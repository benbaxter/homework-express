package edu.nku.csc640.project.web.controller;

import static org.springframework.util.CollectionUtils.isEmpty;
import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import edu.nku.csc640.project.web.model.Assignment;
import edu.nku.csc640.project.web.model.Course;
import edu.nku.csc640.project.web.model.ProgramResult;
import edu.nku.csc640.project.web.model.User;
import edu.nku.csc640.project.web.model.UserRole;


@SuppressWarnings("unchecked")
@Controller
public class InstructorController extends BaseController {
	
	protected static final String root = "/instructor";
	
	@Autowired
	RestTemplate restTemplate;
	
	
	public InstructorController() {
		super();
	}
	
	@RequestMapping(value={root+"/home", root}, method=GET)
	public String goHome(Model model, HttpSession session) { 
		
		model.addAttribute("navPage", "home");
		model.addAttribute("user", getUser(session));
		addMetaDataToModel(model, session);
		return "instructor/home";
	}
		
	@RequestMapping(value= root + "/{id}/courses", method=GET)
	public @ResponseBody List<Object> getCourses(@PathVariable long id) {
		String endpoint = BASE_URL + "instructor/getcourses?userid=" + id; 
		return restTemplate.getForObject(endpoint, List.class);
	}
	
	@RequestMapping(value= root + "/courses/{id}", method=GET)
	public String getCourse(Model model, HttpSession session, @PathVariable long id) { 
		
		String endpoint = BASE_URL + "instructor/getcourse?courseid=" + id; 
		List<Object> list = restTemplate.getForObject(endpoint, List.class);
		if( ! isEmpty(list) ) {
			Map<String, String> s = (Map<String, String>) list.get(0);
			if( RESPONSE_STATUS_SUCCESS.equalsIgnoreCase(s.get(RESPONSE_STATUS)) ) {
				Course course = createCourseFromResponse((Map<String, Object>) list.get(1));
				model.addAttribute("course", course);
				model.addAttribute("navPage", "home");
				model.addAttribute("user", getUser(session));
				addMetaDataToModel(model, session);
				return "instructor/course";
			} else {
				return goHome(model, session);
			}
		} else {
			return goHome(model, session);
		}
	}
	
	@RequestMapping(value= root + "/course/{courseid}/students", method=GET)
	public @ResponseBody List<Object> getStudentsInCourse(@PathVariable long courseid) { 
		String endpoint = BASE_URL + "instructor/getcourse?courseid=" + courseid; 
		return restTemplate.getForObject(endpoint, List.class);
	}
	
	@RequestMapping(value= root + "/student-names", method=GET)
	public @ResponseBody List<User> getStudentNames() { 
		List<User> users = new ArrayList<User>();
		
		String endpoint = BASE_URL + "admin/getUsers?role=Student";
		List<Object> result = restTemplate.getForObject(endpoint, List.class);
		if( ! isEmpty(result) ) {
			Map<String, String> status = (Map<String, String>) result.get(0);
			List<Map<String, Object>> peeps = (List<Map<String, Object>>) result.get(1);
			for (Map<String, Object> u : peeps) {
				if( u.containsKey("Role") 
						&& UserRole.Student == UserRole.getFromString((String) u.get("Role")) ) {
					User user = createUserFromResponse(u);
					users.add(user);
				}
			}
		}
		return users;
	}
	
	@RequestMapping(value= root + "/course/{courseid}/add/student", method=POST)
	public @ResponseBody Map<String, Object> addStudentToCourse(Model model, HttpSession session,
			@PathVariable long courseid, @RequestParam long studentId) { 
		
		String endpoint = BASE_URL + "instructor/addUserToCourse";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("courseId", courseid);
		params.put("userId", studentId);
		return restTemplate.postForObject(endpoint, params, Map.class);
	}
	
	
	@RequestMapping(value= root + "/course/add", method=POST)
	public @ResponseBody Map<String, Object> addCourse(Model model, HttpSession session,
			@RequestParam String name, @RequestParam String description) { 
		
		User user = getUser(session);
		String endpoint = BASE_URL + "instructor/addCourse"; 
		Map<String, Object> params = new HashMap<>();
		params.put("name", name);
		params.put("description", description);
		params.put("instructor.userId", user.getUserId());
		return restTemplate.postForObject(endpoint, params, Map.class);
	}
	
	@RequestMapping(value= root + "/course/{courseid}/delete", method=GET)
	public @ResponseBody Map<String, String> deleteUser(@PathVariable long courseid, HttpSession session) {
		Map<String, Long> params = new HashMap<String, Long>();
		params.put("courseid", courseid);
		String endpoint = BASE_URL + "instructor/removecourse";
		return restTemplate.postForObject(endpoint, params, Map.class);
	}
	
	@RequestMapping(value= root + "/course/{courseid}/student/{studentid}/delete", method=GET)
	public @ResponseBody Map<String, String> removeStudentFromCourse(
			@PathVariable long courseid,
			@PathVariable long studentid,
			HttpSession session) {
		Map<String, Long> params = new HashMap<String, Long>();
		params.put("courseid", courseid);
		params.put("userid", studentid);
		String endpoint = BASE_URL + "instructor/removeuserfromcourse";
		return restTemplate.postForObject(endpoint, params, Map.class);
	}
	
	@RequestMapping(value= root + "/course/{courseid}/assignment/add", method=POST)
	public @ResponseBody Map<String, Object> addAssignment(
			@PathVariable long courseid,
			@RequestParam String name,
			@RequestParam String description,
			@RequestParam String dueDate,
			@RequestParam String finalDate) { 
		
		String endpoint = BASE_URL + "instructor/addAssignment";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("courseId", courseid);
		params.put("name", name);
		params.put("description", description);
		params.put("dueDate", dueDate);
		params.put("finalSubmitDate", finalDate);
		return restTemplate.postForObject(endpoint, params, Map.class);
	}
	
	@RequestMapping(value= root + "/course/{courseid}/assignment/{assignmentid}/delete", method=GET)
	public @ResponseBody Map<String, String> deleteAssignment(@PathVariable long courseid, 
			@PathVariable long assignmentid) {
		Map<String, Long> params = new HashMap<String, Long>();
		params.put("courseId", courseid);
		params.put("assignmentId", assignmentid);
		String endpoint = BASE_URL + "instructor/removeassignment";
		return restTemplate.postForObject(endpoint, params, Map.class);
	}
	
	@RequestMapping(value= root + "/courses/{courseid}/assignment/{assignmentid}", method=GET)
	public String getAssignment(Model model, HttpSession session,
			@PathVariable long courseid,
			@PathVariable long assignmentid) {
		model.addAttribute("courseid", courseid);
		model.addAttribute("assignmentid", assignmentid);
		String reportUrl = BASE_URL + "instructor/getReport?assignmentid=" + assignmentid;
		model.addAttribute("reportUrl", reportUrl);
		model.addAttribute("navPage", "home");
		model.addAttribute("user", getUser(session));
		addMetaDataToModel(model, session);
		return "instructor/assignment";
	}
	
	@RequestMapping(value= root + "/assignment/{assignmentid}/view", method=GET)
	public @ResponseBody List<Object> getAssignment(@PathVariable long assignmentid, HttpSession session) {
		User user = getUser(session);
		String endpoint = BASE_URL + "instructor/getassignment?&assignmentid="+assignmentid 
				+ "&instructorid=" + user.getUserId();
		return restTemplate.getForObject(endpoint, List.class);
	}
	
	@RequestMapping(value= root + "/assignment/{assignmentid}/student/{studentid}/compile-program", method=GET)
	public @ResponseBody Map<String, Object> compileProgram(HttpSession session,
			@PathVariable long assignmentid,
			@PathVariable long studentid) {
		User user = getUser(session);
		String endpoint = BASE_URL + "student/compile?" +
				"userid=" + studentid + 
				"&assignmentid=" + assignmentid +
				"&initiatedby=" + user.getUserId(); 
		return restTemplate.getForObject(endpoint,  Map.class);
	}
	
	@RequestMapping(value= root + "/assignment/{assignmentid}/student/{studentid}/compile-status", method=GET)
	public @ResponseBody List<Object> getCompileStatus(HttpSession session,
			@PathVariable long assignmentid,
			@PathVariable long studentid) {
		User user = getUser(session);
		String endpoint = BASE_URL + "student/compilestatus?" +
				"userid=" + studentid + 
				"&assignmentid=" + assignmentid +
				"&initiatedby=" + user.getUserId(); 
		return restTemplate.getForObject(endpoint,  List.class);
	}
	
	@RequestMapping(value= root + "/assignment/{assignmentid}/student/{studentid}/compile-result", method=GET)
	public @ResponseBody Map<String, Object> getCompileResult(HttpSession session,
			@PathVariable long assignmentid,
			@PathVariable long studentid) {
		Map<String, Object> map = new HashMap<String, Object>();
		String endpoint = BASE_URL + "student/getcompileresult?" +
				"userid=" + studentid + 
				"&assignmentid=" + assignmentid; 
		List<Object> list = restTemplate.getForObject(endpoint,  List.class);
		if( ! isEmpty(list) ) {
			Map<String, String> s = (Map<String, String>) list.get(0);
			if( RESPONSE_STATUS_SUCCESS.equalsIgnoreCase(s.get(RESPONSE_STATUS)) ) {
				ProgramResult result = createProgramResultFromResponse((Map<String, Object>) list.get(1));
				map.put("result", result);
			} else {
				map.put("failed", s.get(RESPONSE_REASON) ); 
			}
		}
		return map;
	}
	
	@RequestMapping(value= root + "/assignment/{assignmentid}/student/{studentid}/cancel-compile", method=GET)
	public @ResponseBody Map<String, String> cancelCompile(HttpSession session,
			@PathVariable long assignmentid,
			@PathVariable long studentid) {
		User user = getUser(session);
		String endpoint = BASE_URL + "student/cancelcompile?" +
				"userid=" + studentid + 
				"&assignmentid=" + assignmentid +
				"&initiatedby=" + user.getUserId(); 
		return restTemplate.getForObject(endpoint,  Map.class);
	}

	@RequestMapping(value= root + "/assignment/{assignmentid}/student/{studentid}/run-program", method=GET)
	public @ResponseBody Map<String, Object> runProgram(HttpSession session,
			@PathVariable long assignmentid,
			@PathVariable long studentid) {
		User user = getUser(session);
		String endpoint = BASE_URL + "student/test?" +
				"userid=" + studentid + 
				"&assignmentid=" + assignmentid +
				"&initiatedby=" + user.getUserId(); 
		return restTemplate.getForObject(endpoint,  Map.class);
	}
	
	@RequestMapping(value= root + "/assignment/{assignmentid}/student/{studentid}/run-program-status", method=GET)
	public @ResponseBody List<Object> getRunningProgramStatus(HttpSession session,
			@PathVariable long assignmentid,
			@PathVariable long studentid) {
		User user = getUser(session);
		String endpoint = BASE_URL + "student/teststatus?" +
				"userid=" + studentid + 
				"&assignmentid=" + assignmentid +
				"&initiatedby=" + user.getUserId(); 
		return restTemplate.getForObject(endpoint,  List.class);
	}
	
	@RequestMapping(value= root + "/assignment/{assignmentid}/student/{studentid}/run-program-result", method=GET)
	public @ResponseBody Map<String, Object> getRunningProgramResult(HttpSession session,
			@PathVariable long assignmentid,
			@PathVariable long studentid) {
		Map<String, Object> map = new HashMap<String, Object>();
		String endpoint = BASE_URL + "student/gettestresults?" +
				"userid=" + studentid + 
				"&assignmentid=" + assignmentid; 
		List<Object> list = restTemplate.getForObject(endpoint,  List.class);
		if( ! isEmpty(list) ) {
			Map<String, String> s = (Map<String, String>) list.get(0);
			if( RESPONSE_STATUS_SUCCESS.equalsIgnoreCase(s.get(RESPONSE_STATUS)) ) {
				List<ProgramResult> results = convertListOfResults(((List<Map<String, Object>>) list.get(1)));
				map.put("results", results);
			} else {
				map.put("failed", s.get(RESPONSE_REASON) ); 
			}
		}
		return map;
	}
	
	@RequestMapping(value= root + "/assignment/{assignmentid}/student/{studentid}/cancel-program", method=GET)
	public @ResponseBody Map<String, String> cancelRunningProgram(HttpSession session,
			@PathVariable long assignmentid,
			@PathVariable long studentid) {
		User user = getUser(session);
		String endpoint = BASE_URL + "student/canceltest?" +
				"userid=" + studentid + 
				"&assignmentid=" + assignmentid +
				"&initiatedby=" + user.getUserId(); 
		return restTemplate.getForObject(endpoint,  Map.class);
	}
	
	@RequestMapping(value= root + "/course/{courseid}/assignment/{assignmentid}/uploadTestFile", method=GET)
	public String addTest(Model model, HttpSession session,
			@PathVariable long assignmentid,
			@PathVariable long courseid) {
		model.addAttribute("courseid", courseid);
		model.addAttribute("assignmentid", assignmentid);
		model.addAttribute("navPage", "home");
		model.addAttribute("user", getUser(session));
		addMetaDataToModel(model, session);
		return "instructor/test";
	}
	
	@RequestMapping(value= root + "/assignment/{assignmentid}/student/{studentid}/update", method=GET)
	public @ResponseBody Map<String, String> updateStudent(HttpSession session,
			@PathVariable long assignmentid,
			@PathVariable long studentid,
			@RequestParam String overrideDate) {
		String endpoint = BASE_URL + "instructor/addStudentException";
		Map<String, Object> params = new HashMap<>();
		params.put("userid", studentid);
		params.put("assignmentid", assignmentid);
		params.put("date", overrideDate);
		return restTemplate.postForObject(endpoint, params, Map.class);
	}

}