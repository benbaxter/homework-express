package edu.nku.csc640.project.web.controller;

import static org.springframework.web.bind.annotation.RequestMethod.GET;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import edu.nku.csc640.project.web.model.Course;




@Controller
public class AdminController extends BaseController {
	
	@RequestMapping(value="/admin/home", method=GET)
	public String goHome(Model model, HttpSession session) { 
		
		model.addAttribute("navPage", "home");
		
		addMetaDataToModel(model, session);
		return "admin/home";
	}
	

	@RequestMapping(value="/admin/courses", method=GET)
	public @ResponseBody List<Course> getAllCourses(HttpServletRequest request) { 
		List<Course> courses = new ArrayList<Course>();
		Course c1 = new Course();
		c1.setName("INF 101");
		c1.setDescription("This course is awesome");
		courses.add(c1);
		
		Course c2 = new Course();
		c2.setName("INF 102");
		c2.setDescription("This course is awesome");
		courses.add(c2);
		
		Course c3 = new Course();
		c3.setName("INF 103");
		c3.setDescription("This course is awesome");
		courses.add(c3);
		
		Course c4 = new Course();
		c4.setName("INF 104");
		c4.setDescription("This course is awesome");
		courses.add(c4);
		
		Course c5 = new Course();
		c5.setName("INF 105");
		c5.setDescription("This course is awesome");
		courses.add(c5);
		return courses;
	}
	
}