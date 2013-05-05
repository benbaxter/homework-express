package edu.nku.csc640.project.web.controller;

import static org.apache.commons.codec.binary.Base64.encodeBase64;
import static org.springframework.util.CollectionUtils.isEmpty;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.ui.Model;

import com.google.appengine.api.utils.SystemProperty;

import edu.nku.csc640.project.web.model.Assignment;
import edu.nku.csc640.project.web.model.Course;
import edu.nku.csc640.project.web.model.File;
import edu.nku.csc640.project.web.model.ProgramResult;
import edu.nku.csc640.project.web.model.User;
import edu.nku.csc640.project.web.model.UserRole;

@SuppressWarnings("unchecked")
public abstract class BaseController {
	
	protected static String BASE_URL;
	protected static String OUR_URL;
	protected static final String RESPONSE_STATUS = "Status";
	protected static final String RESPONSE_REASON = "Reason";
	protected static final String RESPONSE_STATUS_SUCCESS = "Success";
	protected static final String RESPONSE_STATUS_FAILED = "Failure";
	protected static final String RESPONSE_STATUS_EXCEPTION = "Exception";

	protected static final String SESSION_ATTR_USER = "user";

	public BaseController() {
		if (SystemProperty.environment.value() ==
			    SystemProperty.Environment.Value.Production) {
			BASE_URL = "http://www.csc640.com/homeworkexpress/api/";
			OUR_URL = "http://www.homework-express.appspot.com/";
		} else {
			OUR_URL = "http://localhost:8888/";
			BASE_URL = "http://192.168.1.100:5904/api/";
		}
	}
	
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
		User user = getUser(session);
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
	
	protected Course createCourseFromResponse(Map<String, Object> map) {
		Course course = new Course();
		course.setId((int) map.get("Id"));
		course.setName((String) map.get("Name"));
		course.setDescription((String) map.get("Description"));
		course.setInstructor(createUserFromResponse(((Map<String, Object>) map.get("Instructor"))));
		List<Map<String, Object>> ss = (List<Map<String, Object>>) map.get("Users");
		if( ! isEmpty(ss) ) { 
			List<User> students = new ArrayList<User>();
			for(Map<String, Object> s : ss ) {
				User stud = createUserFromResponse(s);
				students.add(stud);
			}
			course.setStudents(students);
		}
		
		List<Map<String, Object>> asss = (List<Map<String, Object>>) map.get("Assignments");
		if( ! isEmpty(asss) ) {
			List<Assignment> assignments = new ArrayList<Assignment>();
			for(Map<String, Object> a : asss ) {
				Assignment ass = createAssignmentFromResponse(a);
				assignments.add(ass);
			}
			course.setAssignments(assignments);
		}
		return course;
	}
	
	protected Assignment createAssignmentFromResponse(Map<String, Object> map) {
		Assignment assignment = new Assignment();
		assignment.setId((int) map.get("Id"));
		assignment.setName((String) map.get("Name"));
		assignment.setDescription((String) map.get("Description"));
		String dueDate = (String) map.get("DueDate");
		assignment.setDueDate(convertDate(dueDate));
		String finalSubmitDate = (String) map.get("FinalSubmitDate");
		assignment.setFinalSubmitDate(convertDate(finalSubmitDate));
		List<Map<String, Object>> fs = (List<Map<String, Object>>) map.get("Files");
		List<File> files = convertListOfFiles(fs);
		assignment.setFiles(files);
		Map<String, Object> compileResultList = (Map<String, Object>) map.get("CompileResult");
		ProgramResult compileResult = createProgramResultFromResponse(compileResultList);
		assignment.setCompileResult(compileResult);
		List<Map<String, Object>> testResultList = (List<Map<String, Object>>) map.get("TestResults");
		List<ProgramResult> testResults = convertListOfResults(testResultList);
		assignment.setTestResults(testResults);
		return assignment;
	}

	protected List<File> convertListOfFiles(List<Map<String, Object>> fs) {
		List<File> files = new ArrayList<File>();
		if( !isEmpty(fs) ) {
			for(Map<String, Object> f : fs) {
				File file = createFileFromResponse(f);
				files.add(file);
			}
		}
		return files;
	}

	protected List<ProgramResult> convertListOfResults(
			List<Map<String, Object>> resultList) {
		List<ProgramResult> results = new ArrayList<ProgramResult>();
		if( !isEmpty(resultList) ) {
			for(Map<String, Object> r : resultList) {
				if(r != null ) {
					ProgramResult result = createProgramResultFromResponse(r);
					results.add(result);
				}
			}
		}
		return results;
	}
	
	protected File createFileFromResponse(Map<String, Object> map) {
		File file = new File();
		file.setId((int) map.get("Id"));
		file.setFileType((String) map.get("FileType"));
		file.setName((String) map.get("FileName"));
		file.setDateSubmitted(convertDate((String) map.get("Date")));
		return file;
	}
	
	protected ProgramResult createProgramResultFromResponse(Map<String, Object> map) {
		if( map != null ) {
			ProgramResult result = new ProgramResult();
			result.setResult((String) map.get("ResultType")); 
			result.setMessage((String) map.get("Message"));
			result.setError((String) map.get("Error"));
			result.setDate(convertDate((String) map.get("Date")));
			result.setCompare((String) map.get("HtmlCompare"));
			if( map.containsKey("HasRan") ) {
				result.setHasRan((boolean) map.get("HasRan"));
			}
			return result;
		} else {
			return null;
		}
	}
	
	private Date convertDate(String dueDate) {
		dueDate = dueDate.replaceAll("[^0-9]", "");
		Date d = new Date(Long.parseLong(dueDate));
		return d;
	}
	
	protected User getUser(HttpSession session) {
		return (User) session.getAttribute(SESSION_ATTR_USER);
	}
}