<%@page import="com.ss.common.util.UserUtil"%>
<%@page import="com.ss.user.value.User"%>
 <%@include file="../init.jsp" %>
 <script type="text/javascript">
  jQuery(document).ready(function(){
  
		jQuery("#frmCourseTitleId").validate();
		jQuery("[id^='courseLevel_']").live('on keyup', function(event) {
			jQuery(this).val(jQuery(this).val().toUpperCase());
		});
		//settingMaskInput();
		jQuery(".removeRowTitleRow").live('click', function(event) {
			//remove the current row
			jQuery(this).parent().parent().remove();
			
		} );
		
	});
</script> 
 <script type="text/javascript">
	 function addCourseTitleBody(){
		 var courseRowId = jQuery("#courseTitleBodyId tr:last").attr("id").split("_");
			index = parseInt(courseRowId[1]) + 1;
		 var addCourseTitleRow = '<tr id="courseTitleRow_'+index+'">'+'<td><input class="txbx w80 required" type="text" id="militarySubjectList_'+index+'" name="militarySubjectList['+index+'].name"><span></span></td>'+
		 					     '<td><input class="txbx w30" type="text" name="militarySubjectList['+index+'].courseLevel" id="courseLevel_'+index+'"><span></span></td>'+
		 						 '<td><input class="txbx w80" type="text" name="militarySubjectList['+index+'].socCategoryCode" id="socCategoryCode_'+index+'"><span></span></td>'+	         					 
	        					 '<td><a class="removeCrossIcon fr mt5 mr10 removeRowTitleRow" href="javascript:void(0);"></a><span></span></td>'+
	         					 '</tr>';
	     jQuery("#courseTitleBodyId tr:last").after(addCourseTitleRow);
	 }
	 function saveMilitarySubject(role){
		 jQuery("#frmCourseTitleId input[id^=militarySubjectList_]").removeClass('redBorder');
		 var isDuplicate=false;
		 
		  jQuery("#frmCourseTitleId input[id^=militarySubjectList_]").each(function() {
			  var instance0 = jQuery(this);
			  jQuery("#frmCourseTitleId input[id^=militarySubjectList_]").each(function() {
				  
				  var title1 = jQuery(this).val();
				  var titleId1 = jQuery(this).attr("id");
				  outerLoop:
				  if(jQuery(this).attr("id") != instance0.attr("id") && title1 == instance0.val()){
					  jQuery(this).addClass( "redBorder" );
					  isDuplicate = true;
					  break outerLoop;
				  }
			  });
		  });
		  
		  if(isDuplicate == true){
			  alert("Duplicate title not allowed.");
			  return false;
		  }
	 }
 </script>
 <% User currentUser = UserUtil.getCurrentUser();
    request.setAttribute("userRoleName", UserUtil.getCurrentRole().getDescription()); %>
    
<c:choose>
   	<c:when test="${userRoleName =='Institution Evaluation Manager'}"> 
      	<c:set var="actionLink" scope="session" value="/evaluation/ieManager.html?operation=saveTransferCourseMilitarySubject&transferCourseId=${transferCourseId}"/>
     </c:when>
	<c:otherwise>
		<c:choose>
			<c:when test="${! empty transferCourseMirrorId}"> 
				<c:set var="actionLink" scope="session" value="/evaluation/quality.html?operation=saveTransferCourseMilitarySubject&fromQueue=${fromQueue }&transferCourseId=${transferCourseId}&transferCourseMirrorId=${transferCourseMirrorId}&transferCourseMirrorIdExist=1"/>
			 </c:when>
			 <c:otherwise>
			 	<c:set var="actionLink" scope="session" value="/evaluation/quality.html?operation=saveTransferCourseMilitarySubject&fromQueue=${fromQueue }&transferCourseId=${transferCourseId}&transferCourseMirrorIdExist=0"/>
			 </c:otherwise>
		 </c:choose>
 	</c:otherwise>
 </c:choose> 
 <form method="post" id="frmCourseTitleId" name="frmCourseTitle" action="<c:url value='${actionLink}'/>"  onsubmit="return saveMilitarySubject('${role}');"">
<div class="popCont popUpBig" style="width:700px;">
    <h1><a class="close" title="close"></a>Subject(s) Details</h1>
    
    <div style="height:190px; overflow:auto" class="mt25">
    <div style="border:1px solid #e7e7e7;" class="institute">
  	
	
    <table width="100%" cellspacing="0" cellpadding="0" border="0" class="noti-tbl3" id="courseTitleBodyId">
       <tbody>
       <tr id="courseTitleRow_-1">
         <th width="38%" scope="col" class="dividerGrey">Subject</th>
         <th width="14%" class="dividerGrey" scope="col">Course Level</th>
         <th width="45%" class="dividerGrey" scope="col">SOC Category Code</th>        
         <th width="3%" class="dividerGrey" scope="col"></th>
         </tr>
         <c:choose>
	       <c:when test="${fn:length(militarySubjectList) gt 0 }">
		       <c:forEach items="${militarySubjectList }" var="militarySubject" varStatus="militarySubjectIndex">
			       <tr id="courseTitleRow_${militarySubjectIndex.index }">
			         <td><input class="txbx w80 required" type="text" name="militarySubjectList[${militarySubjectIndex.index }].name" id="militarySubjectList_${militarySubjectIndex.index }" value="${militarySubject.name}"><span></span></td>
			         <td><input class="txbx w30 " type="text" name="militarySubjectList[${militarySubjectIndex.index }].courseLevel" id="courseLevel_${militarySubjectIndex.index }" value="${militarySubject.courseLevel }"></td>
			         <td><input class="txbx w80 " type="text" name="militarySubjectList[${militarySubjectIndex.index }].socCategoryCode" id="socCategoryCode_${militarySubjectIndex.index }" value="${militarySubject.socCategoryCode }"><span></span></td>
			         <td>
			         	<input type="hidden" name="militarySubjectList[${militarySubjectIndex.index }].id" value="${militarySubject.id}">
			         	<input type="hidden" name="militarySubjectList[${militarySubjectIndex.index }].transferCourseId" value="${militarySubject.transferCourseId}">
			         	<input type="hidden" name="militarySubjectList[${militarySubjectIndex.index }].modifiedBy" value="${militarySubject.modifiedBy}">
			         	<input type="hidden" name="militarySubjectList[${militarySubjectIndex.index }].modifiedDate" value='<fmt:formatDate value="${militarySubject.modifiedDate}" pattern="MM/dd/yyyy"/>'>	
			         	<input type="hidden" name="militarySubjectList[${militarySubjectIndex.index }].createdBy" value="${militarySubject.createdBy}">	
			         	<input type="hidden" name="militarySubjectList[${militarySubjectIndex.index }].createdDate" value='<fmt:formatDate value="${militarySubject.createdDate}" pattern="MM/dd/yyyy"/>'>			         
			         </td>
			         </tr>
		       </c:forEach>
	       </c:when>
	       <c:otherwise>
	        <tr id="courseTitleRow_0">
			         <td><input class="txbx w80 required" type="text" name="militarySubjectList[0].name" id="militarySubjectList_0"></td>
			         <td><input class="txbx w30 " type="text" name="militarySubjectList[0].courseLevel" id="courseLevel_0"></td>
			         <td><input class="txbx w80 " type="text" name="militarySubjectList[0].socCategoryCode" id="socCategoryCode_0"></td>
			         <td></td>
			         </tr>
	       		
	       </c:otherwise>
	       </c:choose>
       </tbody>
     </table>
    </div>
    <div class="mt10" style="margin-left:2px;">
  	  <div class="institutionHeader">
     	<a onclick="javaScript:addCourseTitleBody();" href="javascript:void(0)"><img src="<c:url value='../images/termTypeIcon.png'/>" alt="">Add New</a>      </div>
    </div>
    
      <div class="dividerPopup mt25"></div>
      <input type="hidden" name="institutionId" value="${institutionId}">
      <input type="hidden" name="currentlyActiveTitleIndex" id="currentlyActiveTitleIndexId" value="0">
      
  </div>
   <div class="btn-cnt">
   <div class="fr">
			<input type="submit" name="saveInstitution" value="Save" id="saveInstitution" class="button">
			<input type="button" name="cancel" value="Cancel" id="cancelInstitution" class="close button">
		</div>
            <div class="clear"></div>
  </div>
  
</div>
</form> 