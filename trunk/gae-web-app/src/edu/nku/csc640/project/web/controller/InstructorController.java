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
		
		User user = getUser(session);
		String endpoint = BASE_URL + "instructor/addUserToCourse";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("courseId", courseid);
		params.put("userId", studentId);
		return restTemplate.postForObject(endpoint, params, Map.class);
	}
	
	@RequestMapping(value= root + "/course/{courseid}/assignment/{assignmentid}/submit", method=GET)
	public String submitAssignment(Model model, HttpSession session,
			@PathVariable long courseid, @PathVariable long assignmentid) { 
		
		User user = getUser(session);
		String endpoint = BASE_URL + "instructor/getassignment?userid=" + user.getUserId() + "&assignmentid=" + assignmentid; 
		List<Object> list = restTemplate.getForObject(endpoint, List.class);
		if( ! isEmpty(list) ) {
			Map<String, String> s = (Map<String, String>) list.get(0);
			if( RESPONSE_STATUS_SUCCESS.equalsIgnoreCase(s.get(RESPONSE_STATUS)) ) {
				Assignment assignment = createAssignmentFromResponse((Map<String, Object>) list.get(1));
				model.addAttribute("assignment", assignment);
				model.addAttribute("user", getUser(session));
				model.addAttribute("courseid", courseid);
				model.addAttribute("navPage", "home");
				model.addAttribute("submitUrl", BASE_URL + "instructor/addfiletoassignment");
				model.addAttribute("callBackUrl", "http://localhost:8888/actions/instructor/course/" + courseid + "/assignment/" + assignmentid + "/submitted");
				addMetaDataToModel(model, session);
				return "instructor/submit-assignment";
			} else {
				return getCourse(model, session, courseid);
			}
		} else {
			return getCourse(model, session, courseid);
		}
	}
	
	@RequestMapping(value= root + "/course/{courseid}/assignment/{assignmentid}/submitted", method=GET)
	public String submitAssignment(Model model, HttpSession session, 
			@PathVariable long courseid, @PathVariable long assignmentid, 
			@RequestParam(value=RESPONSE_STATUS) String status,
			@RequestParam(value=RESPONSE_REASON) String reason) {
		if( RESPONSE_STATUS_SUCCESS.equalsIgnoreCase(status) ) {
		} else {
			model.addAttribute("error", reason);
		}
		return submitAssignment(model, session, courseid, assignmentid);
	}
	
	@RequestMapping(value= root + "/assignment/{assignmentid}/compile-program", method=GET)
	public @ResponseBody Map<String, Object> compileProgram(Model model, HttpSession session,
			@PathVariable long assignmentid) {
		User user = getUser(session);
		String endpoint = BASE_URL + "instructor/compile?" +
				"userid=" + user.getUserId() + 
				"&assignmentid=" + assignmentid +
				"&initiatedby=" + user.getUserId(); 
		return restTemplate.getForObject(endpoint,  Map.class);
	}
	
	@RequestMapping(value= root + "/assignment/{assignmentid}/compile-status", method=GET)
	public @ResponseBody List<Object> getCompileStatus(Model model, HttpSession session,
			@PathVariable long assignmentid) {
		User user = getUser(session);
		String endpoint = BASE_URL + "instructor/compilestatus?" +
				"userid=" + user.getUserId() + 
				"&assignmentid=" + assignmentid +
				"&initiatedby=" + user.getUserId(); 
		return restTemplate.getForObject(endpoint,  List.class);
	}
	
	@RequestMapping(value= root + "/assignment/{assignmentid}/compile-result", method=GET)
	public @ResponseBody Map<String, Object> getCompileResult(Model model, HttpSession session,
			@PathVariable long assignmentid) {
		Map<String, Object> map = new HashMap<String, Object>();
		User user = getUser(session);
		String endpoint = BASE_URL + "instructor/getcompileresult?" +
				"userid=" + user.getUserId() + 
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
	
	@RequestMapping(value= root + "/assignment/{assignmentid}/cancel-compile", method=GET)
	public @ResponseBody Map<String, String> cancelCompile(Model model, HttpSession session,
			@PathVariable long assignmentid) {
		User user = getUser(session);
		String endpoint = BASE_URL + "instructor/cancelcompile?" +
				"userid=" + user.getUserId() + 
				"&assignmentid=" + assignmentid +
				"&initiatedby=" + user.getUserId(); 
		return restTemplate.getForObject(endpoint,  Map.class);
	}

	@RequestMapping(value= root + "/assignment/{assignmentid}/run-program", method=GET)
	public @ResponseBody Map<String, Object> runProgram(Model model, HttpSession session,
			@PathVariable long assignmentid) {
		User user = getUser(session);
		String endpoint = BASE_URL + "instructor/test?" +
				"userid=" + user.getUserId() + 
				"&assignmentid=" + assignmentid +
				"&initiatedby=" + user.getUserId(); 
		return restTemplate.getForObject(endpoint,  Map.class);
	}
	
	@RequestMapping(value= root + "/assignment/{assignmentid}/run-program-status", method=GET)
	public @ResponseBody List<Object> getRunningProgramStatus(Model model, HttpSession session,
			@PathVariable long assignmentid) {
		User user = getUser(session);
		String endpoint = BASE_URL + "instructor/teststatus?" +
				"userid=" + user.getUserId() + 
				"&assignmentid=" + assignmentid +
				"&initiatedby=" + user.getUserId(); 
		return restTemplate.getForObject(endpoint,  List.class);
	}
	
	@RequestMapping(value= root + "/assignment/{assignmentid}/run-program-result", method=GET)
	public @ResponseBody Map<String, Object> getRunningProgramResult(Model model, HttpSession session,
			@PathVariable long assignmentid) {
		Map<String, Object> map = new HashMap<String, Object>();
		User user = getUser(session);
		String endpoint = BASE_URL + "instructor/gettestresults?" +
				"userid=" + user.getUserId() + 
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
	
	@RequestMapping(value= root + "/assignment/{assignmentid}/cancel-program", method=GET)
	public @ResponseBody Map<String, String> cancelRunningProgram(Model model, HttpSession session,
			@PathVariable long assignmentid) {
		User user = getUser(session);
		String endpoint = BASE_URL + "instructor/canceltest?" +
				"userid=" + user.getUserId() + 
				"&assignmentid=" + assignmentid +
				"&initiatedby=" + user.getUserId(); 
		return restTemplate.getForObject(endpoint,  Map.class);
	}
	
}