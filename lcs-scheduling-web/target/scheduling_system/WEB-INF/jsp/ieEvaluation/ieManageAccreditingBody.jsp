<%@include file="../init.jsp" %>
<script type="text/javascript" src="<c:url value="/js/evaluationHome.js"/>"></script> 
<script type='text/javascript' src="<c:url value='/js/expand.js'/>"></script>
<script>
var optionString ="";
window.onload = (function () {	

jQuery(document).ready(function(){
	 optionString='<optgroup label="Regional ">'+
		'<c:forEach items="${accreditingBodyList}" var="accreditingBody">'+
		'<c:if test="${accreditingBody.regional eq true}">'+
		'<option value="${accreditingBody.id}">${accreditingBody.name}</option>'+
		'</c:if>'+
		'</c:forEach></optgroup>'+
		    '<optgroup label="National ">'+
			'<c:forEach items="${accreditingBodyList}" var="accreditingBody">'+
		'<c:if test="${accreditingBody.regional eq false}">'+
		'<option value="${accreditingBody.id}">${accreditingBody.name}</option>'+
		'</c:if>'+
		'</c:forEach></optgroup>';
		
		jQuery(".removeRow").live('click', function(event) {
			jQuery(this).parent().parent().remove();
		});
		jQuery("#frmAccreditingBody").validate();
		 jQuery("h1.expand").toggler(); 
	     jQuery("#divContBoxLft").expandAll({trigger: "h1.expand"});
		 jQuery("#divContBoxRgt").expandAll({trigger: "h1.expand"});
		
		 jQuery('.collapse:first').hide();
		 jQuery('h1.expand:first a:first').addClass("close");
			
	
		
});
});
function addABrow(){
	
	var abRowIdIndex;
	try{
		abRowIdIndex = parseInt(jQuery("#addAccreditingTbl tr:last").attr("id").split("_")[1])+1;
	}catch(err){
		abRowIdIndex=0;
	}
	var appendText = "<tr class='infoBottomBrNon' id='trAbRow_"+abRowIdIndex+"'>   " +
	"<td><select class='w90per required ' id='accreditingBody_"+abRowIdIndex+"' name='accreditingBodyInstitutes["+abRowIdIndex+"].accreditingBody.id'>  " +
	"<option  value=''>Select the Accrediting Body</option> 	" +	optionString+"  </select></td>    " +
	"<td><input type='text'  name='accreditingBodyInstitutes["+abRowIdIndex+"].effectiveDate' value='' class='textField w80px maskYear required' /></td>  " +
	" <td><input type='text' name='accreditingBodyInstitutes["+abRowIdIndex+"].endDate' value='' class='textField w80px maskYear' />"+
	"<input type='hidden' name='accreditingBodyInstitutes["+abRowIdIndex+"].instituteId' value='${institution.id}'/> </td>     " +
	"<td id='removeRowTd_"+abRowIdIndex+"' valign='middle'><a href='#' class='removeIcon fr removeRow'></a></td></tr>";
	jQuery("#addAccreditingTbl tr:last").after(appendText);
	settingMaskInput();
}
</script>
  <c:set var="selectedInstitution"  value="${institution}" scope="request" />
 	<%@include file="../common/institutionInfo.jsp" %>
 <ul class="pageNav">
        
        <li><a href="${institutionDetail}" style="z-index:9;">Institution Details <span class="sucssesIcon"></span></a></li>
        <li><a href="${aBodyLink }" style="z-index:8;" class="active">Accrediting Body  <c:choose> <c:when test="${fn:length(institution.accreditingBodyInstitutes)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose>  </a> </li>
        <li><a href="${termTypeLink }" style="z-index:7;">Term Types <c:choose> <c:when test="${fn:length(institution.institutionTermTypes)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose></a> </li>
        <li><a href="${transcriptKeyLink }" style="z-index:6;">Transcript Key <c:choose> <c:when test="${fn:length(institution.institutionTranscriptKeys)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose></a> </li>
        <li><a href="${markCompleteLink }" class="last">Summary</a></li>
        
        </ul>
      
<form id="frmAccreditingBody" method="post" action="/scheduling_system/evaluation/ieManager.html?operation=saveAccreditingBody&institutionId=${institutionId}">
	<div class="infoContnr"><div class="infoTopArow infoarow2"></div>
    	  <div style="border:1px solid #e7e7e7;" class="institute ">
  	
    <table width="100%" id="addAccreditingTbl" cellspacing="0" cellpadding="0" border="0" class="noti-tbl3 contentForm">
       <tbody>
       <tr>
         <th width="70%" scope="col" class="dividerGrey"> Accrediting Body <span class="strColor">*</span></th>
         <th width="12%" class="dividerGrey" scope="col">Effective Year<span class="strColor">*</span></th>
         <th width="12%" scope="col">End Year</th>
         <th width="3%" class="" scope="col">&nbsp;</th>
       </tr>
      <c:choose>
	  <c:when test="${empty accreditingBodyInstituteList}">
		  					 
       <tr class="infoBottomBrNon" id="trAbRow_0">
         <td><select class="w90per required " id="accreditingBody_0" name="accreditingBodyInstitutes[0].accreditingBody.id">
            <option  value="">Select the Accrediting Body</option>
			 <optgroup label="Regional ">
			<c:forEach items="${accreditingBodyList}" var="accreditingBody">
			<c:if test="${accreditingBody.regional eq true}">
			<option value="${accreditingBody.id}">${accreditingBody.name}</option>
			</c:if>
			</c:forEach></optgroup>
			    <optgroup label="National ">
				<c:forEach items="${accreditingBodyList}" var="accreditingBody">
			<c:if test="${accreditingBody.regional eq false}">
			<option value="${accreditingBody.id}">${accreditingBody.name}</option>
			</c:if>
			</c:forEach></optgroup>
         </select></td>
         <td><input type="text" value="" name="accreditingBodyInstitutes[0].effectiveDate" class="textField w80px maskYear required" /></td>
         <td><input type="text" value="" name="accreditingBodyInstitutes[0].endDate" class="textField w80px maskYear" />
         <input type="hidden" name="accreditingBodyInstitutes[0].instituteId" value="${institution.id}"/></td>
         
         <td valign="middle"><a href="#" class="removeIcon fr"></a></td>
       </tr>
        </c:when>
        <c:otherwise>
        <c:forEach items="${accreditingBodyInstituteList}" var="accreditingBodyInstitute" varStatus="loop">
	        <tr class="infoBottomBrNon" id="trAbRow_${loop.index}">
	         <td><select class="w90per required " id="accreditingBody_${loop.index}" name="accreditingBodyInstitutes[${loop.index }].accreditingBody.id">
	           <option  value="">Select the Accrediting Body</option>
			
				 <optgroup label="Regional ">
				<c:forEach items="${accreditingBodyList}" var="accreditingBody">
				<c:if test="${accreditingBody.regional eq true}">
				<option <c:if test="${accreditingBodyInstitute.accreditingBody.id == accreditingBody.id}"> selected="true" </c:if>  value="${accreditingBody.id}">${accreditingBody.name}</option>
				</c:if>
				</c:forEach></optgroup>
				    <optgroup label="National ">
					<c:forEach items="${accreditingBodyList}" var="accreditingBody">
				<c:if test="${accreditingBody.regional eq false}">
				<option <c:if test="${accreditingBodyInstitute.accreditingBody.id == accreditingBody.id}"> selected="true" </c:if>  value="${accreditingBody.id}">${accreditingBody.name}</option>
				</c:if>
				</c:forEach></optgroup>			 
	         </select></td>
	         <td><input type="text"  name="accreditingBodyInstitutes[${loop.index }].effectiveDate" value="${accreditingBodyInstitute.effectiveDate}" class="textField w80px maskYear required" /></td>
	         <td><input type="text" name="accreditingBodyInstitutes[${loop.index }].endDate" value="${accreditingBodyInstitute.endDate}" class="textField w80px maskYear" />
	         <input type="hidden" name="accreditingBodyInstitutes[${loop.index}].instituteId" value="${institution.id}"/></td>
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
        			<input type="submit" name="saveAccreditingBody" value="Save" id="saveAccreditingBody" class="button">
           			<input type="submit" name="saveAccreditingBody" value="Save & Next" id="saveAccreditingBody" class="button">
        		</c:when>
        		<c:when test="${institution.evaluationStatus eq 'NOT EVALUATED' && userRoleName eq 'Institution Evaluator' && ((!empty institution.checkedBy && institution.checkedBy eq userCurrentId) || (!empty institution.confirmedBy && institution.confirmedBy eq userCurrentId))}">
        			<input type="submit" name="saveAccreditingBody" value="Save" id="saveAccreditingBody" class="button">
           			<input type="submit" name="saveAccreditingBody" value="Save & Next" id="saveAccreditingBody" class="button">
        		</c:when>
        		<c:when test="${empty institution.evaluationStatus}">
        			<input type="submit" name="saveAccreditingBody" value="Save" id="saveAccreditingBody" class="button">
           			<input type="submit" name="saveAccreditingBody" value="Save & Next" id="saveAccreditingBody" class="button">
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
    


<%-- 
<script >
function addAccreditingBody(accreditingBodyInstituteId) {
		
		 var url;
		 if('${role}'=='MANAGER'){
			 if(accreditingBodyInstituteId=="0"){
				 url="<c:url value='/evaluation/ieManager.html?operation=addAccreditingBody&institutionId=${institutionId}'/>";
			 }else{
				 url="<c:url value='/evaluation/ieManager.html?operation=addAccreditingBody&institutionId=${institutionId}&accreditingBodyInstId="+accreditingBodyInstituteId+"'/>";
			}
		}else{
			 if(accreditingBodyInstituteId=="0"){
				 url="<c:url value='/evaluation/quality.html?operation=addAccreditingBody&institutionMirrorId=${institutionMirrorId}'/>";
			 }else{
				 url="<c:url value='/evaluation/quality.html?operation=addAccreditingBody&institutionMirrorId=${institutionMirrorId}&accreditingBodyInstId="+accreditingBodyInstituteId+"'/>";
			}
		}
		Boxy.load(url,
		{ unloadOnHide : true	,
 		afterShow : function() {
 			settingMaskInput();
			jQuery("#selAccrediting").change(function(){
				jQuery("#accreditingBodyName").val('');
				jQuery("#accreditingBodyName ").val(jQuery("#selAccrediting option:selected").text());
			});
			
			jQuery.validator.addMethod("dateRange", function() {
				if(jQuery("#endDate").val()!="" ){
 					return  jQuery("#effectiveDate").val() < jQuery("#endDate").val();
				}
				return true;
 			}, "End year should be greater than the effective year.");
 			
 			jQuery.validator.addClassRules({
 				requiredDateRange: {dateRange:true}
 			});
 			
			jQuery("#frmAccreditingBody").validate();
		}
		});
	}
	jQuery(document).ready(function(){
		jQuery("[name='effective']").change(function(){
			if('${role}'=='MANAGER'){
				window.location.href='ieManager.html?operation=effectiveAccreditingBody&institutionId=${institutionId}&accreditingBodyId='+jQuery(this).val();
			}else{
				window.location.href='quality.html?operation=effectiveAccreditingBody&institutionMirrorId=${institutionMirrorId}&accreditingBodyId='+jQuery(this).val();
			}
		})	;
		
	});
</script>

<c:choose>
     	<c:when test="${role=='MANAGER'}"> 
        	<c:set var="backLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=ieInstitution&institutionId=${institutionId}"/>
 	 	</c:when>
 	 	<c:when test="${role == 'ADMIN' }">
 	 		<c:set var="backLink" scope="session" value="/scheduling_system/evaluation/admin.html?operation=viewInstitutionDetails&institutionId=${institutionId}"/>
 	 	</c:when>
 		<c:otherwise>
 			<c:set var="backLink" scope="session" value="/scheduling_system/evaluation/quality.html?operation=ieInstitution&institutionId=${institutionId}"/>
 	 	</c:otherwise>
 	</c:choose> 

 <ul class="pageNav">
        
        <li><a href="${institutionDetail}" style="z-index:9;">Institution Details <span class="sucssesIcon"></span></a></li>
        <li><a href="${aBodyLink }" style="z-index:8;" class="active">Accrediting Body  <c:choose> <c:when test="${fn:length(institution.accreditingBodyInstitutes)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose>  </a> </li>
        <li><a href="${termTypeLink }" style="z-index:7;">Term Types <c:choose> <c:when test="${fn:length(institution.institutionTermTypes)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose></a> </li>
        <li><a href="${transcriptKeyLink }" style="z-index:6;">Transcript Key <c:choose> <c:when test="${fn:length(institution.institutionTranscriptKeys)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose></a> </li>
        <li><a href="${aAgreementLink }" style="z-index:5;">Articulation Agreement <c:choose> <c:when test="${fn:length(institution.articulationAgreements)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose>  </a> </li>
        <li><a href="${markCompleteLink }" class="last">Summary</a></li>
        
        </ul>
    	<div class="infoContnr"><div class="infoTopArow infoarow2"></div>
    	<div class="fr institutionHeader">
       		<a href="javascript:void(0)" onclick='addAccreditingBody("0")'><img alt="" src="../images/termTypeIcon.png">Add Accrediting Body</a>
        </div><br class="clear">
          
<c:choose>

        <c:when test="${fn:length(accreditingBodyList)>0}">
 	<table width="100%" cellspacing="0" cellpadding="0" border="0" class="noti-tbl">
       <tbody>
       <tr>
         <th width="46%" scope="col"> Accrediting Body</th>
         <th width="18%" scope="col" class="dividerGrey">Effective Year</th>
         <th width="18%" scope="col" class="dividerGrey">End Year</th>
          <th width="18%" scope="col" class="dividerGrey">Effective</th>
         <th width="18%" scope="col" class="dividerGrey">Action</th>
       </tr>
       
       <c:forEach items="${accreditingBodyList}" var="accreditingBodyInstitute" varStatus="index">
       <tr>
         <td><span>${accreditingBodyInstitute.accreditingBody.name}</span></td>
         <td><span>${accreditingBodyInstitute.effectiveDate}</span></td>
         <td><span>${accreditingBodyInstitute.endDate}</span></td>
         <td><span>
       <c:choose>
     	<c:when test="${role != 'ADMIN'}"> 
	         <input type="radio" name="effective" value="${accreditingBodyInstitute.id}"  
	         <c:if test="${accreditingBodyInstitute.effective == 'true'}"> checked='checked'</c:if>/>
         </c:when>
         <c:otherwise>${accreditingBodyInstitute.effective}</c:otherwise>
       </c:choose>
         </span></td>
         <td><span>
         <c:if test="${role != 'ADMIN'}">
         	<a onclick='addAccreditingBody("${accreditingBodyInstitute.id}")'   href="#">
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
 	</div>
 
  --%>