package edu.nku.csc640.project.web.controller;

import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
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
	HomeControllerFactory homeControllerFactory;
	
	@RequestMapping(value= {"/login", "/home", "/"}, method=GET)
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
			HttpSession session, HttpServletResponse response) {
		
		user.setUserId("0001");
		
		Cookie userCookie = new Cookie("username", user.getUsername());
		Cookie passCookie = new Cookie("password", user.getPassword());
	
		response.addCookie(passCookie);
		response.addCookie(userCookie);
		
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
	
	protected String goHome(User user, Model model, HttpSession session) {
		return homeControllerFactory.goHome(user, model, session);
	}
}