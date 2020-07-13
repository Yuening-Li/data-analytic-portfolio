package com.mySpringApp.DistrictGeneration.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.mySpringApp.DistrictGeneration.model.Admin;

@Repository
public interface AdminRepository extends CrudRepository<Admin, String> {
	@Transactional
	public Admin findByUsername(String username);
}
