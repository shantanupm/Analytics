<%@include file="../init.jsp" %>

<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="<c:url value="/css/schSysStylesheet.css"/>" />
<title>CRM Result Screen</title>
</head>

<body>
	
	<div class="tbl1">
	</div>
	
	<div class="tbl2">
		<c:choose>
			<c:when test="${errorInOperation == 'true'}">
				<span class="redTxt">One or more of the requested operations did not complete successfully.</span>
			</c:when>
			<c:otherwise>
				<span>The requested operation completed. The details are as below</span>
		
				<div class="tbl2">
					<table class="tableS2" width="100%" style="border-collapse:collapse; border-color:#AAAFB2" border="1" cellspacing="0" cellpadding="0">
					  <tr>
					    <th width="10%">Student Id</th>
					    <th width="10%">Program Version Code</th>
					    <th width="40%" style="text-align:left;">Operation Result</th>
					  </tr>
					  <c:forEach items="${operationResultList}" var="result" varStatus="index">
					  <tr>
					  		<td><c:out value="${result.studentId}" /></td>
					  		<td><c:out value="${result.programVersionCode}" /></td>
					  		<td style="text-align:left;"><c:out value="${result.operationResultDesc}" /></td>
					  </tr>
					  </c:forEach>
					</table>
				</div>
		
			</c:otherwise>
		</c:choose>
	</div>
		
</body>
</html>