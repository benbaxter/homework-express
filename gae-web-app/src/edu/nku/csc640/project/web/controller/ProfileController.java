package edu.nku.csc640.project.web.controller;

import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import edu.nku.csc640.project.web.model.User;

@SuppressWarnings("unchecked")
@Controller
public class ProfileController extends BaseController {
	
	@Autowired
	RestTemplate restTemplate;
	
	public ProfileController() {
		super();
	}
	
	@RequestMapping(value="/profile/edit/{id}", method=GET)
	public String edit(Model model, HttpSession session, @PathVariable String id) { 
		
		User user = new User();
		String endpoint = "login/getuser?UserId=" + id;
		List<Object> list = restTemplate.getForObject(BASE_URL + endpoint, List.class);
		
		Map<String, String> s = (Map<String, String>) list.get(0);
		String status = s.get(RESPONSE_STATUS);
		//it was verified, time get the user object
		if( RESPONSE_STATUS_SUCCESS.equalsIgnoreCase(status) ) {
			Map<String, Object> u = (Map<String, Object>) list.get(1);
			user = createUserFromResponse(u);
		}
		
		addProfileMetaData(model, session, user);
		return "profile/edit";
	}
	
	@RequestMapping(value="/profile/edit", method=POST)
	public String edit(Model model, HttpSession session, @ModelAttribute("user") User user) { 
		
		String endpoint = "admin/updateuser";
		Map<String, String> s = restTemplate.postForObject(BASE_URL + endpoint, user, Map.class);
		if( RESPONSE_STATUS_SUCCESS.equalsIgnoreCase(s.get(RESPONSE_STATUS)) ) {
			addProfileMetaData(model, session, user);
			return "profile/view";
		} else {
			model.addAttribute("error", s.get(RESPONSE_REASON));
			addProfileMetaData(model, session, user);
			return "profile/edit";
		}
	}

	private void addProfileMetaData(Model model, HttpSession session, User user) {
		model.addAttribute("navPage", "profile");
		model.addAttribute("user", user);
		addMetaDataToModel(model, session);
	}
}