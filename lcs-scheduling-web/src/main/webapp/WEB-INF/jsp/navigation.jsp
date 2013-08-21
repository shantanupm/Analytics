<%@include file="init.jsp" %>
<%@page import="com.ss.common.util.UserUtil"%>

<% request.setAttribute("userRoleId", UserUtil.getCurrentRole().getId());
   request.setAttribute("userCurrentId", UserUtil.getCurrentUser().getId());
%>



<!-- Navigation Start here -->
<div class="main_navigationBox">
    <ul>
   		<li id="liHome"><a href=""><em>  </em></a></li>
        <li id="liInstitution" class="disabled"><span>Institutions</span></li>
        <li id="liCourse" class="disabled"><span>Courses</span></li> 
        <li id="liTranscripts" class="disabled"><span>Transcripts</span></li>
        <li id="liUsers" class="disabled"><span>Users</span></li> 
        <li id="liEvaluator" class="disabled"><span>IE</span></li>
        <li id="liSle" class="disabled"><span>SLE</span></li> 
        <li id="liLopes" class="disabled"><span>Lopes</span></li>
    </ul>	
    <br class="clear" />
</div>

<!-- Navigation End -->
<script>

<!-- DEO -->
if('${userRoleIds}'.indexOf("1")>-1){
	jQuery("#liTranscripts").addClass('clickedState bgNone');
	jQuery("#liTranscripts").removeClass('disabled');
	jQuery("#liTranscripts").html('<span><a href="<c:url value="/evaluation/launchEvaluation.html?operation=initParams"/>">Transcripts</a></span>');
}
<!-- Admin -->
if('${userRoleIds}'.indexOf("2")>-1){
	jQuery("#liTranscripts").addClass('clickedState bgNone');
	jQuery("#liCourse").removeClass('disabled');
	jQuery("#liTranscripts").removeClass('disabled');
	jQuery("#liUsers").removeClass('disabled');
	jQuery("#liSle").removeClass('disabled');
	jQuery("#liLopes").removeClass('disabled');
	
	
	jQuery("#liInstitution").html('<span><a href="<c:url value="/evaluation/ieManager.html?operation=getInstitutionList"/>">Institutions</a></span>');
	jQuery("#liCourse").html('<span><a href="<c:url value="/evaluation/ieManager.html?operation=getCoursesForInstitution"/>">Courses</a></span>');
	jQuery("#liTranscripts").html('<span><a href="<c:url value="/evaluation/admin.html?operation=viewTranscripts"/>">Transcripts</a></span>');
	jQuery("#liUsers").html('<span><a href="<c:url value="/user/user.html?operation=manageUsers"/>">Users</a></span>');
	jQuery("#liSle").html('<span><a href="<c:url value="/evaluation/studentEvaluator.html?operation=launchTranscriptForSLEForEvaluation"/>">SLE</a></span>');
	jQuery("#liLopes").html('<span><a href="<c:url value="/evaluation/launchEvaluation.html?operation=launchTranscriptForLOPESForEvaluation"/>">Lopes</a></span>');
	
}
<!-- SLE -->
if('${userRoleIds}'.indexOf("3")>-1){
	jQuery("#liSle").addClass('clickedState bgNone');
	jQuery("#liSle").removeClass('disabled');
	jQuery("#liSle").html('<span><a href="<c:url value="/evaluation/studentEvaluator.html?operation=launchTranscriptForSLEForEvaluation"/>">SLE</a></span>');
}
<!-- IE -->
if('${userRoleIds}'.indexOf("4")>-1){
	jQuery("#liEvaluator").addClass('clickedState bgNone');
	jQuery("#liInstitution").removeClass('disabled');
	jQuery("#liCourse").removeClass('disabled');
	jQuery("#liInstitution").html('<span><a href="<c:url value="/evaluation/ieManager.html?operation=getInstitutionList"/>">Institutions</a>');
	jQuery("#liCourse").html('<span><a href="<c:url value="/evaluation/ieManager.html?operation=getCoursesForInstitution"/>">Courses</a></span>');
	jQuery("#liEvaluator").html('<span><a href="<c:url value="/evaluation/quality.html?operation=ieEvaluate"/>">IE</a></span>');
}
<!-- LOPES -->
if('${userRoleIds}'.indexOf("5")>-1){
	jQuery("#liLopes").addClass('clickedState bgNone');
	jQuery("#liLopes").removeClass('disabled');
	jQuery("#liLopes").html('<span><a href="<c:url value="/evaluation/launchEvaluation.html?operation=launchTranscriptForLOPESForEvaluation"/>">Lopes </a></span>');
}
<!-- IEM -->
if('${userRoleIds}'.indexOf("6")>-1){
	jQuery("#liInstitution").addClass('clickedState bgNone');
	jQuery("#liInstitution").removeClass('disabled');
	jQuery("#liCourse").removeClass('disabled');
	jQuery("#liHome").html('<span><a href="<c:url value="/evaluation/ieManager.html?operation=iemHomePage"/>"><em></em></a>');
	jQuery("#liInstitution").html('<span><a href="<c:url value="/evaluation/ieManager.html?operation=getInstitutionList"/>">Institutions</a>');
	jQuery("#liCourse").html('<span><a href="<c:url value="/evaluation/ieManager.html?operation=getCoursesForInstitution"/>">Courses</a></span>');
}
var reQurl=window.location.href;
jQuery("ul li").removeClass('clickedState bgNone');

if(reQurl.indexOf("operation=getCoursesForInstitution") > 0||reQurl.indexOf("ieManager.html?operation=createCourse") > 0
	|| reQurl.indexOf("ieManager.html?operation=ieCourse") > 0 || reQurl.indexOf("ieManager.html?operation=manageCourseTitles") > 0
	|| reQurl.indexOf("ieManager.html?operation=manageCourseRelationship") > 0 || reQurl.indexOf("ieManager.html?operation=manageCourseCtgRelationship") > 0
	|| reQurl.indexOf("ieManager.html?operation=ieSaveCourse") > 0 || reQurl.indexOf("ieManager.html?operation=ieSaveTransferCourse") > 0 
	|| reQurl.indexOf("ieManager.html?operation=conflictCourse") > 0
	|| reQurl.indexOf("ieManager.html?operation=summaryCourse") > 0){
	
	jQuery("#liCourse").addClass('clickedState bgNone');
}else if(reQurl.indexOf("ieManager.html") > 0){
	jQuery("#liInstitution").addClass('clickedState bgNone');
}else if(reQurl.indexOf("launchEvaluation.html?operation=launchTranscriptForLOPESForEvaluation") > 0){
	jQuery("#liLopes").addClass('clickedState bgNone');
}else if(reQurl.indexOf("launchEvaluation.html") > 0){
	jQuery("#liTranscripts").addClass('clickedState bgNone');
}else if(reQurl.indexOf("user.html") > 0){
	jQuery("#liUsers").addClass('clickedState bgNone');
}else if(reQurl.indexOf("quality.html") > 0){
	jQuery("#liEvaluator").addClass('clickedState bgNone');
}else if(reQurl.indexOf("studentEvaluator.html") > 0){
	jQuery("#liSle").addClass('clickedState bgNone');
} else if(reQurl.indexOf("admin.html?operation=viewTranscripts") > 0){
	jQuery("#liTranscripts").addClass('clickedState bgNone');
} 


</script>