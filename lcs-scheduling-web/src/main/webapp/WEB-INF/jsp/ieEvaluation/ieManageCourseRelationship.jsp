<%@include file="../init.jsp" %>
<link rel="stylesheet" href="<c:url value="/css/jquery.ui.all.css"/>" />
<style>
  .ui-autocomplete {
    max-height: 200px;
    overflow-y: auto;
    /* prevent horizontal scrollbar */
    overflow-x: hidden;
  }
  /* IE 6 doesn't support max-height
   * we use height instead, but this forces the menu to always be this tall
   */
  * html .ui-autocomplete {
    height: 200px;
  }
  </style>
<script type="text/javascript" src="<c:url value="/js/jquery.validate.js"/>"></script>
<script type="text/javascript">

function andCourseRelationship(){
	jQuery("[id^='andCheck_']").live('change',function(){
		
		
		var andIndex=parseInt(jQuery(this).attr('id').split("_")[2]);
		var currentIndex=parseInt(jQuery(this).attr('id').split("_")[1]);
		
		if (jQuery(this).is(':checked')) {
			
			addCourseTitleBody('courseTitleTblId',currentIndex,andIndex,true);
		}else{
			
		}
		
	})
	
}
window.onload = (function () {
	jQuery(function(){
		andCourseRelationship();
		jQuery("h1.expand").toggler(); 
		//jQuery("#divContBoxLft").expandAll({trigger: "h1.expand"});
		//jQuery("#divContBoxRgt").expandAll({trigger: "h1.expand"});
		//jQuery('.collapse:first').show();
		//jQuery('h1.expand:first a:first').addClass("open");
		
		jQuery('#GCUCourse').hide();
		jQuery('form').submit(function() {
			if(jQuery('#CourseTle').is(':checked')) {
				if(jQuery("#courseTitleFormId").valid() == true){
	        		jQuery("#saveCourseTitle").attr("disabled", true);
	          		jQuery("#saveCourseTitleToNext").attr("disabled", true);
				}
			}
			if(jQuery('#GCU').is(':checked')) {
				if(jQuery("#gcuCourseCatgId").valid()){
	        		jQuery("#saveGCUCourseCatg").attr("disabled", true);
	          		jQuery("#saveGCUCourseCatgToNext").attr("disabled", true);
				}
			}
	    });

		// Tabs
		jQuery('#tabs').tabs();
		jQuery(".add").click(function() {
		jQuery(".transcript").show();
		jQuery(".institute").hide();
		});

		//hover states on the static widgets
		jQuery('#dialog_link, ul#icons li').hover(
			function() { jQuery(this).addClass('ui-state-hover'); },
			function() { jQuery(this).removeClass('ui-state-hover'); }
		);
		<c:if test="${fn:length(courseMappingList) gt 0 }">
			jQuery('#CourseTitle').show();
			jQuery('#GCUCourse').hide();
		</c:if>
		<c:if test="${fn:length(courseCategoryMappingList) gt 0 }">
			jQuery('#CourseTitle').hide();
			jQuery('#GCUCourse').show();
		</c:if>	
		jQuery('#CourseTle').click(function(){
				jQuery('#CourseTitle').show();
				jQuery('#GCUCourse').hide();
		});			
			
		jQuery('#GCU').click(function(){			
			jQuery('#CourseTitle').hide();
			jQuery('#GCUCourse').show();
		});
			jQuery("#gcuCourseCatgId").validate();
			jQuery("#courseTitleFormId").validate();
	jQuery(".removeRow").live('click', function(event) {
			jQuery(this).parent().parent().remove();
	});
	
	jQuery("[name='effective']").change(function(){
		if('${role}'=='MANAGER'){
			window.location.href='ieManager.html?operation=effectiveCourseRelationship&institutionId=${institutionId}&transferCourseId=${transferCourseId}&courseMappingId='+jQuery(this).val();
		}else{
			window.location.href='quality.html?operation=effectiveCourseRelationship&transferCourseMirrorId=${transferCourseMirrorId}&courseMappingId='+jQuery(this).val();
		}
	});
	
	});
});
</script>

<script type="text/javascript">
var globalstatus='';
var maxDat="";
	function addCourseRelationship(courseMappingId) {
		 var url;
		 if('${role}'=='MANAGER'){
			 if(courseMappingId=="0"){
				 url="<c:url value='/evaluation/ieManager.html?operation=addCourseRelationship&transferCourseId=${transferCourseId}&institutionId=${institutionId}'/>";
			 }else{
				 url="<c:url value='/evaluation/ieManager.html?operation=addCourseRelationship&transferCourseId=${transferCourseId}&institutionId=${institutionId}&courseMappingId="+courseMappingId+"'/>";
			}
		}else{
			 if(courseMappingId=="0"){
				 url="<c:url value='/evaluation/quality.html?operation=addCourseRelationship&transferCourseMirrorId=${transferCourseMirrorId}'/>";
			 }else{
				 url="<c:url value='/evaluation/quality.html?operation=addCourseRelationship&transferCourseMirrorId=${transferCourseMirrorId}&courseMappingId="+courseMappingId+"'/>";
			}
		}
		Boxy.load(url,
		{ unloadOnHide : true,
 		afterShow : function() {
		   settingMaskInput(); 
 		jQuery('#evaluationStatus').val(globalstatus);

 			 jQuery.validator.addMethod("dateRange", function() {
 				if(jQuery("#endDate").val()!="" && isDate(jQuery("#endDate").val())){
 					return new Date(jQuery("#effectiveDate").val()) < new Date(jQuery("#endDate").val());
 				}
				return true;
 			}, "End date should be greater than the effective date.");
 			
 			jQuery.validator.addClassRules({
 				requiredDateRange: { dateRange:true}
 			}); 
 			
 			jQuery("#frmCourseRelationship").validate();  
 		 	jQuery( "#gcuCourseCode" ).autocomplete({
 		 		
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
 						
 						jQuery("#gcuCourseCode").removeClass('auto-load');
 						response( jQuery.map( data, function( item ) {
 							
 								return {
 									label: item.courseCode+'--'+ item.title,
 									value: item.courseCode,
 									gcutitle: item.title,
 									gcuCourseId : item.id,
 									gcuCourseCredits : item.credits,
 									gcuCourseLevelId : item.courseLevelId,
 									gcuDateAdded : item.dateAdded
 								}
 							
 						}));
 					},
 					error: function(xhr, textStatus, errorThrown){
 						jQuery("#gcuCourseCode").removeClass('auto-load');
 						
 					},
 					

 				});
 			},
 			
 			minLength: 2,
 			 search: function(event, ui) {  jQuery(this).addClass("auto-load"); },
 			 open: function(event, ui) { jQuery(this).removeClass("auto-load"); },
 			select: function(event, ui) {
 			jQuery("#gcuCourseTitle").val(ui.item.gcutitle);
 			jQuery("#gcuCourseId").val(ui.item.gcuCourseId);
 			jQuery("#gcuCourseCredits").val(ui.item.gcuCourseCredits);
 			jQuery("#gcuCourseLevelId").val(ui.item.gcuCourseLevelId);
 			
 			
 			
 			var dat=new Date(ui.item.gcuDateAdded);
 			
 			var datAdd=dateFormat(dat,"MM/DD/YYYY");
 			
 			jQuery("#gcuDateAdded").val(datAdd);
 			
 			jQuery("#credits").val(ui.item.gcuCourseCredits);
 			/* jira issue #62  AdCourseLevelID = '3' Min Tr Grade = C
				 AdCourseLevelID in ('4','5') Min Tr Grade = B*/
 			if(ui.item.gcuCourseLevelId=='4'||ui.item.gcuCourseLevelId=='5'){
 				jQuery("#minTransferGrade").val("B");
 			}else if(ui.item.gcuCourseLevelId=='3'){
 				jQuery("#minTransferGrade").val("C");
 			}
 			jQuery("#effectiveDate").val(datAdd);
 			
 			
 			}
 			
 		 	}); 
 			
		}
		});
	}
		
		function dateFormat(date, format) {
		    // Calculate date parts and replace instances in format string accordingly
		    format = format.replace("DD", (date.getDate() < 10 ? '0' : '') + date.getDate()); // Pad with '0' if needed
		    format = format.replace("MM", (date.getMonth() < 9 ? '0' : '') + (date.getMonth() + 1)); // Months are zero-based
		    format = format.replace("YYYY", date.getFullYear());
		    return format;
		}
		function loadCorrespondingPage(urlToLoad){
			window.location = urlToLoad;
		}
		function fillGCUCourseCode(gcuCodeId){
			//alert(gcuCodeId);
			var cmIndex=gcuCodeId.split("_")[1];
			var cmdIndex=gcuCodeId.split("_")[2];
			var idIndex = cmIndex+"_"+cmdIndex;
			jQuery( "#"+gcuCodeId ).autocomplete({
 		 		
 				//source: availableTags,
 				source: function( request, response ) {
 					//alert(request.term);
 					jQuery.ajax({
 					url: "quality.html?operation=getCourseCode&gcuCourseCode="+request.term,
 					dataType: "json",
 					data: {
 						style: "full",
 						maxRows: 5,
 						name_startsWith: request.term
 					},
 					success: function( data ) {
 						
 						jQuery("#"+gcuCodeId).removeClass('auto-load');
 						response( jQuery.map( data, function( item ) {
 							
 								return {
 									label: item.courseCode+'--'+ item.title,
 									value: item.courseCode,
 									gcutitle: item.title,
 									gcuCourseId : item.id,
 									gcuCourseCredits : item.credits,
 									gcuCourseLevelId : item.courseLevelId,
 									gcuCourseLevel : item.gcuCourseLevel.name,
 									gcuDateAdded : item.dateAdded
 									
 								}
 							
 						}));
 					},
 					error: function(xhr, textStatus, errorThrown){
 						jQuery("#"+gcuCodeId).removeClass('auto-load');
 						
 					},
 					

 				});
 			},
 			
 			minLength: 2,
 			 search: function(event, ui) {  jQuery(this).addClass("auto-load"); },
 			 open: function(event, ui) { jQuery(this).removeClass("auto-load"); },
 			select: function(event, ui) {
 			jQuery("#gcuCourseTitle_"+idIndex).val(ui.item.gcutitle);
 			jQuery("#gcuCourseId_"+idIndex).val(ui.item.gcuCourseId);
 			jQuery("#gcuCourseCredits_"+idIndex).val(ui.item.gcuCourseCredits);
 			jQuery("#gcuCourseLevelId_"+idIndex).val(ui.item.gcuCourseLevelId);
 			jQuery("#gcuCourseLevel_"+idIndex).val(ui.item.gcuCourseLevel);
 			
 			
 			var dat=new Date(ui.item.gcuDateAdded);
 			var oldMaxDate=maxDateFn(cmIndex,cmdIndex);
 			if(oldMaxDate.length==0){
 				maxDat=dat;
 			}else if(maxDat>dat){
 				maxDat=oldMaxDate;
 			}else{
 				maxDat=dat;
 			}
 			
 			
 			var datAdd=dateFormat(maxDat,"MM/DD/YYYY");
 			jQuery("[id^='effectiveDate_"+cmIndex+"_']").val(datAdd);
 			
 			//jQuery("#effectiveDate_"+idIndex).val(datAdd);
 			
 			
 			}
 			
 		 	});
		}
function addCourseTitleBody(TblId,currentIndex,andIndex,isAnd){
	
	
	 	var   courseRowId = jQuery("#"+TblId+" tr:last").attr("id").split("_");
	 	var cssClassrow;
	 	
		var originalIndex=currentIndex;
		var originalAndIndex=andIndex;
		if(isAnd){
			if(jQuery("#courseTitle_"+originalIndex+"_"+originalAndIndex).hasClass('groupSele')){
		 		cssClassrow="groupSele";
		 	}else{
		 		cssClassrow="groupSele2";
		 	}
			
			index=originalIndex;
			andIndex=parseInt(andIndex) + 1;
		}else{
			if(jQuery("#"+TblId+" tr:last").hasClass('groupSele')){
		 		cssClassrow="groupSele2";
		 	}else{
		 		cssClassrow="groupSele";
		 	}
			index = parseInt(courseRowId[1]) + 1;
		}
		var trId = "'"+"gcuCourseCode_"+index+"_"+andIndex+"'";
		var courseTitleTableBodyId = "'"+TblId+"'";
		var addCourseTitleRowHtml =	'<tr id="courseTitle_'+index+'_'+andIndex+'" class='+cssClassrow+'>'+
									'<td><input type="text"   id="gcuCourseCode_'+index+'_'+andIndex+'"  name="courseMappings['+index+'].courseMappingDetails['+andIndex+'].gcuCourse.courseCode" value="" class="textField w80 required" onclick="javaScript:fillGCUCourseCode('+trId+');"/></td>'+
		    						'<td><input type="text"   id="gcuCourseTitle_'+index+'_'+andIndex+'" name="courseMappings['+index+'].courseMappingDetails['+andIndex+'].gcuCourse.title"  value="" readonly="true" class="textField w80 required"/>'+
			    					'<input type="hidden" id="gcuCourseId_'+index+'_'+andIndex+'"  name="courseMappings['+index+'].courseMappingDetails['+andIndex+'].gcuCourse.id" value=""/>'+
									'<input type="hidden" id="gcuCourseLevelId_'+index+'_'+andIndex+'"  name="courseMappings['+index+'].courseMappingDetails['+andIndex+'].gcuCourse.courseLevelId" value=""/>'+
									'<td><input type="text" name="courseMappings['+index+'].courseMappingDetails['+andIndex+'].gcuCourse.gcuCourseLevel.name" id="gcuCourseLevel_'+index+'_'+andIndex+'"  class="textField w80 " /></td>'+
									'<td><input type="text" id="gcuCourseCredits_'+index+'_'+andIndex+'" name="courseMappings['+index+'].courseMappingDetails['+andIndex+'].gcuCourse.credits" value="" readonly="true" class="textField w80"/></td>'+
									'<td><input type="text"  id="effectiveDate_'+index+'_'+andIndex+'" name="courseMappings['+index+'].courseMappingDetails['+andIndex+'].effectiveDate" value="" readonly="true" class="textField w80 maskDate required"></td>'+
									'<td><input type="text"  id="endDate_'+index+'_'+andIndex+'" name="courseMappings['+index+'].courseMappingDetails['+andIndex+'].endDate" value="" class="textField w80 maskEndDate" /></td>'+
									'</td> <td><input type="checkbox" id="andCheck_'+index+'_'+andIndex+'"   class=" w80 " /></td>'+
									'<td><a href="javaScript:void(0);" id="removeRow_'+index+'_'+andIndex+'" name="removeRow_'+index+'" class="removeIcon fr removeRow" onclick="javaScript:deleteRow('+courseTitleTableBodyId+');"></a></td></tr>';
						//alert(addCourseTitleRowHtml);	
		if(isAnd){				
			jQuery("#courseTitle_"+originalIndex+"_"+originalAndIndex).after(addCourseTitleRowHtml);
		}else{
			jQuery("#"+TblId+" tr:last").after(addCourseTitleRowHtml);
		}
  settingMaskInput();
}
function addGCUCourseCategoryRow(TblId){
	 var courseRowId = jQuery("#"+TblId+" tr:last").attr("id").split("_");
		index = parseInt(courseRowId[1]) + 1;
		var trId = "'"+"selGcuCourseCtg_"+index+"'";
		var courseCategoryTableRowId = '"'+TblId+'"';
		var selectCatgOption = "";
		<c:forEach items="${gcuCourseCategoryList}" var="gcuCourseCategory">
				selectCatgOption = selectCatgOption +'<option value="${gcuCourseCategory.id}">${gcuCourseCategory.name}</option>';
 	 	</c:forEach>
		var addCourseTitleRowHtml =	'<tr id="gcuCourseCategoryRow_'+index+'"><td>'+
									'<select class="w90per required valid required" name="courseCategoryMappings['+index+'].gcuCourseCategory.id" id="selGcuCourseCtg_'+index+'"  onchange="javaScript:filltheTitle('+trId+');">'+
    									'<option value="">Select Course Category</option>'+selectCatgOption+'</select></td>'+
    									'<input type="hidden" name="courseCategoryMappings['+index+'].gcuCourseCategory.name" id="gcuCourseCategoryName_'+index+'">'+
    							'<td><input type="text" name="courseCategoryMappings['+index+'].effectiveDate" value="" class="textField w80 maskDate required"></td>'+
    							'<td><input type="text" name="courseCategoryMappings['+index+'].endDate"  value="" class="textField w80 maskEndDate" /></td>'+
    							'<td><a href="javaScript:void(0);" id="removeRow_'+index+'" name="removeRow_'+index+'" class="removeIcon fr removeRow" onclick="javaScript:deleteRow('+courseCategoryTableRowId+');"></a></td></tr>';
	
						//alert(addCourseTitleRowHtml);	
		jQuery("#"+TblId+" tr:last").after(addCourseTitleRowHtml);
		settingMaskInput();
}

function saveGCUCourseCatgName(){
	var url="";
	if('${role}'=="MANAGER"){
		url="<c:url value='/evaluation/ieManager.html?operation=saveCourseCtgRelationshipList&transferCourseId=${transferCourseId}'/>";
	}else{
		url="<c:url value='/evaluation/quality.html?operation=saveCourseCtgRelationshipList&transferCourseMirrorId=${transferCourseMirrorId}'/>";
	}	
	document.gcuCourseCatg.action = url;
	document.gcuCourseCatg.submit();
}

function saveGCUCourseTitle(){
	var url="";
	if('${role}'=="MANAGER"){
		url="<c:url value='/evaluation/ieManager.html?operation=saveCourseRelationshipList&transferCourseId=${transferCourseId}'/>";
	}else{
		url="<c:url value='/evaluation/quality.html?operation=saveCourseRelationshipList&transferCourseMirrorId=${transferCourseMirrorId}'/>";
	}	
	document.courseTitleForm.action = url;
	document.courseTitleForm.submit();
}
function filltheTitle(selectBoxIndex){
	
	var indexToFill = selectBoxIndex.split("_")[1];
	if(jQuery("#"+selectBoxIndex+" :selected").val() != null && jQuery("#"+selectBoxIndex+" :selected").val() != ''){
		var gcuCourseCategoryName = jQuery("#"+selectBoxIndex+" :selected").text();
		//alert("gcuCourseCategoryName="+gcuCourseCategoryName);
		jQuery("#gcuCourseCategoryName_"+indexToFill).val(gcuCourseCategoryName);
	}
}
function markCourseToNext(idTOset,saveAndNextValue){
	jQuery("#"+idTOset).val(saveAndNextValue);	
}
function deleteRow(tableIdTodeleteRow){
	jQuery(".removeRow").live('click', function(event) {
		maxDat="";
		jQuery(this).parent().parent().remove();
	});
	var noOfTableRows = jQuery('#'+tableIdTodeleteRow+' tr').length
	//alert(noOfTableRows);
	 if(noOfTableRows == 2){
			jQuery("#CourseTle").removeAttr("disabled");
			jQuery("#GCU").removeAttr("disabled");
			if(tableIdTodeleteRow == 'gcuCourseCategoryId'){
				addGCUCourseCategoryRow(tableIdTodeleteRow);
			}else{
				addCourseTitleBody(tableIdTodeleteRow,0,0,false);
			}
	}
}
function maxDateFn(cmIndex,cmdIndex){
	var dates=[];
	var skipId=jQuery("#effectiveDate_"+cmIndex+"_"+cmdIndex);
	jQuery("[id^='effectiveDate_"+cmIndex+"']").each(function(){
		var curDat=jQuery(this).val();
		var curId=jQuery(this).attr('id');
		
		if(curDat.length>0 && curId!=skipId){
			dates.push(new Date(curDat));
		}
	})
	if(dates.length>0){
		var maxDate=new Date(Math.max.apply(null,dates));
		var minDate=new Date(Math.min.apply(null,dates));
		return maxDate;
	}else{
		return "";
	}
		
}
</script>
 <style>.ui-autocomplete {
    max-height: 100px !important;
}</style>
 <c:choose>
     	<c:when test="${userRoleName =='Institution Evaluation Manager'}"> 
        	<c:set var="backLink" scope="session" value="/evaluation/ieManager.html?operation=ieCourse&transferCourseId=${transferCourseId}"/>
        	<c:set var="saveCourseCtgRelationshipUrl" scope="session" value="/evaluation/ieManager.html?operation=saveCourseCtgRelationshipList&transferCourseId=${transferCourseId}"/>
        	<c:set var="saveCourseRelationshipUrl" scope="session" value="/evaluation/ieManager.html?operation=saveCourseRelationshipList&transferCourseId=${transferCourseId}"/>
 	 	</c:when>
 	 	<c:when test="${userRoleName =='Administrator'}"> 
        	<c:set var="backLink" scope="session" value="/evaluation/admin.html?operation=viewCourseDetails&courseId=${transferCourseId}"/>
        	<c:set var="saveCourseCtgRelationshipUrl" scope="session" value="/evaluation/ieManager.html?operation=saveCourseCtgRelationshipList&transferCourseId=${transferCourseId}"/>
        	<c:set var="saveCourseRelationshipUrl" scope="session" value="/evaluation/ieManager.html?operation=saveCourseRelationshipList&transferCourseId=${transferCourseId}"/>
 	 	</c:when>
 		<c:otherwise>
 			<c:set var="backLink" scope="session" value="/evaluation/quality.html?operation=ieCourse&institutionMirrorId=${institutionMirrorId}&transferCourseId=${transferCourseId}"/>
 			<c:set var="saveCourseCtgRelationshipUrl" scope="session" value="/evaluation/quality.html?operation=saveCourseCtgRelationshipList&transferCourseMirrorId=${transferCourseMirrorId}"/>
 			<c:set var="saveCourseRelationshipUrl" scope="session" value="/evaluation/quality.html?operation=saveCourseRelationshipList&transferCourseMirrorId=${transferCourseMirrorId}"/>
 	 	</c:otherwise>
 	</c:choose> 
 	 
 <div>
  <div class="institute">
  	<div class="">
    <div class="institutionHeader">
		<a href="javaScript:void(0);" onClick="javaScript:loadCorrespondingPage('<c:url value="${courseDetailLink}"/>');" class="mr10"><img src="<c:url value='/images/arow_img.png'/>" width="15" height="13" alt="" />Back To Course Details</a>
	</div>
	<c:set var="selectedInstitution"  value="${institution}" scope="request" />
 	<%@include file="../common/institutionInfo.jsp" %>
	    <ul class="pageNav">        
	        <li><a  onclick="javaScript:loadCorrespondingPage('<c:url value="${courseDetailLink}"/>')" href="javaScript:void(0);" style="z-index:9;" >Course Details<span class="sucssesIcon"></span></a></li>
	      
	        <li><a <c:if test="${! empty relationLink}"> onclick="javaScript:loadCorrespondingPage('<c:url value="${relationLink}"/>&transferCourseMirrorId=${transferCourseMirrorId}')" </c:if> href="javaScript:void(0);" style="z-index:5;" class="active" >Course Relationship<c:choose><c:when test="${fn:length(courseCategoryMappingList) gt 0 || fn:length(courseMappingList) gt 0}"><span class="sucssesIcon"></span></c:when><c:otherwise><span class="alrtIcon"></span></c:otherwise></c:choose></a> </li>
	        <li><a <c:if test="${! empty relationLink}"> onclick="javaScript:loadCorrespondingPage('<c:url value="${markCompleteLinkCourse}"/>')" </c:if> href="javaScript:void(0);" class="last">Summary</a></li> 
        </ul>
    	<div class="infoContnr"><div class="infoTopArow infoarow2"></div>
    	<div class="deoInfo"> <h1><label class="mr22">Transfer Course:</label> ${transferCourse.trCourseCode } -- ${transferCourse.trCourseTitle }</h1> </div>
        <div class="mb30">
        <label class="noti-label">Course Relationship:</label>
         <label class="mr22" style="margin-top:5px;">
         		
         		<c:choose>
         			<c:when test="${fn:length(courseMappingList) gt 0}">
         				<c:set var="courseMapselected" value="checked='checked'"/>
         				<c:set var="courseCatDisabled" value="disabled='disabled'"/>
         				<c:set var="courseCatselected" value=""/>
         				<c:set var="courseMapDisabled" value=""/>
         			</c:when>
         			<c:when test="${fn:length(courseCategoryMappingList) gt 0 }">
         				<c:set var="courseCatselected" value="checked='checked'"/>
         				<c:set var="courseMapDisabled" value="disabled='disabled'"/>
         				<c:set var="courseMapselected" value=""/>
         				<c:set var="courseCatDisabled" value=""/>
         			</c:when>
         			<c:when test="${fn:length(courseMappingList) le 0 && fn:length(courseCategoryMappingList) le 0 }">
         				<c:set var="courseCatselected" value=""/>
         				<c:set var="courseMapDisabled" value=""/>
         				<c:set var="courseMapselected" value="checked='checked'"/>
         				<c:set var="courseCatDisabled" value=""/>
         			</c:when>
         			<c:otherwise>
         				<%-- <c:set var="courseMapselected" value="checked='checked'"/>
         				<c:set var="courseCatDisabled" value="disabled='disabled'"/>
         				<c:set var="courseCatselected" value=""/>
         				<c:set var="courseMapDisabled" value=""/> --%>
         			</c:otherwise>
         		</c:choose>
         		
               		 <input name="RadioGroup1" type="radio" id="CourseTle" value="radio" <c:if test="${! empty courseMapselected }">${courseMapselected }</c:if>  
         				<c:if test="${! empty courseMapDisabled }">${courseMapDisabled }</c:if> />Course Title</label>
             
              <label style="margin-top:5px;">
                <input type="radio" name="RadioGroup1" value="radio" id="GCU"  <c:if test="${! empty courseCatselected }">${courseCatselected }</c:if>  
         		<c:if test="${! empty courseCatDisabled }">${courseCatDisabled }</c:if>/>
                GCU Course Category
              </label>
        	       
        </div>
    	  <div id="GCUCourse">
    	  <form id="gcuCourseCatgId" name="gcuCourseCatg" method="post" action='<c:url value="${saveCourseCtgRelationshipUrl}"/>'>
    	    <div>
	    	    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl3 noti-bbn tabTBLborder contentForm" id="gcuCourseCategoryId">
					  <tr id="gcuCourseCategoryRow_-1">
						    <th width="60%" scope="col" class="dividerGrey">GCU Course Category</th>
						    <th width="10%" scope="col" class="dividerGrey">Effective Date</th>
						    <th width="10%" scope="col" class="dividerGrey">End Date</th>
						    <th width="10%" scope="col" class="dividerGrey"></th>
					    </tr>
					  <c:choose>
						  	<c:when test="${fn:length(courseCategoryMappingList) gt 0  }">
							  	<c:forEach items="${courseCategoryMappingList}" var="courseCategoryMappings" varStatus="courseCategoryMappingsIndex">
							  		<c:if test="${! empty courseCategoryMappings.gcuCourseCategory.name}">
								  		<tr id="gcuCourseCategoryRow_${courseCategoryMappingsIndex.index }">
										    <td>
										    	<select class="w90per required valid required" name="courseCategoryMappings[${courseCategoryMappingsIndex.index }].gcuCourseCategory.id" id="selGcuCourseCtg_${courseCategoryMappingsIndex.index }" onchange="javaScript:filltheTitle('selGcuCourseCtg_${courseCategoryMappingsIndex.index }');">
										    		<option value="">Select Course Category</option>
										    		<c:forEach items="${gcuCourseCategoryList}" var="gcuCourseCategory">
			        									<option <c:if test="${courseCategoryMappings.gcuCourseCategory.id == gcuCourseCategory.id}"> selected="true" </c:if> value="${gcuCourseCategory.id}">${gcuCourseCategory.name}</option>
			        								</c:forEach>
										     	 	
										   		 </select>
										   		 <input type="hidden" name="courseCategoryMappings[${courseCategoryMappingsIndex.index }].id" value="">
										   		 <input type="hidden" id="gcuCourseCategoryName_${courseCategoryMappingsIndex.index }" name="courseCategoryMappings[${courseCategoryMappingsIndex.index }].gcuCourseCategory.name" value="${courseCategoryMappings.gcuCourseCategory.name}">
										    </td>
										    <td><input type="text" name="courseCategoryMappings[${courseCategoryMappingsIndex.index }].effectiveDate"  value="<fmt:formatDate value='${courseCategoryMappings.effectiveDate}' pattern="MM/dd/yyyy"/>"  class="textField w80 maskDate required"></td>
										    <td><input type="text" name="courseCategoryMappings[${courseCategoryMappingsIndex.index }].endDate"  value="<fmt:formatDate value='${courseCategoryMappings.endDate}' pattern="MM/dd/yyyy"/>" class="textField w80 maskEndDate" /></td>
										    <td><a href="javaScript:void(0);" id="removeRow_${courseCategoryMappingsIndex.index }" name="removeRow_${courseCategoryMappingsIndex.index }" class="removeIcon fr removeRow" onclick="javaScript:deleteRow('gcuCourseCategoryId');"></a></td>
								  		</tr>
							  		</c:if>
							  </c:forEach>
						  	</c:when>
						  	<c:otherwise>
						  		<tr id="gcuCourseCategoryRow_0">
								    <td>
								    	<select class="w90per required valid required" name="courseCategoryMappings[0].gcuCourseCategory.id" id="selGcuCourseCtg_0" onchange="javaScript:filltheTitle('selGcuCourseCtg_0');">
								    		<option value="">Select Course Category</option>
								    			<c:forEach items="${gcuCourseCategoryList}" var="gcuCourseCategory">
								     	 			<option value="${gcuCourseCategory.id}">${gcuCourseCategory.name}</option>
								     	 		</c:forEach>
								   		 </select>
								   		 <input type="hidden" id="gcuCourseCategoryName_0" name="courseCategoryMappings[0].gcuCourseCategory.name" value="">
								    </td>
								    
								    <td><input type="text" name="courseCategoryMappings[0].effectiveDate" value=""  class="textField w80 maskDate required"></td>
								    <td><input type="text" name="courseCategoryMappings[0].endDate"  value="" class="textField w80 maskEndDate" /></td>
								    <td><a href="javaScript:void(0);" id="removeRow_0" name="removeRow_0" class="removeIcon fr removeRow" onclick="javaScript:deleteRow('gcuCourseCategoryId');"></a></td>
						 		</tr>					  	
						  	</c:otherwise>
					  </c:choose> 
			</table>
		</div>
			<div class="mt10 mb10" style="margin-left:-15px;">
		  	  <div class="fl institutionHeader ml20">
		      <a onclick="addGCUCourseCategoryRow('gcuCourseCategoryId');" href="javascript:void(0)"><img src="<c:url value='/images/termTypeIcon.png'/>" alt="">Add New</a>
			   </div>
		  	  <br class="clear">
		        
		    </div>
		    <div class="divider3"></div>
	        <div class="fr mt10">
	          <input type="hidden" id="saveAndNextCourseCatg" name="saveAndNext" value="0">
		           <c:choose>
		        		<c:when test='${fn:toUpperCase(transferCourse.evaluationStatus) eq "NOT EVALUATED" && ((! empty transferCourse.checkedBy && transferCourse.checkedBy eq userCurrentId) ||(! empty transferCourse.confirmedBy && transferCourse.confirmedBy eq userCurrentId) ) && (userRoleName ne "Institution Evaluation Manager" || userRoleName ne "Administrator")}'>
				 			 <input type="submit" name="saveGCUCourseCatg" value="Save" id="saveGCUCourseCatg" class="button" onclick="javaScript:markCourseToNext('saveAndNextCourseCatg','0');">
				  			 <input type="submit" name="saveGCUCourseCatgToNext" value="Save&Next" id="saveGCUCourseCatgToNext" class="button" onclick="javaScript:markCourseToNext('saveAndNextCourseCatg','1');">
				  		</c:when>
				  		<c:when test="${userRoleName eq 'Institution Evaluation Manager' || userRoleName eq 'Administrator'}">
				  			 <input type="submit" name="saveGCUCourseCatg" value="Save" id="saveGCUCourseCatg" class="button" onclick="javaScript:markCourseToNext('saveAndNextCourseCatg','0');">
				  			 <input type="submit" name="saveGCUCourseCatgToNext" value="Save&Next" id="saveGCUCourseCatgToNext" class="button" onclick="javaScript:markCourseToNext('saveAndNextCourseCatg','1');">
				  		</c:when>
		        		<c:otherwise>
		        		
		        		</c:otherwise>
		        	</c:choose>	
			</div>
	        <div class="clear"></div>
	    	</form>    
        </div>
        <div id="CourseTitle">
        <form id="courseTitleFormId" name="courseTitleForm" method="post" action='<c:url value="${saveCourseRelationshipUrl}"/>'>
    	    <div>
	    	    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl3 noti-bbn tabTBLborder contentForm" id="courseTitleTblId">
				 	 <tr id="courseTitle_-1">
					    <th width="10%" scope="col" class="dividerGrey">GCU Course Code</th>
					    <th width="40%" scope="col" class="dividerGrey">Course Title</th>
					    <th width="15%" scope="col" class="dividerGrey">GCU Course Level</th>
					    <th width="5%" scope="col" class="dividerGrey">Credit</th>
					    <th width="10%" scope="col" class="dividerGrey">Effective Date</th>
					    <th width="10%" scope="col" class="dividerGrey">End Date</th>
					    <th width="5%" scope="col" class="dividerGrey">AND</th>
					    <th width="5%" scope="col" class="dividerGrey"></th>
				    </tr>
				    <c:choose>
				    <c:when test="${fn:length(courseMappingList) gt 0 }">
				     <c:forEach items="${courseMappingList }" var="courseMapping" varStatus="courseMappingIndex">	
				       <c:forEach items="${courseMapping.courseMappingDetails }" var="courseMappingDetail" varStatus="courseMappingDetailIndex">
				       	
						  <tr   <c:choose><c:when test="${courseMappingIndex.index % 2 eq 0 }"> class="groupSele"</c:when><c:otherwise> class="groupSele2"</c:otherwise></c:choose> id="courseTitle_${courseMappingIndex.index }_${courseMappingDetailIndex.index}">
							    <td> <input type="text"   id="gcuCourseCode_${courseMappingIndex.index }_${courseMappingDetailIndex.index}"  name="courseMappings[${courseMappingIndex.index }].courseMappingDetails[${courseMappingDetailIndex.index}].gcuCourse.courseCode" value="${courseMappingDetail.gcuCourse.courseCode }" class="textField w80 required" onclick="javaScript:fillGCUCourseCode('gcuCourseCode_${courseMappingIndex.index }_${courseMappingDetailIndex.index}');"/></td>
							    <td><input type="text"   id="gcuCourseTitle_${courseMappingIndex.index }_${courseMappingDetailIndex.index}" name="courseMappings[${courseMappingIndex.index }].courseMappingDetails[${courseMappingDetailIndex.index}].gcuCourse.title"  value="${courseMappingDetail.gcuCourse.title}" readonly="true" class="textField w80 required"/>
								    <input type="hidden" id="gcuCourseId_${courseMappingIndex.index }_${courseMappingDetailIndex.index}"  name="courseMappings[${courseMappingIndex.index }].courseMappingDetails[${courseMappingDetailIndex.index}].gcuCourse.id" value="${courseMappingDetail.gcuCourse.id}"/>
        							<input type="hidden" id="gcuCourseLevelId_${courseMappingIndex.index }_${courseMappingDetailIndex.index}"  name="courseMappings[${courseMappingIndex.index }].courseMappingDetails[${courseMappingDetailIndex.index}].gcuCourse.courseLevelId" value="${courseMappingDetail.gcuCourse.courseLevelId}"/>
        							<input type="hidden" name="courseMappings[${courseMappingIndex.index }].courseMappingDetails[${courseMappingDetailIndex.index}].id" value="${courseMappingId}">
							    </td>
							   <td> <input type="text" name="courseMappings[${courseMappingIndex.index }].courseMappingDetails[${courseMappingDetailIndex.index}].gcuCourse.gcuCourseLevel.name" id="gcuCourseLevel_${courseMappingIndex.index }_${courseMappingDetailIndex.index}"  value="${courseMappingDetail.gcuCourse.gcuCourseLevel.name}" readonly="true" class="textField w80"/></td>
							   <td> <input type="text" name="courseMappings[${courseMappingIndex.index }].courseMappingDetails[${courseMappingDetailIndex.index}].gcuCourse.credits" id="gcuCourseCredits_${courseMappingIndex.index }_${courseMappingDetailIndex.index}"  value="${courseMappingDetail.gcuCourse.credits}" readonly="true" class="textField w80"/></td>
								<td><input type="text"  id="effectiveDate_${courseMappingIndex.index }_${courseMappingDetailIndex.index}" name="courseMappings[${courseMappingIndex.index }].courseMappingDetails[${courseMappingDetailIndex.index}].effectiveDate" value="<fmt:formatDate value='${courseMappingDetail.effectiveDate }' pattern="MM/dd/yyyy"/>" readonly="true" class="textField w80 maskDate required"></td>
								<td><input type="text"  id="endDate_${courseMappingIndex.index }_${courseMappingDetailIndex.index}" name="courseMappings[${courseMappingIndex.index }].courseMappingDetails[${courseMappingDetailIndex.index}].endDate" value="<fmt:formatDate value='${courseMappingDetail.endDate }' pattern="MM/dd/yyyy"/>" class="textField w80 maskEndDate" /></td>
								<td><input type="checkbox" <c:if test="${fn:length(courseMapping.courseMappingDetails)-1 >courseMappingDetailIndex.index }">checked="checked"</c:if>  id="andCheck_${courseMappingIndex.index}_${courseMappingDetailIndex.index}" class=" w80 " /></td>
					    		<td><a href="javaScript:void(0);" id="removeRow_${courseMappingIndex.index }" name="removeRow_${courseMappingIndex.index }" class="removeIcon fr removeRow" onclick="javaScript:deleteRow('courseTitleTblId');"></a></td>
					    </tr>
					     </c:forEach>
				    </c:forEach>
			    </c:when>
			    <c:otherwise>
				     <tr class="groupSele" id="courseTitle_0_0">
							 	<td><input type="text"   id="gcuCourseCode_0_0"  name="courseMappings[0].courseMappingDetails[0].gcuCourse.courseCode" value="" class="textField w80 required" onclick="javaScript:fillGCUCourseCode('gcuCourseCode_0_0');"/></td>
							    <td><input type="text"   id="gcuCourseTitle_0_0" name="courseMappings[0].courseMappingDetails[0].gcuCourse.title"  value="" readonly="true" class="textField w80 required"/>
        							<input type="hidden" id="gcuCourseLevelId_0_0"  name="courseMappings[0].courseMappingDetails[0].gcuCourse.courseLevelId" value=""/>
        							<input type="hidden" id="gcuCourseId_0_0"  name="courseMappings[0].courseMappingDetails[0].gcuCourse.id" value=""/>
							    </td>
							    <td><input type="text" id="gcuCourseLevel_0_0" name="courseMappings[0].courseMappingDetails[0].gcuCourse.gcuCourseLevel.name" value="" readonly="true" class="textField w80"/></td>
							    <td><input type="text" id="gcuCourseCredits_0_0" name="courseMappings[0].courseMappingDetails[0].gcuCourse.credits" value="" readonly="true" class="textField w80"/></td>
								<td><input type="text"  id="effectiveDate_0_0" name="courseMappings[0].courseMappingDetails[0].effectiveDate" value="" readonly="true" class="textField w80 maskDate required"></td>
								<td><input type="text"  id="endDate_0_0" name="courseMappings[0].courseMappingDetails[0].endDate" value="" class="textField w80 maskEndDate" /></td>
								<td><input type="checkbox" id="andCheck_0_0"   class=" w80 " /></td>
					    		<td><a href="javaScript:void(0);" id="removeRow_0_0" name="removeRow_0" class="removeIcon fr removeRow" onclick="javaScript:deleteRow('courseTitleTblId');"></a></td>
					</tr>
			    </c:otherwise>
			    </c:choose>
			    <input type="hidden" name="trCourseId" value="${transferCourseId}">
				<input type="hidden" name="institutionId" value="${institutionId}">
				
			 	
			</table>
	</div>
	<div class="mt10 mb10" style="margin-left:-15px;">
  	  <div class="fl institutionHeader ml20">
      <a onclick="javascript:addCourseTitleBody('courseTitleTblId',0,0,false)" href="javascript:void(0)"><img src="<c:url value='/images/termTypeIcon.png'/>" alt="">Add New</a>
	   </div>
  	  <br class="clear">
        
    </div>
     <div class="divider3"></div>
        <div class="fr mt10">
          <input type="hidden" id="saveAndNextCourseTitle" name="saveAndNext" value="0">
	          <c:choose>
	        		<c:when test='${fn:toUpperCase(transferCourse.evaluationStatus) eq "NOT EVALUATED" && ((! empty transferCourse.checkedBy && transferCourse.checkedBy eq userCurrentId) ||(! empty transferCourse.confirmedBy && transferCourse.confirmedBy eq userCurrentId) ) && (userRoleName ne "Institution Evaluation Manager" || userRoleName ne "Administrator")}'>
			 		 	<input type="submit" name="saveCourseTitle" value="Save" id="saveCourseTitle" class="button" onclick="javaScript:markCourseToNext('saveAndNextCourseTitle','0');">
			  		 	<input type="submit" name="saveCourseTitleToNext" value="Save & Next" id="saveCourseTitleToNext" class="button" onclick="javaScript:markCourseToNext('saveAndNextCourseTitle','1');">
			  		</c:when>
			  		<c:when test="${userRoleName eq 'Institution Evaluation Manager' || userRoleName eq 'Administrator'}">
			  			<input type="submit" name="saveCourseTitle" value="Save" id="saveCourseTitle" class="button" onclick="javaScript:markCourseToNext('saveAndNextCourseTitle','0');">
			  		 	<input type="submit" name="saveCourseTitleToNext" value="Save & Next" id="saveCourseTitleToNext" class="button" onclick="javaScript:markCourseToNext('saveAndNextCourseTitle','1');">
			  		</c:when>
	        		<c:otherwise>
	        		
	        		</c:otherwise>
	        </c:choose>
		</div>
        <div class="clear"></div>
       </form> 
        </div>
         
      </div>
        
        
    </div>
  </div>
    
  
    </div>
