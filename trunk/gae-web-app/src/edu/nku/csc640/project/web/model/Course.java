package edu.nku.csc640.project.web.model;

import java.io.Serializable;

public class Course implements Serializable {
	
	private static final long serialVersionUID = 1L;

	String name;
	String description;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
}
