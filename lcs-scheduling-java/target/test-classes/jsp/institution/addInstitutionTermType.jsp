<%@include file="../init.jsp" %>

<form method="post" action="/scheduling_system/institution/manageInstitution.html?operation=saveInstitutionTermType&institutionId=${institutionId}">

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

        <label class="caption">Select Term Type:</label>
        
        <select  name="termType.id">
			<option id="" value="">Select Term Type</option>
			<c:forEach items="${termTypeList}" var="termType">
				<option <c:if test="${institutionTermType.termType.id == termType.id}"> selected="true" </c:if> value="${termType.id}">${termType.name}</option>
			</c:forEach>			    
		</select> 
			<br class="clear" />
         <label class="caption">Effective Date</label>
        <input name="effectiveDate" type="text" class="textField small maskDate" value='<fmt:formatDate value="${institutionTermType.effectiveDate}" pattern="MM/dd/yyyy"/>'   /><a href="#" id="A2"><span class="datepicker2" > </span></a><br class="clear" />

        <label class="caption">End Date</label>
        <input name="endDate" type="text" class="textField small maskDate" value='<fmt:formatDate value="${institutionTermType.endDate}" pattern="MM/dd/yyyy"/>'    /><a href="#" id="A1"><span class="datepicker2"> </span></a><br class="clear" />
        
        <div class="buttonRow">
        	 <input type="hidden" name="instituteId" value="${institutionId}">
        	 <c:if test="${not empty institutionTermType.id }">
       		 	<input type="hidden" name="id" value="${institutionTermType.id}">
       		 </c:if>
            <input name="" type="submit" value="Save" />
            <input name="" type="button"  class="close"  value="Cancel" /></div>
    </div>
  </form>