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
	
	public AdminController() {
		super();
	}
	
	@RequestMapping(value="/admin/home", method=GET)
	public String goHome(Model model, HttpSession session) { 
		
		model.addAttribute("navPage", "home");
		
		addMetaDataToModel(model, session);
		return "admin/home";
	}
	
	@RequestMapping(value="/admin/courses/create", method=POST)
	public @ResponseBody Map<String, String> createCourses(
			@RequestParam String name,
			@RequestParam String description,
			@RequestParam String instructorName,
			HttpSession session) throws Exception {


//		String basicAuth = encodeBase64User(session);
//		MultiValueMap<String, String> headers = new HttpHeaders();
//		headers.set("Authorization", "Basic " + basicAuth);
//		restTemplate.exchange(BASE_URL, HttpMethod.POST, new HttpEntity<String>(headers), Map.class);
		
		Course course = new Course();
		course.setName(name);
		course.setDescription(description);
		User instructor = new User();
		course.setInstructor(instructor);
		
		course.setStudents(new ArrayList<User>());
		
		
		String endpoint = BASE_URL + "AddCourse";
		Map<String, String> s = restTemplate.postForObject(endpoint, course, Map.class);
		return s;
	}
	
	@RequestMapping(value="/admin/users/create", method=POST)
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
	

	@RequestMapping(value="/admin/instructors", method=GET)
	public @ResponseBody List<Object> getAllInstructors(HttpSession session) throws Exception {
		String endpoint = BASE_URL + "admin/getusers?role=Instructor";
		List<Object> result = restTemplate.getForObject(endpoint, List.class);
		return result;
	}
	
	@RequestMapping(value="/admin/students", method=GET)
	public @ResponseBody List<Object> getAllStudents(HttpSession session) throws Exception {
		String endpoint = BASE_URL + "admin/getusers?role=Student";
		List<Object> result = restTemplate.getForObject(endpoint, List.class);
		return result;
	}
	
	@RequestMapping(value="/admin/admins", method=GET)
	public @ResponseBody List<Object> getAllAdmins(HttpSession session) throws Exception {
		String endpoint = BASE_URL + "admin/getusers?role=Admin";
		List<Object> result = restTemplate.getForObject(endpoint, List.class);
		return result;
	}
	
	@RequestMapping(value="/admin/users/delete/{userId}", method=GET)
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
	
	@RequestMapping(value="/admin/instructors/names", method=GET)
	public @ResponseBody List<String> getAllInstructorsNames() {
		List<String> users = new ArrayList<String>();
		
		String endpoint = BASE_URL + "GetUsers";
		List<Object> result = restTemplate.getForObject(endpoint, List.class);
		if( ! isEmpty(result) ) {
			Map<String, String> status = (Map<String, String>) result.get(0);
			
			List<Map<String, String>> peeps = (List<Map<String, String>>) result.get(1);
			for (Map<String, String> u : peeps) {
				if( u.containsKey("Role") 
						&& UserRole.Instructor == UserRole.getFromString(u.get("Role")) ) {
					String name = u.get("FirstName") + " " + u.get("LastName");
					users.add(name);
				}
			}
		}
		return users;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/admin/courses", method=GET, produces="application/json")
	public @ResponseBody List<Course> getAllCourses() {
		
		List<Course> courses = new ArrayList<Course>();
		
		String endpoint = BASE_URL + "GetCourses";
		List<Object> result = restTemplate.getForObject(endpoint, List.class);
		if( ! isEmpty(result) ) {
			Map<String, String> status = (Map<String, String>) result.get(0);
			
			List<Map<String, Object>> cs = (List<Map<String, Object>>) result.get(1);
			for (Map<String, Object> c : cs) {
				Course course = new Course();
				course.setName((String)c.get("Name"));
				course.setDescription((String)c.get("Description"));
				
				Map<String, String> i = (Map<String,String>)c.get("Instructor");
				User instructor = new User();
				course.setInstructor(instructor);
				
				List<User> students = new ArrayList<>();
				List<Map<String,String>> ss = (List<Map<String,String>>) c.get("Users");
				for (Map<String, String> s : ss) {
					User student = new User();
					student.setFirstName(s.get("FirstName"));
					student.setLastName(s.get("LastName"));
					student.setUsername(s.get("Username"));
					student.setPassword(s.get("Password"));
					student.setRole(UserRole.getFromString(s.get("Role")));
					students.add(student);
				}
				course.setStudents(students);
				
				courses.add(course);
			}
		}
		return courses;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/admin/ass/files", method=POST)
	public @ResponseBody List<Object> createAssignment(Assignment assignment, BindingResult result) {

		Map<String, Object> endpointParams = new HashMap<String, Object>();
//		CommonsMultipartFile file = assignment.getFiles().get(0);
//		endpointParams.put("file", file);
		
		String endpoint = BASE_URL + "test";
		List<Object> s = restTemplate.postForObject(endpoint, endpointParams, List.class);
		return s;
	}
}
