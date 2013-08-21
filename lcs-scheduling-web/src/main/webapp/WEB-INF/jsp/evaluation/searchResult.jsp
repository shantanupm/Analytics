<%@include file="../init.jsp" %>
<script type="text/javascript">
	jQuery(document).ready(function () {
		
		jQuery('#ReSetbtn').click(function(){
				jQuery('#searchBy').show();
				jQuery('#searchResult').hide();	
  				jQuery('#srchFrm').each(function(){
        this.reset();
    });
 			});
		jQuery('#EditBtn').click(function(){
				jQuery('#searchBy').show();
				jQuery('#searchResult').hide();
			});
	});
	
	

</script>

<div class="deoSerchFor">
	<div class="fl mt5">
		You searched for: 
			<c:if test="${!empty searchCriteria.crmId}">
			    <strong>CRM INQUIRY ID:</strong> ${searchCriteria.crmId},
			</c:if>
			<c:if test="${!empty searchCriteria.campusvueId}">
				<strong>Student Number:</strong> ${searchCriteria.campusvueId},
			</c:if>
			<c:if test="${!empty searchCriteria.demographics.firstName}">
				<strong>First Name:</strong> ${searchCriteria.demographics.firstName},
			</c:if>
			<c:if test="${!empty searchCriteria.demographics.maidenName}">
				<strong>Maiden Name:</strong> ${searchCriteria.demographics.maidenName},
			</c:if>
			<c:if test="${!empty searchCriteria.demographics.lastName}">
				<strong>Last Name:</strong> ${searchCriteria.demographics.lastName},
			</c:if>
			<c:if test="${!empty searchCriteria.demographics.dateOfBirth}">
				<strong>Date of Birth:</strong> ${searchCriteria.demographics.dateOfBirth},
			</c:if>
			<c:if test="${!empty searchCriteria.demographics.last4SSN}">
				<strong>SSN:</strong>XXXX-XX-${searchCriteria.demographics.last4SSN},
			</c:if>
			<c:if test="${!empty searchCriteria.state}">
				<strong>State:</strong> ${searchCriteria.state},
			</c:if>
			<c:if test="${!empty searchCriteria.city}">
				<strong>City:</strong> ${searchCriteria.city},
			</c:if>
	</div>
	<div class="floatRight" align="right">
		<input type="button" class="button" value="Edit" id="EditBtn">&nbsp;<input
			type="button" class="button" value="Reset" id="ReSetbtn">
	</div>
	<div class="clear"></div>
</div>
<!-- End of div with class deoSerchFor -->
 <c:if test="${not (hasError)}">	            
   <div class="mb10">${resultsTotal} Result found</div>	            
 </c:if>

<div class="tabTBLborder mb30">
	<div>
		<table width="100%" border="0" cellspacing="0" cellpadding="0"
			class="deosrc-tbl">
			<tr>
				<th width="10%" scope="col" class="brdRight"><span
					class="sort_d">CRM INQUIRY ID</span></th>
				<th width="12%" scope="col" class="brdRight">Student Number</th>
				<th width="18%" scope="col" class="brdRight"><span
					class="sort_d">First Name</span></th>
				<th width="16%" scope="col" class="brdRight">Maiden Name</th>
				<th width="18%" scope="col" class="brdRight"><span
					class="sort_d">Last Name</span></th>
				<th width="10%" scope="col" class="brdRight">Date of Birth</th>
				<th width="10%" scope="col">SSN</th>
				<th width="1%" scope="col">&nbsp;</th>
			</tr>
		</table>
	</div>
	<!--end of the div that is wrapping the table -->
	<div class="deosrcScroll">
		<table width="100%" border="0" cellspacing="0" cellpadding="0"
			class="deosrc-tbl"> 
		   <c:choose>
				    <c:when test="${fn:length(searchResults) gt 0}">
				      	 <c:forEach items="${searchResults}" var="srchResult" varStatus="loop">			  
							<tr>
								<td class="noBorder" width="10%"><a href="<c:url value='launchEvaluation.html?operation=launchEvaluationHome&studentCrmId=${srchResult.crmId}&studentNumber=${srchResult.campusvueId}'/>">${srchResult.crmId}</a></td>
						    	<td class="noBorder" width="12%">${srchResult.campusvueId}</td>
							    <td class="noBorder" width="18%">${srchResult.demographics.firstName}</td>
								<td class="noBorder" width="16%">${srchResult.demographics.maidenName}</td>
								<td class="noBorder" width="18%">${srchResult.demographics.lastName}</td>
								<td class="noBorder" width="10%">${srchResult.demographics.dateOfBirth}</td>
								<td class="noBorder" width="11%">XXXX-XX-${srchResult.demographics.last4SSN}</td>
				            </tr>
						</c:forEach>
		            </c:when>	
		             <c:when test="${hasError}">
				      	 <div class="errorMessageDv">${errorMessage}</div>	 
		            </c:when>	
		             <c:otherwise>
		               <tr>No Records found for the search Criteria</tr>
		            </c:otherwise>	   
		    </c:choose>
 		  
		</table>
	</div>
	<!-- end of the div with class deosrcScroll -->
</div>
<!-- end of div with id tabTBLborder mb30 -->