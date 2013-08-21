package com.ss.user.security;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.ss.common.logging.RequestContext;
import com.ss.user.dao.UserDAO;
import com.ss.user.service.RoleService;
import com.ss.user.value.Role;
import com.ss.user.value.User;

public class SSUserDetailsServiceImpl implements UserDetailsService {
	private static final Logger log = LoggerFactory.getLogger(SSUserDetailsServiceImpl.class);
	@Autowired
	UserDAO userDao;
	@Autowired
	private RoleService roleService;
	
	
	public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException, DataAccessException {
		User user=null;
		try {
			user = userDao.findUserByUserName(userName);
			if (user == null) throw new UsernameNotFoundException("Username not found.");
			List<Role> roles = roleService.findRolesForUserName(userName);
			List <GrantedAuthority> ga = null;		
			if(roles!=null && roles.size()>0){
				ga = new ArrayList<GrantedAuthority>();
				for (Role role:roles) {
					ga.add(role);
					log.debug("@@yippeeee!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Added Role"+role.getTitle());
				}	
			}
			user.setAuthorities(ga);
					
		} catch (Exception e) {
			// TODO Auto-generated catch block
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Exception Occured."+e+" RequestId:"+uniqueId, e);
			e.printStackTrace();
		}
		log.debug("@@User = "+user);
		return user;
	}	

}
