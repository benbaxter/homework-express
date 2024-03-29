package edu.nku.csc640.project.web.filter;

import static edu.nku.csc640.project.web.model.UserRole.Admin;
import static edu.nku.csc640.project.web.model.UserRole.Instructor;
import static edu.nku.csc640.project.web.model.UserRole.Student;
import static org.springframework.util.StringUtils.hasText;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;
import java.util.logging.Logger;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import edu.nku.csc640.project.web.model.User;
import edu.nku.csc640.project.web.model.UserRole;

public class AuthFilter implements Filter {

	private static final Logger log = Logger.getLogger(AuthFilter.class.getName());
	
	//Currently need to whitelist the login url path to advoid the filter 
	private static final Set<String> whiteListSpringUrlsToNotFilter;
	static {
		whiteListSpringUrlsToNotFilter = new HashSet<String>();
		whiteListSpringUrlsToNotFilter.add("/actions/login");
		whiteListSpringUrlsToNotFilter.add("/actions/logout");
//		whiteListSpringUrlsToNotFilter.add("/actions/profile");
		whiteListSpringUrlsToNotFilter.add("/actions/no-auth");
		whiteListSpringUrlsToNotFilter.add("/actions/something-bad-happened");
	}
	
	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		
		HttpServletRequest httpRequest = (HttpServletRequest) request;
		String url = httpRequest.getRequestURI();
		HttpSession session = httpRequest.getSession();
		User user = (User) session.getAttribute("user");
        log.info("user: " + user);
        log.info("url: " + url);
		if( user != null ) {
			if( user.getRole() == Admin
					&& (url.startsWith("/actions/admin")
					|| url.startsWith("/actions/instructor")) ) {
				chain.doFilter(request, response);
			} else if( user.getRole() == Instructor
						&& url.startsWith("/actions/instructor") ) {
					chain.doFilter(request, response);
			} else if( user.getRole() == Student
					&& url.startsWith("/actions/student") ) {
				chain.doFilter(request, response);
			} else if(url.startsWith("/actions/profile")) {
				chain.doFilter(request, response);
			} else {
				handleRedirect("/actions/no-auth", url, request, response, chain);
			}
		} else {
			handleRedirect("/actions/login", url, request, response, chain);
		}
		
	}
	
	private void handleRedirect(String redirect, String url, 
			ServletRequest request, ServletResponse response, FilterChain chain) 
					throws IOException, ServletException {
		if( ! isUrlWhiteListed(url) ) {
			((HttpServletResponse) response).sendRedirect(redirect);
		} else {
			chain.doFilter(request, response);
		}
	}

	//This method to to strip the JSESSION variable from the url
	private boolean isUrlWhiteListed(String url) {
		if( hasText(url) ) {
			for (String whiteList : whiteListSpringUrlsToNotFilter) {
				if( url.startsWith(whiteList) ) {
					return true;
				}
			}
		}
		return false;
	}
	
	@Override
	public void init(FilterConfig arg0) throws ServletException {
	}

	@Override
	public void destroy() {
	}
}
