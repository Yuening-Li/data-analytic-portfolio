package com.mySpringApp.DistrictGeneration.model;

import java.util.ArrayList;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

@Entity
@Table(name = "Admin")
public class Admin extends User{
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	@Column(name = "id")
	public Integer id;

	@Column(name="username")
	public String username;

	@Column(name="pass_word")
	public String password;
	


	@Transient
	private ArrayList<RegisteredUser> users;
	
	
	public void addUser(RegisteredUser user) {
		users.add(user);
	}
	
	public void removeUser(RegisteredUser user) {
		users.remove(user);
	}
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	
	public void printUsers() {
		for(int i = 0; i<users.size(); i++) {
			System.out.print("Username: " + users.get(i).getUsername());
			System.out.print("Email: " + users.get(i).getEmail());
			System.out.print("Password: " + users.get(i).getPassword());
		}
	}

}
