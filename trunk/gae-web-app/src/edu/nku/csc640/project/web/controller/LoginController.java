package edu.nku.csc640.project.web.controller;

import static edu.nku.csc640.project.web.model.UserRole.ADMIN;
import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import edu.nku.csc640.project.web.model.User;


@Controller
public class LoginController extends BaseController {
	
	@Autowired
	AdminController adminController;
	
	@RequestMapping(value= {"/login", "/home"}, method=GET)
	public String login(Model model, HttpSession session) { 
		
		addMetaDataToModel(model, session);
		
		User user = (User) session.getAttribute(SESSION_ATTR_USER);
		if( isLoggedIn(user) ) {
			return goHome(user, model, session);
		} else {
			return "common/login";
		}
	}
	
	@RequestMapping(value="/login", method=POST)
	public String submitLogin(Model model, @ModelAttribute("user") User user,
			HttpSession session) {
		
		user.setRole(ADMIN);
		session.setAttribute(SESSION_ATTR_USER, user);
		model.addAttribute(SESSION_ATTR_USER, user);
		addMetaDataToModel(model, session);
		return goHome(user, model, session);
	}
	
	@RequestMapping(value="/logout", method=GET)
	public String logout(Model model, HttpSession session) {
		
		session.removeAttribute(SESSION_ATTR_USER);
		model.addAttribute(SESSION_ATTR_USER, null);
		return login(model, session);
	}	
	
	//TODO: once we build the other controllers, we need to update this method
	protected String goHome(User user, Model model, HttpSession session) {
		switch (user.getRole()) {
		case ADMIN:
			return adminController.goHome(model, session);
		case INSTRUCTOR:
			return adminController.goHome(model, session);
		case STUDENT:
			return adminController.goHome(model, session);
		default:
			return adminController.goHome(model, session);
		}
	}
}