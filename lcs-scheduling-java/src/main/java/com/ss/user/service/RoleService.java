package com.ss.user.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.ss.user.value.Role;

@Service
public interface RoleService {
	
	public List<Role> findRolesForUserName(String userName);

	public Role findRoleByRoleTitle(String roleTitle);
	
	public List<Role> findAllRoles();
	
	public Role findRoleById(String roleId);
}
