package com.ss.user.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ss.common.util.UserUtil;
import com.ss.user.dao.UserDAO;
import com.ss.user.value.Role;
import com.ss.user.value.User;
import com.ss.user.value.UserRole;

@Service("userService")
public class UserServiceImpl implements UserService{
	
	@Autowired
	UserDAO userDAO;
	
	@Override
	public List<UserRole> getUserRoleList(String searchBy, String searchText){
		List<UserRole> userRoleList = userDAO.getUserRoleList(searchBy, searchText);
		return userRoleList;
	}
	
	@Override
	public List<User> getUserList(String searchBy, String searchText){
		List<User> userList = userDAO.getUserList(searchBy, searchText);
		for(User user : userList){
			user.setCurrentRole(userDAO.getRoleNameForUser(user.getId()));
		}
		return userList;
	}
	
	@Override
	public User getUserByUserId(String userId){
		User user = userDAO.findById(userId);
		user.setCurrentRole(userDAO.getRoleNameForUser(userId));
		return user;
	}
	
	@Override
	public List<Role> findAllRoles(){
		return userDAO.findAllRoles();
	}
	
	@Override
	public void addUser(User user){
		userDAO.addUser(user);
	}
	
	@Override
	public void addUserRole(UserRole userRole){
		userDAO.addUserRole(userRole);
	}
	
	@Override
	public void createUserRole(String userId, String roleId, String previousRoleId){
		
		UserRole userRole = null;
		if(previousRoleId != null){
			userRole = userDAO.getUserRoleByUserIdAndRoleId(userId,previousRoleId);
		}
		
		if(userRole == null){
			userRole = new UserRole();
			userRole.setModifiedBy(UserUtil.getCurrentUser().getId());
			userRole.setRoleId(roleId);
			userRole.setStatus("A");
			userRole.setUserId(userId);
			addUserRole(userRole);
		}
		else{
			userDAO.updateUserRole(userId, roleId, previousRoleId,UserUtil.getCurrentUser().getId());
		}
		
	}
	@Override
	public void addBulkUser(User user, Role role){
		addUser(user);
		createUserRole(user.getId(),role.getId(),null);
	}
	@Override
	public User findUserByUserName(String userName) {
		return userDAO.findUserByUserName(userName);
	}
	@Override
	public List<User> getUserByRoleId(String roleId) {
		return userDAO.findUserByRoleId(roleId);
	}
}
