<%@include file="../init.jsp"%>
	<div class="popCont">
	<form name="selectTranscriptForm" method="post" action="launchEvaluation.html?operation=saveTranscript">
		<h1>
			<a href="#" class="close"></a>Add Transcript
		</h1>
		<label class="caption">Institution Name:</label> <input name="institute"
			type="text" class="textField big" readonly="readonly"
			value="${selectedInstitution.name}" style="border: 0px" /><br			class="clear" /> 
			<%--
			<label class="caption">Institution Program
			Name:</label> <input name="" type="text" class="textField big"
			readonly="readonly" value="${programDesc }" style="border: 0px" /><br
			class="clear" /> 
			 --%><label class="caption">TR Course ID:</label> <input
			name="trCourseId" type="text" class="textField small" value=""/><br class="clear" />

		<label class="caption">TR Course Title:</label> 
		
		<select name="selCourse" id="selCourse" >
		
			<option>Select the course</option>
			<c:forEach items="${courseList}" var="course">
				<option id="${course.clockHours}" value="${course.id}">${course.trCourseTitle}</option>
				
			</c:forEach>
		</select><br class="clear" /> <label class="caption">Course Title (If
			not present in the list):</label> <input name="" type="text"
			class="textField big" /><br class="clear" /> <label class="caption">Grade:</label>
		<input name="" type="text" class="textField small" /><br
			class="clear" /> <label class="caption">Credits:</label> <input
			name="" type="text" class="textField small" /><br class="clear" />

		<label class="caption">Hours:</label> 
		<input name="clockHours" type="text" id="clockHours"
			class="textField small" /><br class="clear" /> <label
			class="caption">Completion Date:</label> <input name="" type="text"
			class="textField small" /><br class="clear" />

		<div class="CreateSchedule">
			<input type="button" value="Add Transcript" name="Select Institution" />
		</div>
		<br class="clear" /> <br class="clear" />
		<hr />
		<br class="clear" /> <label class="">If the course is a new
			course, the course will be added to the database, which will be
			edited in Course Management.</label> <br class="clear" />

	<input type="hidden" name="expectedStartDateString" id="expectedStartDateString" value="<fmt:formatDate value='${studentCourseInfo.expectedStartDate}' pattern='yyyy-MM-dd' />" />
   	<input type="hidden" name="studentCrmId" id="studentCrmId" value="${studentCourseInfo.studentCrmId}" />
   	<input name="programVersionCode" type="hidden" value="${studentCourseInfo.programVersionCode}" />
   	<input name="programDesc" type="hidden" value="${studentCourseInfo.programDesc}" />
   	<input name="catalogCode" type="hidden" value="${studentCourseInfo.catalogCode}" />
   	<input name="stateCode" type="hidden" value="${studentCourseInfo.stateCode}" />
   	<input type="hidden" name="studentId" id="studentId" value="${studentCourseInfo.studentCrmId}" />
   	<input type="hidden" name="evaluationStatus" id="evaluationStatus" value="Unofficial" />
   	
   	</form>
	</div>


