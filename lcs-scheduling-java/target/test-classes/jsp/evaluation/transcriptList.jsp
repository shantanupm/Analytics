<%@include file="../init.jsp"%>

<link rel="stylesheet" href="<c:url value="/css/schSysStylesheet.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/jquery.ui.all.css"/>" />
<style>
.capitalise
{
    text-transform:capitalize;
} 
</style>

<script type="text/javascript" src="<c:url value="/js/jquery.validate.js"/>"></script>
<script type='text/javascript' src="<c:url value='/js/expand.js'/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.maskedinput-1.3.js"/>"></script> 


<!--  Newly ADDed -->
<link rel="stylesheet" href="<c:url value="/css/boxy.css"/>" />
<link rel="stylesheet" href="<c:url value="/css/boxypopupscrollfix.css"/>" />
  
<script type='text/javascript' src="<c:url value="/js/jquery.boxy.js"/>"></script> 
<script type='text/javascript' src="<c:url value="/js/ui.dropdownchecklist.js"/>"></script> 

<!-- End of Newly Added  -->


<script type="text/javascript">
window.onload = (function () {

	jQuery(document).ready(function () {
		jQuery("h1.expand").toggler(); 
		jQuery("#divContBoxLft").expandAll({trigger: "h1.expand"});
		jQuery("#divContBoxRgt").expandAll({trigger: "h1.expand"});
		
		jQuery('.collapse:first').show();
		jQuery('h1.expand:first a:first').addClass("open");	
		
	
		jQuery("#addExistingForm").validate();
		jQuery("#addNewForm").validate();
		
		jQuery("#countryId").val('1');
		jQuery("#countryIdNew").val('1');
		
		jQuery("#zipcode").removeClass("number");
		jQuery("#zipcode").mask("99999-?9999");
		jQuery("#phone1").mask("9999999999");
		jQuery("#phone2").mask("9999999999");
		jQuery("#fax").mask("(999) 999-9999"); 
		
		jQuery("#zipcodeNew").removeClass("number");
		jQuery("#zipcodeNew").mask("99999-?9999");
		jQuery("#phone1New").mask("9999999999"); 
		jQuery("#phone2New").mask("9999999999"); 
		jQuery("#faxNew").mask("(999) 999-9999"); 
		
		jQuery("[id^='institutionName']").live('on keyup', function(event) {
			jQuery(this).addClass('capitalise');
		});
		jQuery("[id^='institutionNameNew']").live('on keyup', function(event) {
			jQuery(this).addClass('capitalise');
		});
		
		jQuery("#countryId").live('blur', function(event) {
			if(jQuery(this).val()==1){
				
				jQuery("#zipcode").removeClass("number");
				jQuery("#zipcode").mask("99999-?9999");
				jQuery("#phone1").mask("9999999999");
				jQuery("#phone2").mask("9999999999");
				jQuery("#fax").mask("(999) 999-9999"); 
				
				jQuery("#zipcodeNew").removeClass("number");
				jQuery("#zipcodeNew").mask("99999-?9999");
				jQuery("#phone1New").mask("9999999999");
				jQuery("#phone2New").mask("9999999999");
				jQuery("#faxNew").mask("(999) 999-9999"); 
				
				
			}else{
				
				jQuery("#zipcode").addClass("number");
				jQuery("#zipcode").unmask();
				jQuery("#phone1").unmask();
				jQuery("#phone2").unmask();
				jQuery("#fax").unmask();
				
				jQuery("#zipcodeNew").addClass("number");
				jQuery("#zipcodeNew").unmask();
				jQuery("#phone1New").unmask();
				jQuery("#phone2New").unmask();
				jQuery("#faxNew").unmask();
				
			}
		
		
		});
				
		jQuery("#institutionNameNew").live('blur', function(event) {
			var schoolTitle=jQuery("#institutionNameNew").val();
			var institutionId ="";
			
			
			if(schoolTitle.length>0){
				var url= "<c:url value='/evaluation/launchEvaluation.html?operation=getInstitutionByTitle&title="+schoolTitle+"'/>"
				jQuery.ajax({url:url,dataType: "json", success:function(data){
				   if(data.id !=''&& data.id!=null){
						//jQuery("#schoolTitleErrorDisplay").html('<p style="color: red;">Already Exist<p>');
						var r1 =  confirm("This institution already exists in the Evaluation database,would you like to add it to the student's record? ");
						if(r1){
							jQuery('#AddExsting').show();
							jQuery('#AddNewInsti').hide();
							jQuery('.buttonLeft').addClass("active");
							jQuery('.buttonRight').removeClass('active');
							jQuery('#institutionName').val(schoolTitle);
							jQuery('#institutionId').val(data.id);
							institutionInTranscriptExist(data.id,data.institutionID);
							jQuery("#saveInstitutionNew").attr('disabled','disabled');
						}
					}else{
						jQuery("#schoolTitleErrorDisplay").html('');
						jQuery("#saveInstitutionNew").attr('disabled',false);
					}
				  }});
			}
		});
		
		jQuery("#institutionName").live('blur', function(event) {
			var schoolTitle=jQuery("#institutionName").val();
			var institutionId ="";
			
			
			if(schoolTitle.length>0){
				var url= "<c:url value='/evaluation/launchEvaluation.html?operation=getInstitutionByTitle&title="+schoolTitle+"'/>"
				jQuery.ajax({url:url,dataType: "json", success:function(data){
				   if(data.id !=''&& data.id!=null){
					   jQuery("#addNewAddressLink").show();
						jQuery("#saveInstitution").attr('disabled',false);
					}else{
						jQuery("#addNewAddressLink").hide();
						jQuery("#saveInstitution").attr('disabled','disabled');
					}
				  }});
			}
		});
		
	
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

		
			jQuery(".stateClass").autocomplete({source: stateList});
		
		
		jQuery('#AddNewInsti,#newAddrBox,.addInsti').hide();
		
		jQuery('.buttonLeft').click(function()
		{
			jQuery('#AddExsting').show();
			jQuery('#AddNewInsti').hide();
			jQuery(this).addClass("active");
			jQuery('.buttonRight').removeClass('active');
			
			})
			
			
		jQuery('.buttonRight').click(function()
		{
			jQuery('#AddExsting').hide();
			jQuery('#AddNewInsti').show();
			jQuery(this).addClass("active");
			jQuery('.buttonLeft').removeClass('active');
			
			})
			
		jQuery('#addNewAddressLink').click(function()
		{
			jQuery('#newAddrBox').slideDown(500);
			jQuery(this).slideUp(800);	
			jQuery("#address1").addClass('required');
			jQuery("#city").addClass('required');
			jQuery("#mainState").addClass('required');
			jQuery("#zipcode").addClass('required');
			jQuery("#countryId").addClass('required');
			jQuery("#phone1").addClass('required');
		})
		
		jQuery('#editAddress').live("click", function()
		{
			jQuery('#newAddrBox').slideDown(500);
		})
		jQuery('#removeAddress').live("click", function()
		{
			jQuery('#newAddAddress').html('');
			jQuery("#address1").val('');
			jQuery("#address2").val('');
			jQuery("#city").val('');
			jQuery("#state").val('');
			jQuery("#countryId").val('');
			jQuery("#zipcode").val('');+
			jQuery("#phone1").val('');
			jQuery("#phone2").val('');
			jQuery("#fax").val('');
			jQuery("#website").val('');
			
		})
		jQuery('#CancelBtn').click(function()
		{
			jQuery('#addNewAddressLink').slideDown(500);
			jQuery('#newAddrBox').slideUp(800);
			jQuery("#address1").removeClass('required');
			jQuery("#city").removeClass('required');
			jQuery("#mainState").removeClass('required');
			jQuery("#zipcode").removeClass('required');
			jQuery("#countryId").removeClass('required');
			jQuery("#phone1").removeClass('required');
		})
		
		jQuery('#addInsTution').click(function()
		{
			jQuery('.addInsti').slideDown(500);
			jQuery(this).addClass('grayColor');
		})
		jQuery('#cancelInstitution,#cancelInstitutionNew').click(function(){			
			jQuery('.addInsti').slideUp(800);
			jQuery('#addInsTution').removeClass('grayColor')
			
		})	
		
		jQuery('#add').click(function(){
		
			var addInstitution=	"<label> <input type='radio' name='RadioGroup1' value='radio' id='RadioGroup1_0' />" +
			"	</label> <div class='aseladdOverflow'>"+jQuery("#address1").val()+" "+jQuery("#address2").val()+" 	" +
			jQuery("#city").val()+" "+jQuery("#state").val()+" 	"+jQuery("#countryId").val()+" "+jQuery("#zipcode").val()+
			"Phone: "+jQuery("#phone1").val()+","+jQuery("#phone2").val()+" 	<br /> 	" +
			"Fax: "+jQuery("#fax").val()+" Website "+jQuery("#website").val()+"	</div> "+
			"<div class='fr'> <a href='javascript:void(0)' id='editAddress' class='editIcon'>Edit</a>"+
			"<a href='#'class='removeIcon' id='removeAddress'>Remove</a></div><br class='clear' />";
			
			
			 if(jQuery("#addExistingForm").valid()){
					jQuery("#newAddAddress").html(addInstitution);
					jQuery("#addNewAddressLink").hide();
					jQuery('#addNewAddressLink').slideDown(500);
					jQuery('#newAddrBox').slideUp(800);
			 }else{
					jQuery("#newAddAddress").html("");
			 }
		})	
		
			
			jQuery( "#institutionName" ).autocomplete({
				source: function( request, response ) {
					jQuery.ajax({
					url: "<c:url value='/evaluation/launchEvaluation.html?operation=getInstitutionByTitleAndState&title="+request.term +"&state="+jQuery("#state").val()+"'/>",		
					dataType: "json",
					data: {
						style: "full",
						maxRows: 5,
						name_startsWith: request.term
					},
					success: function( data ) {
						if(data.length>0){
							jQuery("#institutionName").removeClass('auto-load');
							response( jQuery.map( data, function( item ) {
								jQuery("#institutionId").val(item.id);
								return {
										label: item.name ,
										value: item.name,
										instId: item.id,
										institution_id:item.institutionID
									}	
							}));
							jQuery("#addNewAddressLink").show();
							jQuery("#saveInstitution").attr('disabled',false)
						}else{
							jQuery("#addNewAddressLink").hide();
							jQuery("#saveInstitution").attr('disabled','disabled')
							jQuery("#institutionName").removeClass('auto-load');
						}
					},
					error: function(xhr, textStatus, errorThrown){
						jQuery("#addNewAddressLink").hide();
						jQuery("#saveInstitution").attr('disabled','disabled');
						jQuery("#institutionName").removeClass('auto-load');
					},
				});
			},
			minLength: 2,
			 search: function(event, ui) { jQuery(this).addClass("auto-load"); },
			  open: function(event, ui) { jQuery(this).removeClass("auto-load"); },
			 select: function(event, ui) {
				 
				institutionInTranscriptExist(ui.item.instId,ui.item.institution_id);
				
				
				
			 }
			});
			
		});
});
	function  institutionInTranscriptExist(institutionId,institutionNo){
		
		var url= "<c:url value='/evaluation/launchEvaluation.html?operation=institutionInTranscriptExist&studentId=${student.id}&institutionId="+institutionId+"'/>";
		
		jQuery.ajax({url:url, success:function(result){
		
		   if(result=="true"){
				alert("This institution already exists on the student's record. To add additional transcripts, please select the institution name from the list below");
				jQuery("#saveInstitution").attr('disabled','disabled');
				jQuery("#institutionIdLabel").text('');
				jQuery("#selAddress").html('');
			
			}else{
				fillAddress(institutionId);
			 	jQuery("#institutionIdLabel").text(institutionNo);
				jQuery("#saveInstitution").attr('disabled',false);
		
			}
		  }});
		
}
	function fillAddress(instId){
		
		jQuery.ajax({
			url: "<c:url value='/evaluation/launchEvaluation.html?operation=getInstitutionAddresses&institutionId="+instId+"'/>",		
			success: function( data ) {
				
				jQuery("#selAddress").html(data);
				
			},
			error: function(xhr, textStatus, errorThrown){
				alert("No Address Found");
			},
		});
	}
</script>


<div class="deo2">
	<div style="border: 1px solid #e7e7e7; border-top: none;"
		class="institute">
		<div class="noti-tools2">
		
			<!-- Error Messsage If it exists -->
			<c:if test="${hasError}">
				      	 <div class="errorMessageDv">${errorMessage}</div>	 
		    </c:if>	
		    
			<div class="clear"></div>
			<div class="fr institutionHeader mb-8">
				<a
					href="<c:url value='launchEvaluation.html?operation=initParams'/>"
					class="mr10"><img src="../images/addStudentIcon.png" width="17"
					height="17" alt="" />Next Student</a>

			</div>
			<div class="clear"></div>
		
			<div class="deo">
				<div class="deoInfo">
					<h1 class="expand">${student.demographics.firstName} ${student.demographics.lastName}</h1>

					<div class="deoExpandDetails collapse" style="display: block;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0"
							class="contentForm">
							<tr>
								<td width="40%" valign="top"><label class="noti-label w130">Student No:</label> <label class="noti-label2">${student.campusvueId}</label>
								</td>
								<td width="2%" valign="top" class="brdLeft">&nbsp;</td>
								<td width="40%" valign="top"><label class="noti-label w130">Program
										Name:</label> <label class="noti-label2 w50">${studentProgramInfo.programName}</label>
								</td>
								<td width="6%" align="center" valign="top"><a onclick='Boxy.load("<c:url value='/evaluation/launchEvaluation.html?operation=showAllPrograms&inquiryId=${student.crmId}'/>")' href="javascript:void(0)" class="mr10" >View all</a></td>

							</tr>
							<tr>
								<td><label class="noti-label w130">Lead CRM ID:</label> <label
									class="noti-label2">${student.crmId}</label>
								</td>
								<td valign="top" class="brdLeft">&nbsp;</td>
								<td valign="top"><label class="noti-label w130">PV
										Code:</label> <label class="noti-label2">${studentProgramInfo.programVersionCode}</label>
								</td>
							</tr>
							<tr>
								<td><label class="noti-label w130"> State Code:</label> <label
									class="noti-label2">${student.state}</label>
								</td>
								<td valign="top" class="brdLeft">&nbsp;</td>
								<td valign="top"><label class="noti-label w130">Expected
										Start Date:</label> <label class="noti-label2"><fmt:formatDate
											value="${studentProgramInfo.expectedStartDate}" pattern="MM/dd/yyyy" />
								</label>
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td valign="top" class="brdLeft">&nbsp;</td>
								<td valign="top"><label class="noti-label w130">Catalog
										Code:</label> <label class="noti-label2">${studentProgramInfo.catalogCode}</label>
								</td>								
							</tr>
						</table>
					</div>

				</div>

				<div class="fr institutionHeader">
					<a href="#" id="addInsTution"><img
						src="../images/add_institution.png" width="17" height="15" alt="" />Add
						Institution</a>
				</div>
				<div class="clear"></div>
				<div class="addInsti contentForm">

					<div class="ButtonGroup">
						<a href="javascript:void(0)" class="buttonLeft active">Add
							Existing Institution</a> <a href="javascript:void(0)"
							class="buttonRight">Add New Institution</a>

					</div>

<form id="addExistingForm" action='<c:url value="/evaluation/launchEvaluation.html?operation=saveExistingInstitution"/>'  onkeypress="return event.keyCode != 13;" method="post">
<input type="hidden" value="${student.campusvueId}" name="studentId" id="" >
<input type="hidden" value="${student.crmId}" name="studentCrmId" id="" >
					<div id="AddExsting">

						<label class="noti-label w130">State:</label> 
							<input type="text" value="" id="state" class="textField w200 stateClass"><br />
						<br class="clear" /> 
						<label class="noti-label w130">Institution Name:<span class="strColor">*</span>
						</label> 
							<input type="text" value="" id="institutionName" class="textField w340 required"> <br />
						<input type="hidden" value="" name="institutionId" id="institutionId" class="textField w340">
						<br class="clear" />
						 <label class="noti-label w130">Institution ID:</label>
						  <label class="noti-label2" id="institutionIdLabel"></label> <br />
						   <br	class="clear" /> <label class="noti-label w130">Select
							Address :<span class="strColor">*</span>
						</label>

						<div class="selAddrDiv" >
						<div id="selAddress">
							
						</div>
						<div id="newAddAddress"></div>
							<br class="clear" />
							<div id="newAddrBox">

								<div class="newAddrHead">New Address</div>
								<div class="newAddsub">

									<div class="borderRight widhth50">
										<label class="noti-label w100">Address:<span
											class="strColor">*</span>
										</label> 
										<input type="text" value="" id="address1" name="address1" class="textField w170 "> <br	class="clear" /> 
										<label class="noti-label w100"></label> 
										<input	type="text" value="" id="address2" name="address2" class="textField w170"> <br class="clear" />
										 <label class="noti-label w100">City:<span class="strColor">*</span></label> 
										<input type="text" value="" id="city" name="city" class="textField w170 "> <br	class="clear" /> 
										<label class="noti-label w100">State:<span	class="strColor">*</span>
										</label> <input type="text" value="" name="state" id="mainState" class="textField w170 stateClass ">
										<br /> <br class="clear" /> <label class="noti-label w100">Zip
											Code:<span class="strColor">*</span>
										</label> <input type="text" value="" id="zipcode" name="zipcode" class="textField w170 "> <br
											class="clear" />
											 <label class="noti-label w100">Toll Free:</label>
										<input type="text" value="" id="tollFree" name="tollFree" class="textField w170 tollFree"> <br
											class="clear" />
									</div>


									<div class="widhth50">

										<label class="noti-label w100">Country:<span
											class="strColor">*</span>
										</label>
										 <select  class="valid w180 "  id="countryId" name="country.id" >
											<option value="">Select the Country</option>
												<c:forEach items="${countryList}" var="country">
													
														<option value="${country.id}" >${country.name}</option>
												</c:forEach>		    
										</select> 
										<br class="clear" /> <label class="noti-label w100">Phone:<span
											class="strColor">*</span>
										</label> <input type="text" value="" id="phone1" name="phone1" class="textField w170  number "> <br
											class="clear" /> <label class="noti-label w100">Phone:</label>
										<input type="text" value="" id="phone2" name="phone2" class="textField w170 number"> <br
											class="clear" /> <label class="noti-label w100">Fax:</label>
										<input type="text" value="" id="fax"  name="fax" class="textField w170"> <br class="clear" />
											 <label class="noti-label w100">Website:</label>
										<input type="text" value="" id="website" name="website" class="textField w170 url"> <br
											class="clear" />
										 <label class="noti-label w100">Email Id:</label>
										<input type="text" value="" id="email1" name="email1" class="textField w170 email"> <br
											class="clear" />
										 <label class="noti-label w100">Email Id:</label>
										<input type="text" value="" id="email2" name="email2" class="textField w170 email"> <br
											class="clear" />




									</div>
									<div class="fr mr22">
										<input type="button" name="Add" value="Add" id="add" class="button"> 
										<input type="button" name="cancel" value="Cancel" id="CancelBtn" class="button">
									</div>
									<div class="clear"></div>

								</div>


							</div>

							<a href="javascript:void(0)" class="ml20 mt10"
								id="addNewAddressLink" style="display: block;"> Add New
								Address</a>
						</div>

  <br  class="clear"/>
                    
                     <div class="BorderLine"></div>
   <div class="fl mandatoryTxt"><span class="strColor">*</span> Mandatory fields</div>
    <div class="fr">
			<input type="submit" name="saveInstitution" value="Save" id="saveInstitution" class="button">
			<input type="button" name="cancel" value="Cancel" id="cancelInstitution" class="button">
		</div>
        <div class="clear"></div>

					</div>
					 
        </form>
    

<form id="addNewForm" action='<c:url value="/evaluation/launchEvaluation.html?operation=saveNewInstitution"/>'  method="post">
<input type="hidden" value="${student.crmId}" name="studentCrmId" id="" >
					<div id="AddNewInsti">

						<label class="noti-label w130">Institution Name:<span
							class="strColor">*</span>
						</label> <input type="text" value="" id="institutionNameNew" name="institutionName" class="textField w340"> <br />
						<div id="schoolTitleErrorDisplay"></div>
						<br class="clear" /> <label class="noti-label w130">Address:<span
							class="strColor">*</span>
						</label>
						<div class="selAddrDiv">


							<div class="mb10">

								<div class="newAddrHead">New Address</div>
								<div class="newAddsub">

									<div class="borderRight widhth50">
										<label class="noti-label w100">Address:<span
											class="strColor">*</span>
										</label> 
										<input type="text" value="" id="address1New" name="address1" class="textField w170 required"> <br	class="clear" /> 
										<label class="noti-label w100"></label> 
										<input	type="text" value="" id="address2New" name="address2" class="textField w170"> <br class="clear" />
										 <label class="noti-label w100">City:<span class="strColor">*</span></label> 
										<input type="text" value="" id="cityNew" name="city" class="textField w170 required"> <br	class="clear" /> 
										<label class="noti-label w100">State:<span	class="strColor">*</span>
										</label> <input type="text" value="" name="state" id="mainStateNew" class="textField w170 stateClass required">
										<br /> <br class="clear" /> <label class="noti-label w100">Zip
											Code:<span class="strColor">*</span>
										</label> <input type="text" value="" id="zipcodeNew" name="zipcode" class="textField w170 required "> <br
											class="clear" />
											 <label class="noti-label w100">Toll Free:</label>
										<input type="text" value="" id="tollFree" name="tollFree" class="textField w170 tollFree"> <br
											class="clear" />
									</div>


									<div class="widhth50">

										<label class="noti-label w100">Country:<span
											class="strColor">*</span>
										</label>
										 <select  class="valid w180 required"  id="countryIdNew" name="country.id" >
											<option value="">Select the Country</option>
												<c:forEach items="${countryList}" var="country">
													
														<option value="${country.id}" >${country.name}</option>
												</c:forEach>		    
										</select> 
										<br class="clear" /> <label class="noti-label w100">Phone:<span
											class="strColor">*</span>
										</label> <input type="text" value="" id="phone1New" name="phone1" class="textField w170 required number "> <br
											class="clear" /> <label class="noti-label w100">Phone:</label>
										<input type="text" value="" id="phone2New" name="phone2" class="textField w170 "> <br
											class="clear" /> <label class="noti-label w100">Fax:</label>
										<input type="text" value="" id="faxNew"  name="fax" class="textField w170 "> <br class="clear" />
											 <label class="noti-label w100">Website:</label>
										<input type="text" value="" id="websiteNew" name="website" class="textField w170 url"> <br
											class="clear" />
										 <label class="noti-label w100">Email Id:</label>
										<input type="text" value="" id="email1New" name="email1" class="textField w170 email"> <br
											class="clear" />
										 <label class="noti-label w100">Email Id:</label>
										<input type="text" value="" id="email2New" name="email2" class="textField w170 email"> <br
											class="clear" />

									</div>
									
									<div class="clear"></div>

								</div>



							</div>

						</div>
						<br /> <br class="clear" />
 <div class="BorderLine"></div>
               <div class="fl mandatoryTxt"><span class="strColor">*</span> Mandatory fields</div>
    <div class="fr">
			<input type="submit" name="saveInstitution" value="Save" id="saveInstitutionNew" class="button">
			<input type="button" name="cancel" value="Cancel" id="cancelInstitutionNew" class="button">
		</div>
        <div class="clear"></div>
    </div>
    </form>
         <br />
          <br  class="clear"/>
 </div>       
        </div>
        
        <div style="border: 1px solid #e7e7e7; margin:15px;"
					class="institute">


					<table width="100%" cellspacing="0" cellpadding="0" border="0"
						class="noti-tbl3 noti-bbn">
						<thead>
							<tr>
								<th width="40%" scope="col" class="dividerGrey"><span>Institution</span>
								</th>
								<th width="15%" scope="col" class="dividerGrey"><span>Date
										Created</span>
								</th>
								<th width="15%" scope="col" class="dividerGrey"><span>Date
										Modified</span>
								</th>
								<th width="30%" scope="col" class="dividerGrey"><span>Transcript
										Evaluation Status</span>
								</th>
							 </tr>	
						</thead>
						<tbody>
							<c:forEach items="${transcriptSummaryList}" var="transcriptSummary" varStatus="loop">		
								<tr>
									<td><a href="launchEvaluation.html?operation=getAllCoursesAndDegreesForStudentAndInstitute&studentId=${transcriptSummary.studentInstitutionTranscript.student.id}&institutionId=${transcriptSummary.studentInstitutionTranscript.institution.id}&institutionAddressId=${transcriptSummary.studentInstitutionTranscript.institutionAddress.id}" id="${transcriptSummary.studentInstitutionTranscript.id}" class="add">${transcriptSummary.studentInstitutionTranscript.institution.name}</a></td>
									<td><fmt:formatDate value='${transcriptSummary.dateCreated}' pattern='MM/dd/yyyy'/></td>
									<td><fmt:formatDate value='${transcriptSummary.dateModified}' pattern='MM/dd/yyyy'/></td>
									<td>${transcriptSummary.transcriptEvaluationStatus}</td>
								</tr>
						   </c:forEach>
					   </tbody>
					</table>
				</div>
					</div>
					
              
			
			</div>
		</div>




