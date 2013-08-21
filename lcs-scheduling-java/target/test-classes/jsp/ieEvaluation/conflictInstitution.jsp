<%@include file="../init.jsp" %>
<script type='text/javascript' src="<c:url value="/js/jquery-ui-1.8.23.custom.min.js"/>"></script>
<script type="text/javascript" src="../js/expand.js"></script>
<script type="text/javascript"
	src="<c:url value="/js/jquery.validate.js"/>"></script>
	
 <script>
function editInstitution(type) {
	 var url;
	 var selectedInstitution=jQuery("[name='selectInstitution']:checked").val();
	 if(selectedInstitution==''||selectedInstitution===undefined){
		 alert('Please Select Institution');
		 //jQuery("[name='selectInstitution']").focus();
	 }else if(type=='submit'){
		url="<c:url value='/evaluation/ieManager.html?operation=submitInstitution&selectedInstitution="+selectedInstitution+"'/>";
		window.location.href=url
			
	}else{
		window.location.href="<c:url value='/evaluation/ieManager.html?operation=editInstitution&selectedInstitution="+selectedInstitution+"'/>"
	}
}

jQuery(document).ready(function(){
	// Tabs
	jQuery('#tabs').tabs({ selected: 0 });
	//validation
	jQuery("#conflictInstitutionForm").validate();
	
	jQuery(':radio').change(function(){
		var rdname=jQuery(this).attr('name').split('_')[1];
		//alert(jQuery(this).val()+'---'+rdname);
		//alert(jQuery('#'+rdname+' option:selected').text());
		jQuery('#'+rdname).val(jQuery(this).val());
		jQuery('#'+rdname+'_name').val(jQuery('#'+rdname+' option:selected').text());
	}); 
	
	jQuery('.dd_change').change(function(){
		var rdname=jQuery(this).attr('id');
		jQuery('#'+rdname+'_name').val(jQuery(this).find("option:selected").text());
	}); 
	
});

</script>
<script type="text/javascript">
jQuery(function() {
	jQuery("h1.expand").toggler(); 
	jQuery(".conflictExpander").expandAll({trigger: "h1.expand"});
	
	jQuery('.collapse:first').show();
	jQuery('h1.expand:first a:first').addClass("open"); 
});
function disabledGropComponent(componentLength,index,transcriptKeyLength,componentName){
	if(componentName=='AccreditingBody'){
		if(jQuery("#accreditingBodyNA"+index).is(':checked')){	
			jQuery("#rd_accbdynameIe1-"+index).attr("checked","");
			jQuery("#rd_accbdynameIe1-"+index).attr("disabled","disabled");
			
			jQuery("#rd_accbdynameIe2-"+index).attr("checked","");
			jQuery("#rd_accbdynameIe2-"+index).attr("disabled","disabled");
			
			jQuery("#rd_accbdyname-"+index).attr("checked","");
			jQuery("#rd_accbdyname-"+index).attr("disabled","disabled");
			
			jQuery("#accbdyname-"+index).val("");
			jQuery("#accbdyname-"+index).attr("disabled","disabled");
			
			jQuery("#rd_accbdyEfDateIe1-"+index).attr("checked","");
			jQuery("#rd_accbdyEfDateIe1-"+index).attr("disabled","disabled");
			
			jQuery("#rd_accbdyEfDateIe2-"+index).attr("checked","");
			jQuery("#rd_accbdyEfDateIe2-"+index).attr("disabled","disabled");
			
			jQuery("#rd_accbdyEfDate-"+index).attr("checked","");
			jQuery("#rd_accbdyEfDate-"+index).attr("disabled","disabled");
			
			jQuery("#accbdyEfDate-"+index).val("");
			jQuery("#accbdyEfDate-"+index).attr("disabled","disabled");
			
			jQuery("#rd_accbdyEndDateIe1-"+index).attr("checked","");
			jQuery("#rd_accbdyEndDateIe1-"+index).attr("disabled","disabled");
			
			jQuery("#rd_accbdyEndDateIe2-"+index).attr("checked","");
			jQuery("#rd_accbdyEndDateIe2-"+index).attr("disabled","disabled");
			
			jQuery("#rd_accbdyEndDate-"+index).attr("checked","");
			jQuery("#rd_accbdyEndDate-"+index).attr("disabled","disabled");
			
			
			jQuery("#accbdyEndDate-"+index).val("");
			jQuery("#accbdyEndDate-"+index).attr("disabled","disabled");
			
		}else{
			jQuery("#rd_accbdynameIe1-"+index).removeAttr("disabled");
			jQuery("#rd_accbdynameIe2-"+index).removeAttr("disabled");
			jQuery("#rd_accbdyname-"+index).removeAttr("disabled");
			jQuery("#accbdyname-"+index).removeAttr("disabled");
			
			jQuery("#rd_accbdyEfDateIe1-"+index).removeAttr("disabled");
			jQuery("#rd_accbdyEfDateIe2-"+index).removeAttr("disabled");
			jQuery("#rd_accbdyEfDate-"+index).removeAttr("disabled");
			jQuery("#accbdyEfDate-"+index).removeAttr("disabled");
			jQuery("#rd_accbdyEndDateIe1-"+index).removeAttr("disabled");
			jQuery("#rd_accbdyEndDateIe2-"+index).removeAttr("disabled");
			jQuery("#rd_accbdyEndDate-"+index).removeAttr("disabled");
			jQuery("#rd_accbdyEndDate-"+index).removeAttr("disabled");
			jQuery("#accbdyEndDate-"+index).removeAttr("disabled");
		}
	}
	if(componentName=='TermType'){
		if(jQuery("#termTypeNA"+index).is(':checked')){	

			jQuery("#rd_ttypnameIe1-"+index).attr("checked","");
			jQuery("#rd_ttypnameIe1-"+index).attr("disabled","disabled");

			jQuery("#rd_ttypnameIe2-"+index).attr("checked","");
			jQuery("#rd_ttypnameIe2-"+index).attr("disabled","disabled");

			jQuery("#rd_ttypname-"+index).attr("checked","");
			jQuery("#rd_ttypname-"+index).attr("disabled","disabled");

			jQuery("#ttypname-"+index).val("");
			jQuery("#ttypname-"+index).attr("disabled","disabled");

			jQuery("#rd_ttypEfDateIe1-"+index).attr("checked","");
			jQuery("#rd_ttypEfDateIe1-"+index).attr("disabled","disabled");

			jQuery("#rd_ttypEfDateIe2-"+index).attr("checked","");
			jQuery("#rd_ttypEfDateIe2-"+index).attr("disabled","disabled");

			jQuery("#rd_ttypEfDate-"+index).attr("checked","");
			jQuery("#rd_ttypEfDate-"+index).attr("disabled","disabled");

			jQuery("#ttypEfDate-"+index).val("");
			jQuery("#ttypEfDate-"+index).attr("disabled","disabled");

			jQuery("#rd_ttypEndDateIe1-"+index).attr("checked","");
			jQuery("#rd_ttypEndDateIe1-"+index).attr("disabled","disabled");

			jQuery("#rd_ttypEndDateIe2-"+index).attr("checked","");
			jQuery("#rd_ttypEndDateIe2-"+index).attr("disabled","disabled");
			
			jQuery("#rd_ttypEndDate-"+index).attr("checked","");
			jQuery("#ttypEndDate-"+index).val("");
			jQuery("#rd_ttypEndDate-"+index).attr("disabled","disabled");
			
		}else{
			jQuery("#rd_ttypnameIe1-"+index).removeAttr("disabled");
			jQuery("#rd_ttypnameIe2-"+index).removeAttr("disabled");
			jQuery("#rd_ttypname-"+index).removeAttr("disabled");
			jQuery("#ttypname-"+index).removeAttr("disabled");
			jQuery("#rd_ttypEfDateIe1-"+index).removeAttr("disabled");
			jQuery("#rd_ttypEfDateIe2-"+index).removeAttr("disabled");
			jQuery("#rd_ttypEfDate-"+index).removeAttr("disabled");
			jQuery("#ttypEfDate-"+index).removeAttr("disabled");
			jQuery("#rd_ttypEndDateIe1-"+index).removeAttr("disabled");
			jQuery("#rd_ttypEndDateIe2-"+index).removeAttr("disabled");
			jQuery("#rd_ttypEndDate-"+index).removeAttr("disabled");
		}
	}
	if(componentName=='TranscriptKey'){
		if(jQuery("#transcriptKeyNA"+index).is(':checked')){
			//var efValue = document.getElementById("idInstitutionTranscriptKeys["+index+"].effectiveDate").value;
			//alert("efValue="+efValue);
			///var addHiddenFields = "<div id='hiddenTranscript'>";
			for(var i=0;i<=transcriptKeyLength;i++){
				jQuery("#rd_tkydtfrmIe1-"+index+"-"+i).attr("checked","");
				jQuery("#rd_tkydtfrmIe1-"+index+"-"+i).attr("disabled","disabled");
				
				jQuery("#rd_tkydtfrmIe2-"+index+"-"+i).attr("checked","");
				jQuery("#rd_tkydtfrmIe2-"+index+"-"+i).attr("disabled","disabled");
				
				jQuery("#rd_tkydtfrm-"+index+"-"+i).attr("checked","");
				jQuery("#rd_tkydtfrm-"+index+"-"+i).val("");
				jQuery("#rd_tkydtfrm-"+index+"-"+i).attr("disabled","disabled");
				
				jQuery("#tkydtfrm-"+index+"-"+i).val("");
				jQuery("#tkydtfrm-"+index+"-"+i).attr("disabled","disabled");
				
				jQuery("#rd_tkydttoIe1-"+index+"-"+i).attr("checked","");
				jQuery("#rd_tkydttoIe1-"+index+"-"+i).attr("disabled","disabled");
				
				jQuery("#rd_tkydttoIe2-"+index+"-"+i).attr("checked","");
				jQuery("#rd_tkydttoIe2-"+index+"-"+i).attr("disabled","disabled");
				
				jQuery("#rd_tkydtto-"+index+"-"+i).attr("checked","");
				jQuery("#rd_tkydtto-"+index+"-"+i).val("");
				jQuery("#rd_tkydtto-"+index+"-"+i).attr("disabled","disabled");
				
				jQuery("#tkydtto-"+index+"-"+i).val("");
				jQuery("#tkydtto-"+index+"-"+i).attr("disabled","disabled");
				
				
				jQuery("#rd_tkygcucrslvlIe1-"+index+"-"+i).attr("checked","");
				jQuery("#rd_tkygcucrslvlIe1-"+index+"-"+i).attr("disabled","disabled");
				
				jQuery("#rd_tkygcucrslvlIe2-"+index+"-"+i).attr("checked","");
				jQuery("#rd_tkygcucrslvlIe2-"+index+"-"+i).attr("disabled","disabled");
				
				
				jQuery("#rd_tkygcucrslvl-"+index+"-"+i).attr("checked","");
				jQuery("#rd_tkygcucrslvl-"+index+"-"+i).val("");
				jQuery("#rd_tkygcucrslvl-"+index+"-"+i).val("");
				jQuery("#rd_tkygcucrslvl-"+index+"-"+i).attr("disabled","disabled");
				
				jQuery("#tkygcucrslvl-"+index+"-"+i).val("");
				jQuery("#tkygcucrslvl-"+index+"-"+i).attr("disabled","disabled");
				
			}
			document.getElementById("idInstitutionTranscriptKeys["+index+"].effectiveDate").value ="";
			document.getElementById("idInstitutionTranscriptKeys["+index+"].effectiveDate").setAttribute('disabled',true);
			//alert("idInstitutionTranscriptKeys["+index+"].effectiveDate="+jQuery("#idInstitutionTranscriptKeys["+index+"].effectiveDate").val());
			//jQuery("#idInstitutionTranscriptKeys["+index+"].effectiveDate").attr('disabled','disabled');
			//jQuery("#idInstitutionTranscriptKeys["+index+"].endDate").attr('disabled','disabled');
			
			
			//addHiddenFields=addHiddenFields+"</div>";
			
			//jQuery("#forHiddenField").html(addHiddenFields);
		}else{
			for(var i=0;i<=transcriptKeyLength;i++){
				jQuery("#rd_tkydtfrmIe1-"+index+"-"+i).removeAttr("disabled");
				jQuery("#rd_tkydtfrmIe2-"+index+"-"+i).removeAttr("disabled");
				jQuery("#rd_tkydtfrm-"+index+"-"+i).removeAttr("disabled");
				jQuery("#tkydtfrm-"+index+"-"+i).removeAttr("disabled");
				jQuery("#rd_tkydttoIe1-"+index+"-"+i).removeAttr("disabled");
				jQuery("#rd_tkydttoIe2-"+index+"-"+i).removeAttr("disabled");
				jQuery("#rd_tkydtto-"+index+"-"+i).removeAttr("disabled");
				jQuery("#tkydtto-"+index+"-"+i).removeAttr("disabled");
				jQuery("#rd_tkygcucrslvlIe1-"+index+"-"+i).removeAttr("disabled");
				jQuery("#rd_tkygcucrslvlIe2-"+index+"-"+i).removeAttr("disabled");
				jQuery("#rd_tkygcucrslvl-"+index+"-"+i).removeAttr("disabled");
				jQuery("#tkygcucrslvl-"+index+"-"+i).removeAttr("disabled");
				//jQuery("#hiddenTranscript").remove();
				
			}
		}
	}
	
	if(componentName == 'ArticulationAgreements'){
		if(jQuery("#articulationAgreementsNA"+index).is(':checked')){
			//for(var i=0;i<=transcriptKeyLength;i++){
				jQuery("#rd_gcuCourseCategoryIe1-"+index).attr("disabled","disabled");
				jQuery("#rd_gcuCourseCategoryIe2-"+index).attr("disabled","disabled");
				jQuery("#rd_institutionDegreeIe1-"+index).attr("disabled","disabled");
				jQuery("#rd_institutionDegreeIe2-"+index).attr("disabled","disabled");
				jQuery("#rd_institutionDegree-"+index).attr("disabled","disabled");
				jQuery("#rd_gcuDegreeIe1-"+index).attr("disabled","disabled");
				jQuery("#rd_gcuDegreeIe2-"+index).attr("disabled","disabled");
				jQuery("#rd_gcuDegree-"+index).attr("disabled","disabled");
				jQuery("#rd_gcuCourseCategory-"+index).attr("disabled","disabled");
				jQuery("#rd_effectiveDateIe1-"+index).attr("disabled","disabled");
				jQuery("#rd_effectiveDateIe2-"+index).attr("disabled","disabled");
				jQuery("#effectiveDate-"+index).attr("disabled","disabled");
				jQuery("#rd_effectiveDate-"+index).attr("disabled","disabled");
				
				document.getElementById("institutionDegree-"+index).value = "";
				document.getElementById("institutionDegree-"+index).setAttribute('disabled',true);
				
				document.getElementById("gcuDegree-"+index).value = "";
				document.getElementById("gcuDegree-"+index).setAttribute('disabled',true);
				
				document.getElementById("rd_gcuCourseCategory-"+index).value = "";
				document.getElementById("rd_gcuCourseCategory-"+index).setAttribute('disabled',true);
				
				document.getElementById("rd_effectiveDate-"+index).value = "";
				document.getElementById("rd_effectiveDate-"+index).setAttribute('disabled',true);
				
				
				//jQuery("#institutionDegree-"+index).attr("disabled",true);
				//jQuery("#gcuDegree-"+index).attr("disabled",true);
				//jQuery("#rd_gcuCourseCategory-"+index).attr("disabled",true);
				//jQuery("#rd_effectiveDate-"+index).attr("disabled",true);
			//}
		}else{
			//for(var i=0;i<=transcriptKeyLength;i++){
				jQuery("#rd_institutionDegreeIe1-"+index).removeAttr("disabled");
				jQuery("#rd_institutionDegreeIe2-"+index).removeAttr("disabled");
				jQuery("#rd_institutionDegree-"+index).attr("disabled","disabled");
				
				jQuery("#rd_gcuDegreeIe2-"+index).removeAttr("disabled");
				jQuery("#rd_gcuDegreeIe1-"+index).removeAttr("disabled");
				jQuery("#rd_gcuDegree-"+index).removeAttr("disabled");

				jQuery("#rd_gcuCourseCategoryIe1-"+index).removeAttr("disabled");
				jQuery("#rd_gcuCourseCategoryIe2-"+index).removeAttr("disabled");
				jQuery("#rd_gcuCourseCategory-"+index).removeAttr("disabled");
				
				jQuery("#rd_effectiveDateIe1-"+index).removeAttr("disabled");
				jQuery("#rd_effectiveDateIe2-"+index).removeAttr("disabled");
				jQuery("#effectiveDate-"+index).removeAttr("disabled");
				jQuery("#rd_effectiveDate-"+index).removeAttr("disabled");
				
				
			//}
		} 
	}
}
</script>

<div id="tabs">
    <%-- <ul>
        <li><a href="#tabs-1">Conflict List</a> <span class="notification">${conflictCount}</span></li>
        <li><a href="#tabs-2" onclick="window.location='/scheduling_system/evaluation/ieManager.html?operation=getCoursesForApproval'">College/Courses Approval</a> <span class="notification">${requiredApprovalCount}</span></li>
        <li><a onclick="window.location='/scheduling_system/evaluation/ieManager.html?operation=getInstitutionList&status=ALL'" href="#tabs-3">Manage Institutions/Courses</a></li>
        <li><a href="#tabs-4" onclick="window.location='/scheduling_system/evaluation/ieManager.html?operation=getCoursesForReAssignment'">Reassign</a></li>
    </ul> --%>
    <div id="tabs-1">
		<div class="course" >
            <!-- Conflict Page 2 Start -->
           <%--  <div class="noti-tools">
                <div class="fl">
                    <div class="breadcrumb">
                    <a title="Home" href="/scheduling_system/evaluation/ieManager.html?operation=managerEvaluationView">Conflict List</a>${institution1.name}</div>
                    </div>
                <br class="clear">
            </div> --%>
            <!-- Conflict Page 2 End -->
            
            <!-- Conflict Content Start -->
            <div class="conflictListCon">
                <div class="conflictHeader">
                	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl" style="margin-bottom:0px;">
                		<tr>
                			<th width="25%" class="dividerGrey"><span>${institution1.name}</span></th>
                			<th width="20%" class="dividerGrey"><span>${institution1.evaluator1.firstName} ${institution1.evaluator1.lastName}</span></th>
                			<th width="20%" class="dividerGrey"><span>${institution2.evaluator1.firstName} ${institution2.evaluator1.lastName}</span></th>
                			<th width="20%" class="dividerGrey"><span>Corrected Data</span></th>
                			<th width="15%" class="dividerGrey"></th>
                		</tr>
                	</table>
                	 
                </div>
                
                <div class="conflictExpander">
                	<form id="conflictInstitutionForm" method="post" action="/scheduling_system/evaluation/ieManager.html?operation=resolveAndSubmitInstitution">
                	<h1 class="expand">Institution Details</h1> 
                    <div class="collapse" style="display:block;"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl5">
                          <tr <c:set var="test" scope="page" value="${institution1.schoolcode == institution2.schoolcode}"/> <c:if test="${!test}">class="alertCourse"</c:if> >
                            <td width="25%"><span>School Code</span></td>
                            <td width="20%"><c:if test="${!test  && not empty institution1.schoolcode}"><input name="rd_schoolcode" type="radio" value="${institution1.schoolcode}" /></c:if> ${institution1.schoolcode}</td>
                            <td width="20%"><c:if test="${!test  && not empty institution2.schoolcode}"><input name="rd_schoolcode" type="radio" value="${institution2.schoolcode}" /></c:if> ${institution2.schoolcode}</td>
                            <td width="20%"><c:if test="${!test}"><input name="rd_schoolcode" type="radio" value="" /></c:if> <input id="schoolcode" <c:choose> <c:when test="${test}"> type="hidden" value="${institution2.schoolcode}"</c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose>  class="txbx required" name="schoolcode"> </td>
                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
                          </tr>
                          <tr>
                          	<td width="25%"><span>Location Type</span></td>
                          	<td width="20%">${institution1.locationId}</td>
                          	<td width="20%">${institution2.locationId}</td>
                          	<td width="20%"><input type="hidden" value="${institution2.locationId}" class="txbx" name="locationId"> </td>
                          	<td width="15%" align="center"></td>
                          </tr>
                          <tr <c:set var="test" scope="page" value="${institution1.name == institution2.name}"/> <c:if test="${!test}">class="alertCourse"</c:if> >
                            <td width="25%"><span>Institution Name</span></td>
                            <td width="20%"><c:if test="${!test && not empty institution1.name}"><input name="rd_name" type="radio" value="${institution1.name}" /></c:if> ${institution1.name}</td>
                            <td width="20%"><c:if test="${!test && not empty institution2.name}"><input name="rd_name" type="radio" value="${institution2.name}" /></c:if> ${institution2.name}</td>
                            <td width="20%"><c:if test="${!test}"><input name="rd_name" type="radio" value="" /></c:if> <input id="name"<c:choose> <c:when test="${test}"> type="hidden" value="${institution2.name}"</c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose>  class="txbx required" name="name">  </td>
                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
                          </tr>
                          <tr>
                          	<td width="25%"><span>Address line 1</span></td>
                          	<td width="20%">${institution1.address1}</td>
                          	<td width="20%">${institution2.address1}</td>
                          	<td width="20%"><input type="hidden" value="${institution2.address1}" class="txbx" name="address1"> </td>
                          	<td width="15%" align="center"></td>
                          </tr>
                          <tr>
                          	<td width="25%"><span>Address line 2</span></td>
                          	<td width="20%">${institution1.address2}</td>
                          	<td width="20%">${institution2.address2}</td>
                          	<td width="20%"><input type="hidden" value="${institution2.address2}" class="txbx" name="address2"> </td>
                          	<td width="15%" align="center"></td>
                          </tr>
                          <tr <c:set var="test" scope="page" value="${institution1.city == institution2.city}"/> <c:if test="${!test}">class="alertCourse"</c:if> >
                            <td width="25%"><span>City</span></td>
                            <td width="20%"><c:if test="${!test && not empty institution1.city}"><input name="rd_city" type="radio" value="${institution1.city}" /></c:if> ${institution1.city}</td>
                            <td width="20%"><c:if test="${!test && not empty institution2.city}"><input name="rd_city" type="radio" value="${institution2.city}" /></c:if> ${institution2.city}</td>
                            <td width="20%"><c:if test="${!test}"><input name="rd_city" type="radio" value="" /></c:if> <input id="city" <c:choose> <c:when test="${test}"> type="hidden" value="${institution2.city}"</c:when> <c:otherwise> type="text"  value=""</c:otherwise></c:choose> class="txbx" name="city"> </td>
                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
                          </tr>
                          <tr <c:set var="test" scope="page" value="${institution1.country.id == institution2.country.id}"/> <c:if test="${!test}">class="alertCourse"</c:if>>
                          	<td width="25%"><span>Country</span></td>
                          	<td width="20%"><c:if test="${!test && not empty institution1.country.id}"><input name="rd_country" type="radio" value="${institution1.country.id}" /></c:if> ${institution1.country.name}</td>
                          	<td width="20%"><c:if test="${!test && not empty institution2.country.id}"><input name="rd_country" type="radio" value="${institution2.country.id}" /></c:if> ${institution2.country.name}</td>
                          	<td width="20%"><c:if test="${!test}"><input name="rd_country" type="radio" value="" /></c:if> 
                          	
                          	 
                          	 <c:choose> 
                          	 <c:when test="${test}">
                          	 <input id="country"  type="hidden" value="${institution2.country.id}"  type="text" value="" class="txbx required" name="country.id">
                          	 </c:when> 
                          	 <c:otherwise>
                          	 <select id="country" name="country.id" class="dd_change">
                          	 <c:forEach items="${countryList}" var="country">
                          	 	<option value="${country.id}">${country.name}</option>
                          	 </c:forEach></select> </c:otherwise></c:choose>
                          	 <input id="country_name"  type="hidden" value="${institution2.country.name}"  type="text" value="" class="txbx required" name="country.name">
                           </td>
                          	<td width="15%" align="center"></td>
                          </tr>
                          <tr <c:set var="test" scope="page" value="${institution1.state == institution2.state}"/> <c:if test="${!test}">class="alertCourse"</c:if> >
                          	<td width="25%"><span>State</span></td>
                          	<td width="20%"><c:if test="${!test && not empty institution1.state}"><input name="rd_state" type="radio" value="${institution1.state}" /></c:if> ${institution1.state}</td>
                          	<td width="20%"><c:if test="${!test && not empty institution2.state}"><input name="rd_state" type="radio" value="${institution2.state}" /></c:if> ${institution2.state}</td>
                          	<td width="20%"><c:if test="${!test}"><input name="rd_state" type="radio" value="" /></c:if> <input <c:choose> <c:when test="${test}"> type="hidden"  value="${institution2.state}"</c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose>class="txbx" name="state" id="state"> </td>
                          	<td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
                          </tr>
                          <tr>
                          	<td width="25%"><span>Zip Code</span></td>
                          	<td width="20%"><c:out value="${institution1.zipcode}"></c:out></td>
                          	<td width="20%">${institution2.zipcode}</td>
                          	<td width="20%"><input type="hidden" value="${institution2.zipcode}" class="txbx" name="zipcode"> </td>
                          	<td width="15%" align="center"></td>
                          </tr>
                          <tr>
                          	<td width="25%"><span>Phone</span></td>
                          	<td width="20%">${institution1.phone}</td>
                          	<td width="20%">${institution2.phone}</td>
							<td width="20%"><input type="hidden" value="${institution2.phone}" class="txbx" name="phone"> </td>
                          	<td width="15%" align="center"></td>
                          </tr>
                          <tr>
                          	<td width="25%"><span>Fax</span></td>
                          	<td width="20%">${institution1.fax}</td>
                          	<td width="20%">${institution2.fax}</td>
                          	<td width="20%"><input type="hidden" value="${institution2.fax}" class="txbx" name="fax"> </td>
                          	<td width="15%" align="center"></td>
                          </tr>
                          <tr>
                          	<td width="25%"><span>Website</span></td>
                          	<td width="20%">${institution1.website}</td>
                          	<td width="20%">${institution2.website}</td>
                          	<td width="20%"><input type="hidden" value="${institution2.website}" class="txbx" name="website"> </td>
                          	<td width="15%" align="center"></td>
                          </tr>
                          <tr <c:set var="test" scope="page" value="${institution1.institutionType.id == institution2.institutionType.id}"/> <c:if test="${!test}">class="alertCourse"</c:if>>
                          	<td width="25%"><span>Institution Type</span></td>
                          	<td width="20%"><c:if test="${!test && not empty institution1.institutionType.id}"><input name="rd_institutionType" type="radio" value="${institution1.institutionType.id}" /></c:if>${institution1.institutionType.name}</td>
                          	<td width="20%"><c:if test="${!test && not empty institution2.institutionType.id}"><input name="rd_institutionType" type="radio" value="${institution2.institutionType.id}" /></c:if>${institution2.institutionType.name}</td>
                          	<td width="20%"><c:if test="${!test}"><input name="rd_institutionType" type="radio" value="" /></c:if> 
                          	
                          	<c:choose> 
                          	 <c:when test="${test}">
                          	 <input id="institutionType"  type="hidden" value="${institution2.institutionType.id}"  type="text" value="" class="txbx required" name="institutionType.id">
                          	 </c:when> 
                          	 <c:otherwise>
                          	 <select id="institutionType" name="institutionType.id" class="dd_change">
                          	 <c:forEach items="${institutionTypeList}" var="institutionType">
                          	 	<option value="${institutionType.id}">${institutionType.name}</option>
                          	 </c:forEach></select> </c:otherwise></c:choose>
                          	 <input id="institutionType_name"  type="hidden" value="${institution2.institutionType.name}"  type="text" value="" class="txbx required" name="institutionType.name">
                          	 </td>
                          	<td width="15%" align="center"></td>
                          </tr>
                          <tr>
                          	<td width="25%"><span>Parent Institute</span></td>
                          	<td width="20%">${institution1.parentInstitutionName}</td>
                          	<td width="20%">${institution2.parentInstitutionName}</td>
                          	<td width="20%"><input type="hidden" value="${institution2.parentInstitutionId}" class="txbx" name="parentInstitutionId"> </td>
                          	<td width="15%" align="center"></td>
                          </tr>
                          
                        </table>
                    </div>
                    
                    <c:choose>
      					<c:when test="${fn:length(institution1.accreditingBodyInstitutes) gt fn:length(institution2.accreditingBodyInstitutes)}">
      						<c:set var="accreditingBodyInstitutes" scope="page" value="${institution1.accreditingBodyInstitutes}"></c:set>
      					</c:when>
      					<c:otherwise>
      						<c:set var="accreditingBodyInstitutes" scope="page" value="${institution2.accreditingBodyInstitutes}"></c:set>
      					</c:otherwise>
      				</c:choose>
      				
      				 <c:forEach items="${accreditingBodyInstitutes}" varStatus="index">
                   		<c:set var="r1a" scope="page" value="${not empty institution1.accreditingBodyInstitutes[index.index]}"></c:set>
                    	<c:set var="r2a" scope="page" value="${not empty institution2.accreditingBodyInstitutes[index.index]}"></c:set>
                    	<h1 class="expand">Accrediting Body</h1>
                    	<div class="collapse" style="display:block;"> 
                    	<div>&nbsp;&nbsp;<input type="checkbox" id="accreditingBodyNA${index.index }" name="accreditingBodyNA" onclick="javascript:disabledGropComponent('${fn:length(accreditingBodyInstitutes)}','${index.index }','0','AccreditingBody');">&nbsp;N/A</div>
	                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl5">
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${institution1.accreditingBodyInstitutes[index.index].accreditingBody.name == institution2.accreditingBodyInstitutes[index.index].accreditingBody.name}"/></c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%"><span>Accrediting Body Name</span></td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test && not empty institution1.accreditingBodyInstitutes[index.index].accreditingBody.name}"><input id="rd_accbdynameIe1-${index.index}" name="rd_accbdyname-${index.index}" type="radio" value="${institution1.accreditingBodyInstitutes[index.index].accreditingBody.id}" /></c:if> ${institution1.accreditingBodyInstitutes[index.index].accreditingBody.name}</c:if> </td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test && not empty institution2.accreditingBodyInstitutes[index.index].accreditingBody.name}"><input id="rd_accbdynameIe2-${index.index}" name="rd_accbdyname-${index.index}" type="radio" value="${institution2.accreditingBodyInstitutes[index.index].accreditingBody.id}" /></c:if> ${institution2.accreditingBodyInstitutes[index.index].accreditingBody.name}</c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_accbdyname-${index.index}" name="rd_accbdyname-${index.index}" type="radio" value="" /></c:if>
	                            <c:choose> 
	                            <c:when test="${test}"><input id="accbdyname-${index.index}"  type="hidden" value="${institution2.accreditingBodyInstitutes[index.index].accreditingBody.id}" type="text" class="txbx required" name="accreditingBodyInstitutes[${index.index}].accreditingBody.id">
	                            </c:when> 
	                            <c:otherwise>
	                            	<select id="accbdyname-${index.index}" style="width:200px;" name="accreditingBodyInstitutes[${index.index}].accreditingBody.id">
		                            	<c:forEach items="${accreditingBodyList}" var="accbdy">
		                            		<option value="${accbdy.id}">${accbdy.name}</option>
		                            	</c:forEach>
	                            	</select> 
	                           </c:otherwise>
	                           </c:choose> </td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                          
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${institution1.accreditingBodyInstitutes[index.index].effectiveDate == institution2.accreditingBodyInstitutes[index.index].effectiveDate}"/> </c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%"><span>Effective Date</span></td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test && not empty institution1.accreditingBodyInstitutes[index.index].effectiveDate}"><input id="rd_accbdyEfDateIe1-${index.index}" name="rd_accbdyEfDate-${index.index}" type="radio" value='${institution1.accreditingBodyInstitutes[index.index].effectiveDate}' /></c:if> ${institution1.accreditingBodyInstitutes[index.index].effectiveDate} </c:if></td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test && not empty institution2.accreditingBodyInstitutes[index.index].effectiveDate}"><input id="rd_accbdyEfDateIe2-${index.index}" name="rd_accbdyEfDate-${index.index}" type="radio" value='${institution2.accreditingBodyInstitutes[index.index].effectiveDate}' /></c:if> ${institution2.accreditingBodyInstitutes[index.index].effectiveDate} </c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_accbdyEfDate-${index.index}" name="rd_accbdyEfDate-${index.index}" type="radio" value="" /></c:if><input id="accbdyEfDate-${index.index}" <c:choose> <c:when test="${test}"> type="hidden" value='${institution2.accreditingBodyInstitutes[index.index].effectiveDate}' </c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose> class="txbx required" name="accreditingBodyInstitutes[${index.index}].effectiveDate"></td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${institution1.accreditingBodyInstitutes[index.index].endDate == institution2.accreditingBodyInstitutes[index.index].endDate}"/> </c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%"><span>End Date</span></td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test && not empty institution1.accreditingBodyInstitutes[index.index].endDate}"><input id="rd_accbdyEndDateIe1-${index.index}" name="rd_accbdyEndDate-${index.index}" type="radio" value='${institution1.accreditingBodyInstitutes[index.index].endDate}' /></c:if> ${institution1.accreditingBodyInstitutes[index.index].endDate} </c:if></td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test && not empty institution2.accreditingBodyInstitutes[index.index].endDate}"><input id="rd_accbdyEndDateIe2-${index.index}" name="rd_accbdyEndDate-${index.index}" type="radio" value='${institution2.accreditingBodyInstitutes[index.index].endDate}' /></c:if> ${institution2.accreditingBodyInstitutes[index.index].endDate} </c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_accbdyEndDate-${index.index}" name="rd_accbdyEndDate-${index.index}" type="radio" value="" /></c:if><input id="accbdyEndDate-${index.index}" <c:choose> <c:when test="${test}"> type="hidden" value='${institution2.accreditingBodyInstitutes[index.index].endDate}' </c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose> class="txbx" name="accreditingBodyInstitutes[${index.index}].endDate"></td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                          
	                        </table>
                   		</div>
                    </c:forEach> 
                    
                    <c:choose>
      					<c:when test="${fn:length(institution1.institutionTermTypes) gt fn:length(institution2.institutionTermTypes)}">
      						<c:set var="institutionTermTypes" scope="page" value="${institution1.institutionTermTypes}"></c:set>
      					</c:when>
      					<c:otherwise>
      						<c:set var="institutionTermTypes" scope="page" value="${institution2.institutionTermTypes}"></c:set>
      					</c:otherwise>
      				</c:choose>
      				
                    <c:forEach items="${institutionTermTypes}" varStatus="index">
                   		<c:set var="r1a" scope="page" value="${not empty institution1.institutionTermTypes[index.index]}"></c:set>
                    	<c:set var="r2a" scope="page" value="${not empty institution2.institutionTermTypes[index.index]}"></c:set>
                    	<h1 class="expand">Term Type</h1>
                    	<div class="collapse" style="display:block;"> 
                    		<div>&nbsp;&nbsp;<input type="checkbox" id="termTypeNA${index.index }" name="termTypeNA" onclick="javascript:disabledGropComponent('${fn:length(institutionTermTypes)}','${index.index }','0','TermType');">&nbsp;N/A</div>
	                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl5">
	                        	                        
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${institution1.institutionTermTypes[index.index].termType.name == institution2.institutionTermTypes[index.index].termType.name}"/></c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%"><span>Term Type Name</span></td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test && not empty institution1.institutionTermTypes[index.index].termType.name}"><input id="rd_ttypnameIe1-${index.index}" name="rd_ttypname-${index.index}" type="radio" value="${institution1.institutionTermTypes[index.index].termType.id}" /></c:if> ${institution1.institutionTermTypes[index.index].termType.name}</c:if> </td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test && not empty institution2.institutionTermTypes[index.index].termType.name}"><input id="rd_ttypnameIe2-${index.index}" name="rd_ttypname-${index.index}" type="radio" value="${institution2.institutionTermTypes[index.index].termType.id}" /></c:if> ${institution2.institutionTermTypes[index.index].termType.name}</c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_ttypname-${index.index}" name="rd_ttypname-${index.index}" type="radio" value="" /></c:if><c:choose> <c:when test="${test}"><input id="ttypname-${index.index}" type="hidden" value="${institution2.institutionTermTypes[index.index].termType.id}" type="text" value="" class="txbx required" name="institutionTermTypes[${index.index}].termType.id"> </c:when> <c:otherwise> <select id="ttypname-${index.index}" name="institutionTermTypes[${index.index}].termType.id"><c:forEach items="${termTypeList}" var="ttyp"><option value="${ttyp.id}">${ttyp.name}</option></c:forEach></select> </c:otherwise></c:choose> </td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                          
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${institution1.institutionTermTypes[index.index].effectiveDate == institution2.institutionTermTypes[index.index].effectiveDate}"/> </c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%"><span>Effective Date</span></td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test && not empty institution1.institutionTermTypes[index.index].effectiveDate}"><input id="rd_ttypEfDateIe1-${index.index}" name="rd_ttypEfDate-${index.index}" type="radio" value='<fmt:formatDate value="${institution1.institutionTermTypes[index.index].effectiveDate}" pattern="MM/dd/yyyy"/>' /></c:if> <fmt:formatDate value="${institution1.institutionTermTypes[index.index].effectiveDate}" pattern="MM/dd/yyyy"/> </c:if></td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test && not empty institution2.institutionTermTypes[index.index].effectiveDate}"><input id="rd_ttypEfDateIe2-${index.index}" name="rd_ttypEfDate-${index.index}" type="radio" value='<fmt:formatDate value="${institution2.institutionTermTypes[index.index].effectiveDate}" pattern="MM/dd/yyyy"/>' /></c:if> <fmt:formatDate value="${institution2.institutionTermTypes[index.index].effectiveDate}" pattern="MM/dd/yyyy"/> </c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_ttypEfDate-${index.index}" name="rd_ttypEfDate-${index.index}" type="radio" value="" /></c:if><input id="ttypEfDate-${index.index}" <c:choose> <c:when test="${test}"> type="hidden" value='<fmt:formatDate value="${institution2.institutionTermTypes[index.index].effectiveDate}" pattern="MM/dd/yyyy"/>' </c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose> class="txbx maskDate required" name="institutionTermTypes[${index.index}].effectiveDate"></td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${institution1.institutionTermTypes[index.index].endDate == institution2.institutionTermTypes[index.index].endDate}"/> </c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%"><span>End Date</span></td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test && not empty institution1.institutionTermTypes[index.index].endDate}"><input id="rd_ttypEndDateIe1-${index.index}" name="rd_ttypEndDate-${index.index}" type="radio" value='<fmt:formatDate value="${institution1.institutionTermTypes[index.index].endDate}" pattern="MM/dd/yyyy"/>' /></c:if> <fmt:formatDate value="${institution1.institutionTermTypes[index.index].endDate}" pattern="MM/dd/yyyy"/> </c:if></td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test && not empty institution2.institutionTermTypes[index.index].endDate}"><input id="rd_ttypEndDateIe2-${index.index}" name="rd_ttypEndDate-${index.index}" type="radio" value='<fmt:formatDate value="${institution2.institutionTermTypes[index.index].endDate}" pattern="MM/dd/yyyy"/>' /></c:if> <fmt:formatDate value="${institution2.institutionTermTypes[index.index].endDate}" pattern="MM/dd/yyyy"/> </c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_ttypEndDate-${index.index}" name="rd_ttypEndDate-${index.index}" type="radio" value="" /></c:if><input id="ttypEndDate-${index.index}" <c:choose> <c:when test="${test}"> type="hidden" value='<fmt:formatDate value="${institution2.institutionTermTypes[index.index].endDate}" pattern="MM/dd/yyyy"/>' </c:when> <c:otherwise> type="text" value=""</c:otherwise></c:choose> class="txbx maskDate" name="institutionTermTypes[${index.index}].endDate"></td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                          
	                        </table>
                   		</div>
                    </c:forEach>
                    
                    <c:choose>
      					<c:when test="${fn:length(institution1.institutionTranscriptKeys) gt fn:length(institution2.institutionTranscriptKeys)}">
      						<c:set var="institutionTranscriptKeys" scope="page" value="${institution1.institutionTranscriptKeys}"></c:set>
      					</c:when>
      					<c:otherwise>
      						<c:set var="institutionTranscriptKeys" scope="page" value="${institution2.institutionTranscriptKeys}"></c:set>
      					</c:otherwise>
      				</c:choose>
      				
                    <c:forEach items="${institutionTranscriptKeys}" varStatus="index">
                   		<c:set var="r1a" scope="page" value="${not empty institution1.institutionTranscriptKeys[index.index]}"></c:set>
                    	<c:set var="r2a" scope="page" value="${not empty institution2.institutionTranscriptKeys[index.index]}"></c:set>
                    	<h1 class="expand">Transcript Key</h1>
                    	 <c:choose>
	                          	<c:when test="${!r1a}">
	                          		<c:set var="institutionTranscriptKeyDetailsList" scope="page" value="${institution2.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList}"></c:set>
	                          	</c:when>
	                          	<c:when test="${!r2a}">
	                          		<c:set var="institutionTranscriptKeyDetailsList" scope="page" value="${institution1.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList}"></c:set>
	                          	</c:when>
	                          	<c:otherwise>
	                          		<c:choose>
      									<c:when test="${fn:length(institution1.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList) gt fn:length(institution2.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList)}">
      										<c:set var="institutionTranscriptKeyDetailsList" scope="page" value="${institution1.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList}"></c:set>
      									</c:when>
      									<c:otherwise>
      										<c:set var="institutionTranscriptKeyDetailsList" scope="page" value="${institution2.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList}"></c:set>
      									</c:otherwise>
      						  		</c:choose>
	                          	</c:otherwise>
	                      </c:choose>
                    	<div class="collapse" style="display:block;"> 
                    	<div>&nbsp;&nbsp;<input type="checkbox" id="transcriptKeyNA${index.index }" name="transcriptKeyNA" onclick="javascript:disabledGropComponent('${fn:length(institutionTranscriptKeys)}','${index.index }','${fn:length(institutionTranscriptKeyDetailsList)-1}','TranscriptKey');">&nbsp;N/A</div>
	                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl5">
	                         
	                          
      						  <tr>
      						  	<td colspan=5>
      						  	<c:forEach var="i" begin="0" end="${fn:length(institutionTranscriptKeyDetailsList)-1}">
      						  		
      						  		<c:choose><c:when test="${!r1a}"><c:set var="r11a" scope="page" value="false"></c:set></c:when><c:otherwise><c:set var="r11a" scope="page" value="${not empty institution1.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i]}"></c:set></c:otherwise></c:choose>
			                    	<c:choose><c:when test="${!r2a}"><c:set var="r22a" scope="page" value="false"></c:set></c:when><c:otherwise><c:set var="r22a" scope="page" value="${not empty institution2.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i]}"></c:set></c:otherwise> </c:choose>
      						   		<h2>Key Detail #${i+1}</h2>
      						   		<table width="100%" border="0" cellspacing="0" cellpadding="0">
      						   		
      						   			<tr <c:choose> <c:when test="${r11a && r22a}"> <c:set var="test1" scope="page" value="${institution1.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].from == institution2.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].from}"/> </c:when> <c:otherwise> <c:set var="test1" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test1 || not r11a || not r22a}">class="alertCourse"</c:if>>
      						   				<td width="25%"><span>From</span></td>
				                            <td width="20%"><c:if test="${r11a}"> <c:if test="${!test1 && not empty institution1.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].from}"><input id="rd_tkydtfrmIe1-${index.index}-${i}" name="rd_tkydtfrm-${index.index}-${i}" type="radio" value='${institution1.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].from}' /></c:if> ${institution1.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].from} </c:if></td>
				                            <td width="20%"><c:if test="${r22a}"> <c:if test="${!test1 && not empty institution2.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].from}"><input id="rd_tkydtfrmIe2-${index.index}-${i}" name="rd_tkydtfrm-${index.index}-${i}" type="radio" value='${institution2.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].from}' /></c:if> ${institution2.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].from} </c:if></td>
				                            <td width="20%"><c:if test="${!test1}"><input id="rd_tkydtfrm-${index.index}-${i}" name="rd_tkydtfrm-${index.index}-${i}" type="radio" value="" /></c:if>
				                           
				                            <c:choose> 
				                            	<c:when test="${test1}">  <input id="tkydtfrm-${index.index}-${i}" type="hidden" 
				                            		value="${institution2.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].from}" class="txbx required" name="institutionTranscriptKeys[${index.index}].institutionTranscriptKeyDetailsList[${i}].from"/>
				                            	</c:when>
				                             	<c:otherwise>
				                             		  <input id="tkydtfrm-${index.index}-${i}" type="text" value="" class="txbx required" name="institutionTranscriptKeys[${index.index}].institutionTranscriptKeyDetailsList[${i}].from"/>
				                             	</c:otherwise>
				                             </c:choose> 
				                             
				                             </td>
				                            <td width="15%" align="center"><c:if test="${!test1}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
      						   			</tr>
      						   			<tr <c:choose> <c:when test="${r11a && r22a}"> <c:set var="test1" scope="page" value="${institution1.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].to == institution2.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].to}"/> </c:when> <c:otherwise> <c:set var="test1" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test1 || not r11a || not r22a}">class="alertCourse"</c:if>>
      						   				<td width="25%"><span>To</span></td>
				                            <td width="20%"><c:if test="${r11a}"> <c:if test="${!test1 && not empty institution1.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].to}"><input id="rd_tkydttoIe1-${index.index}-${i}" name="rd_tkydtto-${index.index}-${i}" type="radio" value='${institution1.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].to}' /></c:if> ${institution1.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].to} </c:if></td>
				                            <td width="20%"><c:if test="${r22a}"> <c:if test="${!test1 && not empty institution2.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].to}"><input id="rd_tkydttoIe2-${index.index}-${i}" name="rd_tkydtto-${index.index}-${i}" type="radio" value='${institution2.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].to}' /></c:if> ${institution2.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].to} </c:if></td>
				                            <td width="20%"><c:if test="${!test1}"><input id="rd_tkydtto-${index.index}-${i}" name="rd_tkydtto-${index.index}-${i}" type="radio" value="" /></c:if> 
				                            <c:choose> 
				                            	<c:when test="${test1}"> <input id="tkydtto-${index.index}-${i}" type="hidden" 
				                            		value="${institution2.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].to}" class="txbx required" name="institutionTranscriptKeys[${index.index}].institutionTranscriptKeyDetailsList[${i}].to"/>
				                            	</c:when> 
				                            	<c:otherwise>
				                            		<input id="tkydtto-${index.index}-${i}" type="text" value="" class="txbx required" name="institutionTranscriptKeys[${index.index}].institutionTranscriptKeyDetailsList[${i}].to"/>
				                            	</c:otherwise>
				                            </c:choose>
				                            
				                            </td>
				                            <td width="15%" align="center"><c:if test="${!test1}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
      						   			</tr>
      						   			<tr >
      						   				<td width="25%"><span>GCU Course Level</span></td>
				                            <td width="20%"><c:if test="${r11a}"> <c:if test="${!test1 && not empty institution1.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].gcuCourseLevel.id}"><input id="rd_tkygcucrslvlIe1-${index.index}-${i}" name="rd_tkygcucrslvl-${index.index}-${i}" type="radio" value='${institution1.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].gcuCourseLevel.id}' /></c:if> ${institution1.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].gcuCourseLevel.name} </c:if></td>
				                            <td width="20%"><c:if test="${r22a}"> <c:if test="${!test1 && not empty institution2.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].gcuCourseLevel.id}"><input id="rd_tkygcucrslvlIe2-${index.index}-${i}" name="rd_tkygcucrslvl-${index.index}-${i}" type="radio" value='${institution2.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].gcuCourseLevel.id}' /></c:if> ${institution2.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].gcuCourseLevel.name} </c:if></td>
				                            <td width="20%"><c:if test="${!test1}"><input id="rd_tkygcucrslvl-${index.index}-${i}" name="rd_tkygcucrslvl-${index.index}-${i}" type="radio" value="" /></c:if><c:choose>
				                             <c:when test="${test1}">
				                             <input  id="tkygcucrslvl-${index.index}-${i}" type="hidden" 
				                             value="${institution2.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].gcuCourseLevel.id}"
				                              class="txbx" name="institutionTranscriptKeys[${index.index}].institutionTranscriptKeyDetailsList[${i}].gcuCourseLevel.id"> 
				                              </c:when> 
				                              <c:otherwise> <select class="dd_change" id="tkygcucrslvl-${index.index}-${i}" name="institutionTranscriptKeys[${index.index}].institutionTranscriptKeyDetailsList[${i}].gcuCourseLevel.id"><c:forEach items="${gcuCourseLevelList}" var="gcl"><option value="${gcl.id}">${gcl.name}</option></c:forEach></select></c:otherwise></c:choose>
				                               <input  id="tkygcucrslvl-${index.index}-${i}_name" type="hidden" 
				                             value="${institution2.institutionTranscriptKeys[index.index].institutionTranscriptKeyDetailsList[i].gcuCourseLevel.name}"
				                              class="txbx" name="institutionTranscriptKeys[${index.index}].institutionTranscriptKeyDetailsList[${i}].gcuCourseLevel.name" /> 
				                              
				                              </td>
				                             
				                              
				                            <td width="15%" align="center"><c:if test="${!test1}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
      						   			</tr>
      						   		</table> 
      						  	</c:forEach>
      						  	</td>
      						  </tr>
	                          <tr>
	                            <td width="25%"><span>Effective Date</span></td>
	                            <td width="20%"><fmt:formatDate value="${institution1.institutionTranscriptKeys[index.index].effectiveDate}" pattern="MM/dd/yyyy"/></td>
	                            <td width="20%"><fmt:formatDate value="${institution2.institutionTranscriptKeys[index.index].effectiveDate}" pattern="MM/dd/yyyy"/></td>
	                            <td width="20%"><input type="hidden" value='<fmt:formatDate value="${institution1.institutionTranscriptKeys[index.index].effectiveDate}" pattern="MM/dd/yyyy"/>' class="txbx" name="institutionTranscriptKeys[${index.index}].effectiveDate" id="idInstitutionTranscriptKeys[${index.index}].effectiveDate"></td>
	                            <td width="15%" align="center"></td>
	                          </tr>
	                          <tr>
	                            <td width="25%"><span>End Date</span></td>
	                            <td width="20%"><fmt:formatDate value="${institution1.institutionTranscriptKeys[index.index].endDate}" pattern="MM/dd/yyyy"/></td>
	                            <td width="20%"><fmt:formatDate value="${institution2.institutionTranscriptKeys[index.index].endDate}" pattern="MM/dd/yyyy"/></td>
	                            <td width="20%"><input type="hidden" value='<fmt:formatDate value="${institution2.institutionTranscriptKeys[index.index].endDate}" pattern="MM/dd/yyyy"/>' class="txbx" name="institutionTranscriptKeys[${index.index}].endDate" id="idInstitutionTranscriptKeys[${index.index}].endDate"></td>
	                            <td width="15%" align="center"></td>
	                          </tr>
	                          
	                        </table>
                   		</div>
                    </c:forEach>
                     <c:choose>
      					<c:when test="${fn:length(institution1.articulationAgreements) gt fn:length(institution2.articulationAgreements)}">
      						<c:set var="articulationAgreements" scope="page" value="${institution1.articulationAgreements}"></c:set>
      					</c:when>
      					<c:otherwise>
      						<c:set var="articulationAgreements" scope="page" value="${institution2.articulationAgreements}"></c:set>
      					</c:otherwise>
      				</c:choose>
      				
      				<%--  <c:forEach items="${articulationAgreements}" varStatus="index">
                   		<c:set var="r1a" scope="page" value="${not empty institution1.articulationAgreements[index.index]}"></c:set>
                    	<c:set var="r2a" scope="page" value="${not empty institution2.articulationAgreements[index.index]}"></c:set>
                    	<h1 class="expand">Articulation Agreement</h1>
                    	<div class="collapse" style="display:block;"> 
                    	<div>&nbsp;&nbsp;<input type="checkbox" id="articulationAgreementsNA${index.index }" name="articulationAgreementsNA" onclick="javascript:disabledGropComponent('${fn:length(articulationAgreements)}','${index.index }','0','ArticulationAgreements');">&nbsp;N/A</div>
	                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl5">
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${institution1.articulationAgreements[index.index].institutionDegree == institution2.articulationAgreements[index.index].institutionDegree}"/></c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%"><span>Other Institution Degree</span></td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test}"><input id="rd_institutionDegreeIe1-${index.index}" name="rd_institutionDegree-${index.index}" type="radio" value="${institution1.articulationAgreements[index.index].institutionDegree}" /></c:if> ${institution1.articulationAgreements[index.index].institutionDegree}</c:if> </td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test}"><input id="rd_institutionDegreeIe2-${index.index}" name="rd_institutionDegree-${index.index}" type="radio" value="${institution2.articulationAgreements[index.index].institutionDegree}" /></c:if> ${institution2.articulationAgreements[index.index].institutionDegree}</c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_institutionDegree-${index.index}" name="rd_institutionDegree-${index.index}" type="radio" value="" /></c:if>
		                            <c:choose> 
		                            	<c:when test="${test}"><input id="institutionDegree-${index.index}"  type="hidden" value="${institution2.articulationAgreements[index.index].institutionDegree}" class="txbx required" name="articulationAgreements[${index.index}].institutionDegree">
		                            </c:when> 
		                            <c:otherwise>	                            
		                            	<input type="text" name="articulationAgreements[${index.index}].institutionDegree" id="institutionDegree-${index.index}" class="txbx required">
		                           </c:otherwise>
		                           </c:choose> 
	                           </td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${institution1.articulationAgreements[index.index].gcuDegree == institution2.articulationAgreements[index.index].gcuDegree}"/></c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%"><span>GCU Degree</span></td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test}"><input id="rd_gcuDegreeIe1-${index.index}" name="rd_gcuDegree-${index.index}" type="radio" value="${institution1.articulationAgreements[index.index].gcuDegree}" /></c:if> ${institution1.articulationAgreements[index.index].gcuDegree}</c:if> </td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test}"><input id="rd_gcuDegreeIe2-${index.index}" name="rd_gcuDegree-${index.index}" type="radio" value="${institution2.articulationAgreements[index.index].gcuDegree}" /></c:if> ${institution2.articulationAgreements[index.index].gcuDegree}</c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_gcuDegree-${index.index}" name="rd_gcuDegree-${index.index}" type="radio" value="" /></c:if>
		                            <c:choose> 
		                            	<c:when test="${test}"><input id="gcuDegree-${index.index}"  type="hidden" value="${institution2.articulationAgreements[index.index].institutionDegree}" class="txbx required" name="articulationAgreements[${index.index}].gcuDegree">
		                            </c:when> 
		                            <c:otherwise>	                            
		                            	<input type="text" name="articulationAgreements[${index.index}].gcuDegree" id="gcuDegree-${index.index}" class="txbx required">
		                           </c:otherwise>
		                           </c:choose> 
	                           </td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                          
	                          <c:forEach items="${articulationAgreements[index.index].articulationAgreementDetailsList}" var="articulationAgreementDetail" varStatus="detailIndex">
	                          	<tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${institution1.articulationAgreements[index.index].articulationAgreementDetailsList[detailIndex.index].gcuCourseCategory == institution2.articulationAgreements[index.index].articulationAgreementDetailsList[detailIndex.index].gcuCourseCategory}"/></c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%"><span>GCU Course Category </span></td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test}"><input id="rd_gcuCourseCategoryIe1-${index.index}" name="rd_gcuCourseCategory-${index.index}" type="radio" value='${institution1.articulationAgreements[index.index].articulationAgreementDetailsList[detailIndex.index].gcuCourseCategory}' /></c:if> ${institution1.articulationAgreements[index.index].articulationAgreementDetailsList[detailIndex.index].gcuCourseCategory}</c:if> </td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test}"><input id="rd_gcuCourseCategoryIe2-${index.index}" name="rd_gcuCourseCategory-${index.index}" type="radio" value='${institution2.articulationAgreements[index.index].articulationAgreementDetailsList[detailIndex.index].gcuCourseCategory}' /></c:if> ${institution2.articulationAgreements[index.index].articulationAgreementDetailsList[detailIndex.index].gcuCourseCategory}</c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_gcuCourseCategory-${index.index}" name="rd_gcuCourseCategory-${index.index}" type="radio" value="" /></c:if>
		                            <c:choose> 
		                            	<c:when test="${test}"><input id="rd_gcuCourseCategory-${index.index}"  type="hidden" value="${institution2.articulationAgreements[index.index].articulationAgreementDetailsList[detailIndex.index].gcuCourseCategory}" type="text" class="txbx required" name="articulationAgreements[${index.index}].articulationAgreementDetailsList[${detailIndex.index}].gcuCourseCategory">
		                            </c:when> 
		                            <c:otherwise>	                            
		                            	<select id="gcuCourseCategory-${index.index}" name="articulationAgreements[${index.index}].articulationAgreementDetailsList[${detailIndex.index }].gcuCourseCategory" class="dd_change required">
		                            		<option value="">Select GCU Course Category</option>
		                            	<c:forEach items="${gcuCourseCategoryList }" var="artiGcuCourseCategory">
		                            		<option value="${artiGcuCourseCategory.name}">${artiGcuCourseCategory.name }</option>
		                            	</c:forEach>
		                            	
		                            	</select>
		                           </c:otherwise>
		                           </c:choose> 
	                           </td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                          </c:forEach>
	                          <tr <c:choose> <c:when test="${r1a && r2a}"> <c:set var="test" scope="page" value="${institution1.articulationAgreements[index.index].effectiveDate == institution2.articulationAgreements[index.index].effectiveDate}"/></c:when> <c:otherwise> <c:set var="test" scope="page" value="false"/> </c:otherwise> </c:choose> <c:if test="${not test || not r1a || not r2a}">class="alertCourse"</c:if> >
	                            <td width="25%"><span>Effective Date</span></td>
	                            <td width="20%"><c:if test="${r1a}"> <c:if test="${!test}"><input id="rd_effectiveDateIe1-${index.index}" name="rd_effectiveDate-${index.index}" type="radio" value='<fmt:formatDate value="${institution1.articulationAgreements[index.index].effectiveDate}" pattern="MM/dd/yyyy"/>' /></c:if> <fmt:formatDate value="${institution1.articulationAgreements[index.index].effectiveDate}" pattern="MM/dd/yyyy"/></c:if> </td>
	                            <td width="20%"><c:if test="${r2a}"> <c:if test="${!test}"><input id="rd_effectiveDateIe2-${index.index}" name="rd_effectiveDate-${index.index}" type="radio" value='<fmt:formatDate value="${institution2.articulationAgreements[index.index].effectiveDate}" pattern="MM/dd/yyyy"/>' /></c:if> <fmt:formatDate value="${institution2.articulationAgreements[index.index].effectiveDate}" pattern="MM/dd/yyyy"/></c:if></td>
	                            <td width="20%"><c:if test="${!test}"><input id="rd_effectiveDate-${index.index}" name="rd_effectiveDate-${index.index}" type="radio" value="" /></c:if>
		                            <c:choose> 
		                            	<c:when test="${test}"><input id="rd_effectiveDate-${index.index}"  type="hidden" value="${institution2.articulationAgreements[index.index].effectiveDate}" class="txbx required" name="articulationAgreements[${index.index}].effectiveDate">
		                            </c:when> 
		                            <c:otherwise>	                            
		                            	<input type="text" name="articulationAgreements[${index.index}].effectiveDate" id="effectiveDate-${index.index}" class="txbx maskDate valid">
		                           </c:otherwise>
		                           </c:choose> 
	                           </td>
	                            <td width="15%" align="center"><c:if test="${!test}"><img src="../images/alertIcon.png" width="16" height="14" alt="" /></c:if></td>
	                          </tr>
	                        </table>
                   		</div>
                    </c:forEach>  --%>
                    <c:forEach items="${articulationAgreements}" varStatus="index">
                   		<c:set var="r1a" scope="page" value="${not empty institution1.articulationAgreements[index.index]}"></c:set>
                    	<c:set var="r2a" scope="page" value="${not empty institution2.articulationAgreements[index.index]}"></c:set>
                    	<c:choose> 
                    		<c:when test="${r1a && r2a}"> 
                    			<c:set var="test" scope="page" value="${institution1.articulationAgreements[index.index].institutionDegree == institution2.articulationAgreements[index.index].institutionDegree}"/>
                    		</c:when> 
	                    	<c:otherwise> 
	                    		<c:set var="test" scope="page" value="false"/> 
	                    	</c:otherwise> 
                    	</c:choose>
                    	<h1 class="expand">Articulation Agreement</h1>
                    	<div class="collapse" style="display:block;"> 
                    	<%-- <div>&nbsp;&nbsp;<input type="checkbox" id="articulationAgreementsNA${index.index }" name="articulationAgreementsNA" onclick="javascript:disabledGropComponent('${fn:length(articulationAgreements)}','${index.index }','0','ArticulationAgreements');">&nbsp;N/A</div> --%>
	                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl5">
	                          <tr>
	                            <td width="25%"><span>Other Institution Degree</span></td>
	                            <td width="20%">${institution1.articulationAgreements[index.index].institutionDegree}</td>
	                            <td width="20%">${institution2.articulationAgreements[index.index].institutionDegree}</td>
	                            <td width="20%">
		                            <c:choose> 
		                            	<c:when test="${test}">
		                            		<input id="institutionDegree-${index.index}"  type="hidden" value="${institution2.articulationAgreements[index.index].institutionDegree}" class="txbx" name="articulationAgreements[${index.index}].institutionDegree">
		                            	</c:when> 
		                            <c:otherwise>
			                            <c:choose>
			                            	<c:when test="${r1a && r2a}"> 
			                            		<input id="institutionDegree-${index.index}"  type="hidden" value="${institution1.articulationAgreements[index.index].institutionDegree}" class="txbx" name="articulationAgreements[${index.index}].institutionDegree">
			                            	</c:when>
			                            	<c:otherwise>
				                            	<c:choose>
					                            	<c:when test="${r1a}">
						                            	 <input id="institutionDegree-${index.index}"  type="hidden" value="${institution1.articulationAgreements[index.index].institutionDegree}" class="txbx" name="articulationAgreements[${index.index}].institutionDegree">
						                            </c:when>
						                             <c:otherwise>	
			                            	 				<input id="institutionDegree-${index.index}"  type="hidden" value="${institution2.articulationAgreements[index.index].institutionDegree}" class="txbx" name="articulationAgreements[${index.index}].institutionDegree">
						                             </c:otherwise> 
					                            </c:choose>
				                            </c:otherwise> 
			                            </c:choose>
		                           </c:otherwise>
		                           </c:choose>
	                           </td>
	                            <td width="15%" align="center"></td>
	                          </tr>
	                          <tr>
	                          <c:choose> 
		                          	<c:when test="${r1a && r2a}"> 
		                          		<c:set var="test" scope="page" value="${institution1.articulationAgreements[index.index].gcuDegree == institution2.articulationAgreements[index.index].gcuDegree}"/>
		                          	</c:when> 
		                          	<c:otherwise> 
		                          		<c:set var="test" scope="page" value="false"/> 
		                          	</c:otherwise> 
	                          	</c:choose>
	                            <td width="25%"><span>GCU Degree</span></td>
	                            <td width="20%">${institution1.articulationAgreements[index.index].gcuDegree} </td>
	                            <td width="20%">${institution2.articulationAgreements[index.index].gcuDegree}</td>
	                            <td width="20%">
		                           <c:choose> 
		                            	<c:when test="${test}">
		                            		<input id="gcuDegree-${index.index}"  type="hidden" value="${institution2.articulationAgreements[index.index].gcuDegree}" class="txbx" name="articulationAgreements[${index.index}].gcuDegree">
		                            	</c:when> 
		                            <c:otherwise>
		                            <c:choose>
		                            	<c:when test="${r1a && r2a}"> 
		                            		<input id="gcuDegree-${index.index}"  type="hidden" value="${institution2.articulationAgreements[index.index].gcuDegree}" class="txbx" name="articulationAgreements[${index.index}].gcuDegree">
		                            	</c:when>
		                            	<c:otherwise>
			                            	<c:choose>
				                            	<c:when test="${r1a}">	
				                            	 	<input id="gcuDegree-${index.index}"  type="hidden" value="${institution2.articulationAgreements[index.index].gcuDegree}" class="txbx" name="articulationAgreements[${index.index}].gcuDegree">
				                            	</c:when>
				                            
			                            	<c:otherwise>	
			                            	 	<input id="gcuDegree-${index.index}"  type="hidden" value="${institution2.articulationAgreements[index.index].gcuDegree}" class="txbx" name="articulationAgreements[${index.index}].gcuDegree">
			                            	</c:otherwise>		                            	 
		                            		</c:choose>
		                            	</c:otherwise>                
		                            	
		                            	</c:choose>
		                           </c:otherwise>
		                           </c:choose> 
	                           </td>
	                            <td width="15%" align="center"></td>
	                          </tr>
	                          
	                          <c:forEach items="${articulationAgreements[index.index].articulationAgreementDetailsList}" var="articulationAgreementDetail" varStatus="detailIndex">
	                          	<c:choose> 
	                          		<c:when test="${r1a && r2a}"> 
	                          			<c:set var="test" scope="page" value="${institution1.articulationAgreements[index.index].articulationAgreementDetailsList[detailIndex.index].gcuCourseCategory == institution2.articulationAgreements[index.index].articulationAgreementDetailsList[detailIndex.index].gcuCourseCategory}"/>
	                          		</c:when> 
		                          	<c:otherwise> 
		                          		<c:set var="test" scope="page" value="false"/> 
		                          	</c:otherwise> 
	                          	</c:choose>
	                          	<tr>
	                            <td width="25%"><span>GCU Course Category </span></td>
	                            <td width="20%">${institution1.articulationAgreements[index.index].articulationAgreementDetailsList[detailIndex.index].gcuCourseCategory}</td>
	                            <td width="20%">${institution2.articulationAgreements[index.index].articulationAgreementDetailsList[detailIndex.index].gcuCourseCategory}</td>
	                            <td width="20%">
	                            
		                         <c:choose> 
		                            	<c:when test="${test}">
		                            		<input id="rd_gcuCourseCategory-${index.index}"  type="hidden" value="${institution2.articulationAgreements[index.index].articulationAgreementDetailsList[detailIndex.index].gcuCourseCategory}" type="text" class="txbx" name="articulationAgreements[${index.index}].articulationAgreementDetailsList[${detailIndex.index}].gcuCourseCategory">
		                           		 </c:when> 
		                            <c:otherwise>
		                            <c:choose>
		                            	<c:when test="${r1a && r2a}"> 
		                            		<input id="rd_gcuCourseCategory-${index.index}"  type="hidden" value="${institution1.articulationAgreements[index.index].articulationAgreementDetailsList[detailIndex.index].gcuCourseCategory}" type="text" class="txbx" name="articulationAgreements[${index.index}].articulationAgreementDetailsList[${detailIndex.index}].gcuCourseCategory">
		                            	</c:when>
		                            	<c:otherwise>
			                            	<c:choose>
				                            	<c:when test="${r1a}">	
				                            	 	<input id="rd_gcuCourseCategory-${index.index}"  type="hidden" value="${institution1.articulationAgreements[index.index].articulationAgreementDetailsList[detailIndex.index].gcuCourseCategory}" type="text" class="txbx" name="articulationAgreements[${index.index}].articulationAgreementDetailsList[${detailIndex.index}].gcuCourseCategory">
				                            	</c:when>
				                            	<c:otherwise>	
				                            	 	<input id="rd_gcuCourseCategory-${index.index}"  type="hidden" value="${institution2.articulationAgreements[index.index].articulationAgreementDetailsList[detailIndex.index].gcuCourseCategory}" type="text" class="txbx" name="articulationAgreements[${index.index}].articulationAgreementDetailsList[${detailIndex.index}].gcuCourseCategory">
				                            	</c:otherwise> 		                            	 
			                            	</c:choose>
		                            	</c:otherwise>                
		                            	
		                            	</c:choose>
		                           </c:otherwise>
		                           </c:choose>  
	                           </td>
	                            <td width="15%" align="center"></td>
	                          </tr>
	                          </c:forEach>
	                          <tr>
	                          	 <c:choose> 
	                          	 	<c:when test="${r1a && r2a}">
	                          	 		 <c:set var="test" scope="page" value="${institution1.articulationAgreements[index.index].effectiveDate == institution2.articulationAgreements[index.index].effectiveDate}"/>
	                          	 	</c:when> 
	                          		<c:otherwise> 
	                          			<c:set var="test" scope="page" value="false"/> 
	                          		</c:otherwise> 
	                           </c:choose> 
	                            <td width="25%"><span>Effective Date</span></td>
	                            <td width="20%"><fmt:formatDate value="${institution1.articulationAgreements[index.index].effectiveDate}" pattern="MM/dd/yyyy"/></td>
	                            <td width="20%"><fmt:formatDate value="${institution2.articulationAgreements[index.index].effectiveDate}" pattern="MM/dd/yyyy"/></td>
	                            <td width="20%">
		                           <c:choose> 
		                            	<c:when test="${test}">
		                            		<input id="rd_effectiveDate-${index.index}"  type="hidden" value='<fmt:formatDate value="${institution2.articulationAgreements[index.index].effectiveDate}" pattern="MM/dd/yyyy"/>' class="txbx" name="articulationAgreements[${index.index}].effectiveDate">
		                            	</c:when> 
		                            <c:otherwise>	                            
		                            	 <c:choose>
			                            	<c:when test="${r1a && r2a}"> 
			                            		<input id="rd_effectiveDate-${index.index}"  type="hidden" value='<fmt:formatDate value="${institution2.articulationAgreements[index.index].effectiveDate}" pattern="MM/dd/yyyy"/>' class="txbx" name="articulationAgreements[${index.index}].effectiveDate">
			                            	</c:when>
			                            	<c:otherwise>
			                            		<c:choose> 
					                            	<c:when test="${r1a}">	
					                            		<input id="rd_effectiveDate-${index.index}"  type="hidden" value='<fmt:formatDate value="${institution1.articulationAgreements[index.index].effectiveDate}" pattern="MM/dd/yyyy"/>' class="txbx" name="articulationAgreements[${index.index}].effectiveDate">
					                            	 	
					                            	</c:when>
					                            	<c:otherwise>	
					                            	 	<input id="rd_effectiveDate-${index.index}"  type="hidden" value='<fmt:formatDate value="${institution2.articulationAgreements[index.index].effectiveDate}" pattern="MM/dd/yyyy"/>' class="txbx" name="articulationAgreements[${index.index}].effectiveDate">
					                            	</c:otherwise>		                            	 
			                            		</c:choose>	
			                            	</c:otherwise>                
		                            	
		                            	</c:choose>
		                           </c:otherwise>
		                           </c:choose>
	                           </td>
	                            <td width="15%" align="center"></td>
	                          </tr>
	                        </table>
                   		</div>
                    
                    </c:forEach>
                    <input type="hidden" value="${institution1.id}" name="institutionId"/>
                    <div id="forHiddenField">
                    
                    </div>
                    <br class="clear"/>
                    
                    <div class="fr mt10 mb10 mr10">
                		<input type="submit" value="Resolve Conflict"/>
                	</div>
                    <br class="clear"/>
                    </form>
				</div>
			</div>
		</div>
	</div>
                    <div id="tabs-2"></div>
                    <div id="tabs-3"></div>
                    <div id="tabs-4"></div>
                    </div>
                    


