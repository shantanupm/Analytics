<%@include file="../init.jsp" %>

<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="<c:url value="/css/schSysStylesheet.css"/>" />
<title>CRM Screen</title>
</head>

<body>

	<form name="underGradProgStrucForm" action="programStructure.html?operation=createUnderGradProgramSchedule" method="post">
		<table class="tableS1" width="100%" border="1" cellspacing="0" style="border-collapse:collapse;" cellpadding="0">  
			<div class="tbl1">
				<tr>
			    	<th width="75%">Number of Students</td>
			   	 	<th width="25%"><input type="text" name="numStudents"></td>
			  	</tr>
			</div>
			<tr>
				<td><input type="submit" value="Submit"></td>
		 	</tr>
		</table>
	</form>

</body>
</html>