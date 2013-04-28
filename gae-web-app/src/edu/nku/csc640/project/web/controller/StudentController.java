package edu.nku.csc640.project.web.controller;

import static org.springframework.util.CollectionUtils.isEmpty;
import static org.springframework.web.bind.annotation.RequestMethod.GET;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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


@SuppressWarnings("unchecked")
@Controller
public class StudentController extends BaseController {
	
	@Autowired
	RestTemplate restTemplate;
	
	public StudentController() {
		super();
	}
	
	@RequestMapping(value="/student/home", method=GET)
	public String goHome(Model model, HttpSession session) { 
		model.addAttribute("navPage", "home");
		model.addAttribute("user", getUser(session));
		addMetaDataToModel(model, session);
		return "student/home";
	}	
	
	@RequestMapping(value="/student/{id}/courses", method=GET)
	public @ResponseBody List<Object> getCourses(@PathVariable long id) {
		String endpoint = BASE_URL + "student/getcourses?studentid=" + id; 
		return restTemplate.getForObject(endpoint, List.class);
	}
	
	@RequestMapping(value="/student/courses/{id}", method=GET)
	public String getCourse(Model model, HttpSession session, @PathVariable long id) { 
		
		String endpoint = BASE_URL + "student/getcourse?courseid=" + id; 
		List<Object> list = restTemplate.getForObject(endpoint, List.class);
		if( ! isEmpty(list) ) {
			Map<String, String> s = (Map<String, String>) list.get(0);
			if( RESPONSE_STATUS_SUCCESS.equalsIgnoreCase(s.get(RESPONSE_STATUS)) ) {
				Course course = createCourseFromResponse((Map<String, Object>) list.get(1));
				model.addAttribute("course", course);
				model.addAttribute("navPage", "home");
				model.addAttribute("user", getUser(session));
				addMetaDataToModel(model, session);
				return "student/course";
			} else {
				return goHome(model, session);
			}
		} else {
			return goHome(model, session);
		}
	}
	
	@RequestMapping(value="/student/course/{courseid}/assignment/{assignmentid}", method=GET)
	public String getAssignment(Model model, HttpSession session,
			@PathVariable long courseid, @PathVariable long assignmentid) { 
		
		User user = getUser(session);
		String endpoint = BASE_URL + "student/getassignment?userid=" + user.getUserId() + "&assignmentid=" + assignmentid; 
		List<Object> list = restTemplate.getForObject(endpoint, List.class);
		if( ! isEmpty(list) ) {
			Map<String, String> s = (Map<String, String>) list.get(0);
			if( RESPONSE_STATUS_SUCCESS.equalsIgnoreCase(s.get(RESPONSE_STATUS)) ) {
				Assignment assignment = createAssignmentFromResponse((Map<String, Object>) list.get(1));
				model.addAttribute("assignment", assignment);
				model.addAttribute("courseid", courseid);
				model.addAttribute("user", getUser(session));
				model.addAttribute("navPage", "home");
				addMetaDataToModel(model, session);
				return "student/assignment";
			} else {
				return getCourse(model, session, courseid);
			}
		} else {
			return getCourse(model, session, courseid);
		}
	}
	
	@RequestMapping(value="/student/course/{courseid}/assignment/{assignmentid}/submit", method=GET)
	public String submitAssignment(Model model, HttpSession session,
			@PathVariable long courseid, @PathVariable long assignmentid) { 
		
		User user = getUser(session);
		String endpoint = BASE_URL + "student/getassignment?userid=" + user.getUserId() + "&assignmentid=" + assignmentid; 
		List<Object> list = restTemplate.getForObject(endpoint, List.class);
		if( ! isEmpty(list) ) {
			Map<String, String> s = (Map<String, String>) list.get(0);
			if( RESPONSE_STATUS_SUCCESS.equalsIgnoreCase(s.get(RESPONSE_STATUS)) ) {
				Assignment assignment = createAssignmentFromResponse((Map<String, Object>) list.get(1));
				model.addAttribute("assignment", assignment);
				model.addAttribute("user", getUser(session));
				model.addAttribute("courseid", courseid);
				model.addAttribute("navPage", "home");
				model.addAttribute("submitUrl", BASE_URL + "student/addfiletoassignment");
				model.addAttribute("callBackUrl", "http://localhost:8888/actions/student/course/" + courseid + "/assignment/" + assignmentid + "/submitted");
				addMetaDataToModel(model, session);
				return "student/submit-assignment";
			} else {
				return getCourse(model, session, courseid);
			}
		} else {
			return getCourse(model, session, courseid);
		}
	}
	
	@RequestMapping(value="/student/course/{courseid}/assignment/{assignmentid}/submitted", method=GET)
	public String submitAssignment(Model model, HttpSession session, 
			@PathVariable long courseid, @PathVariable long assignmentid, 
			@RequestParam(value=RESPONSE_STATUS) String status,
			@RequestParam(value=RESPONSE_REASON) String reason) {
		if( RESPONSE_STATUS_SUCCESS.equalsIgnoreCase(status) ) {
			return getAssignment(model, session, courseid, assignmentid);
		} else {
			model.addAttribute("error", reason);
			return submitAssignment(model, session, courseid, assignmentid);
		}
	}
	
	@RequestMapping(value="/student/assignment/{assignmentid}/compile-program", method=GET)
	public @ResponseBody Map<String, Object> compileProgram(Model model, HttpSession session,
			@PathVariable long assignmentid) {
		User user = getUser(session);
		String endpoint = BASE_URL + "student/compile?" +
				"userid=" + user.getUserId() + 
				"&assignmentid=" + assignmentid +
				"&initiatedby=" + user.getUserId(); 
		return restTemplate.getForObject(endpoint,  Map.class);
	}
	
	@RequestMapping(value="/student/assignment/{assignmentid}/compile-status", method=GET)
	public @ResponseBody List<Object> getCompileStatus(Model model, HttpSession session,
			@PathVariable long assignmentid) {
		User user = getUser(session);
		String endpoint = BASE_URL + "student/compilestatus?" +
				"userid=" + user.getUserId() + 
				"&assignmentid=" + assignmentid +
				"&initiatedby=" + user.getUserId(); 
		return restTemplate.getForObject(endpoint,  List.class);
	}
	
	@RequestMapping(value="/student/assignment/{assignmentid}/compile-result", method=GET)
	public @ResponseBody Map<String, Object> getCompileResult(Model model, HttpSession session,
			@PathVariable long assignmentid) {
		Map<String, Object> map = new HashMap<String, Object>();
		User user = getUser(session);
		String endpoint = BASE_URL + "student/getcompileresult?" +
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
	
	@RequestMapping(value="/student/assignment/{assignmentid}/cancel-compile", method=GET)
	public @ResponseBody Map<String, String> cancelCompile(Model model, HttpSession session,
			@PathVariable long assignmentid) {
		User user = getUser(session);
		String endpoint = BASE_URL + "student/cancelcompile?" +
				"userid=" + user.getUserId() + 
				"&assignmentid=" + assignmentid +
				"&initiatedby=" + user.getUserId(); 
		return restTemplate.getForObject(endpoint,  Map.class);
	}

	@RequestMapping(value="/student/assignment/{assignmentid}/run-program", method=GET)
	public @ResponseBody Map<String, Object> runProgram(Model model, HttpSession session,
			@PathVariable long assignmentid) {
		User user = getUser(session);
		String endpoint = BASE_URL + "student/test?" +
				"userid=" + user.getUserId() + 
				"&assignmentid=" + assignmentid +
				"&initiatedby=" + user.getUserId(); 
		return restTemplate.getForObject(endpoint,  Map.class);
	}
	
	@RequestMapping(value="/student/assignment/{assignmentid}/run-program-status", method=GET)
	public @ResponseBody List<Object> getRunningProgramStatus(Model model, HttpSession session,
			@PathVariable long assignmentid) {
		User user = getUser(session);
		String endpoint = BASE_URL + "student/teststatus?" +
				"userid=" + user.getUserId() + 
				"&assignmentid=" + assignmentid +
				"&initiatedby=" + user.getUserId(); 
		return restTemplate.getForObject(endpoint,  List.class);
	}
	
	@RequestMapping(value="/student/assignment/{assignmentid}/run-program-result", method=GET)
	public @ResponseBody Map<String, Object> getRunningProgramResult(Model model, HttpSession session,
			@PathVariable long assignmentid) {
		Map<String, Object> map = new HashMap<String, Object>();
		User user = getUser(session);
		String endpoint = BASE_URL + "student/gettestresults?" +
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
	
	@RequestMapping(value="/student/assignment/{assignmentid}/cancel-program", method=GET)
	public @ResponseBody Map<String, String> cancelRunningProgram(Model model, HttpSession session,
			@PathVariable long assignmentid) {
		User user = getUser(session);
		String endpoint = BASE_URL + "student/canceltest?" +
				"userid=" + user.getUserId() + 
				"&assignmentid=" + assignmentid +
				"&initiatedby=" + user.getUserId(); 
		return restTemplate.getForObject(endpoint,  Map.class);
	}
}