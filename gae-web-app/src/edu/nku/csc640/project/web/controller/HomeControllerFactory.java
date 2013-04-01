package edu.nku.csc640.project.web.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import edu.nku.csc640.project.web.model.User;

@Service
public class HomeControllerFactory {
	
	@Autowired
	AdminController adminController;
	
	@Autowired
	InstructorController instructorController;
	
	@Autowired
	StudentController studentController;
	
	public String goHome(User user, Model model, HttpSession session) {
		switch (user.getRole()) {
		case ADMIN:
			return adminController.goHome(model, session);
		case INSTRUCTOR:
			return instructorController.goHome(model, session);
		case STUDENT:
			return studentController.goHome(model, session);
		default:
			return adminController.goHome(model, session);
		}
	}
}