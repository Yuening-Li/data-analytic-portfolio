package com.mySpringApp.DistrictGeneration.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "RegisteredUser")
public class RegisteredUser extends User {
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	@Column(name = "id")
	public Integer id;

	@Column(name="username")
	public String username;
	
	@Column(name="firstname")
	public String firstname;

	@Column(name="lastname")
	public String lastname;

	@Column(name="email")
	public String email;

	@Column(name="pass_word")
	public String password;

	public RegisteredUser() {
		
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

	public String getFirstName() {
		return firstname;
	}

	public void setFirstName(String firstName) {
		this.firstname = firstName;
	}

	public String getLastName() {
		return lastname;
	}

	public void setLastName(String lastName) {
		this.lastname = lastName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	@Override
	public String toString() {
		return "RegisteredUser [username=" + username + ", firstName=" + firstname + ", lastName="
				+ lastname + ", email=" + email + ", password=" + password + "]";
	}
}