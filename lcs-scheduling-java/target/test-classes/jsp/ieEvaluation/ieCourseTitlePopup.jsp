<%@page import="com.ss.common.util.UserUtil"%>
<%@page import="com.ss.user.value.User"%>
 <%@include file="../init.jsp" %>
 <script type="text/javascript">
  jQuery(document).ready(function(){
  
		jQuery("#frmCourseTitleId").validate();
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
		 var addCourseTitleRow = '<tr id="courseTitleRow_'+index+'">'+'<td><input class="txbx w80 required" type="text" id="titleList_'+index+'" name="titleList['+index+'].title" value=""><span></span></td>'+
	         					'<td><input class="txbx w80 maskEffectiveDate" type="text" name="titleList['+index+'].effectiveDate" value=""><span></span></td>'+
	         					'<td><input class="txbx w80 maskEffectivEndDate" type="text" name="titleList['+index+'].endDate" value=""><span><span></span></span></td>'+
	         					'<td align="center">&nbsp;</td>'+
	         					'<td align="center">'+
		        				 '<span><input type="radio" class="floatLeft" name="effective" id="effectiveCourseTitle_'+index+'"></span>'+
	        					 '</td><td><a class="removeCrossIcon fr mt5 mr10 removeRowTitleRow" href="javascript:void(0);"></a><span></span></td>'+
	         					'</tr>';
	     jQuery("#courseTitleBodyId tr:last").after(addCourseTitleRow);
	     settingMaskInputForPopup();
	 }
	 function saveCourseTitle(role){
		 var effectiveIndex = jQuery("#frmCourseTitleId input[type='radio']:checked").attr("id").split("_")[1];
		 jQuery("#currentlyActiveTitleIndexId").val(effectiveIndex);
		 var isDuplicate=false;
		 
		  jQuery("#frmCourseTitleId input[id^=titleList_]").each(function() {
			  var instance0 = jQuery(this);
			  jQuery("#frmCourseTitleId input[id^=titleList_]").each(function() {
				  
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
      	<c:set var="actionLink" scope="session" value="/evaluation/ieManager.html?operation=saveTransferCourseTitle&transferCourseId=${transferCourseId}"/>
     </c:when>
	<c:otherwise>
		<c:choose>
			<c:when test="${! empty transferCourseMirrorId}"> 
				<c:set var="actionLink" scope="session" value="/evaluation/quality.html?operation=saveTransferCourseTitle&fromQueue=${fromQueue }&transferCourseId=${transferCourseId}&transferCourseMirrorId=${transferCourseMirrorId}&transferCourseMirrorIdExist=1"/>
			 </c:when>
			 <c:otherwise>
			 	<c:set var="actionLink" scope="session" value="/evaluation/quality.html?operation=saveTransferCourseTitle&fromQueue=${fromQueue }&transferCourseId=${transferCourseId}&transferCourseMirrorIdExist=0"/>
			 </c:otherwise>
		 </c:choose>
 	</c:otherwise>
 </c:choose> 
 <form method="post" id="frmCourseTitleId" name="frmCourseTitle" action="<c:url value='${actionLink}'/>"  onsubmit="return saveCourseTitle('${role}');"">
<div class="popCont popUpBig" style="width:700px;">
    <h1><a class="close" title="close"></a>Course Title</h1>
    
    <div style="height:190px; overflow:auto" class="mt25">
    <div style="border:1px solid #e7e7e7;" class="institute">
  	
	
    <table width="100%" cellspacing="0" cellpadding="0" border="0" class="noti-tbl3" id="courseTitleBodyId">
       <tbody>
       <tr id="courseTitleRow_-1">
         <th width="37%" scope="col" class="dividerGrey">Course Title</th>
         <th width="15%" class="dividerGrey" scope="col">Effective Date</th>
         <th width="15%" class="dividerGrey" scope="col">End Date</th>
         <th width="18%" align="center" class="dividerGrey" scope="col">Evaluation Status</th>
          <th width="10%" align="center" class="dividerGrey" scope="col">Effective</th>
          <th width="3%" align="center" class="dividerGrey" scope="col"></th>
         </tr>
         <c:choose>
	       <c:when test="${fn:length(courseTitleList) gt 0 }">
		       <c:forEach items="${courseTitleList }" var="transferCourseTitle" varStatus="transferCourseTitleIndex">
			       <tr id="courseTitleRow_${transferCourseTitleIndex.index }">
			         <td><input class="txbx w80 required" type="text" name="titleList[${transferCourseTitleIndex.index }].title" id="titleList_${transferCourseTitleIndex.index }" value="${transferCourseTitle.title}"><span></span></td>
			         <td><input class="txbx w80 maskEffectiveDate" type="text" name="titleList[${transferCourseTitleIndex.index }].effectiveDate" value="<fmt:formatDate value='${transferCourseTitle.effectiveDate}' pattern="MM/dd/yyyy"/>"><span></span></td>
			         <td><input class="txbx w80 maskEffectivEndDate" type="text" name="titleList[${transferCourseTitleIndex.index }].endDate" value='<fmt:formatDate value="${transferCourseTitle.endDate}" pattern="MM/dd/yyyy"/>'><span><span></span></span></td>
			         <td align="center">${transferCourseTitle.evaluationStatus }</td>
			         <td align="center"><span>
			           <input type="radio" class="floatLeft" name="effective" id="effectiveCourseTitle_${transferCourseTitleIndex.index }" 
		       		   <c:if test="${transferCourseTitle.effective || currentlyActiveTitle}"> checked</c:if>  onclick="javaScript:markEffectiveIfChecked('${courseTitleId}');">  	<br class="clear" />
		       	   
			         </span>
			         <input type="hidden" name="titleList[${transferCourseTitleIndex.index }].id" value="${transferCourseTitle.id}">
			         <input type="hidden" name="titleList[${transferCourseTitleIndex.index }].evaluationStatus" value="EVALUATED">
			         <input type="hidden" name="titleList[${transferCourseTitleIndex.index }].transferCourseId" value="${transferCourseTitle.transferCourseId}">
			         </td>
			         <td></td>
			         </tr>
		       </c:forEach>
	       </c:when>
	       <c:otherwise>
	        <tr id="courseTitleRow_0">
			         <td><input class="txbx w80 required" type="text" name="titleList[0].title" value=""></td>
			         <td><input class="txbx w80 maskEffectiveDate" type="text" name="titleList[0].effectiveDate" value=""></td>
			         <td><input class="txbx w80 maskEffectivEndDate" type="text" name="titleList[0].endDate" value=""></td>
			         <td align="center">&nbsp;</td>
			         <td align="center">
				         <span>
				           <input type="radio" class="floatLeft" name="effective" id="effectiveCourseTitle_0">
				         </span>
			         </td>
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