<%@include file="../init.jsp" %>
<link rel="stylesheet" media="screen" href="<c:url value="/css/jquery.ui.autocomplete.css"/>" />

<script type='text/javascript' src="<c:url value="/js/jquery.ui.core.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.widget.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.position.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.autocomplete.js"/>"></script> 

<script type="text/javascript">

	jQuery(document).ready(function(){
		globalstatus='${courseMapping.evaluationStatus}';
	 });
function markEffectiveIfChecked(courseMappingId){
	if(jQuery("#effectiveCourseMapping").is(":checked")){
		jQuery("#endDate").attr("disabled","disabled");
		jQuery("[for='endDate']").remove();
	}else{
		jQuery("#endDate").removeAttr("disabled");
	}
}
</script>
 <c:choose>
   	<c:when test="${userRoleName =='Institution Evaluation Manager'}"> 
      	<c:set var="actionLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=saveCourseRelationship&transferCourseId=${transferCourseId}"/>
     	</c:when>
	<c:otherwise>
		<c:set var="actionLink" scope="session" value="/scheduling_system/evaluation/quality.html?operation=saveCourseRelationship&transferCourseMirrorId=${transferCourseMirrorId}"/>
 	</c:otherwise>
 </c:choose>   
  

<form method="post" action="${actionLink}" id="frmCourseRelationship">
 <div class="popCont">
        <h1><a href="#" class="close"></a> 
        <c:choose>
        <c:when test="${not empty courseMappingId}">
        	Edit
        </c:when>
        <c:otherwise>
        	Add
        </c:otherwise>
        </c:choose> Course  Relationship</h1>
        
        

        <label  class="caption caption5">GCU Course Code:<strong class="asterisk" style="font-size:14px;">*</strong></label>
        <input name="gcuCourse.courseCode" id="gcuCourseCode" type="text"  value="${courseMapping.gcuCourse.courseCode}" class="textField small required" /><br class="clear" />
		<input name="gcuCourse.id" id="gcuCourseId" type="hidden" value="${courseMapping.gcuCourse.id}"/>
        <input name="gcuCourse.credits" id="gcuCourseCredits" type="hidden" value="${courseMapping.gcuCourse.credits}"/>
        <input name="gcuCourse.courseLevelId" id="gcuCourseLevelId" type="hidden" value="${courseMapping.gcuCourse.courseLevelId}"/>
        <input name="gcuCourse.dateAdded" id="gcuDateAdded" type="hidden" value="<fmt:formatDate value="${courseMapping.gcuCourse.dateAdded}" pattern="MM/dd/yyyy"/>"/>
        
        <label class="caption caption5">Course Title:</label>
        <input name="gcuCourse.title" id="gcuCourseTitle" type="text" value="${courseMapping.gcuCourse.title}" readonly="true" class="textField"/><br class="clear" />
			
        <label class="caption caption5">Credits:</label>
        <input id="credits" name="credits" type="text" value="${courseMapping.credits}" readonly="true"  class="textField small  number" /><br class="clear" />

        <label class="caption caption5">Min TR Grade:</label>
        <input id= "minTransferGrade" name="minTransferGrade" type="text" readonly="true" value="${courseMapping.minTransferGrade}" class="textField small" />
        
        <br class="clear" />

        <label class="caption caption5">Effective Date:</label>
        <input id="effectiveDate" name="effectiveDate" type="text" readonly="true"  value='<fmt:formatDate value="${courseMapping.effectiveDate}" pattern="MM/dd/yyyy"/>'  class="textField small maskDate " /><br class="clear" />

       
       	<label class="caption caption5">Currently Active</label>
       	<input type="checkbox" class="floatLeft" name="effective" id="effectiveCourseMapping" 
       	<c:if test="${courseMapping.effective || currentlyActive}"> checked</c:if> <c:if test="${currentlyActive}"> disabled="disabled" </c:if> onclick="javaScript:markEffectiveIfChecked('${courseMappingId}');">
       	
       	<br class="clear" />
        <label class="caption caption5">End Date:</label>
      	<input id="endDate" name="endDate" type="text"  value='<fmt:formatDate value="${courseMapping.endDate}" pattern="MM/dd/yyyy"/>' class="textField small maskEndDate  requiredDateRange"  <c:if test="${courseMapping.effective}"> disabled="disabled" </c:if>/>
       <br class="clear" />

        <label class="caption caption5">Evaluation Status:</label>
         <select  name="evaluationStatus" id="evaluationStatus">
            <option>Eligible</option>
            <option>Not Eligible</option>
            <option>Pending Evaluation</option>
        </select><br class="clear" />
        <br class="clear" />
        <div class="buttonRow mt10 mb10 fr">
       		 <input type="hidden" name="trCourseId" value="${transferCourseId}">
       		 <input type="hidden" name="trCourseMirrorId" value="${transferCourseMirrorId}">
       		 <input type="hidden" name="institutionId" value="${institutionId}">
			 <input type="hidden" name="currentlyActive" value="${currentlyActive}">
			 <c:if test="${not empty courseMappingId}">
			 	<%-- <input type="hidden" name="effective" value="${courseMapping.effective}"/> --%>
				<input type="hidden" name="id" value="${courseMappingId}">
			 </c:if>
            <input name="saveCourseMapping" type="submit" value="Save" />
            <input name=""  class="close" type="button" value="Cancel" /></div>
    </div>
   </form>