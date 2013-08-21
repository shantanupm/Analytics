<%@include file="../init.jsp" %>
<script type="text/javascript" src="<c:url value="/js/evaluationHome.js"/>"></script> 
<script type="text/javascript">
jQuery(document).ready(function(){
	optionString = "";
	<c:forEach items="${gcuCourseCategoryList}" var="gcuCourseCategory">
	
	 	 optionString=optionString+ '<option  value="${gcuCourseCategory.name}">${gcuCourseCategory.name}</option>';
	
	</c:forEach>
});
function addArticulationAgreementTblRow(placeholder){	
	
	var placeholder = parseInt(placeholder) + 1 ;
	var appendInsText =					
	    "<tr><td><select id='gcuCourseCategory_"+placeholder+"' name='articulationAgreementDetailsList["+placeholder+"].gcuCourseCategory' class=' eventCaptureField' > <option id='' value=''>Select Course Category</option>"+optionString+"</select></td>"
	    +
		"<td id='removeRowTd_"+placeholder+"'>"
		+"<a onclick='addArticulationAgreementTblRow("+placeholder+");' class='addRow' name='addRow_"+placeholder+"' id='addRow_"+placeholder+"' href='javascript:void(0)'><img width='15' height='14' src='../images/addCourse.png' alt='add'> Add New</a><br/>"
		+
		"<a href='#'  id='removeRow_"+placeholder+"' name='removeRow_"+placeholder+"' class='removeInstitutionRow'><img width='15' height='15' src='../images/removeIcon.png' alt='Delete'>Remove</a></td></tr>";
		
		addRowsAtFly('eventCaptureField', 'blur', 'addArticulationAgreementTbl', 'removeRowTd_', appendInsText, placeholder);
}

</script> 
 <c:choose>
   	<c:when test="${role=='MANAGER'}"> 
      	<c:set var="actionLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=saveArticulationAgreement&institutionId=${institutionId}"/>
     	</c:when>
	<c:otherwise>
		<c:set var="actionLink" scope="session" value="/scheduling_system/evaluation/quality.html?operation=saveArticulationAgreement&institutionMirrorId=${institutionMirrorId}"/>
 	</c:otherwise>
 </c:choose>  
<c:set var="listCount" value="${fn:length(articulationAgreement.articulationAgreementDetailsList)}"/>
<form:form method="post" action="${actionLink}" id="frmArticulationAgreement" modelAttribute="articulationAgreement">
 <div class="popCont">
        <h1><a href="#" class="close"></a>Articulate Agreement</h1>

		<label class="noti-pop-labl">Other Institution Degree:<strong class="asterisk" style="font-size:14px;">*</strong></label>
        <input name="institutionDegree" type="text"  value="${articulationAgreement.institutionDegree}"  class="txbx noti-pop-txbx required" /><br class="clear" />

        <label class="noti-pop-labl">GCU Degree:<strong class="asterisk" style="font-size:14px;">*</strong></label>
        <input name="gcuDegree" type="text" class="txbx noti-pop-txbx required" value="${articulationAgreement.gcuDegree}"   /><br class="clear" />

		
        <label class="noti-pop-labl">Effective Date:<strong class="asterisk" style="font-size:14px;">*</strong></label>
        <input id="effectiveDate" name="effectiveDate" type="text" value='<fmt:formatDate value="${articulationAgreement.effectiveDate}" pattern="MM/dd/yyyy"/>'  class="txbx noti-pop-txbx maskDate required" /><br class="clear" />

        <label class="noti-pop-labl">End Date:</label>
        <input id="endDate" name="endDate" type="text" class="txbx noti-pop-txbx maskDate  requiredDateRange" value='<fmt:formatDate value="${articulationAgreement.endDate}" pattern="MM/dd/yyyy"/>'  /><br class="clear" />

        <label class="noti-pop-labl">GCU Course Category Requirement:</label>
        <br class="clear" />

        <table id="addArticulationAgreementTbl"  class="noti-tbl1" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <th >Course Category<strong class="asterisk" style="font-size:14px;">*</strong></th>
				<th class="dividerGrey">Action</th>
               
            </tr>
            
            
           <c:forEach items="${articulationAgreement.articulationAgreementDetailsList}" var="articulationAgreementDetails" varStatus="status">
            <tr>
                 <td><select class="eventCaptureField required" name="articulationAgreementDetailsList[${status.index}].gcuCourseCategory" >
                    <option id="" value="">Select Course Category</option>
					<c:forEach items="${gcuCourseCategoryList}" var="gcuCourseCategory">
						<option <c:if test="${articulationAgreementDetails.gcuCourseCategory == gcuCourseCategory.name}"> selected="true" 
						</c:if> value="${gcuCourseCategory.name}">${gcuCourseCategory.name}</option>
					</c:forEach>	
                </select></td>
                <td id="removeRowTd_${status.index}" >
                <c:choose>                
				 <c:when test="${status.index eq 0 && (status.index +1) eq listCount }">
					 <a onclick="addArticulationAgreementTblRow('${status.index}');" class="addRow" name="addRow_${status.index}" id="addRow_${status.index}" href="javascript:void(0)"><img width="15" height="14" src="../images/addCourse.png" alt="add"> Add New</a>
				 </c:when>
                <c:when test="${status.index eq (listCount-1)}">
               		<a onclick="addArticulationAgreementTblRow('${status.index}');" class="addRow" name="addRow_${status.index}" id="addRow_${status.index}" href="javascript:void(0)"><img width="15" height="14" src="../images/addCourse.png" alt="add"> Add New</a><br/>
					<a class="removeInstitutionRow removeRow" name="removeRow_${status.index}" id="removeRow_${status.index}" href="#"><img width="15" height="15" alt="Delete" src="../images/removeIcon.png"> Remove</a>
				</c:when>
               </c:choose> 
                
                 </td>
            </tr>
			
            </c:forEach> 
		<c:if test="${listCount == 0 }">	 
            <tr>
               
                 <td><select id="gcuCourseCategory_${listCount}" class="eventCaptureField required" name="articulationAgreementDetailsList[${listCount}].gcuCourseCategory" >
                    <option id="" value="">Select Course Category</option>
					<c:forEach items="${gcuCourseCategoryList}" var="gcuCourseCategory">
						<option  value="${gcuCourseCategory.name}">${gcuCourseCategory.name}</option>
					</c:forEach>	
                </select></td>
                <td id="removeRowTd_${listCount}" ><a onclick="addArticulationAgreementTblRow('${listCount}');" class="addRow" name="addRow_${listCount}" id="addRow_${listCount}" href="javascript:void(0)"><img width="15" height="14" src="../images/addCourse.png" alt="add"> Add New</a> </td>
            </tr>
		</c:if>	
        </table>
        <br class="clear" />
        <div class="buttonRow">
			<input type="hidden" name="instituteId" value="${institutionId}">
			
        	 <c:if test="${not empty articulationAgreement.id }">
        	 	<input type="hidden" name="effective" value="${articulationAgreement.effective}"/>
       		 	<input type="hidden" name="id" value="${articulationAgreement.id}">
       		 </c:if>
       		 <c:if test="${currentlyActiveArticulationAgreement }">
        	 	<input type="hidden" name="effective" value="${currentlyActiveArticulationAgreement}"/>
       		 </c:if>
            <input name="" type="submit" value="Save" />
            <input name="" class="close" type="button" value="Cancel" /></div>
         
    </div>

</form:form>