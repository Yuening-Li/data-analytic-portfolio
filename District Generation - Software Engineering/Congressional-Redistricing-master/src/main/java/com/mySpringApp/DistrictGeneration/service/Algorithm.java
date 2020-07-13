package com.mySpringApp.DistrictGeneration.service;

import java.util.HashMap;
import java.util.Map;

import com.mySpringApp.DistrictGeneration.model.State;
import com.mySpringApp.DistrictGeneration.utils.MethodFlag;
import com.mySpringApp.DistrictGeneration.utils.Weights;

public class Algorithm {
	public State state;
	public HashMap<Weights, Double> weights;
	public MethodFlag methodFlag;

	public Algorithm(State state) {
		this.state = state;
		initializeWeights();
		methodFlag = MethodFlag.SIMULATEDANNEALING_RANDOM;
	}

	public void initializeWeights() {
		weights = new HashMap<Weights, Double>();
		weights.put(Weights.POPULATION, 0.5);
		weights.put(Weights.COMPACTNESS, 0.5);
		weights.put(Weights.EFFICIENCY_GAP, 0.5);
		weights.put(Weights.PARTISIAN_FAIRNESS, 0.5);
	}
	
	public void initAlgo(Map<String, String> data) {
		setMethodFlag(data.get("methodFlag"));
		setWeights(Double.parseDouble(data.get("population")),
				 Double.parseDouble(data.get("compactness")), 
				 Double.parseDouble(data.get("partisian")),
				 Double.parseDouble(data.get("gap")));	
	}


	public State getState() {
		return state;
	}

	public void setState(State state) {
		this.state = state;
	}

	public HashMap<Weights, Double> getWeights() {
		return weights;
	}

	public void setWeights(double popInput, double compInput, 
						   double fairInput, double gapInput) {
		weights.put(Weights.POPULATION, popInput);
		weights.put(Weights.COMPACTNESS, compInput);
		weights.put(Weights.PARTISIAN_FAIRNESS, fairInput);
		weights.put(Weights.EFFICIENCY_GAP, gapInput);
	}

	public MethodFlag getMethodFlag() {
		return methodFlag;
	}

	public void setMethodFlag(String methodFlag) {
		if(methodFlag.equals("Simulated Annealing(Random)")) {
			this.methodFlag = MethodFlag.SIMULATEDANNEALING_RANDOM;
		}
		else if(methodFlag.equals("Simulated Annealing(Worst)")){
			this.methodFlag = MethodFlag.SIMULATEDANNEALING_WORST;
		}
		else if(methodFlag.equals("Region Growth(Random)")) {
			this.methodFlag = MethodFlag.REGRIONGROW_RANDOM;
		}
		else {
			this.methodFlag = MethodFlag.REGIONGROW_MAP;
		}
	}

	@Override
	public String toString() {
		return "Algorithm [state=" + state + ", weights=" + weights + ", method=" + methodFlag + "]";
	}

}
