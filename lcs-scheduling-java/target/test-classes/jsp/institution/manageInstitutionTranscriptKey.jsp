 <%@include file="../init.jsp" %>
 <script type="text/javascript" src="<c:url value="/js/evaluationHome.js"/>"></script> 
 <script>
 var optionString='';
 function addInstitutionTranscriptKey(institutionTranscriptKeyId) {
	 var url
	 if(institutionTranscriptKeyId=="0"){
		 url="<c:url value='/institution/manageInstitution.html?operation=addInstitutionTranscriptKey&institutionId=${institutionId}'/>";
	 }else{
		 url="<c:url value='/institution/manageInstitution.html?operation=addInstitutionTranscriptKey&institutionId=${institutionId}&institutionTranscriptKeyId="+institutionTranscriptKeyId+"'/>";
	}
	
		Boxy.load(url,
			{ unloadOnHide : true, 
			afterShow : function() {
		
				var placeholder = "@placeholder@";
				var appendInsText = 
					"<tr><th><input id='from_"+placeholder+"' name='institutionTranscriptKeyDetailsList["+placeholder+"].from' type='text' class='textField small ' style='border:1px' /></th>"
				    +
				    "<th><input name='institutionTranscriptKeyDetailsList["+placeholder+"].to' id='to_"+placeholder+"' type='text' class='textField small ' style='border:1px'  /></th>"
				    +
				    "<th><select id='courseLevelId_"+placeholder+"' name='institutionTranscriptKeyDetailsList["+placeholder+"].gcuCourseLevel.id' class=' eventCaptureField' > <option id='' value=''>Select Course Level</option>"+optionString+"</select></th>"
				    +
					"<th id='removeRowTd_"+placeholder+"'><a href='#' id='removeRow_"+placeholder+"' name='removeRow_"+placeholder+"' class='removeInstitutionRow'>Remove</a></th></tr>";
					
				addDynamicRows( 'eventCaptureField', 'blur', 'addTranscriptKeyTbl', 'removeRowTd_', appendInsText, placeholder );

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
						jQuery("#removeRowTd_"+(rowIndex)).html( "<a href='#' id='removeRow_"+rowIndex+"' name='removeRow_"+rowIndex+"' class='removeInstitutionRow'>Remove</a>" );
					}
				} );
			
				jQuery("#frmTranscriptKey").validate({
					 submitHandler: function(form) {
					   form.submit();
					 }
				});
				settingMaskInput();
				
			}
			});
	}
 </script>
 <center>
 <div class="tblFormDiv divCover outLine">
 <div class="innerDiv" >
        <table class="tableForm" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <th class="heading" colspan="5"><strong>View / Edit Transcript Key</strong></th>
            </tr>
        </table>
        <br class="clear" />
         <table class="tableS2" width="100%" style="border-collapse: collapse; border-color: #AAAFB2"
            border="1" cellspacing="0" cellpadding="0">
            <tr>
                <th width="10%" rowspan="2">
                    Record #
                </th>
                <th width="60%" colspan="3">Transfer Institute Course Numbering</th>
                <th width="10%" rowspan="2">
                    Effective Date</th>
                <th width="10%" rowspan="2">
                    End Date</th>
                <th width="10%" rowspan="2">
                    Action
                </th>
            </tr>
            <tr><th colspan="3">
			<table width="100%" style="border-collapse: collapse; border-color: #AAAFB2"
            border="1" cellspacing="0" cellpadding="0" >
            <tr>
                <th width="30%">From</th>
                <th width="30%" >To</th>
                <th width="40%" >GCU Course Level</th>
              </tr>
				</table></th>
            </tr>
			
			 <c:forEach items="${institutionTranscriptKeyList}" var="institutionTranscriptKey" varStatus="index">
			
            <tr>
                <td  width="10%">${index.count}</td>
				<td width="40%" colspan="3"> 
				<table width="100%" style="border-collapse: collapse; border-color: #AAAFB2"  border="1" cellspacing="0" cellpadding="0" > 
					<c:forEach items="${institutionTranscriptKey.institutionTranscriptKeyDetailsList}" var="institutionTranscriptKeyDetails" varStatus="index2">
						<tr><td width="30%">${institutionTranscriptKeyDetails.from}</td>
						<td width="30%">${institutionTranscriptKeyDetails.to}</td>
						<td width="40%">${institutionTranscriptKeyDetails.gcuCourseLevel.name}</td> </tr>
					</c:forEach>
					</table>
				</td>
                
                <td align="center"  width="15%"><fmt:formatDate value="${institutionTranscriptKey.effectiveDate}" pattern="MM/dd/yyyy"/></td>
                <td align="center"  width="15%"> <fmt:formatDate value="${institutionTranscriptKey.endDate}" pattern="MM/dd/yyyy"/></td>
                <td align="center"  width="10%"><a onclick='addInstitutionTranscriptKey("${institutionTranscriptKey.id}")'   href="#">Edit</a></td>
            </tr>
            
			</c:forEach>
            
       
            
            
        </table>
        <table class="" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <td width="35%"> </td>
                <td width="65%" align="right" style="padding-top:10px">
                    <input type="button" value="Add New Transcript Key" name="P Institution" class="button"
                    onclick='addInstitutionTranscriptKey("0")'   /> 
                      <input type="button" value="Back"  class="button backlink" />
                </td>
            </tr>
        </table>
        
    </div>    
    </div>
   </center>