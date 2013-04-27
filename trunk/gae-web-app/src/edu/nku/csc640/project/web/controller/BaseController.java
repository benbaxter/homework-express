package edu.nku.csc640.project.web.controller;

import static org.apache.commons.codec.binary.Base64.encodeBase64;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.ui.Model;

import edu.nku.csc640.project.web.model.User;
import edu.nku.csc640.project.web.model.UserRole;

public abstract class BaseController {
	
	protected static final String BASE_URL = "http://csgcinlt151:5904/api/";
//	protected static final String BASE_URL = "http://www.csc640.com/api/";
	protected static final String RESPONSE_STATUS = "Status";
	protected static final String RESPONSE_REASON = "Reason";
	protected static final String RESPONSE_STATUS_SUCCESS = "Success";
	protected static final String RESPONSE_STATUS_FAILED = "Failure";
	protected static final String RESPONSE_STATUS_EXCEPTION = "Exception";

	protected static final String SESSION_ATTR_USER = "user";

	protected Model addMetaDataToModel(Model model, HttpSession session) {
		User user = (User) session.getAttribute(SESSION_ATTR_USER);
		if( ! isLoggedIn(user) ) {
			model.addAttribute("loginUrl", "/actions/login");
		} else {
			model.addAttribute("logoutUrl", "/actions/logout");
			model.addAttribute("homeUrl", getHomeUrl(user));
			model.addAttribute("basicauthorization", encodeBase64User(user));
		}
		return model;
	}

	protected String getHomeUrl(User user) {
		return "/actions/" + user.getRootUrl(user) + "/home";
	}
	
	protected boolean isLoggedIn(User user) {
		//mocking out for now until we have a better 
		//handle on user sessions
		return user != null;
	}
	
	protected String encodeBase64User(HttpSession session) {
		User user = (User) session.getAttribute(SESSION_ATTR_USER);
		return encodeBase64User(user);
	}
	
	protected String encodeBase64User(User user) {
		String basicAuth = user.getUsername() + ":" + user.getPassword();
		return encodeBase64String(basicAuth);
	}
	
	protected String encodeBase64String(String string) {
		byte[] bytes = encodeBase64(string.getBytes());
		String s = new String(bytes);
		return s;
	}
	
	protected User createUserFromResponse(Map<String, Object> map) {
		User user = new User();
		user.setUserId((int) map.get("UserId"));
		user.setFirstName((String) map.get("FirstName"));
		user.setLastName((String) map.get("LastName"));
		user.setRole(UserRole.getFromString((String) map.get("Role")));
		user.setUsername((String) map.get("UserName"));
		return user;
	}
}