package edu.nku.csc640.project.web.model;

import java.io.Serializable;
import java.util.List;

import org.springframework.web.multipart.commons.CommonsMultipartFile;

public class Assignment implements Serializable {
	
	private static final long serialVersionUID = 1L;

	String name;
	List<CommonsMultipartFile> files;

	public List<CommonsMultipartFile> getFiles() {
		return files;
	}
	
	public void setFiles(List<CommonsMultipartFile> files) {
		this.files = files;
	}
	
	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
}
