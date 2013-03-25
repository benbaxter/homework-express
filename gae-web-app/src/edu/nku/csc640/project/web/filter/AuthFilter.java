package edu.nku.csc640.project.web.filter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import static org.springframework.util.StringUtils.hasText;
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

public class AuthFilter implements Filter {

	//Currently need to whitelist the login url path to advoid the filter 
	private static final List<String> whiteListSpringUrlsToNotFilter;
	static {
		whiteListSpringUrlsToNotFilter = new ArrayList<String>();
		whiteListSpringUrlsToNotFilter.add("/actions/login");
	}
	
	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		
		HttpServletRequest httpRequest = (HttpServletRequest) request;
		String url = httpRequest.getRequestURI();
		HttpSession session = httpRequest.getSession();
		User user = (User) session.getAttribute("user");
		
		if( user == null && ! isUrlWhiteListed(url) ) {
			((HttpServletResponse) response).sendRedirect("/actions/login");
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
