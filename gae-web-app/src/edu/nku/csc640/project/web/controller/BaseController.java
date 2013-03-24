package edu.nku.csc640.project.web.controller;

import javax.servlet.http.HttpSession;

import org.springframework.ui.Model;

import edu.nku.csc640.project.web.model.User;



public abstract class BaseController {
	
	protected static final String SESSION_ATTR_USER = "user";
	
	protected Model addMetaDataToModel(Model model, HttpSession session) {
		User user = (User) session.getAttribute(SESSION_ATTR_USER);
		if( ! isLoggedIn(user) ) {
			model.addAttribute("loginUrl", "/actions/login");
		} else {
			model.addAttribute("username", user.getUsername());
			model.addAttribute("logoutUrl", "/actions/logout");
			model.addAttribute("homeUrl", getHomeUrl(user));
		}
		
		return model;
	}

	protected String getHomeUrl(User user) {
		return "/actions/" + getUserRootUrl(user) + "/home";
	}

	private String getUserRootUrl(User user) {
		switch (user.getRole()) {
		case ADMIN:
			return "admin";
		case INSTRUCTOR:
			return "instructor";
		case STUDENT:
			return "student";
		default:
			return "student";
		}
	}
	
	protected boolean isLoggedIn(User user) {
		//mocking out for now until we have a better 
		//handle on user sessions
		return user != null;
	}
	
}
