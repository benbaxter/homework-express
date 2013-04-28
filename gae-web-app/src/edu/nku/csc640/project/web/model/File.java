package edu.nku.csc640.project.web.model;

import java.io.Serializable;
import java.util.Date;

public class File implements Serializable {
	
	private static final long serialVersionUID = 1L;

	int id;
	String name;
	String fileType;
	Date dateSubmitted;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Date getDateSubmitted() {
		return dateSubmitted;
	}
	public void setDateSubmitted(Date dateSubmitted) {
		this.dateSubmitted = dateSubmitted;
	}
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}
}
