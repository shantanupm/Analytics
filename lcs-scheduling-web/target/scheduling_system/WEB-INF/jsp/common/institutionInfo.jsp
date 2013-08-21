<%@include file="../init.jsp" %>
<div class="deoInfo">
<h1 class="expand"><div class="fl">Transfer Institution: <span class="FntNormal">${selectedInstitution.name}</span></div>
        
        <div class="Inprgss FntNormal">${selectedInstitution.evaluationStatus }</div>
        <div class="trnId">ID: <span class="FntNormal">${selectedInstitution.institutionID}</span></div>
        
        <div class="clear"></div>
        </h1>
    	
        <div class="deoExpandDetails collapse" style="display:block;">
         <table width="100%" border="0" cellspacing="0" cellpadding="0" class="contentForm">
              <tr>
                <td width="100%" valign="top"><label class="noti-label w130">Address:</label>
                     <c:forEach items="${selectedInstitution.addresses}" var="address" varStatus="index">
			         <label class="noti-label2 wrapText1">
		               
		               		 ${address.address1} &nbsp;
		               		 ${address.address2} &nbsp;
		               		 <c:if test="${!empty address.city}">&nbsp;${address.city}</c:if>
		               		 <c:if test="${!empty address.state}">&nbsp;${address.state}</c:if>
		               		 <c:if test="${!empty address.zipcode}">&nbsp;${address.zipcode}</c:if>
		               		 <c:if test="${!empty address.country.name}">&nbsp;${address.country.name}</c:if>
		                 	<c:if test="${!empty address.phone1}">Phone: &nbsp;${address.phone1}</c:if>
		                 	<c:if test="${!empty address.phone1 && !empty address.phone2}">,</c:if>
		                 	<c:if test="${!empty address.phone2}">${address.phone2}</c:if>
		                 	<c:if test="${!empty address.phone1 || !empty address.phone2}"><br /></c:if>
		                  	
		               		<c:if test="${!empty address.email1}"> Email Id 1: &nbsp; ${address.email1}</c:if>
		               		<c:if test="${!empty address.email1 && !empty address.email2}">,</c:if>
		               		<c:if test="${!empty address.email2}">${address.email2}</c:if>
		               		<c:if test="${!empty address.email1 || !empty address.email2}"><br></c:if>
		               		<c:if test="${!empty address.website}">Website: &nbsp;${address.website}</c:if>
		               		
		             
	               </label>
	               </c:forEach>
               </td>
              </tr>
            </table>
            </div>
     </div>