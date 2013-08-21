<%@include file="../init.jsp" %>
<script type="text/javascript" src="<c:url value="/js/evaluationHome.js"/>"></script> 
<script type="text/javascript">
jQuery(document).ready(function(){
	optionString ="";
	<c:forEach items="${gcuCourseLevelList}" var="gcuCourseLevel">
	
	 		 optionString = optionString+ '<option  value="${gcuCourseLevel.id}">${gcuCourseLevel.name}</option>';
	
		</c:forEach>
});
function addInstitutionTranscriptKeyRow(placeholder){	
	
	var placeholder = parseInt(placeholder) + 1 ;
	var appendInsText = 
		"<tr><td><input id='from_"+placeholder+"' name='institutionTranscriptKeyDetailsList["+placeholder+"].from' type='text' class='txbx w60 required' /></td>"
	    +
	    "<td><input name='institutionTranscriptKeyDetailsList["+placeholder+"].to' id='to_"+placeholder+"' type='text' class='txbx w60 required '/></td>"
	    +
	    "<td><select id='courseLevelId_"+placeholder+"' name='institutionTranscriptKeyDetailsList["+placeholder+"].gcuCourseLevel.id' class=' eventCaptureField' > <option id='' value=''>Select Course Level</option>"+optionString+"</select>"
	    +" <input type='hidden' id='courseLevelName_"+placeholder+"' name='institutionTranscriptKeyDetailsList["+placeholder+"].gcuCourseLevel.name' /> </td>"
	    +
		"<td id='removeRowTd_"+placeholder+"'>"
	    +"<a onclick='addInstitutionTranscriptKeyRow("+placeholder+");' class='addRow' name='addRow_"+placeholder+"' id='addRow_"+placeholder+"' href='javascript:void(0)'><img width='15' height='14' src='../images/addCourse.png' alt='add'> Add New</a><br/><a href='#' src='../images/removeIcon.png'  id='removeRow_"+placeholder+"' name='removeRow_"+placeholder+"' class='removeInstitutionRow removeRow'><img width='15' height='15' src='../images/removeIcon.png' alt='Delete'>Remove</a></td></tr>";
		//alert(appendInsText);
		addRowsAtFly( 'eventCaptureField', 'blur', 'addTranscriptKeyTbl', 'removeRowTd_', appendInsText, placeholder );
}
</script>
 <c:choose>
   	<c:when test="${role=='MANAGER'}"> 
      	<c:set var="actionLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=saveInstitutionTranscriptKey&institutionId=${institutionId}"/>
     	</c:when>
	<c:otherwise>
		<c:set var="actionLink" scope="session" value="/scheduling_system/evaluation/quality.html?operation=saveInstitutionTranscriptKey&institutionMirrorId=${institutionMirrorId}"/>
 	</c:otherwise>
 </c:choose> 
<c:set var="listCount" value="${fn:length(institutionTranscriptKey.institutionTranscriptKeyDetailsList)}"/>

<form:form  id="frmTranscriptKey" method="post" action="${actionLink}" modelAttribute="institutionTranscriptKey">
 <div class="popCont">
	<h1><a href="#" class="close"></a>Transcript Key</h1>

	<label class="noti-pop-labl">Effective Date:<strong class="asterisk" style="font-size:14px;">*</strong></label>
	<input id="effectiveDate" name="effectiveDate" type="text" value='<fmt:formatDate value="${institutionTranscriptKey.effectiveDate}" pattern="MM/dd/yyyy"/>'  class="textField  required maskDate date small" /><br class="clear" />

	<label class="noti-pop-labl">End Date:</label>
	<input id="endDate" name="endDate" type="text" class="textField maskDate  small  requiredDateRange" value='<fmt:formatDate value="${institutionTranscriptKey.endDate}" pattern="MM/dd/yyyy"/>'  /><br class="clear" />

	<label class="noti-pop-labl">Keys:</label>
	<br class="clear" />
	
	<table id="addTranscriptKeyTbl"  class="noti-tbl1" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <th width="20%">From<strong class="asterisk" style="font-size:14px;">*</strong></th>
                <th width="20%" class="dividerGrey"><span>To<strong class="asterisk" style="font-size:14px;">*</strong></span></th>
                <th width="40%" class="dividerGrey"><span>GCU Course Level<strong class="asterisk" style="font-size:14px;">*</strong></span></th>
                <th width="20%" class="dividerGrey"><span>Action</span></th>
            </tr>
			
			<c:forEach items="${institutionTranscriptKey.institutionTranscriptKeyDetailsList}" var="institutionTranscriptKeyDetails" varStatus="status">
            
			<tr>
                <td><Span><input  id="from_${status.index}" type="text"  name="institutionTranscriptKeyDetailsList[${status.index}].from" value="${institutionTranscriptKeyDetails.from}" class="txbx w60 required" /></span></td>
                <td><Span><input  id="to_${status.index}"type="text" name="institutionTranscriptKeyDetailsList[${status.index}].to" value="${institutionTranscriptKeyDetails.to}" class="txbx w60 required" /></span></td>
                <td><span><select id="courseLevelId_${status.index}"  class="eventCaptureField required" name="institutionTranscriptKeyDetailsList[${status.index}].gcuCourseLevel.id" >
                    <option id="" value="">Select Course Level</option>
					<c:forEach items="${gcuCourseLevelList}" var="gcuCourseLevel">
						<option <c:if test="${institutionTranscriptKeyDetails.gcuCourseLevel.id == gcuCourseLevel.id}"> selected="true" </c:if> value="${gcuCourseLevel.id}">${gcuCourseLevel.name}</option>
					</c:forEach>	
                </select></span>
                <input id="courseLevelName_${status.index}" type="hidden" value="${institutionTranscriptKeyDetails.gcuCourseLevel.name}" name="institutionTranscriptKeyDetailsList[${status.index}].gcuCourseLevel.name" />
                </td>
                 
                <td id="removeRowTd_${status.index}" > 
                 <c:choose>                 
					 <c:when test="${status.index eq 0 && (status.index +1) eq listCount}">
					 	<a onclick="addInstitutionTranscriptKeyRow('${status.index}');" class="addRow" name="addRow_${status.index}" id="addRow_${status.index}" href="javascript:void(0)"><img width="15" height="14" src="../images/addCourse.png" alt="add"> Add New</a>
					 </c:when>
	                <c:when test="${status.index eq (listCount-1)}">
						<a onclick="addInstitutionTranscriptKeyRow('${status.index}');" class="addRow" name="addRow_${status.index}" id="addRow_${status.index}" href="javascript:void(0)"><img width="15" height="14" src="../images/addCourse.png" alt="add"> Add New</a><br/>
						<a class="removeInstitutionRow removeRow" name="removeRow_${status.index}" id="removeRow_${status.index}" href="#"><img width="15" height="15" alt="Delete" src="../images/removeIcon.png"> Remove</a>
					</c:when>
				 </c:choose>		
				</td>
            </tr>
			
            </c:forEach>
			 
			<c:if test="${listCount == 0 }">
	            <tr class="noBorder">
	                <td><Span><input  id="from_${listCount}" type="text"  name="institutionTranscriptKeyDetailsList[${listCount}].from" value="${institutionTranscriptKeyDetails.from}" class="txbx w60 required"  value="" /></span></td>
	                <td><Span><input  id="to_${listCount}"type="text" name="institutionTranscriptKeyDetailsList[${listCount}].to" value="${institutionTranscriptKeyDetails.to}" class="txbx w60 required " value="" /></span></td>
	                <td><span><select  id="courseLevelId_${listCount}" class="eventCaptureField required" name="institutionTranscriptKeyDetailsList[${listCount}].gcuCourseLevel.id" >
	                    <option id="" value="">Select Course Level</option>
						<c:forEach items="${gcuCourseLevelList}" var="gcuCourseLevel">
							<option  value="${gcuCourseLevel.id}">${gcuCourseLevel.name}</option>
							
						</c:forEach>	
	                </select></span>
	                <input id="courseLevelName_${listCount}" type="hidden" value="${institutionTranscriptKeyDetailsList[listCount].gcuCourseLevel.name}" name="institutionTranscriptKeyDetailsList[${listCount}].gcuCourseLevel.name" />
	                </td>
	                <td id="removeRowTd_${listCount}" > 
	                	<a onclick="addInstitutionTranscriptKeyRow('${listCount}');" class="addRow" name="addRow_${listCount}" id="addRow_${listCount}" href="javascript:void(0)"><img width="15" height="14" src="../images/addCourse.png" alt="add"> Add New</a>
	                	<%-- <a class="removeInstitutionRow removeRow" name="removeRow_${status.index}" id="removeRow_${listCount}" href="#"><img width="15" height="15" alt="Delete" src="../images/removeIcon.png"> Remove</a> --%>
	                </td>
	            </tr>
			</c:if> 
        </table>
		<div class="dividerPopup mt25"></div>
	
	<div class="btn-cnt">
		 <c:if test="${not empty institutionTranscriptKey.id }">
			<input type="hidden" name="id" value="${institutionTranscriptKey.id}">
			<input type="hidden" name="effective" value="${institutionTranscriptKey.effective}"/>
		 </c:if>
		 
		  <c:if test="${currentlyActiveTranscriptKey}">
			<input type="hidden" name="effective" value="${currentlyActiveTranscriptKey}"/>
		 </c:if>
		<input name="" type="submit" value="Save" />
		<input name="" type="button"   class="close"  value="Cancel" />
	</div>
</div>



</form:form>