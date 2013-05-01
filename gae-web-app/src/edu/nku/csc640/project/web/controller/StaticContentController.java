package edu.nku.csc640.project.web.controller;

import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class StaticContentController extends BaseController {
	
	public StaticContentController() {
		super();
	}
	
	@RequestMapping(value= {"/you-suck"}, method={GET, POST})
	public String unauthed(Model model, HttpSession session) { 
		
		addMetaDataToModel(model, session);
		return "common/unauthed";
	}
	
	@RequestMapping(value= {"/something-bad-happened"}, method={GET, POST})
	public String uhoh(Model model, HttpSession session) { 
		
		addMetaDataToModel(model, session);
		return "common/error";
	}
}