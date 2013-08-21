<%@include file="../init.jsp" %>


<link rel="stylesheet" href="<c:url value="/css/schSysStylesheet.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/jquery.ui.all.css"/>" />
<style>
.capitalise
{
    text-transform:capitalize;
} 
</style>
<script type="text/javascript" src="<c:url value="/js/jquery.validate.js"/>"></script>
<script type='text/javascript' src="<c:url value='/js/expand.js'/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.maskedinput-1.3.js"/>"></script>
  
<title>Evaluate Courses</title>
	
<script>
	var rejectCourseList = new Array();
	var availableTags = [
					<c:forEach items="${courseList}" var="course">
					"${course.trCourseCode}",
					</c:forEach>
							];
	
	function clockHoursAdj(){
		jQuery("[id^='trCourseCredits_']").live('blur', function(){
			var indecs=jQuery(this).attr('id').split('_')[1];
			if(jQuery(this).val().length>0){
				jQuery("#trClockHours_"+indecs).val('');
				jQuery("#trClockHours_"+indecs).attr('disabled','disabled');
				jQuery("#trCourseCredits_"+indecs).removeAttr('disabled');
				jQuery("#trCourseCredits_"+indecs).addClass('required');
				jQuery("#trClockHours_"+indecs).removeClass('required');
			}else{
				jQuery("#trClockHours_"+indecs).removeAttr('disabled');
				jQuery("#trClockHours_"+indecs).focus();
				jQuery("#trCourseCredits_"+indecs).val('');
				jQuery("#trCourseCredits_"+indecs).attr('disabled','disabled');
				jQuery("#trCourseCredits_"+indecs).removeClass('required');
				jQuery("#trClockHours_"+indecs).addClass('required');
			}
			
			
		})
		
			jQuery("[id^='trClockHours_']").live('blur',function(){
			var indecs=jQuery(this).attr('id').split('_')[1];
			if(jQuery(this).val().length>0){
				jQuery("#trClockHours_"+indecs).removeAttr('disabled');
				jQuery("#trCourseCredits_"+indecs).val('');
				jQuery("#trCourseCredits_"+indecs).attr('disabled','disabled');
				
			}else{
				jQuery("#trClockHours_"+indecs).val('');
				jQuery("#trClockHours_"+indecs).attr('disabled','disabled');
				jQuery("#trCourseCredits_"+indecs).removeAttr('disabled');
			}
			
			
		})
	}
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
			//valuesChanged(this);
        },
		minLength: 2,
		 search: function(event, ui) { jQuery(this).addClass("auto-load"); },
		  open: function(event, ui) { jQuery(this).removeClass("auto-load"); }
		  
		
		});
	}
		
		
	<fmt:formatDate value="${courseInfo.expectedStartDate}" pattern="MM/dd/yyyy" var="dateValue" />

	<c:set var="queryString" value="studentCrmId=${student.crmId}&programVersionCode=${courseInfo.programVersionCode}&programDesc=${courseInfo.programDesc}&catalogCode=${courseInfo.catalogCode}&stateCode=${student.state}&expectedStartDateString=${dateValue}" />
	<c:set var="transcriptQueryString" value="instId=${selectedInstitution.id}&speId=${studentInstitutionTranscript.student.id}" />

	function evalSemEq(textBox){
	var currentRow = jQuery(textBox).attr('id').split('_')[1];
		//currentRow = currentRow - 1;
		var semEqValue = parseInt(jQuery("#trCourseCredits_"+currentRow).val());
		if(!isNaN(semEqValue)){
			if("${studentInstitutionTranscript.institution.evaluationStatus}".toUpperCase() == "EVALUATED" && semEqValue != ''){
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
			}else{
				jQuery("#trSemCredits_"+currentRow).val("---");
			}
		}else{
			jQuery("#trSemCredits_"+currentRow).val("---");
		} 
	}
		
	function fillTitle(selected, tableId){
		var currentRow = jQuery(selected).attr('id').split('_')[1];
		if(jQuery("#"+tableId+" #trCourseTitleSelect_"+currentRow).val()!=''){
			jQuery("#"+tableId+" #trCourseTitle_"+currentRow).val(jQuery("#"+tableId+" #trCourseTitleSelect_"+currentRow+" option:selected").text());	
			jQuery("#"+tableId+" #trCourseTitle_"+currentRow).attr("title",jQuery("#"+tableId+" #trCourseTitleSelect_"+currentRow+" option:selected").text());
		}
		else{
			jQuery("#"+tableId+" #trCourseTitle_"+currentRow).val("");
			jQuery("#"+tableId+" #trCourseTitle_"+currentRow).attr("title","");
		}
		
	}
	
function addComments(){
	
	jQuery("[id^='addComment']").click(function(){
		var index=jQuery(this).attr('id').split('_')[1];
		var dataString = "transcriptId=" + jQuery("#sitId_"+index).val()+"&comment=" + jQuery("#comment_"+index).val()+"&divindex="+index;
		if( jQuery("#comment_"+index).val().length>0){
			jQuery.ajax({
				url: "<c:url value='/evaluation/launchEvaluation.html?operation=addTranscriptComment'/>",
				type: "POST",
				data: dataString,
				success: function( data ) {
					jQuery("#transcriptCommentsDiv_"+index).html(data);
					jQuery("#comment_"+index).val('');
					jQuery('#addNoteFrm_'+index).hide();
					jQuery('#addNoteLnk_'+index).show();
				}
			});
		}
	});
	}
	
function removeComments(){
	
	jQuery(".removeBtn"). live('click',function(){
		var index=jQuery(this).attr('divindex');
		var commentId=jQuery(this).attr('commentId');
		var transcriptId=jQuery(this).attr('transcriptId');
		var dataString = "transcriptId="+ transcriptId+"&commentId=" + commentId+"&divindex="+index;
		var urlString="<c:url value='/evaluation/launchEvaluation.html?operation=removeTranscriptComment'/>";
		jQuery.ajax({
			url: urlString,
			data: dataString,
			success: function( data ) {
				jQuery("#transcriptCommentsDiv_"+index).html(data);
			}
		});
		
	});
	}	
window.onload = (function () {
	jQuery(document).ready( function() {
		addComments();
		removeComments();
		clockHoursAdj();
		
		jQuery("[id^='trCourseTitle_']").each(function(){
			jQuery(this).addClass('capitalise');
		}); 
		
		jQuery("[id^='trCourseTitle_']").live('on keyup', function(event) {
			jQuery(this).addClass('capitalise');
		});
		
		jQuery(".removeInstitutionRow, .removeRow").live('click', function(event) {
			jQuery(this).parent().parent().remove();
		});
		
			jQuery('.addNoteFrm, #dashLine').hide();
			jQuery("[id^='addNoteLnk_']").click(function(){
				var index=jQuery(this).attr('id').split('_')[1];	
				jQuery('#addNoteFrm_'+index).show();
				
				jQuery(this).hide();
					
			});
	
			jQuery("[id^='trCourseGrade_']").css("text-transform" ,"uppercase" );
			jQuery("[id^='trCourseGrade_']").live('on keyup', function(event) {
				jQuery(this).val(jQuery(this).val().toUpperCase());
			});
				
			jQuery("[id^='trCourseId_']").css("text-transform" ,"uppercase" );
			jQuery("[id^='trCourseId_']").live('on keyup', function(event) {
				
				jQuery(this).val(jQuery(this).val().toUpperCase());
				jQuery(this).autocomplete({
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
							
							jQuery("[id^='trCourseId_']").removeClass('auto-load');
							response( jQuery.map( data, function( item ) {
								
								return {
									label: item.trCourseCode ,
									value: item.trCourseCode
								}
							}));
						},
						error: function(xhr, textStatus, errorThrown){
							jQuery("[id^='trCourseId_']").removeClass('auto-load');
						},
						

					});
				},
				select: function(event, ui) {
					//valuesChanged(this);
		        },
				minLength: 2,
				 search: function(event, ui) { jQuery(this).addClass("auto-load"); },
				  open: function(event, ui) { jQuery(this).removeClass("auto-load"); }
				  
				
				});
				
			});
			
			jQuery('#trCourseId')
			   
			    .ajaxStart(function() {
			        $(this).show();
			        
			    })
			    .ajaxStop(function() {
			      
			        jQuery(".trCourseId").removeClass("auto-load");
			    });	
			jQuery("[id^='cancelAddComment_']").click(function(){
				var index=jQuery(this).attr('id').split('_')[1];				
				jQuery("#addNoteLnk_"+index).show();				
				jQuery('#addNoteFrm_'+index).hide();
					
			});
		
			/*	if(${studentInstitutionTranscript.evaluationStatus == 'REJECTED INSTITUTION'}){
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
		
			if(${studentInstitutionTranscript.evaluationStatus == 'REJECTED INSTITUTION'}){
				jQuery("#addTranscriptBtn").hide();
				jQuery("#transferCourseForm").hide();
				jQuery("#backToTrList").hide();
			}
			else if(${studentInstitutionTranscript.evaluationStatus == 'REJECTED'}){
				jQuery("#backToTrList").hide();
				jQuery('#transferCourseForm :input').attr('disabled',false);
				jQuery("#submitTrCourses").attr('disabled',true);
				
			}*/	
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
			
			//initEventHandlerForSave();
	
			 jQuery(".keyUpTextField").change(function () {
				 var ctr=jQuery(this).attr('id').split("_")[1];
				 jQuery(this).removeClass("errorClass");
				 jQuery('#evalStatus_'+ctr).removeClass("errorClass");
				 jQuery('#trCourseTitle_'+ctr).removeClass("errorClass");
				 jQuery('#trCourseCredits_'+ctr).removeClass("errorClass");
				 jQuery('#trCourseCompletionDate_'+ctr).removeClass("errorClass");
				 jQuery('#trCourseGrade_'+ctr).removeClass("errorClass");
				 //jQuery('#transcriptStatus_'+ctr).val("DRAFT");
				 
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
				
		//Other ready function code
	
		    jQuery("h1.expand").toggler(); 
		    jQuery("#divContBoxLft").expandAll({trigger: "h1.expand"});
			jQuery("#divContBoxRgt").expandAll({trigger: "h1.expand"});
			
			 jQuery('.collapse:first').hide();
			 jQuery('h1.expand:first a:first').addClass("close");
			 jQuery(".add").click(function() {
				jQuery(".transcript").show();
				jQuery(".institute").hide();
			});
	
					//hover states on the static widgets
			jQuery('#dialog_link, ul#icons li').hover(
				function() { jQuery(this).addClass('ui-state-hover'); },
				function() { jQuery(this).removeClass('ui-state-hover'); }
			);
			removeInstitutionDegreeDetails();
			var i = 2;
			var tabTxt1 = "";
			var tabIndexCount = -1;
			var tabIndex = 0;
			<c:forEach items="${studentInstitutionTranscriptSummaryList}" var="studentInstitutionTranscriptSummary" varStatus="summaryIndex">
			 <c:if test="${fn:length(studentInstitutionTranscriptSummary.studentInstitutionTranscript.studentTranscriptCourse) gt 0}">
			 	tabIndexCount = tabIndexCount + 1;
			 	tabIndex = i + tabIndexCount;
				<c:if test="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.official eq true}">
					tabTxt1 = "Official - <fmt:formatDate value="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.createdDate}" pattern="MM/dd/yyyy"/>";			
				</c:if>
				<c:if test="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.official eq false}">
					tabTxt1 = "Un-Official - <fmt:formatDate value="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.createdDate}" pattern="MM/dd/yyyy"/>";
				</c:if>
			jQuery("#MarkComplete").click(function() {
			 // jQuery('<li><a href="javascript:void(0)" id="tablink_'+tabIndex+'"><span>'+tabTxt1+'</span></a></li>').appendTo("#addTopNav");
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
			
		} );
});	
	function findCourseDetails(ctr, transferCourseTblId,transferCourseFormId,text2){
		//alert('in here ctr='+ctr);
		if( jQuery.trim(text2) == '') {
			return;
		}
		 
		jQuery.getJSON("<c:url value="/evaluation/launchEvaluation.html?operation=getCourseDetails"/>&institutionId=${studentInstitutionTranscript.institution.id}&trCourseId="+jQuery.trim(text2),function (JsonData){
			//alert(JsonData.trCourse);	
				if(JsonData != null && JsonData.trCourse == null){	
					//alert('in else');
					jQuery('#'+transferCourseFormId+' #evalStatus_'+ctr).val('NOT EVALUATED');
					jQuery('#'+transferCourseFormId+' #trCourseTitle_'+ctr).attr("readonly", false); 
					jQuery('#'+transferCourseFormId+' #trCourseTitle_'+ctr).val('');
					jQuery('#'+transferCourseFormId+' #trCourseCredits_'+ctr).val('');
					jQuery("#"+transferCourseFormId+" #trSemCredits_"+ctr).val('');
					jQuery("#"+transferCourseFormId+" #trClockHours_"+ctr).val('');
					jQuery("#"+transferCourseFormId+" #trCourseTitleSelect_"+ctr).attr("disabled","disabled");
					jQuery("#"+transferCourseFormId+" #trCourseTitleSelect_"+ctr).html("");
					jQuery("#"+transferCourseFormId+" #trCourseTitleSelect_"+ctr).append('<option value="">Select Title</option>'+appendtxt);
					//jQuery('#trCourseTitle_'+ctr).focus();
				}
				else {
					if(JsonData != null){
							//alert("------ "+JsonData.titleList[0].title);					
							//jQuery('#trCourseTitle_'+ctr).val(JsonData.trCourse.trCourseTitle);
							var inRange = false;
							var x=0,i;
							var appendtxt = '';
							var courseCompletionDate = jQuery("#"+transferCourseFormId+" #trCourseCompletionDate_"+ctr).val();
							if(JsonData.titleList != null){
								//alert(JsonData.titleList.length);
								for(i=0;i<JsonData.titleList.length;i++){
									var txt = ""+JsonData.titleList[i].title;
									appendtxt = appendtxt+"<option value="+txt+">"+txt+"</option>";	
									
									var efdt = formatDt(new Date(JsonData.titleList[i].effectiveDate));
									var endt = formatDt(new Date(JsonData.titleList[i].endDate));
									//alert("effectiveDate ----  ");
								
									
									//check if the course completion date falls in range
									if((cmpDate(courseCompletionDate, efdt)<0)&&(cmpDate(courseCompletionDate, endt)>0)){
										jQuery('#'+transferCourseFormId+' #trCourseTitle_'+ctr).val(JsonData.titleList[i].title);
										if( (JsonData.trCourse.evaluationStatus).toUpperCase() == 'EVALUATED' ) {
											jQuery('#'+transferCourseFormId+' #trCourseTitle_'+ctr).attr("readonly", true);
											jQuery('#'+transferCourseFormId+' #evalStatus_'+ctr).val('EVALUATED');
										}
										else {
											jQuery('#'+transferCourseFormId+' #trCourseTitle_'+ctr).attr("readonly", false);
											jQuery('#'+transferCourseFormId+' #evalStatus_'+ctr).val(JsonData.trCourse.evaluationStatus);
										}
										inRange = true;
									}
								}
							}
							if(!inRange){
								if(JsonData.titleList != null && JsonData.titleList.length == 1){
									//autofill the only value
									jQuery('#'+transferCourseFormId+' #trCourseTitle_'+ctr).val(JsonData.titleList[0].title);
									jQuery('#'+transferCourseFormId+' #trCourseTitleSelect_'+ctr).attr("disabled","disabled");
								}
								else{
									// enable deo to select titles
									jQuery("#"+transferCourseFormId+" #trCourseTitleSelect_"+ctr).html("");
									jQuery("#"+transferCourseFormId+" #trCourseTitleSelect_"+ctr).append('<option value="">Select Title</option>'+appendtxt);
									jQuery("#"+transferCourseFormId+" #trCourseTitleSelect_"+ctr).removeAttr("disabled");
								}
								jQuery('#'+transferCourseFormId+' #evalStatus_'+ctr).val('NOT EVALUATED');
							}
							if(JsonData.trCourse.transcriptCredits != null && JsonData.trCourse.transcriptCredits !=''){
								jQuery('#'+transferCourseFormId+' #trCourseCredits_'+ctr).val(parseInt(JsonData.trCourse.transcriptCredits));
							}
							if(JsonData.trCourse.clockHours != null && JsonData.trCourse.clockHours !=''){
								jQuery('#'+transferCourseFormId+' #trClockHours_'+ctr).val(JsonData.trCourse.clockHours);
							}
							
							jQuery("#"+transferCourseTblId+" #studentTranscriptCourseTranscriptStatus_"+ctr).html(JsonData.trCourse.transferStatus);
							if(JsonData.trCourse.evaluationStatus != '' && JsonData.trCourse.evaluationStatus =='CONFLICT'){
								//jQuery("#"+transferCourseTblId+" #studentTranscriptCourseEvaluationStatus_"+ctr).html("IN PROGRESS");
								jQuery("#"+transferCourseTblId+" #transcriptEvaluationStatus_"+ctr).val("IN PROGRESS");
							}else{						
								//jQuery("#"+transferCourseTblId+" #studentTranscriptCourseEvaluationStatus_"+ctr).html(JsonData.trCourse.evaluationStatus);
								jQuery("#"+transferCourseTblId+" #transcriptEvaluationStatus_"+ctr).val(JsonData.trCourse.evaluationStatus);
							}
							jQuery("#"+transferCourseTblId+" #transcriptStatus_"+ctr).val(JsonData.trCourse.transferStatus);
							
							
							
							//filling the equivalent semester credits
							var semEqValue = parseInt(jQuery("#"+transferCourseTblId+" #trCourseCredits_"+ctr).val());
						if(JsonData.trCourse.clockHoursChk == false){
							jQuery("#"+transferCourseTblId+" #trCourseCredits_"+ctr).removeAttr("disabled");
							jQuery("#"+transferCourseTblId+" #trClockHours_"+ctr).attr("disabled","disabled");
							if(semEqValue !=''){
								jQuery.ajax({
									url: "<c:url value='/evaluation/launchEvaluation.html?operation=getInstitutionTermTypeForCourse&completionDate='/>"+jQuery("#"+transferCourseTblId+" #trCourseCompletionDate_"+ctr).val()+"&institutionId="+jQuery("#institutionId").val(),	
									dataType: "json", success:function(data){
										var semEqValue = parseInt(jQuery("#"+transferCourseTblId+" #trCourseCredits_"+ctr).val());
										//alert(data.termType);
										if(!isNaN(semEqValue)){
											if(data.termType !=null && data.termType != '' && "${studentInstitutionTranscript.institution.evaluationStatus}".toUpperCase() == "EVALUATED" && semEqValue != ''){
												if(data.termType.name == "Quarter"){
													semEqValue = parseFloat(semEqValue)*2/3;
													jQuery("#"+transferCourseTblId+" #trSemCredits_"+ctr).val(semEqValue.toFixed(2));
												}
												else if(data.termType.name == "4-1-4"){
													semEqValue = parseFloat(semEqValue)*4;
													jQuery("#"+transferCourseTblId+" #trSemCredits_"+ctr).val(semEqValue.toFixed(2));
												}
												else if(data.termType.name == "Semester"){
													jQuery("#"+transferCourseTblId+" #trSemCredits_"+ctr).val(semEqValue.toFixed(2));
												}
												else{
													jQuery("#"+transferCourseTblId+" #trSemCredits_"+ctr).val("---");
												}
											}else{
												jQuery("#"+transferCourseTblId+" #trSemCredits_"+ctr).val("---");
											}
										}else{
											jQuery("#"+transferCourseTblId+" #trSemCredits_"+ctr).val("---");
										}
									},
									error: function(xhr, textStatus, errorThrown){
										jQuery("#"+transferCourseTblId+" #trSemCredits_"+ctr).val("---");
									}
								});
							}else{
								jQuery("#"+transferCourseTblId+" #trSemCredits_"+ctr).val("---");
							}
						}else if(JsonData.trCourse.clockHoursChk == true){
							jQuery("#"+transferCourseTblId+" #trCourseCredits_"+ctr).attr("disabled","disabled");
							jQuery("#"+transferCourseTblId+" #trClockHours_"+ctr).removeAttr("disabled");
							if(jQuery("#"+transferCourseTblId+" #trClockHours_"+ctr).val() !=''){
								jQuery.ajax({
									url: "<c:url value='/evaluation/launchEvaluation.html?operation=getCourseType&institutionId='/>"+jQuery("#institutionId").val()+"&courseCode="+jQuery("#"+transferCourseTblId+" #trCourseId_"+ctr).val(),	
									dataType: "json", success:function(data){
										var semEqValue1 = parseInt(jQuery("#trClockHours_"+ctr).val());
										//alert(semEqValue);
										if(!isNaN(semEqValue1)){					
											jQuery("#"+transferCourseFormId+" #trSemCredits_"+ctr).val("---");
											if("${studentInstitutionTranscript.institution.evaluationStatus}".toUpperCase() == "EVALUATED" && semEqValue1 != ''){
												//alert(data.courseType);
												if(data.courseType == "Lecture"){
													semEqValue1 = parseFloat(semEqValue1)/15;
													jQuery("#"+transferCourseFormId+" #trSemCredits_"+ctr).val(semEqValue1.toFixed(2));	
												}
												else if(data.courseType == "Lab"){
													semEqValue1 = parseFloat(semEqValue1)/30;
													jQuery("#"+transferCourseFormId+" #trSemCredits_"+ctr).val(semEqValue1.toFixed(2));
												}
												else if(data.courseType == "Clinical"){
													semEqValue1 = parseFloat(semEqValue1)/45;
													jQuery("#"+transferCourseFormId+" #trSemCredits_"+ctr).val(semEqValue1.toFixed(2));
												}
												else{
													jQuery("#"+transferCourseFormId+" #trSemCredits_"+ctr).val("---");
												}
											}else{
												jQuery("#"+transferCourseFormId+" #trSemCredits_"+ctr).val("---");
											}
										}else{
											jQuery("#"+transferCourseFormId+" #trSemCredits_"+ctr).val("---");
										}
									},
									error: function(xhr, textStatus, errorThrown){
										jQuery("#"+transferCourseFormId+" #trSemCredits_"+ctr).val("---");
									}
								});
							}else{
								jQuery("#"+transferCourseFormId+" #trSemCredits_"+ctr).val("---");
							}
						}else{
							jQuery("#"+transferCourseFormId+" #trSemCredits_"+ctr).val("---");
						}						
						//jQuery('#trCourseGrade_'+ctr).focus();
				 }	
			}
				
				
			
		});
	}

	

	function verifyRejected(){
		var returnValue;
	
		jQuery("[id^='trCourseId_']").each(function(){
			var currentVal=jQuery(this).val();
			for(var i=0;i<rejectCourseList.length;i++){
			
				if(currentVal==rejectCourseList[i]){
					alert("Please Change the Rejected CourseCode");
					returnValue= false;
					break;
				}
			}
			return returnValue;
		});
		
		return returnValue;
	}

	function addEntryInstitution(){
		url="<c:url value='/institution/manageInstitution.html?operation=entryInstitution'/>";
	
 		Boxy.load(url,
 		 		{ unloadOnHide : true,
		 		afterShow : function() {
	 				jQuery("#frmEntryInstitution").validate();
					jQuery("#entryStudentCrmId").val(jQuery("#homeStudentCrmId").val());
					jQuery("#entryProgramVersionCode").val(jQuery("#homeProgramVersionCode").val());
					jQuery("#entryCatalogCode").val(jQuery("#homeCatalogCode").val());
					jQuery("#entryStateCode").val(jQuery("#homeStateCode").val());
					jQuery("#entryExpectedStartDate").val(jQuery("#homeExpectedStartDate").val());
	 		}
 		})   
	 }
		
	function formatDt(d){
		var curr_date = d.getDate();
		if(curr_date < 10){
			curr_date = '0'+curr_date;
		}
	    var curr_month = d.getMonth() + 1; //Months are zero based
	    if(curr_month < 10){
			curr_month = '0'+curr_month;
		}
	    var curr_year = d.getFullYear();
	    return curr_month + "/" + curr_date + "/" + curr_year;
	}
		
</script>

<script type="text/javascript">

function launchDeoComments(){
	Boxy.load("<c:url value='launchEvaluation.html?operation=deoComments&studentProgramEvaluationId=${studentInstitutionTranscript.student.id}&programVersionCode=${courseInfo.programVersionCode}&studentCrmId=${student.crmId}'/>",
		 		{ unloadOnHide : true	 		
		})   
}
function getInstituteNames(instituteName,firstOption){
	var url = "<c:url value='launchEvaluation.html?operation=getInstituteName'/>&state="+instituteName;
	jQuery.ajax({url:url, success:function(result){
		  jQuery("#fillInstituteInfo").html('');
		  jQuery("#select").html("");
		  jQuery("#select").html(firstOption+result);
	}});
}

function removeInstitutionDegreeDetails(){
	//Remove rows when Remove link is clicked.
	jQuery(".removeInstitutionRow").live('click', function(event) {
		//remove the current row
		jQuery(this).parent().parent().remove();

		//set the remove link for the previous row in the table unless it is the first row.
		var noOfRows = jQuery( "#degreeTblId" ).attr('rows').length;
		rowIndex = noOfRows - 2;
		//alert(rowIndex);
		if( rowIndex == -1 ) {
			rowIndex = 0;
		}
		if( rowIndex > 0 ) {
			jQuery("#removeRowTd_"+(rowIndex)).html( "<a href='javaScript:void(0);' id='removeRow_"+rowIndex+"' name='removeRow_"+rowIndex+"' class='removeInstitutionRow removeIcon fr mt5'></a>" );
		}/* else if(rowIndex == 0){
			jQuery("#removeRowTd_"+(rowIndex)).html( "<a onclick='loadInstitutionDegreeKeyRow(1);' class='addRow' name='addRow_0' id='addRow_0' href='javascript:void(0)'><img width='15' height='14' src='../images/addCourse.png' alt='add'> Add New</a><br/>" );
		} */
	} );
}

function markUnMarkDisabled(index,degreeTblIdToMarkUnMark){
	//major_index
	//alert(jQuery("#"+degreeTblIdToMarkUnMark+" #insDegree_"+index).find("option:selected").val());
	if(jQuery("#"+degreeTblIdToMarkUnMark+" #insDegree_"+index).find("option:selected").val() != 'No Degree'){
		
		jQuery("#"+degreeTblIdToMarkUnMark+" #major_"+index).removeAttr("disabled");
	}else{
		jQuery("#"+degreeTblIdToMarkUnMark+" #major_"+index).val("");
		jQuery("#"+degreeTblIdToMarkUnMark+" #major_"+index).attr("disabled","disabled");
	}
	
	
}

	
	
</script>
   

<script type="text/javascript">
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

/* function validate() {
	if(!errorFound){
		jQuery(":input").removeClass( "redBorder" );
	}
	var noOfRows = jQuery( "#degreeTblId" ).attr('rows').length;
	noOfRows = noOfRows - 2;
	var errorString = "";
	
	//alert( "noOfRows is " + noOfRows );
	for( var ctr=0; ctr<=noOfRows; ctr++ ){
		var degree = jQuery("#insDegree_"+ctr).val();
		var major = jQuery.trim( jQuery("#major_"+ctr).val() );
		var completionDate = jQuery.trim( jQuery("#degreeDate_"+ctr).val() );
		var gpa = jQuery.trim( jQuery("#GPA_"+ctr).val() );
		var lastAttendenceDate = jQuery.trim( jQuery("#lastAttendenceDate_"+ctr).val() );
		var errorInCurrentRow = false;
		var errorStringCurrentRow = "";
		
		//If there is only 1 row, ensure that it is not blank
		if( noOfRows == 0 && ( degree == 'NA' && major == '' && completionDate == '' && gpa == '' && lastAttendenceDate == '' ) ) {
			jQuery("#insDegree_"+ctr).addClass( "redBorder" );
			jQuery("#degreeDate_"+ctr).addClass( "redBorder" );
			jQuery("#GPA_"+ctr).addClass( "redBorder" );
			jQuery("#lastAttendenceDate_"+ctr).addClass( "redBorder" );
			errorFound = true;
			errorString = errorString + "Institution 1 : Enter the degree details"+'\n';
		}

		
		//If this is the last row which is completely blank, ignore.
		if( ctr == noOfRows && ( degree == 'NA' && major == '' && completionDate == '' && gpa == '' && lastAttendenceDate == '') ) {
			continue;
		}

		//GPA cannot be blank. it should be a number
		if( gpa == '' || isNaN(gpa)) {
			errorFound = true;
			errorInCurrentRow = true;
			jQuery("#GPA_"+ctr).addClass( "redBorder" );
			errorStringCurrentRow = errorStringCurrentRow + "GPA (number)" + '\t';
		}

		//If degree != NA, then completion date cannot be blank
		//if( degree != 'NA' && completionDate == '' ) {
		if( completionDate == '' ) {
			errorFound = true;
			errorInCurrentRow = true;
			jQuery("#degreeDate_"+ctr).addClass( "redBorder" );
			errorStringCurrentRow = errorStringCurrentRow + "Degree date" + '\t';
		}
		if( lastAttendenceDate == '' ) {
			errorFound = true;
			errorInCurrentRow = true;
			jQuery("#lastAttendenceDate_"+ctr).addClass( "redBorder" );
			errorStringCurrentRow = errorStringCurrentRow + "Attendence date" + '\t';
		}
		if(errorInCurrentRow){
			errorString = errorString + "Institution "+ (ctr+1) + '\t' + errorStringCurrentRow + '\n';
		}
	}

	

	if( errorFound == true ) {
		if(errorString != ""){
			errorString = "The following information is required :"+'\n\n' + errorString;
			alert( errorString );
			return false;
		}

	}
	if(jQuery("#zipcode1").is(":visible") && jQuery("#zipcode2").is(":visible"))
		jQuery("#zipcode").val(jQuery("#zipcode1").val()+jQuery("#zipcode2").val());
	
	document.selectInstitutionForm.noOfRows.value=jQuery("#addInstitutionTbl").attr('rows').length-1;
	document.selectInstitutionForm.saveInstitution.disabled = true;
	document.selectInstitutionForm.submit();
	
} */
var errorForDegree;
var errorString;
function loadInstitutionDegreeKeyRow(degreeTblId,fomDegreeId){
	if(validateAllDeggreeRow(degreeTblId,fomDegreeId)){
		alert("Please enter all required fields");
		return false;
	}else{
		jQuery(":input").removeClass( "redBorder" );
	}
	var getIndexNo = jQuery("#"+degreeTblId+" tr:last" ).attr("id").split("_");
	var index = parseInt(getIndexNo[1]) + 1;
	
	var gcuDegrees ="";
	<c:forEach items="${gCUDegreeList}" var="gcuDegree">
		gcuDegrees = gcuDegrees + "<option value='${gcuDegree.degree }'>${gcuDegree.degree }</option>";
	</c:forEach>
	var tableIdFindDegree = '"'+degreeTblId+'"';
	
	var appendDegreeText = "<tr id='degreeRow_"+index+"'>"+
					    "<td>"+
						    "<select id='insDegree_"+index+"' class='w230 required valid' name='studentInstitutionDegreeSet["+index+"].institutionDegree.degree' onchange='javascript:markUnMarkDisabled("+index+","+tableIdFindDegree+");'>"+
						      "<option value='No Degree'>No Degree</option>"+gcuDegrees+
						    "</select>"+
						    "</td>"+	    
					    "<td><input type='text' id='major_"+index+"' name='studentInstitutionDegreeSet["+index+"].major' class='textField w80' disabled='disabled'></td>"+
					    "<td><input type='text' id='degreeDate_"+index+"' name='studentInstitutionDegreeSet["+index+"].completionDate'  class='dgCompletionDate textField w100 maskDate'></td>"+
					    "<td><input type='text' id='GPA_"+index+"' name='studentInstitutionDegreeSet["+index+"].gpa' value='0.00' onblur='assignDefaultVal(this);' class='textField w80px number required'><a href='javaScript:void(0);' class='removeIcon fr mt5 removeInstitutionRow'></td></tr>";
	//alert(jQuery("#degreeTblId tr:last" ).attr("id"));
	
	jQuery("#"+degreeTblId+" tr:last" ).after(appendDegreeText);	
	settingMaskInput();
}

function validateDeggreeRow(degreeTblId,fomDegreeId){
	var getvalidateIndexNo = jQuery("#"+degreeTblId+" tr:last" ).attr("id").split("_");
	var index = parseInt(getvalidateIndexNo[1]);
	var degree = jQuery("#"+fomDegreeId+" input[id=insDegree_"+index+"]").val();
	
	var major = jQuery.trim( jQuery("#"+fomDegreeId+" input[id=major_"+index+"]").val() );
	var completionDate = jQuery.trim( jQuery("#"+fomDegreeId+" input[id=degreeDate_"+index+"]").val() );
	var gpa = jQuery.trim( jQuery("#"+fomDegreeId+" input[id=GPA_"+index+"]").val() );
	var errorFoundForDegree = false;
	errorForDegree = "";
	
	
	if(degree == 'No Degree' && (major == '' || completionDate == '')) {
		errorFoundForDegree = true;
		
	}
	if(degree != 'No Degree' && (major == '' || completionDate == '')) {
		errorFoundForDegree = true;
		errorForDegree = errorForDegree + "Institution : Enter the degree details"+'\n';
	}if(degree != 'No Degree' && major == ''){
		errorFoundForDegree = true;
		jQuery("#"+fomDegreeId+" input[id=major_"+index+"]").addClass( "redBorder" );
		errorForDegree = errorForDegree + "\t \t Degree Major\n";
	}
	if(degree != 'No Degree' && completionDate == '' ) {
		jQuery("#"+fomDegreeId+" input[id=degreeDate_"+index+"]").addClass( "redBorder" );
		errorForDegree = errorForDegree + "\t \t Degree date" + '\n';
	}
	if( gpa != '' && isNaN(gpa)) {
		errorFoundForDegree = true;
		jQuery("#"+fomDegreeId+" input[id=GPA_"+index+"]").addClass( "redBorder" );
		errorForDegree = errorForDegree + "\t \t GPA (number)" + '\t';
	}
		return errorFoundForDegree;	
} 
function validateAllDeggreeRow(degreeTblId,fomDegreeId){
	if(jQuery("#"+degreeTblId+" tr" ).length > 1){

	var tableNoOfTr = parseInt(jQuery("#"+degreeTblId+" tr:last" ).attr("id").split("_")[1]);
	var errorFoundForDegree = false;
	errorForDegree = "Institution : Enter the degree details"+'\n';
	for(var index=0;index<=tableNoOfTr;index++){
		
		var degree = jQuery("#"+degreeTblId+" #insDegree_"+index).find("option:selected").val();
		var major = jQuery.trim( jQuery("#"+degreeTblId+" #major_"+index).val() );
		var completionDate = jQuery.trim( jQuery("#"+degreeTblId+" #degreeDate_"+index).val() );
		var gpa = jQuery.trim( jQuery("#"+degreeTblId+" #GPA_"+index).val() );
		
		var trRowCounter = index + 1;
		if(degree != undefined){
			if(degree == 'No Degree' && (major == '' || completionDate == '')) {
				errorFoundForDegree = false;			
			}
			if(degree != 'No Degree' && (major == '' || completionDate == '')) {
				errorFoundForDegree = true;
				errorForDegree = errorForDegree +'in row # '+trRowCounter;
			}if(degree != 'No Degree' && major == ''){
				errorFoundForDegree = true;
				jQuery("#"+fomDegreeId+" input[id=major_"+index+"]").addClass( "redBorder" );
				errorForDegree = errorForDegree + "\t \t Degree Major\n";
			}
			if(degree != 'No Degree' && completionDate == '' ) {
				jQuery("#"+fomDegreeId+" input[id=degreeDate_"+index+"]").addClass( "redBorder" );
				errorForDegree = errorForDegree + "\t \t Degree date" + '\n';
			}
			if( gpa != '' && isNaN(gpa)) {
				errorFoundForDegree = true;
				jQuery("#"+fomDegreeId+" input[id=GPA_"+index+"]").addClass( "redBorder" );
				errorForDegree = errorForDegree + "\t \t GPA (number)" + '\t';
			}
		}
	}
	for(var index=0;index<=tableNoOfTr;index++){
		
		var degree = jQuery("#"+degreeTblId+" #insDegree_"+index).find("option:selected").val();
		var major = jQuery.trim( jQuery("#"+degreeTblId+" #major_"+index).val() );
		var completionDate = jQuery.trim( jQuery("#"+degreeTblId+" #degreeDate_"+index).val() );
		var gpa = jQuery.trim( jQuery("#"+degreeTblId+" #GPA_"+index).val() );
		
		var trRowCounter = index + 1;
		if(degree != undefined){
			if(degree == 'No Degree' && (major == '' || completionDate == '')) {
				errorFoundForDegree = false;			
			}
			if(degree != 'No Degree' && (major == '' || completionDate == '')) {
				errorFoundForDegree = true;
			}if(degree != 'No Degree' && major == ''){
				errorFoundForDegree = true;
			}
			if(degree != 'No Degree' && completionDate == '' ) {
				jQuery("#"+fomDegreeId+" input[id=degreeDate_"+index+"]").addClass( "redBorder" );
			}
			if( gpa != '' && isNaN(gpa)) {
				errorFoundForDegree = true;
			}
			if(errorFoundForDegree == true){
				break;
			}
		}
	}
	
		return errorFoundForDegree;	
	}else{
		return false;	
	}
}
 
//Validate the Transfer Course form
function validateTransferCourses(courseIndex,formIdForValidation) {
	
	var errorFound = false;
	var dateExceed = false;

	errorString = '';
	
		var courseId = jQuery.trim( jQuery("#"+formIdForValidation+" input[id=trCourseId_"+courseIndex+"]").val() );
		var courseTitle = jQuery.trim( jQuery("#"+formIdForValidation+" input[id=trCourseTitle_"+courseIndex+"]").val() );
		var courseGrade = jQuery.trim( jQuery("#"+formIdForValidation+" input[id=trCourseGrade_"+courseIndex+"]").val() );
		var courseCredit = jQuery.trim( jQuery("#"+formIdForValidation+" input[id=trCourseCredits_"+courseIndex+"]").val() );
		var completionDate = jQuery.trim( jQuery("#"+formIdForValidation+" input[id=trCourseCompletionDate_"+courseIndex+"]").val() );
		var clockHours = jQuery.trim( jQuery("#"+formIdForValidation+" input[id=trClockHours_"+courseIndex+"]").val() );
		// latest degree completion date
		var maxDegCompletionDate = jQuery("#"+formIdForValidation+" .dgCompletionDate").first().val();
		if(maxDegCompletionDate != ''){
			jQuery("#"+formIdForValidation+" .dgCompletionDate").each(function(){
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
			jQuery("#"+formIdForValidation+" input[id=trCourseCompletionDate_"+courseIndex+"]").addClass( "redBorder" );
		}

		if( courseId == '' ) {
			errorFound = true;
			errorInCurrentRow = true;
			jQuery("#"+formIdForValidation+" input[id=trCourseId_"+courseIndex+"]").addClass( "redBorder" );
			errorStringForCourse = errorStringForCourse + "TR Course ID" + '\t';
		}
		if( courseTitle == '' ) {
			errorFound = true;
			errorInCurrentRow = true;
			jQuery("#"+formIdForValidation+" input[id=trCourseTitle_"+courseIndex+"]").addClass( "redBorder" );
			errorStringForCourse = errorStringForCourse + "TR Course Title" + '\t';
		}
		if( courseGrade == '' ) {
			errorFound = true;
			errorInCurrentRow = true;
			jQuery("#"+formIdForValidation+" input[id=trCourseGrade_"+courseIndex+"]").addClass( "redBorder" );
			errorStringForCourse = errorStringForCourse + "Grade" + '\t';
		}

		if ( (courseCredit == '' || isNaN(courseCredit)) && (clockHours == '' || isNaN(clockHours))) {
			errorFound = true;
			errorInCurrentRow = true;
			jQuery("#"+formIdForValidation+" input[id=trCourseCredits_"+courseIndex+"]").addClass( "redBorder" );
			jQuery("#"+formIdForValidation+" input[id=trClockHours_"+courseIndex+"]").addClass( "redBorder" );
			errorStringForCourse = errorStringForCourse + "Credits(Non zero)" + '\t';
		}
		
		if(errorInCurrentRow){
			errorString = errorString + "row #"+ (courseIndex+1) + '\t' + errorStringForCourse + '\n';
		}
	

	//document.transferCourseForm.coursesAdded.value=jQuery("#transferCourseTbl").attr('rows').length-1;
	/* if(${(studentInstitutionTranscript.evaluationStatus == 'REJECTED INSTITUTION'||studentInstitutionTranscript.evaluationStatus == 'REJECTED')}){
		var valueRejected= verifyRejected();
		if(valueRejected==false){
			return false;
		}
	} */
	
	if( errorFound == true ) {
		return false;
	}
	else if(dateExceed==true){
		/*var r2 = false;
		var r1 =  confirm("Course completion date is greater than the degree completion date."+'\n\n\n\t\t\t\t'+"Press 'OK' if you wish to continue");
		if(r1 == true){
			r2 = confirm("Once the transcript is completed no further editing will be allowed."+'\n\n\n\t\t\t\t'+"Press 'OK' if you wish to continue");
			return r2;
		}
		else{
			return r1;
		}*/
	}
	return true;
	
	//return confirm("Once the transcript is completed no further editing will be allowed."+'\n\n\n\t\t\t\t'+"Press 'OK' if you wish to continue");
}
//Validate the Transfer Course form
function validateAllTransferCourses(courseTableId,formIdForValidation) {
		var tableNoOfTr = parseInt(jQuery("#"+courseTableId+" tr:last" ).attr("id").split("_")[1]);
		var errorFound = false;
		var dateExceed = false;

		errorString = '';
		var maxDegCompletionDate = jQuery("#"+formIdForValidation+" .dgCompletionDate").first().val();
		if(maxDegCompletionDate!= undefined && maxDegCompletionDate != ''){
			jQuery("#"+formIdForValidation+" .dgCompletionDate").each(function(){
					if(jQuery(this).val()!='' && cmpDate(maxDegCompletionDate,jQuery(this).val())>0){
						maxDegCompletionDate = jQuery(this).val();
					}
			});
		}
		for(var courseIndex=0;courseIndex<=tableNoOfTr;courseIndex++){
			
			var courseId = jQuery.trim( jQuery("#"+courseTableId+" #trCourseId_"+courseIndex).val() );
			var courseTitle = jQuery.trim( jQuery("#"+courseTableId+" #trCourseTitle_"+courseIndex).val() );
			var courseGrade = jQuery.trim( jQuery("#"+courseTableId+" #trCourseGrade_"+courseIndex).val() );
			var courseCredit = jQuery.trim( jQuery("#"+courseTableId+" #trCourseCredits_"+courseIndex).val() );
			var completionDate = jQuery.trim( jQuery("#"+courseTableId+" #trCourseCompletionDate_"+courseIndex).val() );
			var clockHours = jQuery.trim( jQuery("#"+courseTableId+" #trClockHours_"+courseIndex).val() );
						
			if(jQuery("#"+courseTableId+" #trCourseId_"+courseIndex).val() != undefined){
				var errorInCurrentRow = false;
				var errorStringForCourse = "";
					if( completionDate == '' ||(maxDegCompletionDate!= undefined && maxDegCompletionDate!='' && completionDate!='' && cmpDate(completionDate, maxDegCompletionDate)<0)) {
						if(completionDate == ''){
							errorFound = true;
							errorInCurrentRow = true;
							errorStringForCourse = errorStringForCourse + "Completion Date" + '\t\t';
						}
						else if(maxDegCompletionDate!= undefined && cmpDate(completionDate, maxDegCompletionDate)<0){
							dateExceed = true;
						}
						jQuery("#"+formIdForValidation+" input[id=trCourseCompletionDate_"+courseIndex+"]").addClass( "redBorder" );
					}
			
					if( courseId == '' ) {
						errorFound = true;
						errorInCurrentRow = true;
						jQuery("#"+formIdForValidation+" input[id=trCourseId_"+courseIndex+"]").addClass( "redBorder" );
						errorStringForCourse = errorStringForCourse + "TR Course ID" + '\t';
					}
					if( courseTitle == '' ) {
						errorFound = true;
						errorInCurrentRow = true;
						jQuery("#"+formIdForValidation+" input[id=trCourseTitle_"+courseIndex+"]").addClass( "redBorder" );
						errorStringForCourse = errorStringForCourse + "TR Course Title" + '\t';
					}
					if( courseGrade == '' ) {
						errorFound = true;
						errorInCurrentRow = true;
						jQuery("#"+formIdForValidation+" input[id=trCourseGrade_"+courseIndex+"]").addClass( "redBorder" );
						errorStringForCourse = errorStringForCourse + "Grade" + '\t';
					}
			
					if ( (courseCredit == '' || isNaN(courseCredit)) && (clockHours == '' || isNaN(clockHours))) {
						errorFound = true;
						errorInCurrentRow = true;
						jQuery("#"+formIdForValidation+" input[id=trCourseCredits_"+courseIndex+"]").addClass( "redBorder" );
						jQuery("#"+formIdForValidation+" input[id=trClockHours_"+courseIndex+"]").addClass( "redBorder" );
						errorStringForCourse = errorStringForCourse + "Credits(Non zero)" + '\t';
					}
					
					if(errorInCurrentRow){
						errorString = errorString + "row #"+ (courseIndex+1) + '\t' + errorStringForCourse + '\n';
					}
				
				else if(dateExceed==true){
					
				}
			}
	}
	if( errorFound == true ) {
		return false;
	}
	return true;
	
	//return confirm("Once the transcript is completed no further editing will be allowed."+'\n\n\n\t\t\t\t'+"Press 'OK' if you wish to continue");
}

function validateTranscriptCredit(courseTableIdForCredit,formIdForValidateCredit){
	var tableNoOfTr = parseInt(jQuery("#"+courseTableIdForCredit+" tr:last" ).attr("id").split("_")[1]);
	var notANumberFlag = false;
	for(var courseIndex=0;courseIndex<=tableNoOfTr;courseIndex++){		
		var courseCredit = jQuery.trim( jQuery("#"+courseTableIdForCredit+" input[id=trCourseCredits_"+courseIndex+"]").val() );
		if (isNaN(courseCredit)) {
			jQuery("#"+courseTableIdForCredit+" input[id=trCourseCredits_"+courseIndex+"]").addClass( "redBorder" );
			notANumberFlag = true;
			break;
		}
	}
	if(notANumberFlag){
		return false;
	}else{
		return true;
	}
}


function addCourseRow1(tableIdToAppendCourse,transcriptEvalStatus,formId) {
		//var noOfRows = jQuery("#transferCourseTbl").attr('rows').length;
		var courseRowId ="";
		var getvalidateIndexNoForCourse ="";
		var courseIndex ="";
		var index = "";
		var pd1 = "";
		courseRowId = jQuery("#"+tableIdToAppendCourse+" tr:last").attr("id");
		if(courseRowId == undefined){
			index = 0;
			courseIndex = 0;
		}else{
			courseRowId = jQuery("#"+tableIdToAppendCourse+" tr:last").attr("id").split("_");
			index = parseInt(courseRowId[1]) + 1;
			courseIndex = parseInt(courseRowId[1]);
		}
		
		//index = noOfRows - 1;
		if( index == -1 ) {
			index = 0;
			
		}
		//var getvalidateIndexNoForCourse = jQuery("#transferCourseTbl tr:last" ).attr("id").split("_");
		//var courseIndex = parseInt(getvalidateIndexNoForCourse[1]);
		//alert(courseIndex);
		if(courseRowId != undefined && validateTransferCourses(courseIndex,formId) == false) {
			alert("Please enter all required fields");
			return;
		}else{
			jQuery("#"+formId+" :input").removeClass( "redBorder" );
		}
		if(index > 0){
				 pd1 = jQuery("#"+formId+" input[id=trCourseCompletionDate_"+(index-1)+"]").val();					
		}
		
		var tableIdFindCourse = '"'+tableIdToAppendCourse+'"';
		var formIdFindCourse = '"'+formId+'"';
			var appendText = "<tr id='courseRow_"+index+"'>"+
						    "<td>"+
						    	"<span class='dateReceived'>"+
						      		"<input type='text' onblur='javaScript:getInstitutionTermType("+formIdFindCourse+",this);' name='studentTranscriptCourse["+index+"].completionDate' id='trCourseCompletionDate_"+index+"' value='"+pd1+"' class='textField w70 maskDate required' />"+
						    	"</span>"+
						    "</td>"+
						    "<td>"+
						    	"<input type='hidden' name='hasUnsavedValues_"+index+"' id='hasUnsavedValues_"+index+"' value='1' />"+
						    	"<input type='hidden'  id='transcriptStatus_"+index+"' name='studentTranscriptCourse["+index+"].transcriptStatus' value='' />"+
						    	"<input type='hidden' id='transcriptEvaluationStatus_"+index+"' name='studentTranscriptCourse["+index+"].evaluationStatus'   value='' />"+
						    	"<input type='text' name='studentTranscriptCourse["+index+"].trCourseId' id='trCourseId_"+index+"' class='textField w70 required'  onblur='javascript:findCourseDetails("+index+","+tableIdFindCourse+","+formIdFindCourse+", this.value);'/>"+
						    "</td>"+
						    "<td>"+
								"<input type='text' name='studentTranscriptCourse["+index+"].transferCourseTitle.title' id='trCourseTitle_"+index+"' class='textField w110 mr10 required' maxlength='75' onkeyup='javaScript:titleLimit(this);'/>"+ 
						    	"<select class='titleselect w90' name='trCourseTitleSelect_"+index+"' disabled='disabled'  id='trCourseTitleSelect_"+index+"' onchange='fillTitle(this,"+tableIdFindCourse+");'>"+			    	
						      		"<option>Select Title</option>"+
						    	"</select>"+
						    "</td>"+
						    "<td align='left'><input type='text' name='studentTranscriptCourse["+index+"].grade' id='trCourseGrade_"+index+"' class='textField w40 required' />"+
							    /* "<select name='studentTranscriptCourse["+index+"].grade' id='trCourseGrade_"+index+"' class='w50px required valid' onchange='valuesChanged(this);'>"+
				            		"<option value=''></option>"+ 
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
				                "</select>"+ */
						    "</td>"+
						    "<td align='center'><input type='text' name='studentTranscriptCourse["+index+"].transferCourse.transcriptCredits' id='trCourseCredits_"+index+"' onblur='javaScript:getInstitutionTermType("+formIdFindCourse+",this);' class='textField w30 required' /></td>"+
						    "<td align='center'><input type='text' name='studentTranscriptCourse["+index+"].transferCourse.clockHours'   id='trClockHours_"+index+"' class='textField w30 required' onblur='javaScript:getCourseType(this);'/></td>"+
						    "<td align='center'><input type='text' name='studentTranscriptCourse["+index+"].transferCourse.semesterCredits' id='trSemCredits_"+index+"' readonly='readonly' class='textField w33 required' /></td>"+
						    
						    "<td id='studentTranscriptCourseTranscriptStatus_"+index+"'></td>"+
						    "<td id='studentTranscriptCourseEvaluationStatus_"+index+"'></td>"+
						    "<td><a href='javaScript:void(0);' id='removeRow_"+index+"' class='removeIcon fr removeRow'></a></td>"+
					   "</tr>";
			
            // for the case of rejected transcript extra td should be added under checkbox header
			 if(transcriptEvalStatus == 'REJECTED'){
				appendText = 
					"<tr id='courseRow_"+index+"'>"+
				    "<td>"+
				    	"<span class='dateReceived'>"+
				      		"<input type='text' onblur='javaScript:getInstitutionTermType("+formIdFindCourse+",this);' name='studentTranscriptCourse["+index+"].completionDate' id='trCourseCompletionDate_"+index+"' value='"+pd1+"' class='textField w70 maskDate required' />"+
				    	"</span>"+
				    "</td>"+
				    "<td>"+
				    	"<input type='hidden' name='hasUnsavedValues_"+index+"' id='hasUnsavedValues_"+index+"' value='1' />"+
				    	"<input type='hidden'  id='transcriptStatus_"+index+"' name='studentTranscriptCourse["+index+"].transcriptStatus' value='' />"+
				    	"<input type='hidden' name='studentTranscriptCourse["+index+"].evaluationStatus' id='transcriptEvaluationStatus_"+index+"'  value='' />"+
				    	"<input type='text' name='studentTranscriptCourse["+index+"].trCourseId' id='trCourseId_"+index+"' class='textField w70 required'  onblur='javascript:findCourseDetails("+index+","+tableIdFindCourse+","+formIdFindCourse+", this.value);'/>"+
				    "</td>"+
				    "<td>"+
						"<input type='text' name='studentTranscriptCourse["+index+"].transferCourseTitle.title' id='trCourseTitle_"+index+"' class='textField w110 mr10 required' maxlength='75' onkeyup='javaScript:titleLimit(this);'/>"+ 
				    	"<select class='titleselect w90' name='trCourseTitleSelect_"+index+"' disabled='disabled' id='trCourseTitleSelect_"+index+"' onchange='fillTitle(this,"+tableIdFindCourse+");'>"+			    	
				      		"<option>Select Title</option>"+
				    	"</select>"+
				    "</td>"+
				    "<td align='left'><input type='text' name='studentTranscriptCourse["+index+"].grade' id='trCourseGrade_"+index+"' class='textField w40 required' />"+
					   /*  "<select name='studentTranscriptCourse["+index+"].grade' id='trCourseGrade_"+index+"' class='w50px required valid' onchange='valuesChanged(this);'>"+
		            		"<option value=''></option>"+ 
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
		                "</select>"+ */
				    "</td>"+
				    "<td align='center'><input type='text' name='studentTranscriptCourse["+index+"].transferCourse.transcriptCredits' id='trCourseCredits_"+index+"' onblur='javaScript:getInstitutionTermType("+formIdFindCourse+",this);' class='textField w30 required' /></td>"+
				    "<td align='center'><input type='text' name='studentTranscriptCourse["+index+"].transferCourse.clockHours'   id='trClockHours_"+index+"' class='textField w30 required' onblur='javaScript:getCourseType(this);'/></td>"+
				    "<td align='center'><input type='text' name='studentTranscriptCourse["+index+"].transferCourse.semesterCredits' id='trSemCredits_"+index+"' class='textField w33 required' readonly='readonly' /></td>"+
				    "<td id='studentTranscriptCourseTranscriptStatus_"+index+"'></td>"+
				    "<td id='studentTranscriptCourseEvaluationStatus_"+index+"'></td>"+
				    "<td></td>"+
				    "<td><a href='javaScript:void(0);' id='removeRow_"+index+"' class='removeIcon fr removeRow'></a></td>"+
			   "</tr>";
				
			} 
			//jQuery("#removeRowTd_"+(index-1)).html( "" );
			
            jQuery("#"+tableIdToAppendCourse+" tr:last").after(appendText);           
			settingMaskInput();
			jQuery('#trCourseCompletionDate_'+index).focus();
			autoCompleteCourse();	
}
function submitTranscript(actionUrl,buttonName,newTranscriptFormId,trCourseTblId,degreeTblId){
			
	var rowCountOfTable = jQuery('#'+trCourseTblId+' tr').length;
	 var isDuplicateDegree=false;
	jQuery("#transferCourseForm select[id^=insDegree_]").each(function() {
		 var instance0 = jQuery(this).attr("id");
		 var selectedValue0 = jQuery("#"+instance0+" option:selected").text();
		
		  jQuery("#transferCourseForm select[id^=insDegree_]").each(function() {
			  
			  var instance1 = jQuery(this).attr("id");
			  var selectedValue1 = jQuery("#"+instance1+" option:selected").text();
			  
			  outerLoop:
			  if(jQuery(this).attr("id") != instance0 && selectedValue0 == selectedValue1){
				  jQuery(this).addClass( "redBorder" );
				  isDuplicateDegree = true;
				  break outerLoop;
			  }
		  });
	  });
	  if(isDuplicateDegree == true){
		  alert("Please remove multiple 'No Degree' from Degree block, only one 'No Degree' is allowed.");
		  return false;
	  }
		
	var degreeError = validateAllDeggreeRow(degreeTblId,newTranscriptFormId);
	if(degreeError == true){
		alert("Please enter all required fields");
		return false;
	} 
			
   if(rowCountOfTable>1){		
			var completionDate = jQuery.trim( jQuery("#"+newTranscriptFormId+" input[id^=trCourseCompletionDate_]").first().val() );
		    // latest degree completion date
		    var maxDegCompletionDate = jQuery("#"+newTranscriptFormId+" .dgCompletionDate").first().val();
		    if(maxDegCompletionDate!= undefined && maxDegCompletionDate != ''){
		    	jQuery("#"+newTranscriptFormId+" .dgCompletionDate").each(function(){
		                      if(jQuery(this).val()!='' && cmpDate(maxDegCompletionDate,jQuery(this).val())>0){
		                            maxDegCompletionDate = jQuery(this).val();
		                      }
		          });
		    }
		    
		    
		    var courseId=jQuery(jQuery("#"+newTranscriptFormId+" input[id^=trCourseCompletionDate_]").first()).attr('id');
		    if(completionDate != ''){
		    	jQuery("#"+newTranscriptFormId+" input[id^=trCourseCompletionDate_]").each(function(){
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
		      jQuery("#"+newTranscriptFormId+" input[id^=trCourseId_]").each(function() {
				 	var $current =jQuery(this);
				 	 var currentIdIndex=	$current.attr('id').split('_')[1];
				 	jQuery("#"+newTranscriptFormId+" input[id^=trCourseId_]").each(function() {
			    	   
			    	    var thisIdIndex=jQuery(this).attr('id').split('_')[1];
			    	  //  alert(jQuery(this).attr('id')+"=="+thisIdIndex +"----"+$current.attr('id')+"=="+currentIdIndex);
			    	    var thisDate=jQuery("#"+newTranscriptFormId+" input[id=trCourseCompletionDate_"+thisIdIndex+"]").val();
			    	    var currentDate=jQuery("#"+newTranscriptFormId+" input[id=trCourseCompletionDate_"+currentIdIndex+"]").val();
			    	    var thisGrade=jQuery("#"+newTranscriptFormId+" input[id=trCourseGrade_"+thisIdIndex+"]").val();
			    	    var currentGrade=jQuery("#"+newTranscriptFormId+" input[id=trCourseGrade_"+currentIdIndex+"]").val();
		    	        if (jQuery(this).val().toUpperCase() == $current.val().toUpperCase() && jQuery(this).attr('id') != $current.attr('id') 
		    	        		&& thisDate==currentDate && thisGrade==currentGrade)
		    	        {
		    	            //alert('duplicate found!');
		    	            $current.addClass( "redBorder" );
		    	            courseCode=jQuery(this).val().toUpperCase();
		    	            courseDate=thisDate;
		    	            isDuplicate=true;
		    	            return 1 ;
		    	        }else if(jQuery(this).val().toUpperCase() == $current.val().toUpperCase() && jQuery(this).attr('id') != $current.attr('id') && 
		    	        		thisDate==currentDate && thisGrade!=currentGrade){
		    	        	$current.addClass( "redBorder" );
		     	            courseCode=jQuery(this).val().toUpperCase();
		     	           isDuplicateDifDate=true;
		     	            return 1 ;
		    	        }
		
		    	    });
		    	   
		    	  });
		      var lastcourseRowId = jQuery("#"+trCourseTblId+" tr:last").attr("id");
		      var lastCurrentRow = 0;
				if(lastcourseRowId == undefined){
					lastCurrentRow = 0;
				}else{
					var courseRowId = jQuery("#"+trCourseTblId+" tr:last").attr("id").split("_");
					lastCurrentRow = parseInt(courseRowId[1]);
				}				
			    if(rowCountOfTable==2 && jQuery("#trCourseCompletionDate_"+lastCurrentRow).val() =='' && jQuery("#trCourseId_"+lastCurrentRow).val() =='' && jQuery("#trCourseTitle_"+lastCurrentRow).val() == '' && jQuery("#trCourseGrade_"+lastCurrentRow).val() ==''){ 
			    	if(jQuery("#trClockHours_"+lastCurrentRow).val() == ''){
			    		jQuery("#trClockHours_"+lastCurrentRow).val('0');
			    	}
			    }else{
			    	if(validateAllTransferCourses(trCourseTblId,newTranscriptFormId)==false){
				    	/* if(errorString != ''){
							alert("following information is required :"+'\n\n'+errorString);
						} */
						alert("Please enter all required fields.");
				    	errorGot=false;
				    	return;
				    }   	  
			      	if(validateTranscriptCredit(trCourseTblId,newTranscriptFormId)==false){
						alert("Please fill only numeric value in Credits.");
			      		return;
			      	}	
			    }
		      if(isDuplicate){
		    	  alert("Course "+courseCode+" with date completed "+courseDate+" already exists on this student's transcript. Please modify the course completion date if the student completed the course more than once.");
		      	  return 0;
		      }
		      if(isDuplicateDifDate){
		    	  var r1 =    confirm("Course "+courseCode+" already exists on the student's transcript, please verify that it should be added more than once");
		    	  if (!r1)
		      	  	return 0;
		      }
		      if(errorGot==false)
		    	  return ;
		      
		      jQuery("#"+newTranscriptFormId+" input[id^=trCourseCompletionDate_]").removeClass( "redBorder" );
		    if(completionDate!='' && maxDegCompletionDate != undefined && maxDegCompletionDate!=''){
		    	if(cmpDate(completionDate, maxDegCompletionDate)<0){
		                jQuery("#"+courseId).addClass( "redBorder" );
		                var r1 =  confirm("Course completion date is greater than the degree completion date."+'\n\n\n\t\t\t\t'+"Press 'OK' if you wish to continue");
		                if(r1 == true){
		                	jQuery("#"+newTranscriptFormId+" :input").removeClass( "redBorder" );
		                      document.transferCourseForm.action = actionUrl;
		                      document.transferCourseForm.submit();
		                      jQuery('#saveInstitutionDegree').attr("disabled", true);
		          			  jQuery('#MarkComplete').attr("disabled", true);
		                }else{
		                      return 0;
		                }
		                
		    	}
		    }
		   document.transferCourseForm.action = actionUrl;
	       document.transferCourseForm.submit();
	       jQuery('#saveInstitutionDegree').attr("disabled", true);
	       jQuery('#MarkComplete').attr("disabled", true);
 }else{
          document.transferCourseForm.action = actionUrl;
          document.transferCourseForm.submit();
          jQuery('#saveInstitutionDegree').attr("disabled", true);
          jQuery('#MarkComplete').attr("disabled", true);
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
</script>
<script type="text/javascript">
function submitRejectedTranscript(actionUrl,divIdToRefer,formId,buttonId,courseTblId,degreeTblId){
	var rowCountOfTable = jQuery('#'+courseTblId+' tr').length;
	if(rowCountOfTable<=1){
		alert("Atleast one course require to be added");
		return false;
	}
    var completionDate = jQuery.trim( jQuery("#"+formId+" input[id^=trCourseCompletionDate_]").first().val() );
    // latest degree completion date
    var maxDegCompletionDate = jQuery("#"+formId+" .dgCompletionDate").first().val();
    if(maxDegCompletionDate!= undefined && maxDegCompletionDate != ''){
    	jQuery("#"+formId+" .dgCompletionDate").each(function(){
                      if(jQuery(this).val()!='' && cmpDate(maxDegCompletionDate,jQuery(this).val())>0){
                            maxDegCompletionDate = jQuery(this).val();
                      }
          });
    }
    //alert("maxDegCompletionDate="+maxDegCompletionDate);
    var degreeError = validateAllDeggreeRow(degreeTblId,formId);
	if(degreeError == true){
		alert(errorForDegree);
		return false;
	}
    var courseId=jQuery(jQuery("#"+formId+" input[id^=trCourseCompletionDate_]").first()).attr('id');
    if(completionDate != ''){
    	jQuery("#"+formId+" input[id^=trCourseCompletionDate_]").each(function(){
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
      jQuery("#"+formId+" input[id^=trCourseId_]").each(function() {
		 	var $current =jQuery(this);
		 	 var currentIdIndex=	$current.attr('id').split('_')[1];
		 	jQuery("#"+formId+" input[id^=trCourseId_]").each(function() {
	    	   
	    	    var thisIdIndex=jQuery(this).attr('id').split('_')[1];
	    	  //alert(jQuery(this).attr('id')+"=="+thisIdIndex +"----"+$current.attr('id')+"=="+currentIdIndex);
	    	    var thisDate=jQuery("#"+formId+" input[id=trCourseCompletionDate_"+thisIdIndex+"]").val();
	    	    var currentDate=jQuery("#"+formId+" input[id=trCourseCompletionDate_"+currentIdIndex+"]").val();
    	        if (jQuery(this).val().toUpperCase() == $current.val().toUpperCase() && jQuery(this).attr('id') != $current.attr('id') && thisDate==currentDate)
    	        {
    	           // alert('duplicate found!');
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
    	   
    	  });
      var lastcourseRowId = jQuery("#"+courseTblId+" tr:last").attr("id");
      //alert("lastcourseRowId="+lastcourseRowId);
      var lastCurrentRow = 0;
		if(lastcourseRowId == undefined){
			lastCurrentRow = 0;
		}else{
			var courseRowId = jQuery("#"+courseTblId+" tr:last").attr("id").split("_");
			lastCurrentRow = parseInt(courseRowId[1]);
		}
	    
	    if(validateTransferCourses(lastCurrentRow,formId)==false){
	    	if(errorString != ''){
				alert("following information is required :"+'\n\n'+errorString);
			}
	    	errorGot=false;
	    	return;
	    }   	  
	   // alert("isDuplicate="+isDuplicate);
      
      if(isDuplicate){
    	  alert("Course "+courseCode+" with date completed "+courseDate+" already exists on this student's transcript. Please modify the course completion date if the student completed the course more than once.");
      	  return 0;
      }
     // alert("isDuplicateDifDate="+isDuplicateDifDate);
      if(isDuplicateDifDate){
    	  var r1 =    confirm("Course "+courseCode+" already exists on the student's transcript, please verify that it should be added more than once");
    	  if (!r1)
      	  	return 0;
      }
      //alert("errorGot="+errorGot);
      if(errorGot==false)
    	  return ;
      
      jQuery("#"+formId+" input[id^=trCourseCompletionDate_]").removeClass( "redBorder" );
    if(completionDate!='' && maxDegCompletionDate!= undefined && maxDegCompletionDate!='' && cmpDate(completionDate, maxDegCompletionDate)<0){
                jQuery("#"+courseId).addClass( "redBorder" );
                var r1 =  confirm("Course completion date is greater than the degree completion date."+'\n\n\n\t\t\t\t'+"Press 'OK' if you wish to continue");
                if(r1 == true){
                	var found = checkForRejectedCoursesRectification(formId);
                	if(found == false){
                		jQuery("#"+formId+" :input").removeClass( "redBorder" );
                		var rj =  confirm("Please make sure you have rectified all the Rejected Courses ."+'\n\n\n\t\t\t\t'+"Press 'OK' if you are sure that you have rectified.");
                		if(rj == false){			
                			return 0;
                		}else{
                			jQuery("#"+formId).submit();
                			jQuery('#saveInstitutionDegree').attr("disabled", true);
                			jQuery('#MarkComplete').attr("disabled", true);
                			
                		}
                	}else{
                		alert("Please select all check boxes indicating that corrections have been made to the rejected courses.");
                	} 
                }else{
                      return 0;
                }
    }else{
    	var found2 = checkForRejectedCoursesRectification(formId);
    	if(found2 == false){
    		jQuery("#"+formId+" :input").removeClass( "redBorder" );
    		var rj2 =  confirm("Please make sure you have rectified all the Rejected Courses ."+'\n\n\n\t\t\t\t'+"Press 'OK' if you are sure that you have rectified.");
    		if(rj2 == false){			
    			return 0;
    		}else{
    			jQuery("#"+formId).submit();
    			jQuery('#saveInstitutionDegree').attr("disabled", true);
    			jQuery('#MarkComplete').attr("disabled", true);
    		}
    	}else{
    		alert("Please select all check boxes indicating that corrections have been made to the rejected courses.");
    	}
    }

}
// Javascript break from loop
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

function getInstitutionTermType(trCoursesFormId,elementToaccess){
	var currentRow = jQuery(elementToaccess).attr("id").split("_")[1];
	if(jQuery("#"+trCoursesFormId+" #trCourseCompletionDate_"+currentRow).val() !=''){
		jQuery.ajax({
			url: "<c:url value='/evaluation/launchEvaluation.html?operation=getInstitutionTermTypeForCourse&completionDate='/>"+jQuery("#"+trCoursesFormId+" #trCourseCompletionDate_"+currentRow).val()+"&institutionId="+jQuery("#"+trCoursesFormId+" #institutionId").val(),	
			dataType: "json", success:function(data){
				var semEqValue = parseInt(jQuery("#"+trCoursesFormId+" #trCourseCredits_"+currentRow).val());
				//alert(semEqValue);
				if(!isNaN(semEqValue)){					
					jQuery("#trSemCredits_"+currentRow).val("---");
					
					if("${studentInstitutionTranscript.institution.evaluationStatus}".toUpperCase() == "EVALUATED" && semEqValue != '' && data.termType != null && data.termType != '' && data.termType.name != null && data.termType.name !=''){
						if(data.termType.name == "Quarter"){
							semEqValue = parseFloat(semEqValue)*2/3;
							jQuery("#"+trCoursesFormId+" #trSemCredits_"+currentRow).val(semEqValue.toFixed(2));	
						}
						else if(data.termType.name == "4-1-4"){
							semEqValue = parseFloat(semEqValue)*4;
							jQuery("#"+trCoursesFormId+" #trSemCredits_"+currentRow).val(semEqValue.toFixed(2));
						}
						else if(data.termType.name == "Semester"){
							jQuery("#"+trCoursesFormId+" #trSemCredits_"+currentRow).val(semEqValue.toFixed(2));
						}
						else{
							jQuery("#"+trCoursesFormId+" #trSemCredits_"+currentRow).val("---");
						}
					}else{
						jQuery("#"+trCoursesFormId+" #trSemCredits_"+currentRow).val("---");
					}
				}else{
					jQuery("#"+trCoursesFormId+" #trSemCredits_"+currentRow).val("---");
				}
			},
			error: function(xhr, textStatus, errorThrown){
				jQuery("#"+trCoursesFormId+" #trSemCredits_"+currentRow).val("---");	
			}
		});
	}
}

function getCourseType(indexElementToAccess){

	var currentRow = jQuery(indexElementToAccess).attr("id").split("_")[1];
	if(jQuery("#trClockHours_"+currentRow).val() !=''){
		jQuery.ajax({
			url: "<c:url value='/evaluation/launchEvaluation.html?operation=getCourseType&institutionId='/>"+jQuery("#institutionId").val()+"&courseCode="+jQuery("#trCourseId_"+currentRow).val(),	
			dataType: "json", success:function(data){
				var semEqValue = parseInt(jQuery("#trClockHours_"+currentRow).val());
				//alert(semEqValue);
				if(!isNaN(semEqValue)){					
					jQuery("#trSemCredits_"+currentRow).val("---");
					if("${studentInstitutionTranscript.institution.evaluationStatus}".toUpperCase() == "EVALUATED" && semEqValue != '' && data.clockHoursChk == true){
						//alert(data.courseType);
						if(data.courseType == "Lecture"){
							semEqValue = parseFloat(semEqValue)/15;
							jQuery("#trSemCredits_"+currentRow).val(semEqValue.toFixed(2));	
						}
						else if(data.courseType == "Lab"){
							semEqValue = parseFloat(semEqValue)/30;
							jQuery("#trSemCredits_"+currentRow).val(semEqValue.toFixed(2));
						}
						else if(data.courseType == "Clinical"){
							semEqValue = parseFloat(semEqValue)/45;
							jQuery("#trSemCredits_"+currentRow).val(semEqValue.toFixed(2));
						}
						else{
							jQuery("#trSemCredits_"+currentRow).val("---");
						}
					}else{
						jQuery("#trSemCredits_"+currentRow).val("---");
					}
				}else{
					jQuery("#trSemCredits_"+currentRow).val("---");
				}
			},
			error: function(xhr, textStatus, errorThrown){
				jQuery("#trSemCredits_"+currentRow).val("---");
			}
		});
	}else{
		jQuery("#trSemCredits_"+currentRow).val("---");
	}
	
	
}
function titleLimit(titleValue){
	
	var limitNum = 75;
	if (titleValue.value.length >= limitNum) {
		var elementId = jQuery(titleValue).attr("id");
		jQuery("#"+elementId).addClass("redBorder");
		alert("you can fill up to 75 charater.");
		return false;
    } 
}
</script>

<%--<c:if test="${studentInstitutionTranscript.evaluationStatus == 'REJECTED' || studentInstitutionTranscript.evaluationStatus == 'REJECTED INSTITUTION' }">
 <div align="center" style="color:red; padding-top:20px; font-size:16px; background-color: #ffeded;">
	<span><img src="../images/alertIcon.png"  alt="rejected" height="14" width="16"/> This is a <em><i>REJECTED</i></em> transcript. &nbsp; <c:if test="${studentInstitutionTranscript.evaluationStatus == 'REJECTED INSTITUTION'}"> Please add a fresh transcript</c:if>&nbsp;&nbsp;&nbsp;</span>
	<c:choose>
		
		<c:when test="${not empty studentInstitutionTranscript.lopeComment}">
			<span>LOPE comment : &nbsp;<c:out value="${studentInstitutionTranscript.lopeComment}"></c:out></span>
		</c:when>
		<c:otherwise>
			<span>SLE comment : &nbsp;<c:out value="${studentInstitutionTranscript.sleComment }"></c:out></span>
		</c:otherwise>
		
	</c:choose>
	
</div> --%>
<div class="deo2">
  <div style="border:1px solid #e7e7e7; border-top:none;" class="institute">
  	<div class="noti-tools2">
  	  <div class="clear"></div>
    <div class="institutionHeader mb-8">
      <a id="backToTrList" href="launchEvaluation.html?operation=launchEvaluationHome&programVersionCode=${courseInfo.programVersionCode}&studentCrmId=${student.crmId}" class="mr10"><img src="../images/arow_img.png" width="15" height="13" alt="" />Back to Transcript List</a></div>
      <div class="clear"></div>
      <div class="deo">
	<div class="deoInfo">
		<form name="leadInformationForm">
			<%@include file="../common/studentDemographicsInfo.jsp" %>
	     </form>
 </div>
	 <div class="deoInfo">
	 <%@include file="../common/institutionInfo.jsp" %>
    </div>
  </div>  
    <ul id="addTopNav" class="floatLeft top-nav-tab ml20">
   	 <c:set var="upperTabIndexToAppend" value="2"/>
              <li><a class="on" id="tablink_1" href="javascript:void(0)"><span>New Transcript</span></a></li>
           <c:forEach items="${studentInstitutionTranscriptSummaryList }" var="studentInstitutionTranscriptSummary" varStatus="transcriptIndex">
           		<%-- <c:if test="${fn:length(studentInstitutionTranscriptSummary.studentInstitutionTranscript.studentTranscriptCourse) gt 0}"> --%>
	           		<c:set var="upperTabIndexToAppend" value="${upperTabIndexToAppend + transcriptIndex.index}"/>
	        		<c:if test="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.official eq true }">
	              		<li><a id="tablink_${upperTabIndexToAppend }" href="javascript:void(0)"><span>Official - <fmt:formatDate value="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.createdDate}" pattern="MM/dd/yyyy"/></span></a></li>
	                </c:if>
	                <c:if test="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.official eq false }">
	              		<li><a id="tablink_${upperTabIndexToAppend }" href="javascript:void(0)"><span>Un-Official - <fmt:formatDate value="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.createdDate}" pattern="MM/dd/yyyy"/></span></a></li>
	                </c:if>
                 <%-- </c:if> --%>
            </c:forEach>
    </ul>
    <br class="clear">
    <div id="addDyndivs" class="tabBorder contentForm">
       <c:set var="now" value="<%=new java.util.Date()%>"/>
    <form name="transferCourseForm" id="transferCourseForm" method="post"><!--//launchEvaluation.html?operation=markTranscriptComplete -->
    <div id="inrContBox_1">
    	<div class="mt30">
        
        	<div class="dateReceived">
            	
                <label class="noti-label w100">Date Received: </label>
             
                    <input type="text" id="dateReceivedCur" name="dateReceived" value="<fmt:formatDate value='${!empty studentInstitutionTranscript.dateReceived ?studentInstitutionTranscript.dateReceived:now}' pattern='MM/dd/yyyy'/>" class="textField w80px maskDate required">
            
            </div>
        	<div class="lastAttend">
            
            	<label class="noti-label w100">Last Attended:</label>
                    <input type="text" name="lastAttendenceDate" value="<fmt:formatDate value='${studentInstitutionTranscript.lastAttendenceDate}' pattern='MM/dd/yyyy'/>" class="textField w80px maskDate required">
            
            </div>
        	<div class="tanscriptType">
	            <label class="noti-label w110">Transcript Type:</label>
	            <%-- <c:choose>
			          <c:when test="${!empty studentInstitutionTranscript }">
			              <label class="mr22">
			                <input type="radio" name="official" value="false" id="RadioGroup1_0" <c:if test="${studentInstitutionTranscript.official eq false}"> checked</c:if> style="float:none; margin-right:0px;" />
			                Un-official
			                </label>
			             
			              <label>
			                <input type="radio" name="official" value="true" id="RadioGroup1_1" <c:if test="${studentInstitutionTranscript.official eq true}"> checked</c:if> style="float:none; margin-right:0px;" />
			                Official
			                </label>
			          </c:when>
		            <c:otherwise>
		            	 <label class="mr22">
			                <input type="radio" name="official" value="false" id="RadioGroup1_0" style="float:none; margin-right:0px;"/>
			                Un-official
			                </label>
			             
			              <label>
			                <input type="radio" name="official" value="true" id="RadioGroup1_1" checked="checked" style="float:none; margin-right:0px;"/>
			                Official
			                </label>            
		            </c:otherwise>
	            </c:choose> --%>
            	<label class="mr22">
		                <input type="radio" name="official" value="false" id="RadioGroup1_0" style="float:none; margin-right:0px;"/>
		                Un-official
		         </label>
		             
		         <label>
		                <input type="radio" name="official" value="true" id="RadioGroup1_1" checked="checked" style="float:none; margin-right:0px;"/>
		                Official
		         </label> 
            </div>
        	<div class="clear"></div>            
        
        </div>
	
    	<div class="mt30">
        	<div class="tabHeader">Degree(s) Details</div>
	            <div>
	            
		            <table name="degreeTblForm" id="degreeTblId"  width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl3 noti-bbn tabTBLborder">
						  <tr id="degreeRow_-1">
						    <th width="40%" scope="col" class="dividerGrey">Degree Earned</th>
						    <th width="30%" scope="col" class="dividerGrey">Major</th>
						    <th width="15%" scope="col" class="dividerGrey">Graduation Date</th>
						    <th width="15%" scope="col">GPA</th>
						  </tr>
						  <c:choose>
						  		<c:when test="${fn:length(studentInstitutionDegreeList) gt 0}">
						  		<c:set var="degreeCount" value="0"></c:set>
							  		<c:forEach items="${studentInstitutionDegreeList}" var="sInstDegList" varStatus="index">
							  			<c:if test="${!empty sInstDegList.institutionDegree.degree}">							  			 
								  			<c:if test="${sInstDegList.institutionDegree.degree ne 'No Degree'}">
								  				<c:set var="degreeCount" value="${degreeCount+1}"></c:set>
									              <tr id="degreeRow_${index.index }">
												    <td>
													    <select id="insDegree_${index.index }" class="w230 required valid" name="studentInstitutionDegreeSet[${index.index }].institutionDegree.degree" onchange="javascript:markUnMarkDisabled('${index.index}','degreeTblId');">
													      
														         <option value="No Degree">No Degree</option>
															      <c:forEach items="${gCUDegreeList}" var="gcuDegree" varStatus="indexDegree">												      
																      <option value="${gcuDegree.degree }" <c:if test="${sInstDegList.institutionDegree.degree eq gcuDegree.degree}">selected</c:if>>${gcuDegree.degree }</option>
															   	  </c:forEach>
														   
													    </select>
												    </td>
												    <td><input id="major_${index.index }" type="text" name="studentInstitutionDegreeSet[${index.index }].major" value="${sInstDegList.major}" <c:if test="${sInstDegList.institutionDegree.degree eq 'No Degree'}">disabled="disabled"</c:if>  class="textField w80 required"></td>
												    <td><input id="degreeDate_${index.index }" type="text" name="studentInstitutionDegreeSet[${index.index }].completionDate"  value="<fmt:formatDate value='${sInstDegList.completionDate}' pattern='MM/dd/yyyy'/>" class="dgCompletionDate textField w100 maskDate required"></td>
												    <td><input id="GPA_${index.index }" type="text" name="studentInstitutionDegreeSet[${index.index }].gpa" value='<fmt:formatNumber type="number"  maxFractionDigits="2" value="${sInstDegList.gpa}" pattern="0.00"/>' class="textField w80px number" onblur="assignDefaultVal(this);">
												    	<%-- <c:if test="${index.index ne 0 }"> --%><a href="javaScript:void(0);" id='removeRow_${index.index }' name='removeRow_${index.index }' class="removeIcon fr mt5 removeInstitutionRow"></a><%-- </c:if> --%>
												    </td>
											  </tr>
											</c:if>
									  </c:if>
	            		 			</c:forEach>
	            		 			<c:if test="${degreeCount eq 0 }">
	            		 				<tr id="degreeRow_0">
									    <td>
										    <select id="insDegree_0" class="w230 required valid" name="studentInstitutionDegreeSet[0].institutionDegree.degree" onchange="javascript:markUnMarkDisabled('0','degreeTblId');">
										      <option value="No Degree">No Degree</option>
										      <c:forEach items="${gCUDegreeList}" var="gcuDegree">
										      		<option value="${gcuDegree.degree }">${gcuDegree.degree }</option>
										      </c:forEach>
										    </select>
									    </td>
									    <td><input id="major_0" type="text" name="studentInstitutionDegreeSet[0].major" class="textField w80" disabled="disabled"></td>
									    <td><input id="degreeDate_0" type="text" name="studentInstitutionDegreeSet[0].completionDate" class="dgCompletionDate textField w100 maskDate"></td>
									    <td>
									    	<input id="GPA_0" type="text" name="studentInstitutionDegreeSet[0].gpa" value="0.0" class="textField w80px number" onblur="assignDefaultVal(this);">
									    	<a href="javaScript:void(0);" id='removeRow_0' name='removeRow_0' class="removeIcon fr mt5 removeInstitutionRow"></a>
									    </td>
					 		 		</tr>
	            		 			</c:if>
						  		</c:when>
						  		<c:otherwise>
						  			<tr id="degreeRow_0">
									    <td>
										    <select id="insDegree_0" class="w230 required valid" name="studentInstitutionDegreeSet[0].institutionDegree.degree" onchange="javascript:markUnMarkDisabled('0','degreeTblId');">
										      <option value="No Degree">No Degree</option>
										      <c:forEach items="${gCUDegreeList}" var="gcuDegree">
										      		<option value="${gcuDegree.degree }">${gcuDegree.degree }</option>
										      </c:forEach>
										    </select>
									    </td>
									    <td><input id="major_0" type="text" name="studentInstitutionDegreeSet[0].major" class="textField w80" disabled="disabled"></td>
									    <td><input id="degreeDate_0" type="text" name="studentInstitutionDegreeSet[0].completionDate" class="dgCompletionDate textField w100 maskDate"></td>
									    <td>
									    	<input id="GPA_0" type="text" name="studentInstitutionDegreeSet[0].gpa" value="0.0" class="textField w80px number" onblur="assignDefaultVal(this);">
									    	<a href="javaScript:void(0);" id='removeRow_0' name='removeRow_0' class="removeIcon fr mt5 removeInstitutionRow"></a>
									    </td>
					 		 		</tr>
						  		</c:otherwise>
						  </c:choose>
					  
					  
					</table>
			  </div>
			<div><a href="javascript:void(0);" class="addDegree" onclick="javascript:loadInstitutionDegreeKeyRow('degreeTblId','transferCourseForm');">Add Degree</a></div>
        </div>
        
        <div>
        	<div class="tabHeader">Course(s) Details</div>
            <div> 
            
   			 <table name="transferCourseTbl" id="transferCourseTbl" width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl3 noti-bbn tabTBLborder">
						  <tr>
							    <th width="10%" scope="col" class="dividerGrey">Date Completed<br />
								<span class="mandatoryTxt">(mm/dd/yyyy)</span></th>
							    <th width="10%" scope="col" class="dividerGrey">Transfer Course ID</th>
							    <th width="28%" scope="col" class="dividerGrey">Transfer Course Title</th>
							    <th width="6%" align="center" class="dividerGrey" scope="col">Grade</th>
							    <th width="6%" align="center" class="dividerGrey" scope="col">Credits</th>
							    <th width="6%" align="center" class="dividerGrey" scope="col">Clock Hours</th>
							    <th width="7%" align="center" class="dividerGrey" scope="col">Semester Credits</th>
							    <th width="12%" scope="col" class="dividerGrey">Transfer Status</th>
							    <th width="12%" scope="col"><!-- Course Evaluation Status --></th>
							    <th width="2%" scope="col">&nbsp;</th>
						 </tr>
						  <c:choose>
	  						<c:when test="${empty studentTranscriptCourseList}">
		  						<tr id="courseRow_0">
								    <td>
								    	<span class="dateReceived">
								      		<input type="text" name="studentTranscriptCourse[0].completionDate" id="trCourseCompletionDate_0" class="textField w70 maskDate required" onblur="javaScript:getInstitutionTermType('transferCourseForm',this);"/>
								    	</span>
								    </td>
								    <td>
								    	    <input type="hidden"  id="hasUnsavedValues_0" name="hasUnsavedValues_0" value="0" />	
								    	    <input type="hidden"  id="transcriptStatus_0" name="studentTranscriptCourse[0].transcriptStatus" value="" />
							            	<input type="hidden"  id="transcriptEvaluationStatus_0" name="studentTranscriptCourse[0].evaluationStatus" value="" />		            	            						
								    	<input type="text" name="studentTranscriptCourse[0].trCourseId" id="trCourseId_0" class="keyUpTextField textField trCourseId w70 required"  onBlur="javascript:findCourseDetails('0','transferCourseTbl','transferCourseForm', this.value);"/>
								    	
								    </td>
								    <td>
								    	<input type="text" name="studentTranscriptCourse[0].transferCourseTitle.title" id="trCourseTitle_0" class="textField w110 mr10 required" maxlength="75" onkeyup="javaScript:titleLimit(this);"/> 
								    	<select class="titleselect w90" id="trCourseTitleSelect_0" name="trCourseTitleSelect_0" onchange="fillTitle(this,'transferCourseTbl');">
								    	
								      		<option>Select Title</option>
								    	</select>
								    </td>
								    <td align="left"><input type="text" name="studentTranscriptCourse[0].grade" id="trCourseGrade_0" class="textField w40 required"/>
									    <!-- <select name="studentTranscriptCourse[0].grade" id="trCourseGrade_0" class="w50px required valid" >
						            		<option value=''></option> 
						            		<option value='A'>A</option> 
						            		<option value='A-'>A-</option> 
						            		<option value='B'>B</option>
						            		<option value='B+'>B+</option>
						            		<option value='B-'>B-</option> 
						            		<option value='C'>C</option> 
						            		<option value='C+'>C+</option> 
						            		<option value='C-'>C-</option>
						            		<option value='CR'>CR</option>
						            		<option value='D'>D</option>
						            		<option value='D+'>D+</option>
						            		<option value='D-'>D-</option>
						            		<option value='F'>F</option>
						            		<option value='I'>I</option> 
						            		<option value='IP'>IP</option>
						            		<option value='S'>S</option>
						            		<option value='TR'>TR</option> 
						            		<option value='U'>U</option> 
						            		<option value='W'>W</option>
						            		<option value='WF'>WF</option>					
						                </select> -->
								    </td>
								    <td align="center"><input type="text" name="studentTranscriptCourse[0].transferCourse.transcriptCredits" id="trCourseCredits_0" class="textField w30 required"  onblur="javaScript:getInstitutionTermType('transferCourseForm',this);"/></td>
								    <td align="center"><input type="text" name="studentTranscriptCourse[0].transferCourse.clockHours" id="trClockHours_0" class="textField w30 required" onblur="javaScript:getCourseType(this);"/></td>
								    <td align="center"><input type="text" name="studentTranscriptCourse[0].transferCourse.semesterCredits" id="trSemCredits_0" class="textField w33 required" readonly="readonly" /></td>
								    <td id="studentTranscriptCourseTranscriptStatus_0"></td>
								    <td id="studentTranscriptCourseEvaluationStatus_0"><input type="hidden" name="evaluationStatus" id="evalStatus_0"/></td>
								    <td><a href="javaScript:void(0);" id="removeRow_0" name="removeRow_0" class="removeIcon fr removeRow"></a></td>
							   </tr>
	  						</c:when>
	  						<c:otherwise>
	  							<c:forEach items="${studentTranscriptCourseList}" var="studentTranscriptCourse" varStatus="loop">
									<c:set var="rejectClass" value=""></c:set>
							        <c:if test="${studentTranscriptCourse.transcriptStatus=='REJECTED'}">  
										<c:set var="rejectClass" value="errorClass"></c:set>
										
										<script>
											rejectCourseList.push('${studentTranscriptCourse.trCourseId}')
										</script>
									</c:if>
									<tr id="courseRow_${loop.index}">
					        			<td>
											<input type="text" onblur="javaScript:getInstitutionTermType('transferCourseForm',this);" <c:if test="${studentTranscriptCourse.markCompleted eq true }"> readonly="readonly"</c:if>  name="studentTranscriptCourse[${loop.index}].completionDate" id="trCourseCompletionDate_${loop.index}" class="textField ${rejectClass} w70"   value="<fmt:formatDate value='${studentTranscriptCourse.completionDate}' pattern='MM/dd/yyyy'/>"/>
							            </td>
							            <td>
											<input type="hidden" <c:if test="${studentTranscriptCourse.markCompleted eq true }"> readonly="readonly"</c:if>  id="transcriptStatus_${loop.index}" name="studentTranscriptCourse[${loop.index}].transcriptStatus" value="${studentTranscriptCourse.transcriptStatus}" />
							            	<input type="hidden"<c:if test="${studentTranscriptCourse.markCompleted eq true }"> readonly="readonly"</c:if>  name="hasUnsavedValues_${loop.index}" id="hasUnsavedValues_${loop.index}" value="0" />
							            	<input type="hidden" <c:if test="${studentTranscriptCourse.markCompleted eq true }"> readonly="readonly"</c:if>  id="transcriptEvaluationStatus_${loop.index}" name="studentTranscriptCourse[${loop.index}].evaluationStatus" value="${studentTranscriptCourse.evaluationStatus}" />		            	
							            	<input type="text" <c:if test="${studentTranscriptCourse.markCompleted eq true}"> readonly="readonly"</c:if>  name="studentTranscriptCourse[${loop.index}].trCourseId" id="trCourseId_${loop.index}" value="${studentTranscriptCourse.trCourseId}" class="keyUpTextField trCourseId ${rejectClass} textField w70" onBlur="javascript:findCourseDetails(${loop.index},transferCourseTbl,transferCourseForm, this.value);" />            	
										</td>
										<td>
									        <input type="text" name="studentTranscriptCourse[${loop.index}].transferCourseTitle.title" id="trCourseTitle_${loop.index}"  class="${rejectClass} textField w110 mr10" value="${studentTranscriptCourse.courseTitle}" title="${studentTranscriptCourse.courseTitle}" maxlength="75" onkeyup="javaScript:titleLimit(this);"/>
									        
									        <select  class="required valid w90" id="trCourseTitleSelect_${loop.index}" name="trCourseTitleSelect_${loop.index}"  onchange="fillTitle(this,'transferCourseTbl');" <c:if test="${fn:length(studentTranscriptCourse.transferCourseTitleList) eq 1 }"> disabled="disabled"  </c:if>>
												<option value="">Select Title</option>
												<c:forEach items="${studentTranscriptCourse.transferCourseTitleList}" var="transferCourseTitle">
														<option value="${transferCourseTitle.title }">${transferCourseTitle.title }</option>
												</c:forEach>		    
											</select><br class="clear" />
									    </td>
									    <td>
									    	<input type="text"  name="studentTranscriptCourse[${loop.index}].grade" id="trCourseGrade_${loop.index}"  class="${rejectClass} textField w40" value="${studentTranscriptCourse.grade}"  />
									    	<%-- <select <c:if test="${studentTranscriptCourse.markCompleted eq true }"> readonly="readonly" </c:if>   name="studentTranscriptCourse[${loop.index}].grade" id="trCourseGrade_${loop.index}"   class="${rejectClass} w50px required valid">
						            			<option value=''></option>
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
						                	</select> --%>
									    </td>
									    <td>
									        <input type="text" name="studentTranscriptCourse[${loop.index}].transferCourse.transcriptCredits" id="trCourseCredits_${loop.index}"   onblur="javaScript:getInstitutionTermType('transferCourseForm',this);" class="${rejectClass} textField w30" value="${studentTranscriptCourse.creditsTransferred}"  />
									    </td>
									    <td align="center"><input type="text" name="studentTranscriptCourse[${loop.index}].transferCourse.clockHours"  value="${studentTranscriptCourse.clockHours}" id="trClockHours_${loop.index}" class="textField w30 required" onblur="javaScript:getCourseType(this);"/></td>
									    <td>
							            	<c:choose>
							            		<c:when test="${fn:toUpperCase(studentInstitutionTranscript.institution.evaluationStatus) == 'EVALUATED'}">
							            			<c:choose>
							            				<c:when test="${studentTranscriptCourse.institutionTermType.termType.name == 'Quarter' && studentTranscriptCourse.transferCourse.clockHoursChk eq false}">
							            					<input type="text" <c:if test="${studentTranscriptCourse.markCompleted eq true }"> readonly="readonly"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w33" value='<fmt:formatNumber value="${studentTranscriptCourse.creditsTransferred*2/3}" maxFractionDigits="2" pattern="0.00"/>'/>
							            				</c:when>
							            				<c:when test="${studentTranscriptCourse.institutionTermType.termType.name == '4-1-4' && studentTranscriptCourse.transferCourse.clockHoursChk eq false}">
							            					<input type="text" <c:if test="${studentTranscriptCourse.markCompleted eq true}"> readonly="readonly"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w33" value='<fmt:formatNumber value="${studentTranscriptCourse.creditsTransferred*4}" maxFractionDigits="2" pattern="0.00"/>' />
							            				</c:when>
							            				<c:when test="${studentTranscriptCourse.institutionTermType.termType.name == 'Semester' && studentTranscriptCourse.transferCourse.clockHoursChk eq false}">
							            					<input type="text" <c:if test="${studentTranscriptCourse.markCompleted eq true }"> readonly="readonly"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w33" value='<fmt:formatNumber value="${studentTranscriptCourse.creditsTransferred}" maxFractionDigits="2" pattern="0.00"/>'  />
							            				</c:when>
							            				<c:when test="${studentTranscriptCourse.institutionTermType.termType.name == 'Annual' && studentTranscriptCourse.transferCourse.clockHoursChk eq false}">
							            					<input type="text" <c:if test="${studentTranscriptCourse.markCompleted eq true }"> readonly="readonly"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w33" value='---'  />
							            				</c:when>
							            				<c:otherwise>
								            				<c:choose>
								            					<c:when test="${studentTranscriptCourse.transferCourse.courseType == 'Lecture' && studentTranscriptCourse.transferCourse.clockHoursChk eq true}">
								            						<input type="text" <c:if test="${studentTranscriptCourse.markCompleted eq true }"> readonly="readonly"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w33" value='<fmt:formatNumber value="${studentTranscriptCourse.clockHours/15}" maxFractionDigits="2" pattern="0.00"/>'  />
								            					</c:when>
								            					<c:when test="${studentTranscriptCourse.transferCourse.courseType == 'Lab' && studentTranscriptCourse.transferCourse.clockHoursChk eq true}">
								            						<input type="text" <c:if test="${studentTranscriptCourse.markCompleted eq true }"> readonly="readonly"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w33" value='<fmt:formatNumber value="${studentTranscriptCourse.clockHours/30}" maxFractionDigits="2" pattern="0.00"/>'  />
								            					</c:when>
								            					<c:when test="${studentTranscriptCourse.transferCourse.courseType == 'Clinical' && studentTranscriptCourse.transferCourse.clockHoursChk eq true}">
								            						<input type="text" <c:if test="${studentTranscriptCourse.markCompleted eq true }"> readonly="readonly"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w33" value='<fmt:formatNumber value="${studentTranscriptCourse.clockHours/45}" maxFractionDigits="2" pattern="0.00"/>'  />
								            					</c:when>
								            					<c:otherwise>
										            				<input type="text" <c:if test="${studentTranscriptCourse.markCompleted eq true }"> readonly="readonly"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w33" value="---" />
										            			</c:otherwise>
										            		</c:choose>	
							            				</c:otherwise>
							            			</c:choose>
							            		</c:when>							            		
							            		<c:otherwise>
							            			<input type="text" <c:if test="${studentTranscriptCourse.markCompleted eq true }"> readonly="readonly"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w33" value="---" />
							            		</c:otherwise> 
							            	</c:choose>	
									    </td>
									    
									    <td id="studentTranscriptCourseTranscriptStatus_${loop.index}">
									    	${studentTranscriptCourse.transcriptStatus}
									   </td>
									    <td id="studentTranscriptCourseEvaluationStatus_${loop.index}">
									    	<%-- ${studentTranscriptCourse.evaluationStatus} --%>
									    </td>
									    <c:if test="${studentInstitutionTranscript.evaluationStatus == 'REJECTED' }">
									    	<td>
									    		<c:if test="${studentTranscriptCourse.transcriptStatus=='REJECTED'}">
									    			<input type="checkbox" name="errCrctd_${loop.index}" id="errCrctd_${loop.index}" class="errCrctd" style="margin:10px 0px 0px 20px;"/>
									    		</c:if>
									    	</td>
									    </c:if>
									    <td id="removeRowTd_${loop.index}">
											<c:choose>
										    	<%-- <c:when test="${loop.last == true && loop.first == false && (studentInstitutionTranscript.evaluationStatus == 'DRAFT' || studentInstitutionTranscript.evaluationStatus == 'REJECTED')}">
										        	
										        	<a href="#" id="removeRow_${loop.index}" name="removeRow_${loop.index}" class="removeIcon fr removeRow"></a>
										        	
										        </c:when> --%>
										        <c:when test="${studentInstitutionTranscript.evaluationStatus == 'REJECTED'  && studentTranscriptCourse.evaluationStatus eq 'EVALUATED'}">
											        
											    </c:when>
										  		<c:otherwise>
										  			<a href="javaScript:void(0);" id="removeRow_${loop.index}" name="removeRow_${loop.index}" class="removeIcon fr removeRow"></a>
										        </c:otherwise>
										    </c:choose>
										</td>
								    </tr>
								</c:forEach>		
	  						</c:otherwise>
	  						</c:choose>
						  
						 
		            </table>
		            <input type="hidden" name="id" id="studentInstitutionTranscriptId" value="${studentInstitutionTranscript.id}" />
		            <input type="hidden" id="selinstitutionId" name="institution.id" value="${selectedInstitution.id}" />
		           <%--  <input type="hidden" name="institution" value="${selectedInstitution}" /> --%>		            
				   	<input type="hidden" name="evaluationStatus" id="evaluationStatus" value="" />
				   	<input type="hidden" name="lastDateForLastCourse" id="lastDateForLastCourse" value='<fmt:formatDate value="${studentInstitutionTranscript.lastDateForLastCourse}" pattern="MM/dd/yyyy hh:mm:ss:SSS"/>' />
				   <%-- 	<input type="hidden" name="createdDate" id="createdTime" value='<fmt:formatDate value="${studentInstitutionTranscript.createdDate}" pattern="MM/dd/yyyy hh:mm:ss:SSS"/>' /> --%>
				   	<input type="hidden" name="createdBy" id="createdBy" value="${studentInstitutionTranscript.createdBy}" />
				   <%--	<input type="hidden" name="studentProgramEvaluation" id="studentProgramEvaluation" value="${studentInstitutionTranscript.studentProgramEvaluation}" />
				   	<input type="hidden" name="studentProgramEvaluation.id" id="studentProgramEvaluationId" value="${studentInstitutionTranscript.studentProgramEvaluation.id}" />
				   	 <input type="hidden" name="studentProgramEvaluation" id="studentProgramEvaluationId" value="${studentInstitutionTranscript.studentProgramEvaluation}" />
				   	 --%>
				   	
				   	<input type="hidden" name="studentCrmId" id="studentCrmId" value="${student.crmId}" />
				   	<input type="hidden" name="programVersionCode" id="programVersionCode"  value="${courseInfo.programVersionCode}" />
				   	<input type="hidden" name="programDesc"  value="${courseInfo.programDesc}" />
				   	<input type="hidden" name="catalogCode"  value="${courseInfo.catalogCode}" />
				   	<input type="hidden" name="stateCode"  value="${courseInfo.stateCode}" />
				   	
				   	
				    <input type="hidden" name="coursesAdded" value="" />
				    <input type="hidden" name="expectedStartDateString" id="expectedStartDateString" value="<fmt:formatDate value='${courseInfo.expectedStartDate}' pattern='MM/dd/yyyy' />" />
				    <input type="hidden" name="institutionId" id="institutionId" value="${studentInstitutionTranscript.institution.id}" />
				    <input type="hidden" name="studentId" id="studentId" value="${student.id}" />
				   	<%-- <input type="hidden" name="studentProgramEvaluationId" id="studentProgramEvaluationId" value="${studentProgramEvaluation.id}" /> 
				   	<input type="hidden" name="studentInstitutionTranscriptId" id="studentInstitutionTranscriptId" value="${studentInstitutionTranscript.id}" />
				 	 	
				   	<input type="hidden" name="isSaveDraftInProgress" id="isSaveDraftInProgress" value="0" />--%>
				   	<input type="hidden" name="redirectValue1" id="redirectValue1" value="${redirectValue1}"/>
				   	<input type="hidden" name="institutionAddressId" id="institutionAddressId" value="${studentInstitutionTranscript.institutionAddress.id}"/>
		            
           </div>
			<div><a href="javascript:void(0);" class="addCourse" onclick="javaScript:addCourseRow1('transferCourseTbl','${studentInstitutionTranscript.evaluationStatus}','transferCourseForm');">Add Course</a></div>
        </div>
          <div class="mt40">
       <div class="tabHeader">Note</div>
  		 <br>  <div class="mt10 p10 addNoteFrm" id="addNoteFrm_1">
            
            	<div class="noteLeft">${userName}:</div>
                <div class="noteRight">
                  <label for="textarea"></label>
                  <textarea  name="comment" id="comment_1"  cols="45" rows="5" style="width:99%; height:60px; margin:-6px 0px 0px 0px;"></textarea>
                </div>
                <input type="hidden" name="transcriptId" id="sitId_1" value="${studentInstitutionTranscript.id}"/>
                <div class="clear"></div>
                <div class="fr mt10">
		             <input type="button" value="Add" id="addComment_1" />&nbsp;&nbsp;<input type="button" value="Cancel" id="cancelAddComment_1" />
				</div>
                <div class="clear"></div>
            	</div>
            </div>
            <div><a href="javascript:void(0);" class="addNotes" title="Add Note" id="addNoteLnk_1">Add Note</a></div>
		       <div id="transcriptCommentsDiv_1">
		       
		       <c:set var="divindex" value="1"/>
		       	<c:set var="transcriptCommentsList" value="${studentInstitutionTranscript.transcriptCommentsList }"></c:set>
		       <%@include file="transcriptCommentsList.jsp" %>
		       </div>
		       <div class="notedashbdr" id="dashLine"></div>
			
       
       
        <div class="BorderLine"></div>
        <div>
	          <div class="fr">  
	          	<input type="button" name="saveInstitutionDegree" value="Save" id="saveInstitutionDegree" class="button" onclick="submitTranscript('<c:url value="/evaluation/launchEvaluation.html?operation=saveTranscriptIntoDraftMode"/>','MarkComplete','transferCourseForm','transferCourseTbl','degreeTblId');">            
				<input type="button" name="MarkComplete" value="Mark Complete" id="MarkComplete" class="button" id="submitTrCourses" onclick="submitTranscript('<c:url value="/evaluation/launchEvaluation.html?operation=markTranscriptToComplete&markCompleted=true"/>','saveInstitutionDegree','transferCourseForm','transferCourseTbl','degreeTblId');">
			</div>
	        <div class="clear"></div>
    	</div>
    	 
     </div>
     </form> 
     <c:set var="tabIndexToAppend" value="2"/>
     <c:set var="divTabIndexToAppend" value="1"/>
    <c:forEach items="${studentInstitutionTranscriptSummaryList }" var="studentInstitutionTranscriptSummary" varStatus="transcriptIndex">
    <%-- <c:if test="${fn:length(studentInstitutionTranscriptSummary.studentInstitutionTranscript.studentTranscriptCourse) gt 0}"> --%>
    <c:set var="tabIndexToAppend" value="${transcriptIndex.index + tabIndexToAppend }"/>
    <c:set var="firstRejectedDivId" value="0"/>
    <c:set var="rejectedTranscriptFound" value="0"/>
    	<c:choose>
    		<c:when test="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.evaluationStatus ne 'REJECTED' && studentInstitutionTranscriptSummary.studentInstitutionTranscript.evaluationStatus ne 'REJECTED INSTITUTION'}">
    		
	    	
			    <div id="inrContBox_${tabIndexToAppend }" style="display:none;">
			   		
			    	<div class="mt30">
			        
			        	<div class="dateReceived">
			            	
			                <label class="noti-label w100">Date Received:</label>
			                	<fmt:formatDate value='${studentInstitutionTranscriptSummary.studentInstitutionTranscript.dateReceived }' pattern='MM/dd/yyyy'/>
			                    <%-- <input type="text" disabled="disabled" value="<fmt:formatDate value='${studentInstitutionTranscriptSummary.studentInstitutionTranscript.dateReceived }' pattern='MM/dd/yyyy'/>" class="textField w80px"> --%>
			            
			            </div>
			        	<div class="lastAttend">
			            
			            	<label class="noti-label w100">Last Attended:</label>
			            		<fmt:formatDate value='${studentInstitutionTranscriptSummary.studentInstitutionTranscript.lastAttendenceDate }' pattern='MM/dd/yyyy'/>
			                    <%-- <input type="text" disabled="disabled" value="<fmt:formatDate value='${studentInstitutionTranscriptSummary.studentInstitutionTranscript.lastAttendenceDate }' pattern='MM/dd/yyyy'/>" class="textField w80px">
			             		--%>
			            </div>
			        	<div class="tanscriptType">
			            <label class="noti-label w110">Transcript Type:</label>
			            <label style="margin-top:5px;">
				            <c:choose>
				            	<c:when test="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.official }">
					            		official
					            	</c:when>
					            	<c:otherwise>
					            		Un-official
					            	</c:otherwise>
				            </c:choose>
			            
			            </label>
			          
			            
			            </div>
			        	<div class="clear"></div>            
			        
			        </div>
			
			    	<div class="mt30">
			        	<div class="tabHeader">Degree(s) Details</div>
			            	<div>
					            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl3 noti-bbn tabTBLborder">
								  <tr>
									    <th width="40%" scope="col" class="dividerGrey">Degree Earned</th>
									    <th width="30%" scope="col" class="dividerGrey">Major</th>
									    <th width="15%" scope="col" class="dividerGrey">Graduation Date</th>
									    <th width="15%" scope="col">GPA</th>
									  </tr>
								  <c:forEach items="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.studentInstitutionDegreeSet}" var="sInstDegList1" varStatus="index">
								  	 <c:if test="${!empty sInstDegList1.institutionDegree.degree}">
										  <tr>
										    <td>${sInstDegList1.institutionDegree.degree}</td>
										    <td>${sInstDegList1.major}</td>
										    <td><fmt:formatDate value='${sInstDegList1.completionDate}' pattern='MM/dd/yyyy'/></td>
										    <td><fmt:formatNumber type="number"  maxFractionDigits="2" value="${sInstDegList1.gpa}" pattern="0.00"/></td>
										  </tr>
									  </c:if>
							 	 </c:forEach>
							</table>
			
							</div>
			    	
			  	  </div>
			        
			        <div class="mt40">
			        	<div class="tabHeader">Course(s) Details</div>
			            <div>
			            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl3 noti-bbn tabTBLborder">
						  <tr>
						    <th width="10%" scope="col" class="dividerGrey">Date Completed<br />
							<span class="mandatoryTxt">(mm/dd/yyyy)</span></th>
						    <th width="10%" scope="col" class="dividerGrey">Transfer Course ID</th>
						    <th width="28%" scope="col" class="dividerGrey">Transfer Course Title</th>
						    <th width="6%" scope="col" class="dividerGrey">Grade</th>
						    <th width="6%" scope="col" class="dividerGrey">Credits</th>
						    <th width="6%" scope="col" class="dividerGrey">Clock Hours</th>
						    <th width="7%" scope="col" class="dividerGrey">Semester Credits</th>
						    <th width="12%" scope="col" class="dividerGrey">Transfer Status</th>
						    <th width="15%" scope="col"><!-- Course Evaluation Status --></th>
						  </tr>
					 <c:forEach items="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.studentTranscriptCourse}" var="studentTranscriptCourse1" varStatus="loop">
			  			 		<tr id="courseRow_${loop.index}">
								    <td>
								    	<span class="dateReceived"><fmt:formatDate value='${studentTranscriptCourse1.completionDate}' pattern='MM/dd/yyyy'/></span>
										<%-- <input type="text" <c:if test="${studentTranscriptCourse1.markCompleted eq true }"> disabled</c:if>  class="textField w70"    value="<fmt:formatDate value='${studentTranscriptCourse1.completionDate}' pattern='MM/dd/yyyy'/>"/> --%>
									</td>
									<td>
										${studentTranscriptCourse1.trCourseId}
										<%-- <input type="text" <c:if test="${studentTranscriptCourse1.markCompleted eq true}"> disabled</c:if> value="${studentTranscriptCourse1.trCourseId}"  class="keyUpTextField trCourseId ${rejectClass} textField w70" onBlur="javascript:findCourseDetails(${loop.index}, this.value);" /> --%>            	
									</td>
									<td>
										${studentTranscriptCourse1.courseTitle}
										<%-- <input type="text" <c:if test="${studentTranscriptCourse1.markCompleted eq true }"> disabled</c:if>    class="${rejectClass} textField w110 mr10" value="${studentTranscriptCourse1.courseTitle}" <c:if test='${fn:toUpperCase(studentTranscriptCourse1.transferCourse.evaluationStatus) == "EVALUATED" }'>readonly="readonly"</c:if>    />
										<select  class="required valid w90" id="trCourseTitleSelect_${loop.index}" name="trCourseTitleSelect_${loop.index}" onchange="fillTitle(this);" >
												<option value="">Select Title</option>		    
										</select><br class="clear" /> --%>
									</td>
									<td>${studentTranscriptCourse1.grade}<%-- 
										<select <c:if test="${studentTranscriptCourse1.markCompleted eq true }"> disabled</c:if>  class="${rejectClass} w50px required valid">
									            			<option value=''>TR Grade</option>
															<option value="A" <c:if test="${studentTranscriptCourse1.grade eq 'A'}">selected</c:if>>A</option>
															<option value="A-" <c:if test="${studentTranscriptCourse1.grade eq 'A-'}">selected</c:if>>A-</option>
															<option value="B" <c:if test="${studentTranscriptCourse1.grade eq 'B'}">selected</c:if>>B</option>
															<option value="B+" <c:if test="${studentTranscriptCourse1.grade eq 'B+'}">selected</c:if>>B+</option>
															<option value="B-" <c:if test="${studentTranscriptCourse1.grade eq 'B-'}">selected</c:if>>B-</option>
															<option value="C" <c:if test="${studentTranscriptCourse1.grade eq 'C'}">selected</c:if>>C</option>
															<option value="C+" <c:if test="${studentTranscriptCourse1.grade eq 'C+'}">selected</c:if>>C+</option>
															<option value="C-" <c:if test="${studentTranscriptCourse1.grade eq 'C-'}">selected</c:if>>C-</option>
															<option value="CR" <c:if test="${studentTranscriptCourse1.grade eq 'CR'}">selected</c:if>>CR</option>
															<option value="D" <c:if test="${studentTranscriptCourse1.grade eq 'D'}">selected</c:if>>D</option>
															<option value="D+" <c:if test="${studentTranscriptCourse1.grade eq 'D+'}">selected</c:if>>D+</option>
															<option value="D-" <c:if test="${studentTranscriptCourse1.grade eq 'D-'}">selected</c:if>>D-</option>
															<option value="F" <c:if test="${studentTranscriptCourse1.grade eq 'F'}">selected</c:if>>F</option>
															<option value="I" <c:if test="${studentTranscriptCourse1.grade eq 'I'}">selected</c:if>>I</option>
															<option value="IP" <c:if test="${studentTranscriptCourse1.grade eq 'IP'}">selected</c:if>>IP</option>
															<option value="S" <c:if test="${studentTranscriptCourse1.grade eq 'S'}">selected</c:if>>S</option> 
															<option value="TR" <c:if test="${studentTranscriptCourse1.grade eq 'TR'}">selected</c:if>>TR</option>
															<option value="TR" <c:if test="${studentTranscriptCourse1.grade eq 'TR'}">selected</c:if>>TR</option>
															<option value="U" <c:if test="${studentTranscriptCourse1.grade eq 'U'}">selected</c:if>>U</option>
															<option value="W" <c:if test="${studentTranscriptCourse1.grade eq 'W'}">selected</c:if>>W</option>
															<option value="WF" <c:if test="${studentTranscriptCourse1.grade eq 'WF'}">selected</c:if>>WF</option>
									      </select> --%>
								  </td>
								<td>
									${studentTranscriptCourse1.creditsTransferred}
									<%-- <input type="text" <c:if test="${studentTranscriptCourse1.markCompleted eq true }"> disabled</c:if>   class="textField w30" value="${studentTranscriptCourse1.transferCourse.transcriptCredits}"  /> --%>
								</td>
								<td>${studentTranscriptCourse1.clockHours}</td>
								<td>
									<c:choose>
										 <c:when test="${fn:toUpperCase(studentInstitutionTranscript.institution.evaluationStatus) == 'EVALUATED'}">
										        <c:choose>
										            <c:when test="${studentTranscriptCourse1.institutionTermType.termType.name == 'Quarter' && studentTranscriptCourse1.transferCourse.clockHoursChk eq false}">
										            	<fmt:formatNumber type="number"  maxFractionDigits="2" value="${studentTranscriptCourse1.creditsTransferred*2/3}" pattern="0.00"/>										             
										            </c:when>
										           <c:when test="${studentTranscriptCourse1.institutionTermType.termType.name == '4-1-4' && studentTranscriptCourse1.transferCourse.clockHoursChk eq false}">
										           		<fmt:formatNumber type="number"  maxFractionDigits="2" value="${studentTranscriptCourse1.creditsTransferred*4}" pattern="0.00"/>
										            </c:when>
										            <c:when test="${studentTranscriptCourse1.institutionTermType.termType.name == 'Semester' && studentTranscriptCourse1.transferCourse.clockHoursChk eq false}">
										 						<fmt:formatNumber type="number"  maxFractionDigits="2" value="${studentTranscriptCourse1.creditsTransferred}" pattern="0.00"/>
													</c:when>
													<c:when test="${studentTranscriptCourse1.institutionTermType.termType.name == 'Annual' && studentTranscriptCourse1.transferCourse.clockHoursChk eq false}">
							            					---
							            			</c:when>
										            <c:otherwise>
															 <c:choose>
													            <c:when test="${studentTranscriptCourse1.transferCourse.courseType == 'Lecture' && studentTranscriptCourse1.transferCourse.clockHoursChk eq true}">
													            	<fmt:formatNumber value="${studentTranscriptCourse1.clockHours/15}" maxFractionDigits="2" pattern="0.00"/>
													            </c:when>
													            <c:when test="${studentTranscriptCourse1.transferCourse.courseType == 'Lab' && studentTranscriptCourse1.transferCourse.clockHoursChk eq true}">
													            	<fmt:formatNumber value="${studentTranscriptCourse1.clockHours/30}" maxFractionDigits="2" pattern="0.00"/>
													            </c:when>
													            <c:when test="${studentTranscriptCourse1.transferCourse.courseType == 'Clinical' && studentTranscriptCourse1.transferCourse.clockHoursChk eq true}">
													            	<fmt:formatNumber value="${studentTranscriptCourse1.clockHours/45}" maxFractionDigits="2" pattern="0.00"/>
													            </c:when>
													            <c:otherwise>
															        ---
															    </c:otherwise>
															  </c:choose>
										            </c:otherwise>
										       </c:choose>
										 </c:when>
										 
								</c:choose>	
							</td>
							<td>
								${studentTranscriptCourse1.transcriptStatus}
							 </td>
							<td>
								<%-- ${studentTranscriptCourse1.evaluationStatus} --%>
							</td>
							
								<td id="removeRowTd_${loop.index}"></td>
						</tr>
				</c:forEach>
			            </table>
			            </div>
			            <div class="BorderLine"></div>
			            <div class="mb10 createdby"><strong>Created By:</strong> ${studentInstitutionTranscriptSummary.studentInstitutionTranscript.user.firstName } &nbsp;${studentInstitutionTranscriptSummary.studentInstitutionTranscript.user.lastName }</div>
			            
			           
		  				    <div class="mt40">
					       <div class="tabHeader">Note</div>
					  		 <br>  <div class="mt10 p10 addNoteFrm" id="addNoteFrm_${tabIndexToAppend}">
					            
					            	<div class="noteLeft">${userName}:</div>
					                <div class="noteRight">
					                  <label for="textarea"></label>
					                  <textarea  name="comment" id="comment_${tabIndexToAppend}"  cols="45" rows="5" style="width:99%; height:60px; margin:-6px 0px 0px 0px;"></textarea>
					                </div>
					                <input type="hidden" name="transcriptId" id="sitId_${tabIndexToAppend}" value="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.id}"/>
					                <div class="clear"></div>
					                <div class="fr mt10">
							             <input type="button" value="Add" id="addComment_${tabIndexToAppend}"  />&nbsp;&nbsp;<input type="button" value="Cancel" id="cancelAddComment_${tabIndexToAppend}" />
									</div>
					                <div class="clear"></div>
					            	</div>
					            </div>
					            <div><a href="javascript:void(0);" class="addNotes" title="Add Note" id="addNoteLnk_${tabIndexToAppend}">Add Note</a></div>
					       
					       
		  				 <div id="transcriptCommentsDiv_${tabIndexToAppend }">
		        			<c:set var="divindex" value="${tabIndexToAppend }"/>
					       	<c:set var="transcriptCommentsList" value="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.transcriptCommentsList }"></c:set>
					       <%@include file="transcriptCommentsList.jsp" %>
					       </div>
		  				
				    
				       <div class="clear"></div>
				       
			        </div>
			      </div>
			</c:when>
    		<c:otherwise>
    			<c:set var="rejectedTranscriptFound" value="${rejectedTranscriptFound +1 }"/>
    			<form name="transferCourseForm${divTabIndexToAppend }" id="transferCourseFormId${divTabIndexToAppend }" method="post" action="<c:url value="/evaluation/launchEvaluation.html?operation=markRectifyCourseToComplete&markCompleted=true" />"><!--//launchEvaluation.html?operation=markTranscriptComplete -->
		         	 
		         	 
		         	 
				     <c:if test="${rejectedTranscriptFound eq 1 }">
				     	<c:set var="firstRejectedDivId" value="${tabIndexToAppend }"/>
				     </c:if>
		         	 <script type="text/javascript">
			    		jQuery("a[id^='tablink_']").each(
			    				function() {
			    						jQuery(this).removeClass("on");
			    						jQuery(this).hide();
			    					}
			    			);    		
			    		jQuery("#tablink_"+${firstRejectedDivId }).addClass("on");
			    		jQuery("#tablink_"+${firstRejectedDivId }).show();
			    		
    				</script>
			          <div id="inrContBox_${tabIndexToAppend }" style="display:none;">	
				     	<div class="rejctdiv rejColor mt10">
				         	   	<c:choose>
							          <c:when test="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.official eq true}">
							          	${studentInstitutionTranscriptSummary.studentInstitutionTranscript.sleComment}
							          </c:when>
							          <c:otherwise>
							          	${studentInstitutionTranscriptSummary.studentInstitutionTranscript.lopeComment}
							         </c:otherwise>
						        </c:choose>
				      </div>
		    	<div class="mt30">
		        
		        	<div class="dateReceived">
		            	
		                <label class="noti-label w100">Date Received:</label>
		                    <input type="text" name="dateReceived" value="<fmt:formatDate value='${studentInstitutionTranscriptSummary.studentInstitutionTranscript.dateReceived}' pattern='MM/dd/yyyy'/>" class="textField w80px maskDate required">
		            
		            </div>
		        	<div class="lastAttend">
		            
		            	<label class="noti-label w100">Last Attended:</label>
		                    <input type="text" name="lastAttendenceDate" value="<fmt:formatDate value='${studentInstitutionTranscriptSummary.studentInstitutionTranscript.lastAttendenceDate}' pattern='MM/dd/yyyy'/>" class="textField w80px maskDate required">
		            
		            </div>
		        	<div class="tanscriptType">
		            <label class="noti-label w110">Transcript Type:</label>
		            <c:choose>
				          <c:when test="${!empty studentInstitutionTranscript }">
				              <label class="mr22" style="margin-top:5px;">
				                 <c:if test="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.official eq false}">
				                	Un-official
				                 </c:if>
				               
				                <c:if test="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.official eq true}">
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
			            
				            <table name="degreeTblForm" id="degreeTblId${divTabIndexToAppend }"  width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl3 noti-bbn tabTBLborder">
								  <tr id="degreeRow_-1">
								    <th width="40%" scope="col" class="dividerGrey">Degree Earned</th>
								    <th width="30%" scope="col" class="dividerGrey">Major</th>
								    <th width="15%" scope="col" class="dividerGrey">Graduation Date</th>
								    <th width="15%" scope="col">GPA</th>
								  </tr>
								  <c:choose>
								  		<c:when test="${fn:length(studentInstitutionTranscriptSummary.studentInstitutionTranscript.studentInstitutionDegreeSet) gt 0}">
									  		<c:forEach items="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.studentInstitutionDegreeSet}" var="sInstDeg" varStatus="index">
										  		 <c:if test="${!empty sInstDeg.institutionDegree.degree}">
										              <tr id="degreeRow_${index.index }">
													    <td>
														    <select id="insDegree_${index.index }" class="w230 required valid" name="studentInstitutionDegreeSet[${index.index }].institutionDegree.degree" onchange="javascript:markUnMarkDisabled('${index.index}','degreeTblId${divTabIndexToAppend }');">
														      <option value="No Degree" <c:if test="${sInstDeg.institutionDegree.degree eq 'No Degree'}">selected</c:if>>No Degree</option>
														       <c:forEach items="${gCUDegreeList}" var="gcuDegree">
														      		<option value="${gcuDegree.degree }" <c:if test="${sInstDeg.institutionDegree.degree eq gcuDegree.degree}">selected</c:if>>${gcuDegree.degree }</option>
															  </c:forEach>
														    </select>
													    </td>
													    <td><input id="major_${index.index }" type="text" name="studentInstitutionDegreeSet[${index.index }].major" value="${sInstDeg.major}" <c:if test="${sInstDeg.institutionDegree.degree eq 'No Degree'}">disabled="disabled"</c:if> class="textField w80 required"></td>
													    <td><input id="degreeDate_${index.index }" type="text" name="studentInstitutionDegreeSet[${index.index }].completionDate"  value="<fmt:formatDate value='${sInstDeg.completionDate}' pattern='MM/dd/yyyy'/>" class="dgCompletionDate textField w100 maskDate required"></td>
													    <td><input id="GPA_${index.index }" type="text" name="studentInstitutionDegreeSet[${index.index }].gpa" value="${sInstDeg.gpa}" class="textField w80px number" onblur="assignDefaultVal(this);">
													    	<%-- <c:if test="${index.index ne 0 }"> --%><a href="javaScript:void(0);" id='removeRow_${index.index }' name='removeRow_${index.index }' class="removeIcon fr mt5 removeInstitutionRow"></a><%-- </c:if> --%>
													    </td>
												 	 </tr>
												  </c:if>
			            		 			</c:forEach>
								  		</c:when>
								  		<c:otherwise>
								  			<tr id="degreeRow_0">
											    <td>
												    <select id="insDegree_0" class="w230 required valid" name="studentInstitutionDegreeSet[0].institutionDegree.degree" onchange="javascript:markUnMarkDisabled('0','degreeTblId${divTabIndexToAppend }');">
												      <option value="No Degree">No Degree</option>
												      <c:forEach items="${gCUDegreeList}" var="gcuDegree">
													      	<option value="${gcuDegree.degree }" <c:if test="${sInstDeg.institutionDegree.degree eq gcuDegree.degree}">selected</c:if>>${gcuDegree.degree }</option>
													  </c:forEach>
												    </select>
											    </td>
											    <td><input id="major_0" type="text" name="studentInstitutionDegreeSet[0].major" class="textField w80" disabled="disabled"></td>
											    <td><input id="degreeDate_0" type="text" name="studentInstitutionDegreeSet[0].completionDate" class="dgCompletionDate textField w100 maskDate"></td>
											    <td>
											    	<input id="GPA_0" type="text" name="studentInstitutionDegreeSet[0].gpa" value="0.0" class="textField w80px number" onblur="assignDefaultVal(this);">
											    	<a href="javaScript:void(0);" id='removeRow_0' name='removeRow_0' class="removeIcon fr mt5 removeInstitutionRow"></a>
											    </td>
							 		 		</tr>
								  		</c:otherwise>
								  </c:choose>
							  
							  
							</table>
					  </div>
					<div><a href="javascript:void(0);" class="addDegree" onclick="javascript:loadInstitutionDegreeKeyRow('degreeTblId${divTabIndexToAppend }','transferCourseFormId${divTabIndexToAppend }');">Add Degree</a></div>
		        </div>
		        
		        <div>
		        	<div class="tabHeader">Course(s) Details</div>
		            <div> 
		            
		   			 <table name="transferCourseTbl${divTabIndexToAppend }" id="transferCourseTbl${divTabIndexToAppend }" width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl3 noti-bbn tabTBLborder">
								  <tr>
									    <th width="10%" scope="col" class="dividerGrey">Date Completed<br />
										<span class="mandatoryTxt">(mm/dd/yyyy)</span></th>
									    <th width="10%" scope="col" class="dividerGrey">Transfer Course ID</th>
									    <th width="22%" scope="col" class="dividerGrey">Transfer Course Title</th>
									    <th width="6%" align="center" class="dividerGrey" scope="col">Grade</th>
									    <th width="6%" align="center" class="dividerGrey" scope="col">Credits</th>
									    <th width="6%" align="center" class="dividerGrey" scope="col">Clock Hours</th>
									    <th width="7%" align="center" class="dividerGrey" scope="col">Semester Credits</th>
									    <th width="8%" scope="col" class="dividerGrey">Transfer Status</th>
									    <th width="16%" scope="col"><!-- Course Evaluation Status --></th>
									    <th width="6%" scope="col"><c:if test="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.evaluationStatus=='REJECTED'}"> Corrected</c:if></th>
									    <th width="2%" scope="col"> &nbsp;</th>
								 </tr>								 
			  					<c:forEach items="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.studentTranscriptCourse}" var="studentTranscriptCourse" varStatus="loop">
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
													<input type="text" onblur="javaScript:getInstitutionTermType('transferCourseFormId${divTabIndexToAppend }',this);" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>  name="studentTranscriptCourse[${loop.index}].completionDate" id="trCourseCompletionDate_${loop.index}" class="textField ${rejectClass} w70"   value="<fmt:formatDate value='${studentTranscriptCourse.completionDate}' pattern='MM/dd/yyyy'/>"/>
									            </td>
									            <td>
													<input type="hidden" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>  id="transcriptStatus_${loop.index}" name="studentTranscriptCourse[${loop.index}].transcriptStatus" value="${studentTranscriptCourse.transcriptStatus}" />
									            	<input type="hidden"<c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>  name="hasUnsavedValues_${loop.index}" id="hasUnsavedValues_${loop.index}" value="0" />
									            	<input type="hidden" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>   name="studentTranscriptCourse[${loop.index}].markCompleted" value="${studentTranscriptCourse.markCompleted}" />
									            	<input type="hidden" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>   name="studentTranscriptCourse[${loop.index}].id" value="${studentTranscriptCourse.id}" />
									            	<input type="hidden" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>   name="studentTranscriptCourse[${loop.index}].createdBy" value="${studentTranscriptCourse.createdBy}" />		            	
									            	<input type="text" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED'}"> disabled="disabled"</c:if>  name="studentTranscriptCourse[${loop.index}].trCourseId" id="trCourseId_${loop.index}" value="${studentTranscriptCourse.trCourseId}" class="trCourseId ${rejectClass} textField w70" onBlur="javascript:findCourseDetails(${loop.index},transferCourseTbl${divTabIndexToAppend },transferCourseFormId${divTabIndexToAppend }, this.value);"/>            	
												</td>
												<td>
											        <input type="text" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourseTitle.title" id="trCourseTitle_${loop.index}"  class="${rejectClass} textField w110 mr10" value="${studentTranscriptCourse.courseTitle}" maxlength="75" onkeyup="javaScript:titleLimit(this);"/>
											        <select  class="required valid w90" id="trCourseTitleSelect_${loop.index}" name="trCourseTitleSelect_${loop.index}" onchange="fillTitle(this,'transferCourseTbl${divTabIndexToAppend }');" <c:if test="${fn:length(studentTranscriptCourse.transferCourseTitleList) eq 1 }"> disabled="disabled"</c:if>>
														<option value="">Select Title</option>
														<c:forEach items="${studentTranscriptCourse.transferCourseTitleList}" var="transferCourseTitle">
															<option value="${transferCourseTitle.title }">${transferCourseTitle.title }</option>
														</c:forEach>		    
													</select><br class="clear" />
											    </td>
											    <td>
											    	<input type="text"  name="studentTranscriptCourse[${loop.index}].grade" id="trCourseGrade_${loop.index}" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled" </c:if>   class="${rejectClass} textField w40" value="${studentTranscriptCourse.grade}"  /> 
											    	<%-- <select <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled" </c:if>   name="studentTranscriptCourse[${loop.index}].grade" id="trCourseGrade_${loop.index}"   class="${rejectClass} w50px required valid">
								            			<option value=''></option>
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
								                	</select>--%>
											    </td>
											    <td>										    
											        <input type="text" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED'}"> disabled="disabled"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.transcriptCredits" id="trCourseCredits_${loop.index}"   onblur="javaScript:getInstitutionTermType('transferCourseFormId${divTabIndexToAppend }',this);"  class="${rejectClass} textField w30" value="${studentTranscriptCourse.creditsTransferred}"  />
											    </td>
											    <td align="center"><input type="text" name="studentTranscriptCourse[${loop.index}].transferCourse.clockHours"  value="${studentTranscriptCourse.clockHours}" id="trClockHours_${loop.index}" class="textField w30 required" onblur="javaScript:getCourseType(this);"/></td>
											    <td>
									            	<c:choose>
									            		<c:when test="${fn:toUpperCase(studentInstitutionTranscript.institution.evaluationStatus) == 'EVALUATED'}">
									            			<c:choose>
									            				<c:when test="${studentTranscriptCourse.institutionTermType.termType.name == 'Quarter' && studentTranscriptCourse.transferCourse.clockHoursChk eq false}">
									            					<input type="text" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED'}"> disabled="disabled"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w33" value='<fmt:formatNumber value="${studentTranscriptCourse.creditsTransferred*2/3}" maxFractionDigits="2" pattern="0.00"/>'/>
									            				</c:when>
									            				<c:when test="${studentTranscriptCourse.institutionTermType.termType.name == '4-1-4' && studentTranscriptCourse.transferCourse.clockHoursChk eq false}">
									            					<input type="text" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED'}"> disabled="disabled"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w33" value='<fmt:formatNumber value="${studentTranscriptCourse.creditsTransferred*4}" maxFractionDigits="2" pattern="0.00"/>' />
									            				</c:when>
									            				<c:when test="${studentTranscriptCourse.institutionTermType.termType.name == 'Semester' && studentTranscriptCourse.transferCourse.clockHoursChk eq false}">
									            					<input type="text" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w33" value="${studentTranscriptCourse.creditsTransferred}" />
									            				</c:when>
									            				<c:when test="${studentTranscriptCourse.institutionTermType.termType.name == 'Annual' && studentTranscriptCourse.transferCourse.clockHoursChk eq false}">
									            					<input type="text" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w33" value="---" />
									            				</c:when>
									            				<c:otherwise>
									            					<c:choose>
										            					<c:when test="${studentTranscriptCourse.transferCourse.courseType == 'Lecture' && studentTranscriptCourse.transferCourse.clockHoursChk eq true}">
										            						<input type="text" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED'}"> disabled="disabled"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w33" value='<fmt:formatNumber value="${studentTranscriptCourse.clockHours/15}" maxFractionDigits="2" pattern="0.00"/>'/>
										            					</c:when>
										            					<c:when test="${studentTranscriptCourse.transferCourse.courseType == 'Lab' && studentTranscriptCourse.transferCourse.clockHoursChk eq true}">
										            						<input type="text" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED'}"> disabled="disabled"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w33" value='<fmt:formatNumber value="${studentTranscriptCourse.clockHours/30}" maxFractionDigits="2" pattern="0.00"/>'/>
										            					</c:when>
										            					<c:when test="${studentTranscriptCourse.transferCourse.courseType == 'Clinical' && studentTranscriptCourse.transferCourse.clockHoursChk eq true}">
										            						<input type="text" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED'}"> disabled="disabled"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w33" value='<fmt:formatNumber value="${studentTranscriptCourse.clockHours/45}" maxFractionDigits="2" pattern="0.00"/>'/>
										            					</c:when>
										            					<c:otherwise>
												            				<input type="text" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w33" value="---" />
												            			</c:otherwise>
										            				</c:choose>
									            				</c:otherwise>
									            			</c:choose>
									            		</c:when>
									            		<c:otherwise>
									            			<input type="text" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>  name="studentTranscriptCourse[${loop.index}].transferCourse.semesterCredits" id="trSemCredits_${loop.index}" readOnly="true"  class="${rejectClass} textField w33" value="---" />
									            		</c:otherwise> 
									            	</c:choose>	
											    </td>
											    
											    <td id="studentTranscriptCourseTranscriptStatus_${loop.index}">
											    	${studentTranscriptCourse.transcriptStatus}
											   </td>
											    <td id="studentTranscriptCourseEvaluationStatus_${loop.index}">
											    	<%-- ${studentTranscriptCourse.evaluationStatus} --%>
											    </td>
											     
											    <c:if test="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.evaluationStatus == 'REJECTED' }">
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
				            <input type="hidden" name="id" id="studentInstitutionTranscriptId" value="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.id}" />
				            <input type="hidden" name="official"  value="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.official}" />
				            <input type="hidden" name="createdBy" value="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.createdBy}" />
				            
				            <input type="hidden" id="selinstitutionId" name="institution.id" value="${selectedInstitution.id}" />
						   	
						   	<input type="hidden" name="studentCrmId" id="studentCrmId" value="${student.crmId}" />
						   	<input type="hidden" name="programVersionCode" id="programVersionCode"  value="${courseInfo.programVersionCode}" />
						   	<input type="hidden" name="programDesc"  value="${courseInfo.programDesc}" />
						   	<input type="hidden" name="catalogCode"  value="${courseInfo.catalogCode}" />
						   	<input type="hidden" name="stateCode"  value="${courseInfo.stateCode}" />
						   	
						   	
						    <input type="hidden" name="coursesAdded" value="" />
						    <input type="hidden" name="expectedStartDateString" id="expectedStartDateString" value="<fmt:formatDate value='${courseInfo.expectedStartDate}' pattern='MM/dd/yyyy' />" />
						    <input type="hidden" name="institutionId" id="institutionId" value="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.institution.id}" />
						   	<%-- <input type="hidden" name="studentProgramEvaluationId" id="studentProgramEvaluationId" value="${studentProgramEvaluation.id}" /> 
						   	<input type="hidden" name="studentInstitutionTranscriptId" id="studentInstitutionTranscriptId" value="${studentInstitutionTranscript.id}" />
						 	 	
						   	<input type="hidden" name="isSaveDraftInProgress" id="isSaveDraftInProgress" value="0" />--%>
						   	<input type="hidden" name="studentId" id="studentId" value="${student.id}" />
						   	
						   	<input type="hidden" name="redirectValue1" id="redirectValue1" value="${redirectValue1}"/>
						   	<input type="hidden" name="institutionAddressId" id="institutionAddressId" value="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.institutionAddress.id}"/>
				            
		           </div>
					<div><a href="javascript:void(0);" class="addCourse" onclick="javaScript:addCourseRow1('transferCourseTbl${divTabIndexToAppend }','${studentInstitutionTranscriptSummary.studentInstitutionTranscript.evaluationStatus}','transferCourseFormId${divTabIndexToAppend }');">Add Course</a></div>
		        </div>
		           <div class="mt40">
					       <div class="tabHeader">Note</div>
					  		 <br>  <div class="mt10 p10 addNoteFrm" id="addNoteFrm_${tabIndexToAppend}">
					            
					            	<div class="noteLeft">${userName}:</div>
					                <div class="noteRight">
					                  <label for="textarea"></label>
					                  <textarea  name="comment" id="comment_${tabIndexToAppend}"  cols="45" rows="5" style="width:99%; height:60px; margin:-6px 0px 0px 0px;"></textarea>
					                </div>
					                <input type="hidden" name="transcriptId" id="sitId_${tabIndexToAppend}" value="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.id}"/>
					                <div class="clear"></div>
					                <div class="fr mt10">
							             <input type="button" value="Add" id="addComment_${tabIndexToAppend}"  />&nbsp;&nbsp;<input type="button" value="Cancel" id="cancelAddComment_${tabIndexToAppend}" />
									</div>
					                <div class="clear"></div>
					            	</div>
					            </div>
					            <div><a href="javascript:void(0);" class="addNotes" title="Add Note" id="addNoteLnk_${tabIndexToAppend}">Add Note</a></div>
					       
					       
		     
			       <div id="transcriptCommentsDiv_${tabIndexToAppend}">
		       <c:set var="divindex" value="${tabIndexToAppend }"/>
		       	<c:set var="transcriptCommentsList" value="${studentInstitutionTranscript.transcriptCommentsList }"></c:set>
		       <%@include file="transcriptCommentsList.jsp" %>
		       </div>
		       <div class="clear"></div>
		        <div class="BorderLine"></div>
		        <div>
			          <div class="fr">
						<input type="button" name="MarkComplete" value="Mark Complete" id="markComplete${divTabIndexToAppend }" class="button" onclick="submitRejectedTranscript('<c:url value="/evaluation/launchEvaluation.html?operation=markRectifyCourseToComplete&markCompleted=true"/>','inrContBox_${divTabIndexToAppend }','transferCourseFormId${divTabIndexToAppend }','markComplete${divTabIndexToAppend }','transferCourseTbl${divTabIndexToAppend }','degreeTblId${divTabIndexToAppend }');">
					</div>
			        <div class="clear"></div>
		    	</div>
		    	 
		     </div>
		     <script type="text/javascript">
	    		jQuery("div[id^='inrContBox_']").each(
	    				function() {
	    						jQuery("#"+this.id).hide();
	    				}
	    			);
	    		
	    		jQuery("#inrContBox_${firstRejectedDivId }").show();
		     
		     </script>
		         
		     </form>
		     <c:set var="divTabIndexToAppend" value="${divTabIndexToAppend + 1}"/> 
		     
    		</c:otherwise>
    		
    	</c:choose>    
    	
      <%-- </c:if> --%>
        </c:forEach> 
   
   
    </div>
    
	<div class="clear"></div>
      </div>
    
    
  
    </div>
      
    </div>
  </div>
</div>