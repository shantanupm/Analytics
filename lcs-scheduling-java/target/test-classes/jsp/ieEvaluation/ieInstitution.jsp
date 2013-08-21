<%@include file="../init.jsp" %>



<link rel="stylesheet" href="<c:url value="/css/jquery.ui.all.css"/>" />
<script type="text/javascript" src="<c:url value="/js/jquery.validate.js"/>"></script>

<script type='text/javascript' src="<c:url value="/js/jquery.maskedinput-1.3.js"/>"></script> 



<script type="text/javascript">
	jQuery(document).ready(function(){

	
	/* jQuery('#tabs').tabs({ selected: 2 });*/
	}); 

</script>
 	<c:set var="institutionDetail" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=createInstitution&institutionId=${institutionId}"/>   
 	<c:set var="actionLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=ieSaveInstitution"/>
	<c:set var="aBodyLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=manageAccreditingBody&institutionId=${institutionId}"/>
 	<c:set var="termTypeLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=manageInstitutionTermType&institutionId=${institutionId}"/>
 	<c:set var="transcriptKeyLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=manageInstitutionTranscriptKey&institutionId=${institutionId}"/>
 	<c:set var="markCompleteLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=summaryInstitution&institutionId=${institutionId}"/>	
 		
<c:choose>
	<c:when test="${userRoleName eq 'Institution Evaluation Manager' || userRoleName eq 'Administrator'}">
	
		
		<c:set var="actionCourseLink" scope="session"
			value='/evaluation/ieManager.html?operation=ieSaveTransferCourse&directLink=${directLink }'/>
			
		<c:choose>
			<c:when test="${! empty transferCourseId}">
				<c:set var="courseDetailLink" scope="session" value="/evaluation/ieManager.html?operation=ieCourse&transferCourseId=${transferCourseId}&institutionId=${institutionId }" />
				<c:set var="relationLink" scope="session" value="/evaluation/ieManager.html?operation=manageCourseRelationship&transferCourseId=${transferCourseId}" />
				<c:set var="markCompleteLinkCourse" scope="session" value="/evaluation/ieManager.html?operation=summaryCourse&transferCourseId=${transferCourseId}" />
			</c:when>
			<c:otherwise>
				<c:set var="courseDetailLink" scope="session" value="" />
				<c:set var="relationLink" scope="session" value="" />
				<c:set var="markCompleteLinkCourse" scope="session" value="" />
			</c:otherwise>
		</c:choose>
		
		<c:set var="catRelationLink" scope="session"
			value="/scheduling_system/evaluation/ieManager.html?operation=manageCourseCtgRelationship&transferCourseId=${transferCourseId}" />
		<c:set var="titleLink" scope="session"
			value="/scheduling_system/evaluation/ieManager.html?operation=manageCourseTitles&transferCourseId=${transferCourseId}" />
		
		
	</c:when>
	<c:otherwise>
		<c:set var="courseDetailLink" scope="session"
			value="/evaluation/quality.html?operation=ieCourse&institutionMirrorId=${institutionMirrorId }&transferCourseId=${transferCourseId}" />
		<c:set var="actionCourseLink" scope="session"
			value="/evaluation/quality.html?operation=ieSaveCourse&directLink=${directLink }" />
		
		
		<c:choose>
			<c:when test="${! empty transferCourseMirrorId}">
				<c:set var="relationLink" scope="session" value="/evaluation/quality.html?operation=manageCourseRelationship&transferCourseMirrorId=${transferCourseMirrorId}" />
				<c:set var="markCompleteLinkCourse" scope="session" value="/evaluation/quality.html?operation=markCompletePreviewCourse&transferCourseMirrorId=${transferCourseMirrorId}" />
			</c:when>
			<c:when test="${empty transferCourseMirrorId && ! empty transferCourseId}">
				<c:set var="relationLink" scope="session" value="/evaluation/ieManager.html?operation=manageCourseRelationship&transferCourseId=${transferCourseId}" />
				<c:set var="markCompleteLinkCourse" scope="session" value="/evaluation/ieManager.html?operation=summaryCourse&transferCourseId=${transferCourseId}" />
			</c:when>
			<c:otherwise>
				<c:set var="relationLink" scope="session" value="" />
				<c:set var="markCompleteLinkCourse" scope="session" value="" />
			</c:otherwise>
		</c:choose>
		
		<c:set var="catRelationLink" scope="session"
			value="/evaluation/quality.html?operation=manageCourseCtgRelationship&transferCourseMirrorId=${transferCourseMirrorId}" />
		<c:set var="titleLink" scope="session"
			value="/evaluation/quality.html?operation=manageCourseTitles&transferCourseMirrorId=${transferCourseMirrorId}" />
		<c:set var="titleLink" scope="session"
			value="/evaluation/quality.html?operation=manageCourseTitles&transferCourseMirrorId=${transferCourseMirrorId}" />
		
	</c:otherwise>
</c:choose>
	





	
  
	  

 <div class="stateCollege">
            <div>
           
            <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" class="mb10">
              <tr>
              <td align="left" valign="top">
                	<div style="border:1px solid #e7e7e7; border-top:none;">
                	<div class="deo2">
                	<div style="padding-top:10px;">
						<div class="institute">
						<div class="">
                	<!-- Include Jsp -->
                	<c:choose>
	                	<c:when test="${tabIndex=='1'}">
	                		<%@include file="institutionEvaluate.jsp" %>
	                	</c:when>
	                	<c:when test="${tabIndex=='2'}">
	                		<%@include file="ieManageAccreditingBody.jsp" %>
	                	</c:when>
	                	<c:when test="${tabIndex=='3'}">
	                		<%@include file="ieManageInstitutionTermType.jsp" %>
	                	</c:when>
	                	<c:when test="${tabIndex=='4'}">
	                		<%@include file="ieManageInstitutionTranscriptKey.jsp" %>
	                	</c:when>
	                	<c:when test="${tabIndex=='5'}">
	                		<%@include file="ieManageArticulationAgreement.jsp" %> 
	                	</c:when>
	                	<c:when test="${tabIndex=='6'}">
	                		<%@include file="../course/courseList.jsp" %>
	                	</c:when>
	                	<c:when test="${tabIndex=='7'}">
	                		<%@include file="ieCourse.jsp" %>
	                	</c:when>
	                	<c:when test="${tabIndex=='8'}">
	                		<%@include file="ieManageCourseRelationship.jsp" %>
	                	</c:when>
	                	<c:when test="${tabIndex=='9'}">
	                		<%@include file="ieManageCourseCtgRelationship.jsp" %>
	                	</c:when>
	                	<c:when test="${tabIndex=='10'}">
	                		<%@include file="ieManageCourseTitles.jsp" %>
	                	</c:when> 
	                	
                	</c:choose>
                	
                	
                  	</div>
                  	</div>
                  	</div>
                  	</div>
                  	</div>
                  	
                </td>
              </tr>
            </table>
			
        </div>

</div>
