package edu.nku.csc640.project.web.controller;

import static org.springframework.web.bind.annotation.RequestMethod.GET;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class StaticContentController extends BaseController {
	
	@RequestMapping(value= {"/you-suck"}, method=GET)
	public String unauthed(Model model, HttpSession session) { 
		
		addMetaDataToModel(model, session);
		return "common/unauthed";
	}
}