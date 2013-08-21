<%@include file="../init.jsp" %>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>
<link rel="stylesheet" href="../css/displaytag.css" type="text/css"> 
<script type='text/javascript' src="<c:url value="/js/jquery-1.8.0.min.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery-ui-1.8.23.custom.min.js"/>"></script>

<script>
jQuery(document).ready(function(){
	jQuery('#tabs').tabs({ selected: 1 });		
	jQuery("#status").val('${status}')
	jQuery("#status").change(function(){
		window.location.href='ieManager.html?operation=getCoursesForInstitution&institutionId=${institution.id}&status='+jQuery(this).val();
	});
});
</script>

<div id="tabs">
    <%-- <ul>
        <li><a href="#tabs-1" onclick="window.location='/scheduling_system/evaluation/ieManager.html?operation=managerEvaluationView'">Conflict List</a> <span class="notification">${conflictCount}</span></li>
        <li><a href="#tabs-2" >College/Courses Approval</a> <span class="notification">${requiredApprovalCount}</span></li>
        <li><a href="#tabs-3" onclick="window.location='/scheduling_system/evaluation/ieManager.html?operation=getInstitutionList&status=EVALUATED'">Manage Institutions/Courses</a></li>
        <li><a href="#tabs-4" onclick="window.location='/scheduling_system/evaluation/ieManager.html?operation=getCoursesForReAssignment'">Reassign</a></li>
    </ul>  --%><%@include file="../tabsNavigation.jsp" %>
	  <div id="tabs-1"></div>
	  <div id="tabs-2">
	   <br class="clear">
	  <div class="noti-bordr">
             <br />
            
          <table width="100%" cellspacing="0" cellpadding="0" border="0" class="noti-tbl brdTop">
            <tbody>
              <tr>
                <th width="8%" scope="col" class="dividerGrey"><span>Sr.No</span></th>
                <th width="8%" scope="col" class="dividerGrey"><span>Course Code</span></th>
                <th width="84%" scope="col" class="dividerGrey"><span >Course Title</span></th>
                
                
              </tr>
			
    <c:choose>
        <c:when test="${fn:length(courses)>0}">
			<c:forEach items="${courses}" var="course" varStatus="index">
              <tr>
                <td valign="top"><span>${index.count}</span></td>
                
                <td valign="top">${course.trCourseCode}</td>
                <td valign="top"><a href="ieManager.html?operation=editCourseForApproval&transferCourseId=${course.id}">${course.trCourseTitle}</a></td>
              </tr>
			   </c:forEach>
			   
			</c:when>
	    <c:otherwise>
		<tr> <td class="table-content" colspan="3">No Courses<td>
		</tr>
	    </c:otherwise>
    </c:choose>
             
         
            </tbody>
          </table>
        </div>
	  
	  
	  
<!-- 	  
<center>
<div class="tblFormDiv divCover outLine"  >

All Courses For College Approval	<br><br>




 
<table width="100%"  cellspacing="1"  border="1" style="border-collapse: collapse;" cellpadding="0" class="">
		<tr>
    	  	<th class="heading">&nbsp;Sr.No</th>
	  		<th class="heading">&nbsp;Course Code</th>
	  		<th class = "heading">&nbsp;Course Title</th>
    	</tr>

	
    	<c:forEach items="${courses}" var="course" varStatus="index">
    	
    		<tr>
    		<td align="left" valign="top" class="table-content">${index.count}</td>
    		<td align="left" valign="top" class="table-content">${course.trCourseCode}</td>
    		<td align="left" valign="top" class="table-content"><a href="ieManager.html?operation=editCourseForApproval&transferCourseId=${course.id}">${course.trCourseTitle}</a></td>
    		</tr>
    		
    	</c:forEach>
    	
	</table>


<table>
<tr>

<td ><input type="button" value="Home Page"  onclick='window.location = "/scheduling_system/evaluation/ieManager.html?operation=managerEvaluationView"' class="button" /></td>


</tr>
</table>
</div>
</center> -->
</div>
<div id="tabs-3"></div>
</div>
