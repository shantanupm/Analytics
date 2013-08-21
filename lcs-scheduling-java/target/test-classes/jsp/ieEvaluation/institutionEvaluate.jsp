<%@include file="../init.jsp" %>
<style>
.capitalise
{
    text-transform:capitalize;
} 
</style>


<script>
		 
var stateList = new Array("AL Alabama","AK Alaska","AB Alberta","AS American Samoa","AZ Arizona","AR Arkansas",
		"AE Armed Forces","AA Armed Forces Americas","AP Armed Forces Pacific","BC British Columbia",
		"CA California","CO Colorado","CT Connecticut","DE Delaware","DC District of Columbia",
		"FM Federated States of Micronesia","FL Florida","FC Foreign Country","GA Georgia","GU Guam, US Territory",
		"HI Hawaii","ID Idaho","IL Illinois","IN Indiana","IA Iowa","KS Kansas","KY Kentucky","LA Louisiana",
		"ME Maine","MB Manitoba","MH Marshall Islands","MD Maryland","MA Massachusetts","MI Michigan","MN Minnesota",
		"MS Mississippi","MO Missouri","MT Montana","NE Nebraska","NV Nevada","NB New Brunswick","NH New Hampshire",
		"NJ New Jersey","NM New Mexico","NY New York","NL Newfoundland and Labrador","NC North Carolina",
		"ND North Dakota","MP Northern Mariana Islands","NT Northwest Territories","NS Nova Scotia","NU Nunavut",
		"OH Ohio","OK Oklahoma","ON Ontario","OR Oregon","PA Pennsylvania","PE Prince Edward Island",
		"PR Puerto Rico","QC Quebec","RI Rhode Island","SK Saskatchewan","SC South Carolina",
		"SD South Dakota","TN Tennessee","TX Texas","UN Unknown","UT Utah","VT Vermont",
		"VI Virgin Islands","VA Virginia","WA Washington","WV West Virginia","WI Wisconsin","WY Wyoming","YT Yukon");

		function selectInstitute(){
			//alert("val------"+jQuery("#selInstitution").val());
			jQuery("#parentInstituteName").val(jQuery("#selInstitution :selected").text());
			jQuery("#parentInstituteId").val(jQuery("#selInstitution :selected").val());
		
		}
		
window.onload = (function () {		
		jQuery(document).ready(function(){			
			jQuery("#locationId").val('${institution.locationId}')
			jQuery("#institutionTypeId").change(function(){
				jQuery("#institutionTypeName").val('');
				jQuery("#institutionTypeName ").val(jQuery("#institutionTypeId option:selected").text());
			});
			
			jQuery("[id^='schoolTitle']").live('on keyup', function(event) {
				jQuery(this).addClass('capitalise');
			});
			validateAddressField();
			
				jQuery("#frmInstitution").validate();
						
				jQuery("#schoolTitle").live('blur', function(event) {
					var schoolTitle=jQuery("#schoolTitle").val();
					var institutionId ="";
					institutionId=jQuery("#institutionId").val();
					if (institutionId === undefined){
						institutionId="";
					}
					var url="/scheduling_system/institution/manageInstitution.html?operation=validateSchoolTitle&schoolTitle="+schoolTitle+"&institutionId="+institutionId;
					
					jQuery.ajax({url:url, success:function(result){
					
					   if(result=="true"){
							jQuery("#schoolTitleErrorDisplay").html('<p style="color: red;">Already Exist<p>');
							jQuery("#saveInstitution").attr('disabled','disabled');
							jQuery("#saveNextInstitution").attr('disabled','disabled');
							
						}else{
							jQuery("#schoolTitleErrorDisplay").html('');
							jQuery("#saveInstitution").attr('disabled',false);
							jQuery("#saveNextInstitution").attr('disabled',false);
						}
					  }});
				});
				
							
		});
});
		function validateAddressField(){
			jQuery("#zipcode").removeClass("number");
			jQuery("#zipcode").mask("99999-?9999");
			jQuery("#phone1").mask("9999999999");
			jQuery("#phone2").mask("9999999999");
			jQuery("#fax").mask("(999) 999-9999"); 	
			
			jQuery("#countryId").live('blur', function(event) {
				if(jQuery(this).val()==1){
					jQuery("#zipcode").removeClass("number");
					jQuery("#zipcode").mask("99999-?9999");
					jQuery("#phone1").mask("9999999999");
					jQuery("#phone2").mask("9999999999");
					jQuery("#fax").mask("(999) 999-9999"); 
					
				}else{
					
					jQuery("#zipcode").addClass("number");
					jQuery("#zipcode").unmask();
					jQuery("#phone1").unmask();
					jQuery("#phone2").unmask();
					jQuery("#fax").unmask();
				}
			
			
			});
			
			
			
				jQuery(".stateClass").autocomplete({source: stateList});

			
		}
		function loadAddress(addressId){
			if(addressId=="0"){
				 url="<c:url value='/evaluation/quality.html?operation=loadAddress&institutionId=${institutionId}'/>";
			 }else{
				 url="<c:url value='/evaluation/quality.html?operation=loadAddress&institutionId=${institutionId}&addressId="+addressId+"'/>";
			}
			
			Boxy.load(url,{
				unloadOnHide : true,
				afterShow : function() {
					jQuery("#addAddressForm").validate();
					
					validateAddressField();
				}
				});
		}

</script>

<%-- <c:if test="${role ne 'MANAGER' && not empty institution.institutionTranscript.studentInstitutionTranscriptId }">
         <div class="fr " style="padding-bottom:10px;">
	 		<a  onclick="NewWindow(this.href,'mywin','800','500','yes','center');return false" onfocus="this.blur()"
	 		href='/scheduling_system/evaluation/launchEvaluation.html?operation=getCoursesForStudentTranscript&studentInstitutionTranscriptId=${institution.institutionTranscript.studentInstitutionTranscriptId}&institutionId=${institution.id}&evaluator=true' >View Transcript Reference</a>
	 		</div>
	 	</c:if> --%>
  <%--   
<c:if test="${!fn:toUpperCase(userRoleName) eq 'INSTITUTION EVALUATOR'  && !fn:toUpperCase(institution.evaluationStatus)  eq 'NOT EVALUATED'}">
<div class="institutionHeader">
     <a href="/scheduling_system/evaluation/ieManager.html?operation=getInstitutionList" class="mr10"><img src="../images/arow_img.png" width="15" height="13" alt="" /> Back To Institution(s) List</a>
    
    &nbsp;&nbsp;&nbsp;
    <a href="/scheduling_system/evaluation/ieManager.html?operation=getCoursesForInstitution&institutionId=${institutionId }" class="fr viewIcon">View All Course(s)</a>
    <br class="clear"/>
    </div>
  </c:if>
   --%>
  <c:if test="${fn:toUpperCase(institution.evaluationStatus)  eq 'EVALUATED'}">
<div class="institutionHeader">
    <a href="/scheduling_system/evaluation/ieManager.html?operation=getCoursesForInstitution&institutionId=${institutionId }" class="fr viewIcon">View All Course(s)</a>
    <br class="clear"/>
    </div>
  </c:if>
   <ul class="pageNav">        
        <li><a href="#" style="z-index:9;" class="active">Institution Details <span class="sucssesIcon"></span></a></li>
       <li><a <c:if test="${not empty institutionId}"> href="${aBodyLink }" </c:if> style="z-index:8;" >Accrediting Body  <c:choose> <c:when test="${fn:length(institution.accreditingBodyInstitutes)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise > <span class="alrtIcon"></span></c:otherwise></c:choose>  </a> </li>
        <li><a <c:if test="${not empty institutionId}"> href="${termTypeLink }" </c:if> style="z-index:7;">Term Types <c:choose> <c:when test="${fn:length(institution.institutionTermTypes)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose></a> </li>
        <li><a <c:if test="${not empty institutionId}"> href="${transcriptKeyLink }" </c:if> style="z-index:6;">Transcript Key <c:choose> <c:when test="${fn:length(institution.institutionTranscriptKeys)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose></a> </li>
        <li><a <c:if test="${not empty institutionId}"> href="${markCompleteLink }" </c:if> class="last">Summary</a></li>
        
        </ul>
       
       <div style="margin-top: -40px;" class="fr">
       CRM Inquiry ID : <c:choose><c:when test="${!empty institution.lastStudent.crmId }"> ${institution.lastStudent.crmId}</c:when><c:otherwise>Not Available</c:otherwise> </c:choose>/
       Student Number : <c:choose><c:when test="${!empty institution.lastStudent.campusvueId }"> ${institution.lastStudent.campusvueId}</c:when><c:otherwise>Not Available</c:otherwise> </c:choose>  
       </div>
	 	
	<div class="infoContnr"><div class="infoTopArow"></div>
	<form id="frmInstitution" method="post" action="${actionLink}">
    	   <table width="100%" border="0" cellspacing="0" cellpadding="0" class="contentForm">
    	    <tr>
    	      <td width="47%" align="left" valign="top"> 
                    
                   
                    <label class="noti-label w130">Institution Name:<span class="astric">*</span></label>
                    <input type="text" name="name" id="schoolTitle" type="text" value="${institution.name}" class="textField required w200">
                    <div id="schoolTitleErrorDisplay"></div>
                    <br  class="clear"/>
                    <label class="noti-label w130">Institution Id:</label>
                    <label class="caption">${institution.institutionID}</label>
                    <br  class="clear"/>
                    <label class="noti-label w130">Address:<span class="strColor">*</span></label>
                   <c:forEach items="${institution.addresses}" var="address">
                    
                    <div class="aseladdOverflow2"> ${address.address1} ${address.address2}	${address.city} ${address.state}
						 ${address.zipcode} ${address.country.name}
		                <c:if test="${!empty address.phone1 }"> <br />Phone: ${address.phone1}</c:if>  
		                <c:if test="${!empty address.phone2 }">, ${address.phone2} <br /> </c:if>
						<c:if test="${!empty address.fax }">Fax: ${address.fax}	</c:if> 
						<c:if test="${!empty address.tollFree }">Toll Free:${address.tollFree} </c:if> 
						<c:if test="${!empty address.website }">Website: ${address.website} </c:if>
						<c:if test="${!empty address.email1 }">Email Id: ${address.email1} </c:if>
						<c:if test="${!empty address.email2 }">, ${address.email2} </c:if><br />
	              <a onclick="javascript:loadAddress('${address.id}');" href="javascript:void(0)">Edit Address</a></div>
	              <br />
                    <br  class="clear"/>
                    
                    <label class="noti-label w130"></label>
                  </c:forEach>  
        
        <c:if test="${not empty institution.id}">
        <br  class="clear"/>
        <label class="noti-label w130"></label>
			<a onclick="javascript:loadAddress(0);" href="javascript:void(0)">Add New Address</a><br />
		</c:if>
			
            
                   
                     
              <c:if test="${empty institution.id}">          
             
                
             
             
                    <input type="text" value=""  name="address1"  class="textField w200 required"> 
                    <br  class="clear"/>
                     <label class="noti-label w130"></label>
                    <input type="text" value="" name="address2" class="textField w200"> 
                    <br  class="clear"/>
				<label class="noti-label w130">City:<span class="strColor">*</span></label>
                    <input type="text" value="" name="city" class="textField w200 required"> <br  class="clear "/>
                    
                    
				<label class="noti-label w130">State:<span class="strColor">*</span></label>
          <input name="state" id="state" value="" class="textField w200 required stateClass" />
                    <br  class="clear"/>
                  
			<label class="noti-label w130">Zip Code:<span class="strColor">*</span></label>
                    <input type="text" value=""   name="zipcode" id="zipcode"  class="textField w200 required">
                    <br  class="clear"/>
                   
                     <label class="noti-label w130">Country:<span class="strColor">*</span></label>
                    <select id="countryId" name="country.id" class="valid w210 required">
	                    <option value="">Select the Country</option>
						<c:forEach items="${countryList}" var="country">
							<option value="${country.id}" <c:if test="${country.id eq 1 }"> selected="true" </c:if> >${country.name}</option>
						</c:forEach>	    
					</select>
                
                    
                    <br  class="clear"/>
                    
                     <label class="noti-label w130">Phone:<span class="strColor">*</span></label>
                    <input type="text" value="" id="phone1" name="phone1" class="textField w200  number required"> 
                    
                    <br  class="clear"/>
                    
                     <label class="noti-label w130">Phone:</label>
                    <input type="text" value="" id="phone2" name="phone2" class="textField w200  number "> 
                    
                    <br  class="clear"/>
                    
                     <label class="noti-label w130">Fax:</label>
                    <input type="text" value=""  id="fax"  name="fax" class="textField w200">
                    
                    <br  class="clear"/>
                    
                     <label class="noti-label w130">Website:</label>
                    <input type="text" value=""  id="website" name="website" class="textField w200">
                    
                    <br  class="clear"/>
                    
                    
                    
                    
                   
            </c:if>
              </div>
              <div class="clear"></div>
              <br />
 			</td>
    	      <td width="2%" class="tblBordr">&nbsp;</td>
    	      <td width="45%" align="left" valign="top">
             
                   
					<label class="noti-label w130">College Board Code:</label>
                    <input type="text" value="${institution.schoolcode}" name="schoolcode" class="textField w200"><br  class="clear"/>
                    <label class="noti-label w130">Institution Type:<span class="astric">*</span></label>
                  
                    
                    <select class="w210 required valid" name="institutionType.id">
					  <option value="" selected="selected">Select Institution Type</option>
						
						<c:forEach items="${institutionTypeList}" var="institutionType">
							<option
								<c:if test="${institution.institutionType.id == institutionType.id}"> selected="true" </c:if>
								value="${institutionType.id}">${institutionType.name}</option>
						</c:forEach>
						
					</select>
					<input id="institutionTypeName" name="institutionType.name" type="hidden" value="${institution.institutionType.name}">
                    <br  class="clear"/>
                    
                    
                    <label class="noti-label w130">Location Type:</label>
                    <select name="locationId" id="locationId" class="valid w210">
						<option>Primary</option>
						<option>Satellite Campus</option>
						<option>Online Campus</option>
						<option>Parent Institution</option>
					</select>
                    <br  class="clear"/>
                    
                      <label class="noti-label w130">Parent Institute:</label>
                    <input type="text" value="${institution.parentInstitutionName}" class="textField w200" id="parentInstituteName" name="parentInstitutionName"  readonly="readonly"/>
                    <input type="hidden"  id="parentInstituteId" name="parentInstitutionId"  value="${institution.parentInstitutionId}"/> 
           <input type="button" onclick='Boxy.load("<c:url value='/institution/manageInstitution.html?operation=selectParentInstitution&institutionId=${institution.id}'/>",{ unloadOnHide : true})' class="button" value="Select">
                    
                    <br  class="clear"/>
                     


              </td>
   	        </tr>
  	    </table>  	    <c:if test="${not empty institution.id}">
				<input name="id" id="institutionId"	type="hidden" value="${institution.id}" /> 
			</c:if>
				<input	name="institutionMirrorId" id="institutionMirrorId" type="hidden"	value="${institutionMirrorId}" /> 
				<input name="createdDate" id="createdDate" type="hidden"	value='<fmt:formatDate value="${institution.createdDate}" pattern="MM/dd/yyyy"/>' />
				<input name="createdBy" id="createdBy" type="hidden"	value="${institution.createdBy}" /> 
				<input name="checkedDate"	id="checkedDate" type="hidden"	value='<fmt:formatDate value="${institution.checkedDate}" pattern="MM/dd/yyyy"/>' />
				<input name="checkedBy" id="checkedBy" type="hidden"	value="${institution.checkedBy}" /> 
				<input name="confirmedBy" id="confirmedBy" type="hidden"	value="${institution.confirmedBy}" /> 
				<input name="modifiedBy" id="modifiedBy" type="hidden" value="${institution.modifiedBy}" />
				<input name="evaluationStatus" type="hidden" value="${institution.evaluationStatus}" />
				<input name="checkedStatus" type="hidden" value="${institution.checkedStatus}" />
				<input name="confirmedStatus" type="hidden" value="${institution.confirmedStatus}" />
			<c:if test="${not empty institution.id}">
				<input name="institutionID" type="hidden" value="${institution.institutionID}" />
				</c:if>
        <div class="divider3 mt10"></div>
        <div class="fr mt10">
        	<c:choose>
        		<c:when test="${userRoleName eq 'Institution Evaluation Manager' || userRoleName eq 'Administrator'}">
        			<input type="submit" name="saveInstitution" value="Save" id="saveInstitution" class="button">
			  		<input type="submit" name="saveInstitution" value="Save & Next" id="saveNextInstitution" class="button">
        		</c:when>
        		<c:when test="${institution.evaluationStatus eq 'NOT EVALUATED' && userRoleName eq 'Institution Evaluator' && ((!empty institution.checkedBy && institution.checkedBy eq userCurrentId) || (!empty institution.confirmedBy && institution.confirmedBy eq userCurrentId))}">
        			<input type="submit" name="saveInstitution" value="Save" id="saveInstitution" class="button">
			  		<input type="submit" name="saveInstitution" value="Save & Next" id="saveNextInstitution" class="button">
        		</c:when>
        		<c:when test="${empty institution.evaluationStatus}">
        			<input type="submit" name="saveInstitution" value="Save" id="saveInstitution" class="button">
			  		<input type="submit" name="saveInstitution" value="Save & Next" id="saveNextInstitution" class="button">
        		</c:when>
        		<c:otherwise>
        		
        		</c:otherwise>
        	
        	</c:choose>
        </div>
        <div class="clear"></div>
        </form>
        </div>
        