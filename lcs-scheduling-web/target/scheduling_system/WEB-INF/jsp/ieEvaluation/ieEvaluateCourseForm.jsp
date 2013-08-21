<%@include file="../init.jsp" %>
<c:choose>
	<c:when test="${userRoleName eq 'Institution Evaluation Manager' || userRoleName eq 'Administrator'}">
	
		<c:set var="actionCourseLink" scope="session"
			value="/evaluation/ieManager.html?operation=ieSaveTransferCourse&directLink=${directLink }" />
		
			
		<c:choose>
			<c:when test="${! empty transferCourse.id}">
				<c:set var="courseDetailLink" scope="session" value="/evaluation/ieManager.html?operation=ieCourse&transferCourseId=${transferCourse.id}&institutionId=${transferCourse.institution.id }" />
		
				<c:set var="relationLink" scope="session" value="/evaluation/ieManager.html?operation=manageCourseRelationship&transferCourseId=${transferCourse.id}" />
				<c:set var="markCompleteLinkCourse" scope="session" value="/evaluation/ieManager.html?operation=summaryCourse&transferCourseId=${transferCourseId}" />
			</c:when>
			<c:otherwise>
				<c:set var="relationLink" scope="session" value="" />
				<c:set var="markCompleteLinkCourse" scope="session" value="" />
			</c:otherwise>
		</c:choose>
		
		<c:set var="catRelationLink" scope="session"
			value="/evaluation/ieManager.html?operation=manageCourseCtgRelationship&transferCourseId=${transferCourse.id}" />
		<c:set var="titleLink" scope="session"
			value="/evaluation/ieManager.html?operation=manageCourseTitles&transferCourseId=${transferCourse.id}" />
		
		
	</c:when>
	<c:otherwise>
		
		<c:set var="courseDetailLink" scope="session"
			value="/evaluation/quality.html?operation=ieCourse&institutionMirrorId=${institutionMirrorId }&transferCourseId=${transferCourseId}" />
		<c:set var="actionCourseLink" scope="session"
			value="/evaluation/quality.html?operation=ieSaveCourse&directLink=${directLink }" />
		<c:choose>
			<c:when test="${! empty transferCourseMirrorId}">
				<c:if test="${! empty transferCourse && transferCourse.transferStatus eq 'Eligible' }">
					<c:set var="relationLink" scope="session" value="/evaluation/quality.html?operation=manageCourseRelationship" />
				</c:if>
				<c:if test="${! empty transferCourse && transferCourse.transferStatus eq 'Not Eligible' }">
					<c:set var="relationLink" scope="session" value="" />
				</c:if>
				<c:set var="markCompleteLinkCourse" scope="session" value="/evaluation/quality.html?operation=markCompletePreviewCourse&transferCourseMirrorId=${transferCourseMirrorId}" />
			</c:when>
			<c:when test="${empty transferCourseMirrorId && ! empty transferCourse.id && fn:toUpperCase(transferCourse.evaluationStatus) eq 'EVALUATED'}">
				<c:set var="relationLink" scope="session" value="/evaluation/ieManager.html?operation=manageCourseRelationship&transferCourseId=${transferCourse.id}" />
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
				 		<c:choose>
				        	<c:when test="${tabIndex=='1'}">
				        		<%@include file="ieCourse.jsp" %>
				        	</c:when>
				        	<c:when test="${tabIndex=='2'}">
				        		<%@include file="ieManageCourseRelationship.jsp" %>
				        	</c:when>
				        	<c:when test="${tabIndex=='3'}">
				        		<%@include file="ieManageCourseCtgRelationship.jsp" %>
				        	</c:when>
				        	<c:when test="${tabIndex=='4'}">
				        		<%@include file="ieManageCourseTitles.jsp" %>
				        	</c:when>
				        	<c:when test="${tabIndex=='5'}">
				        		<%@include file="ieMarkCompletePreviewCourse.jsp" %>
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
