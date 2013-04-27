package edu.nku.csc640.project.web.controller;

import static org.springframework.util.StringUtils.hasText;
import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;
import static org.springframework.util.CollectionUtils.isEmpty;
import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import edu.nku.csc640.project.web.model.Assignment;
import edu.nku.csc640.project.web.model.Course;
import edu.nku.csc640.project.web.model.User;
import edu.nku.csc640.project.web.model.UserRole;

@SuppressWarnings("unchecked")
@Controller
public class AdminController extends BaseController {
	
	List<Course> courses;

	@Autowired
	RestTemplate restTemplate;
	
	public AdminController() {
		courses = new ArrayList<>();
		setupCourses();
	}

	@RequestMapping(value="/admin/home", method=GET)
	public String goHome(Model model, HttpSession session) { 
		
		model.addAttribute("navPage", "home");
		model.addAttribute("sidebar", "courses");
		
		addMetaDataToModel(model, session);
		return "admin/home";
	}
	
	@RequestMapping(value="/admin/users/instructors", method=GET)
	public String goToUsersInstructorsPage(Model model, HttpSession session) { 
		model.addAttribute("navPage", "home");
		model.addAttribute("sidebar", "instructors");
		addMetaDataToModel(model, session);
		return "admin/users";
	}
	
	@RequestMapping(value="/admin/users/students", method=GET)
	public String goToUsersStudentsPage(Model model, HttpSession session) { 
		model.addAttribute("navPage", "home");
		model.addAttribute("sidebar", "students");
		addMetaDataToModel(model, session);
		return "admin/users";
	}
	
	@RequestMapping(value="/admin/users/admins", method=GET)
	public String goToUsersAdminPage(Model model, HttpSession session) { 
		model.addAttribute("navPage", "home");
		model.addAttribute("sidebar", "admin");
		addMetaDataToModel(model, session);
		return "admin/users";
	}
	
	@RequestMapping(value="/admin/ass/submitted", method=GET)
	public String redirectAssignmentFormSubmitted(Model model, HttpSession session,
			@RequestParam String uploaded) { 
		
		model.addAttribute("navPage", "home");
		model.addAttribute("sidebar", "instructors");
		
		model.addAttribute("user", new User());
		addMetaDataToModel(model, session);
		
		if( uploaded.equalsIgnoreCase("1") ) {
			
			return "admin/users";
		}
		return "admin/users";
	}
	
//	@RequestMapping(value="/admin/instructors", method=GET)
//	public @ResponseBody List<User> getAllInstructors() {
//		List<User> users = new ArrayList<User>();
//		
//		User instructor1 = new User();
//		instructor1.setName("Dr. Kevorkian");
//		users.add(instructor1);
//
//		User instructor2 = new User();
//		instructor2.setName("Dr. Pepper");
//		users.add(instructor2);
//		
//		return users;
//	}
	
//	@RequestMapping(value="/admin/instructors/names", method=GET)
//	public @ResponseBody List<String> getAllInstructorsNames() {
//		List<String> users = new ArrayList<String>();
//		users.add("Dr. Kevorkian");
//		users.add("Dr. Pepper");
//		
//		return users;
//	}
	
//	@RequestMapping(value="/admin/courses", method=GET, produces="application/json")
//	public @ResponseBody List<Course> getAllCourses() {
//		return courses;
//	}

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
		instructor.setName(instructorName);
		course.setInstructor(instructor);
		
		course.setStudents(new ArrayList<User>());
		
		
		String endpoint = "AddCourse";
		Map<String, String> s = restTemplate.postForObject(BASE_URL + endpoint, course, Map.class);
		return s;
	}
	

	@SuppressWarnings("unchecked")
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

		String endpoint = "admin/adduser";
		Map<String, String> s = restTemplate.postForObject(BASE_URL + endpoint, 
				user, 
				Map.class);
		return s;
	}
	

	@RequestMapping(value="/admin/instructors", method=GET)
	public @ResponseBody List<Object> getAllInstructors(HttpSession session) throws Exception {
		String endpoint = "admin/getusers?role=Instructor";
		List<Object> result = restTemplate.getForObject(BASE_URL + endpoint, List.class);
		return result;
	}
	
	@RequestMapping(value="/admin/users/delete/{userId}", method=GET)
	public @ResponseBody Map<String, String> deleteUser(@PathVariable long userId) {
		Map<String, Long> params = new HashMap<String, Long>();
		params.put("UserId", userId);
		String endpoint = "admin/removeuser";
		Map<String, String> result = restTemplate.postForObject(BASE_URL + endpoint, params, Map.class);
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/admin/instructors/names", method=GET)
	public @ResponseBody List<String> getAllInstructorsNames() {
		List<String> users = new ArrayList<String>();
		
		String endpoint = "GetUsers";
		List<Object> result = restTemplate.getForObject(BASE_URL + endpoint, List.class);
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
		
		String endpoint = "GetCourses";
		List<Object> result = restTemplate.getForObject(BASE_URL + endpoint, List.class);
		if( ! isEmpty(result) ) {
			Map<String, String> status = (Map<String, String>) result.get(0);
			
			List<Map<String, Object>> cs = (List<Map<String, Object>>) result.get(1);
			for (Map<String, Object> c : cs) {
				Course course = new Course();
				course.setName((String)c.get("Name"));
				course.setDescription((String)c.get("Description"));
				
				Map<String, String> i = (Map<String,String>)c.get("Instructor");
				User instructor = new User();
				instructor.setName(i.get("FirstName") + " " + i.get("LastName"));
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
		CommonsMultipartFile file = assignment.getFiles().get(0);
		endpointParams.put("file", file);
		
		String endpoint = "test";
		List<Object> s = restTemplate.postForObject(BASE_URL + endpoint, endpointParams, List.class);
		return s;
	}

	private void setupCourses() {
		User instructor1 = new User();
//		instructor1.setName("Dr. Kevorkian");
		User instructor2 = new User();
//		instructor2.setName("Dr. Pepper");
		
		Course c1 = new Course();
		c1.setName("INF 101");
		c1.setDescription("This course is awesome");
		c1.setInstructor(instructor1);
		courses.add(c1);
		
		Course c2 = new Course();
		c2.setName("INF 102");
		c2.setDescription("This course is awesome");
		c2.setInstructor(instructor1);
		courses.add(c2);
		
		Course c3 = new Course();
		c3.setName("INF 103");
		c3.setDescription("This course is awesome");
		c3.setInstructor(instructor2);
		courses.add(c3);
		
		Course c4 = new Course();
		c4.setName("INF 104");
		c4.setDescription("This course is awesome");
		c4.setInstructor(instructor2);
		courses.add(c4);
		
		Course c5 = new Course();
		c5.setName("INF 105");
		c5.setDescription("This course is awesome");
		c5.setInstructor(instructor1);
		courses.add(c5);
	}

}
