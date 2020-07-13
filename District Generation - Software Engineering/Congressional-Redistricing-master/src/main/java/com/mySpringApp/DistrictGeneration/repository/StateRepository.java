package com.mySpringApp.DistrictGeneration.repository;
 
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.mySpringApp.DistrictGeneration.model.State;

@Repository
public interface StateRepository extends CrudRepository<State, Integer> {
	
	public State findById(int id);

}
