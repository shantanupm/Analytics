package com.ss.user.security;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;

import com.ss.common.logging.RequestContext;

public class SSDaoAuthenticationProvider extends DaoAuthenticationProvider {
	private static final Logger log = LoggerFactory.getLogger(SSDaoAuthenticationProvider.class);

	@SuppressWarnings("serial")
	@Override
	public Authentication authenticate(Authentication authentication)
			throws AuthenticationException {
		Authentication auth1 = null;
		try {
			auth1 = super.authenticate(authentication);
			return auth1;
		} catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Password is empty."+e+" RequestId:"+uniqueId, e);
			throw new AuthenticationException("Password is empty.") {
			};		

		}

	}
}
