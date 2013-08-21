<%@include file="../init.jsp" %>

 <c:choose>
   	<c:when test="${role=='MANAGER'}"> 
      	<c:set var="actionLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=saveInstitutionTermType&institutionId=${institutionId}"/>
     	</c:when>
	<c:otherwise>
		<c:set var="actionLink" scope="session" value="/scheduling_system/evaluation/quality.html?operation=saveInstitutionTermType&institutionMirrorId=${institutionMirrorId}"/>
 	</c:otherwise>
 </c:choose> 

<form method="post" action="${actionLink}" id="frmTermType">

<div class="popCont">
        <h1><a href="#" class="close"></a>
         <c:choose>
        <c:when test="${not empty institutionTermType.id }">
        	Edit
        </c:when>
        <c:otherwise>
        	Add
        </c:otherwise>
        </c:choose>Term Type</h1>

        <label class="noti-pop-labl">Select Term Type:<strong class="asterisk" style="font-size:14px;">*</strong></label>
        
        <select  id="selTermType" name="termType.id" class="required">
			<option id="" value="">Select Term Type</option>
			<c:forEach items="${termTypeList}" var="termType">
				<option <c:if test="${institutionTermType.termType.id == termType.id}"> selected="true" </c:if> value="${termType.id}">${termType.name}</option>
			</c:forEach>			    
		</select> 
			<br class="clear" />
         <label class="noti-pop-labl">Effective Date<strong class="asterisk" style="font-size:14px;">*</strong></label>
        <input id="effectiveDate" name="effectiveDate" type="text" class="txbx noti-pop-txbx maskDate required" value='<fmt:formatDate value="${institutionTermType.effectiveDate}" pattern="MM/dd/yyyy"/>'   /><br class="clear" />

        <label class="noti-pop-labl">End Date</label>
        <input id="endDate" name="endDate" type="text" class="txbx noti-pop-txbx maskEndDate  requiredDateRange" value='<fmt:formatDate value="${institutionTermType.endDate}" pattern="MM/dd/yyyy"/>'    /><br class="clear" />
        
        <div class="buttonRow">
        	 <input type="hidden" id="termTypeName" name="termTypeName" value="${institutionTermType.termType.name}" >
        	 <input type="hidden" name="instituteId" value="${institutionId}">
        	 
        	 <c:if test="${not empty institutionTermType.id }">
        	  	<input type="hidden" name="effective" value="${institutionTermType.effective}"/>
       		 	<input type="hidden" name="id" value="${institutionTermType.id}">
       		 </c:if>
       		 <c:if test="${currentlyActiveTermType}">
        	  	<input type="hidden" name="effective" value="${currentlyActiveTermType}"/>
       		 </c:if>
            <input name="" type="submit" value="Save" />
            <input name="" type="button"  class="close"  value="Cancel" /></div>
    </div>
  </form>