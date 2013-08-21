 <%@include file="../init.jsp" %>
 <script type='text/javascript' src="<c:url value='/js/expand.js'/>"></script>
 <script>
 var optionString ="";
 window.onload = (function () {	


jQuery(document).ready(function(){
	jQuery("h1.expand").toggler(); 
    jQuery("#divContBoxLft").expandAll({trigger: "h1.expand"});
	 jQuery("#divContBoxRgt").expandAll({trigger: "h1.expand"});
	
	 jQuery('.collapse:first').hide();
	 jQuery('h1.expand:first a:first').addClass("close");
	
	<c:forEach items="${termTypeList}" var="termType">
	
	 		 optionString = optionString+ '<option  value="${termType.id}">${termType.name}</option>';
	
		</c:forEach>
		
		jQuery(".removeRow").live('click', function(event) {
			jQuery(this).parent().parent().remove();
		});
		
		jQuery("[name='effective']").live('change', function(event) {
			jQuery("[id^='effectiveValue_']").val('0');
			var idEffective=jQuery(this).attr("id").split("_")[1];
			if (jQuery(this).is(':checked')) {
				jQuery("#effectiveValue_"+idEffective).val('1');
			}else{
				jQuery("#effectiveValue_"+idEffective).val('0');
			}
		
			
		});
		jQuery("#frmtermType").validate();
		dateOverlapValidate();
});
 });
 
 
 
 function dateOverlapValidate(){
		jQuery.validator.addMethod("dateRange", function() {
			var numberRowIdIndex;
			try{
				numberRowIdIndex = parseInt(jQuery("#addTermTypeTbl tr:last").attr("id").split("_")[1])+1;
			}catch(err){
				numberRowIdIndex=0;
			}
			var i=0;
			for( i=0;i<=numberRowIdIndex;i++){
				var effectiveDate1=new Date(jQuery("#effectiveDate_"+i).val());
				var endDate1=new Date(jQuery("#endDate_"+i).val());
				
				
				if(jQuery("#endDate_"+i).val()!="" ){
						if(  new Date(jQuery("#effectiveDate_"+i).val()) > new Date(jQuery("#endDate_"+i).val())){
							return false
						}
				}
				var indexAhead=i+1
					var effectiveDate2=new Date(jQuery("#effectiveDate_"+indexAhead).val());
					var endDate2=new Date(jQuery("#endDate_"+indexAhead).val());
					
				if(numberRowIdIndex>1&& effectiveDate2!==undefined && endDate2!==undefined){
						if((effectiveDate1 <= endDate2) && (effectiveDate2 <= endDate1)){	
							return false
						}
				}
				
			}
			return true;
			}, "Dates must not overlap. Please correct the date before saving.");
			
			jQuery.validator.addClassRules({
				endDateClass: {dateRange:true}
			});

	}
function addABrow(){
	
	var abRowIdIndex ;
	try{
		abRowIdIndex = parseInt(jQuery("#addTermTypeTbl tr:last").attr("id").split("_")[1])+1;
	}catch(err){
		abRowIdIndex=0;
	}
	var appendText = "<tr class='infoBottomBrNon' id='trAbRow_"+abRowIdIndex+"'>   " +
	"<td><select class='w90per required ' id='termType_"+abRowIdIndex+"' name='institutionTermTypes["+abRowIdIndex+"].termType.id'>  " +
	"<option  value=''>Select Term Type</option> 	" +	optionString+"  </select></td>    " +
	"<td><input type='text' id='effectiveDate_"+abRowIdIndex+"'  name='institutionTermTypes["+abRowIdIndex+"].effectiveDate' value='' class='textField w80px maskDate required' /></td>  " +
	" <td><input type='text' id='endDate_"+abRowIdIndex+"' name='institutionTermTypes["+abRowIdIndex+"].endDate' value='' class='textField w80px maskDate endDateClass' />"+
	"<input type='hidden' name='institutionTermTypes["+abRowIdIndex+"].instituteId' value='${institution.id}'/> </td>     " +
	"<td> <input type='radio' id ='effective_"+abRowIdIndex+"'name='effective' /> "+
	"<input type='hidden' id='effectiveValue_"+abRowIdIndex+"' name='institutionTermTypes["+abRowIdIndex+"].effective' value='0'/></td>"+
	"<td id='removeRowTd_"+abRowIdIndex+"' valign='middle'><a href='#' class='removeIcon fr removeRow'></a></td></tr>";
	jQuery("#addTermTypeTbl tr:last").after(appendText);
	settingMaskInput();
	dateOverlapValidate();
}
</script>

  <c:set var="selectedInstitution"  value="${institution}" scope="request" />
 	<%@include file="../common/institutionInfo.jsp" %>
 <ul class="pageNav">
        
        <li><a href="${institutionDetail}" style="z-index:9;">Institution Details <span class="sucssesIcon"></span></a></li>
        <li><a href="${aBodyLink }" style="z-index:8;" >Accrediting Body  <c:choose> <c:when test="${fn:length(institution.accreditingBodyInstitutes)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose>  </a> </li>
        <li><a href="${termTypeLink }" style="z-index:7;" class="active">Term Types <c:choose> <c:when test="${fn:length(institution.institutionTermTypes)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose></a> </li>
        <li><a href="${transcriptKeyLink }" style="z-index:6;">Transcript Key <c:choose> <c:when test="${fn:length(institution.institutionTranscriptKeys)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose></a> </li>
        <li><a href="${markCompleteLink }" class="last">Summary</a></li>
        
        </ul>
<form id="frmtermType" method="post" action="/scheduling_system/evaluation/ieManager.html?operation=saveInstitutionTermType&institutionId=${institutionId}">
	<div class="infoContnr"><div class="infoTopArow infoarow3"></div>
    	  <div style="border:1px solid #e7e7e7;" class="institute ">
  	

    <table width="100%" id="addTermTypeTbl" cellspacing="0" cellpadding="0" border="0" class="noti-tbl3 contentForm">
       <tbody>
       <tr>
         <th width="67%" scope="col" class="dividerGrey"> Term Type <span class="strColor">*</span></th>
         <th width="10%" class="dividerGrey" scope="col">Effective Date <span class="strColor">*</span></th>
         <th width="10%" class="dividerGrey" scope="col">End Date</th>
         <th width="10%"  scope="col">Effective</th>
         <th width="3%" class="" scope="col">&nbsp;</th>
       </tr>
      <c:choose>
	  <c:when test="${empty institutionTermTypeList}">
		  					 
       <tr class="infoBottomBrNon" id="trAbRow_0">
         <td><select class=" required " id="termType_0" style='width:88%' name="institutionTermTypes[0].termType.id">
            <option  value="">Select Term Type</option>
			<c:forEach items="${termTypeList}" var="termType">
				<option value="${termType.id}">${termType.name}</option>
			</c:forEach>
         </select></td>
         <td><input type="text" value="" id='effectiveDate_0' name="institutionTermTypes[0].effectiveDate" class="textField w80px maskDate required" /></td>
         <td><input type="text" value="" id='endDate_0' name="institutionTermTypes[0].endDate" class="textField w80px maskDate endDateClass" />
         <input type="hidden" name="institutionTermTypes[0].instituteId" value="${institution.id}"/></td>
         <td> <input type="radio" id ="effective_0"name="effective" checked="checked" />
	         <input type="hidden" id="effectiveValue_0" name="institutionTermTypes[0].effective" value="1"/></td>
         
         <td valign="middle"><a href="#" class="removeIcon fr"></a></td>
       </tr>
        </c:when>
        <c:otherwise>
        <c:forEach items="${institutionTermTypeList}" var="termTypeInstitute" varStatus="loop">
	        <tr class="infoBottomBrNon" id="trAbRow_${loop.index}">
	         <td><select class="w90per required " id="termType_${loop.index}" name="institutionTermTypes[${loop.index }].termType.id">
	           <option  value="">Select Term Type</option>
			<c:forEach items="${termTypeList}" var="termType">
				<option <c:if test="${termTypeInstitute.termType.id == termType.id}"> selected="true" </c:if> value="${termType.id}">${termType.name}</option>
			</c:forEach>			 
	         </select></td>
	         <td><input type="text" id='effectiveDate_${loop.index }' name="institutionTermTypes[${loop.index }].effectiveDate" value='<fmt:formatDate value="${termTypeInstitute.effectiveDate}" pattern="MM/dd/yyyy"/>' class="textField w80px maskDate required" /></td>
	         <td><input type="text"  id='endDate_${loop.index }' name="institutionTermTypes[${loop.index }].endDate" value='<fmt:formatDate value="${termTypeInstitute.endDate}" pattern="MM/dd/yyyy"/>' class="textField w80px maskDate endDateClass" />
	         <input type="hidden" name="institutionTermTypes[${loop.index}].instituteId" value="${institution.id}"/></td>
	         <td> <input type="radio" id ="effective_${loop.index}"name="effective" value="${termTypeInstitute.id}"<c:if test="${termTypeInstitute.effective == 'true'}"> checked='checked'</c:if>/>
	         <input type="hidden" id="effectiveValue_${loop.index}" name="institutionTermTypes[${loop.index}].effective" value="${termTypeInstitute.effective}"/></td>
	          <td id="removeRowTd_${loop.index}">
	          	<a href="javaScript:void(0);" id="removeRow_${loop.index}" name="removeRow_${loop.index}" class="removeIcon fr removeRow"></a>
				</td>
	       </tr>
       
        </c:forEach>
        </c:otherwise>
        </c:choose>
       </tbody>
     </table>
    </div>
    <div class="mt10" >
  	  <div class="fl institutionHeader">
      <a onclick="addABrow();" href="javascript:void(0)"><img src="../images/termTypeIcon.png" alt="">Add New</a>
	   </div>
  	  <br class="clear">
        
    </div>
    <div class="divider3 mt10"></div>
        <div class="fr mt10">
	        <input name="id" id="institutionId"	type="hidden" value="${institution.id}" /> 
	       
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
    </div>
  </div>
    
 
<%--  <script >
function addTermType(institutionTermTypeId) {
		
		 var url;
		 if('${role}'=='MANAGER'){
			 if(institutionTermTypeId=="0"){
				 url="<c:url value='/evaluation/ieManager.html?operation=addInstitutionTermType&institutionId=${institutionId}'/>";
			 }else{
				 url="<c:url value='/evaluation/ieManager.html?operation=addInstitutionTermType&institutionId=${institutionId}&institutionTermTypeId="+institutionTermTypeId+"'/>";
			}
		}else{
			 if(institutionTermTypeId=="0"){
				 url="<c:url value='/evaluation/quality.html?operation=addInstitutionTermType&institutionMirrorId=${institutionMirrorId}'/>";
			 }else{
				 url="<c:url value='/evaluation/quality.html?operation=addInstitutionTermType&institutionMirrorId=${institutionMirrorId}&institutionTermTypeId="+institutionTermTypeId+"'/>";
			}
		}
		
		Boxy.load(url,
		{ unloadOnHide : true	,
 		afterShow : function() {
 			
 			settingMaskInput();
 			jQuery("#selTermType").change(function(){
				jQuery("#termTypeName").val('');
				jQuery("#termTypeName ").val(jQuery("#selTermType option:selected").text());
			});
 			
 			jQuery.validator.addMethod("dateRange", function() {
 				if(jQuery("#endDate").val()!='' && isDate(jQuery("#endDate").val())){
 					
 					return new Date(jQuery("#effectiveDate").val()) < new Date(jQuery("#endDate").val());
 				}else{
 					return true;
 				}
 			}, "End date should be greater than the effective date.");
 			
 			jQuery.validator.addClassRules({
 				requiredDateRange: {   dateRange:true}
 			});
 			
 			jQuery("#frmTermType").validate();
		}
		});
	}
	jQuery(document).ready(function(){
		jQuery("[name='effective']").change(function(){
			if('${role}'=='MANAGER'){
				window.location.href='ieManager.html?operation=effectiveTermType&institutionId=${institutionId}&termTypeId='+jQuery(this).val();
			}else{
				window.location.href='quality.html?operation=effectiveTermType&institutionMirrorId=${institutionMirrorId}&termTypeId='+jQuery(this).val();
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
        <li><a href="${aBodyLink }" style="z-index:8;" >Accrediting Body  <c:choose> <c:when test="${fn:length(institution.institutionTermTypes)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise > <span class="alrtIcon"></span></c:otherwise></c:choose>  </a> </li>
        <li><a href="${termTypeLink }" style="z-index:7;" class="active">Term Types <c:choose> <c:when test="${fn:length(institution.institutionTermTypes)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose> </a> </li>
        <li><a href="${transcriptKeyLink }" style="z-index:6;">Transcript Key <c:choose> <c:when test="${fn:length(institution.institutionTranscriptKeys)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose></a> </li>
        <li><a href="${aAgreementLink }" style="z-index:5;" >Articulation Agreement<c:choose> <c:when test="${fn:length(institution.articulationAgreements)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose>  </a> </li>
        <li><a href="${markCompleteLink }" class="last">Summary</a></li>
        
        </ul>
    	<div class="infoContnr"><div class="infoTopArow infoarow3"></div>	
    	<div class="fr institutionHeader">
       		<a href="javascript:void(0)" onclick='addTermType("0")'><img alt="" src="../images/termTypeIcon.png">Add Term Type</a>
        </div><br class="clear">
        

<c:choose>
        <c:when test="${fn:length(institutionTermTypeList)>0}">
	<table width="100%" cellspacing="0" cellpadding="0" border="0" class="noti-tbl">
       <tbody>
       <tr>
         <th width="46%" scope="col"> Term Type</th>
         <th width="18%" scope="col" class="dividerGrey">Effective Date</th>
         <th width="18%" scope="col" class="dividerGrey">End Date</th>
         <th width="18%" scope="col" class="dividerGrey">Effective</th>
         <th width="18%" scope="col" class="dividerGrey">Action</th>
       </tr>
        <c:forEach items="${institutionTermTypeList}" var="institutionTermType" varStatus="index">
       <tr>
         <td><span>${institutionTermType.termType.name}</span></td>
         <td><span><fmt:formatDate value="${institutionTermType.effectiveDate}" pattern="MM/dd/yyyy"/></span></td>
         <td><span><fmt:formatDate value="${institutionTermType.endDate}" pattern="MM/dd/yyyy"/></span></td>
         <td><span>
	       <c:choose>
	     	<c:when test="${role != 'ADMIN'}"> 
		         <input type="radio" name="effective" value="${institutionTermType.id}"  
		         <c:if test="${institutionTermType.effective == 'true'}"> checked='checked'</c:if>/>
	         </c:when>
	         <c:otherwise>${institutionTermType.effective}</c:otherwise>
	       </c:choose>
         </span></td>
         <td><span>
         <c:if test="${role != 'ADMIN'}">
         	 <a onclick='addTermType("${institutionTermType.id}")'   href="#">
         	<img src="../images/editIcon.png" width="14" height="14" alt="Edit" />Edit</a> 
            </c:if>
           </span> 
         </td>
         </tr>
        </c:forEach>
       </tbody>
     </table>
 	</c:when>
 		<c:otherwise> <div class="notifyMsg">No Records Found </div>
 		</c:otherwise>
 		</c:choose>
 </div>	 --%>
