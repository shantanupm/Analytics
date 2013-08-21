<%@include file="../init.jsp" %>



  <script>
  jQuery(document).ready(function(){
    jQuery("#frmAccreditingBody").validate();
	});
  </script>
  
<form id="frmAccreditingBody" method="post" action="/scheduling_system/institution/manageInstitution.html?operation=saveAccreditingBody&institutionId=${institutionId}">
<div class="popCont">
        <h1><a href="#" class="close"></a> 
        <c:choose>
        <c:when test="${not empty accreditingBodyInstitute.id }">
        	Edit
        </c:when>
        <c:otherwise>
        	Add
        </c:otherwise>
        </c:choose> Accrediting Body</h1>

        <label class="caption">Accrediting Body:</label>
        <select id="selInstitution"   style="width:360px;" name="accreditingBody.id">
			<option id="" value="">Select the Accrediting Body</option>
			<c:forEach items="${accreditingBodyList}" var="accreditingBody">
				<option <c:if test="${accreditingBodyInstitute.accreditingBody.id == accreditingBody.id}"> selected="true" </c:if> value="${accreditingBody.id}">${accreditingBody.name}</option>
			</c:forEach>			    
		</select> 
		<br class="clear" />

        <label class="caption">Effective Date</label>
        <input name="effectiveDate" type="text" class="textField small date maskDate required" value='<fmt:formatDate value="${accreditingBodyInstitute.effectiveDate}" pattern="MM/dd/yyyy"/>'   /><a href="#" id="A2"><span class="datepicker2" > </span></a><br class="clear" />

        <label class="caption">End Date</label>
        <input name="endDate" type="text" class="textField small  date maskDate required" value='<fmt:formatDate value="${accreditingBodyInstitute.endDate}" pattern="MM/dd/yyyy"/>'    /><a href="#" id="A1"><span class="datepicker2"> </span></a><br class="clear" />
        
        <div class="buttonRow">
			 <input type="hidden" name="instituteId" value="${institutionId}">
			 <c:if test="${not empty accreditingBodyInstitute.id}">
       			 <input type="hidden" name="id" value="${accreditingBodyInstitute.id}">
       		 </c:if>
            <input name="" type="submit" value="Save" />
            <input name="" type="button"  class="close"  value="Cancel" /></div>
    </div>
    </form>