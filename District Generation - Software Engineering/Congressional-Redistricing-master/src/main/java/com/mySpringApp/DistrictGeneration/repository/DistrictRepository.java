package com.mySpringApp.DistrictGeneration.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.mySpringApp.DistrictGeneration.model.District;

@Repository
public interface DistrictRepository extends CrudRepository<District, Integer> {

}
