<%@include file="../init.jsp" %>


<link rel="stylesheet" href="<c:url value="/css/schSysStylesheet.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/jquery.ui.all.css"/>" />
<style>
.capitalise
{
    text-transform:capitalize;
} 
</style>
<script type="text/javascript" src="<c:url value="/js/evaluationHome.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.validate.js"/>"></script>
<script type='text/javascript' src="<c:url value='/js/expand.js'/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.maskedinput-1.3.js"/>"></script>
 

<script type="text/javascript">
function uniqueSubject(newTranscriptFormId){
	//alert(newTranscriptFormId+"--Subj");
	 var isDuplicate=false;
	 jQuery("#"+newTranscriptFormId+" input[id^=subject_]").removeClass('redBorder');
	 jQuery("#"+newTranscriptFormId+" input[id^=trCourseCode_]").each(function() {
		 var courseId=	jQuery(this).attr('id').split('_')[1];
		 jQuery("#"+newTranscriptFormId+" input[id^=subject_"+courseId+"]").each(function() {
			 	var $current =jQuery(this);
			 	 var currentIdIndex=	$current.attr('id').split('_')[1];
			 	jQuery("#"+newTranscriptFormId+" input[id^=subject_"+courseId+"]").each(function() {
		    	   
		    	    var thisIdIndex=jQuery(this).attr('id').split('_')[1];
		    	  //  alert(jQuery(this).attr('id')+"=="+thisIdIndex +"----"+$current.attr('id')+"=="+currentIdIndex);
		    	   
	    	        if (jQuery(this).val().toUpperCase() == $current.val().toUpperCase() && jQuery(this).attr('id') != $current.attr('id'))
	    	        {
	    	          //  alert('duplicate found!');
	    	            $current.addClass( "redBorder" );
	    	            isDuplicate=true;
	    	            return 1 ;
	    	           
	    	        }
	    	    });
    	   
    	  });
	 });
	 if(isDuplicate){
		 return false; 
	 }
	 return true;
}

function uniqueCourseCode(newTranscriptFormId){
	//alert(newTranscriptFormId+"---Course");
	 var isDuplicate=false;
	 jQuery("#"+newTranscriptFormId+" input[id^=trCourseCode_]").removeClass('redBorder');
	 jQuery("#"+newTranscriptFormId+" input[id^=trCourseCompletionDate_]").removeClass('redBorder');
	 
	 jQuery("#"+newTranscriptFormId+" input[id^=trCourseCode_]").each(function() {
		 	var $current =jQuery(this);
		 	 var currentIdIndex=	$current.attr('id').split('_')[1];
		 	jQuery("#"+newTranscriptFormId+" input[id^=trCourseCode_]").each(function() {
	    	   
	    	    //var thisIdIndex=jQuery(this).attr('id').split('_')[1];
	    	    //alert(jQuery(this).attr('id')+"=="+thisIdIndex +"----"+$current.attr('id')+"=="+currentIdIndex);
	    	    //alert(jQuery(this).attr('id') +"----"+ $current.attr('id'));trCourseCompletionDate_
	    	    var sencondIdIndex = jQuery(this).attr('id').split('_')[1];
	    	    var firstDate = jQuery("#"+newTranscriptFormId+" #trCourseCompletionDate_"+currentIdIndex).val();
	    	    var secondDate = jQuery("#"+newTranscriptFormId+" #trCourseCompletionDate_"+sencondIdIndex).val();
    	        if (jQuery(this).val().toUpperCase() == $current.val().toUpperCase() && jQuery(this).attr('id') != $current.attr('id') && firstDate == secondDate)
    	        {
    	          //  alert('duplicate found!');
    	            $current.addClass( "redBorder" );
    	            jQuery("#"+newTranscriptFormId+" #trCourseCompletionDate_"+currentIdIndex).addClass( "redBorder" );
    	            jQuery("#"+newTranscriptFormId+" #trCourseCompletionDate_"+sencondIdIndex).addClass( "redBorder" );
    	            isDuplicate=true;
    	            return 1 ;
    	           
    	        }
    	    });
    	   
    	  });
	 if(isDuplicate){
		 return false; 
	 }
	 return true;
}
	function findCourseDetails(){
		//alert('in here ctr='+ctr);
		jQuery(".trCourseId"). live('blur',function(){
			var ctr=jQuery(this).attr('id').split("_")[1];
			if( jQuery.trim(jQuery(this).val()) == '') {
				return;
			}
			 var divContainer='';
			 jQuery(this).parents().map(function () {
	                  var strId=this.id;
                	  if (strId.length>0 && strId.indexOf("inrContBox_") >= 0){
                		  //alert( this.tagName+"--------"+this.id);
                		  divContainer=this.id;
                	  }
	                }) 
			jQuery.getJSON("<c:url value="/evaluation/launchEvaluation.html?operation=getCourseDetails"/>&institutionId=${studentInstitutionTranscript.institution.id}&trCourseId="+jQuery(this).val(),
					function (JsonData){
			  	
				if(JsonData.trCourse == null){	
					//alert('in If.....');
					jQuery('#'+divContainer+' #aceExihibitNo_'+ctr).val('');
					jQuery('#'+divContainer+' #trCourseTitle_'+ctr).val('');
					jQuery('#'+divContainer+' #subjectListDiv_'+ctr).html('');
					jQuery('#'+divContainer+' #addSubjectTbl_'+ctr).html('');
					jQuery('#'+divContainer+' #subjectListDiv_'+ctr).html(' <div class="mb10 mt10">'+
                  			'<a href="javascript:void(0);" title="Add New Subject" class="AddNewSubj" id="addNewSubject_'+ctr+'" >Add New Subject</a>'+
                  			'</div>');
					jQuery('#'+divContainer+' #aceExihibitNo_'+ctr).removeAttr("disabled");
					jQuery('#'+divContainer+' #addSubjectTbl_'+ctr).html('<tbody></tbody>');
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
						//alert(JsonData.titleList.length);
						for(i=0;i<JsonData.titleList.length;i++){
							var txt = ""+JsonData.titleList[i].title;
							appendtxt = appendtxt+"<option value="+txt+">"+txt+"</option>";	
							
							var efdt = formatDt(new Date(JsonData.titleList[i].effectiveDate));
							var endt = formatDt(new Date(JsonData.titleList[i].endDate));
							//alert("effectiveDate ----  ");
						
							
							//check if the course completion date falls in range
							if((cmpDate(courseCompletionDate, efdt)<0)&&(cmpDate(courseCompletionDate, endt)>0)){
								jQuery('#'+divContainer+' #trCourseTitle_'+ctr).val(JsonData.titleList[i].title);
								if( (JsonData.trCourse.evaluationStatus).toUpperCase() == 'EVALUATED' ) {
									jQuery('#'+divContainer+' #trCourseTitle_'+ctr).attr("readonly", true);
									jQuery('#'+divContainer+' #evalStatus_'+ctr).val('EVALUATED');
								}
								else {
									jQuery('#'+divContainer+' #trCourseTitle_'+ctr).attr("readonly", false);
									jQuery('#'+divContainer+' #evalStatus_'+ctr).val(JsonData.trCourse.evaluationStatus);
								}
								inRange = true;
							}
						}
					}
					if(!inRange){
						if(JsonData.titleList != null && JsonData.titleList.length == 1){
							//autofill the only value
							jQuery('#'+divContainer+' #trCourseTitle_'+ctr).val(JsonData.titleList[0].title);
							jQuery('#'+divContainer+' #trCourseTitleSelect_'+ctr).attr("disabled","disabled");
						}
						else{
							// enable deo to select titles
							jQuery("#"+divContainer+" #trCourseTitleSelect_"+ctr).html("");
							jQuery("#"+divContainer+" #trCourseTitleSelect_"+ctr).removeAttr("disabled");
							jQuery("#"+divContainer+" #trCourseTitleSelect_"+ctr).append('<option value="">Select Title</option>'+appendtxt);
							
						}
						
					}
					
					jQuery('#'+divContainer+' #aceExihibitNo_'+ctr).val(JsonData.trCourse.aceExhibitNo);
					jQuery('#'+divContainer+' #trCourseTitle_'+ctr).val(JsonData.trCourse.trCourseTitle);
					if( (JsonData.trCourse.evaluationStatus).toUpperCase() == 'EVALUATED' ) {
						jQuery('#'+divContainer+' #aceExihibitNo_'+ctr).attr("disabled","disabled");
					}else{
						jQuery('#'+divContainer+' #aceExihibitNo_'+ctr).removeAttr("disabled");
					}
					if(JsonData.militarySubjectList != null){
						var optionString='';
						 for(i=0;i<JsonData.militarySubjectList.length;i++){
							 var name="'"+JsonData.militarySubjectList[i].name+"'";
							 var courseLevel = "";
							 var socCategoryCode = "";
							 if(JsonData.militarySubjectList[i].courseLevel == null){
								 courseLevel = "''"; 
							 }else{
								 courseLevel = "'"+JsonData.militarySubjectList[i].courseLevel+"'";
							 }
							 if(JsonData.militarySubjectList[i].socCategoryCode == null){
								 socCategoryCode = "''";
							 }else{
								 socCategoryCode="'"+JsonData.militarySubjectList[i].socCategoryCode+"'";
							 }
							 optionString=optionString+'<option value='+name+' socCategoryCode='+socCategoryCode+' courseLevel='+courseLevel+'>'+JsonData.militarySubjectList[i].name+'</option>';
							}
						
						var subjectDiv='<div>Add From Existing Subject list</div>'+
		                '<div><div class="fl">'+
	                      '<label for="select"></label>'+
	                      '<select name="select" id="selectSubject_'+ctr+'"  style=" width:220px; height:80px; margin-top:8px; margin-left:-3px; background-image:none;" multiple="multiple">'+
		                   optionString+'</select>'+
		                   '</div><div class="mt30 fl ml10"><input type="button" id="addSubjectBtn_'+ctr+'" value="Add" class="button"></div>'+
		                  '<div class="clear"></div></div>  <div class="mb10 mt10">'+
                  			'<a href="javascript:void(0);" title="Add New Subject" class="AddNewSubj" id="addNewSubject_'+ctr+'" >Add New Subject</a>'+
                  			'</div>';
						jQuery("#"+divContainer+" #subjectListDiv_"+ctr).html(subjectDiv);
						
					}else{
						jQuery("#"+divContainer+" #subjectListDiv_"+ctr).html(' <div class="mb10 mt10">'+
	                  			'<a href="javascript:void(0);" title="Add New Subject" class="AddNewSubj" id="addNewSubject_'+ctr+'" >Add New Subject</a>'+
	                  			'</div>');
					}
					//jQuery("#addSubjectTbl_"+ctr).html('<tbody></tbody>');
					
				}
		});
	});
}
	
	function subjectMove(){
		
		jQuery("[id^='addSubjectBtn_']"). live('click',function(){
			 var divContainer='';
			 jQuery(this).parents().map(function () {
	                  var strId=this.id;
                	  if (strId.length>0 && strId.indexOf("inrContBox_") >= 0){
                		  //alert( this.tagName+"--------"+this.id);
                		  divContainer=this.id;
                	  }
	                })
			var counter=jQuery(this).attr('id').split("_")[1]
			var courseRowId=0;
			var index=0;
			jQuery("#"+divContainer+" #selectSubject_"+counter+" :selected").each(function(i, selected){ 
                courseRowId = jQuery("#"+divContainer+" #addSubjectTbl_"+counter+" tr:last").attr("id");
        		if(courseRowId == undefined){
        			index = 0;      
        		}else{
					courseRowId = jQuery("#"+divContainer+" #addSubjectTbl_"+counter+" tr:last").attr("id").split("_");
					index = parseInt(courseRowId[2]) + 1;
        		}
        		var courseLvl = jQuery(selected).attr('courseLevel');
        		var socCCode = jQuery(selected).attr('socCategoryCode');
        		if(courseLvl == null){
        			courseLvl ='';
        		}
        		if(socCCode == null){
        			socCCode ='';
        		}
        		var rowSubject='<tr id="rowsubject_'+counter+'_'+index+'">'+
				  ' <td width="51%" style="padding-left:2px;"><input type="text" id="subject_'+counter+'_'+index+'" name="studentTranscriptCourse['+counter+'].transcriptCourseSubjectList['+index+'].militarySubject.name" value="'+jQuery(selected).text()+'" class="textField w80 required" /></td>'+
                ' <td width="10%" style="padding-left:1px;"><input type="text" value=""  id="credit_'+counter+'_'+index+'"  name="studentTranscriptCourse['+counter+'].transcriptCourseSubjectList['+index+'].credit" class="textField w30 required number" /></td>'+
                '<td width="10%" style="padding-left:8px;"><input type="text" value="'+courseLvl+'" id="courseLevel_'+counter+'_'+index+'"  name="studentTranscriptCourse['+counter+'].transcriptCourseSubjectList['+index+'].courseLevel" class="textField w30 required" /></td>'+
                ' <td width="23%" style="padding-left:6px;"><input type="text" value="'+socCCode+'"  id="socCategoryCode_'+counter+'_'+index+'" name="studentTranscriptCourse['+counter+'].transcriptCourseSubjectList['+index+'].militarySubject.socCategoryCode" class="textField w80 " /></td>'+
                ' <td width="5%"><a href="javascript:void(0);" class="removeCrossIcon fl mt5 "></a></td>'+
                ' </tr>';
                jQuery("#"+divContainer+" #addSubjectTbl_"+counter+" > tbody:last").append(rowSubject);
			});
		});
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
			
        },
		minLength: 2,
		 search: function(event, ui) { jQuery(this).addClass("auto-load"); },
		  open: function(event, ui) { jQuery(this).removeClass("auto-load"); }
		  
		
		});
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
	
	window.onload = (function () {
		jQuery(document).ready( function() {
			
			addComments();
			removeComments();
			autoCompleteCourse();
			findCourseDetails();
			subjectMove();
			
			jQuery("[id^='trCourseTitle_']").each(function(){
				jQuery(this).addClass('capitalise');
			});
			 
			jQuery("[id^='trCourseCode_']").live('on keyup', function(event) {
				jQuery(this).val(jQuery(this).val().toUpperCase());
			});
			jQuery("[id^='aceExihibitNo_']").live('on keyup', function(event) {
				jQuery(this).val(jQuery(this).val().toUpperCase());
			});
			jQuery("[id^='courseLevel_']").live('on keyup', function(event) {
				jQuery(this).val(jQuery(this).val().toUpperCase());
			});			
			jQuery("[id^='trCourseTitle_']").live('on keyup', function(event) {
				jQuery(this).addClass('capitalise');
			});
			
			jQuery('.addNoteFrm, #dashLine').hide();
			jQuery("[id^='addNoteLnk_']").click(function(){
				var index=jQuery(this).attr('id').split('_')[1];	
				jQuery('#addNoteFrm_'+index).show();
				
				jQuery(this).hide();
					
			});
			jQuery("[id^='cancelAddComment_']").click(function(){
				var index=jQuery(this).attr('id').split('_')[1];				
				jQuery("#addNoteLnk_"+index).show();				
				jQuery('#addNoteFrm_'+index).hide();
					
			});
			
			 
			 
			 jQuery('.AddNewSubj').live('click',function(){
				 var divContainer='';
				 jQuery(this).parents().map(function () {
		                  var strId=this.id;
	                	  if (strId.length>0 && strId.indexOf("inrContBox_") >= 0){
	                		  //alert( this.tagName+"--------"+this.id);
	                		  divContainer=this.id;
	                	  }
		                })
				 
				 	var counter=jQuery(this).attr('id').split("_")[1];
					var index=0;
					
					var  courseRowId = jQuery("#"+divContainer+" #addSubjectTbl_"+counter+" tr:last").attr("id");
		        		if(courseRowId == undefined){
		        			index = 0;      
		        		}else{
							courseRowId = jQuery("#"+divContainer+" #addSubjectTbl_"+counter+" tr:last").attr("id").split("_");
							index = parseInt(courseRowId[2]) + 1;
		        		}
	                 var rowSubject='  <tr id="rowsubject_'+counter+'_'+index+'">'+
					  ' <td width="51%" style="padding-left:2px;"><input type="text" id="subject_'+counter+'_'+index+'" name="studentTranscriptCourse['+counter+'].transcriptCourseSubjectList['+index+'].militarySubject.name" value="" class="textField w80 required" /></td>'+
	                ' <td width="10%" style="padding-left:1px;"><input type="text" value=""  id="credit_'+counter+'_'+index+'" name="studentTranscriptCourse['+counter+'].transcriptCourseSubjectList['+index+'].credit" class="textField w30 required number" /></td>'+
	                ' <td width="10%" style="padding-left:8px;"><input type="text" value="" id="courseLevel_'+counter+'_'+index+'" name="studentTranscriptCourse['+counter+'].transcriptCourseSubjectList['+index+'].courseLevel" class="textField w30 required" /></td>'+
	                ' <td width="23%" style="padding-left:6px;"><input type="text" value=""  id="socCategoryCode_'+counter+'_'+index+'" name="studentTranscriptCourse['+counter+'].transcriptCourseSubjectList['+index+'].militarySubject.socCategoryCode" class="textField w80 " /></td>'+
	                ' <td width="5%"><a href="javascript:void(0);" class="removeCrossIcon fl mt5 "></a></td>'+
	                ' </tr>';
	                
					 jQuery("#"+divContainer+" #addSubjectTbl_"+counter+" > tbody").append(rowSubject);
			
			});
					
					jQuery('.addCourse').click(function(){
						 var divContainer='';
						 jQuery(this).parents().map(function () {
				                  var strId=this.id;
			                	  if (strId.length>0 && strId.indexOf("inrContBox_") >= 0){
			                		  //alert( this.tagName+"--------"+this.id);
			                		  divContainer=this.id;
			                	  }
				                })
				        //alert("divContainer="+divContainer);       
						//var counterInd=jQuery("[id^='divCourse_']:last").attr('id').split("_")[1];
						var counterInd=0;
						try{
							counterInd = parseInt(jQuery("#"+divContainer+" [id^='divCourse_']:last").attr("id").split("_")[1])+1;
						}catch(err){
							counterInd=0;
						}
						/* var courseRowId=jQuery("[id^='divCourse_']:last").attr('id').split("_")[1];
			        		if(courseRowId == undefined){
			        			counterInd = 0;      
			        		}else{
								courseRowId = jQuery("[id^='divCourse_']:last").attr("id").split("_");
								counterInd = parseInt(courseRowId[1]) + 1;
			        		} */
			        var divContainerIdForTitle = "'"+divContainer+"'";
					var newrow2 = '<div class="dtlCnt" id="divCourse_'+counterInd+'"> '+
				      '<div class="military-dtlCnt">'+
				        '<div>'+
				          '<table width="100%" border="0" cellspacing="0" cellpadding="0" id="transferCourseTbl_'+counterInd+'" name="transferCourseTbl_'+counterInd+'">'+
				            '<tr class="military-grayClr">'+
				              '<td width="9%"><input type="text" name="studentTranscriptCourse['+counterInd+'].completionDate" id="trCourseCompletionDate_'+counterInd+'" class="textField w80 maskDate required" /></td>'+
				              '<td width="9%"><input type="text" name="studentTranscriptCourse['+counterInd+'].trCourseId" id="trCourseCode_'+counterInd+'" class="textField w80 trCourseId required" /></td>'+
				              '<td width="13%"><input type="text" name="studentTranscriptCourse['+counterInd+'].transferCourse.aceExhibitNo" id="aceExihibitNo_'+counterInd+'"  class="textField w80 required" /></td>'+
				              '<td width="33%">'+
				              '<input type="text" name="studentTranscriptCourse['+counterInd+'].transferCourseTitle.title" id="trCourseTitle_'+counterInd+'" class="textField w60per" maxlength="75" onkeyup="javaScript:titleLimit(this);"/> <select class="required valid w90 ml10 required" id="trCourseTitleSelect_'+counterInd+'" disabled="disabled" onchange="fillTitle(this,'+divContainerIdForTitle+');">'+
				      			'<option>Select the Title</option>'+
				    			'</select></td>'+
				              '<td width="7%">&nbsp;</td>'+
				              '<td width="6%">&nbsp;</td>'+
				              '<td width="16%">&nbsp;</td>'+
				              '<td width="3%" align="left" valign="top"><a href="javascript:void(0);" class="removeIcon  mt5 "></a></td>'+
				              '</tr>'+
				            '</table>'+
				          '</div>'+
				        '<div></div> '+   
				        
				        
				        '</div>'+
				      '<div class="military-subtbl">'+
				          '<table width="100%" border="0" cellspacing="0" cellpadding="0">'+
				            '<tr>'+
				              '<td width="30%" align="left" valign="top">  <div id="subjectListDiv_'+counterInd+'">  </div>'+
				          '</td>'+
				              '<td width="61%" colspan="5" valign="top" style="padding-left:0px;">'+
				              '<table width="100%" border="0" cellspacing="0" cellpadding="0" id="addSubjectTbl_'+counterInd+'">'+
				                '<tbody></tbody></table></td>'+
				            '</tr>'+
				            '</table>'+
				        '</div>'+
				      '</div>';
					jQuery("#"+divContainer+" #sho1").append(newrow2);
					settingMaskInput();
					});
			 
				jQuery('#removeBtn').live('click',function(){
					
					jQuery('#addedNote').hide();
					jQuery('#dashLine').hide();
					
					
				
				});	
			 	jQuery('.removeCrossIcon').live('click',function(){
			 		jQuery(this).parent().parent().remove();
				})
				
				jQuery('.removeIcon').live('click',function(){
					jQuery(this).closest('.dtlCnt').remove();			
				})
	
		
		jQuery("h1.expand").toggler(); 
		jQuery("#divContBoxLft").expandAll({trigger: "h1.expand"});
		jQuery("#divContBoxRgt").expandAll({trigger: "h1.expand"});
			
		jQuery('.collapse:first').hide();
		jQuery('h1.expand:first a:first').addClass("close"); 
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
	
		});
});
	
	function submitTranscript(actionUrl2,formName){
		//alert(actionUrl2);
		jQuery("#transferCourseForm").validate();
		var bool=jQuery("#transferCourseForm").valid();
		var uniqueCourseCodeBool= uniqueCourseCode(formName);
		var uniqueSubjectBool=uniqueSubject(formName);
		
		if(bool && uniqueCourseCodeBool && uniqueSubjectBool){
			document.transferCourseForm.action = actionUrl2;
			document.transferCourseForm.submit();
			jQuery('#saveInstitution1').attr("disabled", true);
			jQuery('#MarkComplete').attr("disabled", true);
		}
	}
	function submitRejectedTranscript(rejectedActionUrl,divIdToRefer,formId,buttonId,courseTblId){
		//alert(rejectedActionUrl);
		jQuery("#"+formId).validate();
		var bool=jQuery("#"+formId).valid();
		var uniqueCourseCodeBool= uniqueCourseCode(formId);
		var uniqueSubjectBool=uniqueSubject(formId);
		
		if(bool && uniqueCourseCodeBool && uniqueSubjectBool){
			var found2 = checkForRejectedCoursesRectification(formId);
	    	if(found2 == false){
	    		jQuery("#"+formId+" :input").removeClass( "redBorder" );
	    		var rj2 =  confirm("Please make sure you have rectified all the Rejected Courses or Subjectes."+'\n\n\n\t\t\t\t'+"Press 'OK' if you are sure that you have rectified.");
	    		if(rj2 == false){			
	    			return 0;
	    		}else{
	    			jQuery("#"+formId).submit();
	    			jQuery('#saveInstitution1').attr("disabled", true);
	    			jQuery('#MarkComplete').attr("disabled", true);
	    		}
	    	}else{
	    		alert("Please select all check boxes indicating that corrections have been made to the rejected courses.");
	    	}
		}
	}
	function checkForRejectedCoursesRectification(formId){
		//alert(formId);
		var found = false;
		jQuery('#'+formId+' input:checkbox').each(function() {
			//alert("id="+jQuery(this).attr("id"));
			innerloop:			
			if (!jQuery(this).is(':checked')) {
				found = true;
				//alert("Please select all the check boxes, if you are sure you have rectified all the courses");
				break innerloop;
	    	}
		}); 
		return found;
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
	function titleLimit(titleValue){
		
		var limitNum = 75;
		if (titleValue.value.length >= limitNum) {
			var elementId = jQuery(titleValue).attr("id");
			jQuery("#"+elementId).addClass("redBorder");
			alert("you can fill up to 75 charater.");
			return false;
	    } 
	}
	function fillTitle(selected, tableId){
		//alert(tableId);
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
</script>
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
  
  <ul id="addTopNav" class="floatLeft top-nav-tabml ml20">
   	 <c:set var="upperTabIndexToAppend" value="2"/>
              <li><a class="on" id="tablink_1" href="javascript:void(0)"><span>New Transcript</span></a></li>
           <c:forEach items="${studentInstitutionTranscriptSummaryList }" var="studentInstitutionTranscriptSummary" varStatus="transcriptIndex">
	           		<c:set var="upperTabIndexToAppend" value="${upperTabIndexToAppend + transcriptIndex.index}"/>
	        		<c:if test="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.official eq true }">
	              		<li><a id="tablink_${upperTabIndexToAppend }" href="javascript:void(0)"><span>Official - <fmt:formatDate value="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.createdDate}" pattern="MM/dd/yyyy"/></span></a></li>
	                </c:if>
	                <c:if test="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.official eq false }">
	              		<li><a id="tablink_${upperTabIndexToAppend }" href="javascript:void(0)"><span>Un-Official - <fmt:formatDate value="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.createdDate}" pattern="MM/dd/yyyy"/></span></a></li>
	                </c:if>
            </c:forEach>
    </ul>
  <br class="clear">
      <div id="addDyndivs" class="tabBorder contentForm">
       <c:set var="now" value="<%=new java.util.Date()%>"/>
    <form name="transferCourseForm" id="transferCourseForm" method="post">
    <div id="inrContBox_1">
    	<div class="mt30">
        
        	<div class="dateReceived">
            	
                <label class="noti-label w100">Date Received: </label>
             
                    <input type="text" id="dateReceivedCur" name="dateReceived" value="<fmt:formatDate value='${!empty studentInstitutionTranscript.dateReceived ?studentInstitutionTranscript.dateReceived:now}' pattern='MM/dd/yyyy'/>" class="textField w80px maskDate required">
            
            </div>
        	<div class="lastAttend">
            
            	<label class="noti-label w100">Last Attended:</label>
                    <input type="text" name="lastAttendenceDate" value="<fmt:formatDate value='${studentInstitutionTranscript.lastAttendenceDate}' pattern='MM/dd/yyyy'/>" class="textField w80px maskDate ">
            
            </div>
        	<div class="tanscriptType">
            <label class="noti-label w110">Transcript Type:</label>
	            <%-- <c:choose>
			          <c:when test="${!empty studentInstitutionTranscript }">
			              <label class="mr22" style="margin-top:5px;">
			                <input type="radio" name="official" value="false" id="RadioGroup1_0" <c:if test="${studentInstitutionTranscript.official eq false}"> checked</c:if> />
			                Un-official
			                </label>
			             
			              <label style="margin-top:5px;">
			                <input type="radio" name="official" value="true" id="RadioGroup1_1" <c:if test="${studentInstitutionTranscript.official eq true}"> checked</c:if>/>
			                Official
			                </label>
			          </c:when>
		            <c:otherwise>
		            	 <label class="mr22" style="margin-top:5px;">
			                <input type="radio" name="official" value="false" id="RadioGroup1_0"/>
			                Un-official
			                </label>
			             
			              <label style="margin-top:5px;">
			                <input type="radio" name="official" value="true" id="RadioGroup1_1"/>
			                Official
			                </label>            
		            </c:otherwise>
	            </c:choose> --%>
	               <label class="mr22" style="margin-top:5px;">
		                <input type="radio" name="official" value="false" id="RadioGroup1_0"/>
		                Un-official
		            </label>
		             
		            <label style="margin-top:5px;">
		                <input type="radio" name="official" value="true" checked="checked" id="RadioGroup1_1"/>
		                Official
		            </label> 
            </div>
        	<div class="clear"></div>            
        
        </div>
	
    	
          <div>
          <div class="tabHeader">Course(s) Details</div>
            <div>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="military-tbl tabTBLborder">
				  <tr>
				    <th width="9%" scope="col" class="dividerGrey">Date Completed<br />
					<span class="mandatoryTxt">(mm/dd/yyyy)</span></th>
				    <th width="9%" scope="col" class="dividerGrey">Military Course No.</th>
				    <th width="13%" scope="col" class="dividerGrey">ACE Exhibit No.</th>
				    <th width="34%" scope="col" class="dividerGrey">Transfer Course Title and Subject(s)</th>
				    <th width="7%" align="center" class="dividerGrey" scope="col">Credits </th>
				    <th width="6%" align="center" class="dividerGrey" scope="col">Course Level</th>
				    <th width="16%" scope="col">SOC Category Code</th>
				    <th width="2%" scope="col">&nbsp;</th>
				  </tr>
				  <tr>
					    <td colspan="8">					    
						     <div id="sho1">
						     <c:choose>
								<c:when test="${empty studentTranscriptCourseList}">
								     <div class="dtlCnt" id="divCourse_0" >
								      <div class="military-dtlCnt">
								        
								        <div>
								          <table name="transferCourseTbl" id="transferCourseTbl" width="100%" border="0" cellspacing="0" cellpadding="0">
									          
										  			<tr id="courseRow_0" class="military-grayClr">
										              <td width="9%">
										              	<input type="text" name="studentTranscriptCourse[0].completionDate" value="" id="trCourseCompletionDate_0" class="textField w80 maskDate required" />
										              </td>
										              <td width="9%">
										              	<input type="text" name="studentTranscriptCourse[0].trCourseId" value="" id="trCourseCode_0" class="textField w80 trCourseId required" />
										              </td>
										              <td width="13%">
										              	<input type="text" name="studentTranscriptCourse[0].transferCourse.aceExhibitNo" value="" id="aceExihibitNo_0"class="textField w80 required" />
										              </td>
										              <td width="32%">
										              		<input type="text" name="studentTranscriptCourse[0].transferCourseTitle.title"  id="trCourseTitle_0" value="" class="textField w60per  required" maxlength="75" onkeyup="javaScript:titleLimit(this);" /> 
										              	<select class="required valid w90 ml10" name="" id="trCourseTitleSelect_0" onchange="fillTitle(this,'inrContBox_1');">
												      			<option>Select the Title</option>
												    		</select>
												   	 </td>
									                 <td width="7%">&nbsp;</td>
									                 <td width="6%">&nbsp;</td>
									                 <td width="16%">&nbsp;</td>
									                 <td width="3%" align="left" valign="top"><a href="javascript:void(0);" class="removeIcon mt5 "></a></td>
									              </tr>
										  		
											  			
									              
								            
								            </table>
								          </div>
								        <div></div>     
								        
								        </div>
								      <div class="military-subtbl">
								          <table width="100%" border="0" cellspacing="0" cellpadding="0" id="transcriptCourseSubject_0">
								            <tr>
								              <td width="30%" align="left" valign="top">
									              <div id="subjectListDiv_0">
									              </div>
								              </td>
								              <td width="61%" colspan="5" valign="top" style="padding-left:0px;">
									              <table width="100%" border="0" cellspacing="0" cellpadding="0" id="addSubjectTbl_0">
										              <tbody>
										                
										               </tbody>
									                </table>
									           </td>
								            </tr>
								            </table>
								        </div>
								      </div>
						     </c:when>
							 <c:otherwise>
								<c:forEach items="${studentTranscriptCourseList}" var="studentTranscriptCourse" varStatus="loop">
									<div class="dtlCnt" id="divCourse_${loop.index }" >
								      <div class="military-dtlCnt">
								        
								        <div>
								          <table name="transferCourseTbl_${loop.index }" id="transferCourseTbl_${loop.index }" width="100%" border="0" cellspacing="0" cellpadding="0">
									          <tr id="courseRow_${loop.index }" class="military-grayClr">
											              <td width="9%">
											              	<input type="text" name="studentTranscriptCourse[${loop.index }].completionDate"  id="trCourseCompletionDate_${loop.index }" class="textField w80 maskDate required" value="<fmt:formatDate value='${studentTranscriptCourse.completionDate}' pattern='MM/dd/yyyy'/>"/>
											              </td>
											              <td width="9%">
											              	<input type="text" name="studentTranscriptCourse[${loop.index }].trCourseId" value="${studentTranscriptCourse.trCourseId}" id="trCourseCode_${loop.index }" class="textField w80 trCourseId required" />
											              </td>
											              <td width="13%">
											              	<input type="text" name="studentTranscriptCourse[${loop.index }].transferCourse.aceExhibitNo" <c:if test="${studentTranscriptCourse.transferCourse.evaluationStatus eq 'EVALUATED' }"> disabled="disabled"</c:if> value="${studentTranscriptCourse.transferCourse.aceExhibitNo}" id="aceExihibitNo_${loop.index }"class="textField w80 required" />
											              </td>
											              <td width="32%">
											              		<input type="text" name="studentTranscriptCourse[${loop.index }].transferCourseTitle.title"  id="trCourseTitle_${loop.index }" value="${studentTranscriptCourse.courseTitle}" class="textField w60per required"  maxlength="75" onkeyup="javaScript:titleLimit(this);"/> 
											              		<select class="required valid w90 ml10" name="" id="trCourseTitleSelect_${loop.index }" onchange="fillTitle(this,'inrContBox_1');" <c:if test="${fn:length(studentTranscriptCourse.transferCourseTitleList) eq 1 }"> disabled="disabled"</c:if>>
													      			<option>Select the Title</option>
													      			<c:forEach items="${studentTranscriptCourse.transferCourseTitleList}" var="transferCourseTitle">
																		<option value="${transferCourseTitle.title }">${transferCourseTitle.title }</option>
																	</c:forEach>		    
													    		</select>
													   	 </td>
										                 <td width="7%">&nbsp;</td>
										                 <td width="6%">&nbsp;</td>
										                 <td width="16%">&nbsp;</td>
										                 <td width="3%" align="left" valign="top"><a href="javascript:void(0);" class="removeIcon mt5 "></a></td>
									           </tr>
								            </table>
								          </div>
								        <div></div>     
								        
								        </div>
								        
									      <div class="military-subtbl">
									          <table width="100%" border="0" cellspacing="0" cellpadding="0" id="transcriptCourseSubject_${loop.index }">
									            <tr>
									              <td width="30%" align="left" valign="top">
										              <div id="subjectListDiv_${loop.index }">
											              <c:if test="${fn:length(studentTranscriptCourse.militarySubjectList) gt 0 }">
												              	<div>Add From Existing Subject list</div>
												              	<div>
																	<div class="fl">
																		<label for="select">
																		</label>
																		<select multiple="multiple" style=" width:220px; height:80px; margin-top:8px; margin-left:-3px; background-image:none;" id="selectSubject_${loop.index }" name="select">
																			<c:forEach items="${studentTranscriptCourse.militarySubjectList}" var="militarySubject" varStatus="militarySubjectIndex">																		
																					<option courselevel="${militarySubject.courseLevel }" soccategorycode="${militarySubject.socCategoryCode }" value="${militarySubject.id }">${militarySubject.name }</option>
																			</c:forEach>
																		</select>
																	</div>
																	<div class="mt30 fl ml10">
																		<input type="button" class="button" value="Add" id="addSubjectBtn_${loop.index }">
																	</div>
																	<div class="clear">
																	</div>
																</div>
															</c:if>
															<div class="mb10 mt10">
																<a id="addNewSubject_${loop.index }" class="AddNewSubj" title="Add New Subject" href="javascript:void(0);">Add New Subject</a>
															</div>  
										              </div>
										           
									              </td>
									              <td width="61%" colspan="5" valign="top" style="padding-left:0px;">
										              																	
												              <table width="100%" border="0" cellspacing="0" cellpadding="0" id="addSubjectTbl_${loop.index }">
													              <tbody>
														                <c:forEach items="${studentTranscriptCourse.transcriptCourseSubjectList}" var="transcriptCourseSubject" varStatus="transcriptCourseSubjectIndex">
														                	<tr id="rowsubject_${loop.index }_${transcriptCourseSubjectIndex.index }"> 
																				<td width="51%" style="padding-left:2px;">
																					<input type="text" class="textField w80 required"  name="studentTranscriptCourse[${loop.index }].transcriptCourseSubjectList[${transcriptCourseSubjectIndex.index }].militarySubject.name" id="subject_${loop.index }_${transcriptCourseSubjectIndex.index }" value="${transcriptCourseSubject.militarySubject.name }">
																				</td> 
																				<td width="10%" style="padding-left:1px;">
																					<input type="text" class="textField w30 required number" name="studentTranscriptCourse[${loop.index }].transcriptCourseSubjectList[${transcriptCourseSubjectIndex.index }].credit" id="credit_${loop.index }_${transcriptCourseSubjectIndex.index }" value="${transcriptCourseSubject.credit }">
																				</td> 
																				<td width="10%" style="padding-left:8px;">
																					<input type="text" class="textField w30 required" name="studentTranscriptCourse[${loop.index }].transcriptCourseSubjectList[${transcriptCourseSubjectIndex.index }].courseLevel" id="courseLevel_${loop.index }_${transcriptCourseSubjectIndex.index }" value="${transcriptCourseSubject.courseLevel }">
																				</td> 
																				<td width="23%" style="padding-left:6px;">
																					<input type="text" class="textField w80 " name="studentTranscriptCourse[${loop.index }].transcriptCourseSubjectList[${transcriptCourseSubjectIndex.index }].militarySubject.socCategoryCode" id="socCategoryCode_${loop.index }_${transcriptCourseSubjectIndex.index }" value="${transcriptCourseSubject.militarySubject.socCategoryCode }">
																				</td> 
																				<td width="5%"><a class="removeCrossIcon fl mt5 " href="javascript:void(0);"></a></td> 
																		</tr>
														                	
														                </c:forEach>
													               </tbody>
												                </table>
											             
										           </td>
									            </tr>
									            </table>
									        </div>
									      
								      
								      </div>
								  </c:forEach> 
		  					</c:otherwise>
		  	  			</c:choose> 
						      </div>
					      </td>
				  </tr>
    </table>
            </div>
            	
	<div><a href="javascript:void(0);" class="addCourse" id="Addcrs">Add Course</a></div>
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
			
        			<input type="hidden" name="id" id="studentInstitutionTranscriptId" value="${studentInstitutionTranscript.id}" />
		            <input type="hidden" id="selinstitutionId" name="institution.id" value="${selectedInstitution.id}" />
		                   
				   	<input type="hidden" name="evaluationStatus" id="evaluationStatus" value="" />
				   	<input type="hidden" name="lastDateForLastCourse" id="lastDateForLastCourse" value='<fmt:formatDate value="${studentInstitutionTranscript.lastDateForLastCourse}" pattern="MM/dd/yyyy hh:mm:ss:SSS"/>' />
				   
				   	<input type="hidden" name="createdBy" id="createdBy" value="${studentInstitutionTranscript.createdBy}" />
				   
				   	
				   	<input type="hidden" name="studentCrmId" id="studentCrmId" value="${student.crmId}" />
				   	<input type="hidden" name="programVersionCode" id="programVersionCode"  value="${courseInfo.programVersionCode}" />
				   	<input type="hidden" name="programDesc"  value="${courseInfo.programDesc}" />
				   	<input type="hidden" name="catalogCode"  value="${courseInfo.catalogCode}" />
				   	<input type="hidden" name="stateCode"  value="${courseInfo.stateCode}" />
				   	
				   	
				    <input type="hidden" name="coursesAdded" value="" />
				    <input type="hidden" name="expectedStartDateString" id="expectedStartDateString" value="<fmt:formatDate value='${courseInfo.expectedStartDate}' pattern='MM/dd/yyyy' />" />
				    <input type="hidden" name="institutionId" id="institutionId" value="${studentInstitutionTranscript.institution.id}" />
				    <input type="hidden" name="studentId" id="studentId" value="${student.id}" />
				   	<input type="hidden" name="institutionAddressId" id="institutionAddressId" value="${studentInstitutionTranscript.institutionAddress.id}"/>
       
        <div class="BorderLine"></div>
        <div>
	          <div class="fr">  
	          	<input type="button" name="saveInstitution1" value="Save" id="saveInstitution1" class="button" onclick="submitTranscript('<c:url value="/evaluation/launchEvaluation.html?operation=saveMilitaryTranscriptIntoDraftMode"/>','transferCourseForm');">            
				<input type="button" name="MarkComplete" value="Mark Complete" id="MarkComplete" class="button" id="submitTrCourses" onclick="submitTranscript('<c:url value="/evaluation/launchEvaluation.html?operation=markMilitaryTranscriptToComplete&markCompleted=true"/>','transferCourseForm');">
			</div>
	        <div class="clear"></div>
    	</div>
    	 
     </div>
     </form> 
     <c:set var="tabIndexToAppend" value="2"/>
     <c:set var="divTabIndexToAppend" value="1"/>
	   <c:forEach items="${studentInstitutionTranscriptSummaryList }" var="studentInstitutionTranscriptSummary" varStatus="transcriptSummaryIndex">
		    <%-- <c:if test="${fn:length(studentInstitutionTranscriptSummary.studentInstitutionTranscript.studentTranscriptCourse) gt 0}"> --%>
		    <c:set var="tabIndexToAppend" value="${transcriptSummaryIndex.index + tabIndexToAppend }"/>
		    <c:set var="firstRejectedDivId" value="0"/>
		    <c:set var="rejectedTranscriptFound" value="0"/>
		   		<c:choose>
		    		<c:when test="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.evaluationStatus ne 'REJECTED' && studentInstitutionTranscriptSummary.studentInstitutionTranscript.evaluationStatus ne 'REJECTED INSTITUTION'}">
		    		    <div id="inrContBox_${tabIndexToAppend }" style="display:none;">
						    	<div class="mt30">        
						        	<div class="dateReceived">
						            	
						                <label class="noti-label w100">Date Received:</label>
									   <label style="margin-top:3px;"> <fmt:formatDate value='${studentInstitutionTranscriptSummary.studentInstitutionTranscript.dateReceived }' pattern='MM/dd/yyyy'/></label>
						            
						            </div>
						        	<div class="lastAttend">            
						            	<label class="noti-label w100">Last Attended:</label>
									   <label style="margin-top:3px;">  <fmt:formatDate value='${studentInstitutionTranscriptSummary.studentInstitutionTranscript.lastAttendenceDate }' pattern='MM/dd/yyyy'/></label>
						            </div>
						            
						        	<div class="tanscriptType">
							            <label class="noti-label w110">Transcript Type:</label>
										<label style="margin-top:3px;">
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
	                        <div class="tabHeader">Course(s) Details</div>
	                        <div>
								<table width="100%" border="0" cellspacing="0" cellpadding="0" class="military-tbl tabTBLborder">
									  <tr>
									    <th width="9%" scope="col" class="dividerGrey">Date Completed<br />
										<span class="mandatoryTxt">(mm/dd/yyyy)</span></th>
									    <th width="9%" scope="col" class="dividerGrey">Military Course No.</th>
									    <th width="13%" scope="col" class="dividerGrey">ACE Exhibit No.</th>
									    <th width="34%" scope="col" class="dividerGrey">Transfer Course Title and Subject(s)</th>
									    <th width="7%" align="center" class="dividerGrey" scope="col">Credits </th>
									    <th width="6%" align="center" class="dividerGrey" scope="col">Course Level</th>
									    <th width="16%" scope="col">SOC Category Code</th>
									    <th width="2%" scope="col">&nbsp;</th>
									  </tr>
									 <c:forEach items="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.studentTranscriptCourse}" var="studentTranscriptCourse" varStatus="loop"> 
									  <tr>
										    <td colspan="8">					    
											     <div id="sho">
													 <div class="dtlCnt" id="divCourse_${loop.index }" >
													      <div class="military-dtlCnt">
													        
													        <div>
													          <table width="100%" border="0" cellspacing="0" cellpadding="0">
														          
															  			<tr id="courseRow_${loop.index}" class="military-grayClr">
															              <td width="9%">
															              		<fmt:formatDate value='${studentTranscriptCourse.completionDate}' pattern='MM/dd/yyyy'/>
															              </td>
															              <td width="9%">
															              		${studentTranscriptCourse.trCourseId}
															              </td>
															              <td width="13%">
															              		${studentTranscriptCourse.transferCourse.aceExhibitNo}
															              </td>
															              <td width="32%">
															              		${studentTranscriptCourse.courseTitle}
																	   	 </td>
														                 <td width="7%">&nbsp;</td>
														                 <td width="6%">&nbsp;</td>
														                 <td width="16%">&nbsp;</td>
														                 <td width="3%" align="left" valign="top">&nbsp;</td>
														              </tr>
													            </table>
													          </div>
													        <div></div>     
													        
													        </div>
													      <div class="military-subtbl">
													          <table width="100%" border="0" cellspacing="0" cellpadding="0" id="transcriptCourseSubject_${loop.index }">
													            <tr>
													              <td width="30%" align="left" valign="top">
														              <div id="subjectListDiv_${loop.index }">
																		             <%--  <c:if test="${fn:length(studentTranscriptCourse.militarySubjectList) gt 0 }">
																			              	<div>Add From Existing Subject list</div>
																			              	<div>
																								<div class="fl">
																									<label for="select">
																									</label>
																									<select multiple="multiple" style=" width:220px; height:80px; margin-top:8px; margin-left:-3px; background-image:none;" id="selectSubject_${loop.index }" name="select">
																										<c:forEach items="${studentTranscriptCourse.militarySubjectList}" var="militarySubject" varStatus="militarySubjectIndex">																		
																												<option courselevel="${militarySubject.courseLevel }" soccategorycode="${militarySubject.socCategoryCode }" value="${militarySubject.id }">${militarySubject.name }</option>
																										</c:forEach>
																									</select>
																								</div>
																								<div class="mt30 fl ml10">
																									&nbsp;
																								</div>
																								<div class="clear">
																								</div>
																							</div>
																						</c:if> --%>
																						<div class="mb10 mt10">
																							&nbsp;
																						</div>  
																	              </div>
													              </td>
													              <td width="61%" colspan="5" valign="top" style="padding-left:0px;">
														           	<table width="100%" border="0" cellspacing="0" cellpadding="0" id="addSubjectTbl_${loop.index }">
																				              <tbody>
																					                <c:forEach items="${studentTranscriptCourse.transcriptCourseSubjectList}" var="transcriptCourseSubject" varStatus="transcriptCourseSubjectIndex">
																					                	<tr id="rowsubject_${loop.index }_${transcriptCourseSubjectIndex.index }"> 
																											<td width="51%" style="padding-left:2px;">
																												${transcriptCourseSubject.militarySubject.name }
																											</td> 
																											<td width="10%" style="padding-left:1px;">
																												${transcriptCourseSubject.credit }
																											</td> 
																											<td width="10%" style="padding-left:8px;">
																												${transcriptCourseSubject.courseLevel }
																											</td> 
																											<td width="23%" style="padding-left:6px;">
																												${transcriptCourseSubject.militarySubject.socCategoryCode }
																											</td> 
																											<td width="5%">&nbsp;</td> 
																										</tr>
																					                	
																					                </c:forEach>
																				               </tbody>
																		</table>																	             
																	</td>
													            </tr>
													            </table>
													        </div>
													        										   
											      </div></div>
										      </td>
									  </tr>
								
							</c:forEach>
							</table>
							<table width="100%">
								<tr>
									<td  width="100%">
							 <div class="BorderLine"></div>
      							<div class="mb10 createdby"><strong>Created By:</strong> ${studentInstitutionTranscriptSummary.studentInstitutionTranscript.user.firstName } &nbsp;${studentInstitutionTranscriptSummary.studentInstitutionTranscript.user.lastName }</div>
      	     					 </td>
									  </tr>
									  </table>
				     			 
							
							<table  width="100%">
								<tr>
									<td colspan="8">  
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
										             <input type="button" value="Add" id="addComment_${tabIndexToAppend}" />&nbsp;&nbsp;<input type="button" value="Cancel" id="cancelAddComment_${tabIndexToAppend}" />
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
										       <div class="notedashbdr" id="dashLine"></div>
									</td>
								</tr>	  			  
					    </table>
	             	</div>
					  </div>
					  
					</c:when>
					<c:otherwise>
						<c:set var="rejectedTranscriptFound" value="${rejectedTranscriptFound +1 }"/>
	    			      <form name="transferCourseForm${divTabIndexToAppend }" id="transferCourseFormId${divTabIndexToAppend }" method="post" action="<c:url value="/evaluation/launchEvaluation.html?operation=markRectifyMilitaryCourseToComplete&markCompleted=true" />"><!--//launchEvaluation.html?operation=markTranscriptComplete -->
			         	 	
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
						             			<div class="mt30">
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
										        	<div class="dateReceived">
										            	
										                <label class="noti-label w100">Date Received:</label>
													    <fmt:formatDate value='${studentInstitutionTranscriptSummary.studentInstitutionTranscript.dateReceived }' pattern='MM/dd/yyyy'/>
										            
										            </div>
										        	<div class="lastAttend">            
										            	<label class="noti-label w100">Last Attended:</label>
													    <fmt:formatDate value='${studentInstitutionTranscriptSummary.studentInstitutionTranscript.lastAttendenceDate }' pattern='MM/dd/yyyy'/>
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
		                        			
					                        <div>
					                        	<div class="tabHeader">Course(s) Details</div>
					                        	 <div>
												<table width="100%" border="0" cellspacing="0" name="transferCourseTbl${divTabIndexToAppend }" id="transferCourseTbl${divTabIndexToAppend }" cellpadding="0" class="military-tbl tabTBLborder">
													  <tr>
													    <th width="9%" scope="col" class="dividerGrey">Date Completed<br />
														<span class="mandatoryTxt">(mm/dd/yyyy)</span></th>
													    <th width="9%" scope="col" class="dividerGrey">Military Course No.</th>
													    <th width="13%" scope="col" class="dividerGrey">ACE Exhibit No.</th>
													    <th width="34%" scope="col" class="dividerGrey">Transfer Course Title and Subject(s)</th>
													    <th width="7%" align="center" class="dividerGrey" scope="col">Credits </th>
													    <th width="6%" align="center" class="dividerGrey" scope="col">Course Level</th>
													    <th width="16%" scope="col">SOC Category Code</th>
													    <th width="4%" scope="col">Corrected</th>
													    <th width="2%" scope="col">&nbsp;</th>
													  </tr>
													 
													  <tr class="applyRejectClass">
														    <td colspan="9">					    
															     <div id="sho1">
															     <c:forEach items="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.studentTranscriptCourse}" var="studentTranscriptCourse" varStatus="loop">
																	<c:set var="rejectClass" value=""></c:set>
																	<c:set var="rejectTrClass" value=""></c:set>
															        <c:if test="${studentTranscriptCourse.transcriptStatus eq'REJECTED'}">  
																		<c:set var="rejectClass" value="errorClass"></c:set>
																		<c:set var="rejectTrClass" value="errorColorfrTbl"></c:set>																		
																	
																		<script type="text/javascript">
																			jQuery(".applyRejectClass").addClass('${rejectTrClass}');
																		</script>
																	 </c:if>
																	 <div class="dtlCnt" id="divCourse_${loop.index }" >
																	      <div class="military-dtlCnt">
																	        
																	        <div>
																	          <table width="100%" border="0" cellspacing="0" cellpadding="0">
																		          
																			  			<tr id="courseRow_${loop.index}" class="military-grayClr ${rejectTrClass }">
																			              <td width="9%">
																			              	<input type="text" name="studentTranscriptCourse[${loop.index }].completionDate"  id="trCourseCompletionDate_${loop.index }" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if> class="textField w80 ${rejectClass } maskDate required" value="<fmt:formatDate value='${studentTranscriptCourse.completionDate}' pattern='MM/dd/yyyy'/>"/>
																			              </td>
																			              <td width="9%">
																				              	<input type="hidden" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>  id="transcriptStatus_${loop.index}" name="studentTranscriptCourse[${loop.index}].transcriptStatus" value="${studentTranscriptCourse.transcriptStatus}" />
																				            	<input type="hidden"<c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>  name="hasUnsavedValues_${loop.index}" id="hasUnsavedValues_${loop.index}" value="0" />
																				            	<input type="hidden" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>   name="studentTranscriptCourse[${loop.index}].id" value="${studentTranscriptCourse.id}" />
																				            	<input type="hidden" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>   name="studentTranscriptCourse[${loop.index}].createdBy" value="${studentTranscriptCourse.createdBy}" />	
																				              	<input type="text" name="studentTranscriptCourse[${loop.index }].trCourseId" value="${studentTranscriptCourse.trCourseId}" id="trCourseCode_${loop.index }"  <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if> class="textField ${rejectClass } w80 trCourseId required" />
																			              </td>
																			              <td width="13%">
																			              	<input type="text" name="studentTranscriptCourse[${loop.index }].transferCourse.aceExhibitNo" value="${studentTranscriptCourse.transferCourse.aceExhibitNo}" id="aceExihibitNo_${loop.index }" disabled="disabled" class="textField ${rejectClass } w80 required" />
																			              </td>
																			              <td width="33%">
																			              		<input type="text" name="studentTranscriptCourse[${loop.index }].transferCourseTitle.title"  id="trCourseTitle_${loop.index }" value="${studentTranscriptCourse.courseTitle}"  <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if> class="textField ${rejectClass } w60per" maxlength="75" onkeyup="javaScript:titleLimit(this);"/> 
																			              		<select class="required valid w90 ml10" name="" id="trCourseTitleSelect_${loop.index }" onchange="fillTitle(this,'inrContBox_${tabIndexToAppend }');"  <c:if test="${fn:length(studentTranscriptCourse.transferCourseTitleList) eq 1 }"> disabled="disabled"</c:if>>
																					      			<option>Select the Title</option>
																					      			<c:forEach items="${studentTranscriptCourse.transferCourseTitleList}" var="transferCourseTitle">
																										<option value="${transferCourseTitle.title }">${transferCourseTitle.title }</option>
																									</c:forEach>		    
																					    		</select>
																					   	 </td>
																		                 <td width="7%">&nbsp;</td>
																		                 <td width="6%">&nbsp;</td>
																		                 <td width="16%">&nbsp;</td>
																		                 <td width="4%"><input type="checkbox" style="margin:10px 0px 0px 20px;" class="errCrctd" courseid="${studentTranscriptCourse.id}" studentid="${student.id}" id="errCrctd_${loop.index }" name="errCrctd_${loop.index }"></td>
																		                 <td width="3%" align="left" valign="top"><a href="javascript:void(0);" class="removeIcon mt5"></a></td>
																		              </tr>
																	            </table>
																	          </div>
																	        <div></div>     
																	        
																	        </div>
																	      <div class="military-subtbl">
																	          <table width="100%" border="0" cellspacing="0" cellpadding="0" id="transcriptCourseSubject_${loop.index }">
																	            <tr>
																	              <td width="30%" align="left" valign="top">
																		              <div id="subjectListDiv_${loop.index }">
																						     <c:if test="${fn:length(studentTranscriptCourse.militarySubjectList) gt 0 }">
																							              	<div>Add From Existing Subject list</div>
																							              	<div>
																												<div class="fl">
																													<label for="select">
																													</label>
																													<select multiple="multiple" style=" width:220px; height:80px; margin-top:8px; margin-left:-3px; background-image:none;" id="selectSubject_${loop.index }" name="select">
																														<c:forEach items="${studentTranscriptCourse.militarySubjectList}" var="militarySubject" varStatus="militarySubjectIndex">																		
																																<option courselevel="${militarySubject.courseLevel }" soccategorycode="${militarySubject.socCategoryCode }" value="${militarySubject.id }">${militarySubject.name }</option>
																														</c:forEach>
																													</select>
																												</div>
																												<div class="mt30 fl ml10">
																													<input type="button" id="addSubjectBtn_${loop.index }" value="Add" class="button">
																												</div>
																												<div class="clear">
																												</div>
																											</div>
																								   </c:if>
																								   <div class="mb10 mt10">
																										<a id="addNewSubject_${loop.index }" class="AddNewSubj" title="Add New Subject" href="javascript:void(0);">Add New Subject</a>
																									</div>  
																					  </div>
																	              </td>
																	              <td width="61%" colspan="5" valign="top" style="padding-left:0px;">
																		           	 <table width="100%" border="0" cellspacing="0" cellpadding="0" id="addSubjectTbl_${loop.index }">
																								              <tbody>
																									                <c:forEach items="${studentTranscriptCourse.transcriptCourseSubjectList}" var="transcriptCourseSubject" varStatus="transcriptCourseSubjectIndex">
																									                	<tr id="rowsubject_${loop.index }_${transcriptCourseSubjectIndex.index }"> 
																															<td width="38%" style="padding-left:2px;">
																																<input type="hidden" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>  id="transcriptStatus_${loop.index}" name="studentTranscriptCourse[${loop.index}].transcriptCourseSubject[${transcriptCourseSubjectIndex.index }].transcriptStatus" value="${transcriptCourseSubject.transcriptStatus}" />
																												            	<input type="hidden" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>   name="studentTranscriptCourse[${loop.index}].transcriptCourseSubject[${transcriptCourseSubjectIndex.index }].subjectId" value="${transcriptCourseSubject.subjectId}" />
																												            	<input type="hidden" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>   name="studentTranscriptCourse[${loop.index}].transcriptCourseSubject[${transcriptCourseSubjectIndex.index }].id" value="${transcriptCourseSubject.id}" />
																												            	<input type="hidden" <c:if test="${studentTranscriptCourse.transcriptStatus ne 'REJECTED' }"> disabled="disabled"</c:if>   name="studentTranscriptCourse[${loop.index}].transcriptCourseSubject[${transcriptCourseSubjectIndex.index }].createdBy" value="${transcriptCourseSubject.createdBy}" />
																												            		
																																<input type="text" class="textField w80 <c:if test="${transcriptCourseSubject.transcriptStatus=='REJECTED'}">   ${rejectClass } </c:if> required"  name="studentTranscriptCourse[${loop.index }].transcriptCourseSubjectList[${transcriptCourseSubjectIndex.index }].militarySubject.name" id="subject_${loop.index }_${transcriptCourseSubjectIndex.index }" value="${transcriptCourseSubject.militarySubject.name }">
																															</td> 
																															<td width="7%">
																																<input type="text" class="textField w30 <c:if test="${transcriptCourseSubject.transcriptStatus=='REJECTED'}">   ${rejectClass } </c:if> required number" name="studentTranscriptCourse[${loop.index }].transcriptCourseSubjectList[${transcriptCourseSubjectIndex.index }].credit" id="credit_${loop.index }_${transcriptCourseSubjectIndex.index }" value="${transcriptCourseSubject.credit }">
																															</td> 
																															<td width="7%">
																																<input type="text" class="textField w30 <c:if test="${transcriptCourseSubject.transcriptStatus=='REJECTED'}">   ${rejectClass } </c:if> required" name="studentTranscriptCourse[${loop.index }].transcriptCourseSubjectList[${transcriptCourseSubjectIndex.index }].courseLevel" id="courseLevel_${loop.index }_${transcriptCourseSubjectIndex.index }" value="${transcriptCourseSubject.courseLevel }">
																															</td> 
																															<td width="16%">
																																<input type="text" class="textField w80 <c:if test="${transcriptCourseSubject.transcriptStatus=='REJECTED'}">   ${rejectClass } </c:if>" name="studentTranscriptCourse[${loop.index }].transcriptCourseSubjectList[${transcriptCourseSubjectIndex.index }].militarySubject.socCategoryCode" id="socCategoryCode_${loop.index }_${transcriptCourseSubjectIndex.index }" value="${transcriptCourseSubject.militarySubject.socCategoryCode }">
																															</td> 
																															<td width="2%"><a class="removeCrossIcon fl mt5 " href="javascript:void(0);"></a></td> 
																														</tr>
																									                	
																									                </c:forEach>
																								               </tbody>
																						</table>																	             
																					</td>
																	            </tr>
																	            </table>
																	            
																	        </div>
																	        
																	      </div>
																	      </c:forEach>										   
															      </div>
														      </td>
													  </tr>
												
											
											
												  
									    </table>
					             	</div>
					             	<div><a href="javascript:void(0);" class="addCourse" id="Addcrs">Add Course</a></div>
					             	<div class="BorderLine"></div>
					             	<div class="mb10 createdby"><strong>Created By:</strong> ${studentInstitutionTranscriptSummary.studentInstitutionTranscript.user.firstName } &nbsp;${studentInstitutionTranscriptSummary.studentInstitutionTranscript.user.lastName }</div>
							  </div>
							  <div class="mt40">
									<div class="tabHeader">Note</div>
									<br>  
									<div class="mt10 p10 addNoteFrm" id="addNoteFrm_${tabIndexToAppend}">
														            
										<div class="noteLeft">${userName}:</div>
											<div class="noteRight">
												<label for="textarea"></label>
													<textarea  name="comment" id="comment_${tabIndexToAppend}"  cols="45" rows="5" style="width:99%; height:60px; margin:-6px 0px 0px 0px;"></textarea>
											 </div>
											<input type="hidden" name="transcriptId" id="sitId_${tabIndexToAppend}" value="${studentInstitutionTranscriptSummary.studentInstitutionTranscript.id}"/>
											 <div class="clear"></div>
										 <div class="fr mt10">
												<input type="button" value="Add" id="addComment_${tabIndexToAppend}" />&nbsp;&nbsp;<input type="button" value="Cancel" id="cancelAddComment_${tabIndexToAppend}" />
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
						           <div class="notedashbdr" id="dashLine"></div>
						           <div class="BorderLine"></div>
									 <div>
										<div class="fr">  
											<input type="button" name="MarkComplete" value="Mark Complete" id="markComplete${divTabIndexToAppend }" class="button" onclick="submitRejectedTranscript('<c:url value="/evaluation/launchEvaluation.html?operation=markRectifyMilitaryCourseToComplete&markCompleted=true"/>','inrContBox_${divTabIndexToAppend }','transferCourseFormId${divTabIndexToAppend }','markComplete${divTabIndexToAppend }','transferCourseTbl${divTabIndexToAppend }');">
										</div>
										<div class="clear"></div>
									</div>	 
							</div>		
						</form>
						<script type="text/javascript">
								jQuery("div[id^='inrContBox_']").each(
									function() {
										 jQuery("#"+this.id).hide();
									}
								);
														    		
								jQuery("#inrContBox_${firstRejectedDivId }").show(); 														     
						</script>
						<c:set var="divTabIndexToAppend" value="${divTabIndexToAppend + 1}"/> 	
					</c:otherwise>
			</c:choose>		    
	   </c:forEach>
    </div> 
 	</div>   
   </div>  
</div> 
  