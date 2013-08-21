<%@include file="../init.jsp" %>

<link rel="stylesheet" href="<c:url value="/css/schSysStylesheet.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/boxy.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/popup.css"/>" />
<%-- <script type='text/javascript' src="<c:url value="/js/jquery.maskedinput-1.3.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/dateValidation.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.core.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.widget.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.position.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.autocomplete.js"/>"></script> 
 --%>

 <script type="text/javascript" src="<c:url value="/js/jquery.validate.js"/>"></script>
  <script type='text/javascript' src="<c:url value='/js/jquery.maskedinput-1.3.js'/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery-1.8.2.js"/>" ></script> 
<script type="text/javascript" src="<c:url value="/js/jquery-ui-1.9.0.js"/>" ></script> 
<script type='text/javascript'>
var jQuery_1_8_2 = $.noConflict(true);
jQuery(document).ready(function(){
	//alert('state='+jQuery("#state").val());
	
});



var errorFound = false;
	/*jQuery("#ischoolCode").live('blur', function(event) {
		
		var schoolcode=jQuery(this).val();
		var institutionId ="";
		institutionId=jQuery("#selinstitutionId").val();
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
	});*/
	
	jQuery("#iname").live('blur', function(event) {
		var schoolTitle=jQuery(this).val();
		var institutionId ="";
		institutionId=jQuery("#selinstitutionId").val();
		if (institutionId === undefined){
			institutionId="";
		}
		var url="/scheduling_system/institution/manageInstitution.html?operation=validateSchoolTitle&schoolTitle="+schoolTitle+"&institutionId="+institutionId;
		
		jQuery.ajax({url:url, success:function(result){
		
		   if(result=="true"){
				jQuery("#inameErrorDisplay").html('<p style="color: red;">Already Exist<p>');
				jQuery("#saveInstitution").attr('disabled','disabled');
			}else{
				jQuery("#inameErrorDisplay").html('');
				jQuery("#saveInstitution").attr('disabled','');
			}
		  }});
	});

	$("[id^='degreeDate_']").live('blur', function(event) {
		var curDate="<%=new java.util.Date().getTime()%>";
		
		if(cmpCurrentDate(jQuery(this).val(),curDate)<0){
			jQuery(this).addClass("redBorder");
			alert("This Date cannot be greater than current Date");
			errorFound=true;
		}else{
			jQuery(this).removeClass("redBorder");
			errorFound=false;
		}
		
	});
	
	$("[id^='lastAttendenceDate_']").live('blur', function(event) {
		jQuery(this).removeClass("redBorder");
		errorFound = false;
		
	});
	
function toggling(){
		jQuery(".addInstClass").toggle();
		jQuery(".selectInstClass").toggle();
		if(jQuery("#toggleInstitution").val()=='Add New Institution'){
			jQuery("#fillInstituteInfo").html("");
			jQuery("#toggleInstitution").val('Select Institution')
			jQuery("#institutionBoolean").val("true");
		}else{
			jQuery("#toggleInstitution").val('Add New Institution')
			jQuery("#institutionBoolean").val("false");
		}
		alert(jQuery("#institutionBoolean").val());
}

function validateCreateInstitution() {
	document.selectInstitutionForm.action = "<c:url value='launchEvaluation.html?operation=createInstitution'/>";
	document.selectInstitutionForm.submit();
}
function showInstitution(){
	jQuery("#entryInstituion").show();
}

function validate() {
	if(!errorFound){
		jQuery(":input").removeClass( "redBorder" );
	}
	var noOfRows = jQuery( "#addInstitutionTbl" ).attr('rows').length;
	noOfRows = noOfRows - 2;
	var errorString = "";

	if(${redirectValue} == '1'){
		
		if(jQuery("#toggleInstitution").val()=='Select Institution' && jQuery("#countryId").val().trim() == ''){
			jQuery("#countryId").addClass( "redBorder" );
			alert("Please select the Country");
			return false;
		}else{
			jQuery("#countryId").removeClass( "redBorder" );
		}
		if(jQuery("#state").val().trim() == ''){
			jQuery("#state").addClass( "redBorder" );
			alert("Please select the State");
			return false;
		}else{
			errorFound = false;
			jQuery("#state").removeClass( "redBorder" );
		}
	}
	if(jQuery("#toggleInstitution").val()=='Select Institution'){
		if( jQuery("#ischoolCode").val().trim() == "" || jQuery("#ischoolCode").val().trim() == "" ) {
		
			errorFound = true;
			jQuery("#ischoolCode").addClass( "redBorder" );
			errorString = errorString + "Institution Code,"+'\t\t';
		}
		if( jQuery("#iname").val().trim() == "" || jQuery("#iname").val().trim() == "" ) {
			errorFound = true;
			jQuery("#iname").addClass( "redBorder" );
			errorString = errorString + "Institution Name"+'\n';
		}
	}else{
		if( jQuery("#select").val().trim() == "" || jQuery("#select").val().trim() == "" ) {
			alert("please select an institution");
			return false;
		}else{
			if(${redirectValue} == '1'){
				jQuery("#selinstitutionId").val(jQuery("#select").val().trim());	
			}	
		}
	}
	
	if(jQuery('input[name=transcriptType]:checked','#selectInstitutionForm').val()== undefined){
		alert("Please select the transcript type as Ofiicial or Unofficial");
		return false;
	}
	
	//alert( "noOfRows is " + noOfRows );
	for( var ctr=0; ctr<=noOfRows; ctr++ ){
		var degree = jQuery("#insDegree_"+ctr).val();
		var major = jQuery.trim( jQuery("#major_"+ctr).val() );
		var completionDate = jQuery.trim( jQuery("#degreeDate_"+ctr).val() );
		var gpa = jQuery.trim( jQuery("#GPA_"+ctr).val() );
		var lastAttendenceDate = jQuery.trim( jQuery("#lastAttendenceDate_"+ctr).val() );
		var errorInCurrentRow = false;
		var errorStringCurrentRow = "";
		
		//If there is only 1 row, ensure that it is not blank
		if( noOfRows == 0 && ( degree == 'NA' && major == '' && completionDate == '' && gpa == '' && lastAttendenceDate == '' ) ) {
			jQuery("#insDegree_"+ctr).addClass( "redBorder" );
			jQuery("#degreeDate_"+ctr).addClass( "redBorder" );
			jQuery("#GPA_"+ctr).addClass( "redBorder" );
			jQuery("#lastAttendenceDate_"+ctr).addClass( "redBorder" );
			errorFound = true;
			errorString = errorString + "Institution 1 : Enter the degree details"+'\n';
		}

		
		//If this is the last row which is completely blank, ignore.
		if( ctr == noOfRows && ( degree == 'NA' && major == '' && completionDate == '' && gpa == '' && lastAttendenceDate == '') ) {
			continue;
		}

		//GPA cannot be blank. it should be a number
		if( gpa == '' || isNaN(gpa)) {
			errorFound = true;
			errorInCurrentRow = true;
			jQuery("#GPA_"+ctr).addClass( "redBorder" );
			errorStringCurrentRow = errorStringCurrentRow + "GPA (number)" + '\t';
		}

		//If degree != NA, then completion date cannot be blank
		//if( degree != 'NA' && completionDate == '' ) {
		if( completionDate == '' ) {
			errorFound = true;
			errorInCurrentRow = true;
			jQuery("#degreeDate_"+ctr).addClass( "redBorder" );
			errorStringCurrentRow = errorStringCurrentRow + "Degree date" + '\t';
		}
		if( lastAttendenceDate == '' ) {
			errorFound = true;
			errorInCurrentRow = true;
			jQuery("#lastAttendenceDate_"+ctr).addClass( "redBorder" );
			errorStringCurrentRow = errorStringCurrentRow + "Attendence date" + '\t';
		}
		if(errorInCurrentRow){
			errorString = errorString + "Institution "+ (ctr+1) + '\t' + errorStringCurrentRow + '\n';
		}
	}

	

	if( errorFound == true ) {
		if(errorString != ""){
			errorString = "The following information is required :"+'\n\n' + errorString;
			alert( errorString );
			return false;
		}

	}
	if(jQuery("#zipcode1").is(":visible") && jQuery("#zipcode2").is(":visible"))
		jQuery("#zipcode").val(jQuery("#zipcode1").val()+jQuery("#zipcode2").val());
	
	document.selectInstitutionForm.noOfRows.value=jQuery("#addInstitutionTbl").attr('rows').length-1;
	document.selectInstitutionForm.saveInstitution.disabled = true;
	document.selectInstitutionForm.submit();
	
}
jQuery("#countryId").live('blur', function(event) {
	if(jQuery(this).val()==1){
		//jQuery( "#state" ).autocomplete({source: stateList});
		jQuery("#zipcode1").show();
		jQuery("#zipcode2").show();
		jQuery("#zipcode").hide();
		
		jQuery("#zipcode1").mask("99999");
		jQuery("#zipcode2").mask("9999");
		jQuery("#phone1").mask("9999999999");
	}else{
		//jQuery( "#state" ).autocomplete({source: ''});
		jQuery("#zipcode1").hide();
		jQuery("#zipcode2").hide();
		jQuery("#zipcode").show();
		
		jQuery("#zipcode1").unmask();
		jQuery("#zipcode2").unmask();
		jQuery("#zipcode").unmask();
		jQuery("#phone1").unmask();		
	}


});

jQuery("#state").live('blur', function(event) {
	if(jQuery(this).val() == ''){
		jQuery("#state").addClass( "redBorder" );	
	}else{
			jQuery("#state").removeClass( "redBorder" );	
		 }
	
});
function loadInstitutionDegreeKeyRow(placeholder){
	var srNoHolder = parseInt(placeholder) + 1;
	//alert("srNoHolder="+srNoHolder);
	var appendInsText = 
		"<tr><td align='left'><label>"+srNoHolder+"</label></td><td align='left'><select id='insDegree_"+placeholder+"' name='insDegree_"+placeholder+"' class='frm-stxbx selDegreeClass eventCaptureField' onchange='javascript:markUnMarkDisabled("+placeholder+");'><option value='NA'>N/A</option><option value='Associates'>Associates</option><option value='Bachelors'>Bachelors</option><option value='Masters'>Masters</option><option value='Doctoral'>Doctoral</option></select></td>"
		+
	    "<td align='left'><input id='major_"+placeholder+"' name='major_"+placeholder+"' type='text' class='txbx degreeMajorClass' disabled='disabled'/></td>"
	    +
	    "<td align='left'><input name='degreeDate_"+placeholder+"' id='degreeDate_"+placeholder+"' type='text' class='txbx maskDate' /></td>"
	    +
	    "<td align='left'><input type='text' name='GPA_"+placeholder+"' id='GPA_"+placeholder+"' style='width:40px;' class='txbx w40' /></td>"
	    +
	    "<td align='left'><input type='text' name='lastAttendenceDate_"+placeholder+"' id='lastAttendenceDate_"+placeholder+"' class='txbx maskDate' /></td>"
	    +
	    "<td id='removeRowTd_"+placeholder+"'><a onclick='loadInstitutionDegreeKeyRow("+srNoHolder+");' class='addRow' name='addRow_"+placeholder+"' id='addRow_"+placeholder+"' href='javascript:void(0)'><img width='15' height='14' src='../images/addCourse.png' alt='add'> Add New</a><br/><a href='#' id='removeRow_"+placeholder+"' name='removeRow_"+placeholder+"' class='removeInstitutionRow'><img src='../images/removeIcon.png' width='15' height='15' alt='Delete' /> Remove</a></td></tr>";
	
	addRowsAtFly( 'eventCaptureField', 'blur', 'addInstitutionTbl', 'removeRowTd_', appendInsText, placeholder );
}
function markUnMarkDisabled(index){
	//major_index
	//alert(jQuery("#insDegree_"+index).find("option:selected").val());
	if(jQuery("#insDegree_"+index).find("option:selected").val() != 'NA'){
		
		jQuery("#major_"+index).removeAttr("disabled");
	}else{
		jQuery("#major_"+index).val("");
		jQuery("#major_"+index).attr("disabled","disabled");
	}
	
	
}	
</script>

<script>
/*jQuery(document).oneTime( 0, "validateDegree", function() {


	jQuery(document).stopTime( "validateDegree" );
} );*/
</script><c:set var="degreesExisting" value="${empty studentInsDegreeList ? false : true}" />
 <c:set var="listSize" value="${fn:length(studentInsDegreeList)}" />
 
<div class="popCont popUpBig2" style=" width:900px !important;">
<form name="selectInstitutionForm" id="selectInstitutionForm" method="post" action="launchEvaluation.html?operation=selectInstitution">
        <h1><a href="#" class="close" title="close"></a>Select Institution and Degree</h1>
		
		<div style="height:400px; overflow:auto" class="mt25">
		<div class="floatRight" id="fillInstituteInfo"></div>	
		 <div  style="display:none" class="showAddInstdata">	
		 <label for="Display on" class="noti-pop-labl">Country: </label>
			 <select  class="frm-stxbx required w200"  id="countryId" name="institution.country.id" <c:if test="${!empty studentInstitutionTranscript.institution.country.id}"> disabled="disabled" </c:if>>
				<option value="">Select the Country</option>
					<c:forEach items="${countryList}" var="country">
						
							<option value="${country.id}" <c:if test="${studentInstitutionTranscript.institution.country.id eq country.id }">selected</c:if>>${country.name}</option>
					</c:forEach>		    
			</select>
		</div>
        <br class="clear" />
        
        <label for="Display on" class="noti-pop-labl">State: </label>
        
        <input type="text" class="popupTextFiled" id="state" value="${studentInstitutionTranscript.institution.state}" name="institution.state" <c:if test="${!empty studentInstitutionTranscript.institution.state}"> readonly="true" </c:if>>
        
        <br class="clear" />
       <div class="showInstdata">
       		<label for="Display on" class="noti-pop-labl">Institution Name: </label>
       		<c:choose>
       		<c:when test="${redirectValue eq '1' }">
	            <select style="width:500px" class="frm-stxbx required w200" id="select" name="View by">
	                <option value=''>Select University</option>
	            </select>            
            </c:when>
            <c:otherwise>
            	<input style="width:500px;" type="text" class="frm-stxbx required w200" name="institution.name" id="select" value="${studentInstitutionTranscript.institution.name }" <c:if test="${!empty studentInstitutionTranscript.institution.name}"> readonly="true" </c:if>>
            </c:otherwise>
            </c:choose>
            
            <br class="clear" />
            <label for="Address1" class="noti-pop-labl nomarginBotm">Address1: </label><span class="captionmt3" id="address1">${studentInstitutionTranscript.institution.address1 } </span>
            <br class="clear" />
            <label for="Address2" class="noti-pop-labl nomarginBotm">Address2: </label><span class="captionmt3" id="address2">${studentInstitutionTranscript.institution.address2 } </span>
            <br class="clear" />
            <label for="City" class="noti-pop-labl nomarginBotm">City: </label><span class="captionmt3" id="city"> ${studentInstitutionTranscript.institution.city }</span>
            <br class="clear" />
            <!-- <label  class="noti-pop-labl nomarginBotm">State: </label><span class="captionmt3 noti-pop-labl">NSW</span> -->
            <label  class="noti-pop-labl nomarginBotm">Zip Code: </label><span class="captionmt3" id="zipCode">${studentInstitutionTranscript.institution.zipcode }</span><br class="clear" />
            <label  class="noti-pop-labl nomarginBotm">Phone: </label><span class="captionmt3" id="phone">${studentInstitutionTranscript.institution.phone }</span><br class="clear" />
       </div> 
       <div style="display:none" class="showAddInstdata">
       		<label for="Display on" class="noti-pop-labl">Institution Name: </label>
            <input style="width:500px;" type="text" class="popupTextFiled" name="institution.name" id="iname" value="">
            <br class="clear" />
          	<label class="noti-pop-labl nomarginBotm">College Board Code: </label><input style="margin-right:30px;" type="text" class="popupTextFiled floatLeft" name="institution.schoolCode" id="ischoolCode" value=""> 
            <br class="clear" />
            <label for="Address1" class="noti-pop-labl nomarginBotm">Address1: </label>
            <input type="text" class="popupTextFiled" style="width:500px;" name="institution.address1" value="">
            <br class="clear" />
            <label for="Address2" class="noti-pop-labl nomarginBotm">Address2: </label>
            <input type="text" class="popupTextFiled" style="width:500px;" name="institution.address2" value="">
            <br class="clear" />
            <label for="City" class="noti-pop-labl nomarginBotm">City: </label><input type="text" class="popupTextFiled" name="institution.city" value="">
            <br class="clear" />
            <!-- <label class="noti-pop-labl nomarginBotm">State2: </label><input style="margin-right:30px;" type="text" class="popupTextFiled floatLeft" value=""> -->
            <label for="Zip Code" class="noti-pop-labl nomarginBotm">Zip Code: </label>
             <input type="text" style="width: 60px; display: none;" class="textField" name="zipcode1" id="zipcode1" style="width:50px" 
						value="">
						
				<input type="text" style="width: 60px; display: none;" class="textField" name="zipcode2" id="zipcode2" style="width:40px" 
						value="">
						
				<input name="institution.zipcode" id="zipcode" type="text" value="" class="textField number">
				
            <br class="clear" />
            <label for="Phone" class="noti-pop-labl nomarginBotm">Phone: </label><input type="text" class="textField w200 number" id="phone1" name="institution.phone" value="">
       </div><br class="clear" />
       <input id="toggleInstitution" style="margin-right:100px;" class="button floatRight" type="button" value="Add Institution" /><br />
        <br class="clear" />
       
			<%-- <table>
			<tr>
	        <td><label for="Display on" class="noti-pop-labl">College Board Code: </label>
				
			<c:choose>
				<c:when test="${degreesExisting == true}">
					<input id="schoolCode" name="schoolCode" disabled="disabled" type="text" class="txbx selectInstClass " value="${studentInstitutionTranscript.institution.schoolcode}" />
				</c:when>
				<c:otherwise>
					<input id="schoolCode" name="schoolCode" disabled="disabled" type="text" class="txbx selectInstClass" />
				</c:otherwise>
			</c:choose>
			
			<input id="ischoolCode" name="institution.schoolCode" type="text" class="txbx addInstClass" />
			
			
			<input id="institutionBoolean" name="institutionBoolean" value="false" type="hidden"  />
			</td>
			<td>
			<c:if test="${degreesExisting == false}">
				<input type="button" id="toggleInstitution" onclick="toggling();" value="Add New Institution"/>
			</c:if>
			</td>
			</tr>
			<tr>
			<td>
			<label for="Display on" class="noti-pop-labl">Institution Name: </label>
			<select  class="frm-stxbx w200 selectInstClass" id="selInstitution" ${degreesExisting == true ? "disabled=\"disabled\"" : "" }>
				<option id="" value="">Select the Institution</option>
				<c:forEach items="${institutionList}" var="institution">
					<option id="${institution.schoolcode}"
					<c:if test="${degreesExisting == true}">
						<c:if test="${studentInstitutionTranscript.institution.id == institution.id}">
							selected
						</c:if>
					</c:if> 
					value="${institution.id}">${institution.name}</option>
				</c:forEach>							    
			</select>
			<input id="iname" name="institution.name" type="text" class="txbx addInstClass" />
			</td>
			<td>
			</td>
			</tr>
			</table> --%>	
			
			<div id="inameErrorDisplay" ></div>
			
		
			<br class="clear" />
		
			<label for="Display on" class="noti-pop-labl">Transcript Type:</label>
			<label class="mr10"><input name="transcriptType" type="radio" value="0" ${degreesExisting == true && studentInstitutionTranscript.official == false ? "checked=\"checked\"" : "" }/> Un-Official</label>  
			<label><input name="transcriptType" type="radio" value="1" ${degreesExisting == true && studentInstitutionTranscript.official == true ? "checked=\"checked\"" : "" } /> Official</label> 
			
			 <br class="clear" />
		
        
			
		
		
        <table  name="addInstitutionTbl" id="addInstitutionTbl" class="noti-tbl1" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
            	<th width="5%" align="left" scope="col">Sr.No</th>
                <th width="20%" align="left" scope="col">Institution Degree</th>
                <th width="30%" align="left" class="dividerGrey" scope="col">Degree Major (If not selected 'N/A')</th>
                <th width="10%" align="left" class="dividerGrey" scope="col">Degree Date</th>
                <th width="10%" align="left" class="dividerGrey" scope="col">GPA</th>
                 <th width="10%" align="left" class="dividerGrey" scope="col">Last Date of Attendance</th>
                <th width="15%"></th>
            </tr>
            <c:choose>
            	<c:when test="${degreesExisting == false}">
            		<tr>
            			<td align="left"><label>1</label>
			            <td align="left"><select id="insDegree_0" name="insDegree_0" class="frm-stxbx selDegreeClass" onchange="javascript:markUnMarkDisabled('0');"><option value="NA">N/A</option><option value="Associates">Associates</option><option value="Bachelors">Bachelors</option><option value="Masters">Masters</option><option value="Doctoral">Doctoral</option></select></td>
			            <td align="left"><input id="major_0" name="major_0" type="text" class="txbx degreeMajorClass" disabled="disabled"/></td>
			            <td align="left"><input name="degreeDate_0" id="degreeDate_0" type="text" class="txbx small maskDate required" /><br class="clear" /></td>
			            <td align="left"><input type="text" name="GPA_0" id="GPA_0" class="txbx w40" /></td>
			            <td align="left"><input type="text" name="lastAttendenceDate_0" id="lastAttendenceDate_0" class="txbx small maskDate required" /></td>
			            <td align="left" id="removeRowTd_0">
			            	<a onclick="loadInstitutionDegreeKeyRow('1');" class="addRow" name="addRow_0" id="addRow_0" href="javascript:void(0)"><img width="15" height="14" src="../images/addCourse.png" alt="add"> Add New</a>
			            </td>
		            </tr>
            	</c:when>
            	<c:otherwise>
            		<c:forEach items="${studentInsDegreeList}" var="studInsDeg" varStatus="loop">
			            <tr>
			            	<td><label>${loop.index + 1}</label></td>
				            <td align="left">
				            	<select id="insDegree_${loop.index}" name="insDegree_${loop.index}" class="frm-stxbx selDegreeClass">
				            		<option value="NA" ${studInsDeg.institutionDegree.degree == "NA" ? "selected" : "" }>N/A</option>
				            		<option value="Associates" ${studInsDeg.institutionDegree.degree == "Associates" ? "selected" : "" }>Associates</option>
				            		<option value="Bachelors" ${studInsDeg.institutionDegree.degree == "Bachelors" ? "selected" : "" }>Bachelors</option>
				            		<option value="Masters" ${studInsDeg.institutionDegree.degree == "Masters" ? "selected" : "" }>Masters</option>
				            		<option value="Doctoral" ${studInsDeg.institutionDegree.degree == "Doctoral" ? "selected" : "" }>Doctoral</option>
				            	</select>
				            </td>
				            <td align="left">
				            	<input id="major_${loop.index}" name="major_${loop.index}" type="text" class="txbx degreeMajorClass"  ${studInsDeg.institutionDegree.degree == "NA" ? "disabled=\"disabled\"" : "" } value=" ${studInsDeg.major}" onchange="javascript:markUnMarkDisabled('${loop.index}');"/>
				            </td>
				            <td align="left">
				            	<input name="degreeDate_${loop.index}" id="degreeDate_${loop.index}" type="text" class="txbx small maskDate" value="<fmt:formatDate value='${studInsDeg.completionDate}' pattern='MM/dd/yyyy' />" />
				            	<br class="clear" />
				            </td>
				            <td align="left">
				            	<input type="text" name="GPA_${loop.index}" id="GPA_${loop.index}" class="txbx w40"  value="${studInsDeg.gpa}" />
				            </td>
				            <td align="left">
				            	<input type="text" name="lastAttendenceDate_${loop.index}" id="lastAttendenceDate_${loop.index}" class="txbx small maskDate"  value="<fmt:formatDate value='${studInsDeg.completionDate}' pattern='MM/dd/yyyy' />" />
				            </td>
				            <td align="left" id="removeRowTd_${loop.index}">
				            <c:choose>
				            	<c:when test="${loop.index eq 0 && listSize eq 1}">
				            		<a onclick="loadInstitutionDegreeKeyRow('${loop.index + 1}');" class="addRow" name="addRow_${loop.index}" id="addRow_${loop.index}" href="javascript:void(0)"><img width="15" height="14" src="../images/addCourse.png" alt="add"> Add New</a>
				            	</c:when>
				            	<c:when test="${listSize gt 1 && (loop.index eq (listSize-1))}">
				            		<a onclick="loadInstitutionDegreeKeyRow('${loop.index + 1}');" class="addRow" name="addRow_${loop.index}" id="addRow_${loop.index}" href="javascript:void(0)"><img width="15" height="14" src="../images/addCourse.png" alt="add"> Add New</a><br/>
				            		<a href="#" id="removeRow_${loop.index}" name="removeRow_${loop.index}" class="removeInstitutionRow"><img src="../images/removeIcon.png" width="15" height="15" alt="Delete" /> Remove</a>
				            	</c:when>
				            	
				            </c:choose>
				            </td>
			            </tr>	            
		            </c:forEach>
		            
		           
			        <%-- <tr>
			        	<td align="left"><label>${listSize +1 }-B</label></td>
			            <td align="left">
			            	<select id="insDegree_${listSize}" name="insDegree_${listSize}" class="frm-stxbx selDegreeClass"><option value="NA">N/A</option><option value="Associates">Associates</option><option value="Bachelors">Bachelors</option><option value="Masters">Masters</option></select>
			            </td>
			            <td align="left">
			            	<input id="major_${listSize}" name="major_${listSize}" type="text" class="txbx degreeMajorClass"  disabled="disabled"/>
			            </td>
			            <td align="left">
			            	<input name="degreeDate_${listSize}" id="degreeDate_${listSize}" type="text" class="txbx small maskDate" /><br class="clear" />
			            </td>
			            <td align="left">
			            	<input type="text" name="GPA_${listSize}" id="GPA_${listSize}" class="txbx w40 number" />
			            </td>
			             <td align="left">
			            	<input name="lastAttendenceDate_${listSize}" id="lastAttendenceDate_${listSize}" type="text" class="txbx small maskDate" /><br class="clear" />
			            </td>
			            <td id="removeRowTd_${listSize}">		            	
			            	<a href="#" id="removeRow_${listSize}" name="removeRow_${listSize}" class="removeInstitutionRow"><img src="../images/removeIcon.png" width="15" height="15" alt="Delete" /> Remove</a>
			            </td>
		            </tr> --%>
            	</c:otherwise>
            </c:choose>
                        
        </table>
        
        <div class="dividerPopup mt25"></div>
        <div class="btn-cnt">
            <input class="fr close" name="" type="button" value="Cancel" />
            <input class="fr" type="button" value="Save and Close" id="saveInstitution" name="saveInstitution" onclick="validate();"/>
        	<div class="clear"></div>
    	</div>
		</div>
       	<input type="hidden" id="selinstitutionId" name="institutionId" value="${degreesExisting == true ? studentInstitutionTranscript.institution.id : '' }" />
      	<input type="hidden" name="expectedStartDateString" id="expectedStartDateString" value="<fmt:formatDate value='${courseInfo.expectedStartDate}' pattern='MM/dd/yyyy' />" />
   		<input type="hidden" name="studentCrmId" id="studentCrmId" value="${courseInfo.studentCrmId}" />
	   	<input name="programVersionCode" type="hidden" value="${courseInfo.programVersionCode}" />
	   	<input name="programDesc" type="hidden" value="${courseInfo.programDesc}" />
	   	<input name="catalogCode" type="hidden" value="${courseInfo.catalogCode}" />
	   	<input name="stateCode" type="hidden" value="${courseInfo.stateCode}" />
	   	<input type="hidden" name="studentId" id="studentId" value="${courseInfo.studentCrmId}" />
	   	<input type="hidden" name="evaluationStatus" id="evaluationStatus" value="Unofficial" />
	   	<input type="hidden" name="noOfRows" id="noOfRows" value="" />
	   	<input type="hidden" name="redirectValue" id="redirectValue" value="${redirectValue}"/>
	   	<input id="institutionBoolean" name="institutionBoolean" value="false" type="hidden"  />
   	</form>
	


</div>

 
  