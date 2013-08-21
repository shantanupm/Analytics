package com.ss.common.util;

import java.util.Collection;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;

import com.ss.user.value.Role;
import com.ss.user.value.User;

public class UserUtil {
	private static final Logger log = LoggerFactory.getLogger(UserUtil.class);

	public static User getCurrentUser(){
		if (SecurityContextHolder.getContext().getAuthentication() == null) return null;
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		if (principal instanceof UserDetails) {
		  return (User)principal;
		} else {
		  return null;
		}
	}
	
	public static Object get(String key){		
		return getCurrentUser().getUserSessionMap().get(key);
	}
	
	public static void put(String key, Object obj){
		getCurrentUser().getUserSessionMap().put(key, obj);
	}
	
	public static void remove(String key){
		getCurrentUser().getUserSessionMap().remove(key);
	}
	
	public static Role getCurrentRole(){
		if (SecurityContextHolder.getContext().getAuthentication() == null) return null;
		String currentRole = getCurrentUser().getCurrentRole();
		Collection<GrantedAuthority> authorities =  SecurityContextHolder.getContext().getAuthentication().getAuthorities();
		for (GrantedAuthority grantedAuthority : authorities) {
			Role curRole = (Role)grantedAuthority;
			if (curRole.getTitle().equalsIgnoreCase(currentRole)){
				return curRole;
			}
		}
		return null;
	}
	public static Collection getAssignedRoles(){
		Authentication authentication=SecurityContextHolder.getContext().getAuthentication();
		return authentication == null?null:authentication.getAuthorities();
	}
}
