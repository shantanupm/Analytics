<%@include file="../init.jsp" %>

<%-- <link rel="stylesheet" href="<c:url value="/css/jquery.ui.all.css"/>" /> --%>
<link rel="stylesheet" media="screen" href="<c:url value="/css/datePicker.css"/>" />

<script type="text/javascript" src="<c:url value="/js/jquery.js"/>"></script>     
<script type='text/javascript' src="<c:url value="/js/jquery.ui.core.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.widget.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.position.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.autocomplete.js"/>"></script>  
<script type="text/javascript" src="<c:url value="/js/jquery.validate.js"/>"></script>

<script>

	var availableSchoolCode = [ <c:forEach items="${institutionList}" var="institution">
	 					"${institution.schoolcode}",</c:forEach> ];
	jQuery(document).ready(function(){
			/*	jQuery("#frmCourse").validate({
				 submitHandler: function(form) {
					 if(jQuery('#evaluationStatus').attr('checked')==true){
						 	var r=confirm("The status of this course will be changed to Not Confirmed. \nAnother Institution Evaluator needs to confirm the details to make it 'Evaluated'.\nYou will be able to edit the course info using 'Manage Course' functionality.");
							if(r){
								form.submit();
							}
						 
					}else{
						form.submit();
					}
				  
				 }
			});*/

		jQuery("#frmCourse").validate({
			 submitHandler: function(form) {
				 if(jQuery('#evaluationStatusCheck').attr('checked')==true){
					var msgDisplay="";
					var evaluationStatusValue="";
					 if('${transferCourse.evaluationStatus}'=='UnConfirmed'){
						 msgDisplay="The status of this Course will be changed to Evaluate. \nYou will be able to edit the Course info using 'Manage Institution' functionality.";
						 evaluationStatusValue="Evaluated";
					}else{
						 msgDisplay="The status of this Course will be changed to Not Confirmed. \nAnother Institution Evaluator needs to confirm the details to make it 'Evaluated'.\nYou will be able to edit the Course info using 'Manage Course' functionality.";
						 evaluationStatusValue="UnConfirmed";
					}
					 	var r=confirm(msgDisplay);
						if(r){
							jQuery("#evaluationStatusCheckText").val(evaluationStatusValue)
							form.submit();
						}
					 
				}else{
					form.submit();
				}
			  
			 }
		});
		if('${transferCourse.evaluationStatus}'=='UnConfirmed'){
			jQuery('#evaluationStatusLabel').html('Confirm');
		}else{
			jQuery('#evaluationStatusLabel').html('Evaluate');
		}

	 jQuery( "#schoolCode" ).autocomplete({
			source: availableSchoolCode
		});
		
	jQuery("#transferStatus").val('${transferCourse.transferStatus}')	;
});

</script>
<center>	
<div class="tblFormDiv divCover outLine">
<form id="frmCourse" method="post" action="/scheduling_system/course/manageCourse.html?operation=saveCourse">
        <table class="tableForm" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <th class="heading" colspan="2"><strong> 
                 <c:choose>
		        <c:when test="${not empty transferCourseId}">
		        	Edit
		        </c:when>
		        <c:otherwise>
		        	Create
		        </c:otherwise>
		        </c:choose>
                Course</strong></th>
            </tr>
			
			<tr><td colspan="2">
						
			<c:choose>

					<c:when test="${institution.evaluationStatus != 'Evaluated' && not empty transferCourseId}"> 
						<c:set var="disableValue" value=" onclick='return false' onkeydown='return false' " scope="request" />
						
						<p class="error">Institution attached to this course is not evaluated. Kindly evaluate the Institute before evaluating this course.</p>  
					</c:when>
					<c:otherwise>
						<c:set var="disableValue" value="" scope="request" />
					</c:otherwise>
				</c:choose>
				</td></tr>
            <tr>
                <td width="35%">School Code</td>
                <td width="65%">
                <input name="schoolCode"  id="schoolCode"type="text" <c:if test="${not empty transferCourseId}"> readonly='readonly' </c:if> value="${transferCourse.institution.schoolcode}" class="textField smallread" /><br class="clear" /></td>
            </tr>
            <tr>
                <td>TR Course Code</td>
                <td><input name="trCourseCode" type="text" value="${transferCourse.trCourseCode}" class="textField small" /><br class="clear" /></td>
            </tr>
            <tr>
                <td>TR Course Title</td>
                <td><input name="trCourseTitle" type="text" value="${transferCourse.trCourseTitle}" class="textField big"  /><br class="clear" /></td>
            </tr>
            <tr>
                <td>Transcript Credits</td>
                <td><input name="transcriptCredits" type="text"  value="${transferCourse.transcriptCredits}" class="textField small"  /><br class="clear" /></td>
            </tr>
            <tr>
                <td>Semester Credits</td>
                <td><input name="semesterCredits" type="text" value="${transferCourse.semesterCredits}" class="textField smallread"  /><br class="clear" /></td>
            </tr>
            <tr>
                <td>Pass/Fail</td>
                <td><input name="passFail" type="checkbox" value="${transferCourse.passFail}" class="textField smallread" /></td>
            </tr>
            <tr>
                <td>Minimum Grade</td>
                <td><input name="minimumGrade" type="text" value="${transferCourse.minimumGrade}" class="textField Small2" value="C" /></td>
            </tr>
            <tr>
                <td>Course Level</td>
                <td>
                    <select  name="courseLevelId" >
                    <option id="" value="">Select Course Level</option>
                    <c:forEach items="${gcuCourseLevelList}" var="gcuCourseLevel">
						<option <c:if test="${transferCourse.courseLevelId == gcuCourseLevel.name}"> selected="true" </c:if> value="${gcuCourseLevel.name}">${gcuCourseLevel.name}</option>
					</c:forEach>	
                </select><br class="clear" />
                </td>
            </tr>
            <tr>
                <td>Clock  Hours</td>
                <td><input name="clockHours"  value="${transferCourse.clockHours}" type="text" class="textField small" /></td>
            </tr>
            <tr>
                <td>Effective Date</td>
                <td><input name="effectiveDate" value='<fmt:formatDate value="${transferCourse.endDate}" pattern="MM/dd/yyyy"/>' type="text" class="textField small maskDate" /><br class="clear" /></td>
            </tr>
            <tr>
                <td>End Date</td>
                <td><input name="endDate" type="text" value='<fmt:formatDate value="${transferCourse.endDate}" pattern="MM/dd/yyyy"/>' class="textField small maskDate" /><br class="clear" /></td>
            </tr>
            <tr>
                <td>Catalog Course Description</td>
               <td>
				<textarea  name="catalogCourseDescription" rows="3" cols="40"> ${transferCourse.catalogCourseDescription} </textarea>
				</td>
                
            </tr>
            <tr>
                <td>Transfer Status</td>
                <td>
				
                    <select id="transferStatus" name="transferStatus" >
                        <option>Eligible</option>
                        <option>Not Eligible</option>
                        <option>Pending Evaluation</option>
                        
                    </select><br class="clear" />
                </td>
            </tr>
            <tr>
			    <td><label id="evaluationStatusLabel">Evalutated</label> </td>
                <!-- <td><input id="evaluationStatus" name="evaluationStatus" type="checkbox" ${disableValue} <c:if test="${transferCourse.evaluationStatus == true}"> checked </c:if> /></td> -->
				 <td>
               
                <c:choose>
                  <c:when  test="${transferCourse.checkedBy == user.id && transferCourse.evaluationStatus=='UnConfirmed'}">
                  			Not Confirmed
                  </c:when>
		        <c:when  test="${transferCourse.evaluationStatus == 'Evaluated'}"> Evaluated  </c:when>
		        <c:otherwise><input id="evaluationStatusCheck" ${disableValue} name="evaluationStatusCheck" type="checkbox" / > </c:otherwise>
		        </c:choose>
                
                    <input id="evaluationStatusCheckText" name="evaluationStatus" value="${transferCourse.evaluationStatus}" type="hidden"/></td>
             </tr>
            
            <!--
            <tr>
                <td>Course Relationship</td>
                <td><input type="button" disabled="disabled" value="Add Course Relationship" name="P Institution" class="button"
                 onclick='window.location = "/scheduling_system/course/manageCourse.html?operation=manageCourseRelationship"'  />
                 <br class="clear" /></td>
            </tr>
            <tr>
                <td>Course Category Relationship</td>
                <td><input type="button" disabled="disabled" value="Add Course Category Relationship" name="P Institution" class="button" 
                onclick='window.location = "/scheduling_system/course/manageCourse.html?operation=manageCourseCtgRelationship"'  /><br class="clear" /></td>
            </tr>
            --><tr><td></td><td></td></tr>
        </table>
        <table class="" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <td width="35%"> </td>
                <td width="65%" align="right" style="padding-top:10px">
                 <c:if test="${not empty transferCourseId}">
                	<input type="hidden" name="id" value="${transferCourseId}">
                	<input name="createdDateTime" id="createdDateTime" type="hidden"  value='<fmt:formatDate value="${transferCourse.createdDateTime}" pattern="MM/dd/yyyy"/>'   />
                	<input name="createdBy" id="createdBy" type="hidden" value="${transferCourse.createdBy}"   />
                	<input name="checkedDate" id="checkedDate" type="hidden"  value='<fmt:formatDate value="${transferCourse.checkedDate}" pattern="MM/dd/yyyy"/>'   />
                	<input name="checkedBy" id="checkedBy" type="hidden" value="${transferCourse.checkedBy}"   />
                	<input name="modifiedBy" id="modifiedBy" type="hidden" value="${transferCourse.modifiedBy}"   />
                </c:if>
                	<input type="hidden" name="callingReferer" value="${callingReferer}">	
                    <input type="button" value="Back" onclick='window.location = "${callingReferer}"'  class="button" />
                    <input type="reset"   value="Cancel" name="P Institution"  />
                    <input type="submit" value="Save" name="submitCourse" class="button" />
                    
                    <!-- If the status of the code is Not Confirmed then instead of Evaluated show Confirmed   -->
                </td>
            </tr>
        </table>
  </form>      
        
    </div>
</center>