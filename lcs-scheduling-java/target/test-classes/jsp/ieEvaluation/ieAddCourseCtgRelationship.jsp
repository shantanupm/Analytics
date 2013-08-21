<%@include file="../init.jsp" %>
<script>

	jQuery(document).ready(function(){
		globalstatus1='${courseCategoryMapping.evaluationStatus}';
	});
	function markEffectiveIfChecked(courseMappingId){
		if(jQuery("#effectiveCourseCategoryMapping").is(":checked")){
			jQuery("#endDate").attr("disabled","disabled");
			jQuery("[for='endDate']").remove();
		}else{
			jQuery("#endDate").removeAttr("disabled");
		}
	}
</script>

 <c:choose>
   	<c:when test="${userRoleName =='Institution Evaluation Manager'}"> 
      	<c:set var="actionLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=saveCourseCtgRelationship"/>
     	</c:when>
	<c:otherwise>
		<c:set var="actionLink" scope="session" value="/scheduling_system/evaluation/quality.html?operation=saveCourseCtgRelationship"/>
 	</c:otherwise>
 </c:choose>   
  
<form id="frmCourseCtgRelationship" method="post" action="${actionLink}">
<div class="popCont">
        <h1><a href="#" class="close"></a>
        <c:choose>
        <c:when test="${not empty courseCategoryMappingId}">
        	Edit
        </c:when>
        <c:otherwise>
        	Add
        </c:otherwise>
        </c:choose> Course Category Relationship</h1>

        <label class="caption caption5">GCU Course Category :<strong class="asterisk" style="font-size:14px;">*</strong></label>
        <select name="gcuCourseCategory.id" id="selGcuCourseCtg" class="required">
        	<option id="" value="">Select Course Category</option>
        	<c:forEach items="${gcuCourseCategoryList}" var="gcuCourseCategory">
        		<option <c:if test="${courseCategoryMapping.gcuCourseCategory.id == gcuCourseCategory.id}"> selected="true" </c:if> value="${gcuCourseCategory.id}">${gcuCourseCategory.name}</option>
        	</c:forEach>
        </select>
       
		<br class="clear"/>
        <label class="caption caption5">Credits:<strong class="asterisk" style="font-size:14px;">*</strong></label>
        <input name="credits" type="text" value="${courseCategoryMapping.credits}" class="textField small required number" /><br class="clear" />

        <label class="caption caption5">Min TR Grade:</label>
        <%-- <input name="minTransferGrade" type="text" value="${courseCategoryMapping.minTransferGrade}" class="textField small" /><br class="clear" /> --%>
        <select name="minTransferGrade" id="minTransferGrade" class="w60 small " onchange="valuesChanged(this);">
	            		<option value=''>Min TR Grade</option>
	            		<option value="A" <c:if test="${courseCategoryMapping.minTransferGrade eq 'A'}">selected</c:if>>A</option>
	            		<option value="B" <c:if test="${courseCategoryMapping.minTransferGrade eq 'B'}">selected</c:if>>B</option>
	            		<option value="C" <c:if test="${courseCategoryMapping.minTransferGrade eq 'C'}">selected</c:if>>C</option>
	            		<option value="CR" <c:if test="${courseCategoryMapping.minTransferGrade eq 'CR'}">selected</c:if>>CR</option>
	                </select><br class="clear" />

        <label class="caption caption5">Effective Date:<strong class="asterisk" style="font-size:14px;">*</strong></label>
        <input id="effectiveDate" name="effectiveDate" type="text" value='<fmt:formatDate value="${courseCategoryMapping.effectiveDate}" pattern="MM/dd/yyyy"/>' class="textField small maskDate required" /><br class="clear" />

		<label class="caption caption5">Currently Active</label>
       	<input type="checkbox" class="floatLeft" name="effective" id="effectiveCourseCategoryMapping" 
       	<c:if test="${courseCategoryMapping.effective || currentlyActiveCategory}"> checked</c:if> <c:if test="${currentlyActiveCategory}"> disabled="disabled"</c:if> onclick="javaScript:markEffectiveIfChecked('${courseCategoryMappingId}');">
       	
       	<br class="clear" />
        <label class="caption caption5">End Date:</label>
        <input id="endDate" name="endDate" type="text" value='<fmt:formatDate value="${courseCategoryMapping.endDate}" pattern="MM/dd/yyyy"/>' class="textField small maskEndDate  requiredDateRange" <c:if test="${courseCategoryMapping.effective}"> disabled="disabled" </c:if>/><br class="clear" />
        
       <br class="clear" />
       
        <label class="caption caption5">Evaluation Status:</label>
         <select name="evaluationStatus" id="evaluationStatus">
            <option>Eligible</option>
            <option>Not Eligible</option>
            <option>Pending Evaluation</option>
        </select><br class="clear" />

        <br class="clear" />
        <div class="buttonRow mt10 mb10 fr">
        
        <input type="hidden" name="transferCourseMirrorId" value="${transferCourseMirrorId}">
        <input type="hidden" name="trCourseId" value="${transferCourseId}">
        <input type="hidden" name="institutionId" value="${institutionId}">
         <input type="hidden" id="gcuCourseCategoryName" name="gcuCourseCategoryName" value="${courseCategoryMapping.gcuCourseCategory.name}" >
          <input type="hidden" name="currentlyActiveCategory" value="${currentlyActiveCategory}" >
         
        <c:if test="${not empty courseCategoryMappingId}">
        	<%-- <input type="hidden" name="effective" value="${courseCategoryMapping.effective}"/> --%>
        	<input type="hidden" name="id" value="${courseCategoryMappingId}">
        </c:if>
            <input name="saveCourseCategoryMapping" type="submit" value="Save" />
            <input name=""  class="close" type="button" value="Cancel" /></div>
    </div>
  </form>