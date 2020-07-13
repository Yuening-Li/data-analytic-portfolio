package com.mySpringApp.DistrictGeneration.controller;

import java.util.ArrayList;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import com.mySpringApp.DistrictGeneration.model.Data;
import com.mySpringApp.DistrictGeneration.model.District;
import com.mySpringApp.DistrictGeneration.model.Legend;
import com.mySpringApp.DistrictGeneration.model.Precinct;
import com.mySpringApp.DistrictGeneration.model.State;
import com.mySpringApp.DistrictGeneration.repository.DistrictRepository;
import com.mySpringApp.DistrictGeneration.repository.PrecinctRepository;
import com.mySpringApp.DistrictGeneration.repository.StateRepository;
import com.mySpringApp.DistrictGeneration.service.Algorithm;
import com.mySpringApp.DistrictGeneration.utils.MethodFlag;

@RestController
public class DistrictGenerationRestController {

	@Autowired
	public StateRepository stateRepo;
	@Autowired
	public PrecinctRepository precinctRepo;
	@Autowired
	public DistrictRepository districtRepo;
	
	Algorithm algorithm;

	State state;
	ArrayList<Data> renderSa = new ArrayList<Data>();
	ArrayList<Data> renderRg = new ArrayList<Data>();
	ArrayList<Data> SAData = new ArrayList<Data>();
	ArrayList<Data> RGData = new ArrayList<Data>();

	ArrayList<String> IW = new ArrayList<String>();
	ArrayList<String> CO = new ArrayList<String>();
	ArrayList<String> AZ = new ArrayList<String>();
	Legend legend = new Legend();

	boolean isTerminated = false;
	boolean pause = false;

	@PostMapping("/run")
	public String run(@RequestBody Map<String, String> formData) {

		int stateId = Integer.parseInt(formData.get("id"));
		state = stateRepo.findById(stateId);
		ArrayList<Precinct> unassign = new ArrayList<Precinct>();
		
		algorithm = new Algorithm(state);
		algorithm.initAlgo(formData);
		

		if (algorithm.methodFlag.equals(MethodFlag.SIMULATEDANNEALING_RANDOM)
			|| algorithm.methodFlag.equals(MethodFlag.SIMULATEDANNEALING_WORST)) {	
			state.resetSAmap(renderSa, algorithm.getWeights());	
			if(stateId == 19){
				IW.add("#8da0cb");
				IW.add("#e78ac3");
				IW.add("#fc8d62");
				IW.add("#66c2a5");
				for(int i = 0; i < state.getNumDistrict(); i++){
					District d = state.getDistricts().get(i);
					d.setColor(IW.get(i));
				}
			}
			else if(stateId == 8){
				CO.add("#b3de69");
				CO.add("#fdb462");
				CO.add("#80b1d3");
				CO.add("#fb8072");
				CO.add("#bebada");
				CO.add("#ffffb3");
				CO.add("#8dd3c7");
				for(int i = 0; i < state.getNumDistrict(); i++){
					District d = state.getDistricts().get(i);
					d.setColor(CO.get(i));
				}
			}
			else if(stateId == 4){
				AZ.add("#3288bd");
				AZ.add("#66c2a5");
				AZ.add("#abdda4");
				AZ.add("#e6f598");
				AZ.add("#ffffbf");
				AZ.add("#fee08b");
				AZ.add("#fdae61");
				AZ.add("#f46d43");
				AZ.add("#d53e4f");
				for(int i = 0; i < state.getNumDistrict(); i++){
					District d = state.getDistricts().get(i);
					d.setColor(AZ.get(i));
				}
			}
		} 
		else {
			state.resetRAmap(renderRg, algorithm.methodFlag, unassign, algorithm.getWeights(), formData);
		}
		//END OF INITIALIZE===============================================================
			
		
		if (algorithm.methodFlag.equals(MethodFlag.SIMULATEDANNEALING_RANDOM)
			|| algorithm.methodFlag.equals(MethodFlag.SIMULATEDANNEALING_WORST)) {
			pause = false;
			isTerminated = false;
			int count = 0;
			int countLim = state.getNumPrecincts()/state.getNumDistrict();
			//System.out.println(countLim);
			double oldStateScore = state.calculateStateScore();
			double newStateScore = state.calculateStateScore();
			
			while (!isTerminated) {
				while (!pause) {
					
//					System.out.println("oldStateScore: " + oldStateScore);
//					System.out.println("newStateScore: " + newStateScore);
					
					District d1;
					if (algorithm.methodFlag.equals(MethodFlag.SIMULATEDANNEALING_RANDOM)) {
						d1 = state.selectRandomDistrict();
					} else {
						d1 = state.selectWorstDistrict();
					}
					
					Precinct p = d1.findMovablePrecinct();
					District d2 = d1.selectNeighborDistrict(p);

					boolean hasMoved = state.finalizeMove(p, d1, d2, algorithm.weights);
					if (hasMoved) {
						
						newStateScore = state.calculateStateScore();
						String message = "move precinct " + p.getPrecinctId() + " from district " + d1.getDistrictId() 
									+ " to district " + d2.getDistrictId() + "\n";
						
						//prepare data for info
						Data data = new Data();
						data.setPrecinctId(p.getPrecinctId());
						data.setColor(d2.getColor());
						data.setDistrictId(d2.districtId-4);
						data.setMsg(message);
						SAData.add(data);
						
						//prepare data for legend
						ArrayList<Integer> population = new ArrayList <Integer>();
						ArrayList<Double> score = new ArrayList <Double>();
						for (int i = 0; i < state.getNumDistrict(); i++) {
							District d = state.getDistricts().get(i);
							population.add(d.getPopulation());
							score.add(Math.round(d.getScore() * 1000D)/1000D);
							legend.setPopulations(population);
							legend.setScores(score);
						}
						//System.out.println("oldStateScore: " + oldStateScore);
						//System.out.println("newStateScore: " + newStateScore);
						
						
					}
					if (newStateScore - oldStateScore >= 0.05) {
						oldStateScore = newStateScore;
						count = 0;
					} 
					else {
						count++;
					}
					System.out.println("count: " + count + "\n");

					if (count >= countLim) {
						isTerminated = true;
						pause = true;
						break;
					}
				} // pause
				System.out.println("pausing");
			} 
		} // end sa

		// doing rg
		else {
			pause = false;
			isTerminated = false;
			int n = 0;
			
			int failMoves = 0;
			int maxFailMove = 20000;
		
			while (!isTerminated) {
				while (!pause) {
					if(failMoves > maxFailMove){
						break;
					}
					int curr = n % state.getNumDistrict();
					District d = state.getDistricts().get(curr);
					Precinct p = d.findGrowablePrecinct(unassign);
					
					if(p == null) {
						failMoves++;						
					}
					else {
						boolean hasMoved = state.finalizeGrow(p, d, algorithm.weights);
						if(hasMoved) {
							unassign.remove(p);
							String message = "add precinct " + p.getPrecinctId() + " to district " + d.getDistrictId() +  "\n";
							//prepare data for info
							Data data = new Data();
							data.setPrecinctId(p.getPrecinctId());
							data.setDistrictId(d.districtId);
							data.setColor(d.getColor());
							data.setMsg(message);
							RGData.add(data);
							
							//prepare data for legend
							ArrayList<Integer> population = new ArrayList <Integer>();
							ArrayList<Double> score = new ArrayList <Double>();
							for (int j = 0; j < state.getNumDistrict(); j++) {
								District district = state.getDistricts().get(j);
								population.add(district.getPopulation());
								score.add(Math.round(district.getScore() * 1000D)/1000D);
								legend.setPopulations(population);
								legend.setScores(score);
							}
						}						
					}
					n++;					
					//end condition
					if (unassign.isEmpty()) {
						pause = true;
						isTerminated = true;
					}
				} // end pause
				System.out.println("pausing");
				if(failMoves > maxFailMove){
					
					System.out.println("size " + unassign.size());
					/*
					for(Precinct precinct : unassign){
						System.out.println(precinct.getPrecinctId());
					}
					*/
					for(Precinct precinct : unassign){
						//unassign.remove(precinct);
						System.out.println(precinct.getPrecinctId());
						Precinct neighbor = precinct.getNeighborPrecincts().get(0);
			            District district = neighbor.getDistrictId();
			            
			            System.out.println("before: " + district.districtId);
			            /*
			            if(district.getDistrictId() > 4 && district.getDistrictId() <= 11){
			            	district.setDistrictId(district.districtId - 4);
			            }
			            else if(district.getDistrictId() > 11 && district.getDistrictId() <= 20){
			            	district.setDistrictId(district.districtId - 11);
			            }
			            System.out.println("after: " + district.districtId);
			            */
			            //District di = state.getDistricts().get(district.getDistrictId());
			            
			            System.out.println("id: " + district.getDistrictId());
			            System.out.println("color: " + district.getColor());
			            state.grow(precinct, district);
						
						String message = "add precinct " + precinct.getPrecinctId() + " to district " + district.getDistrictId() +  "\n";
						//prepare data for info
						Data data = new Data();
						data.setPrecinctId(precinct.getPrecinctId());
						data.setDistrictId(district.districtId);
						data.setColor(district.getColor());
						data.setMsg(message);
						RGData.add(data);
						
						//prepare data for legend
						ArrayList<Integer> population = new ArrayList <Integer>();
						ArrayList<Double> score = new ArrayList <Double>();
						for (int j = 0; j < state.getNumDistrict(); j++) {
							District dis = state.getDistricts().get(j);
							population.add(dis.getPopulation());
							score.add(dis.getScore());
							legend.setPopulations(population);
							legend.setScores(score);
						}											
					}
					
					isTerminated = true;
					System.out.println("size " + unassign.size());
				}
			} // end terminated
		}
		return "finish running";
	}

	@GetMapping("/renderSa")
	public ArrayList<Data> renderSa() {
		if (!renderSa.isEmpty()) {
			ArrayList<Data> result = new ArrayList<Data>();
			for (int i = 0; i < renderSa.size(); i++) {
				result.add(renderSa.get(i));
			}
			renderSa.clear();
			return result;
		} else {
			return renderSa;
		}
	}

	@GetMapping("/renderRg")
	public ArrayList<Data> renderRg() {
		if (!renderRg.isEmpty()) {
			ArrayList<Data> result = new ArrayList<Data>();
			for (int i = 0; i < renderRg.size(); i++) {
				result.add(renderRg.get(i));
			}
			renderRg.clear();
			return result;
		} else {
			return renderRg;
		}
	}

	@GetMapping("/listenOnSa")
	public ArrayList<Data> listenOnSa() {
		ArrayList<Data> result = new ArrayList<Data>();
		for (int i = 0; i < SAData.size(); i++) {
			result.add(SAData.get(i));
		}
		SAData.clear();
		return result;
	}

	@GetMapping("/listenOnRg")
	public ArrayList<Data> listenOnRg() {
		ArrayList<Data> result = new ArrayList<Data>();
		for (int i = 0; i < RGData.size(); i++) {
			result.add(RGData.get(i));
		}
		RGData.clear();
		return result;
	}

	@GetMapping("/update")
	public Legend update() {
		return legend;
	}

	@GetMapping("/pause")
	public String pause() {
		pause = true;
		return "in pause";
	}

	@GetMapping("/resume")
	public String resume() {
		pause = false;
		return "in resume";
	}

	@GetMapping("/stop")
	public String stop() {
		isTerminated = true;
		pause = true;
		return "in stop";
	}
}
