package com.ss.common.filter;

import java.io.IOException;
import java.util.UUID;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import com.ss.common.logging.RequestContext;

public class RequestContextFilter implements Filter {

	@Override
	public void destroy() {
		// TODO Auto-generated method stub

	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain filterChain) throws IOException, ServletException {
		// Creating a uniqueId (UUID) that identifies the request
		String requestId = UUID.randomUUID().toString();
		RequestContext.setRequestIdInContext(requestId);
		filterChain.doFilter(request, response);
		//remove the threadLocal for the request while leaving the call
		RequestContext.close();
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		// TODO Auto-generated method stub

	}

}
