

<div class="deo2">
  <div>
  	<div class="noti-tools2" style="border:1px solid #e7e7e7;">
	    <ul class="pageNav">
        
        <li><a href="${institutionDetail}" style="z-index:9;">Institution Details <span class="sucssesIcon"></span></a></li>
        <li><a href="${aBodyLink }" style="z-index:8;" >Accrediting Body  <c:choose> <c:when test="${fn:length(institution.accreditingBodyInstitutes)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise > <span class="alrtIcon"></span> </c:otherwise></c:choose>  </a> </li>
        <li><a href="${termTypeLink }" style="z-index:7;">Term Types <c:choose> <c:when test="${fn:length(institution.institutionTermTypes)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise > <span class="alrtIcon"></span> </c:otherwise></c:choose></a> </li>
        <li><a href="${transcriptKeyLink }" style="z-index:6;">Transcript Key <c:choose> <c:when test="${fn:length(institution.institutionTranscriptKeys)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span>  </c:otherwise></c:choose></a> </li>
        <li><a href="${markCompleteLink }" class="last active">Summary</a></li>
        
        </ul>
    	<div class="infoContnr"><div class="infoTopArow infoarow6"></div>
    	  <div class="markBordr">
          <h3>Institution Details <span class="sucssesIcon"></span></h3>
          <div class="p15">
          <table width="100%" border="0" cellspacing="0" cellpadding="0" class="contentForm">
    	    <tr>
    	      <td width="45%" align="left" valign="top"> <label class="noti-label w130">Institution Name:</label>
                    <span class="textview">${institution.name}</span>
                  <br  class="clear"/>
                   <label class="noti-label w130">Institution Id:</label>
                    <label class="caption">${institution.institutionID}</label>
                    <br  class="clear"/>
                  <label class="noti-label w130">Address(s):</label>
                  <c:forEach items="${institution.addresses}" var="address" varStatus="index">
                    
                    <div class="aseladdOverflow3">${address.address1} ${address.address2}
						${address.city} ${address.state}
						 ${address.zipcode} ${address.country.name}<br />
						<c:if test="${!empty address.phone1 }">Phone: ${address.phone1}</c:if>
						<c:if test="${!empty address.phone2 }">, ${address.phone2}<br /> </c:if>
						<c:if test="${!empty address.fax }">Fax: ${address.fax}	</c:if> 
						<c:if test="${!empty address.tollFree }">Toll Free:${address.tollFree} <br /></c:if> 
						<c:if test="${!empty address.website }">Website: ${address.website} </c:if>
						<c:if test="${!empty address.email1 }">Email Id: ${address.email1} </c:if>
						<c:if test="${!empty address.email2 }">, ${address.email2}</c:if>
              </div>
              
                    <br  class="clear"/>
                     <br />
                    <label class="noti-label w130"></label>
                </c:forEach>    
                    
                    
                 
              </td>
    	      <td width="5%" class="tblBordr">&nbsp;</td>
    	      <td width="45%" align="left" valign="top"><label class="noti-label w130">College Board Code:</label>
                  <span class="textview">${institution.schoolcode }</span><br  class="clear"/>
                    <label class="noti-label w130">Institution Type:</label>
                     <span class="textview">${institution.institutionType.name }</span>
                    <br  class="clear"/>
                    <label class="noti-label w130">Location Type:</label>
                    <span class="textview">${institution.locationId }</span><br  class="clear"/>
                    <label class="noti-label w130">Parent Institute:</label>
                    <span class="textview">${institution.parentInstitutionName}</span><br  class="clear"/>
                 
</td>
  	      </tr>
  	    </table></div>
          </div>
          <div class="divider"></div>
          
  
         
          
          <c:choose> <c:when test="${fn:length(institution.accreditingBodyInstitutes)>0}">
          <div class="markBordr ">
          <h3>Accrediting Body   <span class="sucssesIcon"></span> </h3> </c:when>
          <c:otherwise>  <div class="markBordr orangBordr"> 
          <h3>Accrediting Body  <span class="alrtIcon"></span> </h3></c:otherwise></c:choose>
          <div>
          <table width="100%" cellspacing="0" cellpadding="0" border="0" class="noti-tbl3 tabTBLborder mb0">
       <tbody>
       <tr>
         <th width="60%" scope="col" class=""> Accrediting Body</th>
         <th width="20%" scope="col" class="dividerGrey">Effective Year</th>
         <th width="20%" scope="col" class="dividerGrey">End Year</th>
          
         
       </tr>
     <c:choose>

        <c:when test="${fn:length(institution.accreditingBodyInstitutes)>0}">  
       <c:forEach items="${institution.accreditingBodyInstitutes}" var="accreditingBodyInstitute" varStatus="index">
       <tr>
         <td><span>${accreditingBodyInstitute.accreditingBody.name}</span></td>
         <td><span>${accreditingBodyInstitute.effectiveDate}</span></td>
         <td><span>${accreditingBodyInstitute.endDate}</span></td>
       <%--   <td><span>
       <c:choose>
     	<c:when test="${accreditingBodyInstitute.effective == 'true'}"> YES  </c:when>
         <c:otherwise>NO</c:otherwise>
       </c:choose>
         </span></td>
         --%>
         </tr>
        </c:forEach>
         </c:when>
     
 		<c:otherwise> <tr class="infoBottomBrNon">
		  <td colspan="4"><span><em>No Record Found.</em></span></td>
		  </tr>
 		</c:otherwise>
 		</c:choose>
       </tbody>
     </table></div>
          </div>
          
          <div class="divider"></div>
           <c:choose> <c:when test="${fn:length(institution.institutionTermTypes)>0}">
          <div class="markBordr">
          <h3>Term Type<span class="sucssesIcon"></span></h3>
          </c:when>
          <c:otherwise>  <div class="markBordr orangBordr">  
          <h3>Term Type<span class="alrtIcon"></span> </h3></c:otherwise></c:choose>
          
          <div>
		  <table width="100%" cellspacing="0" cellpadding="0" border="0" class="noti-tbl3 tabTBLborder  mb0">
       <tbody>
       <tr>
         <th width="60%" scope="col" class=""> Term Type</th>
         <th width="20%" class="dividerGrey" scope="col">Effective Date</th>
         <th width="20%" class="dividerGrey" scope="col">End Date</th>
         <!--  <th width="7%" align="center" class="dividerGrey" scope="col">Effective</th> -->
         
       </tr>
        <c:choose>

        <c:when test="${fn:length(institution.institutionTermTypes)>0}">  
      <c:forEach items="${institution.institutionTermTypes}" var="institutionTermType" varStatus="index">
       <tr>
         <td><span>${institutionTermType.termType.name}</span></td>
         <td><span><fmt:formatDate value="${institutionTermType.effectiveDate}" pattern="MM/dd/yyyy"/></span></td>
         <td><span><fmt:formatDate value="${institutionTermType.endDate}" pattern="MM/dd/yyyy"/></span></td>
         <%-- <td><span>
	        <c:choose>
	     	<c:when test="${institutionTermType.effective == 'true'}"> YES  </c:when>
	         <c:otherwise>NO</c:otherwise>
	       </c:choose>
         </span></td>
         --%>
         </tr>
        </c:forEach>
          </c:when>
     
 		<c:otherwise> <tr class="infoBottomBrNon">
		  <td colspan="4"><span><em>No Record Found.</em></span></td>
		  </tr>
 		</c:otherwise>
 		</c:choose>
       </tbody>
     </table></div>
          </div>
          
          <div class="divider"></div>
        <c:choose> <c:when test="${fn:length(institution.institutionTranscriptKeys)>0}">   
        <div   class="markBordr2"   >
		 <h3>Transcript Key <span class="sucssesIcon"></span></h3>
		</c:when><c:otherwise>
          <div   class=" markBordr2 orangBordr"   >
		 <h3>Transcript Key <span class="alrtIcon"></span></h3>
		  </c:otherwise></c:choose>
          <div>
    		<div class="mt10 markBordr">
        	<div class="tabHeader">Course Level</div>
            <div><table cellspacing="0" cellpadding="0" border="0" width="100%" class="noti-tbl3 noti-bbn tabTBLborder contentForm">
  <tbody><tr>
     <th width="20%" class="dividerGrey"><span>From</span></th>
	 <th width="20%" class="dividerGrey"><span>To</span></th>
	 <th width="60%"><span>GCU Course Level</span></th>
    </tr>
 
   <c:choose>
		  <c:when test="${fn:length(institution.institutionTranscriptKeys)>0}">  
				 <c:forEach items="${institution.institutionTranscriptKeys}" var="institutionTranscriptKey" varStatus="index">
				
				<c:forEach items="${institutionTranscriptKey.institutionTranscriptKeyDetailsList}" var="institutionTranscriptKeyDetails" varStatus="index2">
					<tr>
						<td width="20%"><span>${institutionTranscriptKeyDetails.from}</span></td>
						<td width="20%"><span>${institutionTranscriptKeyDetails.to}</span></td>
						<td width="60%"><span>${institutionTranscriptKeyDetails.gcuCourseLevel.name}</span></td>
					</tr>
				</c:forEach>
				</c:forEach>
    </c:when>
 		<c:otherwise>   <tr class="infoBottomBrNon">
		  <td colspan="4"><span><em>No Record Found.</em></span></td>
		  </tr>
 		</c:otherwise>
 		</c:choose>   
</tbody></table></div>
    		</div>
  <c:if test="${fn:length(institution.institutionTranscriptKeys)>0}">        
        <div class="contentForm p0">
        	<div class="mt30">
        	<label class="noti-label">Grading System</label>
            <br class="clear">

        	<div class="dateReceived ">
            	
                <label class="noti-label w100 ">Effective Date:</label>
                  <label class="noti-label45"><fmt:formatDate value="${institution.institutionTranscriptKeys[0].effectiveDate}" pattern="MM/dd/yyyy"/></label>
            
          </div>
        	<div class="lastAttend">
            
            	<label class="noti-label w70">End Date:</label>
                  <label class="noti-label45"><fmt:formatDate value="${institution.institutionTranscriptKeys[0].endDate}" pattern="MM/dd/yyyy"/></label>
            
          </div>
            <div class="clear"></div>
            <div class="clear"></div>            
        
        </div>        
        
        
        </div>
        	
            <div id="numericCont" class="mt10 markBordr">
        	<div class="tabHeader">Alphabet Grade</div>
            <div><table cellspacing="0" cellpadding="0" border="0" width="100%" class="noti-tbl3 noti-bbn tabTBLborder contentForm">
  <tbody><tr>
    <th width="18%" class="dividerGrey" scope="col">Grade</th>
    <th width="39%" class="dividerGrey" scope="col">Short Description</th>
    <th width="39%" scope="col">Long Description</th>
    </tr>
  <c:forEach items="${institution.institutionTranscriptKeys[0].institutionTranscriptKeyGradeAlphaList}" var="institutionTranscriptKeyGradeAlpha" varStatus="loop">
  <tr>
    <td>${institutionTranscriptKeyGradeAlpha.gradeAlpha }</td>
    <td>${institutionTranscriptKeyGradeAlpha.shortDescription }</td>
    <td>${institutionTranscriptKeyGradeAlpha.longDescription } </td>
    </tr>
    </c:forEach>
            </tbody></table>
            </div>
            </div>
        
        <div id="alfaCont" class="mt10 markBordr">
        	<div class="tabHeader">Numeric Grade</div>
            <div><table cellspacing="0" cellpadding="0" border="0" width="100%" class="noti-tbl3 noti-bbn tabTBLborder contentForm">
  <tbody><tr>
    <th width="18%" class="dividerGrey" scope="col">Grade</th>
    <th width="39%" class="dividerGrey" scope="col">Short Description</th>
    <th width="39%" scope="col">Long Description</th>
    </tr>
    <c:forEach items="${institution.institutionTranscriptKeys[0].institutionTranscriptKeyGradeNumberList}" var="institutionTranscriptKeyGradeNumber" varStatus="loop">
  <tr>
    <td><span class="fl w50px">${institutionTranscriptKeyGradeNumber.gradeFrom }</span>
     <span class="fl mr10 ml10"> <strong>To</strong></span> &nbsp;&nbsp;
        <span class="fl w50px">${institutionTranscriptKeyGradeNumber.gradeTo}</span></td>
   <td>${institutionTranscriptKeyGradeNumber.shortDescription }</td>
    <td>${institutionTranscriptKeyGradeNumber.longDescription } </td>
     </tr>
     </c:forEach>
            </tbody></table>
            </div>
        </div>
        
    </c:if>
        </div>
          </div>
        
    
	   <div class="clear"></div>
	 <div class="fr mt10">
      
          <c:if test="${fn:toUpperCase(userRoleName) eq 'INSTITUTION EVALUATION MANAGER' }">
          	<input type="button" name="list" onclick="location.href='/scheduling_system/evaluation/ieManager.html?operation=getInstitutionList'" value="Back to Institution List" class="button">
           </c:if>
          
           <c:if test="${fn:toUpperCase(userRoleName) eq 'INSTITUTION EVALUATOR' && fn:toUpperCase(institution.evaluationStatus) eq 'NOT EVALUATED' && ((!empty institution.checkedBy && institution.checkedBy eq userCurrentId) || (!empty institution.confirmedBy && institution.confirmedBy eq userCurrentId))}">
          	<input type="submit" name="MarkComplete" onclick="location.href='/scheduling_system/evaluation/quality.html?operation=markComplete&institutionId=${institution.id}'" value="Mark Complete" id="saveInstitution" class="button">
           </c:if>
           
           
		</div>
        <div class="clear"></div>
     
       </div>
	  </div>     
     </div>
	 </div>
	     
        
        
    
 
    
  
