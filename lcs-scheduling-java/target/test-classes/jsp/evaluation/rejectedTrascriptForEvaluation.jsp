<%@include file="../init.jsp" %>


<link rel="stylesheet" href="<c:url value="/css/schSysStylesheet.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/jquery.ui.all.css"/>" />

<script type="text/javascript" src="<c:url value="/js/evaluationHome.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.core.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.widget.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.position.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.autocomplete.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.maskedinput-1.3.js"/>"></script>

<script type='text/javascript' src="<c:url value="/js/jquery-ui-1.8.23.custom.min.js"/>"></script>
  
  
<title>Evaluate Courses</title>
	
<script>
	var rejectCourseList = new Array();
	var availableTags = [
					<c:forEach items="${courseList}" var="course">
					"${course.trCourseCode}",
					</c:forEach>
							];
	
	
	function autoCompleteCourse(){
		jQuery( ".trCourseId" ).autocomplete({
			//source: availableTags
			source: function( request, response ) {
				jQuery.ajax({
				url: "launchEvaluation.html?operation=getTransferCourseByInstitutionIdAndString&institutionId=${studentInstitutionTranscript.institution.id}&courseCode="+request.term,
				dataType: "json",
				data: {
					style: "full",
					maxRows: 5,
					name_startsWith: request.term
				},
				success: function( data ) {
					jQuery(".trCourseId").removeClass('auto-load');
					response( jQuery.map( data, function( item ) {
						
						return {
							label: item.trCourseCode ,
							value: item.trCourseCode
						}
					}));
				},
				error: function(xhr, textStatus, errorThrown){
					jQuery(".trCourseId").removeClass('auto-load');
				},
				

			});
		},
		select: function(event, ui) {
			valuesChanged(this);
        },
		minLength: 2,
		 search: function(event, ui) { jQuery(this).addClass("auto-load"); },
		  open: function(event, ui) { jQuery(this).removeClass("auto-load"); }
		  
		
		});
	}
		
		
	<fmt:formatDate value="${courseInfo.expectedStartDate}" pattern="MM/dd/yyyy" var="dateValue" />

	<c:set var="queryString" value="studentCrmId=${courseInfo.studentCrmId}&programVersionCode=${courseInfo.programVersionCode}&programDesc=${courseInfo.programDesc}&catalogCode=${courseInfo.catalogCode}&stateCode=${courseInfo.stateCode}&expectedStartDateString=${dateValue}" />
	<c:set var="transcriptQueryString" value="instId=${selectedInstitution.id}&speId=${studentInstitutionTranscript.student.id}" />
		
	function evalSemEq(textBox){
		var currentRow = jQuery(textBox).attr('id').split('_')[1];
		//currentRow = currentRow - 1;
		var semEqValue = jQuery("#trCourseCredits_"+currentRow).val();
		if("${studentInstitutionTranscript.institution.evaluationStatus}".toUpperCase() == "EVALUATED"&&semEqValue != ''){
			if("${institutionTermType.termType.name}"=="Quarter"){
				semEqValue = parseFloat(semEqValue)*2/3;
				jQuery("#trSemCredits_"+currentRow).val(semEqValue.toFixed(2));	
			}
			else if("${institutionTermType.termType.name}"=="4-1-4"){
				semEqValue = parseFloat(semEqValue)*4;
				jQuery("#trSemCredits_"+currentRow).val(semEqValue.toFixed(2));
			}
			else if("${institutionTermType.termType.name}"=="Semester"){
				jQuery("#trSemCredits_"+currentRow).val(semEqValue.toFixed(2));
			}
			else{
				jQuery("#trSemCredits_"+currentRow).val("---");
			}
		}
		else{
			jQuery("#trSemCredits_"+currentRow).val("---");
		}
		
	}
		
	function fillTitle(selected){
		var currentRow = jQuery(selected).attr('id').split('_')[1];
		if(jQuery("#trCourseTitleSelect_"+currentRow).val()!=''){
			jQuery("#trCourseTitle_"+currentRow).val(jQuery("#trCourseTitleSelect_"+currentRow+" option:selected").text());	
		}
		else{
			jQuery("#trCourseTitle_"+currentRow).val("");
		}
		
	}
		
	jQuery(document).ready( function() {
		
	/*	if("${deoComment}"=="true"){
			launchDeoComments();
		}*/
		jQuery('#trCourseId')
		   
		    .ajaxStart(function() {
		        $(this).show();
		        
		    })
		    .ajaxStop(function() {
		      
		        jQuery(".trCourseId").removeClass("auto-load");
		    })
		;
					
/*		if(${studentInstitutionTranscript.evaluationStatus == 'REJECTED INSTITUTION'}){
			jQuery("#addTranscriptBtn").hide();
			jQuery("#transferCourseForm").hide();
			jQuery("#backToTrList").hide();
		}
		if(${studentInstitutionTranscript.evaluationStatus == 'REJECTED'}){
			jQuery("#backToTrList").hide();
		}
		if(${!(studentInstitutionTranscript.evaluationStatus == 'DRAFT'||studentInstitutionTranscript.evaluationStatus == 'REJECTED')}){
			jQuery("#submitTrCourses").attr('disabled',true);
			jQuery('#transferCourseForm :input').attr('disabled',true);
		}
		else{
			jQuery("#submitTrCourses").attr('disabled',false);
		}
*/		
		if(${studentInstitutionTranscript.evaluationStatus == 'REJECTED INSTITUTION'}){
			jQuery("#addTranscriptBtn").hide();
			jQuery("#transferCourseForm").hide();
			jQuery("#backToTrList").hide();
		}
		else if(${studentInstitutionTranscript.evaluationStatus == 'REJECTED'}){
			jQuery("#backToTrList").hide();
			jQuery('#transferCourseForm :input').attr('disabled',false);
			jQuery("#submitTrCourses").attr('disabled',true);
			
		}
		/* else if(${(studentInstitutionTranscript.evaluationStatus == 'DRAFT')}){
			jQuery("#submitTrCourses").attr('disabled',false);
		}
		else{
			jQuery("#submitTrCourses").attr('disabled',true);
			jQuery('#transferCourseForm :input').attr('disabled',true);
		} */
		
			jQuery.mask.definitions['d']='[0123]';
			jQuery.mask.definitions['m']='[01]';
			jQuery.mask.definitions['y']='[12]';
			
		//jQuery("#trCourseCompletionDate_0").mask("m9/d9/y999" );
		//all the trCourseCompletionDate  element  mask input at page load
		jQuery("[id^='trCourseCompletionDate_']").mask("m9/d9/y999" );
		
		//addCourseRow();
		autoCompleteCourse();
		
		initEventHandlerForSave();

		 jQuery(".keyUpTextField").change(function () {
			 var ctr=jQuery(this).attr('id').split("_")[1];
			 jQuery(this).removeClass("errorClass");
			 jQuery('#evalStatus_'+ctr).removeClass("errorClass");
			 jQuery('#trCourseTitle_'+ctr).removeClass("errorClass");
			 jQuery('#trCourseCredits_'+ctr).removeClass("errorClass");
			 jQuery('#trCourseCompletionDate_'+ctr).removeClass("errorClass");
			 jQuery('#trCourseGrade_'+ctr).removeClass("errorClass");
			 
			 
			 jQuery('#transcriptStatus_'+ctr).val("DRAFT");
			 
		});
		 
		jQuery(".errCrctd").change(function(){
			var flag=0;
			jQuery(".errCrctd").each(function(){
				if(!jQuery(this).attr("checked")){
					flag=1;
				}
			});
			if (flag==0){
				jQuery("#submitTrCourses").attr('disabled',false);	
			}
			else{
				jQuery("#submitTrCourses").attr('disabled',true);
			}
		}); 
		/* jQuery('.noti-tbl tr').each(function(){
				var thisRowIsMain = $(this);
				jQuery('td',thisRowIsMain).hover(function(){
					jQuery('.mark-as-read',thisRowIsMain).toggle();	
				});
				jQuery('.mark-as-read',thisRowIsMain).click(function(){
					jQuery(thisRowIsMain).removeClass('noti-mark');
				});
			}); */
		if(${param.evaluator=='true'}){
			jQuery("#backToTrList").hide();
		} 
		
	} );

	function findCourseDetails(ctr, text2){
		//alert('in here ctr='+ctr);
		if( jQuery.trim(text2) == '' || jQuery( "#hasUnsavedValues_" + ctr ).val() == '0' ) {
			return;
		}
		
		jQuery.getJSON("<c:url value="/evaluation/launchEvaluation.html?operation=getCourseDetails"/>&institutionId=${studentInstitutionTranscript.institution.id}&trCourseId="+text2,function (JsonData){
			//alert(JsonData.id);	
			
				if(JsonData.trCourse == null){	
					//alert('in else');
					jQuery('#evalStatus_'+ctr).val('NOT EVALUATED');
					jQuery('#trCourseTitle_'+ctr).attr("readonly", false); 
					jQuery('#trCourseTitle_'+ctr).val('');
					jQuery('#trCourseCredits_'+ctr).val('');
					//jQuery('#trCourseTitle_'+ctr).focus();
				}
				else {
					//alert("------ "+JsonData.trCourse.titleList[0].title);					
					//jQuery('#trCourseTitle_'+ctr).val(JsonData.trCourse.trCourseTitle);
					var inRange = false;
					var x=0,i;
					var appendtxt = '';
					var courseCompletionDate = jQuery('#trCourseCompletionDate_'+ctr).val();
					if(JsonData.titleList != null){
						for(i=0;i<JsonData.titleList.length;i++){
							
							if((JsonData.titleList[i].evaluationStatus).toUpperCase() == 'EVALUATED'){
								var txt = ""+JsonData.titleList[i].title;
								appendtxt = appendtxt+"<option value="+txt+">"+txt+"</option>";	
							}
							var efdt = formatDt(new Date(JsonData.titleList[i].effectiveDate));
							var endt = formatDt(new Date(JsonData.titleList[i].endDate));
							//alert("effectiveDate ----  ");
						
							
							//check if the course completion date falls in range
							if((cmpDate(courseCompletionDate, efdt)<0)&&(cmpDate(courseCompletionDate, endt)>0)){
								jQuery('#trCourseTitle_'+ctr).val(JsonData.titleList[i].title);
								if( (JsonData.trCourse.evaluationStatus).toUpperCase() == 'EVALUATED' ) {
									jQuery('#trCourseTitle_'+ctr).attr("readonly", true);
									jQuery('#evalStatus_'+ctr).val('EVALUATED');
								}
								else {
									jQuery('#trCourseTitle_'+ctr).attr("readonly", false);
									jQuery('#evalStatus_'+ctr).val(JsonData.trCourse.evaluationStatus);
								}
								inRange = true;
							}
						}
					}
					if(!inRange){
						if(JsonData.titleList != null && JsonData.titleList.length == 1){
							//autofill the only value
							jQuery('#trCourseTitle_'+ctr).val(JsonData.titleList[0].title);
						}
						else{
							// enable deo to select titles
							jQuery("#trCourseTitleSelect_"+ctr).html("");
							jQuery("#trCourseTitleSelect_"+ctr).append('<option value="">Select the Title</option>'+appendtxt);
							jQuery("#trCourseTitleSelect_"+ctr).append(appendtxt);
							jQuery("#trCourseTitleSelect_"+ctr).removeAttr("disabled");
						}
						jQuery('#evalStatus_'+ctr).val('NOT EVALUATED');
					}
					
					jQuery('#trCourseCredits_'+ctr).val(JsonData.trCourse.semesterCredits);
					
					
					
					//filling the equivalent semester credits
					var semEqValue = jQuery("#trCourseCredits_"+ctr).val();
					if("${studentInstitutionTranscript.institution.evaluationStatus}".toUpperCase() == "EVALUATED"&& semEqValue !=''){
						if("${institutionTermType.termType.name}"=="Quarter"){
							semEqValue = parseFloat(semEqValue)*2/3;
							jQuery("#trSemCredits_"+ctr).val(semEqValue);	
						}
						else if("${institutionTermType.termType.name}"=="4-1-4"){
							semEqValue = parseFloat(semEqValue)*4;
							jQuery("#trSemCredits_"+ctr).val(semEqValue);
						}
						else{
							jQuery("#trSemCredits_"+ctr).val(semEqValue);
						}					
					}
					else{
						jQuery("#trSemCredits_"+ctr).val("---");
					}
					
					//jQuery('#trCourseGrade_'+ctr).focus();		
				}
			
		});
	}

		
</script>

<script type="text/javascript">
jQuery(function(){

	jQuery(".add").click(function() {
	jQuery(".transcript").show();
	jQuery(".institute").hide();
	});

	//hover states on the static widgets
	jQuery('#dialog_link, ul#icons li').hover(
		function() { jQuery(this).addClass('ui-state-hover'); },
		function() { jQuery(this).removeClass('ui-state-hover'); }
	);
	//removeInstitutionDegreeDetails();
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
</script>

<script type="text/javascript">
jQuery(document).ready(function() {
	var i = 2;
	var tabTxt1 = "";
	var tabIndexCount = -1;
	<c:forEach items="${sitRejectedList}" var="studentInstitutionTranscript" varStatus="summaryIndex">
	 <c:if test="${fn:length(studentInstitutionTranscript.studentTranscriptCourse) gt 0}">
	 	tabIndexCount = tabIndexCount + 1;
		<c:if test="${studentInstitutionTranscript.official eq true}">
			tabTxt1 = "Official - <fmt:formatDate value="${studentInstitutionTranscript.createdDate}" pattern="MM/dd/yyyy"/>";
			tabIndex = i + tabIndexCount;
		</c:if>	
		<c:if test="${studentInstitutionTranscript.official eq false}">
			tabTxt1 = "Un-Official - <fmt:formatDate value="${studentInstitutionTranscript.createdDate}" pattern="MM/dd/yyyy"/>";
	   </c:if>	
		tabIndex = i + tabIndexCount;
	jQuery("#MarkComplete").click(function() {
	 //jQuery('<li><a href="javascript:void(0)" id="tablink_'+tabIndex+'"><span>'+tabTxt1+'</span></a></li>').appendTo("#addTopNav");
	  jQuery("#addDyndivs").append(jQuery("#inrContBox_2").clone().attr('id','inrContBox_'+tabIndex));
	  jQuery("a[id^='tablink_']").each(
		function() {
			jQuery("#"+this.id).click(
				function() {
					tabClicked(this.id);
				}
			);
		}
	);
	});
	
	</c:if>
</c:forEach>

	jQuery("a[id^='tablink_']").each(
		function() {
			jQuery("#"+this.id).click(
				function() {
					tabClicked(this.id);
				}
			);
		}
	);
	
});
function tabClicked(linkId) {
	var idArray = linkId.split("_");
	var idClicked = idArray[1];
	jQuery("div[id^='inrContBox_']").each(
		function() {
			if(this.id == "inrContBox_"+idClicked) {
				jQuery("#"+this.id).show();
			} else {
				jQuery("#"+this.id).hide();
			}
		}
	);
	
	jQuery("a[id^='tablink_']").each(
		function() {
			if(this.id == "tablink_"+idClicked) {
				jQuery("#"+this.id).addClass("on");
			} else {
				jQuery("#"+this.id).removeClass("on");
			}
		}
	);
}


//Validate the Transfer Course form
function validateTransferCourses(courseIndex) {

	

	//var getvalidateIndexNoForCourse = jQuery("#transferCourseTbl tr:last" ).attr("id").split("_");
	//var courseIndex = parseInt(getvalidateIndexNoForCourse[1]);

	var errorFound = false;
	var dateExceed = false;
	errorString = ''; 

	
		var courseId = jQuery.trim( jQuery("#trCourseId_"+courseIndex).val() );
		var courseTitle = jQuery.trim( jQuery("#trCourseTitle_"+courseIndex).val() );
		var courseGrade = jQuery.trim( jQuery("#trCourseGrade_"+courseIndex).val() );
		var courseCredit = jQuery.trim( jQuery("#trCourseCredits_"+courseIndex).val() );
		var completionDate = jQuery.trim( jQuery("#trCourseCompletionDate_"+courseIndex).val() );
		
		// latest degree completion date
		var maxDegCompletionDate = jQuery(".dgCompletionDate").first().val();
		//alert("maxDegCompletionDate="+maxDegCompletionDate);
		//alert(maxDegCompletionDate != '');
		if(maxDegCompletionDate != ''){
			jQuery(".dgCompletionDate").each(function(){
				//alert("dgCompletionDate");
					if(jQuery(this).val()!='' && cmpDate(maxDegCompletionDate,jQuery(this).val())>0){
						maxDegCompletionDate = jQuery(this).val();
					}
			});
		}
		var errorInCurrentRow = false;
		var errorStringForCourse = "";
		
		if( completionDate == '' ||(maxDegCompletionDate!='' && completionDate!='' && cmpDate(completionDate, maxDegCompletionDate)<0)) {
			if(completionDate == ''){
				errorFound = true;
				errorInCurrentRow = true;
				errorStringForCourse = errorStringForCourse + "Completion Date" + '\t\t';
			}
			else if(cmpDate(completionDate, maxDegCompletionDate)<0){
				dateExceed = true;
			}
			jQuery( "#trCourseCompletionDate_"+courseIndex ).addClass( "redBorder" );
		}

		if( courseId == '' ) {
			errorFound = true;
			errorInCurrentRow = true;
			jQuery( "#trCourseId_"+courseIndex ).addClass( "redBorder" );
			errorStringForCourse = errorStringForCourse + "TR Course ID" + '\t';
		}
		if( courseTitle == '' ) {
			errorFound = true;
			errorInCurrentRow = true;
			jQuery( "#trCourseTitle_"+courseIndex ).addClass( "redBorder" );
			errorStringForCourse = errorStringForCourse + "TR Course Title" + '\t';
		}
		if( courseGrade == '' ) {
			errorFound = true;
			errorInCurrentRow = true;
			jQuery( "#trCourseGrade_"+courseIndex ).addClass( "redBorder" );
			errorStringForCourse = errorStringForCourse + "Grade" + '\t';
		}

		if ( courseCredit == '' || parseFloat(courseCredit) == '0.0' ) {
			errorFound = true;
			errorInCurrentRow = true;
			jQuery( "#trCourseCredits_"+courseIndex ).addClass( "redBorder" );
			errorStringForCourse = errorStringForCourse + "Credits(Non zero)" + '\t';
		}
		
		if(errorInCurrentRow){
			errorString = errorString + "row #"+ (courseIndex+1) + '\t' + errorStringForCourse + '\n';
		}
	

	//document.transferCourseForm.coursesAdded.value=jQuery("#transferCourseTbl").attr('rows').length-1;
	if(${(studentInstitutionTranscript.evaluationStatus == 'REJECTED INSTITUTION'||studentInstitutionTranscript.evaluationStatus == 'REJECTED')}){
		var valueRejected= verifyRejected();
		if(valueRejected==false){
			return false;
		}
	}
	
	if( errorFound == true ) {
		return false;
	}
	else if(dateExceed==true){
		var r2 = false;
		var r1 =  confirm("Course completion date is greater than the degree completion date."+'\n\n\n\t\t\t\t'+"Press 'OK' if you wish to continue");
		if(r1 == true){
			r2 = confirm("Once the transcript is completed no further editing will be allowed."+'\n\n\n\t\t\t\t'+"Press 'OK' if you wish to continue");
			return r2;
		}
		else{
			return r1;
		}
	}
	
	//return confirm("Once the transcript is completed no further editing will be allowed."+'\n\n\n\t\t\t\t'+"Press 'OK' if you wish to continue");
}

function addCourseRow1() {
	
			//var noOfRows = jQuery("#transferCourseTbl").attr('rows').length;
		var courseRowId ="";
		var index = "";
		var pd1 = "";
		courseRowId = jQuery("#transferCourseTbl tr:last").attr("id");
		if(courseRowId == undefined){
			index = 0;
		}else{
			courseRowId = jQuery("#transferCourseTbl tr:last").attr("id").split("_");
			index = parseInt(courseRowId[1]) + 1;
		}
		
		//index = noOfRows - 1;
		if( index == -1 ) {
			index = 0;
			
		}
		var getvalidateIndexNoForCourse = jQuery("#transferCourseTbl tr:last" ).attr("id").split("_");
		var courseIndex = parseInt(getvalidateIndexNoForCourse[1]);

		if(courseRowId != undefined && validateTransferCourses(courseIndex) == false) {
				if(errorString != ''){
					alert("following information is required :"+'\n\n'+errorString);
				}else{
					jQuery(":input").removeClass( "redBorder" );
				}
				return;
		}else{
				jQuery(":input").removeClass( "redBorder" );
		}
		if(index > 0){
				 pd1 = jQuery("#trCourseCompletionDate_"+(index-1)).val();					
		}
		
			var appendText = "<tr id='courseRow_"+index+"'>"+
						    "<td>"+
						    	"<span class='dateReceived'>"+
						      		"<input type='text' name='studentTranscriptCourse["+index+"].completionDate' id='trCourseCompletionDate_"+index+"' value='"+pd1+"' class='textField w70 maskDate required' />"+
						    	"</span>"+
						    "</td>"+
						    "<td>"+
						    	"<input type='hidden' name='hasUnsavedValues_"+index+"' id='hasUnsavedValues_"+index+"' value='1' />"+
						    	"<input type='text' name='studentTranscriptCourse["+index+"].trCourseId' id='trCourseId_"+index+"' class='textField w70 required' onchange='valuesChanged(this);'/>"+
						    "</td>"+
						    "<td>"+
								"<input type='text' name='studentTranscriptCourse["+index+"].transferCourseTitle.title' id='trCourseTitle_"+index+"' class='textField w110 mr10 required' />"+ 
						    	"<select class='titleselect' name='trCourseTitleSelect_"+index+"' id='trCourseTitleSelect_"+index+"' onchange='fillTitle(this);'>"+			    	
						      		"<option>Select Title</option>"+
						    	"</select>"+
						    "</td>"+
						    "<td align='left'>"+
							    "<select name='studentTranscriptCourse["+index+"].grade' id='trCourseGrade_"+index+"' class='w50px required valid' onchange='valuesChanged(this);'>"+
				            		"<option value=''>TR Grade</option>"+ 
				            		"<option value='A'>A</option>"+ 
				            		"<option value='A-'>A-</option>"+ 
				            		"<option value='B'>B</option>"+
				            		"<option value='B+'>B+</option>"+
				            		"<option value='B-'>B-</option>"+ 
				            		"<option value='C'>C</option>"+ 
				            		"<option value='C+'>C+</option>"+ 
				            		"<option value='C-'>C-</option>"+
				            		"<option value='CR'>CR</option>"+
				            		"<option value='D'>D</option>"+
				            		"<option value='D+'>D+</option>"+
				            		"<option value='D-'>D-</option>"+
				            		"<option value='F'>F</option>"+
				            		"<option value='I'>I</option>"+ 
				            		"<option value='IP'>IP</option>"+
				            		"<option value='S'>S</option>"+
				            		"<option value='TR'>TR</option>"+
				            		"<option value='U'>U</option>"+
				            		"<option value='W'>W</option>"+
				            		"<option value='WF'>WF</option>"+				
				                "</select>"+
						    "</td>"+
						    "<td align='center'><input type='text' name='studentTranscriptCourse["+index+"].transferCourse.transcriptCredits' id='trCourseCredits_"+index+"' onchange='evalSemEq(this);' class='textField w30 required' /></td>"+
						    "<td align='center'><input type='text' name='studentTranscriptCourse["+index+"].transferCourse.semesterCredits' id='trSemCredits_"+index+"' readonly='readonly' class='textField w30 required' /></td>"+
						    "<td></td>"+
						    "<td></td>"+
						    "<td></td>"+
						    "<td><a href='javaScript:void(0);' id='removeRow_"+index+"' class='removeIcon fr removeRow'></a></td>"+
					   "</tr>";
			
            // for the case of rejected transcript extra td should be added under checkbox header
			 if("${studentInstitutionTranscript.evaluationStatus}" == "REJECTED"){
				appendText = 
					"<tr id='courseRow_"+index+"'>"+
				    "<td>"+
				    	"<span class='dateReceived'>"+
				      		"<input type='text' name='studentTranscriptCourse["+index+"].completionDate' id='trCourseCompletionDate_"+index+"' value='"+pd1+"' class='textField w70 maskDate required' />"+
				    	"</span>"+
				    "</td>"+
				    "<td>"+
				    	"<input type='hidden' name='hasUnsavedValues_"+index+"' id='hasUnsavedValues_"+index+"' value='1' />"+
				    	"<input type='text' name='studentTranscriptCourse["+index+"].trCourseId' id='trCourseId_"+index+"' class='textField w70 required' onchange='valuesChanged(this);'/>"+
				    "</td>"+
				    "<td>"+
						"<input type='text' name='studentTranscriptCourse["+index+"].transferCourseTitle.title' id='trCourseTitle_"+index+"' class='textField w110 mr10 required' />"+ 
				    	"<select class='titleselect' name='trCourseTitleSelect_"+index+"' id='trCourseTitleSelect_"+index+"' onchange='fillTitle(this);'>"+			    	
				      		"<option>Select Title</option>"+
				    	"</select>"+
				    "</td>"+
				    "<td align='left'>"+
					    "<select name='studentTranscriptCourse["+index+"].grade' id='trCourseGrade_"+index+"' class='w50px required valid' onchange='valuesChanged(this);'>"+
		            		"<option value=''>TR Grade</option>"+ 
		            		"<option value='A'>A</option>"+ 
		            		"<option value='A-'>A-</option>"+ 
		            		"<option value='B'>B</option>"+
		            		"<option value='B+'>B+</option>"+
		            		"<option value='B-'>B-</option>"+ 
		            		"<option value='C'>C</option>"+ 
		            		"<option value='C+'>C+</option>"+ 
		            		"<option value='C-'>C-</option>"+
		            		"<option value='CR'>CR</option>"+
		            		"<option value='D'>D</option>"+
		            		"<option value='D+'>D+</option>"+
		            		"<option value='D-'>D-</option>"+
		            		"<option value='F'>F</option>"+
		            		"<option value='I'>I</option>"+ 
		            		"<option value='IP'>IP</option>"+
		            		"<option value='S'>S</option>"+
		            		"<option value='TR'>TR</option>"+
		            		"<option value='U'>U</option>"+
		            		"<option value='W'>W</option>"+
		            		"<option value='WF'>WF</option>"+				
		                "</select>"+
				    "</td>"+
				    "<td align='center'><input type='text' name='studentTranscriptCourse["+index+"].transferCourse.transcriptCredits' id='trCourseCredits_"+index+"' onchange='evalSemEq(this);' class='textField w30 required' /></td>"+
				    "<td align='center'><input type='text' name='studentTranscriptCourse["+index+"].transferCourse.semesterCredits' id='trSemCredits_"+index+"' class='textField w30 required' readonly='readonly' /></td>"+
				    "<td></td>"+
				    "<td></td>"+
				    "<td></td>"+
				    "<td></td>"+
				    "<td><a href='javaScript:void(0);' id='removeRow_"+index+"' class='removeIcon fr removeRow'></a></td>"+
			   "</tr>";
				
			} 
			//jQuery("#removeRowTd_"+(index-1)).html( "" );
			
            jQuery("#transferCourseTbl tr:last").after(appendText);
        
			//settingMaskInput();
			autoCompleteCourse();	
}
function submitTranscript(actionUrl,divIdToRefer,formId,buttonId){
    var completionDate = jQuery.trim( jQuery("[id^=trCourseCompletionDate_]").first().val() );
    // latest degree completion date
    var maxDegCompletionDate = jQuery(".dgCompletionDate").first().val();
    if(maxDegCompletionDate != ''){
          jQuery(".dgCompletionDate").each(function(){
                      if(jQuery(this).val()!='' && cmpDate(maxDegCompletionDate,jQuery(this).val())>0){
                            maxDegCompletionDate = jQuery(this).val();
                      }
          });
    }
    
    
    var courseId=jQuery(jQuery("[id^=trCourseCompletionDate_]").first()).attr('id');
    if(completionDate != ''){
          jQuery("[id^=trCourseCompletionDate_]").each(function(){
                      if((jQuery(this).val()!='' && completionDate!='') && cmpDate(completionDate,jQuery(this).val())>0){
                            completionDate = jQuery(this).val();
                            courseId=jQuery(this).attr('id');
                      }
          });
    }
    
      var isDuplicate=false;
      var isDuplicateDifDate=false;
      var errorGot=true;
      var courseCode="";
      var courseDate="";
      jQuery('input[id^="trCourseId_"]').each(function() {
		 	var $current =jQuery(this);
		 	 var currentIdIndex=	$current.attr('id').split('_')[1];
    	    jQuery('input[id^="trCourseId_"]').each(function() {
	    	   
	    	    var thisIdIndex=jQuery(this).attr('id').split('_')[1];
	    	  //  alert(jQuery(this).attr('id')+"=="+thisIdIndex +"----"+$current.attr('id')+"=="+currentIdIndex);
	    	    var thisDate=jQuery("#trCourseCompletionDate_"+thisIdIndex).val();
	    	    var currentDate=jQuery("#trCourseCompletionDate_"+currentIdIndex).val();
    	        if (jQuery(this).val().toUpperCase() == $current.val().toUpperCase() && jQuery(this).attr('id') != $current.attr('id') && thisDate==currentDate)
    	        {
    	            //alert('duplicate found!');
    	            $current.addClass( "redBorder" );
    	            courseCode=jQuery(this).val().toUpperCase();
    	            courseDate=thisDate;
    	            isDuplicate=true;
    	            return 1 ;
    	        }else if(jQuery(this).val().toUpperCase() == $current.val().toUpperCase() && jQuery(this).attr('id') != $current.attr('id') && thisDate!=currentDate){
    	        	$current.addClass( "redBorder" );
     	            courseCode=jQuery(this).val().toUpperCase();
     	           isDuplicateDifDate=true;
     	            return 1 ;
    	        }

    	    });
    	    
    	    
    	    if(validateTransferCourses(currentIdIndex)==false){
    	    	errorGot=false;
    	    	return 1;
    	    }
    	    	  
    	    
    	  });
      
      if(isDuplicate){
    	  alert("Course "+courseCode+" with date completed "+courseCode+" already exists on this student's transcript. Please modify the course completion date if the student completed the course more than once.");
      	  return 0;
      }
      if(isDuplicateDifDate){
    	  var r1 =    confirm("Course "+courseCode+" already exists on the student's transcript, please verify that it should be added more than once");
    	  if (!r1)
      	  	return 0;
      }
      if(errorGot==false)
    	  return ;
      
     jQuery("[id^=trCourseCompletionDate_]").removeClass( "redBorder" );
    if(completionDate!='' && maxDegCompletionDate!='' && cmpDate(completionDate, maxDegCompletionDate)<0){
                jQuery("#"+courseId).addClass( "redBorder" );
                var r1 =  confirm("Course completion date is greater than the degree completion date."+'\n\n\n\t\t\t\t'+"Press 'OK' if you wish to continue");
                if(r1 == true){
                      document.transferCourseForm.action = actionUrl;
                      document.transferCourseForm.submit();
                }else{
                      return 0;
                }
    } 
	
	
	var found = checkForRejectedCoursesRectification(formId);
	if(found == false){
		var rj =  confirm("Please make sure you have rectified all the Rejected Courses ."+'\n\n\n\t\t\t\t'+"Press 'OK' if you are sure that you have rectified.");
		if(rj == false){			
			return 0;
		}else{
			jQuery("#"+formId).submit();
		}
	}else{
		alert("Please select all check boxes indicating that corrections have been made to the rejected courses.");
	} 
    

}
function assignDefaultVal(field){
	if(jQuery(field).val() == ''){
		jQuery(field).val("0.0");
	}
	
}
function markedOfficialUnOffcial(){
	alert(jQuery(this).val());
}
function checkForRejectedCoursesRectification(formId){
	var found = false;
	jQuery('#'+formId+' input:checkbox').each(function() {
		innerloop:
		//alert("jQuery(this)="+jQuery(this).attr("id"));
		if (!jQuery(this).is(':checked')) {
			found = true;
			//alert("Please select all the check boxes, if you are sure you have rectified all the courses");
			break innerloop;
    	}
	}); 
	return found;
}
</script>
<div class="deo2">
  <div style="border:1px solid #e7e7e7; border-top:none;" class="institute">
  	<div class="noti-tools2">
  	  <div class="clear"></div>
    <div class="institutionHeader mb-8">
      <a id="backToTrList" href="launchEvaluation.html?operation=launchEvaluationHome&programVersionCode=${courseInfo.programVersionCode}&studentCrmId=${courseInfo.studentCrmId}" class="mr10"><img src="../images/arow_img.png" width="15" height="13" alt="" />Back to Transcript List</a></div>
      <div class="clear"></div>
      <div class="deo">
	<div class="deoInfo">
		<form name="leadInformationForm">
	        <h1 class="expand">FirstName LastName</h1>
	    	
	        <div class="deoExpandDetails collapse" style="display:block;"> 
	            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="contentForm">
	              <tr>
	                <td width="46%">
		                <label class="noti-label w130">Student No.:</label>
		                <label class="noti-label2">--</label>
	                </td>
	                <td width="2%" valign="top" class="brdLeft">&nbsp;</td>
	                <td width="52%" valign="top">
	                	<label class="noti-label w130">Program Name:</label>
	               		<label class="noti-label2">${courseInfo.programDesc}</label>
	               	</td>
	              </tr>
	              <tr>
	                <td>
		                <label class="noti-label w130">Lead CRM ID:</label>
		                <label class="noti-label2">${courseInfo.studentCrmId}</label>
	                </td>
	                <td valign="top" class="brdLeft">&nbsp;</td>
	                <td valign="top">
		                <label class="noti-label w130">PV Code:</label>
		                <label class="noti-label2">${courseInfo.programVersionCode}</label>
	                </td>
	              </tr>
	              <tr>
	                <td>
			             <label class="noti-label w130"> State Code:</label>
			             <label class="noti-label2">${courseInfo.stateCode}</label>
	                </td>
	                <td valign="top" class="brdLeft">&nbsp;</td>
	                <td valign="top"><label class="noti-label w130">Expected Start Date:</label>
	                <label class="noti-label2"><fmt:formatDate value="${courseInfo.expectedStartDate}" pattern="MM/dd/yyyy"/></label></td>
	              </tr>
	              <tr>
	                <td>&nbsp;</td>
	                <td valign="top" class="brdLeft">&nbsp;</td>
	                <td valign="top"><label class="noti-label w130">Catalog Code:</label>
	                <label class="noti-label2">${courseInfo.catalogCode}</label></td>
	              </tr>
	            </table>
	        </div>
	       
	     </form>
  </div>
	 <div class="deoInfo">
        <h1 class="expand"><div class="fl">Transfer Institution: <span class="FntNormal">${selectedInstitution.name}</span></div>
        
        <div class="Inprgss FntNormal">${selectedInstitution.evaluationStatus }</div>
        <div class="trnId">ID: <span class="FntNormal">${selectedInstitution.institutionID}</span></div>
        
        <div class="clear"></div>
        </h1>
    	
        <div class="deoExpandDetails collapse" style="display:block;">
         <table width="100%" border="0" cellspacing="0" cellpadding="0" class="contentForm">
              <tr>
                <td width="46%" valign="top"><label class="noti-label w130">School Code:</label>
                <label class="noti-label2">${selectedInstitution.schoolcode}</label></td>
                <td width="2%" valign="top" class="brdLeft">&nbsp;</td>
                <td width="52%" valign="top"><label class="noti-label w130">Address:</label>
                <label class="noti-label2 wrapText1">
	                <c:if test="${!empty selectedInstitution.institutionAddress }">
	               		 ${selectedInstitution.institutionAddress.address1} &nbsp;&nbsp;
	               		 ${selectedInstitution.institutionAddress.address2} &nbsp;&nbsp;
	               		 <c:if test="${!empty selectedInstitution.institutionAddress.city}">&nbsp;${selectedInstitution.institutionAddress.city}</c:if>
	               		 <c:if test="${!empty selectedInstitution.institutionAddress.state}">&nbsp;${selectedInstitution.institutionAddress.state}</c:if>
	               		 <c:if test="${!empty selectedInstitution.institutionAddress.zipcode}">&nbsp;${selectedInstitution.institutionAddress.zipcode}</c:if>
	               		 <c:if test="${!empty selectedInstitution.institutionAddress.country.name}">&nbsp;${selectedInstitution.institutionAddress.country.name}</c:if>
	                 	<c:if test="${!empty selectedInstitution.institutionAddress.phone1}">Phone: &nbsp;${selectedInstitution.institutionAddress.phone1}</c:if>
	                 	<c:if test="${!empty selectedInstitution.institutionAddress.phone2}">,${selectedInstitution.institutionAddress.phone2}</c:if>
	                  	<br />
	               		<c:if test="${!empty selectedInstitution.institutionAddress.email1}"> Email Id 1: &nbsp; ${selectedInstitution.institutionAddress.email1}</c:if>
	               		<c:if test="${!empty selectedInstitution.institutionAddress.email2}">,${selectedInstitution.institutionAddress.email2}</c:if>
	              </c:if>  
               </label></td>
              </tr>
              <tr>
                <td valign="top"><label class="noti-label w130">Location Type:</label>
                <label class="noti-label2">Primary</label></td>
                <td valign="top" class="brdLeft">&nbsp;</td>
                <td valign="top">&nbsp;</td>
              </tr>
            </table>
		<%-- <table width="100%" border="0" cellspacing="0" cellpadding="0" class="contentForm">
              <tr>
                <td width="50%">
                    <label class="noti-label w130">School Code:</label>
                    <label class="noti-label w130">${selectedInstitution.schoolcode}</label>
                    
                </td>
                <td width="50%">
                    <label class="noti-label w130">Location Type:</label>
                    <label class="noti-label w130">${selectedInstitution.locationId}</label>
                    
                </td>
             </tr>
              <tr>
                <td width="50%">
                    <label class="noti-label w130">Institution Address:</label>
                    <label class="noti-label w130">${selectedInstitution.address}</label>
                    
                </td>
                <td width="50%">
                    <label class="noti-label w130">Accrediting Body:</label>
                    <label class="noti-label w130"></label>
                    
                </td>
             </tr>
              <tr>
                <td width="50%">
                    <label class="noti-label w130">City:</label>
                    <label class="noti-label w130">${selectedInstitution.city}</label>
                    
                </td>
                <td width="50%">
                    <label class="noti-label w130">Term Type:</label>
                    <label class="noti-label w130">${institutionTermType.termType.name}</label>
                    
                </td>
             </tr>
              <tr>
                <td width="50%">
                    <label class="noti-label w130">State:</label>
                    <label class="noti-label w130">${selectedInstitution.state}</label>
                    
                </td>
                <td width="50%">
                    <label class="noti-label w130">Parent Institute:</label>
                    <label class="noti-label w130">${selectedInstitution.parentInstitutionId}</label>
                    
                </td>
             </tr>
              <tr>
                <td width="50%">
                    <label class="noti-label w130">Zip Code:</label>
                    <label class="noti-label w130">${selectedInstitution.zipcode}</label>
                    
                </td>
                <td width="50%">
                    
                    
                </td>
             </tr>
              <tr>
                <td width="50%">
                    <label class="noti-label w130">Phone:</label>
                    <label class="noti-label w130">${selectedInstitution.phone}</label>
                    
                </td>
                <td width="50%">
                   
                    
                </td>
             </tr>
              <tr>
                <td width="50%">
                    <label class="noti-label w130">Fax:</label>
                    <label class="noti-label w130">${selectedInstitution.fax}</label>
                    
                </td>
                <td width="50%">
                  
                    
                </td>
             </tr>
              <tr>
                <td width="50%">
                    <label class="noti-label w130">Country:</label>
                    <label class="noti-label w130">${selectedInstitution.country.name}</label>
                    
                </td>
                <td width="50%">
                   
                    
                </td>
             </tr>
              <tr>
                <td width="50%">
                    <label class="noti-label w130">Website:</label>
                    <label class="noti-label w210">${selectedInstitution.website}</label>
                    
                </td>
                <td width="50%">
                   
                    
                </td>
             </tr> 
         </table>    --%>
    </div>
  </div>  
    <ul id="addTopNav" class="floatLeft top-nav-tab ml20">
   	  <c:set var="upperTabIndexToAppend" value="0"/>
           <c:forEach items="${sitRejectedList }" var="studentInstitutionTranscript" varStatus="transcriptIndex">
           		<c:if test="${fn:length(studentInstitutionTranscript.studentTranscriptCourse) gt 0}">
	           		<c:set var="upperTabIndexToAppend" value="${upperTabIndexToAppend + 1}"/>
	        		<c:if test="${studentInstitutionTranscript.official eq true }">
	              		<li><a class='<c:if test="${upperTabIndexToAppend eq 1 }">on</c:if>' id="tablink_${upperTabIndexToAppend }" href="javascript:void(0)"><span>Official - <fmt:formatDate value="${studentInstitutionTranscript.createdDate}" pattern="MM/dd/yyyy"/></span></a></li>
	                </c:if>
	                <c:if test="${studentInstitutionTranscript.official eq false }">
	              		<li><a class='<c:if test="${upperTabIndexToAppend eq 1 }">on</c:if>' id="tablink_${upperTabIndexToAppend }" href="javascript:void(0)"><span>Un-Official - <fmt:formatDate value="${studentInstitutionTranscript.createdDate}" pattern="MM/dd/yyyy"/></span></a></li>
	                </c:if>
                 </c:if>
            </c:forEach>
    </ul>
    <br class="clear">
    <div id="addDyndivs" class="tabBorder contentForm">
    		<c:set var="divTabIndexToAppend" value="0"/>
		         <c:forEach items="${sitRejectedList }" var="studentInstitutionTranscript" varStatus="transcriptIndex">
		         	<c:if test="${fn:length(studentInstitutionTranscript.studentTranscriptCourse) gt 0}">
		         	 <c:set var="divTabIndexToAppend" value="${divTabIndexToAppend + 1}"/>
		         	 
		         	 <form name="transferCourseForm${divTabIndexToAppend }" id="transferCourseFormId${divTabIndexToAppend }" method="post" action="<c:url value="/evaluation/launchEvaluation.html?operation=markRectifyCourseToComplete&markCompleted=true"/>"><!--//launchEvaluation.html?operation=markTranscriptComplete -->
		         	 
			          <div id="inrContBox_${divTabIndexToAppend }" <c:if test="${divTabIndexToAppend gt 1 }">style="display:none;"</c:if>>	
				     	<div class="rejctdiv rejColor mt10">
				         	   	<c:choose>
							          <c:when test="${studentInstitutionTranscript.official eq true}">
							          	${studentInstitutionTranscript.sleComment}
							          </c:when>
							          <c:otherwise>
							          	${studentInstitutionTranscript.lopeComment}
							         </c:otherwise>
						        </c:choose>
				         	   
				      </div>
		    	<div class="mt30">
		        
		        	<div class="dateReceived">
		            	
		                <label class="noti-label w100">Date Received:</label>
		                    <input type="text" name="dateReceived" value="<fmt:formatDate value='${studentInstitutionTranscript.dateReceived}' pattern='MM/dd/yyyy'/>" class="textField w80px maskDate required">
		            
		            </div>
		        	<div class="lastAttend">
		            
		            	<label class="noti-label w100">Last Attended:</label>
		                    <input type="text" name="lastAttendenceDate" value="<fmt:formatDate value='${studentInstitutionTranscript.lastAttendenceDate}' pattern='MM/dd/yyyy'/>" class="textField w80px maskDate required">
		            
		            </div>
		        	<div class="tanscriptType">
		            <label class="noti-label w110">Transcript Type:</label>
		            <c:choose>
				          <c:when test="${!empty studentInstitutionTranscript }">
				              <label class="mr22" style="margin-top:5px;">
				                 <c:if test="${studentInstitutionTranscript.official eq false}">
				                	Un-official
				                 </c:if>
				               
				                <c:if test="${studentInstitutionTranscript.official eq true}">
				                	Official
				                </c:if>
				              </label>
				          </c:when>
		            </c:choose>
		            </div>
		        	<div class="clear"></div>            
		        
		        </div>
			
		    	<div class="mt30">
		        	<div class="tabHeader">Degree(s) Details</div>
			            <div>
			            
				            <table name="degreeTblForm" id="degreeTblId"  width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl3 noti-bbn tabTBLborder">
								  <tr>
								    <th width="20%" scope="col" class="dividerGrey">Degree Earned</th>
								    <th width="50%" scope="col" class="dividerGrey">Major</th>
								    <th width="15%" scope="col" class="dividerGrey">Graduation Date</th>
								    <th width="15%" scope="col">GPA</th>
								  </tr>
								  <c:choose>
								  		<c:when test="${fn:length(studentInstitutionDegreeList) gt 0}">
									  		<c:forEach items="${studentInstitutionDegreeList}" var="sInstDegList" varStatus="index">
									              <tr id="degreeRow_${index.index }">
												    <td>
													    <select id="insDegree_${index.index }" class="w120 required valid" name="studentInstitutionDegreeSet[${index.index }].institutionDegree.degree" onchange="javascript:markUnMarkDisabled('${index.index}');">
													      <option value="No Degree" <c:if test="${sInstDegList.institutionDegree.degree eq 'No Degree'}">selected</c:if>>No Degree</option>
													      <option value="Associates" <c:if test="${sInstDegList.institutionDegree.degree eq 'Associates'}">selected</c:if>>Associates</option>
														  <option value="Bachelors" <c:if test="${sInstDegList.institutionDegree.degree eq 'Bachelors'}">selected</c:if>>Bachelors</option>
													      <option value="Masters" <c:if test="${sInstDegList.institutionDegree.degree eq 'Masters'}">selected</c:if>>Masters</option>
								                          <option value="Doctoral" <c:if test="${sInstDegList.institutionDegree.degree eq 'Doctoral'}">selected</c:if>>Doctoral</option>
													    </select>
												    </td>
												    <td><input id="major_${index.index }" type="text" name="studentInstitutionDegreeSet[${index.index }].major" value="${sInstDegList.major}" class="textField w80 required"></td>
												    <td><input id="degreeDate_${index.index }" type="text" name="studentInstitutionDegreeSet[${index.index }].completionDate"  value="<fmt:formatDate value='${sInstDegList.completionDate}' pattern='MM/dd/yyyy'/>" class="dgCompletionDate textField w100 maskDate required"></td>
												    <td><input id="GPA_${index.index }" type="text" name="studentInstitutionDegreeSet[${index.index }].gpa" value="${sInstDegList.gpa}" class="textField w80px number" onblur="assignDefaultVal(this);">
												    	<c:if test="${index.index ne 0 }"><a href="javaScript:void(0);" id='removeRow_${index.index }' name='removeRow_${index.index }' class="removeIcon fr mt5 removeInstitutionRow"></a></c:if>
												    </td>
											  </tr>
			            		 			</c:forEach>
								  		</c:when>
								  		<c:otherwise>
								  			<tr id="degreeRow_0">
											    <td>
												    <select id="insDegree_0" class="w120 required valid" name="studentInstitutionDegreeSet[0].institutionDegree.degree" onchange="javascript:markUnMarkDisabled('0');">
												      <option value="No Degree">No Degree</option>
												      <option value="Associates">Associates</option>
													  <option value="Bachelors">Bachelors</option>
												      <option value="Masters">Masters</option>
							                          <option value="Doctoral">Doctoral</option>
												    </select>
											    </td>
											    <td><input id="major_0" type="text" name="studentInstitutionDegreeSet[0].major" class="textField w80" disabled="disabled"></td>
											    <td><input id="degreeDate_0" type="text" name="studentInstitutionDegreeSet[0].completionDate" class="dgCompletionDate textField w100 maskDate"></td>
											    <td><input id="GPA_0" type="text" name="studentInstitutionDegreeSet[0].gpa" value="0.0" class="textField w80px number" onblur="assignDefaultVal(this);"></td>
							 		 		</tr>
								  		</c:otherwise>
								  </c:choose>
							  
							  
							</table>
					  </div>
					<div><a href="javascript:void(0);" class="addDegree" onclick="javascript:loadInstitutionDegreeKeyRow();">Add Degree</a></div>
		        </div>
		        
		        <div>
		        	<div class="tabHeader">Course(s) Details</div>
		            <div> 
		            
		   			 <table name="transferCourseTbl" id="transferCourseTbl" width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl3 noti-bbn tabTBLborder">
								  <tr>
									    <th width="10%" scope="col" class="dividerGrey">Date Completed<br />
										<span class="mandatoryTxt">(mm/dd/yyyy)</span></th>
									    <th width="10%" scope="col" class="dividerGrey">Transfer Course ID</th>
									    <th width="22%" scope="col" class="dividerGrey">Transfer Course Title</th>
									    <th width="7%" align="center" class="dividerGrey" scope="col">Grade</th>
									    <th width="7%" align="center" class="dividerGrey" scope="col">Credits</th>
									    <th width="8%" align="center" class="dividerGrey" scope="col">Semester Credits</th>
									    <th width="8%" scope="col" class="dividerGrey">Transfer Status</th>
									    <th width="16%" scope="col">Course Evalutation Status</th>
									    <th width="6%" scope="col"> <c:if test="${studentInstitutionTranscript.evaluationStatus=='REJECTED'}"> Corrected</c:if></th>
									    <th width="2%" scope="col"> &nbsp;</th>
								 </tr>								 
			  					<c:forEach items="${studentInstitutionTranscript.studentTranscriptCourse}" var="studentTranscriptCourse" varStatus="loop">
											<c:set var="rejectClass" value=""></c:set>
											<c:set var="rejectTrClass" value=""></c:set>
									        <c:if test="${studentTranscriptCourse.transcriptStatus=='REJECTED'}">  
												<c:set var="rejectClass" value="errorClass"></c:set>
												<c:set var="rejectTrClass" value="errorColorfrTbl"></c:set>
												<script>
													rejectCourseList.push('${studentTranscriptCourse.trCourseId}')
												</script>
											</c:if>
											<tr id="courseRow_${loop.index}" class="${rejectTrClass }">
							        			<td>
													<input type="text" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>  name="studentTranscriptCourse[${loop.index}].completionDate" id="trCourseCompletionDate_${loop.index}" class="textField ${rejectClass} w70"   onchange="valuesChanged(this);" value="<fmt:formatDate value='${studentTranscriptCourse.completionDate}' pattern='MM/dd/yyyy'/>"/>
									            </td>
									            <td>
													<input type="hidden" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>  id="transcriptStatus_${loop.index}" name="studentTranscriptCourse[${loop.index}].transcriptStatus" value="${studentTranscriptCourse.transcriptStatus}" />
									            	<input type="hidden"<c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>  name="hasUnsavedValues_${loop.index}" id="hasUnsavedValues_${loop.index}" value="0" />
									            	<input type="hidden" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>   name="studentTranscriptCourse[${loop.index}].markCompleted" value="${studentTranscriptCourse.markCompleted}" />
									            	<input type="hidden" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>   name="studentTranscriptCourse[${loop.index}].id" value="${studentTranscriptCourse.id}" />
									            	<input type="hidden" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>   name="studentTranscriptCourse[${loop.index}].createdBy" value="${studentTranscriptCourse.createdBy}" />		            	
									            	<input type="text" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED'}"> disabled="disabled"</c:if>  name="studentTranscriptCourse[${loop.index}].trCourseId" id="trCourseId_${loop.index}" value="${studentTranscriptCourse.trCourseId}" onchange="valuesChanged(this);" class="trCourseId ${rejectClass} textField w70" <%-- onBlur="javascript:findCourseDetails(${loop.index}, this.value);" --%> />            	
												</td>
												<td>
											        <input type="text" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourseTitle.title" id="trCourseTitle_${loop.index}"  onchange="valuesChanged(this);" class="${rejectClass} textField w110 mr10" value="${studentTranscriptCourse.courseTitle}"/>
											        <select  class="required valid w90" id="trCourseTitleSelect_${loop.index}" name="trCourseTitleSelect_${loop.index}" onchange="fillTitle(this);" >
														<option value="">Select Title</option>		    
													</select><br class="clear" />
											    </td>
											    <td>
											    	<%-- <input type="text"  name="trCourseGrade_${loop.index}" id="trCourseGrade_${loop.index}"  onchange="valuesChanged(this);" class="${rejectClass} textField w40" value="${studentTranscriptCourse.grade}"  /> --%>
											    	<select <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled" </c:if>   name="studentTranscriptCourse[${loop.index}].grade" id="trCourseGrade_${loop.index}"  onchange="valuesChanged(this);" class="${rejectClass} w50px required valid">
								            			<option value=''>TR Grade</option>
														<option value="A" <c:if test="${studentTranscriptCourse.grade eq 'A'}">selected</c:if>>A</option>
														<option value="A-" <c:if test="${studentTranscriptCourse.grade eq 'A-'}">selected</c:if>>A-</option>
														<option value="B" <c:if test="${studentTranscriptCourse.grade eq 'B'}">selected</c:if>>B</option>
														<option value="B+" <c:if test="${studentTranscriptCourse.grade eq 'B+'}">selected</c:if>>B+</option>
														<option value="B-" <c:if test="${studentTranscriptCourse.grade eq 'B-'}">selected</c:if>>B-</option>
														<option value="C" <c:if test="${studentTranscriptCourse.grade eq 'C'}">selected</c:if>>C</option>
														<option value="C+" <c:if test="${studentTranscriptCourse.grade eq 'C+'}">selected</c:if>>C+</option>
														<option value="C-" <c:if test="${studentTranscriptCourse.grade eq 'C-'}">selected</c:if>>C-</option>
														<option value="CR" <c:if test="${studentTranscriptCourse.grade eq 'CR'}">selected</c:if>>CR</option>
														<option value="D" <c:if test="${studentTranscriptCourse.grade eq 'D'}">selected</c:if>>D</option>
														<option value="D+" <c:if test="${studentTranscriptCourse.grade eq 'D+'}">selected</c:if>>D+</option>
														<option value="D-" <c:if test="${studentTranscriptCourse.grade eq 'D-'}">selected</c:if>>D-</option>
														<option value="F" <c:if test="${studentTranscriptCourse.grade eq 'F'}">selected</c:if>>F</option>
														<option value="I" <c:if test="${studentTranscriptCourse.grade eq 'I'}">selected</c:if>>I</option>
														<option value="IP" <c:if test="${studentTranscriptCourse.grade eq 'IP'}">selected</c:if>>IP</option>
														<option value="S" <c:if test="${studentTranscriptCourse.grade eq 'S'}">selected</c:if>>S</option> 
														<option value="TR" <c:if test="${studentTranscriptCourse.grade eq 'TR'}">selected</c:if>>TR</option>
														<option value="U" <c:if test="${studentTranscriptCourse.grade eq 'U'}">selected</c:if>>U</option>
														<option value="W" <c:if test="${studentTranscriptCourse.grade eq 'W'}">selected</c:if>>W</option>
														<option value="WF" <c:if test="${studentTranscriptCourse.grade eq 'WF'}">selected</c:if>>WF</option>
								                	</select>
											    </td>
											    <td>
											    
											        <input type="text" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED'}"> disabled="disabled"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.transcriptCredits" id="trCourseCredits_${loop.index}"  onchange="valuesChanged(this);evalSemEq(this);"  class="${rejectClass} textField w30" value="${studentTranscriptCourse.transferCourse.transcriptCredits}"  />
											    </td>
											    <td>
									            	<c:choose>
									            		<c:when test="${fn:toUpperCase(studentInstitutionTranscript.institution.evaluationStatus) == 'EVALUATED'}">
									            			<c:choose>
									            				<c:when test="${institutionTermType.termType.name == 'Quarter'}">
									            					<input type="text" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED'}"> disabled="disabled"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w30" value='<fmt:formatNumber value="${studentTranscriptCourse.transferCourse.transcriptCredits*2/3}" maxFractionDigits="2" />'/>
									            				</c:when>
									            				<c:when test="${institutionTermType.termType.name == '4-1-4'}">
									            					<input type="text" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED'}"> disabled="disabled"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w30" value='<fmt:formatNumber value="${studentTranscriptCourse.transferCourse.transcriptCredits*4}" maxFractionDigits="2" />' />
									            				</c:when>
									            				<c:otherwise>
									            					<input type="text" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w30" value="${studentTranscriptCourse.transferCourse.transcriptCredits}" />
									            				</c:otherwise>
									            			</c:choose>
									            		</c:when>
									            		<c:otherwise>
									            			<input type="text" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w30" value="---" />
									            		</c:otherwise> 
									            	</c:choose>	
											    </td>
											    <td>
											    	${studentTranscriptCourse.transcriptStatus}
											   </td>
											    <td>
											    	${studentTranscriptCourse.evaluationStatus}
											    </td>
											    <c:if test="${studentInstitutionTranscript.evaluationStatus == 'REJECTED' }">
											    	<td>
											    		<c:if test="${studentTranscriptCourse.transcriptStatus=='REJECTED'}">
											    			<input type="checkbox" name="errCrctd_${loop.index}" id="errCrctd_${loop.index}"  studentId="${studentInstitutionTranscript.student.id}" courseId="${studentTranscriptCourse.id }" class="errCrctd" style="margin:10px 0px 0px 20px;"/>
											    		</c:if>
											    	</td>
											    </c:if>
											    <td id="removeRowTd_${loop.index}">
													<c:choose>
												    	<%-- <c:when test="${loop.last == true && loop.first == false && (studentInstitutionTranscript.evaluationStatus == 'DRAFT' || studentInstitutionTranscript.evaluationStatus == 'REJECTED')}">
												        	
												        	<a href="#" id="removeRow_${loop.index}" name="removeRow_${loop.index}" class="removeIcon fr removeRow"></a>
												        	
												        </c:when> --%>
												        <c:when test="${studentTranscriptCourse.markCompleted eq true  && studentTranscriptCourse.evaluationStatus eq 'EVALUATED' && studentTranscriptCourse.transcriptStatus  ne 'REJECTED'}">
													        
													    </c:when>
												  		<c:otherwise>
												  			<a href="javaScript:void(0);" id="removeRow_${loop.index}" name="removeRow_${loop.index}" class="removeIcon fr removeRow"></a>
												        </c:otherwise>
												    </c:choose>
												</td>
										    </tr>
										</c:forEach>
				            </table>
				            <input type="hidden" name="id" id="studentInstitutionTranscriptId" value="${studentInstitutionTranscript.id}" />
				            <input type="hidden" name="official"  value="${studentInstitutionTranscript.official}" />
				            <input type="hidden" name="createdBy" value="${studentInstitutionTranscript.createdBy}" />
				            
				            <input type="hidden" id="selinstitutionId" name="institution.id" value="${selectedInstitution.id}" />
						   	
						   	<input type="hidden" name="studentCrmId" id="studentCrmId" value="${courseInfo.studentCrmId}" />
						   	<input type="hidden" name="programVersionCode" id="programVersionCode"  value="${courseInfo.programVersionCode}" />
						   	<input type="hidden" name="programDesc"  value="${courseInfo.programDesc}" />
						   	<input type="hidden" name="catalogCode"  value="${courseInfo.catalogCode}" />
						   	<input type="hidden" name="stateCode"  value="${courseInfo.stateCode}" />
						   	
						   	
						    <input type="hidden" name="coursesAdded" value="" />
						    <input type="hidden" name="expectedStartDateString" id="expectedStartDateString" value="<fmt:formatDate value='${courseInfo.expectedStartDate}' pattern='MM/dd/yyyy' />" />
						    <input type="hidden" name="institutionId" id="institutionId" value="${studentInstitutionTranscript.institution.id}" />
						   	<%-- <input type="hidden" name="studentProgramEvaluationId" id="studentProgramEvaluationId" value="${studentProgramEvaluation.id}" /> 
						   	<input type="hidden" name="studentInstitutionTranscriptId" id="studentInstitutionTranscriptId" value="${studentInstitutionTranscript.id}" />
						 	 	
						   	<input type="hidden" name="isSaveDraftInProgress" id="isSaveDraftInProgress" value="0" />--%>
						   	<input type="hidden" name="studentId" id="studentId" value="${studentId }" />
						   	
						   	<input type="hidden" name="redirectValue1" id="redirectValue1" value="${redirectValue1}"/>
						   	<input type="hidden" name="institutionAddressId" id="institutionAddressId" value="${studentInstitutionTranscript.institutionAddress.id}"/>
				            
		           </div>
					<div><a href="javascript:void(0);" class="addCourse" onclick="javaScript:addCourseRow1();">Add Course</a></div>
		        </div>
		      
		        <div class="BorderLine"></div>
		        <div>
			          <div class="fr">
						<input type="button" name="MarkComplete" value="Mark Complete" id="markComplete${divTabIndexToAppend }" class="button" onclick="submitTranscript('<c:url value="/evaluation/launchEvaluation.html?operation=markRectifyCourseToComplete&markCompleted=true"/>','inrContBox_${divTabIndexToAppend }','transferCourseFormId${divTabIndexToAppend }','markComplete${divTabIndexToAppend }');">
					</div>
			        <div class="clear"></div>
		    	</div>
		    	 
		     </div>
		     </form> 
		   </c:if>
		  </c:forEach> 
    </div>
    
	<div class="clear"></div>
      </div>
    
    
  
    </div>
      
    </div>
  </div>
</div>