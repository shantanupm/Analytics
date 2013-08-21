package com.ss.user.security;

import java.net.URLEncoder;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.web.authentication.preauth.AbstractPreAuthenticatedProcessingFilter;
import org.springframework.security.web.authentication.preauth.PreAuthenticatedCredentialsNotFoundException;

import com.ss.common.logging.RequestContext;
import com.ss.common.util.Constants;
import com.ss.user.service.UserService;
import com.ss.user.value.User;

import org.apache.commons.codec.binary.Base64;

import sun.misc.BASE64Decoder;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SSRequestParameterAuthenticationFilter extends AbstractPreAuthenticatedProcessingFilter {
	@Autowired
	private UserService userService;
	
	private String authTokenParamName="token";
	private String creadentialRequestParameter;
	private boolean exceptionIfParameterIsMissing = false;
	private String userIdParamName = "userName"; 

	private static final Logger log = LoggerFactory.getLogger(SSRequestParameterAuthenticationFilter.class);
	
	private  String decrypt(String text)throws Exception{		
		Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
		byte[] keyBytes= new byte[16];
		byte[] key = new String(Constants.SHAREDKEY).getBytes();
		int len= key.length;
		if (len > keyBytes.length) len = keyBytes.length;
		System.arraycopy(key, 0, keyBytes, 0, len);
		SecretKeySpec keySpec = new SecretKeySpec(keyBytes, "AES");
		IvParameterSpec ivParamSpec = new IvParameterSpec(keyBytes);
		cipher.init(Cipher.DECRYPT_MODE,keySpec, ivParamSpec);         
		BASE64Decoder decoder = new BASE64Decoder();         
		//log.debug("in decrypt value = "+text);		
		try {
			byte [] results = cipher.doFinal(decoder.decodeBuffer(text));
			String str =  new String(results,"UTF-8");
			//log.debug("@@ decrypted = "+str);
			return str;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Exception occured."+e+" RequestId:"+uniqueId, e);
			e.printStackTrace();
		}
		return null;
	}
	protected Object getPreAuthenticatedCredentials(HttpServletRequest request) {
		if (creadentialRequestParameter != null) {
            String credentials = request.getParameter(creadentialRequestParameter);
            return credentials;
        }
        return "N/A";
	}

	protected Object getPreAuthenticatedPrincipal(HttpServletRequest request) {
	        String principal = request.getParameter(authTokenParamName);
	        //log.debug("@@@@@@@@@@@@@@@@@@ classID  = "+request.getParameter("classId"));
	       
	         if (principal == null && exceptionIfParameterIsMissing) {
		            throw new PreAuthenticatedCredentialsNotFoundException(authTokenParamName
		                    + " Parameter not found in request.");
		     }else{
		    	 try{		
		    		 //log.debug("passing the value .. ");
		    		 principal=principal.replace(' ', '+');
		    		 principal = decrypt(principal);
		    		 //log.debug("@@@@@@@@@ in else");
		    		// log.debug("principal-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="+principal);
		    	 }catch (Exception e) {
		    		 if(exceptionIfParameterIsMissing){
		    			 String uniqueId = RequestContext.getRequestIdFromContext();
		    			 log.error(principal+" Not able to decript the auth token.."+e+" RequestId:"+uniqueId, e);
		    		 throw new PreAuthenticatedCredentialsNotFoundException(principal+" :Not able to decript the auth token.");
		    		 }else{
		    			 return null;
		    		 }
				}
		    	
		    	 /*if(!principal.equals(request.getParameter(userIdParamName))){
		    		 log.debug("@@@@@@@@@@@ in iff");
		    		 if(exceptionIfParameterIsMissing){
		    			 throw new PreAuthenticatedCredentialsNotFoundException("Authentication parameters were tampered");
		    		 }else{
		    			 return null;
		    		 }
		    	 }
		    	 log.debug("@@@@@@@@@@@ after iff");*/
		     }
		     
	      //  log.debug("principal-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-="+principal);
	        
			 User user =null;
			 if(principal!=null){
				
				 String userName=getValue("userName",principal);
				 String crmId = getValue("studentCrmId",principal);
			    
			     request.setAttribute("studentCrmId", crmId);
			     request.setAttribute("programVersionCode", getValue("programVersionCode",principal));
			     request.setAttribute("catalogCode", getValue("catalogCode",principal));
			     request.setAttribute("stateCode", getValue("stateCode",principal));
			     request.setAttribute("expectedStartDate", getValue("expectedStartDate",principal));
			     
			     user = userService.findUserByUserName(userName);
			 }
			if(user==null && exceptionIfParameterIsMissing){
				throw new PreAuthenticatedCredentialsNotFoundException("User does not exists with the given user name.");
			}
			if(user!=null){
				user.setOnline(true);
				//for Updating User
				userService.addUser(user); 
		        log.debug("@@@@@@@@@@@ after iff user.getUsername().toLowerCase() = "+user.getUsername().toLowerCase());
				return user.getUsername().toLowerCase();		
			}else{
				return null;
			}
	}

	
	public void setAuthTokenParamName(String authTokenParamName) {
		this.authTokenParamName = authTokenParamName;
	}
	public void setUserIdParamName(String userIdParamName) {
		//log.debug("@@ setUserIdParamName");
		this.userIdParamName = userIdParamName;
	}
	public void setCreadentialRequestParameter(String creadentialRequestParameter) {
		//log.debug("@@ setCreadentialRequestParameter");
		this.creadentialRequestParameter = creadentialRequestParameter;
	}

	public void setExceptionIfParameterIsMissing(
			boolean exceptionIfParameterIsMissing) {
		//log.debug("@@ setExceptionIfParameterIsMissing");
		this.exceptionIfParameterIsMissing = exceptionIfParameterIsMissing;
	}

	private String getValue(String toFind, String string){
		String returnValue="";
		String[] arr = string.split("&");
		for(int i=0;i<arr.length;i++){
			if(arr[i].toLowerCase().contains(toFind.toLowerCase())){
				returnValue=arr[i].substring(toFind.length()+1);
				break;
			}
		}
		return returnValue;
	}
}
