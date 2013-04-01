package edu.nku.csc640.project.web.controller;

import static org.springframework.util.StringUtils.hasText;
import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import edu.nku.csc640.project.web.model.Course;
import edu.nku.csc640.project.web.model.User;


@Controller
public class AdminController extends BaseController {
	
	List<Course> courses;
	
	public AdminController() {
		courses = new ArrayList<>();
		setupCourses();
	}

	@RequestMapping(value="/admin/home", method=GET)
	public String goHome(Model model, HttpSession session) { 
		
		model.addAttribute("navPage", "home");
		
		addMetaDataToModel(model, session);
		return "admin/home";
	}
	
	@RequestMapping(value="/admin/instructors", method=GET)
	public @ResponseBody List<User> getAllInstructors() {
		List<User> users = new ArrayList<User>();
		
		User instructor1 = new User();
		instructor1.setName("Dr. Kevorkian");
		users.add(instructor1);

		User instructor2 = new User();
		instructor2.setName("Dr. Pepper");
		users.add(instructor1);
		
		return users;
	}
	
	@RequestMapping(value="/admin/instructors/names", method=GET)
	public @ResponseBody List<String> getAllInstructorsNames() {
		List<String> users = new ArrayList<String>();
		users.add("Dr. Kevorkian");
		users.add("Dr. Pepper");
		
		return users;
	}
	
	@RequestMapping(value="/admin/courses", method=GET)
	public @ResponseBody List<Course> getAllCourses() {
		return courses;
	}

	@RequestMapping(value="/admin/courses/create", method=POST)
	public @ResponseBody Map<String, Object> createCourses(HttpServletRequest r) {
		
		String name = r.getParameter("name");
		String description = r.getParameter("description");
		String instructorName = r.getParameter("instructorName");
		Map<String, Object> m = new HashMap<>();
		if( hasText(name) ) {
			Course c = new Course();
			c.setName(name);
			c.setDescription(description);
			User u = new User();
			u.setName(instructorName);
			c.setInstructor(u);
			courses.add(c);
			m.put("status", "success");
		} else {
			m.put("status", "notsuccess");
		}
		return m;
	}
	
	private void setupCourses() {
		User instructor1 = new User();
		instructor1.setName("Dr. Kevorkian");
		User instructor2 = new User();
		instructor2.setName("Dr. Pepper");
		
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