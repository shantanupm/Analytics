<%@include file="../init.jsp" %>
<script type="text/javascript" src="<c:url value="/js/evaluationHome.js"/>"></script> 


<form:form  id="frmTranscriptKey" method="post" action="/scheduling_system/institution/manageInstitution.html?operation=saveInstitutionTranscriptKey&institutionId=${institutionId}" modelAttribute="institutionTranscriptKey">
 <div class="popCont">
        <h1><a href="#" class="close"></a>Transcript Key</h1>

        <label class="caption">Effective Date:</label>
        <input name="effectiveDate" type="text" value='<fmt:formatDate value="${institutionTranscriptKey.effectiveDate}" pattern="MM/dd/yyyy"/>'  class="textField  required maskDate date small" /><a href="#" id="A2"><span class="datepicker2" > </span></a><br class="clear" />

        <label class="caption">End Date:</label>
        <input name="endDate" type="text" class="textField maskDate date small" value='<fmt:formatDate value="${institutionTranscriptKey.endDate}" pattern="MM/dd/yyyy"/>'  /><a href="#" id="A1"><span class="datepicker2"> </span></a><br class="clear" />

        <label class="caption">Keys:</label>
        <br class="clear" />

        <table id="addTranscriptKeyTbl"  class="tableS2" width="100%" style="border-collapse: collapse; border-color: #AAAFB2"
            border="1" cellspacing="0" cellpadding="0">
            <tr>
                <th>From</th>
                <th>To</th>
                <th>GCU Course Level</th>
                <th>Action</th>
            </tr>
            
            
           <c:forEach items="${institutionTranscriptKey.institutionTranscriptKeyDetailsList}" var="institutionTranscriptKeyDetails" varStatus="status">
            <tr>
                <th><input  id="from_${status.index}" type="text"  name="institutionTranscriptKeyDetailsList[${status.index}].from" value="${institutionTranscriptKeyDetails.from}" class="textField small"  style="border:1px"  /></th>
                <th><input  id="to_${status.index}"type="text" name="institutionTranscriptKeyDetailsList[${status.index}].to" value="${institutionTranscriptKeyDetails.to}" class="textField small " style="border:1px"  /></th>
                <th><select class="eventCaptureField" name="institutionTranscriptKeyDetailsList[${status.index}].gcuCourseLevel.id" >
                    <option id="" value="">Select Course Level</option>
					<c:forEach items="${gcuCourseLevelList}" var="gcuCourseLevel">
						<option <c:if test="${institutionTranscriptKeyDetails.gcuCourseLevel.id == gcuCourseLevel.id}"> selected="true" </c:if> value="${gcuCourseLevel.id}">${gcuCourseLevel.name}</option>
					</c:forEach>	
                </select></th>
                <th id="removeRowTd_${status.index}" > </th>
            </tr>
			
            </c:forEach>
			<c:set var="listCount" value="${fn:length(institutionTranscriptKey.institutionTranscriptKeyDetailsList)}"/> 
			 
            <tr>
                <th><input  id="from_${listCount}" type="text"  name="institutionTranscriptKeyDetailsList[${listCount}].from" value="${institutionTranscriptKeyDetails.from}" class="textField small"  value="" style="border:1px"  /></th>
                <th><input  id="to_${listCount}"type="text" name="institutionTranscriptKeyDetailsList[${listCount}].to" value="${institutionTranscriptKeyDetails.to}" class="textField small " value="" style="border:1px"  /></th>
                <th><select class="eventCaptureField" name="institutionTranscriptKeyDetailsList[${listCount}].gcuCourseLevel.id" >
                    <option id="" value="">Select Course Level</option>
                    <script>  optionString='';</script>
					<c:forEach items="${gcuCourseLevelList}" var="gcuCourseLevel">
						<option  value="${gcuCourseLevel.id}">${gcuCourseLevel.name}</option>
						<script>
						  optionString=optionString+ '<option  value="${gcuCourseLevel.id}">${gcuCourseLevel.name}</option>';
						</script>
					</c:forEach>	
                </select></th>
                <th id="removeRowTd_${listCount}" > </th>
            </tr>
			
        </table>
        <br class="clear" />
        <div class="buttonRow">
        	 <c:if test="${not empty institutionTranscriptKey.id }">
       		 	<input type="hidden" name="id" value="${institutionTranscriptKey.id}">
       		 </c:if>
            <input name="" type="submit" value="Save" />
            <input name="" type="button"   class="close"  value="Cancel" /></div>
         
    </div>

</form:form>