<%@include file="../init.jsp" %>

<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="<c:url value="/css/schSysStylesheet.css"/>" />
<title>CRM Screen</title>
</head>

<body>

	<form name="underGradStudentForm" action="programStructure.html?operation=createUnderGradProgramSchedule" method="post">
		
		<div class="tbl1">
		</div>
		
		<c:if test="${errorInOperation == 'true'}">
			<div class="tbl2">
				<span class="redTxt">An error was encoutered while performing the requested operation</span>
			</div>
		</c:if>
		
		<div class="tbl2">
		<table class="tableS2" width="100%" style="border-collapse:collapse; border-color:#AAAFB2" border="1" cellspacing="0" cellpadding="0">
		  <tr>
		    <th width="7%">Student Id</th>
		    <th width="7%">First Name</th>
		    <th width="7%">Last Name</th>
		    <th width="7%">Catalog</th>
		    <th width="10%">PV Code</th>
		    <th width="15%">PV Desc</th>
		    <th width="10%">School Status</th>
		    <th width="7%">Exp Start Date</th>
		    <th width="7%">Version Start Date</th>
		    <th width="7%">State</th>
		    <th width="7%">Status</th>
		  </tr>
		  <c:forEach items="${studentList}" var="student" varStatus="index">
		  <tr>
		  		<td><c:out value="${student.studentId}" /></td>
		  		<td><c:out value="${student.firstName}" /></td>
		  		<td><c:out value="${student.lastName}" /></td>
		  		<td><c:out value="${student.catalogCode}" /></td>
		  		<td><c:out value="${student.programVersionCode}" /></td>
		  		<td class="LeftText"><c:out value="${student.programVersionDesc}" /></td>
		  		<td><c:out value="${student.schoolStatus}" /></td>
		  		<td><c:out value="${student.programStartDateAsString}" /></td>
		  		<td><c:out value="${student.versionStartDateAsString}" /></td>
		  		<td><c:out value="${student.stateCode}" /></td>
		  		<td><c:out value="${student.status}" /></td>
		  </tr>
		  </c:forEach>
		  </table>
		</div>

		<div class="CreateSchedule">
			<input type="hidden" id="numStudents" name="numStudents" value="${numStudents}" />
			<input type="submit" value="Create Schedule" name="Create Schedule" />
		</div>
	
	</form>

</body>
</html>