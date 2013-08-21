package com.ss.user.security;

import java.io.IOException;
import java.util.Collection;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AbstractAuthenticationTargetUrlRequestHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.ss.common.util.UserUtil;
import com.ss.institution.controller.InstitutionController;
import com.ss.user.value.Role;
import com.ss.user.value.User;

public class SSAuthenticationSuccessHandlerImpl extends
		AbstractAuthenticationTargetUrlRequestHandler implements
		AuthenticationSuccessHandler {
	private static transient Logger log = LoggerFactory.getLogger(InstitutionController.class );
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request,
			HttpServletResponse response, Authentication authentication)
			throws IOException, ServletException {
		User currentUser = UserUtil.getCurrentUser();
		if (currentUser.getAuthorities() != null&& currentUser.getAuthorities().size() > 0) {
			Collection<GrantedAuthority> authorities = currentUser.getAuthorities();
			
			String strRolesId ="",strRole ="";
			if (authorities != null && authorities.size() > 0) {
				 strRole = ((Role) (authorities.toArray()[0])).getTitle();
				for(int i=0;i<authorities.size();i++){
					 strRolesId = strRolesId+((Role) (authorities.toArray()[i])).getId();
					 
					 if(i!=authorities.size()-1){
						 strRolesId=strRolesId+",";
						 
					 }
					 if(strRolesId.contains("4")){
						 strRole = ((Role) (authorities.toArray()[i])).getTitle();
					 }
				}
				
				
				if (strRolesId.contains("4") || (strRolesId.contains("4") && strRolesId.contains("3"))) {	//--IE-- OR IE && SLE both
					response.sendRedirect("/scheduling_system/evaluation/quality.html?operation=ieEvaluate");
				}else if(strRolesId.equals("1")) {	//--DEO--
					response.sendRedirect("/scheduling_system/evaluation/launchEvaluation.html?operation=initParams");
				}else if(strRolesId.equals("3")) {	//--SLE--
					response.sendRedirect("/scheduling_system/evaluation/studentEvaluator.html?operation=launchTranscriptForSLEForEvaluation");
				}
				else if(strRolesId.equals("5")) {	//--LOPES--
					response.sendRedirect("/scheduling_system/evaluation/launchEvaluation.html?operation=launchTranscriptForLOPESForEvaluation");
				}else if(strRolesId.equals("6")){	//--IEM--
					response.sendRedirect("/scheduling_system/evaluation/ieManager.html?operation=getCoursesForInstitution&status=Conflict");
				}
				else if(strRolesId.equals("2")){	//--Administrator--
					response.sendRedirect("/scheduling_system/evaluation/admin.html?operation=viewTranscripts");
				}
				currentUser.setCurrentRole(strRole);
			}
		} else {
			// log.debug("@@@came here .. User has NO active Role .. so redirecting him to contact admin page");
			response.sendRedirect("user/users.html?operation=noUserRole");
		}

	}

}
