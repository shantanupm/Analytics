<%@include file="../init.jsp" %>

<%-- <link rel="stylesheet" href="<c:url value="/css/jquery.ui.all.css"/>" /> --%>
<link rel="stylesheet" media="screen" href="<c:url value="/css/datePicker.css"/>" />

<script type="text/javascript" src="<c:url value="/js/jquery.js"/>"></script>     
<script type='text/javascript' src="<c:url value="/js/jquery.ui.core.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.widget.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.position.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.autocomplete.js"/>"></script>    
<script type="text/javascript" src="<c:url value="/js/jquery.validate.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.maskedinput-1.3.js"/>"></script>


<script>


	var stateList = new Array("","AK","AL","AR","AS","AZ","CA","CO","CT","DC","DE","FL","GA","GU","HI","IA","ID",
		"IL","IN","KS","KY","LA","MA","MD","ME","MH","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY",
		"OH","OK","OR","PA","PR","PW","RI","SC","SD","TN","TX","UT","VA","VI","VT","WA","WI","WV","WY");


		
		  
		function selectInstitute(){
		//alert("val------"+jQuery("#selInstitution").val());
		jQuery("#parentInstituteId").val(jQuery("#selInstitution :selected").text());

		
		}

		jQuery(document).ready(function(){

			jQuery("#frmInstitution").validate();
		
		
		
			if('${institution.evaluationStatus}'=='UnConfirmed'){
				jQuery('#evaluationStatusLabel').html('Confirm');
			}else{
				jQuery('#evaluationStatusLabel').html('Evaluate');
			}
		
			jQuery("#schoolcode").live('blur', function(event) {
				var schoolcode=jQuery("#schoolcode").val();
				var institutionId ="";
				institutionId=jQuery("#institutionId").val();
				if (institutionId === undefined){
					institutionId="";
				}
				var url="/scheduling_system/institution/manageInstitution.html?operation=validateSchoolCode&schoolCode="+schoolcode+"&institutionId="+institutionId;
				
				jQuery.ajax({url:url, success:function(result){
				
				   if(result=="true"){
						jQuery("#schoolcodeErrorDisplay").html('<p style="color: red;">Already Exist<p>');
						jQuery("#saveInstitution").attr('disabled','disabled');
					}else{
						jQuery("#schoolcodeErrorDisplay").html('');
						jQuery("#saveInstitution").attr('disabled','');
					}
				  }});
			});
			
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
					}else{
						jQuery("#schoolTitleErrorDisplay").html('');
						jQuery("#saveInstitution").attr('disabled','');
					}
				  }});
			});
			
			jQuery("#countryId").live('blur', function(event) {
				if(jQuery(this).val()==1){
					jQuery( "#state" ).autocomplete({source: stateList});
					jQuery("#zipcode").mask("99999-9999");
					jQuery("#phone").mask("(999) 999-9999"); 
					jQuery("#fax").mask("(999) 999-9999"); 
					
					
				}else{
					jQuery( "#state" ).autocomplete({source: ''});
					jQuery("#zipcode").unmask();
					jQuery("#phone").unmask();
					jQuery("#fax").unmask();
					
					
				}
			
			
			});

			jQuery("#evaluationStatus").val('${institution.evaluationStatus}')	;
		});
		

</script>

<c:choose>
     	<c:when test="${role=='MANAGER'}"> 
        	<c:set var="actionLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=ieSaveInstitution"/>
        	<c:set var="aBodyLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=manageAccreditingBody&institutionId=${institution.id}"/>
 			<c:set var="termTypeLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=manageInstitutionTermType&institutionId=${institution.id}"/>
 			<c:set var="transcriptKeyLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=manageInstitutionTranscriptKey&institutionId=${institution.id}"/>
 			<c:set var="aAgreementLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=manageArticulationAgreement&institutionId=${institution.id}"/>
	 	</c:when>
 		<c:otherwise>
 			<c:set var="actionLink" scope="session" value="/scheduling_system/evaluation/quality.html?operation=ieSaveInstitution"/>
 			<c:set var="aBodyLink" scope="session" value="/scheduling_system/evaluation/quality.html?operation=manageAccreditingBody&institutionMirrorId=${institutionMirrorId}"/>
 			<c:set var="termTypeLink" scope="session" value="/scheduling_system/evaluation/quality.html?operation=manageInstitutionTermType&institutionMirrorId=${institutionMirrorId}"/>
 			<c:set var="transcriptKeyLink" scope="session" value="/scheduling_system/evaluation/quality.html?operation=manageInstitutionTranscriptKey&institutionMirrorId=${institutionMirrorId}"/>
 			<c:set var="aAgreementLink" scope="session" value="/scheduling_system/evaluation/quality.html?operation=manageArticulationAgreement&institutionMirrorId=${institutionMirrorId}"/>
	 	</c:otherwise>
 	</c:choose>   

<center>
    <div class="tblFormDiv divCover" style="width:720px; padding-left:10px;">
   
   <!--  <form  id="frmInstitution" method="post" action="/scheduling_system/evaluation/quality.html?operation=ieSaveInstitution">-->
   <form  id="frmInstitution" method="post" action="${actionLink}">
        <table class="tableForm" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <th class="heading" colspan="2"><strong>Evaluate Institution</strong></th>
            </tr>
            <tr>
                <td width="35%">School Code</td>
                <td width="65%"><input id="schoolcode" name="schoolcode" readonly="readonly" value="${institution.schoolcode}" type="text" class="textField small required" /><br class="clear" />
				<div id="schoolcodeErrorDisplay" ></div>
				</td>
            </tr>
            <tr>
                <td>Location Type</td>
                <td>
                    <select name="locationId">
                        <option>Primary</option>
                        <option>Satellite Campus</option>
                        <option>Online Campus</option>
                        <option>Parent Institution</option>
                    </select><br class="clear" />
                </td>
            </tr>
            <tr>
                <td>Institution Name</td>
                <td><input name="name" id="schoolTitle" type="text" value="${institution.name}" class="textField big required"  /><br class="clear" />
				<div id="schoolTitleErrorDisplay" ></div></td>
            </tr>
            <tr>
                <td>Institution Address</td>
                <td><input name="address1" type="text" value="${institution.address1}" class="textField big" /><br class="clear" /></td>
            </tr>
            <tr>
                <td>Institution Address</td>
                <td><input name="address2" type="text" value="${institution.address2}" class="textField big"  /><br class="clear" /></td>
            </tr>
            <tr>
                <td>City</td>
                <td><input name="city" type="text" value="${institution.city}" class="textField small" /></td>
            </tr>
			 <tr>
                <td>Country</td>
                <td>
                    <select  id="countryId" name="countryId" class="required">
						<option value="">Select the Country</option>
						<c:forEach items="${countryList}" var="country">
							<option <c:if test="${institution.country.id == country.id}"> selected="true" </c:if> value="${country.id}">${country.name}</option>
						</c:forEach>		    
					</select> <br class="clear" />
                </td>
           
            </tr>
            <tr>
                <td>State</td>
                <td><input name="state" id="state" type="text" value="${institution.state}" class="textField small" /></td>
            </tr>
            <tr>
                <td>Zip Code</td>
                <td><input name="zipcode" id="zipcode" type="text"  value="${institution.zipcode}" class="textField small" /></td>
            </tr>
            <tr>
                <td>Phone</td>
                <td><input name="phone" id="phone"  type="text"  value="${institution.phone}" class="textField small " /></td>
            </tr>
            <tr>
                <td>Fax</td>
                <td><input name="fax" id="fax" type="text" value="${institution.fax}" class="textField small " /></td>
            </tr>
           
            <tr>
                <td>Website</td>
                <td><input name="website" type="text"  value="${institution.website}" class="textField big"  /><br class="clear" /></td>
            </tr>
            <tr>
                <td>Institution Type</td>
                <td>
                     <select  name="institutionTypeId" class="required">
						<option value="">Select Institution Type</option>
						<c:forEach items="${institutionTypeList}" var="institutionType">
							<option <c:if test="${institution.institutionType.id == institutionType.id}"> selected="true" </c:if> value="${institutionType.id}">${institutionType.name}</option>
						</c:forEach>			    
					</select> <br class="clear" />
                </td>
            </tr>
           
            
            <tr>
                <td>Parent Institute</td>
                <td>
				<input type="text" readonly="readonly"  id="parentInstituteId" value="" />
				<input type="button" value="Select Parent Institution" class="button" 
                onclick='Boxy.load("<c:url value='/institution/manageInstitution.html?operation=selectParentInstitution&institutionId=${institution.id}'/>",{ unloadOnHide : true})'/>
                <br class="clear" /></td>
            </tr>
           
            <tr>
            
            <td></td><td></td></tr>
        </table>
        <table class="" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <td width="35%"> </td>
                <td width="65%" align="right" style="padding-top:10px;padding-right:10px;">
                
                	<input name="id" id="institutionId" type="hidden" value="${institution.id}"   />
                	<input name="institutionMirrorId" id="institutionMirrorId" type="hidden" value="${institutionMirrorId}"   />
                	<input name="createdDateTime" id="createdDateTime" type="hidden"  value='<fmt:formatDate value="${institution.createdDateTime}" pattern="MM/dd/yyyy"/>'   />
                	<input name="createdBy" id="createdBy" type="hidden" value="${institution.createdBy}"   />
                	<input name="checkedDate" id="checkedDate" type="hidden"  value='<fmt:formatDate value="${institution.checkedDate}" pattern="MM/dd/yyyy"/>'   />
                	<input name="checkedBy" id="checkedBy" type="hidden" value="${institution.checkedBy}"   />
                	<input name="modifiedBy" id="modifiedBy" type="hidden" value="${institution.modifiedBy}"   />
                	<input name="evaluationStatus"  type="hidden" value="${institution.evaluationStatus}"   />
                
               		 <c:if test="${role!='MANAGER'}"> 
                    	<input type="button" value="Back" onclick='window.location = "/scheduling_system/evaluation/quality.html?operation=ieEvaluate"' class="button" />
                    </c:if>
                    <input type="submit" id="saveInstitution" value="Save" name="saveInstitution" class="button" />
					
                </td>
            </tr>
        </table>
        <br/>
    </form>
    
    <table class="" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <td align="center">
                    <input type="button" value="Accrediting Body" name="P Institution" class="button" onclick='window.location = "${aBodyLink}"' />
                    <input type="button" value="Term Types" name="P Institution" class="button" onclick='window.location = "${termTypeLink}"' />
                    <input type="button" value="Transcript Key" name="P Institution" class="button" onclick='window.location = "${transcriptKeyLink}"' />
                    <input type="button" value="Articulation Agreement" name="P Institution" class="button" onclick='window.location = "${aAgreementLink}"' />
					<br  />
                </td>
                <td>
               		 <c:if test="${role=='MANAGER'}"> 
                    	<input type="button" value="Home"  onclick='window.location = "/scheduling_system/evaluation/ieManager.html?operation=managerEvaluationView"' class="button" />
                    </c:if>
                </td>
            </tr>
        </table>
		<br  />
   </div>     
</center>    

