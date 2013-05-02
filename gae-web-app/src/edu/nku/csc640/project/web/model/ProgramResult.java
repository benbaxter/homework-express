package edu.nku.csc640.project.web.model;

import java.io.Serializable;
import java.util.Date;

public class ProgramResult implements Serializable {
	
	private static final long serialVersionUID = 1L;

	String result;
	String message;
	String error;
	Date date;
	String compare;
	
	public String getCompare() {
		return compare;
	}
	public void setCompare(String compare) {
		this.compare = compare;
	}
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getError() {
		return error;
	}
	public void setError(String error) {
		this.error = error;
	}
	public Date getDate() {
		return date;
	}
	public void setDate(Date date) {
		this.date = date;
	}
	
	
}