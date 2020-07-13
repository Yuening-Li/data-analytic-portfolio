package com.mySpringApp.DistrictGeneration.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Transient;

import com.mySpringApp.DistrictGeneration.utils.MethodFlag;
import com.mySpringApp.DistrictGeneration.utils.Weights;

@Entity
@Table(name = "State")
public class State {

	@Id
	@Column(name = "state_Id")
	public int stateId;

	@Column(name = "short_cut")
	public String abbr;

	@Column(name = "state_name")
	public String name;

	@Column(name = "num_district")
	public int numDistrict;

	@Column(name = "population")
	public int population;

	@OneToMany(mappedBy = "stateId")
	private List<District> districts;

	@Transient
	private double stateScore = 0;

	@Transient
	private double expectedPartisan = 0;
	
	@Transient
	private double expectedPopulation = 0;

	public District selectRandomDistrict() {
		int random = (int) (Math.random() * districts.size());
		return districts.get(random);
	}
	
	public void initState(HashMap<Weights, Double> w) {
		expectedPartisan = calculateExpectedPartisan();
		expectedPopulation = population/numDistrict;
		for (int i = 0; i < districts.size(); i++) {
			District d = districts.get(i);
			d.setExpectedPartisan(expectedPartisan);
			d.setExpectedPopulation(expectedPopulation);
			double something = calculateTotal(w, d.calculateScores());
			d.setScore(something);
			System.out.println(i+1 + ": " + something);
		}
	}
	
	public void resetSAmap(ArrayList<Data> renderSA, HashMap<Weights, Double> w) {
		initState(w);		
	}

	public void resetRAmap(ArrayList<Data> renderRg, MethodFlag methodFlag, 
							ArrayList<Precinct> unassign, HashMap<Weights, Double> w, Map<String, String> formData) {
		for (int i = 0; i < numDistrict; i++) {
			unassign.addAll(districts.get(i).getPrecincts());
		}
		districts.clear();
		int numDis = Integer.parseInt(formData.get("num"));
		setNumDistrict(numDis);
			
		if(methodFlag.equals(MethodFlag.REGRIONGROW_RANDOM)) {
			
			for (int i = 1; i <= numDistrict; i++) {
				int random = (int) (Math.random() * unassign.size());
				Precinct p = unassign.remove(random);
				ArrayList<Precinct> precincts = new ArrayList<Precinct>();
				precincts.add(p);
				Random r = new Random();
				String color = generateColor(r);
				District d = new District(this, i, p.getPopulation(), p.getRepublican(), p.getDemocratic(),
						p.getGeometry(), precincts, precincts, color);
				districts.add(d);
				
				Data data = new Data();
				data.setPrecinctId(p.getPrecinctId());
				data.setColor(color);
				data.setDistrictId(i);
				data.setStrokeWeight(0.3);
				renderRg.add(data);
			}
		}
		else {
			for (int i = 1; i <= numDistrict; i++) {
				Precinct p = null;
				boolean found = false;
				while(!found) {
					int random = (int) (Math.random() * unassign.size());
					p = unassign.remove(random);
					
					if(districts.size() == 0) {
						break;
					}
					for(int j = 0; j < districts.size(); j++) {
						District d = districts.get(j);
						//System.out.println(d.getBoundary());
						//System.out.println(p.getBoundary());
						if(d.getGeometry().distance(p.getGeometry()) < 1.5) {
							unassign.add(p);
							found = false;
							break;
						}
						else {
							found = true;
						}
					}					
				}
				
				ArrayList<Precinct> precincts = new ArrayList<Precinct>();
				precincts.add(p);
				Random r = new Random();
				String color = generateColor(r);
				District d = new District(this, i, p.getPopulation(), p.getRepublican(), p.getDemocratic(),
						p.getGeometry(), precincts, precincts, color);
				districts.add(d);

				Data data = new Data();
				data.setPrecinctId(p.getPrecinctId());
				data.setColor(color);
				data.setDistrictId(i);
				data.setStrokeWeight(0.3);
				renderRg.add(data);
			}
		}
		initDistricts(numDis, w);	
	}

	private void initDistricts(int number, HashMap<Weights, Double> w) {
		//initialized attributes of new districts.
		for (int i = 0; i < numDistrict; i++) {
			District d = districts.get(i);
			
			// set expect population
			expectedPopulation = population / number;
			d.setExpectedPopulation(expectedPopulation);
			
			expectedPartisan = calculateExpectedPartisan();
			d.setExpectedPartisan(expectedPartisan);
			
			//initialize scores
			d.setScoreList(d.calculateScores());
			d.setScore(calculateTotal(w, d.getScoreList()));		
		}
	}
	
	public double calculateExpectedPartisan() {
		double rep = 0;
		double dem = 0;
		for (int i = 0; i < districts.size(); i++) {
			rep += districts.get(i).getRepublican();
			dem += districts.get(i).getDemocratic();
		}
		return rep/dem;
		
	}

	public District selectWorstDistrict() {
//		District worst = districts.get(0);
//		for (int i = 1; i < districts.size(); i++) {
//			if (districts.get(i).getScore() < worst.getScore()) {
//				worst = districts.get(i);
//			}
//		}
//		return worst;
		int random = (int) (Math.random() * districts.size());
		return districts.get(random);
	}
	
	public double calculateStateScore() {
		double sum = 0;
		for (int i = 0; i < districts.size(); i++) {
			sum += districts.get(i).getScore();
		}
		return sum/districts.size();
	}
	
	public double calculateTotal(HashMap<Weights, Double> w, HashMap<Weights, Double> scoreList) {
		return (w.get(Weights.POPULATION) * scoreList.get(Weights.POPULATION) 
				+ w.get(Weights.COMPACTNESS) * scoreList.get(Weights.COMPACTNESS) 
				+ w.get(Weights.PARTISIAN_FAIRNESS) * scoreList.get(Weights.PARTISIAN_FAIRNESS) 
				+ w.get(Weights.EFFICIENCY_GAP) * scoreList.get(Weights.EFFICIENCY_GAP));
	}

	public boolean finalizeMove(Precinct p, District d1, District d2, HashMap<Weights, Double> w) {
		move(p, d1, d2);
		
		HashMap<Weights, Double> score1 = d1.calculateScores();
		HashMap<Weights, Double> score2 = d2.calculateScores();
		
		double newScoreD1 = calculateTotal(w, score1);
		double newScoreD2 = calculateTotal(w, score2);
		
		if (newScoreD1 - d1.getScore() < 0 && Math.random()>0.95) {
			move(p, d2, d1);
			return false;
		} else {
			d1.setScoreList(score1);
			d1.setScore(newScoreD1);
			d2.setScoreList(score2);
			d2.setScore(newScoreD2);
			return true;
		}
	}

	public boolean finalizeGrow(Precinct p, District d, HashMap<Weights, Double> w) {
		if(p == null) {
			return false;
		}
		grow(p, d);
		boolean isSatisfy = ifSatisfyConstraint(d);
		double newScore = calculateTotal(w, d.calculateScores());
		//System.out.println("new score: " + newScore + "\n");
		if (( (newScore < d.getScore() && Math.random() > 0.5)) || (isSatisfy && Math.random() > 0.5) ) {
			revertGrow(p, d);
			return false;
		} else {
			d.setScore(newScore);
			return true;
		}
	}


	public void move(Precinct p, District d1, District d2) {

		// update d1
		
		d1.setPopulation(d1.getPopulation() - p.getPopulation());
		d1.setDemocratic(d1.getDemocratic() - p.getDemocratic());
		d1.setRepublican(d1.getRepublican() - p.getRepublican());
		if(p.getGeometry().isValid() && p.getGeometry().isValid())
			d1.setGeometry(d1.getGeometry().norm().difference(p.getGeometry().norm()));
		d1.deleteBorder(p);
		d1.getPrecincts().remove(p);

		// updates d2
		d2.setPopulation(d2.getPopulation() + p.getPopulation());
		d2.setDemocratic(d2.getDemocratic() + p.getDemocratic());
		d2.setRepublican(d2.getRepublican() + p.getRepublican());
		if(p.getGeometry().isValid() && p.getGeometry().isValid())
			d2.setGeometry(d2.getGeometry().norm().union(p.getGeometry().norm()));

		d2.addBorder(p);
		d2.getPrecincts().add(p);
	}

	public void grow(Precinct p, District d) {
		d.setPopulation(d.getPopulation() + p.getPopulation());
		d.setDemocratic(d.getDemocratic() + p.getDemocratic());
		d.setRepublican(d.getRepublican() + p.getRepublican());
		if(p.getGeometry().isValid() && p.getGeometry().isValid())
			d.setGeometry(d.getGeometry().norm().union(p.getGeometry().norm()));
		d.addBorder(p);
		d.getPrecincts().add(p);
		p.setDistrictId(d);
	}

	public void revertGrow(Precinct p, District d) {
		d.setPopulation(d.getPopulation() - p.getPopulation());
		d.setDemocratic(d.getDemocratic() - p.getDemocratic());
		d.setRepublican(d.getRepublican() - p.getRepublican());
		if(p.getGeometry().isValid() && p.getGeometry().isValid())
			d.setGeometry(d.getGeometry().norm().difference(p.getGeometry().norm()));
		d.deleteBorder(p);
		d.getPrecincts().remove(p);
		p.setDistrictId(d);
	}
	
	public int getNumPrecincts() {
		int totalPrecinct = 0;
		for(int i = 0; i<numDistrict; i++) {
			totalPrecinct += districts.get(i).getPrecincts().size();
		}
		return totalPrecinct;
	}


	public int getStateId() {
		return stateId;
	}

	public void setStateId(int stateId) {
		this.stateId = stateId;
	}

	public String getAbbr() {
		return abbr;
	}

	public void setAbbr(String abbr) {
		this.abbr = abbr;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getNumDistrict() {
		return numDistrict;
	}

	public void setNumDistrict(int numDistrict) {
		this.numDistrict = numDistrict;
	}

	public int getPopulation() {
		return population;
	}

	public void setPopulation(int population) {
		this.population = population;
	}

	public double getStateScore() {
		return stateScore;
	}

	public void setStateScore(double stateScore) {
		this.stateScore = stateScore;
	}

	public List<District> getDistricts() {
		return districts;
	}

	public void setDistricts(List<District> districts) {
		this.districts = districts;
	}
	
	private static String generateColor(Random r) {
		final char[] hex = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
		char[] s = new char[7];
		int n = r.nextInt(0x1000000);

		s[0] = '#';
		for (int i = 1; i < 7; i++) {
			s[i] = hex[n & 0xf];
			n >>= 4;
		}
		return new String(s);
	}
	

	private boolean ifSatisfyConstraint(District d) {
		
 		double ratio = Math.abs((d.getPopulation() - expectedPopulation)/expectedPopulation);
 		double dev = Math.abs(1-ratio);
		//System.out.println("deviation: " + dev);
		if(dev < 0.65) {
			return true;
		}
		else {
			return false;
		}		
	}

}
