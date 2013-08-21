<%@include file="../init.jsp"%>


<link href="<c:url value="/css/boxy.css"/>" rel="stylesheet" type="text/css" />
<link href="<c:url value="/css/boxypopupscrollfix.css"/>" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="<c:url value="/css/jquery.ui.all.css"/>" />
<!--[if IE 9]>
  <link href="css/ie9.css" rel="stylesheet" type="text/css" />
<![endif]-->

<script type="text/javascript" src="<c:url value="/js/jquery.validate.js"/>"></script>

<script type="text/javascript">
var win=null;
function NewWindow(mypage,myname,w,h,scroll,pos){
if(pos=="random"){LeftPosition=(screen.width)?Math.floor(Math.random()*(screen.width-w)):100;TopPosition=(screen.height)?Math.floor(Math.random()*((screen.height-h)-75)):100;}
if(pos=="center"){LeftPosition=(screen.width)?(screen.width-w)/2:100;TopPosition=(screen.height)?(screen.height-h)/2:100;}
else if((pos!="center" && pos!="random") || pos==null){LeftPosition=0;TopPosition=20}
settings='width='+w+',height='+h+',top='+TopPosition+',left='+LeftPosition+',scrollbars='+scroll+',location=no,directories=no,status=no,menubar=no,toolbar=no,resizable=no';
win=window.open(mypage,myname,settings);
}

function clockHrsCal(){

	if("${transferCourse.clockHours}".length>0 && "${transferCourse.clockHours}"!="0"){
		jQuery("#courseTypeId").removeAttr('disabled');
		jQuery("#clockHours").removeAttr('disabled');
		jQuery("#courseTypeId").val('${transferCourse.clockHoursChk}');
		jQuery("#clockHours").val('${transferCourse.clockHours}');
		jQuery('input[name$=transcriptCredits]').attr('disabled','disabled');
		jQuery("#clockHoursChk").attr('checked','checked');
		
		
	}else{
		jQuery("#courseTypeId").attr('disabled','disabled');
		jQuery("#clockHours").attr('disabled','disabled');
		jQuery("#courseTypeId").val('');
		jQuery("#clockHours").val('');
		jQuery('input[name$=transcriptCredits]').removeAttr('disabled');
		jQuery("#clockHoursChk").removeAttr('checked');
	}
	
	jQuery("#courseTypeId , #clockHours").blur(function(){
		var clockHours=jQuery("#clockHours").val();
		var courseType=jQuery("#courseTypeId").val();
		var semesterCredit=0;
		if(clockHours.length>0 && clockHours>0 && clockHours!=0){
			if(courseType=="Lecture"){
				semesterCredit=parseInt(clockHours)/15;
				jQuery("#semesterCredits").val(semesterCredit.toFixed(2));
			}else if(courseType=="Lab"){
				semesterCredit=parseInt(clockHours)/30;
				jQuery("#semesterCredits").val(semesterCredit.toFixed(2));
			}else if(courseType=="Clinical"){
				semesterCredit=parseInt(clockHours)/45;
				jQuery("#semesterCredits").val(semesterCredit.toFixed(2));
			}else if(courseType==""){
			jQuery("#semesterCredits").val("---");
			}
			
			
		}else{
			jQuery("#semesterCredits").val("---");
		}
		
	});
}

function evalSemEq(textBox){
	//alert(${institutionTermType.termType.name});
	var credit=jQuery('input[name$=transcriptCredits]').val();
	var semEqValue=0;
	if(credit.length>0&&!isNaN(credit)){
		semEqValue= parseInt(credit);
	}
	
	if( "${transferCourse.clockHoursChk}".length==0 || "${transferCourse.clockHoursChk}"=="false"){
		if("${transferCourse.institution.evaluationStatus}".toUpperCase() == "EVALUATED" && semEqValue != ''  ){
			if("${institutionTermType.termType.name}"=="Quarter"){
				semEqValue = parseFloat(semEqValue)*2/3;
				jQuery('input[name$=semesterCredits]').val(semEqValue.toFixed(2));	
			}
			else if("${institutionTermType.termType.name}"=="4-1-4"){
				semEqValue = parseFloat(semEqValue)*4;
				jQuery('input[name$=semesterCredits]').val(semEqValue.toFixed(2));
			}
			else if("${institutionTermType.termType.name}"=="Semester"){
				jQuery('input[name$=semesterCredits]').val(semEqValue.toFixed(2));
			}
			else{
				jQuery('input[name$=semesterCredits]').val("---");
			}
		}
		else{
			jQuery('input[name$=semesterCredits]').val("---");
		}
	
	}else{
		jQuery('input[name$=semesterCredits]').val("${transferCourse.semesterCredits}");
		//jQuery('input[name$=transcriptCredits]').attr('disabled','disabled');

	}
	
}

window.onload = (function () {
jQuery(document).ready(function(){
	
	jQuery('form').submit(function() {
		if(jQuery(this).valid()){
			jQuery('input:submit').attr("disabled", true);
		}else{
			jQuery('input:submit').removeAttr("disabled");
			jQuery("#sendToIEManager").attr("disabled","disabled");
		}

	});
	
	/* if(jQuery('input[name=passFail]').attr('checked')){
		jQuery('input[name=minimumGrade]').removeClass('number');
		jQuery('input[name=minimumGrade]').val('PASS');
		jQuery('input[name=minimumGrade]').attr('readonly',true);
	}
	
	jQuery(jQuery('input[name=passFail]')).change(function(){
		var minGrade = jQuery('input[name=minimumGrade]');
			if($('input[name=passFail]').attr('checked')){
				minGrade.removeClass('number');
				minGrade.val('PASS');
				minGrade.attr('readonly',true);
			}
			else{
				minGrade.addClass('number');
				minGrade.val('');
				minGrade.attr('readonly',false);
			}
	}); */
	

	jQuery("[name='trCourseCode']").css("text-transform" ,"uppercase" );
	clockHrsCal();
	jQuery("#courseTypeId").val('${transferCourse.courseType}');
	if('${transferCourse.institution.institutionType.id}' == '5'){
		jQuery("#editSubjectId32").css("display",true);
		jQuery("#aceExhibitNoId1").css("display","block");	
		jQuery("#aceExhibitNoTextId").addClass("required");
		jQuery('input[name$=transcriptCredits]').removeClass("required");
	}else{
		jQuery("#editSubjectId32").css("display","none");
		jQuery("#aceExhibitNoId1").css("display","none");
		jQuery("#aceExhibitNoTextId").removeClass("required");
		jQuery('input[name$=transcriptCredits]').addClass("required");
	}	
	jQuery("#clockHoursChk").click(function(){
		if(jQuery(this).is(':checked')){
			jQuery('input[name$=transcriptCredits]').attr('disabled','disabled');
			jQuery("#clockHours").removeAttr('disabled');
			jQuery("#courseTypeId").removeAttr('disabled');
			jQuery('input[name$=transcriptCredits]').val('');
		}else{
			jQuery("#courseTypeId").val('');
			jQuery("#clockHours").val('');
			jQuery("#courseTypeId").attr('disabled','disabled');
			jQuery("#clockHours").attr('disabled','disabled');
			jQuery('input[name$=transcriptCredits]').removeAttr('disabled');
		}
	})
	
	//before "mark complete" make sure the course mapping is added or course is not eligible for transfer
	jQuery("#markComplete").click(function(){
		if((jQuery("#transferStatus").val()).toLowerCase() == 'Eligible'.toLowerCase()){
			if(${empty courseMappingList} && ${empty courseCategoryMappingList}){
				alert("Add a mapping for the course");
			}
			else{
				window.location = "/scheduling_system/evaluation/quality.html?operation=markCompleteCourse&transferCourseMirrorId=${transferCourseMirrorId}";
			}
		}
		else{
			window.location = "/scheduling_system/evaluation/quality.html?operation=markCompleteCourse&transferCourseMirrorId=${transferCourseMirrorId}";
		}
		
	});
	
	/* jQuery("#sendToIEManager").click(function(){
		if(confirm("This course will be sent to IE Manager for college approval."+'\n\n\t\t'+"Press Ok if you wish to proceed.")){
			window.location = "/scheduling_system/evaluation/quality.html?operation=sendForCollegeApproval&transferCourseMirrorId=${transferCourseMirrorId}&transferCourseId=${transferCourse.id}";
		} 
	});*/
	
	jQuery("#transferStatus").val('${transferCourse.transferStatus}')	;
	
	if('${institution.evaluationStatus}'.toLowerCase()=='EVALUATED'.toLowerCase() || '${institutionMirror.evaluationStatus}'.toLowerCase()=='COMPLETED'.toLowerCase()){
		if('${transferCourseMirrorId}'!=''){
			jQuery('#markComplete').show();
			jQuery('#courseRelationship').attr('disabled','');
			jQuery('#courseCatRelationship').attr('disabled','');
			jQuery('#titleList').attr('disabled','');
		}else{
			jQuery('#markComplete').hide();
			jQuery('#courseRelationship').attr('disabled','disabled');
			jQuery('#courseCatRelationship').attr('disabled','disabled');
			jQuery('#titleList').attr('disabled','disabled');
		}
		
	}else{
		jQuery('#markComplete').hide();
	}
	
	// show hide of send for college approval button
	jQuery('input[name=collegeApprovalRequired]').change(function(){
		if(jQuery('input[name=collegeApprovalRequired]').attr("checked")){
			jQuery("#sendToIEManager").removeAttr("disabled");
			jQuery("#submitCourse").attr("disabled","disabled");
			jQuery("#submitCourseToNext").attr("disabled","disabled");
			jQuery("input[name='transcriptCredits']").removeClass("required ");
			jQuery("select[name='courseLevelId']").removeClass("required ");
			jQuery("input[name='courseType']").removeClass("required ");
			jQuery("input[name='effectiveDate']").removeClass("required ");
			jQuery("select[name='transferStatus']").removeClass("required ");
		}
		else{
			jQuery("#sendToIEManager").attr("disabled","disabled");
			jQuery("#submitCourse").removeAttr("disabled");
			jQuery("#submitCourseToNext").removeAttr("disabled");
			jQuery("input[name='transcriptCredits']").addClass("required ");
			jQuery("select[name='courseLevelId']").addClass("required ");
			jQuery("input[name='courseType']").addClass("required ");
			jQuery("input[name='effectiveDate']").addClass("required ");
			jQuery("select[name='transferStatus']").addClass("required ");
		}
	});
	
	if('${userRoleName}'=='Institution Evaluation Manager'){
		jQuery("#sendToIEManager").attr("disabled","disabled");		
	}
	
	jQuery( "#schoolTitle" ).autocomplete({
		source: function( request, response ) {
			jQuery.ajax({
			url: "ieManager.html?operation=getInstitutionByCodeAndTitle&searchBy=2&searchText="+request.term,
			dataType: "json",
			data: {
				style: "full",
				maxRows: 5,
				name_startsWith: request.term
			},
			success: function( data ) {
				jQuery("#schoolTitle").removeClass('auto-load');
				response( jQuery.map( data, function( item ) {
					
						return {
							label: item.name ,
							value: item.name,
							code : item.institutionID,
							id : item.id,
							instEvalStatus : item.evaluationStatus,
							institutionTypeId : item.institutionType.id
						}
					
				}));
			},
			error: function(xhr, textStatus, errorThrown){
				jQuery("#schoolTitle").removeClass('auto-load');
			},
		});
	},
	
	minLength: 2,
	 search: function(event, ui) { jQuery(this).addClass("auto-load"); },
	  open: function(event, ui) { jQuery(this).removeClass("auto-load"); },
	  select: function(event, ui) {		  
		 
		  var instEvaluationStatus = ui.item.instEvalStatus;
		  var institutionTypeIdToDectect = ui.item.institutionTypeId;
		  jQuery("#aceExhibitNoId1").css("display",true);
		  if(institutionTypeIdToDectect == '5'){
			  
			  if(jQuery("#aceExhibitNoId1").css("display") == 'none'){
				  jQuery("#aceExhibitNoId1").css("display","block");
				  jQuery("#aceExhibitNoTextId").addClass("required");
				  jQuery('input[name$=transcriptCredits]').removeClass("required");
			  }
			  
		  }else{
			  jQuery("#aceExhibitNoId1").css("display","none");	
			  jQuery("#aceExhibitNoTextId").removeClass("required");
			  jQuery('input[name$=transcriptCredits]').addClass("required");
		  }
		  if(instEvaluationStatus == 'NOT EVALUATED'){
			  jQuery("#institutionCode").text("");
			  jQuery("#institutionId").val("");
			  jQuery("#institutionTypeId").val("");
			  jQuery("#editSubjectId32").css("display","none");
			  jQuery("#submitCourse").attr("disabled", true);
			  jQuery("#submitCourseToNext").attr("disabled", true);
			  jQuery("#evalInstitutionStatus").val(instEvaluationStatus);
			  //alert("You can create courses Only when the Institute is Evaluated.");			 
			  return;
		  }else{
			  jQuery("#institutionCode").text(ui.item.code);
			  jQuery("#institutionId").val(ui.item.id);
			  jQuery("#institutionTypeId").val(ui.item.institutionTypeId);
			  jQuery("#editSubjectId32").css("display",true);
			  jQuery("#submitCourse").attr("disabled", false);
			  jQuery("#submitCourseToNext").attr("disabled", false);
			  jQuery("#evalInstitutionStatus").val(instEvaluationStatus);
		  	  //loadAcceptedGrade(jQuery("#institutionId").val());
		  }
	  }
	});
	evalSemEq("textBox");
	settingMaskInput();
	jQuery("#frmCourseId").validate();
});
});
	function loadCourseTitle(transferCourseIdValue,transferCourseMirrorId,subjectPopup){
    	jQuery("#loaderBoxId").html('<div class="loader mt50"><img src="<c:url value="../images/smallLoader.gif"/>" alt="loading..." /></div>');
		Boxy.load("<c:url value='/evaluation/ieManager.html?operation=loadCourseTitles&transferCourseId='/>"+transferCourseIdValue+"&subjectPopup="+subjectPopup+"&transferCourseMirrorId="+transferCourseMirrorId+"&comingFromIECycle=${comingFromIECycle}",{afterShow: boxyAfterShowCall});
   }

	jQuery("#schoolTitle").live('blur', function(event) {
		  jQuery("#institutionCode").text("");
		  jQuery("#institutionId").val("");
		  jQuery("#institutionTypeId").val("");
		  jQuery("#editSubjectId32").css("display","none");
		  jQuery("#submitCourse").attr("disabled", true);
		  jQuery("#submitCourseToNext").attr("disabled", true);
		  jQuery("#evalInstitutionStatus").val("");
		  jQuery("#accptGradsId").empty();
	if(jQuery("#schoolTitle").val() != null && jQuery("#schoolTitle").val() !=''){ 
		jQuery.ajax({
			url: "<c:url value='/evaluation/ieManager.html?operation=getInstitutionByCodeAndTitle&searchBy=2&searchText='/>"+jQuery("#schoolTitle").val(),	
			dataType: "json", success:function(data){
				//alert("jdlkjsa="+data.length);
				if(data.length != 0){	  
					 var instEvaluationStatus = data[0].evaluationStatus;
					  var institutionTypeIdToDectect = data[0].institutionType.id;
					  jQuery("#aceExhibitNoId1").css("display",true);
					  if(institutionTypeIdToDectect == '5'){
						  
						  if(jQuery("#aceExhibitNoId1").css("display") == 'none'){
							  jQuery("#aceExhibitNoId1").css("display","block");
							  jQuery("#aceExhibitNoTextId").addClass("required");
							  jQuery('input[name$=transcriptCredits]').removeClass("required");
						  }
						  
					  }else{
						  jQuery("#aceExhibitNoId1").css("display","none");	
						  jQuery("#aceExhibitNoTextId").removeClass("required");
						  jQuery('input[name$=transcriptCredits]').addClass("required");
					  }
					  if(instEvaluationStatus == 'NOT EVALUATED'){
						  jQuery("#institutionCode").text("");
						  jQuery("#institutionId").val("");
						  jQuery("#institutionTypeId").val("");
						  jQuery("#editSubjectId32").css("display","none");
						  jQuery("#submitCourse").attr("disabled", true);
						  jQuery("#submitCourseToNext").attr("disabled", true);
						  jQuery("#evalInstitutionStatus").val(instEvaluationStatus);
						  alert("You can create courses Only when the Institute is Evaluated.");			 
						  return;
					  }else{
						  jQuery("#institutionCode").text(data[0].institutionID);
						  jQuery("#institutionId").val(data[0].id);
						  jQuery("#institutionTypeId").val(institutionTypeIdToDectect);
						  jQuery("#editSubjectId32").css("display",true);
						  jQuery("#submitCourse").attr("disabled", false);
						  jQuery("#submitCourseToNext").attr("disabled", false);
						  jQuery("#evalInstitutionStatus").val(instEvaluationStatus);
					  	  loadAcceptedGrade(jQuery("#institutionId").val());
					  }
				}else{
					alert("The Institution "+jQuery("#schoolTitle").val()+" does not exist. Please first create the Institution.");
				} 
			},
			error: function(xhr, textStatus, errorThrown){
				alert("Error Occured");	
			}
		});
	}
	});
	jQuery("#trCourseCodeId").live('blur', function(event) {
		  jQuery("#submitCourse").attr("disabled", true);
		  jQuery("#submitCourseToNext").attr("disabled", true);
		if(jQuery("#trCourseCodeId").val() != null && jQuery("#trCourseCodeId").val() !='' && jQuery("#institutionId").val() != null && jQuery("#institutionId").val() != ''){ 
			jQuery.ajax({
				url: "<c:url value='/evaluation/ieManager.html?operation=getTransferCourseByCodeAndInstitution&courseCode='/>"+jQuery("#trCourseCodeId").val()+"&institutionId="+jQuery("#institutionId").val(),	
				dataType: "json", success:function(data){
					//alert("jdlkjsa="+data.trCourseCode);
					if(data.trCourseCode == undefined){
						 jQuery("#submitCourse").attr("disabled", false);
						 jQuery("#submitCourseToNext").attr("disabled", false);
						 jQuery("#trCourseCodeErrorDisplay").html("");
					}else{
						 jQuery("#trCourseCodeErrorDisplay").html('<p style="color: red;">Already Exist<p>');
						
						 jQuery("#submitCourse").attr("disabled", true);
						 jQuery("#submitCourseToNext").attr("disabled", true);
					}
					
				},
				error: function(xhr, textStatus, errorThrown){
					alert("Error Occured");	
				}
			});
		}
	});
/* function saveCourse(){
	//alert('${role}');
	//alert('${actionCourseLink}');
	document.frmCourse.action="<c:url value='${actionCourseLink}'/>";
	document.frmCourse.submit();
} */
jQuery("#sendToIEManager").click(function(){
	if(!jQuery('input[name=collegeApprovalRequired]').attr("checked")){
		alert("Please first checked the Requires College Approval check box");
		return false;
	}
});
function fillGradeAsscoDetail(){
	if((jQuery("#evalInstitutionStatus").val()=="EVALUATED") || ("${institution.evaluationStatus}".toUpperCase() == "EVALUATED") || 
			("${! empty institution.checkedBy}" && "${institution.checkedBy}" == "${userCurrentId}" && 
			"${institution.checkedStatus}".toUpperCase() == "COMPLETED" ) || ("${! empty institution.confirmedBy}"
			&&  "${institution.confirmedBy}" == "${userCurrentId}"  && "${institution.confirmedStatus}".toUpperCase() == "COMPLETED") || "${userRoleId}" == '6'){
	jQuery('input:checkbox[id^="institutionTranscriptKeyGradeId_"]:checked').each(function(){
		
	 
	   var index = jQuery(this).attr("id").split("_")[1];
	   //jQuery("#institutionTranscriptKeyGradeAsscocId_"+index).val(jQuery(this).attr("assocId"));
	   
	   jQuery("#institutionTranscriptKeyGradeAsscocTransferCourseId_"+index).val(jQuery(this).attr("gradeTrcId"));
	   
	   jQuery("#institutionTranscriptKeyGradeAsscocInstitutionTranscriptKeyGradeId_"+index).val(jQuery(this).attr("transcriptKeyGradeId"));
	   
	   jQuery("#institutionTranscriptKeyGradeAsscocInstitutionId_"+index).val(jQuery(this).attr("gradeInstitutionId"));
	   
	   jQuery("#institutionTranscriptKeyGradeAsscocGradeFromId_"+index).val(jQuery(this).attr("gradeFrom"));
	   
	   jQuery("#institutionTranscriptKeyGradeAsscocGradeToId_"+index).val(jQuery(this).attr("gradeTo"));
	   jQuery("#institutionTranscriptKeyGradeAsscocGradeCreatedById_"+index).val(jQuery(this).attr("createdBy"));
	   jQuery("#institutionTranscriptKeyGradeAsscocGradeCreatedDateId_"+index).val(jQuery(this).attr("createdDate"));
	   jQuery("#institutionTranscriptKeyGradeAsscocGradeModifiedById_"+index).val(jQuery(this).attr("modifiedBy"));
	   jQuery("#institutionTranscriptKeyGradeAsscocGradeModifiedDateId_"+index).val(jQuery(this).attr("modifiedDate"));  
	   
	   
	});
	if(jQuery('input[name=collegeApprovalRequired]').attr("checked")){
		if(confirm("This course will be sent to IE Manager for college approval."+'\n\n\t\t'+"Press Ok if you wish to proceed.")){
				
		}else{
			return false;
		}
	}
	}else{
		alert("Please first Evaluate the Institution. ");
		return false;
	}
	
}
</script>
<script type="text/javascript">
function boxyAfterShowCall()
{ 
	//jQuery(".maskDate").unmask();
	jQuery("#loaderBoxId").html("");
	settingMaskInputForPopup();
	jQuery("#frmCourseTitleId").validate();
 }
function loadCorrespondingPage(urlToLoad){
	window.location = urlToLoad;
}
function loadAcceptedGrade(instId){
	jQuery("#accptGradsId").empty();
	  var endpoint = "<c:url value='/evaluation/ieManager.html?operation=loadInstitutionTranscriptKeyGrade&institutionId='/>"+instId;
	   jQuery.ajax({
		   
		   			type: "POST",
				    async: false,
				    url: endpoint,
				success: function( data ) {
					
					jQuery("#accptGradsId").html(data);
					
				},
				error: function(xhr, textStatus, errorThrown){
					alert("error occured");
				}

		}); 
}
function settingMaskInputForPopup(){
	jQuery(function($){
		$.mask.definitions['d']='[0123]';
		$.mask.definitions['m']='[01]';
		$.mask.definitions['y']='[12]';
		jQuery(".maskEffectiveDate").mask("m9/d9/y999" );
		jQuery(".maskEffectivEndDate").mask("m9/d9/y999" );
	});

	jQuery(".maskEffectiveDate").blur(function() {
		if(jQuery(this).val()!=''){
			if (!isDate(jQuery(this).val())) {
				alert('Invalid date format!');
				jQuery(this).val("");
			}
		}
	});
	jQuery(".maskEffectivEndDate").blur(function() {
		if(jQuery(this).val()!=''){
			if (!isDate(jQuery(this).val())) {
				alert('Invalid date format!');
				jQuery(this).val("");
			}
		}
	});
}
function markCourseToNext(saveAndNextValue){
	//alert(saveAndNextValue);
	jQuery("#saveAndNext").val(saveAndNextValue);	
}
function loadInstitutionCourseLevel(){
	var idOfInstitute = jQuery("#institutionId").val();
	//alert(idOfInstitute);
	if(idOfInstitute == ''){
		alert("Please first select the Institute.");
		return false;
	}else{
		Boxy.load("<c:url value='/evaluation/ieManager.html?operation=loadInstitutionCourseLevel&idOfInstitute='/>"+idOfInstitute,{afterShow: boxyAfterShowCall});
	}
}

</script>
<c:choose>
     	<c:when test="${userRoleName =='Institution Evaluation Manager'}"> 
        	<c:set var="backLink" scope="session" value="/evaluation/ieManager.html?operation=getCoursesForInstitution"/>
 	 	</c:when>
 	 	<c:when test="${userRoleName=='Administrator'}"> 
        	<c:set var="backLink" scope="session" value="/evaluation/admin.html?operation=viewCourseDetails&courseId=${transferCourseId}"/>
 	 	</c:when>
 		<c:otherwise>
 			<c:set var="backLink" scope="session" value="/evaluation/quality.html?operation=ieEvaluate"/>
 	 	</c:otherwise>
</c:choose>
<!-- Tabs -->

<form id="frmCourseId" name="frmCourse" method="post" action="<c:url value='${actionCourseLink}'/>" onsubmit="return fillGradeAsscoDetail();">
<div class="">
  <div class="institute">
  	<div class="">
	   <div class="institutionHeader mb10">
			<a href="javaScript:void(0);" onClick="javaScript:loadCorrespondingPage('<c:url value="${backLink}"/>');" class="mr10"><img src="<c:url value='/images/arow_img.png'/>" width="15" height="13" alt="" />Back To Course(s) List</a>
	   </div>
	    <ul class="pageNav">        
	        <li><a <c:if test="${! empty courseDetailLink}">  onclick="javaScript:loadCorrespondingPage('<c:url value="${courseDetailLink}"/>')"  </c:if>  href="javaScript:void(0);" style="z-index:9;" class="active">Course Details<span class="sucssesIcon"></span></a></li>
	      
	        <li><a <c:if test="${! empty relationLink}"> onclick="javaScript:loadCorrespondingPage('<c:url value="${relationLink}"/>&transferCourseMirrorId=${transferCourseMirrorId}')"  </c:if>   href="javaScript:void(0);" style="z-index:5;" 
	        
	        		<c:if test="${! empty transferCourse && transferCourse.transferStatus eq 'Eligible' }">
		        		
		        	</c:if>
		        	<c:if test="${! empty transferCourse && transferCourse.transferStatus eq 'Not Eligible' }">
		        		class="pageNavDisable"
		        	</c:if>
		        	<c:if test="${empty transferCourse || empty transferCourse.transferStatus}">
		        		class="pageNavDisable"
		        	</c:if>>
		        	Course Relationship
	        <c:choose>
	        	<c:when test="${(fn:length(transferCourse.courseCategoryMappings) gt 0 || fn:length(transferCourse.courseMappings) gt 0) && (currentUserHaveEntryInMirror eq '1' || currentUserHaveEntryInMainDb eq '1')}">
	       		 	<span class="sucssesIcon"></span>
	       		</c:when>
	        	<c:otherwise>
		        	<c:if test="${! empty transferCourse && transferCourse.transferStatus eq 'Eligible' }">
		        		<span class="alrtIcon"></span>
		        	</c:if>
		        	<c:if test="${! empty transferCourse && transferCourse.transferStatus eq 'Not Eligible' }">
		        		<span></span>
		        	</c:if>
		        	<c:if test="${empty transferCourse || empty transferCourse.transferStatus}">
		        		<span></span>
		        	</c:if>
	        	</c:otherwise>
	      </c:choose>
	      	   </a> 
	       </li>
	        <li><a <c:if test="${! empty markCompleteLinkCourse}"> onclick="javaScript:loadCorrespondingPage('<c:url value="${markCompleteLinkCourse}"/>')"  </c:if>  href="javaScript:void(0);" class="last">Summary</a></li> 
        </ul>
    	<div class="infoContnr">
    		<div class="infoTopArow"></div>
    		<c:if test="${not empty validationMSG}"><div class="error">${validationMSG}</div></c:if>
    		
    	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="contentForm">
    	    <tr>
    	      <td width="44%" align="left" valign="top"> 
                 <label class="noti-label w140">Institution Name:<span class="astric">*</span></label>
                 <input id="schoolTitle" name="schoolTitle" 
                 	<c:if test="${not empty transferCourse.id}"> readonly='readonly'
					</c:if> value="${transferCourse.institution.name}" type="text" class="textField w200 required"/> 
				 <br  class="clear"/>
                 <label class="noti-label w140">Institution Id:</label>
                 <label id="institutionCode">${transferCourse.institution.institutionID}&nbsp;</label>
                 <br  class="clear"/>
                 <label class="noti-label w140">TR Course Code:
                 	<c:if test="${empty transferCourse.trCourseCode}"><span class="astric">*</span>
					</c:if> 
				  </label>
                 <input type="text" name="trCourseCode" id="trCourseCodeId" value="${transferCourse.trCourseCode}" class="textField w200 required" <c:if test="${not empty transferCourse.trCourseCode}"> readonly='readonly'</c:if> >
                 <div id="trCourseCodeErrorDisplay"></div>
    			 <br  class="clear"/>
    			 <div id="aceExhibitNoId1">
	    			 <label class="noti-label w140">ACE Exhibit No.:
	                 	<c:if test="${empty transferCourse.aceExhibitNo}"><span class="astric">*</span>
						</c:if> 
					  </label>
	                 <input type="text" name="aceExhibitNo" id="aceExhibitNoTextId" value="${transferCourse.aceExhibitNo}" class="textField w200 required" <c:if test="${not empty transferCourse.aceExhibitNo}"> readonly='readonly'</c:if> >
	                 <br  class="clear"/>
                </div>  
                 <label class="noti-label w140">Course Title:<span class="astric">*</span></label>
                 <input type="text" name="titleList[0].title" class="textField w200 required" value="${transferCourse.trCourseTitle}">
                 <div id="editSubjectId1">
                 <c:if test="${! empty transferCourse.trCourseTitle}">
                 	<a href="javascript:void(0)" class="editTitle" onclick="javascript:loadCourseTitle('${transferCourse.id }','${transferCourseMirrorId }','0');">Edit Title</a><a href="javascript:void(0)" class="editTitle" id="editSubjectId32" onclick="javascript:loadCourseTitle('${transferCourse.id }','${transferCourseMirrorId }','1');">|&nbsp;Edit Subject</a>
                   	
                 </c:if>
                  </div>
                  <div id="loaderBoxId"></div>
                 <br  class="clear"/>
                 <label class="noti-label w140">Transcript Credits:<span class="astric">*</span></label>
                 <input type="text" name="transcriptCredits" value="${transferCourse.transcriptCredits}" class="textField w200 required number" onblur="javaScript:evalSemEq(this);">
                 <br  class="clear"/>
                 <label class="noti-label w140">Semester Credits:</label>
                 <input type="text" id="semesterCredits" name="semesterCredits" value="" readonly="readonly" class="textField w200">
                 <br  class="clear"/>
                 <label class="noti-label w140">Accepted Transfer Grades:</label>
      			<div class="accptGrads" id="accptGradsId">
      				<c:forEach items="${institutionTranscriptKeyGradeList }" var="institutionTranscriptKeyGrade" varStatus="institutionTranscriptKeyGradeIndex">
	      				<label>
	                        
	                        <c:choose>
	                        	  
	                       		 <c:when test="${institutionTranscriptKeyGrade.number }">
	                       		 	
	                       		 	<input type="checkbox" <c:if test="${institutionTranscriptKeyGrade.selected }"> checked="checked" </c:if> 
	                       		 		   assocId="${institutionTranscriptKeyGrade.gradeAssocId }" gradeTrcId="${transferCourse.id}"
	                       		 		   transcriptKeyGradeId="${institutionTranscriptKeyGrade.id }" gradeInstitutionId="${transferCourse.institution.id}"
	                       		 		   gradeFrom="${institutionTranscriptKeyGrade.gradeFrom }"
	                       		 		   gradeTo="${institutionTranscriptKeyGrade.gradeTo }"
	                       		 		   createdBy="${institutionTranscriptKeyGrade.createdBy }"
	                       		 		   modifiedBy="${institutionTranscriptKeyGrade.modifiedBy }"
	                       		 		   createdDate='<fmt:formatDate value="${institutionTranscriptKeyGrade.createdDate}" pattern="MM/dd/yyyy"/>'
	                       		 		   modifiedDate='<fmt:formatDate value="${institutionTranscriptKeyGrade.modifiedDate}" pattern="MM/dd/yyyy"/>'
	                       		 		   name="checkBox_${institutionTranscriptKeyGradeIndex.index }" value="${institutionTranscriptKeyGrade.id }" 
	                       		 		   id="institutionTranscriptKeyGradeId_${institutionTranscriptKeyGradeIndex.index }"/>
	                       		 			${institutionTranscriptKeyGrade.gradeFrom }&nbsp;-&nbsp;${institutionTranscriptKeyGrade.gradeTo }
	                       		 </c:when>
	                       		 <c:otherwise>
	                       		 <input type="checkbox" <c:if test="${institutionTranscriptKeyGrade.selected }"> checked="checked" </c:if> 
	                       		 		assocId="${institutionTranscriptKeyGrade.gradeAssocId }" gradeTrcId="${transferCourse.id}"
	                       		 		transcriptKeyGradeId="${institutionTranscriptKeyGrade.id }" gradeInstitutionId="${transferCourse.institution.id}"
	                       		 		gradeFrom="${institutionTranscriptKeyGrade.gradeAlpha }"
	                       		 		gradeTo=""
	                       		 		createdBy="${institutionTranscriptKeyGrade.createdBy }"
	                       		 		createdDate='<fmt:formatDate value="${institutionTranscriptKeyGrade.createdDate}" pattern="MM/dd/yyyy"/>'
	                       		 		modifiedDate='<fmt:formatDate value="${institutionTranscriptKeyGrade.modifiedDate}" pattern="MM/dd/yyyy"/>'
	                       		 		modifiedBy="${institutionTranscriptKeyGrade.modifiedBy }"
	                       		 		
	                       		 		name="checkBox_${institutionTranscriptKeyGradeIndex.index }"  id="institutionTranscriptKeyGradeId_${institutionTranscriptKeyGradeIndex.index }" />
	                       		 		${institutionTranscriptKeyGrade.gradeAlpha }
	                       		 </c:otherwise>
	                       		 
	                        </c:choose>
	                       
	                    </label>
	                      <c:if test="${institutionTranscriptKeyGradeIndex.index ne 0 && (institutionTranscriptKeyGradeIndex.index%2) ne 0}">
	                        	<div class="clear"></div>
	                      </c:if>
	                      <input type="hidden" name="transferCourseInstitutionTranscriptKeyGradeAssocList[${institutionTranscriptKeyGradeIndex.index }].id" id="institutionTranscriptKeyGradeAsscocId_${institutionTranscriptKeyGradeIndex.index }" value="">
	                      <input type="hidden" name="transferCourseInstitutionTranscriptKeyGradeAssocList[${institutionTranscriptKeyGradeIndex.index }].transferCourse.id" id="institutionTranscriptKeyGradeAsscocTransferCourseId_${institutionTranscriptKeyGradeIndex.index }" value=""> 
	                      <input type="hidden" name="transferCourseInstitutionTranscriptKeyGradeAssocList[${institutionTranscriptKeyGradeIndex.index }].institutionTranscriptKeyGradeId" id="institutionTranscriptKeyGradeAsscocInstitutionTranscriptKeyGradeId_${institutionTranscriptKeyGradeIndex.index }" value="">
	                      <input type="hidden" name="transferCourseInstitutionTranscriptKeyGradeAssocList[${institutionTranscriptKeyGradeIndex.index }].institutionId" id="institutionTranscriptKeyGradeAsscocInstitutionId_${institutionTranscriptKeyGradeIndex.index }" value=""> 
	                      
	                      <input type="hidden" name="transferCourseInstitutionTranscriptKeyGradeAssocList[${institutionTranscriptKeyGradeIndex.index }].gradeFrom" id="institutionTranscriptKeyGradeAsscocGradeFromId_${institutionTranscriptKeyGradeIndex.index }" value="">
	                      <input type="hidden" name="transferCourseInstitutionTranscriptKeyGradeAssocList[${institutionTranscriptKeyGradeIndex.index }].gradeTo" id="institutionTranscriptKeyGradeAsscocGradeToId_${institutionTranscriptKeyGradeIndex.index }" value=""> 	 
	                      <input type="hidden" name="transferCourseInstitutionTranscriptKeyGradeAssocList[${institutionTranscriptKeyGradeIndex.index }].createdBy" id="institutionTranscriptKeyGradeAsscocGradeCreatedById_${institutionTranscriptKeyGradeIndex.index }" value="">
	                      <input type="hidden" name="transferCourseInstitutionTranscriptKeyGradeAssocList[${institutionTranscriptKeyGradeIndex.index }].createdDate" id="institutionTranscriptKeyGradeAsscocGradeCreatedDateId_${institutionTranscriptKeyGradeIndex.index }" value="">
	                      <input type="hidden" name="transferCourseInstitutionTranscriptKeyGradeAssocList[${institutionTranscriptKeyGradeIndex.index }].modifiedBy" id="institutionTranscriptKeyGradeAsscocGradeModifiedById_${institutionTranscriptKeyGradeIndex.index }" value="">
	                      <input type="hidden" name="transferCourseInstitutionTranscriptKeyGradeAssocList[${institutionTranscriptKeyGradeIndex.index }].modifiedDate" id="institutionTranscriptKeyGradeAsscocGradeModifiedDateId_${institutionTranscriptKeyGradeIndex.index }" value="">
	                      			
      				</c:forEach>
                      <!-- <label>
                        <input type="checkbox" name="CheckboxGroup1" value="checkbox" id="CheckboxGroup1_0" />A</label>
                     <label>
                        <input type="checkbox" name="CheckboxGroup1" value="checkbox" id="CheckboxGroup1_1" />B</label>
                       
                      <label>
                        <input type="checkbox" name="CheckboxGroup1" value="checkbox" id="CheckboxGroup1_2" />C</label>
                      <div class="clear"></div>
                      <label>
                      <input type="checkbox" name="CheckboxGroup1" value="checkbox" id="CheckboxGroup1_3" />P</label>
                    
                      <label>
                        <input type="checkbox" name="CheckboxGroup1" value="checkbox" id="CheckboxGroup1_4" />F</label>
                     
                      <label>
                        <input type="checkbox" name="CheckboxGroup1" value="checkbox" id="CheckboxGroup1_5" />AUD</label> -->
                      <br />
                </div>
				<br  class="clear"/>
            </td>
    	      <td width="5%" class="tblBordr">&nbsp;</td>
    	      <td width="45%" align="left" valign="top">
                   
                <label class="noti-label w130">Course Level:<span class="astric">*</span></label>
                    <select class="w210 required valid" name="courseLevelId">
                      <option id="" value="">Select Course Level</option>
                    	<c:forEach items="${gcuCourseLevelList}" var="gcuCourseLevel">
							<option <c:if test="${transferCourse.courseLevelId == gcuCourseLevel.name}"> selected="true" </c:if> value="${gcuCourseLevel.name}">${gcuCourseLevel.name}</option>
						</c:forEach>
                    </select>
                    <a href="javaScript:void(0);" onclick="javaScript:loadInstitutionCourseLevel();">Institution Course Level</a>
                    <br  class="clear"/>
                    <label class="noti-label w130">Clock Hours:</label>
                     <input type="checkbox" id="clockHoursChk" <c:if test="${transferCourse.clockHoursChk eq true}"> checked </c:if> name="clockHoursChk"> &nbsp; &nbsp;&nbsp; 
                    <input type="text" id="clockHours" name="clockHours" value="${transferCourse.clockHours}" class="textField w160"><br  class="clear"/>
                    
                     <label class="noti-label w130">Course Type:<span class="astric">*</span></label>
                    <select id="courseTypeId" class="w210 required valid" name="courseType">
                      	<option id="" value="">Select Course Type</option>
                    	<option value="Lecture">Lecture</option>
                    	<option value="Lab">Lab</option>
                    	<option value="Clinical">Clinical</option>
                    </select>
                    <br  class="clear"/>
               		<label class="noti-label w130">Effective Date:<span class="astric">*</span></label>
               		<input name="effectiveDate" type="text" value='<fmt:formatDate value="${transferCourse.effectiveDate}" pattern="MM/dd/yyyy"/>' class="textField w160 maskDate required" />
                    <br  class="clear"/>
                	<label class="noti-label w130">End Date:</label>
                    <input class="textField w160 maskDate" type="text" value="<fmt:formatDate value="${transferCourse.endDate}" pattern="MM/dd/yyyy"/>" name="endDate">
                    <br  class="clear"/>
                <label class="noti-label w130">Catalog Course Description:</label>
                <label for="textarea"></label>
                <textarea name="catalogCourseDescription" id="catalogCourseDescription" cols="45" rows="5" class="txtaraCCD">${transferCourse.catalogCourseDescription}</textarea>
				<br  class="clear"/>
                <label class="noti-label w130">Transfer Status:<span class="astric">*</span></label>
                     <select class="w210 required valid" name="transferStatus"> 
                     	<option id="" value="">Select Transfer Status</option>                    	
                       	<option <c:if test="${transferCourse.transferStatus eq 'Eligible'}"> selected</c:if> value="Eligible">Eligible</option>
                        <option <c:if test="${transferCourse.transferStatus eq 'Not Eligible'}"> selected</c:if> value="Not Eligible">Not Eligible</option>
                     </select>                     
               <br  class="clear"/>
               <c:if test="${userRoleName eq 'Institution Evaluator'}"> 
					<label class=" noti-label w130"><strong>Requires College Approval:</strong> </label> 
					<input type="checkbox" name="collegeApprovalRequired"  <c:if test="${transferCourse.evaluationStatus eq 'EVALUATED' || transferCourse.collegeApprovalRequired || transferCourse.institution.evaluationStatus eq 'NOT EVALUATED'}">   disabled="disabled" </c:if><c:if test="${transferCourse.collegeApprovalRequired}">  checked</c:if>/>
					<br class="clear" />
			  </c:if>             
		  </td>
		  <c:if test="${not empty transferCourse.id}">
				<input	type="hidden" name="id" value="${transferCourse.id}"> 
			</c:if>
			<input name="createdDate" id="createdDate" type="hidden" value='<fmt:formatDate value="${transferCourse.createdDate}" pattern="MM/dd/yyyy"/>' />
			<input name="createdBy" id="createdBy" type="hidden" value="${transferCourse.createdBy}" /> 
			<input	name="checkedDate" id="checkedDate" type="hidden"	value='<fmt:formatDate value="${transferCourse.checkedDate}" pattern="MM/dd/yyyy"/>' />
			<input name="checkedBy" id="checkedBy" type="hidden" value="${transferCourse.checkedBy}" /> 
			<input name="confirmedBy" id="confirmedBy" type="hidden" value="${transferCourse.confirmedBy}" /> 
			<input name="modifiedBy"	id="modifiedBy" type="hidden" value="${transferCourse.modifiedBy}" />
			<input name="evaluationStatus"	type="hidden" value="${transferCourse.evaluationStatus}" />
			
			<input name="institutionMirrorId" id="institutionMirrorId"	type="hidden" value="${institutionMirror.id}" />
			<input	type="hidden" id="transferCourseMirrorId" name="transferCourseMirrorId"	value="${transferCourseMirrorId}"> 
			<input type="hidden" id="institutionId" name="institutionId" value="${transferCourse.institution.id}">
			<input type="hidden" id="comingFromIECycle" name="comingFromIECycle" value="${comingFromIECycle}">
			<input type="hidden" id="saveAndNext" name="saveAndNext" value="0">
			<input type="hidden" id="evalInstitutionStatus" name="evalInstitutionStatus" value="">
			<input type="hidden" id="institutionTypeId" name="institutionTypeId" value="${transferCourse.institution.institutionType.id}">
			
  	      </tr>
  	    </table>
        <div class="divider3"></div>
        <div class="fr mt10">
        	<c:if test="${userRoleName eq 'Institution Evaluator' && (empty transferCourse.evaluationStatus || fn:toUpperCase(transferCourse.evaluationStatus) eq 'NOT EVALUATED')}">
        		<input type="submit" id="sendToIEManager" value="Send to IE Manager" class="button" <c:if test="${empty transferCourse.id || transferCourse.evaluationStatus eq 'NOT EVALUATED'}"> disabled="disabled" </c:if>/>
	        </c:if>	
		        	<c:choose>
		        		<c:when test='${fn:toUpperCase(transferCourse.evaluationStatus) eq "NOT EVALUATED" && ((! empty transferCourse.checkedBy && transferCourse.checkedBy eq userCurrentId) || (! empty transferCourse.confirmedBy && transferCourse.confirmedBy eq userCurrentId))  && (userRoleName ne "Institution Evaluation Manager" || userRoleName ne "Administrator")}'>
		        			<input type="submit" <c:if test="${transferCourse.collegeApprovalRequired}"> disabled="disabled" </c:if> id="submitCourse" value="Save"	name="submitCourse" class="button" onclick="javaScript:markCourseToNext('0');">
				 	 		<input type="submit" <c:if test="${transferCourse.collegeApprovalRequired}"> disabled="disabled" </c:if> id="submitCourseToNext" name="submitCourseToNext" value="Save & Next"  class="button" onclick="javaScript:markCourseToNext('1');">
		        		</c:when>
		        		<c:when test="${userRoleName eq 'Institution Evaluation Manager' || userRoleName eq 'Administrator'}">
		        			<input type="submit"  id="submitCourse" value="Save" name="submitCourse" class="button" onclick="javaScript:markCourseToNext('0');">
				 	 		<input type="submit" id="submitCourseToNext" name="submitCourseToNext" value="Save & Next"  class="button" onclick="javaScript:markCourseToNext('1');">
		        		</c:when>
		        		<c:when test='${empty transferCourse.evaluationStatus}'>
		        			<input type="submit"  id="submitCourse" value="Save"	name="submitCourse" class="button" onclick="javaScript:markCourseToNext('0');">
				 	 		<input type="submit" id="submitCourseToNext" name="submitCourseToNext" value="Save & Next"  class="button" onclick="javaScript:markCourseToNext('1');">
		        		</c:when>
		        		<c:otherwise>
		        		
		        		</c:otherwise>
		        	</c:choose>
		</div>
        <div class="clear"></div>
        <c:if test="${fn:toUpperCase(transferCourse.evaluationStatus) eq 'EVALUATED' &&  ! empty transferCourse.evaluator1}">
        	<c:if test="${transferCourse.evaluator1.currentRole eq 'IEM' }">
        		<div class="mb10 createdby"><strong>Modified By:</strong> ${transferCourse.evaluator1.firstName } &nbsp;${transferCourse.evaluator1.lastName }</div>
        	</c:if>
        </c:if>
      </div>
        
        
    	</div>
  	</div>
    </div>
</form>
<br class="clear" />

