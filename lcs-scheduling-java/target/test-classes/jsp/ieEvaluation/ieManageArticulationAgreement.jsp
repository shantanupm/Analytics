 <%@include file="../init.jsp" %>
 <script type="text/javascript" src="<c:url value="/js/evaluationHome.js"/>"></script> 
 <script>
 var optionString='';
 function addArticulationAgreement(articulationAgreementId) {
	 var url;
	 if('${role}'=='MANAGER'){
		 if(articulationAgreementId=="0"){
			 url="<c:url value='/evaluation/ieManager.html?operation=addArticulationAgreement&institutionId=${institutionId}'/>";
		 }else{
			 url="<c:url value='/evaluation/ieManager.html?operation=addArticulationAgreement&institutionId=${institutionId}&articulationAgreementId="+articulationAgreementId+"'/>";
		}
	}else{
		 if(articulationAgreementId=="0"){
			 url="<c:url value='/evaluation/quality.html?operation=addArticulationAgreement&institutionMirrorId=${institutionMirrorId}'/>";
		 }else{
			 url="<c:url value='/evaluation/quality.html?operation=addArticulationAgreement&institutionMirrorId=${institutionMirrorId}&articulationAgreementId="+articulationAgreementId+"'/>";
		}
	}
		Boxy.load(url,
			{ unloadOnHide : true, 
			afterShow : function() {
				
				var placeholder = "@placeholder@";
				var appendInsText =					
				    "<tr><td><select id='gcuCourseCategory_"+placeholder+"' name='articulationAgreementDetailsList["+placeholder+"].gcuCourseCategory' class=' eventCaptureField' > <option id='' value=''>Select Course Category</option>"+optionString+"</select></td>"
				    +
					"<td id='removeRowTd_"+placeholder+"'>"
					+"<a onclick='addArticulationAgreementTblRow("+placeholder+");' class='addRow' name='addRow_"+placeholder+"' id='addRow_"+placeholder+"' href='javascript:void(0)'><img width='15' height='14' src='../images/addCourse.png' alt='add'> Add New</a><br/><a href='#' id='removeRow_"+placeholder+"' name='removeRow_"+placeholder+"' class='removeInstitutionRow removeRow'><img width='15' height='15' src='../images/removeIcon.png' alt='Delete'>Remove</a></td></tr>";
					
					//addRowsAtFly( 'eventCaptureField', 'blur', 'addArticulationAgreementTbl', 'removeRowTd_', appendInsText, placeholder );
				//addDynamicRows( 'eventCaptureField', 'blur', 'addArticulationAgreementTbl', 'removeRowTd_', appendInsText, placeholder );

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
						jQuery("#removeRowTd_"+(rowIndex)).html( "<a onclick='addArticulationAgreementTblRow("+rowIndex+");' class='addRow' name='addRow_"+rowIndex+"' id='addRow_"+rowIndex+"' href='javascript:void(0)'><img width='15' height='14' src='../images/addCourse.png' alt='add'> Add New</a><br/><a href='#' id='removeRow_"+rowIndex+"' name='removeRow_"+rowIndex+"' class='removeInstitutionRow removeRow'><img width='15' height='15' src='../images/removeIcon.png' alt='Delete'>Remove</a>" );
					}else if(rowIndex == 0){
						jQuery("#removeRowTd_"+(rowIndex)).html( "<a onclick='addArticulationAgreementTblRow("+rowIndex+");' class='addRow' name='addRow_"+rowIndex+"' id='addRow_"+rowIndex+"' href='javascript:void(0)'><img width='15' height='14' src='../images/addCourse.png' alt='add'> Add New</a>" );
					}
				} );
				settingMaskInput();
				
				jQuery.validator.addMethod("dateRange", function() {
					if(jQuery("#endDate").val()!="" && isDate(jQuery("#endDate").val())){
	 					return new Date(jQuery("#effectiveDate").val()) < new Date(jQuery("#endDate").val());
					}
					return true;
	 			}, "End date should be greater than the effective date.");
	 			
	 			jQuery.validator.addClassRules({
	 				requiredDateRange: {  dateRange:true}
	 			});
	 			
				jQuery("#frmArticulationAgreement").validate();
			}
			});
	}
 
 	jQuery(document).ready(function(){
		jQuery("[name='effective']").change(function(){
			if('${role}'=='MANAGER'){
				window.location.href='ieManager.html?operation=effectiveArticulationAgreement&institutionId=${institutionId}&articulationAgreementId='+jQuery(this).val();
			}else{
				window.location.href='quality.html?operation=effectiveArticulationAgreement&institutionMirrorId=${institutionMirrorId}&articulationAgreementId='+jQuery(this).val();
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
        <li><a href="${aBodyLink }" style="z-index:8;" >Accrediting Body  <c:choose> <c:when test="${fn:length(institution.accreditingBodyInstitutes)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise > <span class="alrtIcon"></span></c:otherwise></c:choose>  </a> </li>
        <li><a href="${termTypeLink }" style="z-index:7;">Term Types <c:choose> <c:when test="${fn:length(institution.institutionTermTypes)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose></a> </li>
        <li><a href="${transcriptKeyLink }" style="z-index:6;">Transcript Key <c:choose> <c:when test="${fn:length(institution.institutionTranscriptKeys)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose></a> </li>
        <li><a href="${aAgreementLink }" style="z-index:5;" class="active">Articulation Agreement <c:choose> <c:when test="${fn:length(institution.articulationAgreements)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise > <span class="alrtIcon"></span></c:otherwise></c:choose>  </a> </li>
      	<li><a href="${markCompleteLink }" class="last">Summary</a></li>

        </ul>
    	<div class="infoContnr"><div class="infoTopArow infoarow5"></div>
    	<div class="fr institutionHeader">
       		<a href="javascript:void(0)" onclick='addArticulationAgreement("0")'><img alt="" src="../images/termTypeIcon.png">Add Articulation Agreement</a>
        </div><br class="clear">
        
 	
<c:choose>
        <c:when test="${fn:length(articulationAgreementList)>0}">
	<table width="100%" cellspacing="0" cellpadding="0" border="0" class="noti-tbl">
       <tbody>
          <tr>
                <th width="25%" class="dividerGrey">Other Institution Degree</th>
                <th width="20%" class="dividerGrey">GCU Degree</th>
                <th width="45%" class="dividerGrey"> GCU Course Category Requirement</th>
                <th width="10%" class="dividerGrey">Effective Date</th>
                <th width="10%" class="dividerGrey">End Date</th>
                <th width="10%" scope="col" class="dividerGrey">Effective</th>
                <th width="10%" class="dividerGrey">Action</th>
            </tr>
        <c:forEach items="${articulationAgreementList}" var="articulationAgreement" varStatus="index">
			 <tr>
            	<td  ><span>${articulationAgreement.institutionDegree}</span></td>
                <td  ><span>${articulationAgreement.gcuDegree}</span></td>
              	<td width="40%" > 
				<table width="100%" style="border-collapse: collapse; border-color: #AAAFB2"  border="0" cellspacing="0" cellpadding="0" > 
					<c:forEach items="${articulationAgreement.articulationAgreementDetailsList}" var="articulationAgreementDetails" varStatus="index2">
						<tr><td width="30%"><span>${articulationAgreementDetails.gcuCourseCategory}</span></td></tr>
						</c:forEach>
					</table>
				</td>
                
                <td align="center"  width="15%"><span><fmt:formatDate value="${articulationAgreement.effectiveDate}" pattern="MM/dd/yyyy"/></span></td>
                <td align="center"  width="15%"> <span><fmt:formatDate value="${articulationAgreement.endDate}" pattern="MM/dd/yyyy"/></span></td>
                <td><span>
			       <c:choose>
			     	<c:when test="${role != 'ADMIN'}"> 
				         <input type="radio" name="effective" value="${articulationAgreement.id}"  
				         <c:if test="${articulationAgreement.effective == 'true'}"> checked='checked'</c:if>/>
			         </c:when>
			         <c:otherwise>${articulationAgreement.effective}</c:otherwise>
			       </c:choose>
			       </span></td>
                <td align="center"  width="10%"><span><c:if test="${role != 'ADMIN'}"><a onclick='addArticulationAgreement("${articulationAgreement.id}")'   href="#">Edit</a></c:if></span></td>
            </tr>
            
			</c:forEach>
       </tbody>
     </table>
 	 </c:when>
 		<c:otherwise> <div class="notifyMsg">No Records Found </div>
 		</c:otherwise>
 		</c:choose>
 	</div>
 	
 	
 <!-- 	

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
                <td align="center"  width="10%"><c:if test="${role != 'ADMIN'}"><a onclick='addArticulationAgreement("${articulationAgreement.id}")'   href="#">Edit</a></c:if></td>
            </tr>
            
			</c:forEach>
            
       
            
            
        </table>
        <table class="" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <td width="35%"> </td>
                <td width="65%" align="right" style="padding-top:10px">
                 <c:if test="${role != 'ADMIN'}">
                    <input type="button" value="Add New Articulation Agreement" name="P Institution" class="button"
                    onclick='addArticulationAgreement("0")'   /> 
                    </c:if>
                       <input type="button" value="Back" onclick='window.location = "${backLink}"' class="button" />
                </td>
            </tr>
        </table>
        
</div>        
    </div>
 </center> -->
  