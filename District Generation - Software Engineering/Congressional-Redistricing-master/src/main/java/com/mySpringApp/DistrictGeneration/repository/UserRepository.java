package com.mySpringApp.DistrictGeneration.repository;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.transaction.annotation.Transactional;

import com.mySpringApp.DistrictGeneration.model.RegisteredUser;

public interface UserRepository extends CrudRepository<RegisteredUser, String> {
	@Query(value ="SELECT * FROM RegisteredUser",nativeQuery=true)
	public Iterable<RegisteredUser> findAll();
	
	public RegisteredUser findById(int id);
	
	@Transactional
	public void deleteById(int id);
	
	@Transactional
	public RegisteredUser findByUsername(String username);

}
