<%@include file="../init.jsp" %>

<script>
jQuery(document).ready(function(){
	jQuery(document).ready(function(){
		globalstatus='${courseTitle.evaluationStatus}';
		});
});
function markEffectiveIfChecked(courseTitleId){
	if(jQuery("#effectiveCourseTitle").is(":checked")){
		jQuery("#endDate").attr("disabled","disabled");
		jQuery("[for='endDate']").remove();
	}else{
		jQuery("#endDate").removeAttr("disabled");
	}
}
</script>
 <c:choose>
   	<c:when test="${userRoleName =='Institution Evaluation Manager'}"> 
      	<c:set var="actionLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=saveCourseTitles&transferCourseId=${transferCourseId}"/>
     	</c:when>
	<c:otherwise>
		<c:set var="actionLink" scope="session" value="/scheduling_system/evaluation/quality.html?operation=saveCourseTitles&transferCourseMirrorId=${transferCourseMirrorId}"/>
 	</c:otherwise>
 </c:choose>   
  

<form method="post" action="${actionLink}" id="frmCourseTitle">
 <div class="popCont">
        <h1><a href="#" class="close"></a> 
        <c:choose>
        <c:when test="${not empty courseTitleId}">
        	Edit
        </c:when>
        <c:otherwise>
        	Add
        </c:otherwise>
        </c:choose> Course  Title</h1>
        
        

       

        <label class="caption caption5">Course Title:<strong class="asterisk" style="font-size:14px;">*</strong></label>
        <input name="title" type="text" value="${courseTitle.title}" class="textField required" /><br class="clear" />

        <label class="caption caption5">Effective Date:<strong class="asterisk" style="font-size:14px;">*</strong></label>
        <input id="effectiveDate" name="effectiveDate" type="text" value='<fmt:formatDate value="${courseTitle.effectiveDate}" pattern="MM/dd/yyyy"/>'  class="textField small maskDate required" /><br class="clear" />


		<label class="caption caption5">Currently Active</label>
       	<input type="checkbox" class="floatLeft" name="effective" id="effectiveCourseTitle" 
       	<c:if test="${courseTitle.effective || currentlyActiveTitle}"> checked</c:if> <c:if test="${currentlyActiveTitle}"> disabled="disabled" </c:if> onclick="javaScript:markEffectiveIfChecked('${courseTitleId}');">  	<br class="clear" />
       	     	
        <label class="caption caption5">End Date:</label>
       	<input id="endDate" name="endDate" type="text"  value='<fmt:formatDate value="${courseTitle.endDate}" pattern="MM/dd/yyyy"/>' class="textField small maskEndDate  requiredDateRange" />
       
       	
       	<br class="clear" />
 
         <br class="clear" />
        <br class="clear" />
        <div class="buttonRow mt10 mb10 fr">
       		 <input type="hidden" name="trCourseId" value="${transferCourseId}">
       		 <input type="hidden" name="trCourseMirrorId" value="${transferCourseMirrorId}">
       		 <input type="hidden" name="institutionId" value="${institutionId}">
       		 <input type="hidden" name="currentlyActiveTitle" value="${currentlyActiveTitle}">
       		 
			 <c:if test="${not empty courseTitleId}">
			 	<%-- <input type="hidden" name="effective" value="${courseTitle.effective}"/> --%>
				<input type="hidden" name="id" value="${courseTitleId}">
			 </c:if>
            <input name="savecourseTitle" type="submit" value="Save" />
            <input name=""  class="close" type="button" value="Cancel" /></div>
    </div>
   </form>