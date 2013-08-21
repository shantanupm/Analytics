<%@include file="../init.jsp" %>

<script type="text/javascript"	src="<c:url value="/js/jquery.validate.js"/>"></script>

 <script>
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
	jQuery("#conflictCourseForm").validate();
	
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
	jQuery(".conflictExpander").expandAll({trigger: "h1.expand"});
	
	jQuery('.collapse:first').show();
	jQuery('h1.expand:first a:first').addClass("open"); 
});
function disabledGropComponent(componentLength,comboIndex,componentName){
	var index = comboIndex;
	if(componentName=='CourseRelationship'){
	 if(jQuery("#courseRelationshipNA"+comboIndex).is(':checked')){	
		//for(var index=0;index<componentLength;index++){			
			
			jQuery("#rd_cmCourseCode-"+index).attr("checked","");
			jQuery("#rd_cmCourseCodeIe1-"+index).attr("checked","");
			jQuery("#rd_cmCourseCodeIe2-"+index).attr("checked","");
			
			jQuery("#rd_cmCourseCode-"+index).attr("disabled","disabled");
			jQuery("#rd_cmCourseCodeIe1-"+index).attr("disabled","disabled");
			jQuery("#rd_cmCourseCodeIe2-"+index).attr("disabled","disabled");

			jQuery("#cmCourseCode-"+index).val("");
			jQuery("#cmCourseCode-"+index).attr("disabled","disabled");
			
			
			jQuery("#rd_cmCredits-"+index).attr("checked","");
			jQuery("#rd_cmCreditsIe1-"+index).attr("checked","");
			jQuery("#rd_cmCreditsIe2-"+index).attr("checked","");
			jQuery("#cmCredits-"+index).val("");
			jQuery("#cmCredits-"+index).attr("checked","");
			
			jQuery("#rd_cmCredits-"+index).attr("disabled","disabled");
			jQuery("#rd_cmCreditsIe1-"+index).attr("disabled","disabled");
			jQuery("#rd_cmCreditsIe2-"+index).attr("disabled","disabled");
			jQuery("#cmCredits-"+index).attr("disabled","disabled");
			
			jQuery("#rd_cmMinGrade-"+index).attr("checked","");
			jQuery("#rd_cmMinGradeIe1-"+index).attr("checked","");
			jQuery("#rd_cmMinGradeIe2-"+index).attr("checked","");
			jQuery("#cmMinGrade-"+index).val("");
			jQuery("#cmMinGrade-"+index).attr("checked","");
			
			jQuery("#rd_cmMinGrade-"+index).attr("disabled","disabled");
			jQuery("#rd_cmMinGradeIe1-"+index).attr("disabled","disabled");
			jQuery("#rd_cmMinGradeIe2-"+index).attr("disabled","disabled");
			jQuery("#cmMinGrade-"+index).attr("disabled","disabled");
			
			jQuery("#rd_cmEfDate-"+index).attr("checked","");
			jQuery("#rd_cmEfDateIe1-"+index).attr("checked","");
			jQuery("#rd_cmEfDateIe2-"+index).attr("checked","");
			jQuery("#cmEfDate-"+index).val("");
			jQuery("#cmEfDate-"+index).attr("checked","");
			
			jQuery("#rd_cmEfDate-"+index).attr("disabled","disabled");
			jQuery("#rd_cmEfDateIe1-"+index).attr("disabled","disabled");
			jQuery("#rd_cmEfDateIe2-"+index).attr("disabled","disabled");
			jQuery("#cmEfDate-"+index).attr("disabled","disabled");
			
			jQuery("#rd_cmendDate-"+index).attr("checked","");
			jQuery("#rd_cmendDateIe1-"+index).attr("checked","");
			jQuery("#rd_cmendDateIe2-"+index).attr("checked","");
			jQuery("#cmendDate-"+index).val("");
			jQuery("#cmendDate-"+index).attr("checked","");
			
			jQuery("#rd_cmendDate-"+index).attr("disabled","disabled");
			jQuery("#rd_cmendDateIe1-"+index).attr("disabled","disabled");
			jQuery("#rd_cmendDateIe2-"+index).attr("disabled","disabled");
			jQuery("#cmendDate-"+index).attr("disabled","disabled");
			
			jQuery("#rd_cmevsts-"+index).attr("checked","");
			jQuery("#rd_cmevstsIe1-"+index).attr("checked","");
			jQuery("#rd_cmevstsIe2-"+index).attr("checked","");
			jQuery("#cmevsts-"+index).val("");
			jQuery("#cmevsts-"+index).attr("checked","");
			
			jQuery("#rd_cmevsts-"+index).attr("disabled","disabled");
			jQuery("#rd_cmevstsIe1-"+index).attr("disabled","disabled");
			jQuery("#rd_cmevstsIe2-"+index).attr("disabled","disabled");
			jQuery("#cmevsts-"+index).attr("disabled","disabled");
		//}
	 }else{
		// for(var index=0;index<componentLength;index++){

				jQuery("#rd_cmCourseCode-"+index).removeAttr("disabled");
				jQuery("#rd_cmCourseCodeIe1-"+index).removeAttr("disabled");
				jQuery("#rd_cmCourseCodeIe2-"+index).removeAttr("disabled");
				jQuery("#cmCourseCode-"+index).removeAttr("disabled");
				
				jQuery("#rd_cmCredits-"+index).removeAttr("disabled");
				jQuery("#rd_cmCreditsIe1-"+index).removeAttr("disabled");
				jQuery("#rd_cmCreditsIe2-"+index).removeAttr("disabled");
				jQuery("#cmCredits-"+index).removeAttr("disabled");
				
				jQuery("#rd_cmMinGrade-"+index).removeAttr("disabled");
				jQuery("#rd_cmMinGradeIe1-"+index).removeAttr("disabled");
				jQuery("#rd_cmMinGradeIe2-"+index).removeAttr("disabled");
				jQuery("#cmMinGrade-"+index).removeAttr("disabled");
				
				jQuery("#rd_cmEfDate-"+index).removeAttr("disabled");
				jQuery("#rd_cmEfDateIe1-"+index).removeAttr("disabled");
				jQuery("#rd_cmEfDateIe2-"+index).removeAttr("disabled");
				jQuery("#cmEfDate-"+index).removeAttr("disabled");
				
				jQuery("#rd_cmendDate-"+index).removeAttr("disabled");
				jQuery("#rd_cmendDateIe1-"+index).removeAttr("disabled");
				jQuery("#rd_cmendDateIe2-"+index).removeAttr("disabled");
				jQuery("#cmendDate-"+index).removeAttr("disabled");
				
				jQuery("#rd_cmevsts-"+index).removeAttr("disabled");
				jQuery("#rd_cmevstsIe1-"+index).removeAttr("disabled");
				jQuery("#rd_cmevstsIe2-"+index).removeAttr("disabled");
				jQuery("#cmevsts-"+index).removeAttr("disabled");
			//} 
	 }
	}if(componentName=='CourseCategoryRelationship'){
		 if(jQuery("#courseCategoryRelationshipNA"+comboIndex).is(':checked')){	
			//for(var index=0;index<componentLength;index++){
				jQuery("#rd_ccmcourseCode-"+index).attr("checked","");
				jQuery("#rd_ccmcourseCodeIe1-"+index).attr("checked","");
				jQuery("#rd_ccmcourseCodeIe2-"+index).attr("checked","");
				jQuery("#ccmcourseCode-"+index).val("");
				jQuery("#ccmcourseCode-"+index).attr("checked","");
				
				jQuery("#rd_ccmcourseCode-"+index).attr("disabled","disabled");
				jQuery("#rd_ccmcourseCodeIe1-"+index).attr("disabled","disabled");
				jQuery("#rd_ccmcourseCodeIe2-"+index).attr("disabled","disabled");
				jQuery("#ccmcourseCode-"+index).attr("disabled","disabled");
				
				
				jQuery("#rd_ccmCredits-"+index).attr("checked","");
				jQuery("#rd_ccmCreditsIe1-"+index).attr("checked","");
				jQuery("#rd_ccmCreditsIe2-"+index).attr("checked","");
				jQuery("#ccmCredits-"+index).val("");
				jQuery("#ccmCredits-"+index).attr("checked","");
				
				
				jQuery("#rd_ccmCredits-"+index).attr("disabled","disabled");
				jQuery("#rd_ccmCreditsIe1-"+index).attr("disabled","disabled");
				jQuery("#rd_ccmCreditsIe2-"+index).attr("disabled","disabled");
				jQuery("#ccmCredits-"+index).attr("disabled","disabled");
				
				jQuery("#rd_ccmMinGrade-"+index).attr("checked","");
				jQuery("#rd_ccmMinGradeIe1-"+index).attr("checked","");
				jQuery("#rd_ccmMinGradeIe2-"+index).attr("checked","");
				jQuery("#ccmMinGrade-"+index).val("");
				jQuery("#ccmMinGrade-"+index).attr("checked","");
				
				
				jQuery("#rd_ccmMinGrade-"+index).attr("disabled","disabled");
				jQuery("#rd_ccmMinGradeIe1-"+index).attr("disabled","disabled");
				jQuery("#rd_ccmMinGradeIe2-"+index).attr("disabled","disabled");
				jQuery("#ccmMinGrade-"+index).attr("disabled","disabled");
				
				jQuery("#rd_ccmefDate-"+index).attr("checked","");
				jQuery("#rd_ccmefDateIe1-"+index).attr("checked","");
				jQuery("#rd_ccmefDateIe2-"+index).attr("checked","");
				jQuery("#ccmefDate-"+index).val("");
				jQuery("#ccmefDate-"+index).attr("checked","");
				
				jQuery("#rd_ccmefDate-"+index).attr("disabled","disabled");
				jQuery("#rd_ccmefDateIe1-"+index).attr("disabled","disabled");
				jQuery("#rd_ccmefDateIe2-"+index).attr("disabled","disabled");
				jQuery("#ccmefDate-"+index).attr("disabled","disabled");
				
				jQuery("#rd_ccmEndDate-"+index).attr("disabled","disabled");
				jQuery("#rd_ccmEndDateIe1-"+index).attr("disabled","disabled");
				jQuery("#rd_ccmEndDateIe2-"+index).attr("disabled","disabled");
				jQuery("#ccmEndDate-"+index).attr("disabled","disabled");
				
				jQuery("#rd_ccmEndDate-"+index).attr("checked","");
				jQuery("#rd_ccmEndDateIe1-"+index).attr("checked","");
				jQuery("#rd_ccmEndDateIe2-"+index).attr("checked","");
				jQuery("#ccmEndDate-"+index).val("");
				jQuery("#ccmEndDate-"+index).attr("checked","");
				
				jQuery("#rd_ccmevsts-"+index).attr("checked","");
				jQuery("#rd_ccmevstsIe1-"+index).attr("checked","");
				jQuery("#rd_ccmevstsIe2-"+index).attr("checked","");
				jQuery("#ccmevsts-"+index).val("");
				jQuery("#ccmevsts-"+index).attr("checked","");
				
				jQuery("#rd_ccmevsts-"+index).attr("disabled","disabled");
				jQuery("#rd_ccmevstsIe1-"+index).attr("disabled","disabled");
				jQuery("#rd_ccmevstsIe2-"+index).attr("disabled","disabled");
				jQuery("#ccmevsts-"+index).attr("disabled","disabled");
			//}
		 }else{
			 //for(var index=0;index<componentLength;index++){
					jQuery("#rd_ccmcourseCode-"+index).removeAttr("disabled");
					jQuery("#rd_ccmcourseCodeIe1-"+index).removeAttr("disabled");
					jQuery("#rd_ccmcourseCodeIe2-"+index).removeAttr("disabled");
					jQuery("#ccmcourseCode-"+index).removeAttr("disabled");		
					
					jQuery("#rd_ccmCredits-"+index).removeAttr("disabled");
					jQuery("#rd_ccmCreditsIe1-"+index).removeAttr("disabled");
					jQuery("#rd_ccmCreditsIe2-"+index).removeAttr("disabled");
					jQuery("#ccmcourseCode-"+index).removeAttr("disabled");
					
					jQuery("#rd_ccmMinGrade-"+index).removeAttr("disabled");
					jQuery("#rd_ccmMinGradeIe1-"+index).removeAttr("disabled");
					jQuery("#rd_ccmMinGradeIe2-"+index).removeAttr("disabled");
					jQuery("#ccmMinGrade-"+index).removeAttr("disabled");
					
					jQuery("#rd_ccmefDate-"+index).removeAttr("disabled");
					jQuery("#rd_ccmefDateIe1-"+index).removeAttr("disabled");
					jQuery("#rd_ccmefDateIe2-"+index).removeAttr("disabled");
					jQuery("#ccmefDate-"+index).removeAttr("disabled");
					
					jQuery("#rd_ccmEndDate-"+index).removeAttr("disabled");
					jQuery("#rd_ccmEndDateIe1-"+index).removeAttr("disabled");
					jQuery("#rd_ccmEndDateIe2-"+index).removeAttr("disabled");
					jQuery("#ccmEndDate-"+index).removeAttr("disabled");
					
					jQuery("#rd_ccmevsts-"+index).removeAttr("disabled");
					jQuery("#rd_ccmevstsIe1-"+index).removeAttr("disabled");
					jQuery("#rd_ccmevstsIe2-"+index).removeAttr("disabled");
					jQuery("#ccmevsts-"+index).removeAttr("disabled");
				//}
		 }
	}
  if(componentName=='CourseTitles'){
	  if(jQuery("#courseTitlesNA"+comboIndex).is(':checked')){
		  //for(var index=0;index<componentLength;index++){
			 	jQuery("#rd_ttl-"+index).attr("checked","");
				jQuery("#rd_ttlIe1-"+index).attr("checked","");
				jQuery("#rd_ttlIe2-"+index).attr("checked","");
				jQuery("#ttl-"+index).val("");
				jQuery("#ttl-"+index).attr("checked","");
				
				jQuery("#rd_ttl-"+index).attr("disabled","disabled");
				jQuery("#rd_ttlIe1-"+index).attr("disabled","disabled");
				jQuery("#rd_ttlIe2-"+index).attr("disabled","disabled");
				jQuery("#ttl-"+index).attr("disabled","disabled");
				
				jQuery("#rd_ttlefDate-"+index).attr("checked","");
				jQuery("#rd_ttlefDateIe1-"+index).attr("checked","");
				jQuery("#rd_ttlefDateIe2-"+index).attr("checked","");
				jQuery("#ttlefDate-"+index).val("");
				jQuery("#ttlefDate-"+index).attr("checked","");
				
				jQuery("#rd_ttlefDate-"+index).attr("disabled","disabled");
				jQuery("#rd_ttlefDateIe1-"+index).attr("disabled","disabled");
				jQuery("#rd_ttlefDateIe2-"+index).attr("disabled","disabled");
				jQuery("#ttlefDate-"+index).attr("disabled","disabled");
				
				
				jQuery("#rd_ttlendDate-"+index).attr("checked","");
				jQuery("#rd_ttlendDateIe1-"+index).attr("checked","");
				jQuery("#rd_ttlendDateIe2-"+index).attr("checked","");
				jQuery("#ttlendDate-"+index).val("");
				jQuery("#ttlendDate-"+index).attr("checked","");
				
				jQuery("#rd_ttlendDate-"+index).attr("disabled","disabled");
				jQuery("#rd_ttlendDateIe1-"+index).attr("disabled","disabled");
				jQuery("#rd_ttlendDateIe2-"+index).attr("disabled","disabled");
				jQuery("#ttlendDate-"+index).attr("disabled","disabled");
				
				jQuery("#rd_ttevsts-"+index).attr("checked","");
				jQuery("#rd_ttevstsIe1-"+index).attr("checked","");
				jQuery("#rd_ttevstsIe2-"+index).attr("checked","");
				jQuery("#ttevsts-"+index).val("");
				jQuery("#ttevsts-"+index).attr("checked","");
				
				jQuery("#rd_ttevsts-"+index).attr("disabled","disabled");
				jQuery("#rd_ttevstsIe1-"+index).attr("disabled","disabled");
				jQuery("#rd_ttevstsIe2-"+index).attr("disabled","disabled");
				jQuery("#ttevsts-"+index).attr("disabled","disabled");
		  //}
	  }else{
		 // for(var index=0;index<componentLength;index++){
				jQuery("#rd_ttl-"+index).removeAttr("disabled");
				jQuery("#rd_ttlIe1-"+index).removeAttr("disabled");
				jQuery("#rd_ttlIe2-"+index).removeAttr("disabled");
				jQuery("#ttl-"+index).removeAttr("disabled");		
				
				jQuery("#rd_ttlefDate-"+index).removeAttr("disabled");
				jQuery("#rd_ttlefDateIe1-"+index).removeAttr("disabled");
				jQuery("#rd_ttlefDateIe2-"+index).removeAttr("disabled");
				jQuery("#ttlefDate-"+index).removeAttr("disabled");
				
				jQuery("#rd_ttlendDate-"+index).removeAttr("disabled");	
				jQuery("#rd_ttlendDateIe1-"+index).removeAttr("disabled");
				jQuery("#rd_ttlendDateIe2-"+index).removeAttr("disabled");
				jQuery("#ttlendDate-"+index).removeAttr("disabled");
				
				jQuery("#rd_ttevsts-"+index).removeAttr("disabled");
				jQuery("#rd_ttevstsIe1-"+index).removeAttr("disabled");
				jQuery("#rd_ttevstsIe2-"+index).removeAttr("disabled");
				jQuery("#ttevsts-"+index).removeAttr("disabled");
		  //}
	  }
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
 	
<div id="tabs12">
   <%--  <ul>
        <li><a href="#tabs-12">Conflict List</a> <span class="notification">${conflictCount}</span></li>
        <li><a href="#tabs-22" onclick="window.location='/scheduling_system/evaluation/ieManager.html?operation=getCoursesForApproval'">College/Courses Approval</a> <span class="notification">${requiredApprovalCount}</span></li>
        <li><a onclick="window.location='/scheduling_system/evaluation/ieManager.html?operation=getInstitutionList&status=ALL'" href="#tabs-32">Manage Institutions/Courses</a></li>
        <li><a href="#tabs-42" onclick="window.location='/scheduling_system/evaluation/ieManager.html?operation=getCoursesForReAssignment'">Reassign</a></li>
    </ul> --%>
    <div id="tabs-1">
		<%-- <div class="course" >
            <!-- Conflict Page 2 Start -->
            <div class="noti-tools">
                <div class="fl">
                    <div class="breadcrumb">
                    <a title="Home" href="/scheduling_system/evaluation/ieManager.html?operation=managerEvaluationView">Conflict List</a>${transferCourse1.institution.name}</div>
                    </div>
                <br class="clear">
            </div> --%>
            <!-- Conflict Page 2 End -->
            
            <!-- Conflict Content Start -->
            <div class="conflictListCon">
                <div class="conflictHeader">
                	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl" style="margin-bottom:0px;">
                		<tr>
                			<th width="25%" class="dividerGrey"><span>${transferCourse1.trCourseTitle}</span></th>
                			<th width="20%" class="dividerGrey"><span>${transferCourse.evaluator1.firstName} ${transferCourse.evaluator1.lastName}</span></th>
                			<th width="20%" class="dividerGrey"><span>${transferCourse.evaluator2.firstName} ${transferCourse.evaluator2.lastName}</span></th>
                			<th width="20%" class="dividerGrey"><span>Corrected Data</span></th>
                			<th width="15%" class="dividerGrey"></th>
                		</tr>
                	</table>
                </div>
                
                <div class="conflictExpander">
                	<form id="conflictCourseForm" method="post" action="/scheduling_system/evaluation/ieManager.html?operation=resolveAndSubmitCourse">
                	<h1 class="expand">Course</h1> 
                    <div class="collapse" style="display:block;"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl2">
                          <tr <c:set var="test" scope="page" value="${transferCourse1.trCourseCode == transferCourse2.trCourseCode}"/> <c:if test="${!test}">class="alertCourse"</c:if> >
                            <td width="25%">TR Course Code</td>
                            <td width="20%"><c:if test="${!test && not empty transferCourse1.trCourseCode}"><input name="rd_trcourseCode" type="radio" value="${transferCourse1.trCourseCode}" /></c:if> ${transferCourse1.trCourseCode}</td>
                            <td width="20%"><c:if test="${!test && not empty transferCourse2.trCourseCode}"><input name="rd_trcourseCode" type="radio" value="${transferCourse2.trCourseCode}" /></c:if> ${transferCourse2.trCourseCode}</td>
                            <td width="20%"><c:if test="${!test}"><input name="rd_trcourseCode" type="radio" value="" /></c:if> <input id="trcourseCode" <c:choose> <c:when test="${test}"> type="hidden" value="${transferCourse2.trCourseCode}"</c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose>  class="txbx required" name="trCourseCode"> </td>
                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
                          </tr>
                          <tr <c:set var="test" scope="page" value="${transferCourse1.trCourseTitle == transferCourse2.trCourseTitle}"/> <c:if test="${!test}">class="alertCourse"</c:if> >
                            <td width="25%">TR Course Title</td>
                            <td width="20%"><c:if test="${!test && not empty transferCourse1.trCourseTitle}"><input name="rd_trcourseTitle" type="radio" value="${transferCourse1.trCourseTitle}" /></c:if> ${transferCourse1.trCourseTitle}</td>
                            <td width="20%"><c:if test="${!test && not empty transferCourse2.trCourseTitle}"><input name="rd_trcourseTitle" type="radio" value="${transferCourse2.trCourseTitle}" /></c:if> ${transferCourse2.trCourseTitle}</td>
                            <td width="20%"><c:if test="${!test}"><input name="rd_trcourseTitle" type="radio" value="" /></c:if> <input id="trcourseTitle"<c:choose> <c:when test="${test}"> type="hidden" value="${transferCourse2.trCourseTitle}"</c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose>  class="txbx required" name="trCourseTitle">  </td>
                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
                          </tr>
                          <tr <c:set var="test" scope="page" value="${transferCourse1.transcriptCredits == transferCourse2.transcriptCredits}"/> <c:if test="${!test}">class="alertCourse"</c:if> >
                            <td width="25%">Transcript Credits</td>
                            <td width="20%"><c:if test="${!test && not empty transferCourse1.transcriptCredits}"><input name="rd_trcredits" type="radio" value="${transferCourse1.transcriptCredits}" /></c:if> ${transferCourse1.transcriptCredits}</td>
                            <td width="20%"><c:if test="${!test && not empty transferCourse2.transcriptCredits}"><input name="rd_trcredits" type="radio" value="${transferCourse2.transcriptCredits}" /></c:if> ${transferCourse2.transcriptCredits}</td>
                            <td width="20%"><c:if test="${!test}"><input name="rd_trcredits" type="radio" value="" /></c:if> <input id="trcredits" <c:choose> <c:when test="${test}"> type="hidden" value="${transferCourse2.transcriptCredits}"</c:when> <c:otherwise> type="text"  value=""</c:otherwise></c:choose> class="txbx required number" name="transcriptCredits"> </td>
                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
                          </tr>
                          <tr <c:set var="test" scope="page" value="${transferCourse1.passFail == transferCourse2.passFail}"/> <c:if test="${!test}">class="alertCourse"</c:if> >
                          	<td width="25%">Pass/Fail</td>
                          	<td width="20%"><c:if test="${!test && not empty transferCourse1.passFail}"><input name="rd_pf" type="radio" value="${transferCourse1.passFail}" /></c:if> ${transferCourse1.passFail}</td>
                          	<td width="20%"><c:if test="${!test && not empty transferCourse2.passFail}"><input name="rd_pf" type="radio" value="${transferCourse2.passFail}" /></c:if> ${transferCourse2.passFail}</td>
                          	<td width="20%"><c:if test="${!test}"><input name="rd_pf" type="radio" value="" /></c:if> <input <c:choose> <c:when test="${test}"> type="hidden"  value="${transferCourse2.passFail}"</c:when> <c:otherwise> type="checkbox" value=""</c:otherwise></c:choose>class="txbx" name="passFail" id="pf"> </td>
                          	<td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
                          </tr>
                          <tr <c:set var="test" scope="page" value="${transferCourse1.minimumGrade == transferCourse2.minimumGrade}"/> <c:if test="${!test}">class="alertCourse"</c:if> >
                            <td width="25%">Minimum Grade</td>
                            <td width="20%"><c:if test="${!test && not empty transferCourse1.minimumGrade}"><input name="rd_mingrd" type="radio" value="${transferCourse1.minimumGrade}" /></c:if> ${transferCourse1.minimumGrade}</td>
                            <td width="20%"><c:if test="${!test && not empty transferCourse2.minimumGrade}"><input name="rd_mingrd" type="radio" value="${transferCourse2.minimumGrade}" /></c:if> ${transferCourse2.minimumGrade}</td>
                            <td width="20%"><c:if test="${!test}"><input name="rd_mingrd" type="radio" value="" /></c:if> <input id="mingrd" <c:choose> <c:when test="${test}"> type="hidden" value="${transferCourse2.minimumGrade}"</c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose> class="txbx required" name="minimumGrade"> </td>
                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
                          </tr>
                          <tr <c:set var="test" scope="page" value="${transferCourse1.courseLevelId == transferCourse2.courseLevelId}"/> <c:if test="${!test}">class="alertCourse"</c:if> >
                            <td width="25%">Course Level</td>
                            <td width="20%"><c:if test="${!test && not empty transferCourse1.courseLevelId}"><input name="rd_crslvl" type="radio" value="${transferCourse1.courseLevelId}" /></c:if> ${transferCourse1.courseLevelId}</td>
                            <td width="20%"><c:if test="${!test && not empty transferCourse2.courseLevelId}"><input name="rd_crslvl" type="radio" value="${transferCourse2.courseLevelId}" /></c:if> ${transferCourse2.courseLevelId}</td>
                            <td width="20%"><c:if test="${!test}"><input name="rd_crslvl" type="radio" value="" /></c:if> <input id="crslvl" <c:choose> <c:when test="${test}"> type="hidden" value="${transferCourse2.courseLevelId}"</c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose>  class="txbx" name="courseLevelId"> </td>
                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
                          </tr>
                          <tr <c:set var="test" scope="page" value="${transferCourse1.clockHours == transferCourse2.clockHours}"/> <c:if test="${!test}">class="alertCourse"</c:if> >
                            <td width="25%">Clock  Hours</td>
                            <td width="20%"><c:if test="${!test && not empty transferCourse1.clockHours}"><input name="rd_clkhrs" type="radio" value="${transferCourse1.clockHours}" /></c:if> ${transferCourse1.clockHours}</td>
                            <td width="20%"><c:if test="${!test && not empty transferCourse2.clockHours}"><input name="rd_clkhrs" type="radio" value="${transferCourse2.clockHours}" /></c:if> ${transferCourse2.clockHours}</td>
                            <td width="20%"><c:if test="${!test}"><input name="rd_clkhrs" type="radio" value="" /></c:if> <input id="clkhrs"<c:choose> <c:when test="${test}"> type="hidden" value="${transferCourse2.clockHours}"</c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose> class="txbx required number" name="clockHours"> </td>
                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
                          </tr>
            			  <tr <c:set var="test" scope="page" value="${transferCourse1.catalogCourseDescription == transferCourse2.catalogCourseDescription}"/> <c:if test="${!test}">class="alertCourse"</c:if> >
                            <td width="25%">Catalog Course Description </td>
                            <td width="20%"><c:if test="${!test && not empty transferCourse1.catalogCourseDescription}"><input name="rd_ctcrsdscrptn" type="radio" value="${transferCourse1.catalogCourseDescription}" /></c:if> ${transferCourse1.catalogCourseDescription}</td>
                            <td width="20%"><c:if test="${!test && not empty transferCourse2.catalogCourseDescription}"><input name="rd_ctcrsdscrptn" type="radio" value="${transferCourse2.catalogCourseDescription}" /></c:if> ${transferCourse2.catalogCourseDescription}</td>
                            <td width="20%"><c:if test="${!test}"><input name="rd_ctcrsdscrptn" type="radio" value="" /></c:if> <input id="ctcrsdscrptn" <c:choose> <c:when test="${test}"> type="hidden" value="${transferCourse2.catalogCourseDescription}"</c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose> class="txbx" name="catalogCourseDescription"> </td>
                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
                          </tr>
                          <tr <c:set var="test" scope="page" value="${fn:toLowerCase(transferCourse1.transferStatus) == fn:toLowerCase(transferCourse2.transferStatus)}"/> <c:if test="${!test}">class="alertCourse"</c:if>>
                            <td width="25%">Transfer Status</td>
                            <td width="20%"><c:if test="${!test  && not empty transferCourse1.transferStatus}"><input name="rd_trsts" type="radio" value="${transferCourse1.transferStatus}" /></c:if> ${transferCourse1.transferStatus}</td>
                            <td width="20%"><c:if test="${!test && not empty transferCourse2.transferStatus}"><input name="rd_trsts" type="radio" value="${transferCourse2.transferStatus}" /></c:if> ${transferCourse2.transferStatus}</td>
                            <td width="20%"><c:if test="${!test}"><input name="rd_trsts" type="radio" value="" /></c:if>  <c:choose> <c:when test="${test}"> <input id="trsts" type="hidden" value="${transferCourse2.transferStatus}" class="txbx" name="transferStatus" > </c:when> <c:otherwise> <select id="trsts" name="transferStatus" ><option>Eligible</option><option>Not Eligible</option><option>Pending Evaluation</option></select></c:otherwise></c:choose> </td>
                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
                          </tr>                       
                          <tr <c:set var="test" scope="page" value="${transferCourse1.effectiveDate == transferCourse2.effectiveDate}"/> <c:if test="${!test}">class="alertCourse"</c:if> >
                            <td width="25%">Effective Date</td>
                            <td width="20%"><c:if test="${!test && not empty transferCourse1.effectiveDate}"><input name="rd_effdate" type="radio" value='<fmt:formatDate value="${transferCourse1.effectiveDate}" pattern="MM/dd/yyyy"/>' /></c:if> <fmt:formatDate value="${transferCourse1.effectiveDate}" pattern="MM/dd/yyyy"/></td>
                            <td width="20%"><c:if test="${!test && not empty transferCourse2.effectiveDate}"><input name="rd_effdate" type="radio" value='<fmt:formatDate value="${transferCourse2.effectiveDate}" pattern="MM/dd/yyyy"/>' /></c:if> <fmt:formatDate value="${transferCourse2.effectiveDate}" pattern="MM/dd/yyyy"/></td>
                            <td width="20%"><c:if test="${!test}"><input name="rd_effdate" type="radio" value="" /></c:if> <input id="effdate" <c:choose> <c:when test="${test}"> type="hidden" value='<fmt:formatDate value="${transferCourse2.effectiveDate}" pattern="MM/dd/yyyy"/>'</c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose> class="txbx maskDate required" name="effectiveDate"> </td>
                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
                          </tr>
                          <tr <c:set var="test" scope="page" value="${transferCourse1.endDate == transferCourse2.endDate}"/> <c:if test="${!test}">class="alertCourse"</c:if> >
                            <td width="25%">End Date</td>
                            <td width="20%"><c:if test="${!test && not empty transferCourse1.endDate}"><input name="rd_enddate" type="radio" value='<fmt:formatDate value="${transferCourse1.endDate}" pattern="MM/dd/yyyy"/>' /></c:if> <fmt:formatDate value="${transferCourse1.endDate}" pattern="MM/dd/yyyy"/></td>
                            <td width="20%"><c:if test="${!test && not empty transferCourse2.endDate}"><input name="rd_enddate" type="radio" value='<fmt:formatDate value="${transferCourse2.endDate}" pattern="MM/dd/yyyy"/>' /></c:if> <fmt:formatDate value="${transferCourse2.endDate}" pattern="MM/dd/yyyy"/></td>
                            <td width="20%"><c:if test="${!test}"><input name="rd_enddate" type="radio" value="" /></c:if> <input id="enddate" <c:choose> <c:when test="${test}"> type="hidden" value=' <fmt:formatDate value="${transferCourse2.endDate}" pattern="MM/dd/yyyy"/>'</c:when> <c:otherwise> type="text"  value=""</c:otherwise></c:choose> class="txbx maskDate" name="endDate"> </td>
                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
                          </tr>
                        </table>
                    </div>
      				
      				<c:choose>
      					<c:when test="${fn:length(transferCourse1.courseMappings) gt fn:length(transferCourse2.courseMappings)}">
      						<c:set var="courseMappings" scope="page" value="${transferCourse1.courseMappings}"></c:set>
      					</c:when>
      					<c:otherwise>
      						<c:set var="courseMappings" scope="page" value="${transferCourse2.courseMappings}"></c:set>
      					</c:otherwise>
      				</c:choose>
                  
                    <c:forEach items="${courseMappings}" varStatus="index">
                   		<c:set var="r1a" scope="page" value="${not empty transferCourse1.courseMappings[index.index]}"></c:set>
                    	<c:set var="r2a" scope="page" value="${not empty transferCourse2.courseMappings[index.index]}"></c:set>
                    	<h1 class="expand">Course Relationship </h1>
                    	<div class="collapse" style="display:block;"> 
                    	<div>&nbsp;&nbsp;<input type="checkbox" id="courseRelationshipNA${index.index }" name="courseRelationshipNA" onclick="javascript:disabledGropComponent('${fn:length(courseMappings)}','${index.index }','CourseRelationship');">&nbsp;N/A</div>
	                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl2">
	                        
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${fn:toLowerCase(transferCourse1.courseMappings[index.index].gcuCourse.courseCode) == fn:toLowerCase(transferCourse2.courseMappings[index.index].gcuCourse.courseCode)}"/></c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%">GCU Course Code</td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test && not empty transferCourse1.courseMappings[index.index].gcuCourse.courseCode }"><input id="rd_cmCourseCodeIe1-${index.index}" name="rd_cmCourseCode-${index.index}" type="radio" value="${transferCourse1.courseMappings[index.index].gcuCourse.courseCode}" courseMappingId="${transferCourse1.courseMappings[index.index].gcuCourse.id}"/></c:if> ${transferCourse1.courseMappings[index.index].gcuCourse.courseCode}</c:if> </td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test && not empty transferCourse2.courseMappings[index.index].gcuCourse.courseCode}"><input id="rd_cmCourseCodeIe2-${index.index}" name="rd_cmCourseCode-${index.index}" type="radio" value="${transferCourse2.courseMappings[index.index].gcuCourse.courseCode}" courseMappingId="${transferCourse2.courseMappings[index.index].gcuCourse.id}"/></c:if> ${transferCourse2.courseMappings[index.index].gcuCourse.courseCode}</c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_cmCourseCode-${index.index}" name="rd_cmCourseCode-${index.index}" type="radio" value="" /></c:if><input id="cmCourseCode-${index.index}" <c:choose> <c:when test="${test}"> type="hidden" value="${transferCourse2.courseMappings[index.index].gcuCourse.courseCode}" courseMappingId="${transferCourse2.courseMappings[index.index].gcuCourse.id}"</c:when> <c:otherwise> type="text" value="" courseMappingId=""</c:otherwise></c:choose> class="txbx required cmCourseCode" name="">
	                            <input name="courseMappings[${index.index}].gcuCourse.id" id="cmCourseId-${index.index}" type="hidden" <c:choose> <c:when test="${test}"> value="${transferCourse2.courseMappings[index.index].gcuCourse.id}"</c:when> <c:otherwise>value=""</c:otherwise></c:choose>/>
	                            </td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	  
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${fn:toLowerCase(transferCourse1.courseMappings[index.index].credits) == fn:toLowerCase(transferCourse2.courseMappings[index.index].credits)}"/> </c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%">Credits</td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test && not empty transferCourse1.courseMappings[index.index].credits}"><input id="rd_cmCreditsIe1-${index.index}" name="rd_cmCredits-${index.index}" type="radio" value="${transferCourse1.courseMappings[index.index].credits}" /></c:if> ${transferCourse1.courseMappings[index.index].credits}</c:if></td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test && not empty transferCourse2.courseMappings[index.index].credits}"><input id="rd_cmCreditsIe2-${index.index}" name="rd_cmCredits-${index.index}" type="radio" value="${transferCourse2.courseMappings[index.index].credits}" /></c:if> ${transferCourse2.courseMappings[index.index].credits}</c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_cmCredits-${index.index}" name="rd_cmCredits-${index.index}" type="radio" value="" /></c:if><input id="cmCredits-${index.index}" <c:choose> <c:when test="${test}"> type="hidden" value="${transferCourse2.courseMappings[index.index].credits}"</c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose>class="txbx required number" name="courseMappings[${index.index}].credits"></td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${fn:toLowerCase(transferCourse1.courseMappings[index.index].minTransferGrade) == fn:toLowerCase(transferCourse2.courseMappings[index.index].minTransferGrade)}"/> </c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%">Min TR Grade</td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test && not empty transferCourse1.courseMappings[index.index].minTransferGrade}"><input id="rd_cmMinGradeIe1-${index.index}" name="rd_cmMinGrade-${index.index}" type="radio" value=" ${transferCourse1.courseMappings[index.index].minTransferGrade}" /></c:if> ${transferCourse1.courseMappings[index.index].minTransferGrade}</c:if></td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test && not empty transferCourse2.courseMappings[index.index].minTransferGrade}"><input id="rd_cmMinGradeIe2-${index.index}" name="rd_cmMinGrade-${index.index}" type="radio" value="${transferCourse2.courseMappings[index.index].minTransferGrade}" /></c:if> ${transferCourse2.courseMappings[index.index].minTransferGrade}</c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_cmMinGrade-${index.index}" name="rd_cmMinGrade-${index.index}" type="radio" value="" /></c:if><input id="cmMinGrade-${index.index}" <c:choose> <c:when test="${test}"> type="hidden" value="${transferCourse2.courseMappings[index.index].minTransferGrade}"</c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose>class="txbx " name="courseMappings[${index.index}].minTransferGrade"></td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${transferCourse1.courseMappings[index.index].effectiveDate == transferCourse2.courseMappings[index.index].effectiveDate}"/> </c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%">Effective Date</td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test && not empty transferCourse1.courseMappings[index.index].effectiveDate }"><input id="rd_cmEfDateIe1-${index.index}" name="rd_cmEfDate-${index.index}" type="radio" value='<fmt:formatDate value="${transferCourse1.courseMappings[index.index].effectiveDate}" pattern="MM/dd/yyyy"/>' /></c:if> <fmt:formatDate value="${transferCourse1.courseMappings[index.index].effectiveDate}" pattern="MM/dd/yyyy"/> </c:if></td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test && not empty transferCourse2.courseMappings[index.index].effectiveDate }"><input id="rd_cmEfDateIe2-${index.index}" name="rd_cmEfDate-${index.index}" type="radio" value='<fmt:formatDate value="${transferCourse2.courseMappings[index.index].effectiveDate}" pattern="MM/dd/yyyy"/>' /></c:if> <fmt:formatDate value="${transferCourse2.courseMappings[index.index].effectiveDate}" pattern="MM/dd/yyyy"/> </c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_cmEfDate-${index.index}" name="rd_cmEfDate-${index.index}" type="radio" value="" /></c:if><input id="cmEfDate-${index.index}" <c:choose> <c:when test="${test}"> type="hidden" value='<fmt:formatDate value="${transferCourse2.courseMappings[index.index].effectiveDate}" pattern="MM/dd/yyyy"/>' </c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose> class="txbx maskDate required" name="courseMappings[${index.index}].effectiveDate"></td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${transferCourse1.courseMappings[index.index].endDate == transferCourse2.courseMappings[index.index].endDate}"/> </c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%">End Date</td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test && not empty transferCourse1.courseMappings[index.index].endDate }"><input id="rd_cmendDateIe1-${index.index}" name="rd_cmendDate-${index.index}" type="radio" value='<fmt:formatDate value="${transferCourse1.courseMappings[index.index].endDate}" pattern="MM/dd/yyyy"/>' /></c:if> <fmt:formatDate value="${transferCourse1.courseMappings[index.index].endDate}" pattern="MM/dd/yyyy"/> </c:if></td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test && not empty transferCourse2.courseMappings[index.index].endDate }"><input id="rd_cmendDateIe2-${index.index}" name="rd_cmendDate-${index.index}" type="radio" value='<fmt:formatDate value="${transferCourse2.courseMappings[index.index].endDate}" pattern="MM/dd/yyyy"/>' /></c:if><fmt:formatDate value="${transferCourse2.courseMappings[index.index].endDate}" pattern="MM/dd/yyyy"/> </c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_cmendDate-${index.index}" name="rd_cmendDate-${index.index}" type="radio" value="" /></c:if><input id="cmendDate-${index.index}" <c:choose> <c:when test="${test}"> type="hidden" value='<fmt:formatDate value="${transferCourse2.courseMappings[index.index].endDate}" pattern="MM/dd/yyyy"/>'</c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose> class="txbx maskDate" name="courseMappings[${index.index}].endDate"></td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${fn:toLowerCase(transferCourse1.courseMappings[index.index].evaluationStatus) == fn:toLowerCase(transferCourse2.courseMappings[index.index].evaluationStatus)}"/> </c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%">Evaluation Status</td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test}"><input id="rd_cmevstsIe1-${index.index}" name="rd_cmevsts-${index.index}" type="radio" value="${transferCourse1.courseMappings[index.index].evaluationStatus}" /></c:if> ${transferCourse1.courseMappings[index.index].evaluationStatus}</c:if></td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test}"><input id="rd_cmevstsIe2-${index.index}" name="rd_cmevsts-${index.index}" type="radio" value="${transferCourse2.courseMappings[index.index].evaluationStatus}" /></c:if> ${transferCourse2.courseMappings[index.index].evaluationStatus}</c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_cmevsts-${index.index}" name="rd_cmevsts-${index.index}" type="radio" value="" /></c:if><c:choose> <c:when test="${test}"><input  id="cmevsts-${index.index}" type="hidden" value="${transferCourse2.courseMappings[index.index].evaluationStatus}" class="txbx" name="courseMappings[${index.index}].evaluationStatus"></c:when> <c:otherwise> <select id="cmevsts-${index.index}" name="courseMappings[${index.index}].evaluationStatus"><option>Eligible</option><option>Not Eligible</option><option>Pending Evaluation</option></select></c:otherwise></c:choose></td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                        </table>
                   		</div>
                    </c:forEach>   
                    
                    <c:choose>
      					<c:when test="${fn:length(transferCourse1.courseCategoryMappings) gt fn:length(transferCourse2.courseCategoryMappings)}">
      						<c:set var="courseCategoryMappings" scope="page" value="${transferCourse1.courseCategoryMappings}"></c:set>
      					</c:when>
      					<c:otherwise>
      						<c:set var="courseCategoryMappings" scope="page" value="${transferCourse2.courseCategoryMappings}"></c:set>
      					</c:otherwise>
      				</c:choose>        
                	<c:forEach items="${courseCategoryMappings}" varStatus="index">
                   		<c:set var="r1a" scope="page" value="${not empty transferCourse1.courseCategoryMappings[index.index]}"></c:set>
                    	<c:set var="r2a" scope="page" value="${not empty transferCourse2.courseCategoryMappings[index.index]}"></c:set>
                    	<h1 class="expand">Course Category Relationship</h1>
                    	<div class="collapse" style="display:block;"> 
                    	<div>&nbsp;&nbsp;<input type="checkbox" id="courseCategoryRelationshipNA${index.index }" name="courseCategoryRelationshipNA" onclick="javascript:disabledGropComponent('${fn:length(courseCategoryMappings)}','${index.index }','CourseCategoryRelationship');">&nbsp;N/A</div>
	                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl2">
	                        
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${transferCourse1.courseCategoryMappings[index.index].gcuCourseCategory.id == transferCourse2.courseCategoryMappings[index.index].gcuCourseCategory.id}"/></c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%">GCU Course Category</td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test && not empty transferCourse1.courseCategoryMappings[index.index].gcuCourseCategory.id}"><input id="rd_ccmcourseCodeIe1-${index.index}" name="rd_ccmcourseCode-${index.index}" type="radio" value="${transferCourse1.courseCategoryMappings[index.index].gcuCourseCategory.id}" /></c:if> ${transferCourse1.courseCategoryMappings[index.index].gcuCourseCategory.name}</c:if> </td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test && not empty transferCourse2.courseCategoryMappings[index.index].gcuCourseCategory.id}"><input id="rd_ccmcourseCodeIe2-${index.index}" name="rd_ccmcourseCode-${index.index}" type="radio" value="${transferCourse2.courseCategoryMappings[index.index].gcuCourseCategory.id}" /></c:if> ${transferCourse2.courseCategoryMappings[index.index].gcuCourseCategory.name}</c:if></td>   
	                            <td width="20%"><c:if test="${!test}"><input id="rd_ccmcourseCode-${index.index}" name="rd_ccmcourseCode-${index.index}" type="radio" value="" /></c:if><c:choose><c:when test="${test}"><input id="ccmcourseCode-${index.index}" type="hidden" value="${transferCourse2.courseCategoryMappings[index.index].gcuCourseCategory.id}" class="txbx" name="courseCategoryMappings[${index.index}].gcuCourseCategory.id"> </c:when> <c:otherwise> <select id="ccmcourseCode-${index.index}" name="courseCategoryMappings[${index.index}].gcuCourseCategory.id"> <c:forEach var="gcuCourseCategory" items="${gcuCourseCategoryList}"><option value="${gcuCourseCategory.id}">${gcuCourseCategory.name}</option></c:forEach> </select></c:otherwise> </c:choose></td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	  
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${transferCourse1.courseCategoryMappings[index.index].credits == transferCourse2.courseCategoryMappings[index.index].credits}"/> </c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%">Credits</td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test && not empty transferCourse1.courseCategoryMappings[index.index].credits}"><input id="rd_ccmCreditsIe1-${index.index}" name="rd_ccmCredits-${index.index}" type="radio" value="${transferCourse1.courseCategoryMappings[index.index].credits}" /></c:if> ${transferCourse1.courseCategoryMappings[index.index].credits}</c:if></td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test && not empty transferCourse2.courseCategoryMappings[index.index].credits}"><input id="rd_ccmCreditsIe2-${index.index}" name="rd_ccmCredits-${index.index}" type="radio" value="${transferCourse2.courseCategoryMappings[index.index].credits}" /></c:if> ${transferCourse2.courseCategoryMappings[index.index].credits}</c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_ccmCredits-${index.index}" name="rd_ccmCredits-${index.index}" type="radio" value="" /></c:if> <input id="ccmCredits-${index.index}" <c:choose> <c:when test="${test}"> type="hidden" value="${transferCourse2.courseCategoryMappings[index.index].credits}"</c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose>  class="txbx required number" name="courseCategoryMappings[${index.index}].credits"> </td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${transferCourse1.courseCategoryMappings[index.index].minTransferGrade == transferCourse2.courseCategoryMappings[index.index].minTransferGrade}"/> </c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%">Min TR Grade</td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test && not empty transferCourse1.courseCategoryMappings[index.index].minTransferGrade}"><input id="rd_ccmMinGradeIe1-${index.index}" name="rd_ccmMinGrade-${index.index}" type="radio" value="${transferCourse1.courseCategoryMappings[index.index].minTransferGrade}" /></c:if> ${transferCourse1.courseCategoryMappings[index.index].minTransferGrade}</c:if></td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test && not empty transferCourse2.courseCategoryMappings[index.index].minTransferGrade}"><input id="rd_ccmMinGradeIe2-${index.index}" name="rd_ccmMinGrade-${index.index}" type="radio" value="${transferCourse2.courseCategoryMappings[index.index].minTransferGrade}" /></c:if> ${transferCourse2.courseCategoryMappings[index.index].minTransferGrade}</c:if></td>
	                            <td width="20%">
	                            <c:if test="${!test}">	                            
	                            	<input id="rd_ccmMinGrade-${index.index}" name="rd_ccmMinGrade-${index.index}" type="radio" value="" />
	                            </c:if> 
	                            <c:choose> 
	                            	<c:when test="${test}">
	                            		<input id="ccmMinGrade-${index.index}" type="hidden" value="${transferCourse2.courseCategoryMappings[index.index].minTransferGrade}" class="txbx" name="courseCategoryMappings[${index.index}].minTransferGrade"> 
	                            	</c:when> 
	                            	<c:otherwise> 
	                            		<select id="ccmMinGrade-${index.index}" name="courseCategoryMappings[${index.index}].minTransferGrade" class="required">
		                            			<option value=''>TR Grade</option> <option value="A">A</option> <option value="A-">A-</option> <option value="b">B</option> <option value="B+">B+</option> <option value="B-">B-</option> <option value="C">C</option> <option value="C+">C+</option> <option value="C-">C-</option> <option value="CR">CR</option> <option value="D">D</option> <option value="D+">D+</option> <option value="D-">D-</option> <option value="F">F</option> <option value="I">I</option> <option value="IP">IP</option> <option value="S">S</option><option value="TR">TR</option> <option value="U">U</option> <option value="W">W</option> <option value="WF">WF</option>
		                            	</select>
	                            	</c:otherwise>
	                            </c:choose>
	                            	</td>
	                            <td width="15%" align="center">
	                            <c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${transferCourse1.courseCategoryMappings[index.index].effectiveDate == transferCourse2.courseCategoryMappings[index.index].effectiveDate}"/> </c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%">Effective Date</td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test && not empty transferCourse1.courseCategoryMappings[index.index].effectiveDate}"><input id="rd_ccmefDateIe1-${index.index}" name="rd_ccmefDate-${index.index}" type="radio" value='<fmt:formatDate value="${transferCourse1.courseCategoryMappings[index.index].effectiveDate}" pattern="MM/dd/yyyy"/>' /></c:if><fmt:formatDate value="${transferCourse1.courseCategoryMappings[index.index].effectiveDate}" pattern="MM/dd/yyyy"/></c:if></td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test && not empty transferCourse2.courseCategoryMappings[index.index].effectiveDate}"><input id="rd_ccmefDateIe2-${index.index}" name="rd_ccmefDate-${index.index}" type="radio" value='<fmt:formatDate value="${transferCourse2.courseCategoryMappings[index.index].effectiveDate}" pattern="MM/dd/yyyy"/>' /></c:if><fmt:formatDate value="${transferCourse2.courseCategoryMappings[index.index].effectiveDate}" pattern="MM/dd/yyyy"/></c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_ccmefDate-${index.index}" name="rd_ccmefDate-${index.index}" type="radio" value="" /></c:if> <input id="ccmefDate-${index.index}" <c:choose> <c:when test="${test}"> type="hidden" value='<fmt:formatDate value="${transferCourse2.courseCategoryMappings[index.index].effectiveDate}" pattern="MM/dd/yyyy"/>' </c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose>  class="txbx maskDate required" name="courseCategoryMappings[${index.index}].effectiveDate"> </td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${transferCourse1.courseCategoryMappings[index.index].endDate == transferCourse2.courseCategoryMappings[index.index].endDate}"/> </c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%">End Date</td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test && not empty transferCourse1.courseCategoryMappings[index.index].endDate}"><input id="rd_ccmEndDateIe1-${index.index}" name="rd_ccmEndDate-${index.index}" type="radio" value='<fmt:formatDate value="${transferCourse1.courseCategoryMappings[index.index].endDate}" pattern="MM/dd/yyyy"/>' /></c:if><fmt:formatDate value="${transferCourse1.courseCategoryMappings[index.index].endDate}" pattern="MM/dd/yyyy"/></c:if></td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test && not empty transferCourse2.courseCategoryMappings[index.index].endDate}"><input id="rd_ccmEndDateIe2-${index.index}" name="rd_ccmEndDate-${index.index}" type="radio" value='<fmt:formatDate value="${transferCourse2.courseCategoryMappings[index.index].endDate}" pattern="MM/dd/yyyy"/>' /></c:if><fmt:formatDate value="${transferCourse2.courseCategoryMappings[index.index].endDate}" pattern="MM/dd/yyyy"/></c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_ccmEndDate-${index.index}" name="rd_ccmEndDate-${index.index}" type="radio" value="" /></c:if> <input id="ccmEndDate-${index.index}" <c:choose> <c:when test="${test}"> type="hidden" value='<fmt:formatDate value="${transferCourse2.courseCategoryMappings[index.index].endDate}" pattern="MM/dd/yyyy"/>' </c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose> class="txbx maskDate" name="courseCategoryMappings[${index.index}].endDate">  </td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${fn:toLowerCase(transferCourse1.courseCategoryMappings[index.index].evaluationStatus) == fn:toLowerCase(transferCourse2.courseCategoryMappings[index.index].evaluationStatus)}"/> </c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%">Evaluation Status</td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test && not empty transferCourse1.courseCategoryMappings[index.index].evaluationStatus}"><input id="rd_ccmevstsIe1-${index.index}" name="rd_ccmevsts-${index.index}" type="radio" value="${transferCourse1.courseCategoryMappings[index.index].evaluationStatus}" /></c:if> ${transferCourse1.courseCategoryMappings[index.index].evaluationStatus}</c:if></td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test && not empty transferCourse2.courseCategoryMappings[index.index].evaluationStatus}"><input id="rd_ccmevstsIe2-${index.index}" name="rd_ccmevsts-${index.index}" type="radio" value="${transferCourse2.courseCategoryMappings[index.index].evaluationStatus}" /></c:if> ${transferCourse2.courseCategoryMappings[index.index].evaluationStatus}</c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_ccmevsts-${index.index}" name="rd_ccmevsts-${index.index}" type="radio" value="" /></c:if> <c:choose> <c:when test="${test}"> <input id="ccmevsts-${index.index}" type="hidden" value="${transferCourse2.courseCategoryMappings[index.index].evaluationStatus}" class="txbx" name="courseCategoryMappings[${index.index}].evaluationStatus" ></c:when> <c:otherwise> <select id="ccmevsts-${index.index}" name="courseCategoryMappings[${index.index}].evaluationStatus"><option>Eligible</option><option>Not Eligible</option><option>Pending Evaluation</option></select></c:otherwise></c:choose>  </td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                        </table>
                   		</div>
                    </c:forEach>
                    
                    <c:choose>
      					<c:when test="${fn:length(transferCourse1.titleList) gt fn:length(transferCourse2.titleList)}">
      						<c:set var="titleList" scope="page" value="${transferCourse1.titleList}"></c:set>
      					</c:when>
      					<c:otherwise>
      						<c:set var="titleList" scope="page" value="${transferCourse2.titleList}"></c:set>
      					</c:otherwise>
      				</c:choose>        
                	<c:forEach items="${titleList}" varStatus="index">
                   		<c:set var="r1a" scope="page" value="${not empty transferCourse1.titleList[index.index]}"></c:set>
                    	<c:set var="r2a" scope="page" value="${not empty transferCourse2.titleList[index.index]}"></c:set>
                    	<h1 class="expand">Course Titles </h1>
                    	<div class="collapse" style="display:block;"> 
                    	<div>&nbsp;&nbsp;<input type="checkbox" id="courseTitlesNA${index.index }" name="courseTitlesNA" onclick="javascript:disabledGropComponent('${fn:length(titleList)}','${index.index }','CourseTitles');">&nbsp;N/A</div>
	                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl2">
	                        
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${transferCourse1.titleList[index.index].title == transferCourse2.titleList[index.index].title}"/></c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%">Title</td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test && not empty transferCourse1.titleList[index.index].title}"><input id="rd_ttlIe1-${index.index}" name="rd_ttl-${index.index}" type="radio" value="${transferCourse1.titleList[index.index].title}" /></c:if> ${transferCourse1.titleList[index.index].title}</c:if> </td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test && not empty transferCourse2.titleList[index.index].title}"><input id="rd_ttlIe2-${index.index}" name="rd_ttl-${index.index}" type="radio" value="${transferCourse2.titleList[index.index].title}" /></c:if> ${transferCourse2.titleList[index.index].title}</c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_ttl-${index.index}" name="rd_ttl-${index.index}" type="radio" value="rd_ttl-${index.index}" /></c:if> <input id="ttl-${index.index}" <c:choose> <c:when test="${test}"> type="hidden" value="${transferCourse2.titleList[index.index].title}"</c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose>  class="txbx" name="titleList[${index.index}].title"> </td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	  
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${transferCourse1.titleList[index.index].effectiveDate == transferCourse2.titleList[index.index].effectiveDate}"/> </c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%">Effective Date</td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test && not empty transferCourse1.titleList[index.index].effectiveDate}"><input id="rd_ttlefDateIe1-${index.index}" name="rd_ttlefDate-${index.index}" type="radio" value='<fmt:formatDate value="${transferCourse1.titleList[index.index].effectiveDate}" pattern="MM/dd/yyyy"/>' /></c:if><fmt:formatDate value="${transferCourse1.titleList[index.index].effectiveDate}" pattern="MM/dd/yyyy"/></c:if></td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test && not empty transferCourse2.titleList[index.index].effectiveDate}"><input id="rd_ttlefDateIe2-${index.index}" name="rd_ttlefDate-${index.index}" type="radio" value='<fmt:formatDate value="${transferCourse2.titleList[index.index].effectiveDate}" pattern="MM/dd/yyyy"/>' /></c:if><fmt:formatDate value="${transferCourse2.titleList[index.index].effectiveDate}" pattern="MM/dd/yyyy"/></c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_ttlefDate-${index.index}" name="rd_ttlefDate-${index.index}" type="radio" value="" /></c:if> <input id="ttlefDate-${index.index}" <c:choose> <c:when test="${test}"> type="hidden" value='<fmt:formatDate value="${transferCourse2.titleList[index.index].effectiveDate}" pattern="MM/dd/yyyy"/>'</c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose>  class="txbx" name="titleList[${index.index}].effectiveDate"> </td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${transferCourse1.titleList[index.index].endDate == transferCourse2.titleList[index.index].endDate}"/> </c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%">End Date</td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test && not empty transferCourse1.titleList[index.index].endDate}"><input id="rd_ttlendDateIe1-${index.index}" name="rd_ttlendDate-${index.index}" type="radio" value='<fmt:formatDate value="${transferCourse1.titleList[index.index].endDate}" pattern="MM/dd/yyyy"/>' /></c:if><fmt:formatDate value="${transferCourse1.titleList[index.index].endDate}" pattern="MM/dd/yyyy"/></c:if></td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test && not empty transferCourse2.titleList[index.index].endDate}"><input id="rd_ttlendDateIe2-${index.index}" name="rd_ttlendDate-${index.index}" type="radio" value='<fmt:formatDate value="${transferCourse2.titleList[index.index].endDate}" pattern="MM/dd/yyyy"/>' /></c:if><fmt:formatDate value="${transferCourse2.titleList[index.index].endDate}" pattern="MM/dd/yyyy"/></c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_ttlendDate-${index.index}" name="rd_ttlendDate-${index.index}" type="radio" value="" /></c:if> <input id="ttlendDate-${index.index}" <c:choose> <c:when test="${test}"> type="hidden" value='<fmt:formatDate value="${transferCourse2.titleList[index.index].endDate}" pattern="MM/dd/yyyy"/>'</c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose> class="txbx" name="titleList[${index.index}].endDate"> </td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${fn:toLowerCase(transferCourse1.titleList[index.index].evaluationStatus) == fn:toLowerCase(transferCourse2.titleList[index.index].evaluationStatus)}"/> </c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%">Evaluation Status</td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test && not empty transferCourse1.titleList[index.index].evaluationStatus}"><input id="rd_ttevstsIe1-${index.index}" name="rd_ttevsts-${index.index}" type="radio" value="${transferCourse1.titleList[index.index].evaluationStatus}" /></c:if> ${transferCourse1.titleList[index.index].evaluationStatus}</c:if></td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test && not empty transferCourse2.titleList[index.index].evaluationStatus}"><input id="rd_ttevstsIe2-${index.index}" name="rd_ttevsts-${index.index}" type="radio" value="${transferCourse2.titleList[index.index].evaluationStatus}" /></c:if> ${transferCourse2.titleList[index.index].evaluationStatus}</c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_ttevsts-${index.index}" name="rd_ttevsts-${index.index}" type="radio" value="" /></c:if> <input id="ttevsts-${index.index}" <c:choose> <c:when test="${test}"> type="hidden" value="${transferCourse2.titleList[index.index].evaluationStatus}"</c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose>  class="txbx" name="titleList[${index.index}].evaluationStatus"> </td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                        </table>
                   		</div>
                    </c:forEach>
                    
                    <input type="hidden" value="${transferCourse1.institution.id}" name="institutionId"/>
                    <input type="hidden" value="${transferCourse1.id}" name="transferCourseId"/>
                     <br class="clear"/>
                    
                    <div class="fr mt10 mb10 mr10">
                		<input type="submit" value="Resolve Conflict"/>
                	</div>
                    <br class="clear"/>
                    </form>
                </div>
                <br class="clear"/>
                <br class="clear"/>
                <br class="clear"/>
                <br class="clear"/>
                <br class="clear"/>
                <br class="clear"/>
            </div>
            <!-- Conflict Content Start -->
        
        </div>	  
		<div id="tabs-2"></div>
	  	<div id="tabs-3"></div>
    </div>
	 
</div>
    
<!--  
<div class="tblFormDiv divCover "  >
 
	<div class="left">
	
    <table width="100%" border="0" cellspacing="1" cellpadding="0" class="backgrnd">
  <tr>
    <th colspan="2" class="heading">Course</th>
    </tr>
  <tr>
    <td width="40%" class="table-content">School Code</td>
    <td width="60%" class="table-content">${transferCourse1.institution.schoolcode}</td>
  </tr>
  <tr>
    <td class="table-content">TR Course ID</td>
    <td class="table-content"> ${transferCourse1.trCourseCode}</td>
  </tr>
    <tr>
                <td class="table-content">Transcript Credits</td>
                <td class="table-content">${transferCourse1.transcriptCredits}</td>
            </tr>
            <tr>
                <td class="table-content">Semester Credits</td>
                <td class="table-content">${transferCourse1.semesterCredits}</td>
            </tr>
            <tr>
                <td class="table-content">Pass/Fail</td>
                <td class="table-content">${transferCourse1.passFail}</td>
            </tr>
            <tr>
                <td class="table-content">Minimum Grade</td>
                <td class="table-content">${transferCourse1.minimumGrade}</td>
            </tr>
            <tr>
                <td class="table-content">Course Level</td>
                <td class="table-content">${transferCourse1.courseLevelId}</td>
            </tr>
            <tr>
                <td class="table-content">Clock  Hours</td>
                <td class="table-content">${transferCourse1.clockHours}</td>
            </tr>
            <tr>
                <td class="table-content">Effective Date</td>
                <td class="table-content"><fmt:formatDate value="${transferCourse1.effectiveDate}" pattern="MM/dd/yyyy"/></td>
            </tr>
            <tr>
                <td class="table-content">End Date</td>
                <td class="table-content"><fmt:formatDate value="${transferCourse1.endDate}" pattern="MM/dd/yyyy"/></td>
            </tr>
            <tr>
                <td class="table-content">Catalog Course Description</td>
                <td class="table-content">${transferCourse1.catalogCourseDescription}</td>
            </tr>
            <tr>
                <td class="table-content">Transfer Status</td>
                <td class="table-content">${transferCourse1.transferStatus}</td>
            </tr>
  <tr>
    <th colspan="2" class="heading">Course Relationship</th>
  </tr>
  <tr>
    <td colspan="2" class="table-content">
		 <table class="tableS2" width="100%" style="border-collapse: collapse; border-color: #AAAFB2"
            border="1" cellspacing="0" cellpadding="0">
            <tr>
                <th width="5%">Record #</th>
                <th width="15%">GCU Course Code</th>
                <th width="20%">GCU Course Title</th>
                <th width="10%">Credits</th>
                <th width="10%">Min TR Grade</th>
                <th width="10%">Effective Date</th>
                <th width="10%">End Date</th>
                <th width="10%">Evaluation Status</th>
            
            </tr>
              <c:forEach items="${transferCourse1.courseMappings}" var="courseMapping" varStatus="index">
	             <tr>
	                <td align="center"><c:out value="${index.count}" /></td>
	                <td align="center"><c:out value="${courseMapping.gcuCourse.courseCode}" /></td>
	                <td>&nbsp;</td>
	                <td align="center"><c:out value="${courseMapping.credits}" /></td>
	                <td align="center"><c:out value="${courseMapping.minTransferGrade}" /></td>
	                <td align="center"><fmt:formatDate value="${courseMapping.effectiveDate}" pattern="MM/dd/yyyy"/></td>
	                <td align="center" ><fmt:formatDate value="${courseMapping.endDate}" pattern="MM/dd/yyyy"/></td>
	                <td align="center" ><c:out value="${courseMapping.evaluationStatus}" /></td>
	               
	           
	            </tr>
            </c:forEach>
           
            
            
        </table>
	</td>
    
  </tr>
  <tr>
     <th colspan="2" class="heading">Course Category Relationship</th>
    </tr>
  <tr>
   <td colspan="2" class="table-content">
     <table class="tableS2" width="100%" style="border-collapse: collapse; border-color: #AAAFB2"
            border="1" cellspacing="0" cellpadding="0">
            <tr>
                <th width="5%">Record #</th>
                <th width="15%">GCU Course Category Code</th>
                <th width="20%">GCU Course Category Title</th>
                <th width="10%">Credits</th>
                <th width="10%">Min TR Grade</th>
                <th width="10%">Effective Date</th>
                <th width="10%">End Date</th>
                <th width="10%">Evaluation Status</th>
               
            </tr>
             <c:forEach items="${transferCourse1.courseCategoryMappings}" var="courseCategoryMapping" varStatus="index">
	             <tr>
	                <td align="center"><c:out value="${courseCategoryMapping.id}" /></td>
	                <td align="center"><c:out value="${courseCategoryMapping.gcuCourseCategory.id}" /></td>
	                <td><c:out value="${courseCategoryMapping.trCourseId}" /></td>
	                <td align="center"><c:out value="${courseCategoryMapping.credits}" /></td>
	                <td align="center"><c:out value="${courseCategoryMapping.minTransferGrade}" /></td>
	                <td align="center"><fmt:formatDate value="${courseCategoryMapping.effectiveDate}" pattern="MM/dd/yyyy"/></td>
	                <td align="center" ><fmt:formatDate value="${courseCategoryMapping.endDate}" pattern="MM/dd/yyyy"/></td>
	                <td align="center" ><c:out value="${courseCategoryMapping.evaluationStatus}" /></td>
	                
	           
	            </tr>
            </c:forEach>
          
        </table>
   </td>
  </tr>
    <tr>
     <th colspan="2" class="heading">Course Titles</th>
    </tr>
  <tr>
   <tr>
   <td colspan="2" class="table-content">
     <table class="tableS2" width="100%" style="border-collapse: collapse; border-color: #AAAFB2"
            border="1" cellspacing="0" cellpadding="0">
            <tr>
                <th width="5%">Record #</th>
                <th width="20%"> Title</th>
                <th width="10%">Effective Date</th>
                <th width="10%">End Date</th>
                <th width="10%">Evaluation Status</th>
               
            </tr>
             <c:forEach items="${transferCourse1.titleList}" var="title" varStatus="index">
	             <tr>
	                <td align="center"><c:out value="${title.id}" /></td>
	                <td align="center"><c:out value="${title.title}" /></td>
	                <td align="center"><fmt:formatDate value="${title.effectiveDate}" pattern="MM/dd/yyyy"/></td>
	                <td align="center" ><fmt:formatDate value="${title.endDate}" pattern="MM/dd/yyyy"/></td>
	                <td align="center" ><c:out value="${title.evaluationStatus}" /></td>
	          </tr>
            </c:forEach>
          
        </table>
   </td>
  </tr>
  
  
  </table>
  
 
	</div>
    
    	<div class="right">
	
     <table width="100%" border="0" cellspacing="1" cellpadding="0" class="backgrnd">
  <tr>
    <th colspan="2" class="heading">Course</th>
    </tr>
  <tr>
    <td width="40%" class="table-content">School Code</td>
    <td width="60%" class="table-content">${transferCourse2.institution.schoolcode}</td>
  </tr>
  <tr>
    <td class="table-content">TR Course ID</td>
    <td class="table-content"> ${transferCourse2.trCourseCode}</td>
  </tr>
    <tr>
                <td class="table-content">Transcript Credits</td>
                <td class="table-content">${transferCourse2.transcriptCredits}</td>
            </tr>
            <tr>
                <td class="table-content">Semester Credits</td>
                <td class="table-content">${transferCourse2.semesterCredits}</td>
            </tr>
            <tr>
                <td class="table-content">Pass/Fail</td>
                <td class="table-content">${transferCourse2.passFail}</td>
            </tr>
            <tr>
                <td class="table-content">Minimum Grade</td>
                <td class="table-content">${transferCourse2.minimumGrade}</td>
            </tr>
            <tr>
                <td class="table-content">Course Level</td>
                <td class="table-content">${transferCourse2.courseLevelId}</td>
            </tr>
            <tr>
                <td class="table-content">Clock  Hours</td>
                <td class="table-content">${transferCourse2.clockHours}</td>
            </tr>
            <tr>
                <td class="table-content">Effective Date</td>
                <td class="table-content"><fmt:formatDate value="${transferCourse2.effectiveDate}" pattern="MM/dd/yyyy"/></td>
            </tr>
            <tr>
                <td class="table-content">End Date</td>
                <td class="table-content"><fmt:formatDate value="${transferCourse2.endDate}" pattern="MM/dd/yyyy"/></td>
            </tr>
            <tr>
                <td class="table-content">Catalog Course Description</td>
                <td class="table-content">${transferCourse2.catalogCourseDescription}</td>
            </tr>
            <tr>
                <td class="table-content">Transfer Status</td>
                <td class="table-content">${transferCourse2.transferStatus}</td>
            </tr>
  <tr>
    <th colspan="2" class="heading">Course Relationship</th>
  </tr>
  <tr>
    <td colspan="2" class="table-content">
		 <table class="tableS2" width="100%" style="border-collapse: collapse; border-color: #AAAFB2"
            border="1" cellspacing="0" cellpadding="0">
            <tr>
                <th width="5%">Record #</th>
                <th width="15%">GCU Course Code</th>
                <th width="20%">GCU Course Title</th>
                <th width="10%">Credits</th>
                <th width="10%">Min TR Grade</th>
                <th width="10%">Effective Date</th>
                <th width="10%">End Date</th>
                <th width="10%">Evaluation Status</th>
               
            </tr>
              <c:forEach items="${transferCourse2.courseMappings}" var="courseMapping" varStatus="index">
	             <tr>
	                <td align="center"><c:out value="${index.count}" /></td>
	                <td align="center"><c:out value="${courseMapping.gcuCourse.courseCode}" /></td>
	                <td> &nbsp;</td>
	                <td align="center"><c:out value="${courseMapping.credits}" /></td>
	                <td align="center"><c:out value="${courseMapping.minTransferGrade}" /></td>
	                <td align="center"><fmt:formatDate value="${courseMapping.effectiveDate}" pattern="MM/dd/yyyy"/></td>
	                <td align="center" ><fmt:formatDate value="${courseMapping.endDate}" pattern="MM/dd/yyyy"/></td>
	                <td align="center" ><c:out value="${courseMapping.evaluationStatus}" /></td>
	               
	               
	            </tr>
            </c:forEach>
           
            
            
        </table>
	</td>
    
  </tr>
  <tr>
     <th colspan="2" class="heading">Course Category Relationship</th>
    </tr>
  <tr>
   <td colspan="2" class="table-content">
     <table class="tableS2" width="100%" style="border-collapse: collapse; border-color: #AAAFB2"
            border="1" cellspacing="0" cellpadding="0">
            <tr>
                <th width="5%">Record #</th>
                <th width="15%">GCU Course Category Code</th>
                <th width="20%">GCU Course Category Title</th>
                <th width="10%">Credits</th>
                <th width="10%">Min TR Grade</th>
                <th width="10%">Effective Date</th>
                <th width="10%">End Date</th>
                <th width="10%">Evaluation Status</th>
              
            </tr>
             <c:forEach items="${transferCourse2.courseCategoryMappings}" var="courseCategoryMapping" varStatus="index">
	             <tr>
	                <td align="center"><c:out value="${courseCategoryMapping.id}" /></td>
	                <td align="center"><c:out value="${courseCategoryMapping.gcuCourseCategory.id}" /></td>
	                <td><c:out value="${courseCategoryMapping.trCourseId}" /></td>
	                <td align="center"><c:out value="${courseCategoryMapping.credits}" /></td>
	                <td align="center"><c:out value="${courseCategoryMapping.minTransferGrade}" /></td>
	                <td align="center"><fmt:formatDate value="${courseCategoryMapping.effectiveDate}" pattern="MM/dd/yyyy"/></td>
	                <td align="center" ><fmt:formatDate value="${courseCategoryMapping.endDate}" pattern="MM/dd/yyyy"/></td>
	                <td align="center" ><c:out value="${courseCategoryMapping.evaluationStatus}" /></td>
	                
	            	
	            </tr>
            </c:forEach>
          
        </table>
   </td>
  </tr>
  <tr>
     <th colspan="2" class="heading">Course Titles</th>
    </tr>
  <tr>
  <tr>
   <td colspan="2" class="table-content">
     <table class="tableS2" width="100%" style="border-collapse: collapse; border-color: #AAAFB2"
            border="1" cellspacing="0" cellpadding="0">
            <tr>
                <th width="5%">Record #</th>
                <th width="20%"> Title</th>
                <th width="10%">Effective Date</th>
                <th width="10%">End Date</th>
                <th width="10%">Evaluation Status</th>
               
            </tr>
             <c:forEach items="${transferCourse2.titleList}" var="title" varStatus="index">
	             <tr>
	                <td align="center"><c:out value="${title.id}" /></td>
	                <td align="center"><c:out value="${title.title}" /></td>
	                <td align="center"><fmt:formatDate value="${title.effectiveDate}" pattern="MM/dd/yyyy"/></td>
	                <td align="center" ><fmt:formatDate value="${title.endDate}" pattern="MM/dd/yyyy"/></td>
	                <td align="center" ><c:out value="${title.evaluationStatus}" /></td>
	          </tr>
            </c:forEach>
          
        </table>
   </td>
  </tr>
  
  </table>
  
  </div>
 
  
   <br class="clear"/>
     <div class="left"><input name="selectCourse" type="radio" value="${mirrorId1}" />
<label>Please select</label>
</div>
<div class="right"><input name="selectCourse" type="radio" value="${mirrorId2}" />
<label>Please select</label>
</div>
   
   
	<div style="float:right;margin-right:10px;">

	  <input class="button" title="Edit" value="Edit" onclick="updateCourse('edit');" type="button">
	  <input class="button" title="Save" value="Save" onclick="updateCourse('submit');" type="button">
  
  </div>
  <div class="clear"></div>
  </div> -->
  