package edu.nku.csc640.project.web.controller;

import static org.springframework.util.CollectionUtils.isEmpty;
import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import edu.nku.csc640.project.web.model.Assignment;
import edu.nku.csc640.project.web.model.Course;
import edu.nku.csc640.project.web.model.User;
import edu.nku.csc640.project.web.model.UserRole;

@SuppressWarnings("unchecked")
@Controller
public class AdminController extends BaseController {
	
	@Autowired
	RestTemplate restTemplate;
	
	private static final String root = "/admin";
	
	public AdminController() {
		super();
	}
	
	@RequestMapping(value=root + "/home", method=GET)
	public String goHome(Model model, HttpSession session) { 
		
		model.addAttribute("navPage", "home");
		
		addMetaDataToModel(model, session);
		return "admin/home";
	}
	
	@RequestMapping(value= root + "/courses/add", method=POST)
	public @ResponseBody Map<String, Object> addCourse(Model model, HttpSession session,
			@RequestParam String name, @RequestParam String description,
			@RequestParam long instructorId) { 
		
		String endpoint = BASE_URL + "instructor/addCourse"; 
		Map<String, Object> params = new HashMap<>();
		params.put("name", name);
		params.put("description", description);
		params.put("instructor.userId", instructorId);
		return restTemplate.postForObject(endpoint, params, Map.class);
	}
	
	@RequestMapping(value=root + "/users/create", method=POST)
	public @ResponseBody Map<String, String> createUser(HttpSession session, 
			@RequestParam String username,
			@RequestParam String password,
			@RequestParam String firstname,
			@RequestParam String lastname,
			@RequestParam String role) throws Exception {

		User user = new User();
		user.setFirstName(firstname);
		user.setLastName(lastname);
		user.setPassword(password);
		user.setRole(UserRole.getFromString(role));
		user.setUsername(username);

		String endpoint = BASE_URL + "admin/adduser";
		Map<String, String> s = restTemplate.postForObject(endpoint, user, Map.class);
		return s;
	}
	

	@RequestMapping(value=root + "/instructors", method=GET)
	public @ResponseBody List<Object> getAllInstructors(HttpSession session) throws Exception {
		String endpoint = BASE_URL + "admin/getusers?role=Instructor";
		List<Object> result = restTemplate.getForObject(endpoint, List.class);
		return result;
	}
	
	@RequestMapping(value=root + "/students", method=GET)
	public @ResponseBody List<Object> getAllStudents(HttpSession session) throws Exception {
		String endpoint = BASE_URL + "admin/getusers?role=Student";
		List<Object> result = restTemplate.getForObject(endpoint, List.class);
		return result;
	}
	
	@RequestMapping(value=root + "/admins", method=GET)
	public @ResponseBody List<Object> getAllAdmins(HttpSession session) throws Exception {
		String endpoint = BASE_URL + "admin/getusers?role=Admin";
		List<Object> result = restTemplate.getForObject(endpoint, List.class);
		return result;
	}
	
	@RequestMapping(value=root + "/users/delete/{userId}", method=GET)
	public @ResponseBody Map<String, String> deleteUser(@PathVariable long userId, HttpSession session) {
		
		if( userId == getUser(session).getUserId() ) {
			Map<String, String> result = new HashMap<String, String>();
			result.put(RESPONSE_STATUS, RESPONSE_STATUS_FAILED);
			result.put(RESPONSE_REASON, "Cannot delete yourself.");
			return result;
		} else {
			Map<String, Long> params = new HashMap<String, Long>();
			params.put("UserId", userId);
			String endpoint = BASE_URL + "admin/removeuser";
			Map<String, String> result = restTemplate.postForObject(endpoint, params, Map.class);
			return result;
		}
	}
	
	@RequestMapping(value= root + "/courses", method=GET, produces="application/json")
	public @ResponseBody List<Course> getAllCourses() {
		
		String endpoint = BASE_URL + "admin/getCourses";
		return restTemplate.getForObject(endpoint, List.class);
	}
	
	@RequestMapping(value=root + "/ass/files", method=POST)
	public @ResponseBody List<Object> createAssignment(Assignment assignment, BindingResult result) {

		Map<String, Object> endpointParams = new HashMap<String, Object>();
//		CommonsMultipartFile file = assignment.getFiles().get(0);
//		endpointParams.put("file", file);
		
		String endpoint = BASE_URL + "test";
		List<Object> s = restTemplate.postForObject(endpoint, endpointParams, List.class);
		return s;
	}
}
