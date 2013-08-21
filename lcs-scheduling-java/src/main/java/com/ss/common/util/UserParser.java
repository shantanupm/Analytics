package com.ss.common.util;


import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ss.common.logging.RequestContext;
import com.ss.user.service.RoleService;
import com.ss.user.service.UserService;
import com.ss.user.value.Role;
import com.ss.user.value.User;


@Service("userParser")
public class UserParser {
	@Autowired
	 private UserService userService;
	
	
	@Autowired
	private RoleService roleService;
	
	 
	 
	private static final Logger log = LoggerFactory.getLogger(UserParser.class);
	 
	public void parseUserFile(InputStream is,PrintWriter pw) {
		//log.debug("Hello world!");
		try {
			Workbook wb = WorkbookFactory.create(is);
			Sheet sheet = wb.getSheetAt(0);
			
			boolean first = true;
			
			for(Row row:sheet){
				String validationStr = "";
				if(!first){
					if(row.getCell(0).getStringCellValue()==null || (row.getCell(0).getStringCellValue().length()==0 && row.getCell(1).getStringCellValue().length()==0 && row.getCell(2).getStringCellValue().length()==0 && row.getCell(3).getStringCellValue().length()==0 && row.getCell(4).getStringCellValue().length()==0 && row.getCell(5).getStringCellValue().length()==0 && row.getCell(6).getStringCellValue().length()==0))
						break;

					pw.print("\nImporting row"+row.getRowNum()+"...");
					String firstName = row.getCell(0).getStringCellValue();
					validationStr+=firstName.equals("")?"First name is mandatory -- ":"";
					String lastName = row.getCell(1).getStringCellValue();
					validationStr+=lastName.equals("")?"Last name is mandatory --":"";
					String userName= row.getCell(2).getStringCellValue();
					if(userName.equals("")){
						validationStr+="User name is mandatory --";
					}else{
						if(userService.findUserByUserName(userName)!=null){
							validationStr+="User name not available -- ";
						}
					}
					//String refId = row.getCell(3).getStringCellValue();
					String email = row.getCell(3).getStringCellValue();
					validationStr+=email.equals("")?"email id is mandatory -- ":"";
					String password = row.getCell(4).getStringCellValue();
					validationStr+=password.equals("")?"Password is mandatory -- ":"";
					String roleTitle = row.getCell(5).getStringCellValue();
					Role role=roleService.findRoleByRoleTitle(roleTitle);
					if (role==null){
						validationStr+="Role not available -- ";
					}
	
					if(validationStr.equals("")){
						User user = new User();
						user.setFirstName(firstName);
						user.setLastName(lastName);
						user.setUserName(userName);
						user.setEmailAddress(email);
						user.setDisplayName(firstName+" "+lastName);
						user.setPassword(password);
					//	user.setRefId(refId);
						user.setAccountNonExpired(true);
						user.setAccountNonLocked(true);
						user.setCredentialsNonExpired(true);
						user.setEnabled(true);
						user.setCreatedDate(new Date());
						try {
								userService.addBulkUser(user,role);
								
								pw.print("\nUser import successful\n"+validationStr);
						} catch (Exception e) {
							log.debug("Exception in Adding user");
							pw.print("Exception in Adding user at row "+(row.getRowNum()+1));
							e.printStackTrace();
							String uniqueId = RequestContext.getRequestIdFromContext();
							log.error("No  Course found."+e+" RequestId:"+uniqueId, e);
						}
					}else{
						pw.print("\nProblem occured\nDetails : \n\t"+validationStr);
					}
				}else{
					first = false;
				}
				
			}
			
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("User can not be imported."+e+" RequestId:"+uniqueId, e);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Exception occured while importing user list."+e+" RequestId:"+uniqueId, e);
		}
		pw.print("\n\nImport Complete\n");
		pw.flush();
		pw.close();
	}
	
	
	

}
