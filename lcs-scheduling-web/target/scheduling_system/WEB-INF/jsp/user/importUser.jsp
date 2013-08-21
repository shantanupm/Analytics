<%@include file="../init.jsp" %>
<div class="popCont popUpsm">
	<h1><a href="#"  onclick='window.location="<c:url value='/user/user.html?operation=manageUsers'/>"' class="close"></a> Import User</h1>
	<form id="frmImportUser" action="<c:url value='/user/user.html?operation=importUser'/>" method="post" name="frmImportUser" enctype="multipart/form-data" target='iframe_user'>
		<div class="captiongray"><em>Users can be batch created by uploading a Excel file containing the 
		following information in sequential columns - First Name, Last Name, Username,  
		Password, Role; as available in the template file below.</em></div><br /><br class="clear" />
		<a class="atchmnt" href="<c:url value="/static/Template File - Import User.xlsx"/>"> Template File - Import User.xlsx</a><br class="clear" /><br />
 		<label class="caption caption3">Upload File:</label><input size="48" type="file" style="width:360px;" name="uploaded" class="required" accept="xlsx"/><br class="clear" />
 		<label class="error" style="margin:0;display:none;" id="importError">
 		<fmt:message key='user.importuser.errormessage'/></label><br class="clear" />
 		<div class="divider"></div>
 		<!-- <div class="DecrbBox DecrbBoxInr" style="" id="importLogBox"></div> -->
 		<iframe name="iframe_user" id="iframe_user" src="javascript:false;" style="display: none;" ></iframe>
 		<div align="right">
 			<span class="processingRequest greenTxt" style="display: none;" id="processingRequestSpan">
 			<img src="<c:url value="/images/smallLoader.gif"/>" class="smallLoader"> 
 			<fmt:message key="processingrequest"/> </span>
			<input name="importUserBtn" type="submit" class="button" value="Import" id="importUserBtn"/>
		    <input name="cancelBtn" type="button" onclick='window.location="<c:url value='/user/user.html?operation=manageUsers'/>"' class="button close" value="Cancel" id="cancelBtn"/> 
		    <input type="button" class="button" id="impClsBtn" value="View Log" />
		</div>
	</form>
	
</div>