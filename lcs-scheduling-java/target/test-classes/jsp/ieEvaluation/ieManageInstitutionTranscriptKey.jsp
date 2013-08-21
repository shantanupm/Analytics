<%@include file="../init.jsp" %>
<script type='text/javascript' src="<c:url value='/js/expand.js'/>"></script>
<script type="text/javascript">
window.onload = (function () {		
jQuery(document).ready(function() {
	jQuery("h1.expand").toggler(); 
    jQuery("#divContBoxLft").expandAll({trigger: "h1.expand"});
	 jQuery("#divContBoxRgt").expandAll({trigger: "h1.expand"});
	
	 jQuery('.collapse:first').hide();
	 jQuery('h1.expand:first a:first').addClass("close");
	validateRequired();
	/*jQuery('.longDescriptionAlpha :last').live('blur',function(event){
		addAlpharow();
	})
	
	jQuery('.longDescriptionNumeric :last').live('blur',function(event){
		addNumericrow();
	})*/
	jQuery('.longDescriptionAlpha :last').live('keydown',function(e) {
		 var code = (e.keyCode ? e.keyCode : e.which);
		 if(code == 9) {
			addAlpharow();
		 }
	})
	
	jQuery('.longDescriptionNumeric :last').live('keydown',function(e) {
		 var code = (e.keyCode ? e.keyCode : e.which);
		 if(code == 9) {
			addNumericrow();
		 }
	})
	
	jQuery("a[id^='tablink_']").each(
		function() {
			jQuery("#"+this.id).click(
				function() {
					tabClicked(this.id);
				}
			);
		}
	);
	
	

jQuery(".removeRow").live('click', function(event) {
	jQuery(this).parent().parent().remove();
});
jQuery("#frmTranscriptKey").validate();

jQuery(".alphaClass").css("text-transform" ,"uppercase" );
jQuery(".alphaClass").live('on keyup', function(event) {
	
	jQuery(this).val(jQuery(this).val().toUpperCase());
});



jQuery(".alphaClass,.numericFromClass,.numericToClass").live('blur', function(event) {
	validateRequired();
	
})



jQuery.validator.addMethod("dateRange", function() {
	if(jQuery("#endDate").val()!="" ){
			return  jQuery("#effectiveDate").val() < jQuery("#endDate").val();
	}
	return true;
	}, "End date should be greater than the effective date.");
	
	jQuery.validator.addClassRules({
		requiredDateRange: {dateRange:true}
	});
	
	numericOverlapValidate();
	
	
});
});

function numericOverlapValidate(){
	jQuery.validator.addMethod("gradeRange", function() {
		var numberRowIdIndex;
		try{
			numberRowIdIndex = parseInt(jQuery("#addGradeNumberTbl tr:last").attr("id").split("_")[1])+1;
		}catch(err){
			numberRowIdIndex=0;
		}
		var i=0;
		for( i=0;i<=numberRowIdIndex;i++){
			var fromGrade1=jQuery("#numericGradeFrom_"+i).val();
			var toGrade1=jQuery("#numericGradeTo_"+i).val();
			
			
			if(jQuery("#numericGradeTo_"+i).val()!="" ){
					if(  parseInt(jQuery("#numericGradeFrom_"+i).val()) > parseInt(jQuery("#numericGradeTo_"+i).val())){
						return false
					}
			}
			var indexAhead=i+1
				var fromGrade2=parseInt(jQuery("#numericGradeFrom_"+indexAhead).val());
				var toGrade2=parseInt(jQuery("#numericGradeTo_"+indexAhead).val());
				
			if(numberRowIdIndex>1&& fromGrade2!==undefined && toGrade2!==undefined){
					if((fromGrade1 <= toGrade2) && (fromGrade2 <= toGrade1)){	
						return false
					}
			}
			
		}
		return true;
		}, "Numeric grades must not overlap. Please correct the grade scale before saving.");
		
		jQuery.validator.addClassRules({
			numericToClass: {gradeRange:true}
		});

}


function validateRequired(){
	var alphaEmpty=true,numericEmpty=true;
	jQuery(".alphaClass").each(function(){
		if(jQuery(this).val().length>0){
			alphaEmpty=false;
			return 1;
		}
	})
	
	jQuery(".numericFromClass,.numericToClass").each(function(){
		if(jQuery(this).val().length>0){
			numericEmpty=false;
			return 1;
		}
	})
	
	if(!alphaEmpty){
		jQuery(".numericFromClass").removeClass('required');
		jQuery(".numericToClass").removeClass('required');
	}else{
		jQuery(".numericFromClass").addClass('required');
		jQuery(".numericToClass").addClass('required');
	}
	
	if(!numericEmpty){
		jQuery(".alphaClass").removeClass('required');
	}else{
		jQuery(".alphaClass").addClass('required');
	}
}
function addTKrow(){
	var tkRowIdIndex;
	try{
		tkRowIdIndex = parseInt(jQuery("#addTranscriptKeyTbl tr:last").attr("id").split("_")[1])+1;
	}catch(err){
		tkRowIdIndex=0;
	}
	var appendText = "<tr id='trAbRow_"+tkRowIdIndex+"'> <td><Span><input  id='from_"+tkRowIdIndex+"' type='text'  name='institutionTranscriptKeyDetailsList["+tkRowIdIndex+"].from' " +
	"value='${institutionTranscriptKeyDetails.from}' class='txbx w80 required' /></span></td>" +
	"<td><Span><input  id='to_"+tkRowIdIndex+"'type='text' name='institutionTranscriptKeyDetailsList["+tkRowIdIndex+"].to'" +
	" value='${institutionTranscriptKeyDetails.to}' class='txbx w80 ' /></span></td>" +
	" <td><span><select id='courseLevelId_"+tkRowIdIndex+"'  class=' w90per eventCaptureField required' " +
	"name='institutionTranscriptKeyDetailsList["+tkRowIdIndex+"].gcuCourseLevel.id' >" +
	" <option id='' value=''>Select Course Level</option>" +
	"<c:forEach items='${gcuCourseLevelList}' var='gcuCourseLevel'>" +
	"<option value='${gcuCourseLevel.id}'>${gcuCourseLevel.name}</option> </c:forEach> </select></span></td>" +
	" <td id='removeRowTd_"+tkRowIdIndex+"'><a href='javaScript:void(0);' id='removeRow_"+tkRowIdIndex+"'" +
	" name='removeRow_"+tkRowIdIndex+"' class='removeIcon fr removeRow'></a></td></tr>"
	jQuery("#addTranscriptKeyTbl tr:last").after(appendText);
	settingMaskInput();
}

function addAlpharow(){
	var alphaRowIdIndex;
	try{
		alphaRowIdIndex = parseInt(jQuery("#addGradeAlphaTbl tr:last").attr("id").split("_")[1])+1;
	}catch(err){
		alphaRowIdIndex=100;
	}
	var appendText = "<tr id='trAbRow_"+alphaRowIdIndex+"'><td><input type='text'  name='institutionTranscriptKeyGradeList["+alphaRowIdIndex+"].gradeAlpha' class='textField alphaClass w90per required' />" +
	"</td><td><input type='text'  name='institutionTranscriptKeyGradeList["+alphaRowIdIndex+"].shortDescription' class='textField w90per'></td>" +
	"     <td><input type='text'  name='institutionTranscriptKeyGradeList["+alphaRowIdIndex+"].longDescription' class='textField w90per longDescriptionAlpha'></td> " +
	"   <td id='removeRowTd_"+alphaRowIdIndex+"'><a href='javaScript:void(0);' id='removeRow_"+alphaRowIdIndex+"' " +
	"class='removeIcon fr removeRow'></a></td></tr>   "
	jQuery("#addGradeAlphaTbl tr:last").after(appendText);
	settingMaskInput();
}

function addNumericrow(){
	var numberRowIdIndex;
	try{
		numberRowIdIndex = parseInt(jQuery("#addGradeNumberTbl tr:last").attr("id").split("_")[1])+1;
	}catch(err){
		numberRowIdIndex=0;
	}
	var appendText = "<tr  id='trGrdNumberRow_"+numberRowIdIndex+"'> " +
	"<td><input type='text' id='numericGradeFrom_"+numberRowIdIndex+"'  value='${institutionTranscriptKeyGradeNumber.gradeFrom }' name='institutionTranscriptKeyGradeList["+numberRowIdIndex+"].gradeFrom'" +
	" class='textField w40 required numericFromClass number' /> <div class='fl mr10 ml10 mt5'><strong>To</strong> &nbsp;&nbsp;</div>         " +
	"<input type='text' id='numericGradeTo_"+numberRowIdIndex+"' value='${institutionTranscriptKeyGradeNumber.gradeTo }' name='institutionTranscriptKeyGradeList["+numberRowIdIndex+"].gradeTo' " +
	" class='textField w40 required numericToClass number' /></td>      " +
	"  <td><input type='text' value='${institutionTranscriptKeyGradeNumber.shortDescription }' name='institutionTranscriptKeyGradeList["+numberRowIdIndex+"].shortDescription' " +
	"class='textField w90per' /></td>     " +
	"<td><input type='text' value=''${institutionTranscriptKeyGradeNumber.longDescription } name='institutionTranscriptKeyGradeList["+numberRowIdIndex+"].longDescription'" +
	" class='textField w90per longDescriptionNumeric' /></td>     <td id='removeRowTd_"+numberRowIdIndex+"'>" +
	"<input type='hidden' value='1'  name='institutionTranscriptKeyGradeList["+numberRowIdIndex+"].number'  /> 	   " +
	"<a href='javaScript:void(0);' id='removeRow_"+numberRowIdIndex+"' class='removeIcon fr removeRow'></a> </td>   </tr>";
	jQuery("#addGradeNumberTbl tr:last").after(appendText);
	settingMaskInput();
	numericOverlapValidate();
}


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


</script>
<c:set var="listCount" value="${fn:length(institutionTranscriptKey.institutionTranscriptKeyDetailsList)}"/>
  <c:set var="selectedInstitution"  value="${institution}" scope="request" />
 	<%@include file="../common/institutionInfo.jsp" %>

   <ul class="pageNav">
        
        <li><a href="${institutionDetail}" style="z-index:9;">Institution Details <span class="sucssesIcon"></span></a></li>
        <li><a href="${aBodyLink }" style="z-index:8;" >Accrediting Body  <c:choose> <c:when test="${fn:length(institution.accreditingBodyInstitutes)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise > <span class="alrtIcon"></span></c:otherwise></c:choose>  </a> </li>
        <li><a href="${termTypeLink }" style="z-index:7;" >Term Types <c:choose> <c:when test="${fn:length(institution.institutionTermTypes)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose></a> </li>
        <li><a href="${transcriptKeyLink }" style="z-index:6;" class="active">Transcript Key <c:choose> <c:when test="${fn:length(institution.institutionTranscriptKeys)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose></a> </li>
        <li><a href="${markCompleteLink }" class="last">Summary</a></li>
        
        </ul>
<form id="frmTranscriptKey" method="post" action="/scheduling_system/evaluation/ieManager.html?operation=saveInstitutionTranscriptKey&institutionId=${institutionId}">
        <div class="infoContnr"><div class="infoTopArow infoarow4"></div>
    	<div>
    		<div>
        	<div class="tabHeader">Course Level</div>
            <div><table  id="addTranscriptKeyTbl" width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl3 noti-bbn tabTBLborder contentForm">
  <tr>
    <th width="10%" scope="col" class="dividerGrey">From <span class="strColor">*</span></th>
    <th width="10%" scope="col" class="dividerGrey">To</th>
    <th width="60%" scope="col" class="dividerGrey" colspan="2">GCU Course Level<span class="strColor">*</span></th>
    </tr>

    <c:forEach items="${institutionTranscriptKey.institutionTranscriptKeyDetailsList}" var="institutionTranscriptKeyDetails" varStatus="status">
            
			<tr id="trAbRow_${status.index}">
                <td><Span><input  id="from_${status.index}" type="text"  name="institutionTranscriptKeyDetailsList[${status.index}].from" value="${institutionTranscriptKeyDetails.from}" class="txbx w80 required" /></span></td>
                <td><Span><input  id="to_${status.index}"type="text" name="institutionTranscriptKeyDetailsList[${status.index}].to" value="${institutionTranscriptKeyDetails.to}" class="txbx w80 " /></span></td>
                <td><span><select id="courseLevelId_${status.index}"  class=" w90per eventCaptureField required" name="institutionTranscriptKeyDetailsList[${status.index}].gcuCourseLevel.id" >
                    <option id="" value="">Select Course Level</option>
					<c:forEach items="${gcuCourseLevelList}" var="gcuCourseLevel">
						<option <c:if test="${institutionTranscriptKeyDetails.gcuCourseLevel.id == gcuCourseLevel.id}"> selected="true" </c:if> value="${gcuCourseLevel.id}">${gcuCourseLevel.name}</option>
					</c:forEach>	
                </select></span>
                
                </td>
                 
                <td id="removeRowTd_${status.index}">
	          	<a href="javaScript:void(0);" id="removeRow_${status.index}" name="removeRow_${status.index}" class="removeIcon fr removeRow"></a>
				</td>
            </tr>
			
            </c:forEach>
			 
			<c:if test="${listCount == 0 }">
	            <tr class="noBorder" id="trAbRow_${listCount}">
	                <td><Span><input  id="from_${listCount}" type="text"  name="institutionTranscriptKeyDetailsList[${listCount}].from" value="${institutionTranscriptKeyDetails.from}" class="txbx w80 required"  value="" /></span></td>
	                <td><Span><input  id="to_${listCount}"type="text" name="institutionTranscriptKeyDetailsList[${listCount}].to" value="${institutionTranscriptKeyDetails.to}" class="txbx w80  " value="" /></span></td>
	                <td><span><select  id="courseLevelId_${listCount}" class=" w90per eventCaptureField required" name="institutionTranscriptKeyDetailsList[${listCount}].gcuCourseLevel.id" >
	                    <option id="" value="">Select Course Level</option>
						<c:forEach items="${gcuCourseLevelList}" var="gcuCourseLevel">
							<option  value="${gcuCourseLevel.id}">${gcuCourseLevel.name}</option>
							
						</c:forEach>	
	                </select></span>
	               
	                </td>
	                <td id="removeRowTd_${listCount}">
	          	<a href="javaScript:void(0);" id="removeRow_${listCount}" name="removeRow_${listCount}" class="removeIcon fr removeRow"></a>
				</td>
	            </tr>
			</c:if> 
    
</table></div>
<div class="mt10" >
  	  <div class="fl institutionHeader">
      <a onclick="addTKrow();" href="javascript:void(0)"><img src="../images/termTypeIcon.png" alt="">Add New</a>
	   </div>
  	  <br class="clear">
        
    </div>
        </div>
        
        <div class="contentForm p0">
        	<div class="mt30">
        	<label class="noti-label">Grading System</label>
            <br class="clear" />

        	<div class="dateReceived">
            	
                <label class="noti-label w100 ">Effective Date:<span class="astric">*</span></label>
                <input type="text" id="effectiveDate" name="effectiveDate" 
                value='<fmt:formatDate value="${institutionTranscriptKey.effectiveDate}" pattern="MM/dd/yyyy"/>' class="textField w80px required maskDate date">
      			<input type="hidden"  name="id" value="${institutionTranscriptKey.id}" />    
      			<input name="createdBy"  type="hidden"	value="${institutionTranscriptKey.createdBy}" /> 
      			<input name="createdDate"	 type="hidden"	value='<fmt:formatDate value="${institutionTranscriptKey.createdDate}" pattern="MM/dd/yyyy"/>' /> 
            </div>
        	<div class="lastAttend">
            
            	<label class="noti-label w70">End Date:</label>
                    <input type="text" id="endDate" name="endDate"   value='<fmt:formatDate value="${institutionTranscriptKey.endDate}" pattern="MM/dd/yyyy"/>' class="textField w80px maskDate requiredDateRange">
            
            </div>
            <div class="clear"></div>
            <div class="clear"></div>   
            <br/>
            <ul id="addTopNav" class="floatLeft top-nav-tab ml20 mt25">
              <li><a class="on" id="tablink_1" href="javascript:void(0)"><span>Alphabetic</span></a></li>
              <li><a id="tablink_2" href="javascript:void(0)"><span>Numeric</span></a></li>
            </ul>         
            <div class="clear"></div>   
            <div id="addDyndivs" class="tabBorder contentForm mb20">
            
            	 <div id="inrContBox_1">
                 
               	   <div class="mt10">
        	<div class="tabHeader">Grade</div>
            <div>
 <table id="addGradeAlphaTbl" width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl3 noti-bbn tabTBLborder contentForm">
  <tr>
    <th width="18%" scope="col" class="dividerGrey">Grade<span class="strColor">*</span></th>
    <th width="39%" scope="col" class="dividerGrey">Short Description</th>
    <th width="39%" scope="col">Long Description</th>
    <th width="3%" scope="col">&nbsp;</th>
  </tr>
  <c:choose>
   <c:when test="${empty institutionTranscriptKey.institutionTranscriptKeyGradeAlphaList}">
  <tr id="trGradeAlphaRow_100" >
    <td><input type="text" value="" name="institutionTranscriptKeyGradeList[100].gradeAlpha" class="textField w90per required alphaClass" /></td>
    <td><input type="text" value="" name="institutionTranscriptKeyGradeList[100].shortDescription" class="textField w90per"></td>
    <td><input type="text" value="" name="institutionTranscriptKeyGradeList[100].longDescription" class="textField w90per longDescriptionAlpha"></td>
    <td><a href="#" class="removeIcon fr"></a></td>
    
  </tr>
  </c:when>
  <c:otherwise>
  <c:set var="index" scope="session" value="${100}"/>
  
   <c:forEach items="${institutionTranscriptKey.institutionTranscriptKeyGradeAlphaList}" var="institutionTranscriptKeyGradeAlpha" varStatus="loop">
  <tr id="trAbRow_${index}" >
    <td><input type="text" value="${institutionTranscriptKeyGradeAlpha.gradeAlpha }" name="institutionTranscriptKeyGradeList[${index }].gradeAlpha"  class="textField w90per required alphaClass" /></td>
    <td><input type="text" value="${institutionTranscriptKeyGradeAlpha.shortDescription }" name="institutionTranscriptKeyGradeList[${index }].shortDescription" class="textField w90per" /></td>
    <td><input type="text" value="${institutionTranscriptKeyGradeAlpha.longDescription }" name="institutionTranscriptKeyGradeList[${index }].longDescription" class="textField w90per longDescriptionAlpha" /></td>
    <td id="removeRowTd_${loop.index}">
    <input type="hidden" value='${institutionTranscriptKeyGradeAlpha.id}'  name="institutionTranscriptKeyGradeList[${index }].id"  />
    <input type="hidden" value='${institutionTranscriptKeyGradeAlpha.createdBy}'  name="institutionTranscriptKeyGradeList[${index }].createdBy"  />
    <input type="hidden" value='<fmt:formatDate value="${institutionTranscriptKeyGradeAlpha.createdDate}" pattern="MM/dd/yyyy"/>'  name="institutionTranscriptKeyGradeList[${index }].createdDate"  />
    
	          	<a href="javaScript:void(0);" id="removeRow_${index}" class="removeIcon fr removeRow"></a>
				</td>
  </tr>
  <c:set var="index" scope="session" value="${index+1}"/>
  </c:forEach>
  </c:otherwise>
  </c:choose>
            </table>
            </div>
<div class="mt10" >
  	  <div class="fl institutionHeader">
      <a onclick="addAlpharow()" href="javascript:void(0)"><img src="../images/termTypeIcon.png" alt="">Add New</a>
	   </div>
  	  <br class="clear">
        
    </div>
        </div>
                 
                 </div>
                 
                <div id="inrContBox_2" style="display:none;">
                 
               	  <div class="mt10">
        	<div class="tabHeader">Grade</div>
            <div>
 <table  id="addGradeNumberTbl" width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl3 noti-bbn tabTBLborder contentForm">
  <tr>
    <th width="18%" scope="col" class="dividerGrey">Grade<span class="strColor">*</span></th>
    <th width="39%" scope="col" class="dividerGrey">Short Description</th>
    <th width="39%" scope="col">Long Description</th>
    <th width="3%" scope="col">&nbsp;</th>
  </tr>
  <c:choose>
   <c:when test="${empty institutionTranscriptKey.institutionTranscriptKeyGradeNumberList}">
  
  <tr id="trGrdNumberRow_0">
     <td><input type="text" id="numericGradeFrom_0"  name="institutionTranscriptKeyGradeList[0].gradeFrom" class="textField w40 required numericFromClass number" /> 
     <div class="fl mr10 ml10 mt5"><strong>To</strong> &nbsp;&nbsp;</div>
        <input type="text" id="numericGradeTo_0" name="institutionTranscriptKeyGradeList[0].gradeTo"  class="textField w40 required numericToClass number" /></td>
     
    <td><input type="text"  name="institutionTranscriptKeyGradeList[0].shortDescription" class="textField w90per" /></td>
    <td><input type="text"  name="institutionTranscriptKeyGradeList[0].longDescription"  class="textField w90per longDescriptionNumeric" /></td>
   <td><input type="hidden" value='1'  name="institutionTranscriptKeyGradeList[0].number"  /><a href="#" class="removeIcon fr"></a></td>
  </tr>
  </c:when>
  <c:otherwise>
 
  
   <c:forEach items="${institutionTranscriptKey.institutionTranscriptKeyGradeNumberList}" var="institutionTranscriptKeyGradeNumber" varStatus="loop">
  
  <tr  id="trGrdNumberRow_${loop.index}">
    <td><input type="text" id="numericGradeFrom_${loop.index}" value="${institutionTranscriptKeyGradeNumber.gradeFrom }" name="institutionTranscriptKeyGradeList[${loop.index }].gradeFrom" class="textField w40 required numericFromClass number" /> 
     <div class="fl mr10 ml10 mt5"> <strong>To</strong> &nbsp;&nbsp;</div>
        <input type="text" id="numericGradeTo_${loop.index}" value="${institutionTranscriptKeyGradeNumber.gradeTo }" name="institutionTranscriptKeyGradeList[${loop.index }].gradeTo"  class="textField w40 required numericToClass number" /></td>
      
    <td><input type="text" value="${institutionTranscriptKeyGradeNumber.shortDescription }" name="institutionTranscriptKeyGradeList[${loop.index }].shortDescription" class="textField w90per" /></td>
    <td><input type="text" value="${institutionTranscriptKeyGradeNumber.longDescription }" name="institutionTranscriptKeyGradeList[${loop.index }].longDescription" class="textField w90per longDescriptionNumeric" /></td>
    <td id="removeRowTd_${loop.index}">
    <input type="hidden" value='1'  name="institutionTranscriptKeyGradeList[${loop.index }].number"  />
    <input type="hidden" value='${institutionTranscriptKeyGradeNumber.id}'  name="institutionTranscriptKeyGradeList[${loop.index }].id"  />
    <input type="hidden" value='${institutionTranscriptKeyGradeNumber.createdBy}'  name="institutionTranscriptKeyGradeList[${loop.index }].createdBy"  />
    <input type="hidden" value='<fmt:formatDate value="${institutionTranscriptKeyGradeNumber.createdDate}" pattern="MM/dd/yyyy"/>'  name="institutionTranscriptKeyGradeList[${loop.index }].createdDate"  />
	          	<a href="javaScript:void(0);" id="removeRow_${loop.index}" class="removeIcon fr removeRow"></a>
				</td>
  </tr>
  </c:forEach>
  </c:otherwise>
  </c:choose>
            </table>
            </div>
<div class="mt10" >
  	  <div class="fl institutionHeader">
      <a onclick="addNumericrow()" href="javascript:void(0)"><img src="../images/termTypeIcon.png" alt="">Add New</a>
	   </div>
  	  <br class="clear">
        
    </div>
        </div>
                 
                </div>
            
            </div>
        
        </div>        
        
        
        </div>
        	
            
        
        
        
        
        </div>
        <div class="divider3 mt10"></div>
    	  <div class="fr mt10">
    	    	
    	      <c:choose>
        		<c:when test="${userRoleName eq 'Institution Evaluation Manager' || userRoleName eq 'Administrator'}">
        			<input type="submit" name="saveInstitution" value="Save" id="saveInstitution" class="button">
    	     		<input type="submit" name="saveInstitution" value="Save & Next" id="saveInstitution" class="button">
        		</c:when>
        		<c:when test="${institution.evaluationStatus eq 'NOT EVALUATED' && userRoleName eq 'Institution Evaluator' && ((!empty institution.checkedBy && institution.checkedBy eq userCurrentId) || (!empty institution.confirmedBy && institution.confirmedBy eq userCurrentId))}">
        			<input type="submit" name="saveInstitution" value="Save" id="saveInstitution" class="button">
    	     		<input type="submit" name="saveInstitution" value="Save & Next" id="saveInstitution" class="button">
        		</c:when>
        		<c:when test="${empty institution.evaluationStatus}">
        			<input type="submit" name="saveInstitution" value="Save" id="saveInstitution" class="button">
    	     		<input type="submit" name="saveInstitution" value="Save & Next" id="saveInstitution" class="button">
        		</c:when>
        		<c:otherwise>
        		
        		</c:otherwise>
        	
        	</c:choose>
    	  </div>
        <div class="clear"></div>
        </div>
        
 </form>       
    
    















<%--  <script type="text/javascript" src="<c:url value="/js/evaluationHome.js"/>"></script> 
 <script>
 var optionString='';
 function addInstitutionTranscriptKey(institutionTranscriptKeyId) {
	 var url;
	 if('${role}'=='MANAGER'){
		 if(institutionTranscriptKeyId=="0"){
			 url="<c:url value='/evaluation/ieManager.html?operation=addInstitutionTranscriptKey&institutionId=${institutionId}'/>";
		 }else{
			 url="<c:url value='/evaluation/ieManager.html?operation=addInstitutionTranscriptKey&institutionId=${institutionId}&institutionTranscriptKeyId="+institutionTranscriptKeyId+"'/>";
		}
	}else{
		 if(institutionTranscriptKeyId=="0"){
			 url="<c:url value='/evaluation/quality.html?operation=addInstitutionTranscriptKey&institutionMirrorId=${institutionMirrorId}'/>";
		 }else{
			 url="<c:url value='/evaluation/quality.html?operation=addInstitutionTranscriptKey&institutionMirrorId=${institutionMirrorId}&institutionTranscriptKeyId="+institutionTranscriptKeyId+"'/>";
		}
	}
		
		Boxy.load(url,
			{ unloadOnHide : true, 
			afterShow : function() {
		
				var placeholder = "@placeholder@";
				var appendInsText = 
					"<tr><th><input id='from_"+placeholder+"' name='institutionTranscriptKeyDetailsList["+placeholder+"].from' type='text' class='txbx w60 required'/></th>"
				    +
				    "<th><input name='institutionTranscriptKeyDetailsList["+placeholder+"].to' id='to_"+placeholder+"' type='text' class='txbx w60 required'/></th>"
				    +
				    "<th><select id='courseLevelId_"+placeholder+"' name='institutionTranscriptKeyDetailsList["+placeholder+"].gcuCourseLevel.id' class=' eventCaptureField' > <option id='' value=''>Select Course Level</option>"+optionString+"</select>"
				    +" <input type='hidden' id='courseLevelName_"+placeholder+"' name='institutionTranscriptKeyDetailsList["+placeholder+"].gcuCourseLevel.name' /> </th>"
				    +
					"<th id='removeRowTd_"+placeholder+"'>"
					+"<a onclick='addInstitutionTranscriptKeyRow("+placeholder+");' class='addRow' name='addRow_"+placeholder+"' id='addRow_"+placeholder+"' href='javascript:void(0)'><img width='15' height='14' src='../images/addCourse.png' alt='add'> Add New</a><br/><a href='#'  id='removeRow_"+placeholder+"' name='removeRow_"+placeholder+"' class='removeInstitutionRow removeRow'><img width='15' height='15' src='../images/removeIcon.png' alt='Delete'>Remove</a></th></tr>";
					//addInstitutionTranscriptKeyRow(placeholder);
				//addDynamicRows( 'eventCaptureField', 'blur', 'addTranscriptKeyTbl', 'removeRowTd_', appendInsText, placeholder );

				//Remove rows when Remove link is clicked.
				jQuery(".removeInstitutionRow").live('click', function(event) {
					//remove the current row
					jQuery(this).parent().parent().remove();

					//set the remove link for the previous row in the table unless it is the first row.
					var noOfRows = jQuery("#addTranscriptKeyTbl").attr('rows').length;
					rowIndex = noOfRows - 2;
					if( rowIndex == -1 ) {
						rowIndex = 0;
					}
					if( rowIndex > 0 ) {
						jQuery("#removeRowTd_"+(rowIndex)).html( "<a onclick='addInstitutionTranscriptKeyRow("+rowIndex+");' class='addRow' name='addRow_"+rowIndex+"' id='addRow_"+rowIndex+"' href='javascript:void(0)'><img width='15' height='14' src='../images/addCourse.png' alt='add'> Add New</a><br/><a href='#' id='removeRow_"+rowIndex+"' name='removeRow_"+rowIndex+"' class='removeInstitutionRow removeRow'><img width='15' height='15' src='../images/removeIcon.png' alt='Delete'>Remove</a>" );
					}else if(rowIndex == 0){
						jQuery("#removeRowTd_"+(rowIndex)).html( "<a onclick='addInstitutionTranscriptKeyRow("+rowIndex+");' class='addRow' name='addRow_"+rowIndex+"' id='addRow_"+rowIndex+"' href='javascript:void(0)'><img width='15' height='14' src='../images/addCourse.png' alt='add'> Add New</a>" );
					}
				} );
			
				jQuery("#frmTranscriptKey").validate({
					 submitHandler: function(form) {
					   form.submit();
					 }
				});
				settingMaskInput();
				jQuery("[id^='courseLevelId_']").live("change",function(){
					var thisNo=jQuery(this).attr('id').split('_')[1];
					jQuery("#courseLevelName_"+thisNo).val(jQuery("#courseLevelId_"+thisNo+" option:selected").text());
				});
				
				jQuery.validator.addMethod("dateRange", function() {
					if(jQuery("#endDate").val()!=''&& isDate(jQuery("#endDate").val())){
	 					return new Date(jQuery("#effectiveDate").val()) < new Date(jQuery("#endDate").val());
					}else{
	 					return true;
	 				}
	 			}, "End date should be greater than the effective date.");
	 			
	 			jQuery.validator.addClassRules({
	 				requiredDateRange: { dateRange:true}
	 			});
	 			
				jQuery("#frmTranscriptKey").validate();
			}
			});
	}
 jQuery(document).ready(function(){
		jQuery("[name='effective']").change(function(){
			if('${role}'=='MANAGER'){
				window.location.href='ieManager.html?operation=effectiveTranscriptKey&institutionId=${institutionId}&transcriptKeyId='+jQuery(this).val();
			}else{
				window.location.href='quality.html?operation=effectiveTranscriptKey&institutionMirrorId=${institutionMirrorId}&transcriptKeyId='+jQuery(this).val();
			}
			
		})	;
		
	});
 </script>

<c:choose>
     	<c:when test="${role=='MANAGER'}"> 
        	<c:set var="backLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=ieInstitution&institutionId=${institutionId}"/>
 	 	</c:when>
 	 	<c:when test="${role=='ADMIN'}"> 
        	<c:set var="backLink" scope="session" value="/scheduling_system/evaluation/admin.html?operation=viewInstitutionDetails&institutionId=${institutionId}"/>
 	 	</c:when>
 		<c:otherwise>
 			<c:set var="backLink" scope="session" value="/scheduling_system/evaluation/quality.html?operation=ieInstitution&institutionId=${institutionId}"/>
 	 	</c:otherwise>
 	</c:choose>

   <ul class="pageNav">
        
        <li><a href="${institutionDetail}" style="z-index:9;">Institution Details <span class="sucssesIcon"></span></a></li>
        <li><a href="${aBodyLink }" style="z-index:8;" >Accrediting Body  <c:choose> <c:when test="${fn:length(institution.accreditingBodyInstitutes)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise > <span class="alrtIcon"></span></c:otherwise></c:choose>  </a> </li>
        <li><a href="${termTypeLink }" style="z-index:7;" >Term Types <c:choose> <c:when test="${fn:length(institution.institutionTermTypes)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose></a> </li>
        <li><a href="${transcriptKeyLink }" style="z-index:6;" class="active">Transcript Key <c:choose> <c:when test="${fn:length(institution.institutionTranscriptKeys)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose></a> </li>
        <li><a href="${aAgreementLink }" style="z-index:5;" >Articulation Agreement <c:choose> <c:when test="${fn:length(institution.articulationAgreements)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose>  </a> </li>
        <li><a href="${markCompleteLink }" class="last">Summary</a></li>
        
        </ul>
    	<div class="infoContnr"><div class="infoTopArow infoarow4"></div>
    	<div class="fr institutionHeader">
       		<a href="javascript:void(0)" onclick='addInstitutionTranscriptKey("0")'><img alt="" src="../images/termTypeIcon.png">Add Transcript Key</a>
        </div><br class="clear">
        
<c:choose>
        <c:when test="${fn:length(institutionTranscriptKeyList)>0}">
	<table width="100%" cellspacing="0" cellpadding="0" border="0" class="noti-tbl">
       <tbody>
       <tr>
			<th width="60%" class="dividerGrey">
				<table width="100%" cellspacing="0" cellpadding="0" border="0">
					<tr>
						<th colspan="3" align="center"><span>Transfer Institute Course Numbering</span></th>
					</tr>
					<tr>
						<th width="33%"><span>From</span></th>
						<th width="33%" class="dividerGrey"><span>To</span></th>
						<th width="33%" class="dividerGrey"><span>GCU Course Level</span></th>
					</tr>
				</table>
			</th>
			<th width="15%" class="dividerGrey"><span>Effective Date</span></th>
			<th width="15%" class="dividerGrey"><span>End Date</span></th>
			<th width="10%" class="dividerGrey">Effective</th>
			<th width="10%" class="dividerGrey"><span>Action</span></th>
		</tr>
		 <c:forEach items="${institutionTranscriptKeyList}" var="institutionTranscriptKey" varStatus="index">
		<tr>
			<td>
				<table width="100%" cellspacing="0" cellpadding="0" border="0">
				<c:forEach items="${institutionTranscriptKey.institutionTranscriptKeyDetailsList}" var="institutionTranscriptKeyDetails" varStatus="index2">
					<tr>
						<td width="33%"><span>${institutionTranscriptKeyDetails.from}</span></td>
						<td width="33%"><span>${institutionTranscriptKeyDetails.to}</span></td>
						<td width="33%"><span>${institutionTranscriptKeyDetails.gcuCourseLevel.name}</span></td>
					</tr>
				</c:forEach>
				</table>
			</td>
			<td><span><fmt:formatDate value="${institutionTranscriptKey.effectiveDate}" pattern="MM/dd/yyyy"/></span></td>
			<td><span><fmt:formatDate value="${institutionTranscriptKey.endDate}" pattern="MM/dd/yyyy"/></span></td>
			<td><span>
			 <c:choose>
     	<c:when test="${role != 'ADMIN'}"> 
	         <input type="radio" name="effective" value="${institutionTranscriptKey.id}"  
	         <c:if test="${institutionTranscriptKey.effective == 'true'}"> checked='checked'</c:if>/>
         </c:when>
         <c:otherwise>${institutionTranscriptKey.effective}</c:otherwise>
       </c:choose>
			
         
         </span></td>
			<td><span><c:if test="${role != 'ADMIN'}"><a onclick='addInstitutionTranscriptKey("${institutionTranscriptKey.id}")'   href="#">Edit</a></c:if></span></td>
		</tr>
		</c:forEach>
		    
       </tbody>
     </table>
</c:when>
 		<c:otherwise> <div class="notifyMsg">No Records Found </div>
 		</c:otherwise>
 		</c:choose>
</div>	

 --%> 
