 <%@include file="../init.jsp" %>
 <script type="text/javascript" src="<c:url value="/js/evaluationHome.js"/>"></script> 
 <script>
 var optionString='';
 function addArticulationAgreement(articulationAgreementId) {
	 var url
	 if(articulationAgreementId=="0"){
		 url="<c:url value='/institution/manageInstitution.html?operation=addArticulationAgreement&institutionId=${institutionId}'/>";
	 }else{
		 url="<c:url value='/institution/manageInstitution.html?operation=addArticulationAgreement&institutionId=${institutionId}&articulationAgreementId="+articulationAgreementId+"'/>";
	}
	
		Boxy.load(url,
			{ unloadOnHide : true, 
			afterShow : function() {
				
				var placeholder = "@placeholder@";
				var appendInsText =					
				    "<tr><th><select id='gcuCourseCategory_"+placeholder+"' name='articulationAgreementDetailsList["+placeholder+"].gcuCourseCategory' class=' eventCaptureField' > <option id='' value=''>Select Course Category</option>"+optionString+"</select></th>"
				    +
					"<th id='removeRowTd_"+placeholder+"'><a href='#' id='removeRow_"+placeholder+"' name='removeRow_"+placeholder+"' class='removeInstitutionRow'>Remove</a></th></tr>";
					
				addDynamicRows( 'eventCaptureField', 'blur', 'addArticulationAgreementTbl', 'removeRowTd_', appendInsText, placeholder );

				//Remove rows when Remove link is clicked.
				jQuery(".removeInstitutionRow").live('click', function(event) {
					//remove the current row
					jQuery(this).parent().parent().remove();

					//set the remove link for the previous row in the table unless it is the first row.
					var noOfRows = jQuery("#addArticulationAgreementTbl").attr('rows').length;
					rowIndex = noOfRows - 2;
					if( rowIndex == -1 ) {
						rowIndex = 0;
					}
					if( rowIndex > 0 ) {
						jQuery("#removeRowTd_"+(rowIndex)).html( "<a href='#' id='removeRow_"+rowIndex+"' name='removeRow_"+rowIndex+"' class='removeInstitutionRow'>Remove</a>" );
					}
				} );
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
                <th class="heading" colspan="5"><strong>View / Edit Articulation Agreement</strong></th>
            </tr>
        </table>
        <br class="clear" />
         <table class="tableS2" width="100%" style="border-collapse: collapse; border-color: #AAAFB2"
            border="1" cellspacing="0" cellpadding="0">
            <tr>
                <th width="10%" >
                    Record #
                </th>
                <th width="20%" >Other Institution Degree</th>
                <th width="20%" >GCU Degree</th>
                <th width="40%" > GCU Course Category Requirement</th>
                <th width="10%" >Effective Date</th>
                <th width="10%" >End Date</th>
                <th width="10%" >Action</th>
            </tr>
            
			 <c:forEach items="${articulationAgreementList}" var="articulationAgreement" varStatus="index">
			
            <tr>
            	<td  >${index.count}</td>
            	
                <td  >${articulationAgreement.institutionDegree}</td>
                <td  >${articulationAgreement.gcuDegree}</td>
                
				<td width="40%" > 
				<table width="100%" style="border-collapse: collapse; border-color: #AAAFB2"  border="1" cellspacing="0" cellpadding="0" > 
					<c:forEach items="${articulationAgreement.articulationAgreementDetailsList}" var="articulationAgreementDetails" varStatus="index2">
						<tr><td width="30%">${articulationAgreementDetails.gcuCourseCategory}</td></tr>
						</c:forEach>
					</table>
				</td>
                
                <td align="center"  width="15%"><fmt:formatDate value="${articulationAgreement.effectiveDate}" pattern="MM/dd/yyyy"/></td>
                <td align="center"  width="15%"> <fmt:formatDate value="${articulationAgreement.endDate}" pattern="MM/dd/yyyy"/></td>
                <td align="center"  width="10%"><a onclick='addArticulationAgreement("${articulationAgreement.id}")'   href="#">Edit</a></td>
            </tr>
            
			</c:forEach>
            
       
            
            
        </table>
        <table class="" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <td width="35%"> </td>
                <td width="65%" align="right" style="padding-top:10px">
                    <input type="button" value="Add New Articulation Agreement" name="P Institution" class="button"
                    onclick='addArticulationAgreement("0")'   /> 
                       <input type="button" value="Back"  class="button backlink" />
                </td>
            </tr>
        </table>
        
</div>        
    </div>
 </center>