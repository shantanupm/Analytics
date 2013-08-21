<%@include file="../init.jsp" %>

<link rel="stylesheet" href="<c:url value="/css/jquery.ui.all.css"/>" />
<link rel="stylesheet" media="screen" href="<c:url value="/css/datePicker.css"/>" />

<script type="text/javascript" src="<c:url value="/js/jquery.js"/>"></script>     
<script type='text/javascript' src="<c:url value="/js/jquery.ui.core.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.widget.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.position.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.autocomplete.js"/>"></script>   
<script type="text/javascript" src="<c:url value="/js/jquery.validate.js"/>"></script>


 
     <script>

 	var availableSchoolCode = [ <c:forEach items="${institutionList}" var="institution">
 	 					"${institution.schoolcode}",</c:forEach> ];
	var availableSchoolTitle = [ <c:forEach items="${institutionList}" var="institution">
 	 					"${institution.name}",</c:forEach> ];

	jQuery(document).ready(function(){
	    
	    jQuery("#frmInstitution").validate({
	    	 submitHandler: function(form) {
			   form.submit();
	    	 }
	    	});

		    jQuery( "#institutionCode" ).autocomplete({
				source: availableSchoolCode
			});

		    jQuery( "#instituteTitle" ).autocomplete({
				source: availableSchoolTitle
			});
	  });

 	function addEntryInstitution(){
 		Boxy.load("<c:url value='/institution/manageInstitution.html?operation=entryInstitution'/>",
 		 		{ unloadOnHide : true,
		 		afterShow : function() {
	 		//alert("---vale");
	 		jQuery("#frmEntryInstitution").validate();
	 		}
 		})   
	 }
  </script>

<center>
<div class="tblFormDiv divCover outLine"  >
<form id="frmInstitution"  action="/scheduling_system/institution/manageInstitution.html">
<div class="innerDiv" >
        <table class="tableForm" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <th class="heading" colspan="2"><strong>Select Institution</strong></th>
            </tr>
            <tr>
                <td width="35%"> </td>
                <td width="65%"></td>
            </tr>
            <tr>
                <td>School Code</td>
                <td><input name="institutionCode"  id="institutionCode" type="text" class="textField required small" /><br class="clear" /></td>
               
            </tr>
            <tr>
                <td>Institution Title</td>
                <td><input name="instituteTitle" id="instituteTitle" type="text" class="textField big" /><br class="clear" /></td>
            </tr>
            <tr>
                <td></td>
                <td>
					<input name="operation" type="hidden" value="viewInstitution" />
                    <input type="submit"  class="submit" value="Show Details" name="P Institution"    /> 
                    <input type="button" value="Add Institute" name="P Institution" class="button"
                     onclick='window.location = "/scheduling_system/institution/manageInstitution.html?operation=createInstitution"'   /><br class="clear" />
                     
                </td>
            </tr>
            <tr><td></td><td></td></tr>
        </table><br class="clear" />
</div>   
   </form>
        <br class="clear" />
       <c:choose>
        <c:when test="${not empty institution.schoolcode }">   
   <div class="innerDiv" >  
        <table class="tableForm" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <th class="heading" colspan="2"><strong>Institution Details</strong></th>
            </tr>
            <tr>
                <td width="35%">School Code</td>
                <td width="65%">${institution.schoolcode}</td>
            </tr>
            <tr>
                <td>Location Type</td>
                <td>${institution.locationId}</td>
            </tr>
            <tr>
                <td>Institution Name</td>
                <td>${institution.name}</td>
            </tr>
            <tr>
                <td>Institution Address</td>
                <td>${institution.address1}</td>
            </tr>
            <tr>
                <td>City</td>
                <td>${institution.city}</td>
            </tr>
            <tr>
                <td>State</td>
                <td>${institution.state}</td>
            </tr>
            <tr>
                <td>Zip Code</td>
                <td>${institution.zipcode}</td>
            </tr>
            <tr>
                <td>Phone</td>
                <td>${institution.phone}</td>
            </tr>
            <tr>
                <td>Fax</td>
                <td>${institution.fax}</td>
            </tr>
            <tr>
                <td>Country</td>
                <td>${institution.country.name}</td>
            </tr>
            <tr>
                <td>Website</td>
                <td> ${institution.website}</td>
            </tr>
            <tr>
                <td>Institution Type</td>
                <td>${institution.institutionType.name}</td>
            </tr>
            <tr>
                <td>Parent Institute</td>
                <td>${institution.parentInstitutionId}</td>
            </tr>
             <tr>
                <td> </td>
                <td><input type="button" value="Edit Details" name="P Institution" class="button"
                onclick='window.location = "/scheduling_system/institution/manageInstitution.html?operation=createInstitution&institutionId=${institution.id}"'  /></td>
            </tr>
            <tr><td></td><td></td></tr>
        </table>

        <table class="" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <td width="100%" align="right" style="padding-top:10px">
                    <input type="button" value="View/Edit Accrediting Body" name="P Institution" class="button" onclick='window.location = "/scheduling_system/institution/manageInstitution.html?operation=manageAccreditingBody&institutionId=${institution.id}"' />
                    <input type="button" value="View/Edit Term Types" name="P Institution" class="button" onclick='window.location = "/scheduling_system/institution/manageInstitution.html?operation=manageInstitutionTermType&institutionId=${institution.id}"' />
                    <input type="button" value="View/Edit Transcript Key" name="P Institution" class="button" onclick='window.location = "/scheduling_system/institution/manageInstitution.html?operation=manageInstitutionTranscriptKey&institutionId=${institution.id}"' />
                    <input type="button" value="View/Edit Articulation Agreement" name="P Institution" class="button" onclick='window.location = "/scheduling_system/institution/manageInstitution.html?operation=manageArticulationAgreement&institutionId=${institution.id}"' />
                </td>
            </tr>
        </table>
        <br class="clear" />
 	</c:when>
 	<c:otherwise>
	 	<c:if test= "${ empty mode}">
	 		No Institution Found
	 	</c:if>
 	</c:otherwise>
 	</c:choose>   

    </div>
</center>