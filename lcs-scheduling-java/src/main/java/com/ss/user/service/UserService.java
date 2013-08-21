package com.ss.user.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.ss.user.value.Role;
import com.ss.user.value.User;
import com.ss.user.value.UserRole;

@Service
public interface UserService {

	public List<UserRole> getUserRoleList(String searchBy, String searchText);
	public List<User> getUserList(String searchBy, String searchText);
	public User getUserByUserId(String userId);
	public List<Role> findAllRoles();
	public void addUser(User user);
	public void addUserRole(UserRole userRole);
	public void createUserRole(String userId, String roleId, String previousRoleId);
	public void addBulkUser(User user,  Role role);
	public User findUserByUserName(String userName);
	public List<User> getUserByRoleId(String roleId);
}
