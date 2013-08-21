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

 	var availableSchoolCode = [ <c:forEach items="${courseList}" var="transferCourse">
 	 					"${transferCourse.trCourseCode}",</c:forEach> ];
	var availableSchoolTitle = [ <c:forEach items="${courseList}" var="transferCourse">
 	 					"${transferCourse.trCourseTitle}",</c:forEach> ];

	jQuery(document).ready(function(){
	    
	   		    jQuery( "#courseCode" ).autocomplete({
				source: availableSchoolCode
			});

		    jQuery( "#courseTitle" ).autocomplete({
				source: availableSchoolTitle
			});
	  });
</script>

<center>
 <div class="tblFormDiv divCover outLine" >
 
 <form action="/scheduling_system/course/manageCourse.html">
 <div class="innerDiv" >
        <table class="tableForm" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <th class="heading" colspan="2"><strong>Select Course</strong></th>
            </tr>
            <tr>
                <td width="35%"> </td>
                <td width="65%"></td>
            </tr>
            <tr>
                <td>TR Course Code</td>
                <td><input name="courseCode"  id="courseCode" type="text" class="textField small" /><br class="clear" /></td>
            </tr>
            <tr>
                <td>TR Course Title</td>
                <td><input name="courseTitle" id="courseTitle" type="text" class="textField big" /><br class="clear" /></td>
            </tr>
            <tr>
                <td></td>
                <td>
					<input name="operation" type="hidden" value="viewCourse" />
                    <input type="submit" value="Show Details" name="showCourse" class="button"   /> 
                    <input type="button" value="Add Course" name="P Institution" class="button" 
                    onclick='window.location = "/scheduling_system/course/manageCourse.html?operation=createCourse"'  />
                   
                    <br class="clear" />
                </td>
            </tr>
            <tr><td></td><td></td></tr>
        </table>
   </div>
    </form>
    
    <c:choose>
        <c:when  test="${not empty transferCourse.id}">
    <div class="innerDiv" >
        <br class="clear" />
        <table class="tableForm" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <th class="heading" colspan="2"><strong>Course Details</strong></th>
            </tr>
            <tr>
                <td width="35%">School Code</td>
                <td width="65%">${transferCourse.institution.schoolcode}</td>
            </tr>
            <tr>
                <td>TR Course ID</td>
                <td>${transferCourse.trCourseId}</td>
            </tr>
            <tr>
                <td>TR Course Title</td>
                <td>${transferCourse.trCourseTitle}</td>
            </tr>
            <tr>
                <td>Transcript Credits</td>
                <td>${transferCourse.transcriptCredits}</td>
            </tr>
            <tr>
                <td>Semester Credits</td>
                <td>${transferCourse.semesterCredits}</td>
            </tr>
            <tr>
                <td>Pass/Fail</td>
                <td>${transferCourse.passFail}</td>
            </tr>
            <tr>
                <td>Minimum Grade</td>
                <td>${transferCourse.minimumGrade}</td>
            </tr>
            <tr>
                <td>Course Level</td>
                <td>${transferCourse.courseLevelId}</td>
            </tr>
            <tr>
                <td>Clock  Hours</td>
                <td>${transferCourse.clockHours}</td>
            </tr>
            <tr>
                <td>Effective Date</td>
                <td><fmt:formatDate value="${transferCourse.effectiveDate}" pattern="MM/dd/yyyy"/></td>
            </tr>
            <tr>
                <td>End Date</td>
                <td><fmt:formatDate value="${transferCourse.endDate}" pattern="MM/dd/yyyy"/></td>
            </tr>
            <tr>
                <td>Catalog Course Description</td>
                <td>${transferCourse.catalogCourseDescription}</td>
            </tr>
            <tr>
                <td>Transfer Status</td>
                <td>${transferCourse.transferStatus}</td>
            </tr>
             <tr>
                <td> </td>
                <td><input type="button" value="Edit Details" name="P Institution" class="button" 
                onclick='window.location = "/scheduling_system/course/manageCourse.html?operation=createCourse&transferCourseId=${transferCourse.id}"'  /></td>
            </tr>
            <tr><td></td><td></td></tr>
        </table>

        <table class="" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <td width="100%" align="right" style="padding-top:10px">
                    <input type="button" value="View/Edit Course Relationship" name="P Institution" class="button" 
                    onclick='window.location = "/scheduling_system/course/manageCourse.html?operation=manageCourseRelationship&transferCourseId=${transferCourse.id}"'  />
                    <input type="button" value="View/Edit Course Category Relationship" name="P Institution" class="button" 
                    onclick='window.location = "/scheduling_system/course/manageCourse.html?operation=manageCourseCtgRelationship&transferCourseId=${transferCourse.id}"'  />
                </td>
            </tr>
        </table>
     </div>
     </c:when>
     <c:otherwise>
	 	<c:if test= "${ empty mode}">
	 		No Institution Found
	 	</c:if>
 	</c:otherwise>
 	</c:choose>      
        
    </div>

</center>