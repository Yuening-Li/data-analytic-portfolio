package com.mySpringApp.DistrictGeneration.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.mySpringApp.DistrictGeneration.model.Precinct;

@Repository
public interface PrecinctRepository extends CrudRepository<Precinct, String> {

}
