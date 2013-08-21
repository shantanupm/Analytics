package com.ss.user.controller;

import java.io.ByteArrayInputStream;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.beans.propertyeditors.StringTrimmerEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.ss.common.logging.RequestContext;
import com.ss.common.util.Constants;
import com.ss.common.util.UserParser;
import com.ss.common.util.UserUtil;
import com.ss.user.service.RoleService;
import com.ss.user.service.UserService;
import com.ss.user.value.User;
import com.ss.user.value.UserRole;

@Controller
@RequestMapping("/user/user.html")
public class UserController {
	private static final Logger log = LoggerFactory.getLogger(UserController.class);
	
	@Autowired
	private UserParser userParser;

	@Autowired 
	private UserService userService;
	
	@Autowired
	private RoleService roleService;
	
	@InitBinder
	public void allowEmptyDateBinding( WebDataBinder binder )
	{
	    // Allow for null values in date fields.
	    binder.registerCustomEditor( Date.class, new CustomDateEditor( Constants.COMMON_DATE_FORMAT, true ));
	    // tell spring to set empty values as null instead of empty string.
	    binder.registerCustomEditor( String.class, new StringTrimmerEditor( true ));
	}
	
	@RequestMapping(params="operation=manageUsers")
	public String getUserList(@RequestParam(value="searchBy", required=false) String searchBy, 
			@RequestParam(value="searchText", required=false) String searchText, Model model){
		
		model.addAttribute("userList", userService.getUserList(searchBy, searchText));
		
		if(searchBy == null || "".equals(searchBy)){
			searchBy = "2";
		}
		if(searchText == null){
			searchText = "";
		}
		
		model.addAttribute("searchBy",searchBy);
		model.addAttribute("searchText", searchText);
		return "manageUsers";
	}
	
	@RequestMapping(params="operation=createUser")
	public String createUser(@RequestParam(value="userId", required=false) String userId, Model model){
		User user = new User();
		if(userId != null){
			user = userService.getUserByUserId(userId);
		}
		
		model.addAttribute("user", user);
		model.addAttribute("roleList", userService.findAllRoles());
		return "createUser";
	}
	
	@RequestMapping(params="operation=saveUser")
	public String saveUser(User user, @RequestParam("roleId") String roleId,
			@RequestParam(value="previousRoleId",required=false) String previousRoleId, Model model){
		
		if(user.getId() == null || user.getId().isEmpty()){
			user.setEnabled(true);
			user.setCreatedDate(new Date());
		}
		
		user.setAccountNonExpired(true);
		user.setAccountNonLocked(true);
		user.setCredentialsNonExpired(true);
		
		userService.addUser(user);
		userService.createUserRole(user.getId(), roleId, previousRoleId);
		
		user.setCurrentRole(roleService.findRoleById(roleId).getTitle());
		
		return "redirect:user.html?operation=manageUsers";
	}
	
	@RequestMapping(params="operation=getImportUser")
	public String getImportUser(Model model){
		return "importUser";
	}
	@RequestMapping(params="operation=importUser")
	public void importUser(HttpServletResponse response, @RequestParam("uploaded") MultipartFile uploaded){
		try {
			userParser.parseUserFile(new ByteArrayInputStream(uploaded.getBytes()),response.getWriter());
		}
		catch (Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Exception Occured while importing users."+e+" RequestId:"+uniqueId, e);
			e.printStackTrace();
		}
	}
	
	@RequestMapping(params="operation=validateUserName")
	@ResponseBody
	public String validateUserName(@RequestParam(value="userName") String userName,
			Model model ){
		User user = userService.findUserByUserName(userName);
		if(user != null){
			return String.valueOf(true);
		}
		else {
			return String.valueOf(false);
		}
	}

	@RequestMapping(params="operation=handleActivation")
	public String handleActivation(@RequestParam(value="userId") String userId, Model model){
		User user = userService.getUserByUserId(userId);
		if(user.isEnabled()){
			user.setEnabled(false);
		}
		else{
			user.setEnabled(true);
		}
		userService.addUser(user);
		return "redirect:user.html?operation=manageUsers";
	}
}
