<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@include file="../init.jsp" %>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>
<script type='text/javascript' src="<c:url value="/js/jquery-1.8.0.min.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery-ui-1.8.23.custom.min.js"/>"></script>

<script>
jQuery(document).ready(function(){
	//jQuery('#tabs').tabs({ selected: 2 });
	
	jQuery("#searchBy").val('${searchBy}');
	jQuery("#searchText").val('${searchText}');
	
	jQuery("#resetSearch").click(function(){
		jQuery("#searchBy").val("2");
		jQuery("#searchText").val("");
		window.location.href='user.html?operation=manageUsers';
	});
	
	jQuery("#searchUser").click(function(){
		window.location.href='user.html?operation=manageUsers&searchBy='+jQuery("#searchBy").val()+'&searchText='+jQuery("#searchText").val();
	});
	
	jQuery('#searchText').keypress(function(e) {
		 var code = (e.keyCode ? e.keyCode : e.which);
		 if(code == 13) { //Enter keycode
			 window.location.href='user.html?operation=manageUsers&searchBy='+jQuery("#searchBy").val()+'&searchText='+jQuery("#searchText").val();	 	
		 }
	});
	
});

function importUser(){
	Boxy.load('user.html?operation=getImportUser',{unloadOnHide:true,afterShow:function(){
			jQuery("#frmImportUser").validate();
			
			jQuery("#impClsBtn").bind('click',function() {
			});
			jQuery('#impClsBtn').toggle(function() {
				jQuery("#iframe_user").slideDown();
				jQuery('#impClsBtn').val('Hide Log');
				jQuery('.divider').hide();
			}, function() {
				jQuery("#iframe_user").slideUp();
				jQuery('#impClsBtn').val("View Log");
				jQuery('.divider').show();
			});
		}
	});
}

</script>


    	<div>
			<div class="noti-tools">
				<div class="fl">
					<span class="fl"> <label class="noti-label noti-mrgl">Search:</label>
	                <input type="text" id="searchText" class="txbx noti-txbx" name="searchText" value=""/>
                    <select class="frm-stxbx" id="searchBy" name="searchBy">
                        <option value="2">Name</option>
                        <option value="1">User Name</option>
                    </select>
	                </span>
	                <span>
                   		<input name="searchUser" type="button" value="Search"  id="searchUser"/>
                   		<input name="resetSearch"  type="button" value="Reset"  id="resetSearch"/>
               		</span>
               		<br class="clear">
				</div>
				<div class="fr institutionHeader">
                	<a href="<c:url value="user.html?operation=createUser"/>" class="newUser"><img alt="New User" src="/scheduling_system/images/newUser.png">New User</a>
                    <a alt="Import User" href="javascript:void(0)" onclick="javascript:importUser();"><img alt="Import User" src="/scheduling_system/images/importUser.png"> Import User</a>
               	</div>
				<br class="clear">
			</div>
			<display:table name="userList"  id="user" class="noti-tbl"  pagesize="10"  requestURI="user.html" export="false" sort="list">  
	 			<display:column title="Sr. No."  headerClass="dividerGrey thW10"  value="${user_rowNum}"/> 
	      		<display:column  title="<span class='sort_d'>User Name</span>" sortable="true" headerClass="dividerGrey thW20" >
				   ${user.userName}
			   	</display:column>
	      		<display:column  title="<span class='sort_d'>Name</span>" sortable="true" sortProperty="firstName" headerClass="dividerGrey	thW30" >
	           		<a href="<c:url value="user.html?operation=createUser&userId=${user.id}"/>">${user.firstName} ${user.lastName}</a> 
		    	</display:column>
	     		<display:column title="<span class=''> Role</span>" headerClass="dividerGrey thW10" > 
	     		${user.currentRole}
	     		</display:column>
	     		<display:column title="<span class='sort_d'>Creation Date</span>" sortable="true" headerClass="dividerGrey thW20" > 
		     		<fmt:formatDate value="${user.createdDate}" pattern="MM/dd/yyyy"/>
	     		</display:column>
	     		<display:column title="<span class=''>Status</span>" headerClass="dividerGrey thW10" > 
	     			<c:choose>
	     				<c:when test="${user.enabled==true}">Active</c:when>
	     				<c:otherwise>Inactive</c:otherwise>
	     			</c:choose>
	     		</display:column>
	     		<display:column title="<span class=''></span>" headerClass="dividerGrey thW10" > 
	     			<div class="settingBox"> <a class="settingLink" href="javascript:void(0)">&nbsp;</a>
                    	<div class="stsOptions">
                      		<ul>
	                        	<li><a class="editUser" href="<c:url value='user.html?operation=createUser&userId=${user.id}'/>">Modify User</a></li>
	                        	<li>
	                        	<c:choose>
				     				<c:when test="${user.enabled==true}"> <a class="deactivate" href="<c:url value='user.html?operation=handleActivation&userId=${user.id}'/>">Deactivate </a></c:when>
				     				<c:otherwise> <a class="activate" href="<c:url value='user.html?operation=handleActivation&userId=${user.id}'/>">Activate </a></c:otherwise>
	     						</c:choose>
	     						</li>
                      		</ul>
                    	</div>
                  	</div>
	     		</display:column>
		 	</display:table> 
			
			<br class="clear" />
		</div>
    