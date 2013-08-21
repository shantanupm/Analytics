<%@include file="../init.jsp" %>
<script type="text/javascript" src="<c:url value="/js/evaluationHome.js"/>"></script> 


<form:form method="post" action="/scheduling_system/institution/manageInstitution.html?operation=saveArticulationAgreement&institutionId=${institutionId}" modelAttribute="articulationAgreement">
 <div class="popCont">
        <h1><a href="#" class="close"></a>Articulate Agreement</h1>

		<label class="caption">Other Institution Degree:</label>
        <input name="institutionDegree" type="text"  value="${articulationAgreement.institutionDegree}"  class="textField small" /><br class="clear" />

        <label class="caption">GCU Degree:</label>
        <input name="gcuDegree" type="text" class="textField small" value="${articulationAgreement.gcuDegree}"   /><br class="clear" />

		
        <label class="caption">Effective Date:</label>
        <input name="effectiveDate" type="text" value='<fmt:formatDate value="${articulationAgreement.effectiveDate}" pattern="MM/dd/yyyy"/>'  class="textField small maskDate" /><a href="#" id="A2"><span class="datepicker2" > </span></a><br class="clear" />

        <label class="caption">End Date:</label>
        <input name="endDate" type="text" class="textField small maskDate" value='<fmt:formatDate value="${articulationAgreement.endDate}" pattern="MM/dd/yyyy"/>'  /><a href="#" id="A1"><span class="datepicker2"> </span></a><br class="clear" />

        <label class="caption">GCU Course Category Requirement:</label>
        <br class="clear" />

        <table id="addArticulationAgreementTbl"  class="tableS2" width="100%" style="border-collapse: collapse; border-color: #AAAFB2"
            border="1" cellspacing="0" cellpadding="0">
            <tr>
                <th >Course Category</th>
				<th>Action</th>
               
            </tr>
            
            
           <c:forEach items="${articulationAgreement.articulationAgreementDetailsList}" var="articulationAgreementDetails" varStatus="status">
            <tr>
                 <th><select class="eventCaptureField" name="articulationAgreementDetailsList[${status.index}].gcuCourseCategory" >
                    <option id="" value="">Select Course Category</option>
					<c:forEach items="${gcuCourseCategoryList}" var="gcuCourseCategory">
						<option <c:if test="${articulationAgreementDetails.gcuCourseCategory == gcuCourseCategory.gcuCourseCategoryCode}"> selected="true" 
						</c:if> value="${gcuCourseCategory.gcuCourseCategoryCode}">${gcuCourseCategory.gcuCourseCategoryCode}</option>
					</c:forEach>	
                </select></th>
                <th id="removeRowTd_${status.index}" > </th>
            </tr>
			
            </c:forEach>
			<c:set var="listCount" value="${fn:length(articulationAgreement.articulationAgreementDetailsList)}"/> 
			 
            <tr>
               
                 <th><select id="gcuCourseCategory_${listCount}" class="eventCaptureField" name="articulationAgreementDetailsList[${listCount}].gcuCourseCategory" >
                    <option id="" value="">Select Course Category</option>
                    <script>  optionString='';</script>
					<c:forEach items="${gcuCourseCategoryList}" var="gcuCourseCategory">
						<option  value="${gcuCourseCategory.gcuCourseCategoryCode}">${gcuCourseCategory.gcuCourseCategoryCode}</option>
						<script>
						  optionString=optionString+ '<option  value="${gcuCourseCategory.gcuCourseCategoryCode}">${gcuCourseCategory.gcuCourseCategoryCode}</option>';
						</script>
					</c:forEach>	
                </select></th>
                <th id="removeRowTd_${listCount}" > </th>
            </tr>
			
        </table>
        <br class="clear" />
        <div class="buttonRow">
			<input type="hidden" name="instituteId" value="${institutionId}">
        	 <c:if test="${not empty articulationAgreement.id }">
       		 	<input type="hidden" name="id" value="${articulationAgreement.id}">
       		 </c:if>
            <input name="" type="submit" value="Save" />
            <input name="" class="close" type="button" value="Cancel" /></div>
         
    </div>

</form:form>