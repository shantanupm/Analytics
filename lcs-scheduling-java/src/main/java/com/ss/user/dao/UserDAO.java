package com.ss.user.dao;

import java.io.Serializable;
import java.util.List;

import com.ss.common.dao.BaseDAO;
import com.ss.user.value.Role;
import com.ss.user.value.User;
import com.ss.user.value.UserRole;

public interface UserDAO extends BaseDAO<User, Serializable> {

	public User findUserByUserName(String userName);
	public List<Role> findRolesForUserName(String userName);
	public List<User> findUsersByRoleId(String roleId);
	public Role findRoleByRoleTitle(String roleTitle);
	public List<UserRole> getUserRoleList(String searchBy, String searchText);
	public List<User> getUserList(String searchBy, String searchText);
	public String getRoleNameForUser(String userId);
	public List<Role> findAllRoles();
	public void addUser(User user);
	public void addUserRole(UserRole userRole);
	//TODO: Refactor
	public void updateUserRole(String userId, String roleId, String previousRoleId,String modifyingUserId);
	public Role findRoleById(String roleId);
	public UserRole getUserRoleByUserIdAndRoleId(String userId, String roleId);
	public List<User> findUserByRoleId(String roleId);
}
