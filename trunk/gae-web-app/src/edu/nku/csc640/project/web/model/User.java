package edu.nku.csc640.project.web.model;

import java.io.Serializable;

public class User implements Serializable {
	
	private static final long serialVersionUID = 1L;

	String Username;
	String Password;
	UserRole Role;
	String FirstName;
	String LastName;

	int userId;
	String name;
	boolean rememberMe;
	
	public String getRootUrl(User user) {
		switch (user.getRole()) {
		case Admin:
			return "admin";
		case Instructor:
			return "instructor";
		case Student:
			return "student";
		default:
			return "student";
		}
	}
	
	public String getUsername() {
		return Username;
	}

	public void setUsername(String username) {
		Username = username;
	}

	public String getPassword() {
		return Password;
	}

	public void setPassword(String password) {
		Password = password;
	}

	public UserRole getRole() {
		return Role;
	}

	public void setRole(UserRole role) {
		Role = role;
	}

	public String getFirstName() {
		return FirstName;
	}

	public void setFirstName(String firstName) {
		FirstName = firstName;
	}

	public String getLastName() {
		return LastName;
	}

	public void setLastName(String lastName) {
		LastName = lastName;
	}

	public boolean isRememberMe() {
		return rememberMe;
	}

	public void setRememberMe(boolean rememberMe) {
		this.rememberMe = rememberMe;
	}

	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	
}
