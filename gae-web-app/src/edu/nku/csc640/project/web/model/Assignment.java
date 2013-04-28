package edu.nku.csc640.project.web.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class Assignment implements Serializable {
	
	private static final long serialVersionUID = 1L;

	int id;
	String name;
	List<File> files;
	String description;
	Date dueDate;
	Date finalSubmitDate;
	List<String> fileNames;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public List<File> getFiles() {
		return files;
	}
	
	public void setFiles(List<File> files) {
		this.files = files;
	}
	
	public List<String> getFileNames() {
		return fileNames;
	}
	public void setFileNames(List<String> fileNames) {
		this.fileNames = fileNames;
	}
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
	public Date getDueDate() {
		return dueDate;
	}
	public void setDueDate(Date dueDate) {
		this.dueDate = dueDate;
	}
	public Date getFinalSubmitDate() {
		return finalSubmitDate;
	}
	public void setFinalSubmitDate(Date finalSubmitDate) {
		this.finalSubmitDate = finalSubmitDate;
	}
	
}
