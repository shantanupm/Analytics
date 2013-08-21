<%@include file="../init.jsp" %>
<link rel="stylesheet" media="screen" href="<c:url value="/css/datePicker.css"/>" />

<script type="text/javascript" src="<c:url value="/js/jquery.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.validate.js"/>"></script>     
<script type='text/javascript' src="<c:url value="/js/jquery-ui-1.8.23.custom.min.js"/>"></script>

<script>
jQuery(document).ready(function(){
	//jQuery('#tabs').tabs({ selected: 2 });
	jQuery("#frmUser").validate();
	jQuery("#userName").live('blur', function(event) {
		var userName=jQuery("#userName").val();
		
		var url="/scheduling_system/user/user.html?operation=validateUserName&userName="+userName;
		
		jQuery.ajax({url:url, success:function(result){
		
		   if(result=="true"){
				jQuery("#userNameErrorDisplay").html('<p style="color: red;">Already Exist</p>');
				jQuery("#saveUser").attr('disabled','disabled');
			}else{
				jQuery("#userNameErrorDisplay").html('');
				jQuery("#saveUser").removeAttr('disabled');
			}
		  }});
	});
	
});

function checkPasswordMatch() {
    var password = jQuery("#Password").val();
    var confirmPassword = jQuery("#CPassword").val();

    if (password != confirmPassword)
    	jQuery("#pswdmismatch").html("<p style='color: red;'>Passwords do not match!</p>");
    else
    	jQuery("#pswdmismatch").html("");
}

</script>

<!-- <div id="tabs">
	<ul>
        <li><a href="#tabs-1" onclick="window.location='/scheduling_system/evaluation/admin.html?operation=viewInstitutions'">View Institutions &amp; Courses</a></li>
        <li><a href="#tabs-2" onclick="window.location='/scheduling_system/evaluation/admin.html?operation=viewTranscripts'">View Transcripts</a> </li>
        <li><a href="#tabs-3" onclick="window.location='/scheduling_system/user/user.html?operation=manageUsers'">Manage Users</a></li>
    </ul>
    <div id="tabs-1"></div>
    <div id="tabs-2"></div>
    <div id="tabs-3"> -->
    	<div class="noti-tools">
				<div class="fl">
					<div class="breadcrumb"> <a title="User list" href="user.html?operation=manageUsers">Users</a>  <c:choose><c:when test="${empty user.id}">Create User</c:when> <c:otherwise>Modify User</c:otherwise> </c:choose>
					</div>
					<br class="clear">
				</div>
				<br class="clear">
		</div>
    	 <div class="contentForm"> <strong class="orngHdng">User Details</strong><br class="clear" />
    	 <form id="frmUser" action="/scheduling_system/user/user.html?operation=saveUser" method="post">
            <div class="userDivider"></div><br />
            <label class="caption" for="FirstName">First Name:<strong class="asterisk" style="font-size:14px;">*</strong></label>
            <input name="firstName" value="${user.firstName}"  id="FirstName"type="text" class="textField required" />
            <br class="clear" />
            <label class="caption" for="lastName">Last Name:<strong class="asterisk" style="font-size:14px;">*</strong></label>
            <input name="lastName" type="text" id="lastName" value="${user.lastName}" class="textField required" />
            <br class="clear" />
             
            <label class="caption" for="emailAddress">Email Id:<strong class="asterisk" style="font-size:14px;">*</strong></label>
            <input value="${user.emailAddress}" name="emailAddress" type="text" class="textField required email" id="emailAddress" />
            <br class="clear" />
            <label class="caption">Roles:<strong class="asterisk" style="font-size:14px;">*</strong></label>
            <div class="roleListing">
            	<select  name="roleId" class="required">
						<option value="">Select a Role</option>
						<c:forEach items="${roleList}" var="role">
							<option <c:if test="${user.currentRole == role.title}"> selected="true" </c:if> value="${role.id}">${role.title}</option>
						</c:forEach>			    
				</select>
				<c:forEach items="${roleList}" var="role">
					<c:if test="${user.currentRole == role.title}"><input type="hidden" value="${role.id}" name="previousRoleId" /></c:if>
				</c:forEach>
            </div>
            <br class="clear" />
            <label class="caption" for="userName">User Name:<strong class="asterisk" style="font-size:14px;">*</strong></label>
            <input value="${user.userName}" name="userName" id="userName" type="text" class="textField required" />
            <p class="error success" id="userNameErrorDisplay" ></p>
            <br class="clear" />
           
            <label class="caption" for="Password">Password:<strong class="asterisk" style="font-size:14px;">*</strong></label>
            <input value="${user.password}" id="Password" name="password" type="password" class="textField required" /><br class="clear" />
            <br class="clear" />
            <label class="caption" for="Confirm Password">Confirm Password:<strong class="asterisk" style="font-size:14px;">*</strong></label>
            <input value="${user.password}" name="c_password" id="CPassword" type="password" class="textField required" onChange="checkPasswordMatch();" />
            <p class="error" id="pswdmismatch"></p>
            <br />
            <div class="userDivider"></div>
                 <div class="buttonRow1">
                 	<div style="float:left">
                    	<span class="asterisk"><strong>*</strong></span> <em class="captiongray">Mandatory</em> 
                    </div>
                        <input  type="submit" id="saveUser" value="&nbsp;Save&nbsp;" class="button saveButton" />
                        <input type="button" class="button cancelButton" value="&nbsp;Cancel&nbsp;" onclick="window.location='user.html?operation=manageUsers'">
                </div>
            <c:if test="${not empty user.id}">
                <input type="hidden" name="id" value="${user.id}"/>
                <input type="hidden" name="enabled" value="${user.enabled}"/>
                <input type="hidden" name="createdDate" value='<fmt:formatDate value="${user.createdDate}" pattern="MM/dd/yyyy"/> '/>
             </c:if>
            </form>
          </div>
   <!--  </div>
</div> -->