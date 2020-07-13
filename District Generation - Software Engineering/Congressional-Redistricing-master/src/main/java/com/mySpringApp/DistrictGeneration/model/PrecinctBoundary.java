package com.mySpringApp.DistrictGeneration.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MapsId;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "PrecinctBoundry")
public class PrecinctBoundary {
	
	@OneToOne
	@JoinColumn(name="precinct_id")
	@MapsId
	public Precinct precinct;
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	@Column(name="precinct_id")
	public String precinct_id;
	
	@Column(name = "boundary")
	private String boundary;

	public String getBoundary() {
		return boundary;
	}

	public void setBoundary(String boundary) {
		this.boundary = boundary;
	}
	
}
