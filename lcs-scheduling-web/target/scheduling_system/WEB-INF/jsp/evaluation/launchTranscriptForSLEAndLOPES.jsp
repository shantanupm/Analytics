<%@include file="../init.jsp" %>
<link rel="stylesheet" href="<c:url value="/css/schSysStylesheet.css"/>" />
<script type='text/javascript' src="<c:url value="/js/expand.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/evaluationHome.js"/>"></script>
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
var comment = "";
jQuery(document).ready(function() {
	addComments();
	removeComments()
	
		jQuery('.addNoteFrm, #dashLine').hide();
		jQuery("[id^='addNoteLnk_']").click(function(){
			var index=jQuery(this).attr('id').split('_')[1];	
			jQuery('#addNoteFrm_'+index).show();
			jQuery(this).hide();
				
		});
	
	var i = 2;
	var tabTxt1 = "";
	var tabIndexCount = -1;
	var tabIndex = 0;	
	<c:forEach items="${sitSummaryListForSLE}" var="studentInstitutionTranscript" varStatus="summaryIndex">
	 /* <c:if test="${fn:length(studentInstitutionTranscript.studentTranscriptCourse) gt 0}"> */
	 	tabIndexCount = tabIndexCount + 1;
	 	tabIndex = i + tabIndexCount;
		<c:if test="${studentInstitutionTranscript.official eq true}">
			tabTxt1 = "Official - <fmt:formatDate value="${studentInstitutionTranscript.createdDate}" pattern="MM/dd/yyyy"/>";			
		</c:if>	
		<c:if test="${studentInstitutionTranscript.official eq false}">
			tabTxt1 = "Un-Official - <fmt:formatDate value="${studentInstitutionTranscript.createdDate}" pattern="MM/dd/yyyy"/>";
	   </c:if>	
	   
	jQuery("#MarkComplete").click(function() {
		//alert(tabIndex);
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
	
	/* </c:if> */
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

function topicComboChanged(currentSelectedTopic) {
	jQuery("div[id^='topicBox_']").each(
		function() {
			if(this.id == "topicBox_"+currentSelectedTopic) {
				jQuery("#"+this.id).show();
			} else {
				jQuery("#"+this.id).hide();
			}
		}
	);
}

function splitCredit(){
	
jQuery("[id^=courseCategoryMappingIds_]").live('change',function(){
		
		var divContainer='';
		var htmlString='';
		 jQuery(this).parents().map(function () {
	             var strId=this.id;
	       	  if (strId.length>0 && strId.indexOf("inrContBox_") >= 0){
	       		  //alert( this.tagName+"--------"+this.id);
	       		  divContainer=this.id;
	       	  }
	           }) ;
		 
		 var courseCategorySelected=jQuery(this).find('option:selected').text();
		 var index=jQuery(this).attr('id').split("_")[1];
		 var semesterCredit=jQuery("#"+divContainer+" #lblSemesterCredit_"+index).text();
		 semesterCredit=jQuery("#"+divContainer+" #lblSemesterCredit_"+index).text();
			if (semesterCredit=="---"){
				semesterCredit=0;
			}
		 
		 	if("true"=="${studentInstitutionTranscript.institution.institutionType.id  ne '5'}"){
		 		 jQuery("#"+divContainer+" #courseSplitDiv_"+index).html('');
		 		 if(courseCategorySelected.indexOf("Not Applied") >= 0 || courseCategorySelected.indexOf("Not Approved") >= 0
						 || courseCategorySelected.indexOf("Submitted") >= 0 || courseCategorySelected.indexOf("Select") >= 0){
					 jQuery("#"+divContainer+" #courseSplitDiv_"+index).html('');
					 
				 }else{
					 htmlString=htmlString+	'<input type="text" id="txtSplitCredit_'+index+'_0" courseType="category" value="'+semesterCredit+'" class="w30 floatRight mt10"/> <br class="clear">';
					 jQuery("#"+divContainer+" #courseSplitDiv_"+index).html(htmlString);
					 
				 }
		 		
			}else{
				if(courseCategorySelected.indexOf("Not Applied") >= 0 || courseCategorySelected.indexOf("Not Approved") >= 0
						 || courseCategorySelected.indexOf("Submitted") >= 0 || courseCategorySelected.indexOf("Select") >= 0){
					 jQuery("#"+divContainer+" #creditTransfer_"+index).hide();
					 
				 }else{
					 jQuery("#"+divContainer+" #creditTransfer_"+index).show();
					 jQuery("#"+divContainer+" #creditTransfer_"+index).val(semesterCredit);
					 
				 }
			}
		 //creditTransfer=87691d05-7134-4419-9e3e-95dc568edf1e__0__ACC-250<>4_AB 263<>3_SCI-499<>1_
	
});	
	jQuery("[id^=courseMappingIds_]").live('change',function(){
		
		var divContainer='';
		 jQuery(this).parents().map(function () {
	             var strId=this.id;
	       	  if (strId.length>0 && strId.indexOf("inrContBox_") >= 0){
	       		  //alert( this.tagName+"--------"+this.id);
	       		  divContainer=this.id;
	       	  }
	           }) ;
		var courseCode, credit,htmlString='';
		var  gcuCredit;
		var index=jQuery(this).attr('id').split("_")[1];
		jQuery("#"+divContainer+" #courseSplitDiv_"+index).html('');
		var courseString=jQuery(this).find('option:selected').attr('coursecode');
		
		if(courseString!=undefined && courseString.length>0){
			var courseArray=courseString.split("_");
			var creditTransfer=0;
			
			for(i=0;i<courseArray.length-1;i++){
				courseCode=jQuery.trim(courseArray[i].split("<>")[0]);
				gcuCredit=jQuery.trim(courseArray[i].split("<>")[1]);
				
				//if(courseCode.length>0 && credit.length>0){
				if(courseCode.length>0 ){
					if(i==0){
						credit=jQuery("#"+divContainer+" #lblSemesterCredit_"+index).text();
						if (credit=="---"){
							credit=0;
						}
					}else{
						credit=0;
					}
					htmlString=htmlString+'<label class="w50 mt10" id="lblSplitCredit_'+index+'_'+i+'">'+courseCode+'</label>'+
					' <a style="display:none;" id="informAnchor_'+index+'_'+i+'"  title="GCU Credit= '+gcuCredit+' "><img  src="../images/alertIcon.png"/></a> '+
					'<input type="text" id="txtSplitCredit_'+index+'_'+i+'" courseType="relationship" gcuCredit ="'+gcuCredit+'" value="'+credit+'" class="w30 floatRight mt10"/> <br class="clear">';
					creditTransfer=creditTransfer+parseFloat(credit);
				}	
				
			}
			//	alert(jQuery("#studentTranscriptCourseId_"+index).val() );
			jQuery("#"+divContainer+" #courseSplitDiv_"+index).html(htmlString);
			//jQuery("#creditTransfer_"+index).val(jQuery("#studentTranscriptCourseId_"+index).val() +'__'+creditTransfer);
			jQuery("#"+divContainer+" #creditTransfer_"+index).val(jQuery("#"+divContainer+" #studentTranscriptCourseId_"+index).val() +'__'+creditTransfer+'__'+courseString);
		}
	});
	
	 jQuery("[id^=txtSplitCredit_]").live('blur',function(){
		 var divContainer='';
		 jQuery(this).parents().map(function () {
	             var strId=this.id;
	       	  if (strId.length>0 && strId.indexOf("inrContBox_") >= 0){
	       		  //alert( this.tagName+"--------"+this.id);
	       		  divContainer=this.id;
	       	  }
	           }) ;
		var gcuCredit=parseFloat(jQuery(this).attr('gcuCredit'));
		var creditTransferTotal=0;
		var courseCode, credit='';
		var thisIndex=jQuery(this).attr('id').split("_")[1];
		var this2ndIndex=jQuery(this).attr('id').split("_")[2];
		var courseString="";
		var i=0;
		var currentCreditValue=parseFloat(jQuery(this).val());
		var courseType=jQuery(this).attr('courseType');
		if(courseType=="relationship"  && currentCreditValue!=0 &&  currentCreditValue!=gcuCredit){
			//alert("GCU Credit : "+gcuCredit);
			jQuery("#informAnchor_"+thisIndex+"_"+this2ndIndex).show();
		}else{
			jQuery("#informAnchor_"+thisIndex+"_"+this2ndIndex).hide();
		}
		jQuery("#"+divContainer+" [id^=txtSplitCredit_"+thisIndex+"]").each(function(){
			courseCode=jQuery('#'+divContainer+' #lblSplitCredit_'+thisIndex+'_'+i).text();
			credit=jQuery(this).val();
			if(isNaN(credit) || credit.length==0){
				credit=0;
			}
			
			creditTransferTotal=creditTransferTotal+parseFloat(credit);
			courseString=courseString+courseCode+'<>'+credit+'_';
			i++;
		})
		//alert(jQuery("#"+divContainer+" #studentTranscriptCourseId_"+thisIndex).val() );
		jQuery("#"+divContainer+" #creditTransfer_"+thisIndex).val(jQuery("#"+divContainer+" #studentTranscriptCourseId_"+thisIndex).val() +'__'+creditTransferTotal+'__'+courseString);
	}) 
	
	
}
</script>
<script type="text/javascript">
jQuery(document).ready(function() {
	splitCredit();
	jQuery(".courseDetailsTable").find(".toolPos").hover(function(){
		jQuery(this).find(".toolTipCnt").show();
	},
	function(){
		jQuery(this).find(".toolTipCnt").hide();
	})
	jQuery(".courseDetailsTable").find(".flasIncorct").click(function(){
		jQuery(this).toggleClass("flasIncorctSel");
		if(jQuery(this).hasClass("flasIncorctSel")){
			jQuery(this).closest("tr").find(".toolTipdv").html("Flag as correct");
		}else{
			jQuery(this).closest("tr").find(".toolTipdv").html("Flag as incorrect");
		}
		if(jQuery(".courseDetailsTable").find(".flasIncorctSel.flasIncorct").length>0){
			jQuery(".Approve").attr("disabled","disabled");
			jQuery(".SendBack").removeAttr("disabled");
		}else{
			jQuery(".Approve").removeAttr("disabled");
			jQuery(".SendBack").attr("disabled","disabled");
		}
	});
	
	jQuery("[id^='cancelAddComment_']").click(function(){
		var index=jQuery(this).attr('id').split('_')[1];				
		jQuery("#addNoteLnk_"+index).show();				
		jQuery('#addNoteFrm_'+index).hide();
			
	});
	
});
</script>
<script type="text/javascript">
 var courseMappingIds = new Array();
 var courseCategoryMappingIds = new Array();
 
		function approve(studentInstitutionTranscriptId,transcriptType,tableId,formId,institutionTypeId){
			var urlForApproval = "";
			
			var validatedCourseMappingValue = fillSTCCourseMapping(tableId,formId,institutionTypeId);
			var validatedCourseCategoryValue = fillSTCCourseCategoryMapping(tableId,formId,institutionTypeId);
			var courseMappingIdsToMap = courseMappingIds.toString();
			var courseCategoryMappingIdsToMap = courseCategoryMappingIds.toString();
			var creditTransferArray=  new Array();
			var i=0
			jQuery("[id^=creditTransfer_]").each(function(){
				if(jQuery(this).val().length>0){
					
					if("true"=="${studentInstitutionTranscript.institution.institutionType.id  ne '5'}"){
						creditTransferArray[i]=jQuery(this).val();
					}else{
						creditTransferArray[i]= jQuery(this).attr('transcriptCourseSubjectId')+"<>"+ jQuery(this).val();
					}
					i++;
				}
				
			});
			
			if(validatedCourseMappingValue == true || validatedCourseCategoryValue == true){
				alert("Please select the course Relationship");
				return false;
			}else{
				if(transcriptType == 'true'){
					//alert("In if"+transcriptType);
					urlForApproval = "<c:url value='/evaluation/studentEvaluator.html?operation=approveSITForSLE&studentInstitutionTranscriptId="+studentInstitutionTranscriptId+"'/>&courseMappingIdsToMap="+courseMappingIdsToMap+"&courseCategoryMappingIdsToMap="+courseCategoryMappingIdsToMap+"&creditTransfer="+creditTransferArray ;
				}else{
					//alert("In else"+transcriptType);
					urlForApproval = "<c:url value='/evaluation/launchEvaluation.html?operation=approveSITForLOPE&studentInstitutionTranscriptId="+studentInstitutionTranscriptId+"'/>&courseMappingIdsToMap="+courseMappingIdsToMap+"&courseCategoryMappingIdsToMap="+courseCategoryMappingIdsToMap;
					
				}
				//alert(urlForApproval);
				window.location.href=urlForApproval;
				jQuery('#Approve').attr("disabled", true);
    			jQuery('#SendBack').attr("disabled", true);
			}
		}
		
		function sendBack(){
			var url;
			var errorInInstitution = false;
			var errorCourseIds = "";
			var errorstudentInstitutionTranscriptIds = "";
			var transcriptArr = new Array();
			var transcriptCourseSubjectArr = new Array();
			var errorCourseSubjectIds = "";
			/* 
			if(jQuery("#instDetailsFlag").attr('flagAttr')=='false'){
				errorInInstitution = true;
			} */
			
			
			jQuery(".flasIncorctSel").each(function(index){			
					errorCourseIds = errorCourseIds + jQuery(this).attr('stcId') + ',';				
					//errorstudentInstitutionTranscriptIds = errorstudentInstitutionTranscriptIds + jQuery(this).attr('studentInstitutionTranscriptID') + ',';
					transcriptArr[index] = jQuery(this).attr('studentInstitutionTranscriptID');
					transcriptCourseSubjectArr[index] = jQuery(this).attr('transcriptSubjectId');
					if(jQuery(this).attr('transcriptSubjectId') != undefined){
						errorCourseSubjectIds = errorCourseSubjectIds +jQuery(this).attr('transcriptSubjectId') +',';
					}
			});
			jQuery.each(unique(transcriptArr), function(i, value){
				errorstudentInstitutionTranscriptIds = errorstudentInstitutionTranscriptIds + value +',';
			});
			
			//alert("errorCourseSubjectIds="+errorCourseSubjectIds);
			//alert("errorstudentInstitutionTranscriptIds="+errorstudentInstitutionTranscriptIds);
			url = "<c:url value='/evaluation/studentEvaluator.html?operation=disapproveSITForSLEAndLOPES&studentInstitutionTranscriptId="+errorstudentInstitutionTranscriptIds+"&errorCourseIds="+errorCourseIds+"&errorCourseSubjectIds="+errorCourseSubjectIds+"&errorInInstitution=false"+"&comment="+comment+"'/>";
			window.location.href=url;
		}
		
		function comment_prompt(){
			comment=prompt("Please comment on the errors","");
			if(comment==""){
				alert("comment cannot be left empty");
				comment_prompt();
			}
			if(comment!=null){
				sendBack();	
			}
			
		}
		function unique(array){
		    return jQuery.grep(array,function(el,index){
		        return index == jQuery.inArray(el,array);
			});
		}
		function fillSTCCourseMapping(tableIdToCheck,formIdToCheck,institutionTypeId){
			var errorFoundForDegree = false;
			if(jQuery("#"+tableIdToCheck+" tr" ).length > 1){
				var tableNoOfTr = 0;
				//alert("tr last id"+jQuery("#"+tableIdToCheck+" tr:last" ).attr("id"));
				if(institutionTypeId == '5'){
					tableNoOfTr = parseInt(jQuery("#"+tableIdToCheck+" tr:last" ).attr("id").split("_")[2]);
				}else{
					tableNoOfTr = parseInt(jQuery("#"+tableIdToCheck+" tr:last" ).attr("id").split("_")[1]);
				}
				
				//alert("tableNoOfTr="+tableNoOfTr);
				for(var index=0;index<=tableNoOfTr;index++){
					var courseRelation = jQuery("#"+tableIdToCheck+" #courseMappingIds_"+index).find("option:selected").val();
					var courseAndCategoryRelation = jQuery("#"+tableIdToCheck+" #courseAndCategoryMappingIds_"+index).find("option:selected").val();
					if(courseRelation !=undefined  && courseRelation == ''){
						jQuery("#"+tableIdToCheck+" #courseMappingIds_"+index).addClass( "redBorder" );
					}else{
						jQuery("#"+tableIdToCheck+" #courseMappingIds_"+index).removeClass( "redBorder" );
					}
					if(courseAndCategoryRelation !=undefined && courseAndCategoryRelation == ''){
						jQuery("#"+tableIdToCheck+" #courseAndCategoryMappingIds_"+index).addClass( "redBorder" );
					}else{
						jQuery("#"+tableIdToCheck+" #courseAndCategoryMappingIds_"+index).removeClass( "redBorder" );
					}
				}
				for(var index=0;index<=tableNoOfTr;index++){
					var courseRelation = jQuery("#"+tableIdToCheck+" #courseMappingIds_"+index).find("option:selected").val();
					if(courseRelation !=undefined && courseRelation == ''){
						errorFoundForDegree = true;
						break;
					}else{
						var courseAndCategoryRelation = jQuery("#"+tableIdToCheck+" #courseAndCategoryMappingIds_"+index).find("option:selected").val();
						if(courseAndCategoryRelation !=undefined && courseAndCategoryRelation == ''){
							errorFoundForDegree = true;
							break;
						}else{
							if(courseAndCategoryRelation !=undefined && courseAndCategoryRelation != ''){
								courseMappingIds[index] = courseAndCategoryRelation;
							}else{
								courseMappingIds[index] = courseRelation;
							}
						}
					}
				}
				//alert("courseMappingIds="+courseMappingIds.length);
			}
			return errorFoundForDegree;
		}
		
		function fillSTCCourseCategoryMapping(tableIdToCheck,formIdToCheck,institutionTypeId){
			
			var errorFoundForDegree = false;
			if(jQuery("#"+tableIdToCheck+" tr" ).length > 1){
				var tableNoOfTr = 0;
				if(institutionTypeId == '5'){
					tableNoOfTr = parseInt(jQuery("#"+tableIdToCheck+" tr:last" ).attr("id").split("_")[2]);
				}else{
					tableNoOfTr = parseInt(jQuery("#"+tableIdToCheck+" tr:last" ).attr("id").split("_")[1]);
				}				
				for(var index=0;index<=tableNoOfTr;index++){
					var courseRelation = jQuery("#"+tableIdToCheck+" #courseCategoryMappingIds_"+index).find("option:selected").val();
					var courseAndCategoryRelation = jQuery("#"+tableIdToCheck+" #courseAndCategoryMappingIds_"+index).find("option:selected").val();
					if(courseRelation !=undefined  && courseRelation == ''){
						jQuery("#"+tableIdToCheck+" #courseCategoryMappingIds_"+index).addClass( "redBorder" );
					}else{
						jQuery("#"+tableIdToCheck+" #courseCategoryMappingIds_"+index).removeClass( "redBorder" );
					}
					if(courseAndCategoryRelation !=undefined && courseAndCategoryRelation == ''){
						jQuery("#"+tableIdToCheck+" #courseAndCategoryMappingIds_"+index).addClass( "redBorder" );
					}else{
						jQuery("#"+tableIdToCheck+" #courseAndCategoryMappingIds_"+index).removeClass( "redBorder" );
					}
				}
				for(var index=0;index<=tableNoOfTr;index++){
					var courseRelation = jQuery("#"+tableIdToCheck+" #courseCategoryMappingIds_"+index).find("option:selected").val();
					if(courseRelation !=undefined && courseRelation == ''){
						errorFoundForDegree = true;
						break;
					}else{
						var courseAndCategoryRelation = jQuery("#"+tableIdToCheck+" #courseAndCategoryMappingIds_"+index).find("option:selected").val();
						if(courseAndCategoryRelation !=undefined && courseAndCategoryRelation == ''){
							errorFoundForDegree = true;
							break;
						}else{
							if(courseAndCategoryRelation !=undefined && courseAndCategoryRelation != ''){
								courseCategoryMappingIds[index] = courseAndCategoryRelation;
							}else{
								courseCategoryMappingIds[index] = courseRelation;
							}
						}					
					}
				}
				
			}
			return errorFoundForDegree;
		}
		function fillSTCCourseAndCategoryMapping(tableIdToCheck,formIdToCheck){
			var errorFoundForDegree = false;
			if(jQuery("#"+tableIdToCheck+" tr" ).length > 1){
				
				var tableNoOfTr = parseInt(jQuery("#"+tableIdToCheck+" tr:last" ).attr("id").split("_")[1]);
				for(var index=0;index<=tableNoOfTr;index++){
					var courseRelation = jQuery("#"+tableIdToCheck+" #courseAndCategoryMappingIds_"+index).find("option:selected").val();
					if(courseRelation !=undefined  && courseRelation == ''){
						jQuery("#"+tableIdToCheck+" #courseAndCategoryMappingIds_"+index).addClass( "redBorder" );
					}else{
						jQuery("#"+tableIdToCheck+" #courseAndCategoryMappingIds_"+index).removeClass( "redBorder" );
					}
				}
				for(var index=0;index<=tableNoOfTr;index++){
					var courseRelation = jQuery("#"+tableIdToCheck+" #courseAndCategoryMappingIds_"+index).find("option:selected").val();
					if(courseRelation !=undefined && courseRelation == ''){
						errorFoundForDegree = true;
						break;
					}else{
						courseCategoryMappingIds[index] = courseRelation;
						courseMappingIds[index] = courseRelation;
					}
				}
				
			}
			return errorFoundForDegree;
		}
</script>
<title>Evaluate Courses</title>
<div class="deo2">
  <div style="border:1px solid #e7e7e7; border-top:none;" class="institute">
    <div class="noti-tools2">
      <div class="clear"></div>
      <div class="clear"></div>
      <c:choose>
      <c:when test="${transcriptDataAvailable eq true }">
      <div class="deo">
        <div class="deoInfo">
          <%@include file="../common/studentDemographicsInfo.jsp" %>
        </div>
        <div class="deoInfo">
          <%@include file="../common/institutionInfo.jsp" %>
        </div>
        <ul id="addTopNav" class="floatLeft <c:choose><c:when test="${studentInstitutionTranscript.institution.institutionType.id  ne '5'}">top-nav-tab </c:when><c:otherwise>top-nav-tabml</c:otherwise></c:choose> ml20">
          <c:set var="upperTabIndexToAppend" value="0"/>
           <c:forEach items="${sitSummaryListForSLE }" var="studentInstitutionTranscript" varStatus="transcriptIndex">
           		<%-- <c:if test="${fn:length(studentInstitutionTranscript.studentTranscriptCourse) gt 0}"> --%>
	           		<c:set var="upperTabIndexToAppend" value="${upperTabIndexToAppend + 1}"/>
	        		<c:if test="${studentInstitutionTranscript.official eq true }">
	              		<li><a class='<c:if test="${upperTabIndexToAppend eq 1 }">on</c:if>' id="tablink_${upperTabIndexToAppend }" href="javascript:void(0)"><span>Official - <fmt:formatDate value="${studentInstitutionTranscript.createdDate}" pattern="MM/dd/yyyy"/></span></a></li>
	                </c:if>
	                <c:if test="${studentInstitutionTranscript.official eq false }">
	              		<li><a class='<c:if test="${upperTabIndexToAppend eq 1 }">on</c:if>' id="tablink_${upperTabIndexToAppend }" href="javascript:void(0)"><span>Un-Official - <fmt:formatDate value="${studentInstitutionTranscript.createdDate}" pattern="MM/dd/yyyy"/></span></a></li>
	                </c:if>
                <%--  </c:if> --%>
            </c:forEach>
        </ul>
        <br class="clear">
        <div id="addDyndivs" class="tabBorder contentForm">
         <c:set var="tabIndexToAppend" value="2"/>
         <c:set var="divTabIndexToAppend" value="1"/>
         <c:forEach items="${sitSummaryListForSLE }" var="studentInstitutionTranscript" varStatus="transcriptIndex">
           
	         <form name="studentInstitutionTranscriptForm${divTabIndexToAppend }" id="studentInstitutionTranscriptFormId${divTabIndexToAppend }" method="post" >
		         	<%-- <c:if test="${fn:length(studentInstitutionTranscript.studentTranscriptCourse) gt 0}"> --%>
		         		
				          <div id="inrContBox_${divTabIndexToAppend }" <c:if test="${divTabIndexToAppend gt 1 }">style="display:none;"</c:if>>
				          
				         	<div class="mt30">
					              <div class="dateReceived">
					                <label class="noti-label w100">Date Received:</label>
					                <fmt:formatDate value='${studentInstitutionTranscript.dateReceived }' pattern='MM/dd/yyyy'/>
					              </div>
					              <div class="lastAttend">
					                <label class="noti-label w100">Last Attended:</label>
					                <fmt:formatDate value='${studentInstitutionTranscript.lastAttendenceDate }' pattern='MM/dd/yyyy'/>
					              </div>
					              <div class="tanscriptType">
					                <label class="noti-label w110">Transcript Type:</label>
					                <label style="margin-top:5px;"> 
					                	<c:if test="${studentInstitutionTranscript.official eq true}">
					                		Official
					                	</c:if>
					                	<c:if test="${studentInstitutionTranscript.official eq false}">
					                		Un-Official
					                	</c:if>
					                
					                </label>
					              </div>
					              <div class="clear"></div>
				            </div>
				            <c:choose>
					            <c:when test="${studentInstitutionTranscript.institution.institutionType.id  ne '5'}">
						            <div class="mt30">
							              <div class="tabHeader">Degree(s) Details</div>
							              <div>
							                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl3 noti-bbn tabTBLborder">
							                  <tr>
							                    <th width="20%" scope="col" class="dividerGrey">Degree Earned</th>
							                    <th width="50%" scope="col" class="dividerGrey">Major</th>
							                    <th width="15%" scope="col" class="dividerGrey">Graduation Date</th>
							                    <th width="15%" scope="col">GPA</th>
							                  </tr>
							                  <c:forEach items="${studentInstitutionDegreeList}" var="sInstDegList1" varStatus="index">
													  <tr>
													    <td>${sInstDegList1.institutionDegree.degree}</td>
													    <td>${sInstDegList1.major}</td>
													    <td><fmt:formatDate value='${sInstDegList1.completionDate}' pattern='MM/dd/yyyy'/></td>
													    <td>${sInstDegList1.gpa}</td>
													  </tr>
											 	 </c:forEach>
							                </table>
							              </div>
						            </div>
					            </c:when>
					            <c:otherwise>
					            
					            </c:otherwise>
				            </c:choose>
				             <div class="mt40">
					              <div class="tabHeader">Course(s) Details</div>
					              <div>
					              <c:choose>
						              	<c:when test="${studentInstitutionTranscript.institution.institutionType.id  ne '5'}">
							              	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl3 noti-bbn tabTBLborder courseDetailsTable" id="courseDetailsTable${divTabIndexToAppend}">
								                  <tr id="courseRow_-1">
								                    <th width="10%" scope="col" class="dividerGrey">Date Completed<br />
								                      <span class="mandatoryTxt">(mm/dd/yyyy)</span></th>
								                    <th width="10%" scope="col" class="dividerGrey">Transfer Course ID</th>
								                    <th width="20%" scope="col" class="dividerGrey">Transfer Course Title</th>
								                    <th width="6%" align="center" class="dividerGrey" scope="col">Grade</th>
								                    <th width="6%" align="center" class="dividerGrey" scope="col">Credits</th>
								                    <th width="7%" align="center" class="dividerGrey" scope="col">Clock Hours</th>
								                    <th width="8%" align="center" class="dividerGrey" scope="col">Semester Credits</th>
								                    <th width="8%" scope="col" class="dividerGrey">Transfer<br /> Status</th>
								                    <th width="16%" scope="col"><c:if test="${studentInstitutionTranscript.official eq true }">Select Relationship</c:if></th>
								                    <th width="3%" scope="col">&nbsp;</th>
								                  </tr>
										                  <c:forEach items="${studentInstitutionTranscript.studentTranscriptCourse}" var="studentTranscriptCourse1" varStatus="loop">
										  			 		<tr id="courseRow_${loop.index}">
															    <td valign="top">
															    
															    	<span class="dateReceived"><fmt:formatDate value='${studentTranscriptCourse1.completionDate}' pattern='MM/dd/yyyy'/></span>
																</td>
																<td valign="top">
																	${studentTranscriptCourse1.trCourseId}					
																</td>
																<td valign="top">
																	${studentTranscriptCourse1.courseTitle}
																</td>
																<td valign="top">${studentTranscriptCourse1.grade}
															  </td>
															<td valign="top">
																${studentTranscriptCourse1.creditsTransferred}
																
															</td>
															<td valign="top">${studentTranscriptCourse1.clockHours}</td>
															<td valign="top">
															 
																<c:choose>
																	 <c:when test="${fn:toUpperCase(studentInstitutionTranscript.institution.evaluationStatus) == 'EVALUATED'}">
																	        <c:choose>
																	            <c:when test="${studentTranscriptCourse1.institutionTermType.termType.name == 'Quarter' && studentTranscriptCourse1.transferCourse.clockHoursChk eq false}">
																	                 
																	            		<label id="lblSemesterCredit_${loop.index}"><fmt:formatNumber type="number"  maxFractionDigits="2" value="${studentTranscriptCourse1.creditsTransferred*2/3}" pattern="0.00"/> </label>
																	            </c:when>
																	           <c:when test="${studentTranscriptCourse1.institutionTermType.termType.name == '4-1-4' && studentTranscriptCourse1.transferCourse.clockHoursChk eq false}">
																	           		
																	            		<label id="lblSemesterCredit_${loop.index}"><fmt:formatNumber type="number"  maxFractionDigits="2" value="${studentTranscriptCourse1.creditsTransferred*4}" pattern="0.00"/></label>
																	            </c:when>
																	            <c:when test="${studentTranscriptCourse1.institutionTermType.termType.name == 'Semester' && studentTranscriptCourse1.transferCourse.clockHoursChk eq false}">													           		 
																	           		 <label id="lblSemesterCredit_${loop.index}"><fmt:formatNumber type="number"  maxFractionDigits="2" value="${studentTranscriptCourse1.creditsTransferred}" pattern="0.00"/></label>													            		
																	            </c:when>
																	            <c:when test="${studentTranscriptCourse1.institutionTermType.termType.name == 'Annual' && studentTranscriptCourse1.transferCourse.clockHoursChk eq false}">
																	           		<label id="lblSemesterCredit_${loop.index}">---</label>												            		
																	            </c:when>
																	            <c:otherwise>
																	                 <c:choose>
														            					<c:when test="${studentTranscriptCourse1.transferCourse.courseType == 'Lecture' && studentTranscriptCourse1.transferCourse.clockHoursChk eq true}">
														            						<label id="lblSemesterCredit_${loop.index}"><fmt:formatNumber value="${studentTranscriptCourse1.clockHours/15}" maxFractionDigits="2" pattern="0.00"/></label>
														            					</c:when>
														            					<c:when test="${studentTranscriptCourse1.transferCourse.courseType == 'Lab' && studentTranscriptCourse1.transferCourse.clockHoursChk eq true}">
														            						<label id="lblSemesterCredit_${loop.index}"><fmt:formatNumber value="${studentTranscriptCourse1.clockHours/30}" maxFractionDigits="2" pattern="0.00"/></label>
														            					</c:when>
														            					<c:when test="${studentTranscriptCourse1.transferCourse.courseType == 'Clinical' && studentTranscriptCourse1.transferCourse.clockHoursChk eq true}">
														            						<label id="lblSemesterCredit_${loop.index}"><fmt:formatNumber value="${studentTranscriptCourse1.clockHours/45}" maxFractionDigits="2" pattern="0.00"/></label>
														            					</c:when>
														            					<c:otherwise>
																            				<label id="lblSemesterCredit_${loop.index}">---</label>
																            			</c:otherwise>
														            		</c:choose>													            		
																	            </c:otherwise>
																	       </c:choose>
																	 </c:when>
																	 <c:otherwise>
																	 			<label id="lblSemesterCredit_${loop.index}">---	</label>								      
																	 </c:otherwise> 
															</c:choose>	
														</td>
														<td valign="top">
															${studentTranscriptCourse1.transcriptStatus}
														 </td>
														<td valign="top">
															<c:if test="${studentInstitutionTranscript.official eq true }">											
																<c:choose>
																	<c:when test="${fn:length(studentTranscriptCourse1.courseMappingList) gt 0 }">
																		<select class="valid w130" id="courseMappingIds_${loop.index }" name="courseMappingIds[${loop.index }]">
																				<option value="">Select Relationship</option>
																				<c:forEach items="${studentTranscriptCourse1.courseMappingList}" var="courseMapping">${courseMapping.id}
																					<c:if test="${!empty courseMapping.relatedGCUCourseCode}">
																						<option courseCode='<c:forEach items="${courseMapping.courseMappingDetails}" var="courseMappingDetail">${courseMappingDetail.gcuCourse.courseCode}<>${courseMappingDetail.gcuCourse.credits}_</c:forEach>' value="${courseMapping.id }<>${studentTranscriptCourse1.id}" <c:if test="${studentTranscriptCourse1.courseMappingId eq courseMapping.id}"> selected="selected" </c:if>> ${courseMapping.relatedGCUCourseCode} </option>
																					</c:if>
																				</c:forEach>
																				<option value="Not Applied<>${studentTranscriptCourse1.id }" <c:if test="${studentTranscriptCourse1.courseMappingId eq 'Not Applied'}"> selected="selected" </c:if>> Not Applied </option>
																				<option value="Not Approved<>${studentTranscriptCourse1.id }" <c:if test="${studentTranscriptCourse1.courseMappingId eq 'Not Approved'}"> selected="selected" </c:if>> Not Approved </option>
																				<option value="Submitted<>${studentTranscriptCourse1.id }" <c:if test="${studentTranscriptCourse1.courseMappingId eq 'Submitted'}"> selected="selected" </c:if>>Submitted</option>
																		</select>
																		<div id="courseSplitDiv_${loop.index }" class="w134"></div>
																		<input type="hidden" id="creditTransfer_${loop.index }" name="creditTransfer" />
																		<input type="hidden" id="studentTranscriptCourseId_${loop.index }"  value="${studentTranscriptCourse1.id}" />
															
																	</c:when>
																	<c:when test="${fn:length(studentTranscriptCourse1.courseCategoryMappingList) gt 0 }">
																		<select class="valid w130" id="courseCategoryMappingIds_${loop.index }" name="courseMappingIds[${loop.index }]">
																				<option value="">Select Relationship</option>
																				<c:forEach items="${studentTranscriptCourse1.courseCategoryMappingList}" var="courseCategoryMapping">
																					<option value="${courseCategoryMapping.id }<>${studentTranscriptCourse1.id}" <c:if test="${studentTranscriptCourse1.courseCategoryMappingId eq courseCategoryMapping.id}"> selected="selected" </c:if>> ${courseCategoryMapping.gcuCourseCategory.name} </option>
																				</c:forEach>
																				<option value="Not Applied<>${studentTranscriptCourse1.id }" <c:if test="${studentTranscriptCourse1.courseCategoryMappingId eq 'Not Applied'}"> selected="selected" </c:if>> Not Applied </option>
																				<option value="Not Approved<>${studentTranscriptCourse1.id }" <c:if test="${studentTranscriptCourse1.courseCategoryMappingId eq 'Not Approved'}"> selected="selected" </c:if>> Not Approved </option>
																				<option value="Submitted<>${studentTranscriptCourse1.id }" <c:if test="${studentTranscriptCourse1.courseCategoryMappingId eq 'Submitted'}"> selected="selected" </c:if>>Submitted</option>
																		</select>
																		<div id="courseSplitDiv_${loop.index }" class="w134"></div>
																		<input type="hidden" id="creditTransfer_${loop.index }" name="creditTransfer" />
																		<input type="hidden" id="studentTranscriptCourseId_${loop.index }"  value="${studentTranscriptCourse1.id}" />
															
																	</c:when>
																<c:otherwise>
																	<select class="valid w130" id="courseAndCategoryMappingIds_${loop.index }" name="courseAndCategoryMappingIds[${loop.index }]">
																			<option value="">Select Relationship</option>
																			<option value="Not Applied<>${studentTranscriptCourse1.id }" <c:if test="${studentTranscriptCourse1.courseCategoryMappingId eq 'Not Applied'}"> selected="selected" </c:if>> Not Applied </option>
																			<option value="Not Approved<>${studentTranscriptCourse1.id }" <c:if test="${studentTranscriptCourse1.courseCategoryMappingId eq 'Not Approved'}"> selected="selected" </c:if> <c:if test="${studentTranscriptCourse1.transcriptStatus eq 'Not Eligible' && (empty studentTranscriptCourse1.courseCategoryMappingId || studentTranscriptCourse1.courseCategoryMappingId eq 'Not Approved')}"> selected="selected" </c:if> > Not Approved </option>
																			<option value="Submitted<>${studentTranscriptCourse1.id }" <c:if test="${studentTranscriptCourse1.courseCategoryMappingId eq 'Submitted'}"> selected="selected" </c:if>>Submitted</option>
																	</select>
																			
																</c:otherwise>											
															  </c:choose>
															 	
															</c:if>
															 
														</td>
														
														<td valign="top">
															 <div class="toolPos ml4"> <a href="javascript:void(0)" class="flasIncorct" stcId="${studentTranscriptCourse1.id}" studentInstitutionTranscriptID="${studentInstitutionTranscript.id}"></a>
										                        <div class="toolTipCnt"> <span class="toolTipdv"> Flag as incorrect </span> <span class="toolTipArow"></span> </div>
										                      </div>
										                </td>
													</tr>
											</c:forEach>
							                  
							      		</table>		
						              	</c:when>
					              	<c:otherwise>
					              		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl3 noti-bbn tabTBLborder courseDetailsTable" id="courseDetailsTable${divTabIndexToAppend}">
								                  <tr id="courseRow_-1">
													<th width="10%" scope="col" class="dividerGrey">Date Completed<br />
								                      <span class="mandatoryTxt">(mm/dd/yyyy)</span></th>
								                    <th width="10%" scope="col" class="dividerGrey">Military Course No.</th>
								                    <th width="10%" scope="col" class="dividerGrey">ACE Exhibit No.</th>
								                    <th width="20%" scope="col" class="dividerGrey">Transfer Course Title and<br />Subject(s)</th>
								                    <th width="6%" align="center" class="dividerGrey" scope="col">Credits</th>
								                    <th width="6%" align="center" class="dividerGrey" scope="col">Course Level</th>
								                    <th width="8%" scope="col" class="dividerGrey">SOC Category Code</th>
								                    <th width="16%" scope="col"><c:if test="${studentInstitutionTranscript.official eq true }">Select Relationship</c:if></th>
								                    <th width="3%" scope="col">&nbsp;</th>
								                  </tr>
								                  <c:set var="incremantalIndexForMilitaryTr" value="0"></c:set>
										                <c:forEach items="${studentInstitutionTranscript.studentTranscriptCourse}" var="studentTranscriptCourse1" varStatus="loop">
										  			 		<tr id="courseRow_${loop.index}" class="military-grayClr">
										  			 			<td>
										  			 			<!-- TERM TYPE NOT COMING FOR FIRST TRANSCRIPT COURSE===${studentTranscriptCourse1.institutionTermType.termType.name} -->
															       <span class="dateReceived"><fmt:formatDate value='${studentTranscriptCourse1.completionDate}' pattern='MM/dd/yyyy'/></span>
															    </td>
															    <td>
															         ${studentTranscriptCourse1.trCourseId}
															     </td>
															     <td>
															        ${studentTranscriptCourse1.transferCourse.aceExhibitNo}
															     </td>
															     <td>
															        ${studentTranscriptCourse1.courseTitle}
																 </td>
																<td align="left">&nbsp;</td>
											                    <td align="left">&nbsp;</td>
											                    <td>&nbsp;</td>
											                    <td>&nbsp;</td>
											                    <td>
											                    	<div class="toolPos">&nbsp;
											                    		<a href="javascript:void(0)" class="flasIncorct" stcId="${studentTranscriptCourse1.id}" studentInstitutionTranscriptID="${studentInstitutionTranscript.id}"></a>
											                        	<div class="toolTipCnt"> <span class="toolTipdv"> Flag as incorrect </span> <span class="toolTipArow"></span> </div>
											                      	</div>
											                    </td>																
															</tr>
															<c:forEach items="${studentTranscriptCourse1.transcriptCourseSubjectList}" var="transcriptCourseSubject" varStatus="transcriptCourseSubjectIndex">
																
																<tr id="rowsubject_${loop.index }_${incremantalIndexForMilitaryTr }"> 
																  <td>&nbsp;</td>
						                    					  <td>&nbsp;</td>
						                    					  <td>&nbsp;</td>
																  <td>
																	${transcriptCourseSubject.militarySubject.name }
																  </td> 
																  <td>
																	${transcriptCourseSubject.credit }
																  </td> 
																 <td>
																	${transcriptCourseSubject.courseLevel }
																 </td> 
																 <td>
																	${transcriptCourseSubject.militarySubject.socCategoryCode }
																 </td>
																 <td>
																	<c:if test="${studentInstitutionTranscript.official eq true }">											
																		<c:choose>
																			<c:when test="${fn:length(studentTranscriptCourse1.courseMappingList) gt 0 }">
																				<select class="valid w130" id="courseMappingIds_${incremantalIndexForMilitaryTr }" name="courseMappingIds[${incremantalIndexForMilitaryTr }]">
																						<option value="">Select Relationship</option>
																						<c:forEach items="${studentTranscriptCourse1.courseMappingList}" var="courseMapping">
																							<c:if test="${!empty courseMapping.relatedGCUCourseCode}">
																								<option value="${courseMapping.id }<>${studentTranscriptCourse1.id}<>${transcriptCourseSubject.subjectId}" <c:if test="${transcriptCourseSubject.courseMappingId eq courseMapping.id}"> selected="selected" </c:if>> ${courseMapping.relatedGCUCourseCode} </option>
																							</c:if>
																						</c:forEach>
																						<option value="Not Applied<>${studentTranscriptCourse1.id }<>${transcriptCourseSubject.subjectId}" <c:if test="${transcriptCourseSubject.courseMappingId eq 'Not Applied'}"> selected="selected" </c:if>> Not Applied </option>
																						<option value="Not Approved<>${studentTranscriptCourse1.id }<>${transcriptCourseSubject.subjectId}" <c:if test="${transcriptCourseSubject.courseMappingId eq 'Not Approved'}"> selected="selected" </c:if>> Not Approved </option>
																						<option value="Submitted<>${studentTranscriptCourse1.id }<>${transcriptCourseSubject.subjectId}" <c:if test="${transcriptCourseSubject.courseMappingId eq 'Submitted'}"> selected="selected" </c:if>>Submitted</option>
																				</select>
																			</c:when>
																			<c:when test="${fn:length(studentTranscriptCourse1.courseCategoryMappingList) gt 0 }">
																				<select class="valid w130" id="courseCategoryMappingIds_${incremantalIndexForMilitaryTr}" name="courseMappingIds[${incremantalIndexForMilitaryTr}]">
																						<option value="">Select Relationship</option>
																						<c:forEach items="${studentTranscriptCourse1.courseCategoryMappingList}" var="courseCategoryMapping">
																							<option value="${courseCategoryMapping.id }<>${studentTranscriptCourse1.id}<>${transcriptCourseSubject.subjectId}" <c:if test="${transcriptCourseSubject.categoryId eq courseCategoryMapping.id}"> selected="selected" </c:if>> ${courseCategoryMapping.gcuCourseCategory.name} </option>
																						</c:forEach>
																						<option value="Not Applied<>${studentTranscriptCourse1.id }<>${transcriptCourseSubject.subjectId}" <c:if test="${transcriptCourseSubject.categoryId eq 'Not Applied'}"> selected="selected" </c:if>> Not Applied </option>
																						<option value="Not Approved<>${studentTranscriptCourse1.id }<>${transcriptCourseSubject.subjectId}" <c:if test="${transcriptCourseSubject.categoryId eq 'Not Approved'}"> selected="selected" </c:if>> Not Approved </option>
																						<option value="Submitted<>${studentTranscriptCourse1.id }<>${transcriptCourseSubject.subjectId}" <c:if test="${transcriptCourseSubject.categoryId eq 'Submitted'}"> selected="selected" </c:if>>Submitted</option>
																				</select>
																			</c:when>
																		<c:otherwise>
																			<select class="valid w130" id="courseAndCategoryMappingIds_${incremantalIndexForMilitaryTr }" name="courseAndCategoryMappingIds[${incremantalIndexForMilitaryTr}]">
																					<option value="">Select Relationship</option>
																					<option value="Not Applied<>${studentTranscriptCourse1.id }<>${transcriptCourseSubject.subjectId}" <c:if test="${transcriptCourseSubject.categoryId eq 'Not Applied'}"> selected="selected" </c:if>> Not Applied </option>
																					<option value="Not Approved<>${studentTranscriptCourse1.id }<>${transcriptCourseSubject.subjectId}" <c:if test="${transcriptCourseSubject.categoryId eq 'Not Approved'}"> selected="selected" </c:if> <c:if test="${studentTranscriptCourse1.transcriptStatus eq 'Not Eligible' && (empty transcriptCourseSubject.categoryId || transcriptCourseSubject.categoryId eq 'Not Approved')}"> selected="selected" </c:if> > Not Approved </option>
																					<option value="Submitted<>${studentTranscriptCourse1.id }<>${transcriptCourseSubject.subjectId}" <c:if test="${transcriptCourseSubject.categoryId eq 'Submitted'}"> selected="selected" </c:if>>Submitted</option>
																			</select>			
																		</c:otherwise>											
																	  </c:choose>
																	</c:if>
																	<div id="divMilitarySemesterCredit" style="display:none;"> 

																	<c:choose>
																	 <c:when test="${fn:toUpperCase(studentInstitutionTranscript.institution.evaluationStatus) == 'EVALUATED'}">
																	        <c:choose>
																	            <c:when test="${studentTranscriptCourse1.institutionTermType.termType.name == 'Quarter' && studentTranscriptCourse1.transferCourse.clockHoursChk eq false}">
																	            		<label id="lblSemesterCredit_${loop.index}"><fmt:formatNumber type="number"  maxFractionDigits="2" value="${transcriptCourseSubject.credit*2/3}" pattern="0.00"/> </label>
																	            </c:when>
																	           <c:when test="${studentTranscriptCourse1.institutionTermType.termType.name == '4-1-4' && studentTranscriptCourse1.transferCourse.clockHoursChk eq false}">
																	           		
																	            		<label id="lblSemesterCredit_${loop.index}"><fmt:formatNumber type="number"  maxFractionDigits="2" value="${transcriptCourseSubject.credit*4}" pattern="0.00"/></label>
																	            </c:when>
																	            <c:when test="${studentTranscriptCourse1.institutionTermType.termType.name == 'Semester' && studentTranscriptCourse1.transferCourse.clockHoursChk eq false}">													           		 
																	           		 <label id="lblSemesterCredit_${loop.index}"><fmt:formatNumber type="number"  maxFractionDigits="2" value="${transcriptCourseSubject.credit}" pattern="0.00"/></label>													            		
																	            </c:when>
																	            <c:when test="${studentTranscriptCourse1.institutionTermType.termType.name == 'Annual' && studentTranscriptCourse1.transferCourse.clockHoursChk eq false}">
																	           		<label id="lblSemesterCredit_${loop.index}">---</label>												            		
																	            </c:when>
																	            
																	       </c:choose>
																	 </c:when>
																	 <c:otherwise>
																	 			<label id="lblSemesterCredit_${loop.index}">---	</label>								      
																	 </c:otherwise> 
															</c:choose>	
															</div>
															
																	<input type="text" style="display:none;" id="creditTransfer_${incremantalIndexForMilitaryTr}"   transcriptCourseSubjectId="${transcriptCourseSubject.id}" value="${transcriptCourseSubject.transferCredit}" class="w33" />
														          </td> 
														         
																  <td>
																	<div class="toolPos ml4"> <a href="javascript:void(0)" class="flasIncorct" stcId="${studentTranscriptCourse1.id}" studentInstitutionTranscriptID="${studentInstitutionTranscript.id}" transcriptSubjectId="${studentTranscriptCourse1.id}<>${transcriptCourseSubject.subjectId}"></a>
                        												<div class="toolTipCnt"> <span class="toolTipdv"> Flag as incorrect </span> <span class="toolTipArow"></span> </div>
                      												</div>
                      											  </td>
												                </tr>
												                <c:set var="incremantalIndexForMilitaryTr" value="${incremantalIndexForMilitaryTr +1 }"></c:set>	
											                </c:forEach>				
														 </c:forEach>
							                  
							      		   </table>		
					              	
					              	</c:otherwise>
					              
					              </c:choose>
					              </div>
				            </div> 
				            
							       
						 <div class="mt40">
					       <div class="tabHeader">Note</div>
					  		 <br>  <div class="mt10 p10 addNoteFrm" id="addNoteFrm_${divTabIndexToAppend }">
				            
				            	<div class="noteLeft">${userName}:</div>
				                <div class="noteRight">
				                  <label for="textarea"></label>
				                  <textarea  name="comment" id="comment_${divTabIndexToAppend }"  cols="45" rows="5" style="width:99%; height:60px; margin:-6px 0px 0px 0px;"></textarea>
				                </div>
				                <input type="hidden" name="transcriptId" id="sitId_${divTabIndexToAppend }" value="${studentInstitutionTranscript.id}"/>
				                <div class="clear"></div>
				                <div class="fr mt10">
						             <input type="button" value="Add" id="addComment_${divTabIndexToAppend }" />&nbsp;&nbsp;<input type="button" value="Cancel" id="cancelAddComment_${divTabIndexToAppend }" />
								</div>
				                <div class="clear"></div>
				            	</div>
				            </div> 
				            <div><a href="javascript:void(0);" class="addNotes" title="Add Note" id="addNoteLnk_${divTabIndexToAppend }">Add Note</a></div>
						       <div id="transcriptCommentsDiv_${divTabIndexToAppend }">
						       
						       <c:set var="divindex" value="${divTabIndexToAppend }"/>
						        <c:set var="userCurrentId" value="${userCurrentId }"/>						       
						       	<c:set var="transcriptCommentsList" value="${studentInstitutionTranscript.transcriptCommentsList }"></c:set>
						       <%@include file="transcriptCommentsList.jsp" %>
						       </div>      
				            <div class="BorderLine"></div>
				            <div>
				              <div class="fr">
				                <input type="button" name="saveInstitution" value="Approve" id="Approve" class="button Approve" onclick="javascript:approve('${studentInstitutionTranscript.id}','${studentInstitutionTranscript.official }','courseDetailsTable${divTabIndexToAppend}','studentInstitutionTranscriptFormId${divTabIndexToAppend }','${studentInstitutionTranscript.institution.institutionType.id}');">
				                <input type="button" name="cancel" value="Send Back to Data Entry" id="SendBack" class="button SendBack" disabled="disabled" onclick="javascript:comment_prompt();">
				              </div>
				              <div class="clear"></div>
				            </div>
				 
				          
				          </div>
		           <%-- </c:if> --%>
		           <c:set var="tabIndexToAppend" value="${tabIndexToAppend + 1 }"/>
		           <c:set var="divTabIndexToAppend" value="${divTabIndexToAppend + 1 }"/>
	           </form>
	           
        </c:forEach>
        </div>
        <div class="clear"></div>
      </div>
   </c:when> 
   <c:otherwise>
   <div class="rejctdiv rejColor mt10">There are no transcripts to evaluate in the queue at this time. Good job team!</div>
   
   </c:otherwise>
   </c:choose>  
    <%-- --%>  
    </div>
  </div>
</div>