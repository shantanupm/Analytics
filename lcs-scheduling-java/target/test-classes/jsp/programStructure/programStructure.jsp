<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="<c:url value="/css/schSysStylesheet.css"/>" />
<title>CRM Screen</title>
</head>

<body>

	<form name="progStrucForm" action="programStructure.html?operation=createStudentProgramSchedule" method="post">
		<div class="tbl1"><table class="tableS1" width="100%" border="1" cellspacing="0" style="border-collapse:collapse;" cellpadding="0">
		  <tr>
		    <td class="heading" colspan="2"><strong><c:out value="${programInfo.programDescription}" /></strong></td>
		  </tr>
		  <tr>
		    <th width="75%">Cvue Catalog Code</td>
		    <!-- <th width="25%"><input name='catalogCode' value='<c:out value="${programInfo.catalogCode}"/>'/> </td> -->
		    <th width="25%"><c:out value="${programInfo.catalogCode}"/></td>
		  </tr>
		  <tr>
		    <td>Cvue Program Version Code</td>
		    <!-- <td><input name='programVersionCode' value='<c:out value="${programInfo.programVersionCode}"/>'/></td> -->
		    <td><c:out value="${programInfo.programVersionCode}"/></td>	
		  </tr>
		  <tr>
		    <td>Cvue Program Version Weeks</td>
		    <td><c:choose>
		    		<c:when test="${programInfo.programVersionWeeks=='' || programInfo.programVersionWeeks==null}">
		    			<c:out value="${totalNoOfWeeks}"/>
		    		</c:when>
		    		<c:otherwise>
		    			<c:out value="${programInfo.programVersionWeeks}"/></td>
		    		</c:otherwise>
		    	</c:choose>
		  </tr>
		  <tr>
		    <td>Program Start Date (YYYY-MM-DD)</td>
		    <!-- <td><input name='programStartDate' value='<c:out value="${programInfo.programStartDateAsString}"/>'></td> -->
		    <td><fmt:formatDate value="${programInfo.programStartDate}" pattern="yyyy-MM-dd"/></td>	
		  </tr>
		   <tr>
		    <td>Student CVue Id</td>
		    <!-- <td><input name='programStartDate' value='<c:out value="${programInfo.programStartDateAsString}"/>'></td> -->
		    <td><c:out value="${programInfo.studentId}"/></td>	
		  </tr>
		  <tr>
		  	<input type='hidden' name='studentCVueId' value='<c:out value="${programInfo.studentId}"/>' />
		  	<input type='hidden' name='stateCode' value='<c:out value="${programInfo.stateCode}"/>' />
		  	<input type=hidden name=programVersionId value='<c:out value="${programInfo.programVersionId}"/>' />
		  	<input type="hidden" name='catalogCode' value='<c:out value="${programInfo.catalogCode}"/>'/>
		  	<input type=hidden name='programStartDate' value='<fmt:formatDate value="${programInfo.programStartDate}" pattern="yyyy-MM-dd"/>'>
		  	<input type="hidden" name='programVersionCode' value='<c:out value="${programInfo.programVersionCode}"/>'/>
		  </tr>  
		</table></div>
		<!-- 
		  <tr>
			<td><input type="submit" value="Submit"></td>
		  </tr>
		-->
		
		<c:if test="${errorInOperation == 'true'}">
			<div class="tbl2">
				<span class="redTxt">An error was encoutered while performing the requested operation</span>
			</div>
		</c:if>
		
		<c:set var="courseRegistrationRequired" value="false"></c:set>
		
		<div class="tbl2">
		<table class="tableS2" width="100%" style="border-collapse:collapse; border-color:#AAAFB2" border="1" cellspacing="0" cellpadding="0">
		  <tr>
		    <th width="6%">Sequence </th>
		    <th width="4%">XRM-Sequence </th>
		    <th width="7%">Course ID</th>
		    <th width="7%">Course Code</th>
		    <th width="23%">Course Desc</th>
		    <th width="7%">Course Credits</th>
		    <th width="9%">Course Category Code</th>
		    <th width="6%">Course Grade Level</th>
		    <th width="7%">Course Weeks</th>
		    <th width="6%">Transfer Eligible</th>
		    <!-- <th width="5%">States</th> -->
		    <th width="6%">Start Date</th>
		    <th width="6%">End Date</th>
		    <th width="6%">Status</th>
		  </tr>
		  <c:forEach items="${scheduleList}" var="schedule" varStatus="index">
		  <tr>
		  		<td><c:out value="${index.count}" /></td>
		  		<td><c:out value="${schedule.sequenceOrder}" /></td>
		  		<td><c:out value="${schedule.courseId}" /></td>
		  		<td><c:out value="${schedule.courseCode}" /></td>
		  		<td class="LeftText"><c:out value="${schedule.courseDesc}" /></td>
		  		<td><c:out value="${schedule.courseCredits}" /></td>
		  		<td><c:out value="${schedule.courseCategoryCode}" /></td>
		  		<td><c:out value="${schedule.courseGradeLevel}" /></td>
		  		<td><c:out value="${schedule.courseWeeks}" /></td>
		  		<td><c:out value="${schedule.transferEligible}" /></td>
		  		<!-- <td><c:out value="${schedule.states}" /></td> -->
		  		<td><fmt:formatDate value="${schedule.programStartDate}" pattern="yyyy-MM-dd"/></td>
		  		<td><fmt:formatDate value="${schedule.programEndDate}" pattern="yyyy-MM-dd"/></td>
		  		<td><c:out value="${schedule.courseStatus}" /></td>
		  		
		  		<c:if test="${schedule.courseAlreadyScheduled != true }">
		  			<c:set var="courseRegistrationRequired" value="true"></c:set>
		  		</c:if>
		  		
		  </tr>
		  </c:forEach>
		  </table>
		</div>
		<div class="gdate">
		<div class="gdateTxt">Graduation Date</div>
		<div class="gdateTxt1"><c:out value="${programInfo.graduationDateAsString}"/></div>
		</div><br /><Br />
		<div class="CreateSchedule">
			<input type="submit" value="Create Schedule" name="Create Schedule" <c:if test="${programInfo.graduationDateAsString == '' || courseRegistrationRequired == 'false' }"> disabled="disabled" </c:if>/>
		</div>
		<div style="display:none;" class="CreateSchedule1">
			<input type="button" value="Create Schedule" name="Create Schedule" <c:if test="${programInfo.graduationDateAsString == ''}"> disabled="disabled" </c:if>/>
		</div>
		<input type='hidden' name='graduationDate' value='<c:out value="${programInfo.graduationDateAsString}"/>' />
		<input type='hidden' name='courseRegistrationRequired' value='<c:out value="${courseRegistrationRequired}"/>' />
	</form>

</body>
</html>