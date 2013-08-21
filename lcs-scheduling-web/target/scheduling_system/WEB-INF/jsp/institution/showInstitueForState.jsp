<%@include file="../init.jsp" %>

<c:forEach items="${institutionsList }" var="institution">
 	<option value="${institution.id }" onclick="javaScript:fillRelatedFields('${institution.institutionID }','${institution.address1 }','${institution.address2 }','${institution.city }','${institution.zipcode }');">${institution.name }</option>
 </c:forEach>