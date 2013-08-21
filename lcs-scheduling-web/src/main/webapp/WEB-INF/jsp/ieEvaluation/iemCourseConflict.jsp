<%@include file="../init.jsp" %>


 <script type="text/javascript">
function updateCourse(type) {
	 var url;
	 var selectedCourse=jQuery("[name='selectCourse']:checked").val();
	 if(selectedCourse==''||selectedCourse===undefined){
		 alert('Please Select Course');
	 }else if(type=='submit'){	
		url="<c:url value='/evaluation/ieManager.html?operation=submitCourse&selectedCourse="+selectedCourse+"'/>";
		window.location.href=url
	 }else{
		 url="<c:url value='/evaluation/ieManager.html?operation=editCourse&selectedCourse="+selectedCourse+"'/>";
		 window.location.href=url
	 }
	 	
	}


jQuery(document).ready(function(){
	// Tabs
	//jQuery('#tabs').tabs({ selected: 0 });
	//validation
	//jQuery("#conflictCourseForm").validate();
	
	jQuery(':radio').change(function(){
		//alert(jQuery(this).attr('name'));
		var rdname=jQuery(this).attr('name').split('_')[1];
		//alert(jQuery(this).val()+'---'+rdname);
		jQuery('#'+rdname).val(jQuery(this).val());
		if(rdname.split('-')[0] == 'cmCourseCode'){
			var pos = rdname.split('-')[1];
			jQuery("#cmCourseId-"+pos).val(jQuery(this).attr('courseMappingId'));
		}
	});
/*	jQuery('[id^="cmCourseCode-"]').each(function(){
		var pos = jQuery(this).attr('id').split('-')[1];
		jQuery(this).change(function(){
			jQuery('#cmCourseId'+pos).val();
		});
	});
*/	
	jQuery('.cmCourseCode').autocomplete({
	 		
			//source: availableTags,
			source: function( request, response ) {
				jQuery.ajax({
				url: "quality.html?operation=getCourseCode&gcuCourseCode="+request.term,
				dataType: "json",
				data: {
					style: "full",
					maxRows: 5,
					name_startsWith: request.term
				},
				success: function( data ) {
					
					jQuery(this).removeClass('auto-load');
					response( jQuery.map( data, function( item ) {
						
							return {
								label: item.courseCode ,
								value: item.courseCode,
								gcuCourseId : item.id
								
							}
						
					}));
				},
				error: function(xhr, textStatus, errorThrown){
					jQuery(this).removeClass('auto-load');
					
				},
				

			});
		},
		
		minLength: 2,
		 search: function(event, ui) {  jQuery(this).addClass("auto-load"); },
		 open: function(event, ui) { jQuery(this).removeClass("auto-load"); },
		select: function(event, ui) {
			var pos = jQuery(this).attr('id').split('-')[1];
			jQuery("#cmCourseId-"+pos).val(ui.item.gcuCourseId);
			
		
		}
		
	 	});
	
	
});
</script>
<script type="text/javascript">
jQuery(function() {
	jQuery("h1.expand").toggler(); 
	jQuery("#divContBoxLft").expandAll({trigger: "h1.expand"});
	jQuery("#divContBoxRgt").expandAll({trigger: "h1.expand"});
		
	jQuery('.collapse:first').hide();
	jQuery('h1.expand:first a:first').addClass("close"); 
});
function enableDisabledChecks(checkBoxId1,checkBoxId2,currentId,controlNameToAccess,globalCheckboxId,loopLenth){
	var index = currentId.split("_")[1];
	
	if(jQuery("#"+currentId).is(':checked')){
		jQuery("[id^='"+checkBoxId1+"']").each(function(){
			jQuery(this).attr("disabled","disabled");
		});
		jQuery("[id^='"+checkBoxId2+"']").each(function(){
			jQuery(this).attr("disabled","disabled");
		});
		
		if(controlNameToAccess == 'CourseMapping'){
			
			/* if(jQuery("#"+currentId).attr('coursemappingevaluationstatus') != null && jQuery("#"+currentId).attr('coursemappingevaluationstatus') !=''){
				jQuery("#courseMappingEvaluationStatus_"+index).val(jQuery("#"+currentId).attr('coursemappingevaluationstatus'));
				jQuery("#courseMappingEvaluationStatus_"+index).removeAttr("disabled");
			}
			if(jQuery("#"+currentId).attr('coursemappingenddate') != null && jQuery("#"+currentId).attr('coursemappingenddate') !=''){
				// jQuery("#"+currentId).attr('coursemappingenddate');
				jQuery("#courseMappingEndDate_"+index).val(jQuery("#"+currentId).attr('coursemappingenddate'));
				jQuery("#courseMappingEndDate_"+index).removeAttr("disabled");
			}
			if(jQuery("#"+currentId).attr('gcucoursecredits') != null && jQuery("#"+currentId).attr('gcucoursecredits')!=''){
				jQuery("#gcuCourseCredits_"+index).val(parseFloat(jQuery("#"+currentId).attr('gcucoursecredits')));
				jQuery("#gcuCourseCredits_"+index).removeAttr("disabled");
			}
			if(jQuery("#"+currentId).attr('gcucoursetitle') != null && jQuery("#"+currentId).attr('gcucoursetitle') !=''){
				jQuery("#gcuCourseTitle_"+index).val(jQuery("#"+currentId).attr('gcucoursetitle'));
				jQuery("#gcuCourseTitle_"+index).removeAttr("disabled");
			}
			if(jQuery("#"+currentId).attr('coursemappingeffectivedate') != null && jQuery("#"+currentId).attr('coursemappingeffectivedate') !=''){
				jQuery("#courseMappingEffectiveDate_"+index).val(jQuery("#"+currentId).attr('coursemappingeffectivedate'));
				jQuery("#gcuDateAdded_"+index).val(jQuery("#"+currentId).attr('coursemappingeffectivedate'));
				jQuery("#courseMappingEffectiveDate_"+index).removeAttr("disabled");
				jQuery("#gcuDateAdded_"+index).removeAttr("disabled");
				
			}
			if(jQuery("#"+currentId).attr('gcucoursecode') != null && jQuery("#"+currentId).attr('gcucoursecode') !=''){
				jQuery("#gcuCourseCode_"+index).val(jQuery("#"+currentId).attr('gcucoursecode'));
				jQuery("#gcuCourseCode_"+index).removeAttr("disabled");
			}
			if(jQuery("#"+currentId).attr('gcuCourseLevelId') != null && jQuery("#"+currentId).attr('gcuCourseLevelId') !=''){
				jQuery("#gcuCourseLevelId_"+index).val(parseFloat(jQuery("#"+currentId).attr('gcuCourseLevelId')));
				jQuery("#gcuCourseLevelId_"+index).removeAttr("disabled");
			}
			if(jQuery("#"+currentId).attr('coursemappingtrcid') != null && jQuery("#"+currentId).attr('coursemappingtrcid') !=''){
				jQuery("#courseMappingTrCId_"+index).val(jQuery("#"+currentId).attr('coursemappingtrcid'));
				jQuery("#courseMappingTrCId_"+index).removeAttr("disabled");
			} */
			for(var index2=0; index2<loopLenth;index2++ ){
				jQuery("#courseMappingEvaluationStatus_"+index+"_"+index2).removeAttr("disabled");			
				jQuery("#courseMappingEndDate_"+index+"_"+index2).removeAttr("disabled");
				jQuery("#gcuCourseCredits_"+index+"_"+index2).removeAttr("disabled");
				jQuery("#gcuCourseTitle_"+index+"_"+index2).removeAttr("disabled");
				jQuery("#courseMappingEffectiveDate_"+index+"_"+index2).removeAttr("disabled");
				jQuery("#gcuDateAdded_"+index+"_"+index2).removeAttr("disabled");
				jQuery("#gcuCourseCode_"+index+"_"+index2).removeAttr("disabled");
				jQuery("#gcuCourseLevelId_"+index+"_"+index2).removeAttr("disabled");
				jQuery("#courseMappingTrCId_"+index+"_"+index2).removeAttr("disabled");
				jQuery("#gcuCourseId_"+index+"_"+index2).removeAttr("disabled");
			}
			
		}
		if(controlNameToAccess == 'CourseCategoryMapping'){
			if(jQuery("#"+currentId).attr('coursecategorymappingenddate') != null && jQuery("#"+currentId).attr('coursecategorymappingenddate') !=''){
				jQuery("#courseCategoryEndDate_"+index).val(jQuery("#"+currentId).attr('coursecategorymappingenddate'));
				jQuery("#courseCategoryEndDate_"+index).removeAttr("disabled");
			}
			if(jQuery("#"+currentId).attr('coursecategorymappingeffectivedate') != null && jQuery("#"+currentId).attr('coursecategorymappingeffectivedate') !=''){
				jQuery("#courseCategoryEffectiveDate_"+index).val(jQuery("#"+currentId).attr('coursecategorymappingeffectivedate'));
				jQuery("#courseCategoryEffectiveDate_"+index).removeAttr("disabled");
			}
			if(jQuery("#"+currentId).attr('coursecategorymappingname') != null && jQuery("#"+currentId).attr('coursecategorymappingname') !=''){
				jQuery("#gcuCourseCategory_"+index).val(jQuery("#"+currentId).attr('coursecategorymappingname'));
				jQuery("#gcuCourseCategory_"+index).removeAttr("disabled");
			}
			if(jQuery("#"+currentId).attr('coursecategorymappingevaluationstatus') != null && jQuery("#"+currentId).attr('coursecategorymappingevaluationstatus') !=''){
				jQuery("#courseCategoryMappingEvaluationStatus_"+index).val(jQuery("#"+currentId).attr('coursecategorymappingevaluationstatus'));
				jQuery("#courseCategoryMappingEvaluationStatus_"+index).removeAttr("disabled");
			}
			if(jQuery("#"+currentId).attr('coursecategorymappingtrcid') != null && jQuery("#"+currentId).attr('coursecategorymappingtrcid') !=''){
				jQuery("#courseCategoryMappingTrcId_"+index).val(jQuery("#"+currentId).attr('coursecategorymappingtrcid'));
				jQuery("#courseCategoryMappingTrcId_"+index).removeAttr("disabled");
			}
			
		}
	}else{
		var foundUnCheck = verifyAllUnCheck(globalCheckboxId);
		if(foundUnCheck == false){
			jQuery("[id^='"+checkBoxId1+"']").each(function(){
				jQuery(this).removeAttr("disabled");
			});
			jQuery("[id^='"+checkBoxId2+"']").each(function(){
				jQuery(this).removeAttr("disabled");
			});
		}
		if(controlNameToAccess == 'CourseMapping'){			
			for(var index2=0;index2<loopLenth;index2++ ){
				/* jQuery("#courseMappingEvaluationStatus_"+index+"_"+index2).val("");
			
			
				jQuery("#courseMappingEndDate_"+index+"_"+index2).val("");
			
			
				jQuery("#gcuCourseCredits_"+index+"_"+index2).val("");
			
			
				jQuery("#gcuCourseTitle_"+index+"_"+index2).val("");
			
			
				jQuery("#courseMappingEffectiveDate_"+index+"_"+index2).val("");
				jQuery("#gcuDateAdded_"+index+"_"+index2).val("");
				
			
				jQuery("#gcuCourseCode_"+index+"_"+index2).val("");
				jQuery("#courseMappingTrCId_"+index+"_"+index2).val(""); */
			
				jQuery("#courseMappingEvaluationStatus_"+index+"_"+index2).attr("disabled","disabled");
				jQuery("#courseMappingEndDate_"+index+"_"+index2).attr("disabled","disabled");
				jQuery("#gcuCourseCredits_"+index+"_"+index2).attr("disabled","disabled");
				jQuery("#gcuCourseTitle_"+index+"_"+index2).attr("disabled","disabled");
				jQuery("#courseMappingEffectiveDate_"+index+"_"+index2).attr("disabled","disabled");
				jQuery("#gcuCourseCode_"+index+"_"+index2).attr("disabled","disabled");
				jQuery("#gcuDateAdded_"+index+"_"+index2).attr("disabled","disabled");
				jQuery("#gcuCourseLevelId_"+index+"_"+index2).attr("disabled","disabled");
				jQuery("#courseMappingTrCId_"+index+"_"+index2).attr("disabled","disabled");
				jQuery("#gcuCourseId_"+index+"_"+index2).attr("disabled","disabled");
			}	
			
		}
		if(controlNameToAccess == 'CourseCategoryMapping'){
			
				jQuery("#courseCategoryEndDate_"+index).val("");
			
				jQuery("#courseCategoryEffectiveDate_"+index).val("");
			
				jQuery("#gcuCourseCategory_"+index).val("");
			
				jQuery("#courseCategoryMappingEvaluationStatus_"+index).val("");
			
				jQuery("#courseCategoryMappingTrcId_"+index).val("");
			
				jQuery("#courseCategoryEndDate_"+index).attr("disabled","disabled");
				jQuery("#courseCategoryEffectiveDate_"+index).attr("disabled","disabled");
				jQuery("#gcuCourseCategory_"+index).attr("disabled","disabled");
				jQuery("#courseCategoryMappingEvaluationStatus_"+index).attr("disabled","disabled");
				jQuery("#courseCategoryMappingTrcId_"+index).attr("disabled","disabled");
			
		}
	}
	///evaluation/ieManager.html?operation=resolveAndSubmitCourse
}
function verifyAllUnCheck(globalCheckId){
	var found = false;
	jQuery("[id^='"+globalCheckId+"']").each(function(){
		innerloop:
		if(jQuery(this).is(':checked')){
			found = true;
			break innerloop;
		}
	});
	return found;
}
function resolveConflict(){
	var flag1 = false;
	var flag2 = false;
	var flag3 = false;
	var flag4 = false;
	if(jQuery("#checkbox1").val() != undefined && jQuery("#checkbox2").val() != undefined){
		if(!jQuery("#checkbox1").is(':checked') && !jQuery("#checkbox2").is(':checked')){
			alert("Please select atleast one Transfer Status ");
			return false;
		}
	}
	jQuery("[id^='courseMappingIe1_']").each(function(){
		if(jQuery(this).is(":checked")){
			flag1 = true;
		}
	});
	jQuery("[id^='courseMappingIe2_']").each(function(){
		if(jQuery(this).is(":checked")){
			flag2 = true;
		}
	});
	jQuery("[id^='courseCategoryMappingsIe1_']").each(function(){
		if(jQuery(this).is(":checked")){
			flag3 = true;
		}
	});
	jQuery("[id^='courseCategoryMappingsIe2_']").each(function(){
		if(jQuery(this).is(":checked")){
			flag4 = true;
		}
	});
	if(flag1 == false && flag2 == false && flag3 == false && flag4 == false){
		alert("Please check atleast one check box from Course Relationship");
		return false;
	}
	document.conflictCourseForm.action ='<c:url value="/evaluation/ieManager.html?operation=resolveAndSubmitCourse&institutionId=${transferCourse.institution.id}&transferCourseId=${transferCourse.id}"/>';
	document.conflictCourseForm.submit();
}
function fillTrStatus(trCheckBoxIdToRead,trCheckBoxIdToDisable){
	
	if(jQuery("#"+trCheckBoxIdToRead).is(':checked')){
		jQuery("#checkboxTransferStatus").val(jQuery("#"+trCheckBoxIdToRead).val());
		jQuery("#"+trCheckBoxIdToDisable).attr("disabled","disabled");
	}else{
		jQuery("#"+trCheckBoxIdToDisable).removeAttr("disabled");
	}
	
}
</script>
<c:choose>
     	<c:when test="${userRoleName =='Institution Evaluation Manager'}"> 
        	<c:set var="actionLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=ieSaveInstitution"/>
        	<c:set var="aBodyLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=manageAccreditingBody&institutionId=${institution.id}"/>
 			<c:set var="termTypeLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=manageInstitutionTermType&institutionId=${institution.id}"/>
 			<c:set var="transcriptKeyLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=manageInstitutionTranscriptKey&institutionId=${institution.id}"/>
 			<c:set var="aAgreementLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=manageArticulationAgreement&institutionId=${institution.id}"/>
	 	</c:when>
 		<c:otherwise>
 			<c:set var="actionLink" scope="session" value="/scheduling_system/evaluation/quality.html?operation=ieSaveInstitution"/>
 			<c:set var="aBodyLink" scope="session" value="/scheduling_system/evaluation/quality.html?operation=manageAccreditingBody&institutionMirrorId=${institutionMirrorId}"/>
 			<c:set var="termTypeLink" scope="session" value="/scheduling_system/evaluation/quality.html?operation=manageInstitutionTermType&institutionMirrorId=${institutionMirrorId}"/>
 			<c:set var="transcriptKeyLink" scope="session" value="/scheduling_system/evaluation/quality.html?operation=manageInstitutionTranscriptKey&institutionMirrorId=${institutionMirrorId}"/>
 			<c:set var="aAgreementLink" scope="session" value="/scheduling_system/evaluation/quality.html?operation=manageArticulationAgreement&institutionMirrorId=${institutionMirrorId}"/>
	 	</c:otherwise>
</c:choose> 
<form id="conflictCourseForm" name="conflictCourseForm" method="post">
<div class="deo2">
  <div style="border:1px solid #e7e7e7; border-top:none;" class="institute">
  	<div class="noti-tools2">
  	  <div class="clear"></div>
  	  
      <div class="deo">
        <div class="deoInfo">
          <h1 class="expand"><div class="fl">Transfer Institution: <span class="FntNormal">${transferCourse.institution.name }</span></div>
        
        <div class="Inprgss FntNormal">${transferCourse.institution.evaluationStatus }</div>
        <div class="trnId">ID: <span class="FntNormal">${transferCourse.institution.institutionID }</span></div>
        
        <div class="clear"></div>
        </h1>
    	
        <div class="deoExpandDetails collapse" style="display:block;">
          <div class="clear">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
           	 <tr>
	             <td width="100" align="left" valign="top">
	               <label class="noti-label w90">Address:</label>
	             </td>
	             <td align="left" valign="top">
	               
	                 
	                 	<c:forEach items="${institutionDetails }" var="institutionAddress">
		                 	<c:if test="${!empty institutionAddress }">
			                 	<div class="adressdvLeft">
				                 		<label class="noti-label2 wrapText3">
						               		 ${institutionAddress.address1} &nbsp;&nbsp;
						               		 ${institutionAddress.address2} &nbsp;&nbsp;
						               		 <c:if test="${!empty institutionAddress.city}">&nbsp;${institutionAddress.city}</c:if>
						               		 <c:if test="${!empty institutionAddress.state}">&nbsp;${institutionAddress.state}</c:if>
						               		 <c:if test="${!empty institutionAddress.zipcode}">&nbsp;${institutionAddress.zipcode}</c:if>
						               		 <c:if test="${!empty institutionAddress.country.name}">&nbsp;${institutionAddress.country.name}</c:if>
						                 	 <c:if test="${!empty institutionAddress.phone1}">Phone: &nbsp;${institutionAddress.phone1}</c:if>
						                 	<c:if test="${!empty institutionAddress.phone2}">,${institutionAddress.phone2}</c:if>
						                  	<br />
						                  	<c:if test="${!empty institutionAddress.fax}">Fax: &nbsp;${institutionAddress.fax}</c:if><br />
						                  	<c:if test="${!empty institutionAddress.tollFree}">Toll Free: &nbsp;${institutionAddress.tollFree}</c:if><br />
						                  	<c:if test="${!empty institutionAddress.website}">Website: &nbsp;${institutionAddress.website}</c:if><br />
						               		<c:if test="${!empty institutionAddress.email1}"> Email Id: &nbsp; ${institutionAddress.email1}</c:if>
						               		<c:if test="${!empty institutionAddress.email2}">,${institutionAddress.email2}</c:if>
						               	 </label>
					               </div>   
				              </c:if> 
	                 	
	                 	</c:forEach>
	                 	 
			        
	                        
	               <div class="clear"></div>
	             </td>
           </tr>
         </table>
     		</div>
      </div>
        
  </div>
        <div class="clear"></div>
        
        
        <div>
        <div class="tabHeader3">
        	
            <div class="fl"><strong>Course Code:</strong> <span>${transferCourse.trCourseCode}</span></div>
            <div class="floatLeft ml26"><strong>Course Title: </strong><span>${transferCourse.trCourseTitle}</span></div>
        
        <div class="clear"></div>
        
        
        </div>
       
        	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-confi noti-bbn tabTBLborder contentForm">
        	 <tbody>
			  <tr>
			    <th width="15%" scope="col" class="dividerGrey">Information</th>
			    <th width="32%" scope="col" class="dividerGrey">${transferCourse1.evaluator1.firstName} ${transferCourse1.evaluator1.lastName}</th>
			    <th width="32%" scope="col" class="dividerGrey">${transferCourse2.evaluator1.firstName} ${transferCourse2.evaluator1.lastName}</th>
			    <th width="15%" scope="col">Corrected Data</th>
			    <th width="5%" scope="col">&nbsp;</th>
			  </tr>
			   <c:if test="${transferCourse1.transferStatus ne transferCourse2.transferStatus}">
				  <tr class="errorColorfrTbl borderBotttom">
				 
				    <td align="left" valign="top">Transfer Status</td>
				    <td align="left" valign="top"><div><div class="floatLeft">
				      <input type="checkbox" name="transferStatusCheckbox1" id="checkbox1" value="${transferCourse1.transferStatus}" onchange="javaScript:fillTrStatus('checkbox1','checkbox2');"/>
				      <label for="checkbox"></label>
					  <label for="radio"></label></div>
				      <div class="floatLeft wrapText4">${transferCourse1.transferStatus}</div>
				      <div class="clear"></div>      
				      </div></td>
				    <td align="left" valign="top"><div>
				      <div class="floatLeft">
				        <input type="checkbox" name="transferStatusCheckbox2" id="checkbox2" value="${transferCourse2.transferStatus}" onchange="javaScript:fillTrStatus('checkbox2','checkbox1');"/>
				        <label for="radio7"></label>
				        </div>
				      <div class="floatLeft wrapText4">${transferCourse2.transferStatus}</div>
				      <div class="clear"></div>
				      </div></td>
				    <td align="left" valign="top">&nbsp;</td>
				    <td align="left" valign="top"><a href="#" class="alertIcon fr mt5"></a></td>
				  </tr>
			  </c:if>
			  <tr class="">
			    <td align="left" valign="top">Course Relationship</td>
			    <td align="left" valign="top">
				    <c:forEach items="${transferCourse1.courseMappings}" var="courseMapping" varStatus="index">
				    <c:if test="${(index.index % 2) eq 0}">
				    <div class="gropConfli">
				    </c:if>
				    <c:if test="${(index.index % 2) ne 0}">
				    <div class="gropConfli2">
				    </c:if>
				    	<div class="floatLeft">
				    	<input type="checkbox" name="courseMappings[${index.index}].trCourseId" 
						        	id="courseMappingIe1_${index.index }" value="${courseMapping.trCourseId}" courseMappingTrCId="${transferCourse1.id}"
						        	gcuCourseLevelId=""
						        	gcuCourseCode="" courseMappingEffectiveDate=''
						        	gcuCourseTitle="" gcuCourseCredits=""
						        	courseMappingEndDate='' courseMappingEvaluationStatus="EVALUATED"
						        	onchange="javaScript:enableDisabledChecks('courseCategoryMappingsIe1_','courseCategoryMappingsIe2_','courseMappingIe1_${index.index }','CourseMapping','courseMappingIe','${fn:length(courseMapping.courseMappingDetails) }');"/>
						     
										<label for="radio"></label>
						</div>				
									     <c:forEach items="${courseMapping.courseMappingDetails }" var="courseMappingDetail" varStatus="courseMappingDetailIndex">
										    					    
											      
											        		<input type="hidden" id="gcuCourseId_${index.index}_${courseMappingDetailIndex.index}" name="courseMappings[${index.index}].courseMappingDetails[${courseMappingDetailIndex.index }].gcuCourse.id" value="${courseMappingDetail.gcuCourse.id}" disabled="disabled"/>
											        		<input type="hidden" id="gcuCourseCode_${index.index}_${courseMappingDetailIndex.index}" name="courseMappings[${index.index}].courseMappingDetails[${courseMappingDetailIndex.index }].gcuCourse.courseCode"  value="${courseMappingDetail.gcuCourse.courseCode}" disabled="disabled"/>
											        		<input type="hidden" id="gcuCourseTitle_${index.index}_${courseMappingDetailIndex.index}" name="courseMappings[${index.index}].courseMappingDetails[${courseMappingDetailIndex.index }].gcuCourse.title" value="${courseMappingDetail.gcuCourse.title}" disabled="disabled"/>
											    			<input type="hidden" id="gcuCourseCredits_${index.index }_${courseMappingDetailIndex.index}"  name="courseMappings[${index.index }].courseMappingDetails[${courseMappingDetailIndex.index }].gcuCourse.credits" value="${courseMappingDetail.gcuCourse.credits}" disabled="disabled"/>
						        							<input type="hidden" id="gcuCourseLevelId_${index.index }_${courseMappingDetailIndex.index}"  name="courseMappings[${index.index }].courseMappingDetails[${courseMappingDetailIndex.index }].gcuCourse.courseLevelId" value="${courseMappingDetail.gcuCourse.courseLevelId}" disabled="disabled"/>
						        							<input type="hidden" id="gcuDateAdded_${index.index }_${courseMappingDetailIndex.index}"   name="courseMappings[${index.index }].courseMappingDetails[${courseMappingDetailIndex.index }].gcuCourse.dateAdded" value="${courseMappingDetail.gcuCourse.dateAdded}" disabled="disabled"/>
						        							<input type="hidden" id="courseMappingEffectiveDate_${index.index}_${courseMappingDetailIndex.index}" name="courseMappings[${index.index}].courseMappingDetails[${courseMappingDetailIndex.index }].effectiveDate" value='<fmt:formatDate value="${courseMappingDetail.effectiveDate}" pattern="MM/dd/yyyy"/>' disabled="disabled"/>
						        							<input type="hidden" id="courseMappingEndDate_${index.index}_${courseMappingDetailIndex.index}" name="courseMappings[${index.index}].courseMappingDetails[${courseMappingDetailIndex.index }].endDate" value='<fmt:formatDate value="${courseMappingDetail.endDate}" pattern="MM/dd/yyyy"/>' disabled="disabled"/>
						        					<div class="floatLeft"><label for="radio"></label>	</div>
											        	<div class="floatLeft wrapText4">
											        		${courseMappingDetail.gcuCourse.courseCode} <c:if test="${fn:length(courseMapping.courseMappingDetails)-1 >courseMappingDetailIndex.index }"><strong>AND</strong></c:if>&nbsp;
											        	</div>											    	
										       
										 </c:forEach>  
							      <div class="clear"></div>
						</div>
							  
				    </c:forEach>
			    	
			     	<c:forEach items="${transferCourse1.courseCategoryMappings}" var="courseCategoryMapping" varStatus="index">
				     	
					<c:if test="${(index.index % 2) eq 0}">
				    	<div class="gropConfli">
				    </c:if>
				    <c:if test="${(index.index % 2) ne 0}">
				    	<div class="gropConfli2">
				    </c:if>
				    	<div class="floatLeft">
							        <input type="checkbox" name="courseCategoryMappings[${index.index }].gcuCourseCategory.id" id="courseCategoryMappingsIe1_${index.index }"
							         value="${courseCategoryMapping.gcuCourseCategory.id}" courseCategoryMappingTrcId="${transferCourse1.id}"  
							         courseCategoryMappingEvaluationStatus="Eligible" courseCategoryMappingName="${courseCategoryMapping.gcuCourseCategory.name }" 
							         courseCategoryMappingEffectiveDate='<fmt:formatDate value="${courseCategoryMapping.effectiveDate }" pattern="MM/dd/yyyy"/>'
							         courseCategoryMappingEndDate='<fmt:formatDate value="${courseCategoryMapping.endDate}" pattern="MM/dd/yyyy"/>' 
							         onchange="javaScript:enableDisabledChecks('courseMappingIe1_','courseMappingIe2_','courseCategoryMappingsIe1_${index.index }','CourseCategoryMapping','courseCategoryMappingsIe','${fn:length(transferCourse1.courseCategoryMappings) }');"/>
							         
							         		<input type="hidden" id="gcuCourseCategory_${index.index}" name="courseCategoryMappings[${index.index }].gcuCourseCategory.name" disabled="disabled"/>
							         		<input type="hidden" id="courseCategoryEffectiveDate_${index.index}" name="courseCategoryMappings[${index.index }].effectiveDate" disabled="disabled"/>
							         		<input type="hidden" id="courseCategoryEndDate_${index.index}" name="courseCategoryMappings[${index.index }].endDate" disabled="disabled"/>
							        		<input type="hidden" id="courseCategoryMappingEvaluationStatus_${index.index}" name="courseCategoryMappings[${index.index }].evaluationStatus" disabled="disabled"/>
							        		<input type="hidden" id="courseCategoryMappingTrcId_${index.index}" name="courseCategoryMappings[${index.index}].trCourseId" disabled="disabled"/>
							        <label for="radio"></label>
							        </div>
							      <div class="floatLeft"><label for="radio"></label>	</div>
							      <div class="floatLeft wrapText4">${courseCategoryMapping.gcuCourseCategory.name }</div>
							      <div class="clear"></div>
						      
					 </div>	  
				     </c:forEach>
				     
			     </td> 
			     <td align="left" valign="top">
			     	<c:set var="previousIndex" value="${fn:length(transferCourse1.courseMappings) }"></c:set>
				    <c:forEach items="${transferCourse2.courseMappings}" var="courseMapping" varStatus="index">
				     <c:if test="${(index.index % 2) eq 0}">
				    <div class="gropConfli">
				    </c:if>
				    <c:if test="${(index.index % 2) ne 0}">
				    <div class="gropConfli2">
				    </c:if>
				    	<div class="floatLeft">
				    	<input type="checkbox" name="courseMappings[${previousIndex}].trCourseId" 
						      gcuCourseLevelId=""
						      id="courseMappingIe2_${previousIndex}" value="${courseMapping.trCourseId}" courseMappingTrCId="${transferCourse.id}"
						      gcuCourseCode="" courseMappingEffectiveDate=''
						      gcuCourseTitle="" gcuCourseCredits=""
						      courseMappingEndDate='' courseMappingEvaluationStatus="EVALUATED"
						      onchange="javaScript:enableDisabledChecks('courseCategoryMappingsIe1_','courseCategoryMappingsIe2_','courseMappingIe2_${previousIndex }','CourseMapping','courseMappingIe','${fn:length(courseMapping.courseMappingDetails) }');"/>
						      
				    	      <label for="radio"></label>
				    	    </div>
						    <c:forEach items="${courseMapping.courseMappingDetails }" var="courseMappingDetail" varStatus="courseMappingDetailIndex">
							    			 
									        	
									        		<input type="hidden" id="gcuCourseId_${previousIndex}_${courseMappingDetailIndex.index}" name="courseMappings[${previousIndex}].courseMappingDetails[${courseMappingDetailIndex.index }].gcuCourse.id" value="${courseMappingDetail.gcuCourse.id}" disabled="disabled"/>
											        <input type="hidden" id="gcuCourseCode_${previousIndex}_${courseMappingDetailIndex.index}" name="courseMappings[${previousIndex}].courseMappingDetails[${courseMappingDetailIndex.index }].gcuCourse.courseCode"  value="${courseMappingDetail.gcuCourse.courseCode}" disabled="disabled"/>
											        <input type="hidden" id="gcuCourseTitle_${previousIndex}_${courseMappingDetailIndex.index}" name="courseMappings[${previousIndex}].courseMappingDetails[${courseMappingDetailIndex.index }].gcuCourse.title" value="${courseMappingDetail.gcuCourse.title}" disabled="disabled"/>
											    	<input type="hidden" id="gcuCourseCredits_${previousIndex}_${courseMappingDetailIndex.index}"  name="courseMappings[${previousIndex }].courseMappingDetails[${courseMappingDetailIndex.index }].gcuCourse.credits" value="${courseMappingDetail.gcuCourse.credits}" disabled="disabled"/>
						        					<input type="hidden" id="gcuCourseLevelId_${previousIndex}_${courseMappingDetailIndex.index}"  name="courseMappings[${previousIndex }].courseMappingDetails[${courseMappingDetailIndex.index }].gcuCourse.courseLevelId" value="${courseMappingDetail.gcuCourse.courseLevelId}" disabled="disabled"/>
						        					<input type="hidden" id="gcuDateAdded_${previousIndex}_${courseMappingDetailIndex.index}"   name="courseMappings[${previousIndex }].courseMappingDetails[${courseMappingDetailIndex.index }].gcuCourse.dateAdded" value="${courseMappingDetail.gcuCourse.dateAdded}" disabled="disabled"/>
						        					<input type="hidden" id="courseMappingEffectiveDate_${previousIndex}_${courseMappingDetailIndex.index}" name="courseMappings[${previousIndex}].courseMappingDetails[${courseMappingDetailIndex.index }].effectiveDate" value='<fmt:formatDate value="${courseMappingDetail.effectiveDate}" pattern="MM/dd/yyyy"/>' disabled="disabled"/>
						        					<input type="hidden" id="courseMappingEndDate_${previousIndex}_${courseMappingDetailIndex.index}" name="courseMappings[${previousIndex}].courseMappingDetails[${courseMappingDetailIndex.index }].endDate" value='<fmt:formatDate value="${courseMappingDetail.endDate}" pattern="MM/dd/yyyy"/>' disabled="disabled"/>
						        			<div class="floatLeft"><label for="radio"></label></div>
									        	<div class="floatLeft wrapText4">
									        		${courseMappingDetail.gcuCourse.courseCode} <c:if test="${fn:length(courseMapping.courseMappingDetails)-1 >courseMappingDetailIndex.index }"><strong>AND</strong></c:if>&nbsp;
									        	</div>      
								      		 
							        	
							   </c:forEach>
							   <div class="clear"></div>
								 
						  
						   <c:set var="previousIndex" value="${previousIndex + 1}"></c:set>
						    </div>
						 
				    </c:forEach>
			    	<c:set var="previousCatIndex" value="${fn:length(transferCourse1.courseCategoryMappings)}"></c:set>	
			     	<c:forEach items="${transferCourse2.courseCategoryMappings}" var="courseCategoryMapping" varStatus="index">
			     	 	<c:set var="previousCatIndex" value="${previousCatIndex + index.index}"></c:set>
				     	
						<c:if test="${(index.index % 2) eq 0}">
					    	<div class="gropConfli">
					    </c:if>
					    <c:if test="${(index.index % 2) ne 0}">
					    	<div class="gropConfli2">
					    </c:if>
					    	<div class="floatLeft">
							        <input type="checkbox" name="courseCategoryMappings[${previousCatIndex }].gcuCourseCategory.id" id="courseCategoryMappingsIe2_${previousCatIndex}"
							         value="${courseCategoryMapping.gcuCourseCategory.id}" courseCategoryMappingTrcId="${transferCourse.id}"  
							         courseCategoryMappingEvaluationStatus="Eligible" courseCategoryMappingName="${courseCategoryMapping.gcuCourseCategory.name }" 
							         courseCategoryMappingEffectiveDate='<fmt:formatDate value="${courseCategoryMapping.effectiveDate }" pattern="MM/dd/yyyy"/>'
							         courseCategoryMappingEndDate='<fmt:formatDate value="${courseCategoryMapping.endDate}" pattern="MM/dd/yyyy"/>'  
							         onchange="javaScript:enableDisabledChecks('courseMappingIe1_','courseMappingIe2_','courseCategoryMappingsIe2_${previousCatIndex }','CourseCategoryMapping','courseCategoryMappingsIe','${fn:length(transferCourse2.courseCategoryMappings) }');"/>
							         
							         		<input type="hidden" id="gcuCourseCategory_${previousCatIndex}" name="courseCategoryMappings[${previousCatIndex}].gcuCourseCategory.name" disabled="disabled"/>
							         		<input type="hidden" id="courseCategoryEffectiveDate_${previousCatIndex}" name="courseCategoryMappings[${previousCatIndex }].effectiveDate" disabled="disabled"/>
							         		<input type="hidden" id="courseCategoryEndDate_${previousCatIndex}" name="courseCategoryMappings[${previousCatIndex }].endDate" />
							        		<input type="hidden" id="courseCategoryMappingEvaluationStatus_${previousCatIndex}" name="courseCategoryMappings[${previousCatIndex }].evaluationStatus" disabled="disabled"/>
							        		<input type="hidden" id="courseCategoryMappingTrcId_${previousIndex}" name="courseCategoryMappings[${previousIndex}].trCourseId" disabled="disabled"/>
							        <label for="radio"></label>
							        </div>
							        <div class="floatLeft"><label for="radio"></label></div>
							      <div class="floatLeft wrapText4">${courseCategoryMapping.gcuCourseCategory.name }</div>
							      <div class="clear"></div>
						      </div>
						  
				     </c:forEach>
			     </td> 
			    <td align="left" valign="top" style="padding-top:9px;"><a href="javaScript:void(0);" onclick="window.location='<c:url value="/evaluation/ieManager.html?operation=createCourse&institutionId=${transferCourse.institution.id}&transferCourseId=${transferCourse.id}"/>'">Re-evaluate</a></td>			      
			    <td align="left" valign="top"><a href="#" class="alertIcon fr mt5"></a></td>
			  </tr>
			  <input type="hidden" name="id" value="${transferCourse.id}"/>
			  <input type="hidden" name="courseMirrorId" value="${mirrorId2}"/>	
			  <c:choose>
				  <c:when test="${transferCourse1.transferStatus ne transferCourse2.transferStatus}">
				  	<input type="hidden" name="transferStatus" id="checkboxTransferStatus"/>
				  </c:when>
				  <c:otherwise>
				  	<input type="hidden" name="transferStatus" id="checkboxTransferStatus" value="${transferCourse1.transferStatus}"/>
				  </c:otherwise>
			  </c:choose>
			  </tbody>
          </table>
        
  		<div>
          	<div class="fr mt10">
           	 <input type="button" name="cancel" value="Resolve Conflict" id="Resolve Conflict" class="button" onclick="javaScript:resolveConflict();">
			</div>
        	<div class="clear"></div>
    	</div>
       	          
        </div>
        
      </div>
    </div>
      
    </div>
  </div>
 </form> 
 	