<%@include file="../init.jsp" %>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>
<script type='text/javascript' src="<c:url value="/js/jquery-1.8.0.min.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery-ui-1.8.23.custom.min.js"/>"></script>

<script type="text/javascript">
function getAssignees(institutionId) {
	
	 var url="<c:url value='ieManager.html?operation=getInstitutionAssignDetails&institutionId="+institutionId+"'/>";
	
	Boxy.load(url,
	{ unloadOnHide : true	
	});
	
	
}
jQuery(document).ready(function(){
	jQuery('#tabs').tabs({ selected: 3 });		
	
	jQuery('.subtab1').hover(
			function() { jQuery(this).addClass('subtabhover1'); },
			function() { jQuery(this).removeClass('subtabhover1'); }
		);
	
});
</script>
<div id="tabs">
   <%--  <ul>
        <li><a href="#tabs-1" onclick="window.location='/scheduling_system/evaluation/ieManager.html?operation=managerEvaluationView'">Conflict List</a> <span class="notification">${conflictCount}</span></li>
        <li><a href="#tabs-2" onclick="window.location='/scheduling_system/evaluation/ieManager.html?operation=getCoursesForApproval'">College/Courses Approval</a> <span class="notification">${requiredApprovalCount}</span></li>
        <li><a href="#tabs-3" onclick="window.location='/scheduling_system/evaluation/ieManager.html?operation=getInstitutionList&status=EVALUATED'">Manage Institutions/Courses</a></li>
        <li><a href="#tabs-4" onclick="window.location='/scheduling_system/evaluation/ieManager.html?operation=getCoursesForReAssignment'">Reassign</a></li>
    </ul> --%>
    <%@include file="../tabsNavigation.jsp" %>
	  <div id="tabs-1"></div>
	  <div id="tabs-2"></div>
	  <div id="tabs-3"></div>
	  <div id="tabs-4">
	   <div style="height:20px; background-color:aliceBlue;font-size:13px;font-weight:bold;padding:7px;">
	  <table style="width:90%;background:none;" >
	  	<tr>
	  		<td style="width:51%"></td>
	  		<td style="width:49%"><span><a class="subtab1" href="<c:url value='ieManager.html?operation=getCoursesForReAssignment'/>"><img width="16" height="14" alt="course" src="../images/course.png"> Course</a> | <a class="subtabselected1" href="<c:url value='ieManager.html?operation=getInstitutionsForReassignment'/>"><img width="17" height="17" alt="institution" src="../images/institution.png"> Institution</a></span></td>
	  	</tr>
	  </table>
	  
	  </div>
	  <div style="color:#B63300; padding:11px 0px 0px 22px;font-size:14px">
	   		<span><strong>Re-Assignable Institutions</strong></span>
	   </div>
	  <div class="noti-bordr">
             <br />
            
    <display:table name="institutionReAssignList"   class="noti-tbl" id="institution" pagesize="10"   requestURI="ieManager.html" export="false" sort="external">  
 	<display:column title="Sr. No."   headerClass="thW08"  value="${institution_rowNum}"/> 
    <display:column property="schoolcode" title="<span class='sort_d' style='color: black;' >Institution Code</span>" headerClass="dividerGrey thW20" sortable="true"  />
     <display:column property="name"  title="Institution Name"  headerClass="dividerGrey p05 thW20" />
     <display:column title="evaluator1" headerClass="dividerGrey thW20" value="${institution.evaluator1.firstName} ${institution.evaluator1.lastName}"/>
     <display:column title="evaluator2" headerClass="dividerGrey thW20" value="${institution.evaluator2.firstName} ${institution.evaluator2.lastName}"/> 
     <display:column headerClass="dividerGrey thW10" title="action"><a href="javascript:void(0)" onclick="getAssignees('${institution.id}');"> re-assign</a></display:column>     
	 
	</display:table> 

        </div>
 
  <br/>
</div>


<%-- 
<center>
<div class="tblFormDiv divCover outLine"  >
List of Re-Assignable Courses	<br><br>
<div class="" >   

<br class="clear" />
 <display:table name="courseReAssignList"  id="course" pagesize="10"   requestURI="ieManager.html" export="false" sort="external">  
 	<display:column title="Sr. No."   headerClass="heading"  value="${course_rowNum}"/> 
    <display:column property="trCourseCode" title="Course Code"  sortable="true"  />
     <display:column property="trCourseTitle" style="width:500px" title="Course Title" headerClass="heading" />
     <display:column title="evaluator1" headerClass="heading" value="${course.evaluator1.firstName} ${course.evaluator1.lastName}"/>
     <display:column title="evaluator2" headerClass="heading" value="${course.evaluator2.firstName} ${course.evaluator2.lastName}"/> 
     <display:column headerClass="heading" title="action"><a href="javascript:void(0)" onclick="getAssignees('${course.id}');"> re-assign</a></display:column>     
	 
</display:table> 


</div>
<table>
<tr>

<td width=27%><input type="button" value="Home Page"  onclick='window.location = "/scheduling_system/evaluation/ieManager.html?operation=managerEvaluationView"' class="button" /></td>

</tr>
</table>
</div>
</center> --%>