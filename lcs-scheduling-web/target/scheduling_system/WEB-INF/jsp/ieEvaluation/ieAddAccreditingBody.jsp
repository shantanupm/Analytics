<%@include file="../init.jsp" %>



  <script>
  jQuery(document).ready(function(){
  
		jQuery("#frmAccreditingBody").validate();
		
		
	});
  </script>
  
 <c:choose>
   	<c:when test="${role=='MANAGER'}"> 
      	<c:set var="actionLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=saveAccreditingBody&institutionId=${institutionId}"/>
     	</c:when>
	<c:otherwise>
		<c:set var="actionLink" scope="session" value="/scheduling_system/evaluation/quality.html?operation=saveAccreditingBody&institutionMirrorId=${institutionMirrorId}"/>
 	</c:otherwise>
 </c:choose>   
  
<form id="frmAccreditingBody" method="post" action="${actionLink}">
<div class="popCont popUpsm">
        <h1><a href="#" class="close"></a> 
        <c:choose>
        <c:when test="${not empty accreditingBodyInstitute.id }">
        	Edit
        </c:when>
        <c:otherwise>
        	Add
        </c:otherwise>
        </c:choose> Accrediting Body</h1>

        <label class="noti-pop-labl">Accrediting Body:<strong class="asterisk" style="font-size:14px;">*</strong></label>
        <select id="selAccrediting"    class="required frm-stxbx w200" name="accreditingBody.id">
			<option  value="">Select the Accrediting Body</option>
			<c:forEach items="${accreditingBodyList}" var="accreditingBody">
				<option <c:if test="${accreditingBodyInstitute.accreditingBody.id == accreditingBody.id}"> selected="true" </c:if> value="${accreditingBody.id}">${accreditingBody.name}</option>
			</c:forEach>			    
		</select> 
		
		<br class="clear" />

        <label class="noti-pop-labl">Effective Year<strong class="asterisk" style="font-size:14px;">*</strong></label>
        <input id="effectiveDate" name="effectiveDate" type="text" class="txbx noti-pop-txbx  maskYear required" value='${accreditingBodyInstitute.effectiveDate}'   /><br class="clear" />

        <label class="noti-pop-labl">End Year</label>
        <input id="endDate" name="endDate" type="text" class="txbx noti-pop-txbx   maskYear  requiredDateRange" value='${accreditingBodyInstitute.endDate}'    /><br class="clear" />
        
		<div class="dividerPopup mt25"></div>
		
        <div class="btn-cnt fr">
			 <input type="hidden" id="accreditingBodyName" name="accreditingBodyName" value="${accreditingBodyInstitute.accreditingBody.name}"/>
			 <input type="hidden" name="instituteId" value="${institutionId}"/>
			
			 <c:if test="${not empty accreditingBodyInstitute.id}">
			  	<input type="hidden" name="effective" value="${accreditingBodyInstitute.effective}"/>
       			 <input type="hidden" name="id" value="${accreditingBodyInstitute.id}">
       		 </c:if>
       		  <c:if test="${currentlyActiveAccreditingBody}">
			  	<input type="hidden" name="effective" value="${currentlyActiveAccreditingBody}"/>
       		  </c:if>
            <input name="" type="submit" value="Save" />
            <input name="" type="button"  class="close"  value="Cancel" /></div>
    </div>
    </form>