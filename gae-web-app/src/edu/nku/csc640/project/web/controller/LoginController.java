package edu.nku.csc640.project.web.controller;

import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import edu.nku.csc640.project.web.model.User;

@SuppressWarnings("unchecked")
@Controller
public class LoginController extends BaseController {
	
	@Autowired
	HomeControllerFactory homeControllerFactory;
	
	@Autowired
	RestTemplate restTemplate;
	
	@RequestMapping(value= {"/login", "/home", "/"}, method=GET)
	public String login(Model model, HttpSession session) { 
		
		addMetaDataToModel(model, session);
		
		User user = (User) session.getAttribute(SESSION_ATTR_USER);
		if( isLoggedIn(user) ) {
			return goHome(user, model, session);
		} else {
			model.addAttribute("user", new User());
			return "common/login";
		}
	}
	
	@RequestMapping(value="/login", method=POST)
	public String submitLogin(Model model, @ModelAttribute("user") User user,
			HttpSession session, HttpServletResponse response) {
		
		Map<String, String> params = new HashMap<String, String>();
		params.put("username", user.getUsername());
		params.put("password", user.getPassword());
		
		String endpoint = "login/verify";
		List<Object> list = restTemplate.postForObject(BASE_URL + endpoint, params, List.class);
		
		Map<String, String> s = (Map<String, String>) list.get(0);
		String status = s.get(RESPONSE_STATUS);
		//it was verified, time get the user object
		if( RESPONSE_STATUS_SUCCESS.equalsIgnoreCase(status) ) {
			Map<String, Object> u = (Map<String, Object>) list.get(1);
			//not getting password back from service
			String password = user.getPassword();
			
			user = createUserFromResponse(u);
			
			user.setPassword(password);
			
			Cookie userCookie = new Cookie("username", user.getUsername());
			Cookie passCookie = new Cookie("password", user.getPassword());
		
			response.addCookie(passCookie);
			response.addCookie(userCookie);
			
			session.setAttribute(SESSION_ATTR_USER, user);
			model.addAttribute(SESSION_ATTR_USER, user);
			addMetaDataToModel(model, session);
			return goHome(user, model, session);

		} else {
			model.addAttribute("user", user);
			model.addAttribute("errors", s.get(RESPONSE_REASON));
			addMetaDataToModel(model, session);
			return "common/login";
		}
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