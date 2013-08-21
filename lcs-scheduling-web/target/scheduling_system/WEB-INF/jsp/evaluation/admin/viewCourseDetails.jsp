<%@include file="../../init.jsp" %>

<!-- <link rel="stylesheet" href="<c:url value="/css/jquery.ui.all.css"/>" /> -->
<link rel="stylesheet" media="screen" href="<c:url value="/css/datePicker.css"/>" />

<script type="text/javascript" src="<c:url value="/js/jquery.js"/>"></script>     
<script type='text/javascript' src="<c:url value="/js/jquery.ui.core.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.widget.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.position.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.autocomplete.js"/>"></script>  
<script type="text/javascript" src="<c:url value="/js/jquery.validate.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery-ui-1.8.23.custom.min.js"/>"></script>


<c:set var="relationLink" scope="session" value="/scheduling_system/evaluation/admin.html?operation=manageCourseRelationship&transferCourseId=${transferCourse.id}"/>
<c:set var="catRelationLink" scope="session" value="/scheduling_system/evaluation/admin.html?operation=manageCourseCtgRelationship&transferCourseId=${transferCourse.id}"/>

<table width="100%" border="0" align="center" cellpadding="0"
		cellspacing="0">
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr>
			<td width="49%" valign="top">
				<div class="contentForm">
					<label class="caption"><strong>School Code:</strong> </label> 
					<input id="schoolcode" name="schoolcode"
						 readonly='readonly' value="${transferCourse.institution.schoolcode}" type="text" class="textField w160 required" /> 
						 <br class="clear" /> 
					
					<label class="caption"><strong>School Title:</strong> </label> 
					<input id="schoolTitle" name="schoolTitle"
						 readonly='readonly' value="${transferCourse.institution.name}" type="text" class="textField w160 required" /> 
						 <br class="clear" /> 
						 	
						
					<label class="caption"><strong>TR Course Code:</strong> </label> 
					<input name="trCourseCode" type="text" value="${transferCourse.trCourseCode}"	class="textField w160 required"  readonly='readonly'/>
					<br class="clear" />
					  
					<label class="caption"><strong>Course Title:</strong> </label> 
					<input name="trCourseTitle" type="text" value="${transferCourse.trCourseTitle}"	class="textField w160 required"  readonly='readonly' />
					<br class="clear" />
					
					<label class="caption"><strong>Transcript Credits:</strong> </label> 
					<input name="transcriptCredits" type="text" value="${transferCourse.transcriptCredits}" onchange="evalSemEq(this);"	
					class="textField w160 required number"  readonly='readonly'/>
					<br class="clear" />
					
					<label class="caption"><strong>Semester Credits:</strong> </label> 
					<input name="semesterCredits" type="text" value="${transferCourse.semesterCredits}" readonly="true"	class="textField w160"  readonly='readonly'/>
					<br class="clear" />
					
					<label class="caption"><strong>Pass/Fail:</strong> </label> 
					<input name="passFail" type="checkbox"	 disabled="disabled" <c:if test="${transferCourse.passFail}">  checked </c:if> />
					<br class="clear" />
					
						<label class="caption"><strong>Requires College Approval:</strong> </label> 
						<input type="checkbox" name="collegeApprovalRequired"  disabled="disabled" <c:if test="${transferCourse.collegeApprovalRequired}">  checked </c:if> />
						<br class="clear" />
					
					
				</div>
			</td>
			<td width="2%" class="brdLeftDotted">&nbsp;</td>
			<td width="49%" valign="top">
				<div class="contentForm">
					<label class="caption"><strong>Minimum Grade:</strong> </label> 
					<input name="minimumGrade" type="text" value="${transferCourse.minimumGrade}" class="textField w160 required number"  readonly='readonly'/>
					<br class="clear" />
					
					<label class="caption"><strong>Course Level:</strong> </label> 
					<select  name="courseLevelId" class=" w160"  disabled="disabled">
                    <option id="" value="">Select Course Level</option>
                    <c:forEach items="${gcuCourseLevelList}" var="gcuCourseLevel">
						<option <c:if test="${transferCourse.courseLevelId == gcuCourseLevel.name}"> selected="true" </c:if> value="${gcuCourseLevel.name}">${gcuCourseLevel.name}</option>
					</c:forEach>	
                </select>
					<br class="clear" />
					
					<label class="caption"><strong>Clock  Hours:</strong> </label> 
					<input name="clockHours" type="text" value="${transferCourse.clockHours}" class="textField w160 required number"  readonly='readonly'/>
					<br class="clear" />
					
					<label class="caption"><strong>Effective Date:</strong> </label> 
					<input name="effectiveDate" type="text"  readonly='readonly' value='<fmt:formatDate value="${transferCourse.effectiveDate}" pattern="MM/dd/yyyy"/>' 
					class="textField w160 maskDate required" />
					<br class="clear" />
					
					<label class="caption"><strong>End Date:</strong> </label> 
					<input name="endDate" type="text"  readonly='readonly' value='<fmt:formatDate value="${transferCourse.endDate}" pattern="MM/dd/yyyy"/>' 
					class="textField w160 maskDate required" />
					<br class="clear" />
					
					<label class="caption"><strong>Catalog Course Description:</strong> </label> 
					<textarea  name="catalogCourseDescription" rows="3" class="textField w160" cols="20"  readonly='readonly'> ${transferCourse.catalogCourseDescription} </textarea>
					<br class="clear" />
					
					<label class="caption"><strong>Transfer Status:</strong> </label> 
					<select id="transferStatus" name="transferStatus"  disabled="disabled">
                        <option>Eligible</option>
                        <option>Not Eligible</option>
                        <option>Pending Evaluation</option>
                        
                    </select>
					<br class="clear" />
					
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="3" valign="top">
				<input type="hidden" name="id" value="${transferCourse.id}">
	           	<input name="createdDateTime" id="createdDateTime" type="hidden"  value='<fmt:formatDate value="${transferCourse.createdDateTime}" pattern="MM/dd/yyyy"/>'   />
	           	<input name="createdBy" id="createdBy" type="hidden" value="${transferCourse.createdBy}"   />
	           	<input name="checkedDate" id="checkedDate" type="hidden"  value='<fmt:formatDate value="${transferCourse.checkedDate}" pattern="MM/dd/yyyy"/>'   />
	           	<input name="checkedBy" id="checkedBy" type="hidden" value="${transferCourse.checkedBy}"   />
	           	<input name="modifiedBy" id="modifiedBy" type="hidden" value="${transferCourse.modifiedBy}"   />
	           	<input name="institutionMirrorId" id="institutionMirrorId" type="hidden" value="${institutionMirror.id}"   />
	           	<input type="hidden" name="transferCourseMirrorId" value="${transferCourseMirrorId}">
	           	<input type="hidden" name="institutionId" value="${transferCourse.institution.id}">
			</td>
		</tr>
		<tr>
			<td colspan="3" valign="top">&nbsp;</td>
		</tr>
	</table>
	
	
<!--	
<center>	
<div class="tblFormDiv divCover outLine">

        <table class="tableForm" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <th class="heading" colspan="2"><strong> Evaluate Course</strong></th>
            </tr>
			
			<tr><td colspan="2"></td></tr>
            <tr>
                <td width="35%">School Code</td>
                <td width="65%">
                <input name="schoolCode"  id="schoolCode"type="text"  disabled='disabled' value="${transferCourse.institution.schoolcode}" class="textField smallread" /><br class="clear" /></td>
            </tr>
            <tr>
                <td>TR Course Code</td>
                <td><input name="trCourseCode" type="text" disabled='disabled' value="${transferCourse.trCourseCode}" class="textField small required" /><br class="clear" /></td>
            </tr>
            <tr>
                <td>TR Course Title</td>
                <td><input name="trCourseTitle" type="text" disabled='disabled' value="${transferCourse.trCourseTitle}" class="textField big  required"  /><br class="clear" /></td>
            </tr>
            <tr>
                <td>Transcript Credits</td>
                <td><input name="transcriptCredits" type="text" disabled='disabled' value="${transferCourse.transcriptCredits}" class="textField small"  /><br class="clear" /></td>
            </tr>
            <tr>
                <td>Semester Credits</td>
                <td><input name="semesterCredits" type="text" disabled='disabled' value="${transferCourse.semesterCredits}" class="textField smallread"  /><br class="clear" /></td>
            </tr>
            <tr>
                <td>Pass/Fail</td>
                <td><input name="passFail" type="checkbox" disabled='disabled' value="${transferCourse.passFail}" class="textField smallread" /></td>
            </tr>
            <tr>
                <td>Minimum Grade</td>
                <td><input name="minimumGrade" type="text" disabled='disabled' value="${transferCourse.minimumGrade}" class="textField Small2" value="C" /></td>
            </tr>
            <tr>
                <td>Course Level</td>
                <td>
                   ${transferCourse.courseLevelId }
                   <br class="clear" />
                </td>
            </tr>
            <tr>
                <td>Clock  Hours</td>
                <td><input name="clockHours" disabled='disabled'  value="${transferCourse.clockHours}" type="text" class="textField small" /></td>
            </tr>
            <tr>
                <td>Effective Date</td>
                <td><input name="effectiveDate" disabled='disabled' value='<fmt:formatDate value="${transferCourse.endDate}" pattern="MM/dd/yyyy"/>' type="text" class="textField small maskDate" /><br class="clear" /></td>
            </tr>
            <tr>
                <td>End Date</td>
                <td><input name="endDate" type="text" disabled='disabled' value='<fmt:formatDate value="${transferCourse.endDate}" pattern="MM/dd/yyyy"/>' class="textField small maskDate" /><br class="clear" /></td>
            </tr>
            <tr>
                <td>Catalog Course Description</td>
               <td>
				<textarea  name="catalogCourseDescription" disabled='disabled'  rows="3" cols="40"> ${transferCourse.catalogCourseDescription} </textarea>
				</td>
                
            </tr>
            <tr>
                <td>Transfer Status</td>
                <td>
					${transferCourse.transferStatus }
                </td>
            </tr>
            
            
<tr><td></td><td></td></tr>
        </table>
        <table class="" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <td width="35%"> </td>
                <td width="65%" align="right" style="padding-top:10px;padding-right:10px;">
                
                	<input type="hidden" name="id" value="${transferCourse.id}">
                	<input name="createdDateTime" id="createdDateTime" type="hidden"  value='<fmt:formatDate value="${transferCourse.createdDateTime}" pattern="MM/dd/yyyy"/>'   />
                	<input name="createdBy" id="createdBy" type="hidden" value="${transferCourse.createdBy}"   />
                	<input name="checkedDate" id="checkedDate" type="hidden"  value='<fmt:formatDate value="${transferCourse.checkedDate}" pattern="MM/dd/yyyy"/>'   />
                	<input name="checkedBy" id="checkedBy" type="hidden" value="${transferCourse.checkedBy}"   />
                	<input name="modifiedBy" id="modifiedBy" type="hidden" value="${transferCourse.modifiedBy}"   />
                	<input name="institutionMirrorId" id="institutionMirrorId" type="hidden" value="${institutionMirror.id}"   />
                	<input type="hidden" name="transferCourseMirrorId" value="${transferCourseMirrorId}">
                	<input type="hidden" name="institutionId" value="${transferCourse.institution.id}">
                </td>
            </tr>
        </table>
        <br  />
    
        
            <table class="" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <td align="center">
               		<c:if test="${not empty transferCourse.id}"> 
	                    <input type="button" id="courseRelationship" value="Course Relationship" class="button" 
	                    onclick='window.location = "${relationLink}"'  />
	                    <input type="button" id="courseCatRelationship" value="Course Category Relationship" class="button" 
	                    onclick='window.location = "${catRelationLink}"'  />
                 	</c:if>
                </td>
				<td>
					<input type="button" value="Back To Course List" onclick='window.location = "/scheduling_system/evaluation/admin.html?operation=viewCourses&institutionId=${transferCourse.institution.id}"' class="button" />
				</td>
            </tr>
        </table>
        <br  />
    </div>
</center>   -->