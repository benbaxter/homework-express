package edu.nku.csc640.project.web.model;

public enum UserRole {

	Admin,
	Instructor,
	Student;
	
	public static UserRole getFromString(String string) {
		for (UserRole role : values()) {
			if( role.toString().equalsIgnoreCase(string) ) {
				return role;
			}
		}
		return null;
	}
	
}
