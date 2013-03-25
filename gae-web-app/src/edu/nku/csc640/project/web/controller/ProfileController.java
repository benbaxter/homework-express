package edu.nku.csc640.project.web.controller;

import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import edu.nku.csc640.project.web.model.User;

@Controller
public class ProfileController extends BaseController {
	
	@RequestMapping(value="/profile/edit/{id}", method=GET)
	public String edit(Model model, HttpSession session, @PathVariable String id) { 
		
		model.addAttribute("navPage", "profile");
		model.addAttribute("user", (User) session.getAttribute(SESSION_ATTR_USER));
		addMetaDataToModel(model, session);
		return "profile/edit";
	}
	
	@RequestMapping(value="/profile/edit", method=POST)
	public String edit(Model model, HttpSession session, @ModelAttribute("user") User user) { 
		
		session.setAttribute(SESSION_ATTR_USER, user);
		model.addAttribute(SESSION_ATTR_USER, user);

		
		model.addAttribute("navPage", "profile");
		addMetaDataToModel(model, session);
		return "profile/view";
	}
}