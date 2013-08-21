package com.ss.user.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ss.user.dao.UserDAO;
import com.ss.user.value.Role;

@Service("roleService")
@Transactional(readOnly=true)
public class RoleServiceImpl implements RoleService {
	private static final Logger log = LoggerFactory.getLogger(RoleServiceImpl.class);

	
	@Autowired
	private UserDAO userDAO;
	

	@Override
	public List<Role> findRolesForUserName(String userName){
		return userDAO.findRolesForUserName(userName);
	}
	@Override
	public Role findRoleByRoleTitle(String roleTitle){
		return userDAO.findRoleByRoleTitle(roleTitle);
	}
	
	@Override
	public List<Role> findAllRoles(){
		return userDAO.findAllRoles();
	}

	@Override
	public Role findRoleById(String roleId){
		return userDAO.findRoleById(roleId);
	}
}
