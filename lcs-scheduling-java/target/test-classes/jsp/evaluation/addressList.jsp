
<%@include file="../init.jsp"%>
<c:forEach items="${addressList}" var="address" varStatus="index">

<label> <input type="radio" name="id" value="${address.id}" id="RadioGroup1_${index.index }" 
<c:if test="${fn:length(addressList)==1}"> checked='checked'		    </c:if>	</input>	</label>
<div class="aseladdOverflow mb20">${address.address1} ${address.address2}
	${address.city} ${address.state}
	 ${address.zipcode} ${address.country.name}<br />
	<c:if test="${!empty address.phone1 }">Phone: ${address.phone1}</c:if>
	<c:if test="${!empty address.phone2 }">, ${address.phone2} </c:if>
	<c:if test="${!empty address.fax }">Fax: ${address.fax}	</c:if> 
	<c:if test="${!empty address.tollFree }">Toll Free:${address.tollFree}</c:if> <br />
	<c:if test="${!empty address.website }">Website: ${address.website} </c:if>
	<c:if test="${!empty address.email1 }">Email Id: ${address.email1} </c:if>
	<c:if test="${!empty address.email2 }">, ${address.email2}</c:if>
	</div>
							<br class="clear" /> 
		
</c:forEach>