<%@include file="../init.jsp"%>
<script>
jQuery(document).ready(function(){
	//before "mark complete" make sure the course mapping is added or course is not eligible for transfer
	jQuery("#markComplete").click(function(){
		if('${transferCourse.transferStatus}'.toLowerCase() == 'Eligible'.toLowerCase()){
			if(${fn:length(transferCourse.courseMappings)==0} && ${fn:length(transferCourse.courseCategoryMappings)==0}){
				alert("Add a mapping for the course");
			}
			else{
				window.location = "<c:url value='/evaluation/quality.html?operation=markCompleteCourse&transferCourseMirrorId=${transferCourseMirrorId}'/>";
			}
		}
		else{
			window.location = "<c:url value='/evaluation/quality.html?operation=markCompleteCourse&transferCourseMirrorId=${transferCourseMirrorId}'/>";
		}
		
	});
});
function loadCorrespondingPage(urlToLoad){
	window.location = urlToLoad;
}
</script>
<c:choose>
     	<c:when test="${userRoleName =='Institution Evaluation Manager'}"> 
        	<c:set var="backLink" scope="session" value="/evaluation/ieManager.html?operation=ieCourse&transferCourseId=${transferCourseId}"/>
 	 	</c:when>
 	 	<c:when test="${userRoleName =='Administrator'}"> 
        	<c:set var="backLink" scope="session" value="/evaluation/admin.html?operation=viewCourseDetails&courseId=${transferCourseId}"/>
 	 	</c:when>
 		<c:otherwise>
 			<c:set var="backLink" scope="session" value="/evaluation/quality.html?operation=ieCourse&institutionMirrorId=${institutionMirrorId}&transferCourseId=${transferCourseId}"/>
 	 	</c:otherwise>
 	</c:choose>

<div>
  <div class="institute">
  	<div class="">
  	 <div class="institutionHeader">
		<a href="javaScript:void(0);" onClick="javaScript:loadCorrespondingPage('<c:url value="${courseDetailLink}"/>');" class="mr10"><img src="<c:url value='/images/arow_img.png'/>" width="15" height="13" alt="" />Back To Course Details</a>
	 </div>
	    <ul class="pageNav">        
	        <li><a  onclick="javaScript:loadCorrespondingPage('<c:url value="${courseDetailLink}"/>')" href="javaScript:void(0);" style="z-index:9;" >Course Details<span class="sucssesIcon"></span></a></li>
	      
	        <li><a <c:if test="${! empty relationLink}"> onclick="javaScript:loadCorrespondingPage('<c:url value="${relationLink}"/>&transferCourseMirrorId=${transferCourseMirrorId}')" </c:if> href="javaScript:void(0);" style="z-index:5;"
	        		<c:if test="${! empty transferCourse && transferCourse.transferStatus eq 'Eligible' }">
		        		
		        	</c:if>
		        	<c:if test="${! empty transferCourse && transferCourse.transferStatus eq 'Not Eligible' }">
		        		class="pageNavDisable"
		        	</c:if>
		        	<c:if test="${empty transferCourse || empty transferCourse.transferStatus}">
		        		class="pageNavDisable"
		        	</c:if>
	          >Course Relationship
	          <c:choose>
	          	<c:when test="${fn:length(transferCourse.courseCategoryMappings) gt 0 || fn:length(transferCourse.courseMappings) gt 0}">
	          		<span class="sucssesIcon"></span>
	          	</c:when>
	        	<c:otherwise>
		        	<c:if test="${! empty transferCourse && transferCourse.transferStatus eq 'Eligible' }">
		        		<span class="alrtIcon"></span>
		        	</c:if>	
		        	<c:if test="${! empty transferCourse && transferCourse.transferStatus eq 'Not Eligible' }">
			        		<span></span>
			        </c:if>
			        <c:if test="${empty transferCourse || empty transferCourse.transferStatus}">
			        		<span></span>
			        </c:if>
	        	</c:otherwise>
	         </c:choose>
	        	</a>
	        </li>
	        <li><a onclick="javaScript:loadCorrespondingPage('<c:url value="${markCompleteLinkCourse}"/>')" href="javaScript:void(0);" class="active last">Summary</a></li> 
        </ul>
        
        
        <div class="infoContnr"><div class="infoTopArow infoarow7"></div>
    	  <div class="markBordr">
          <h3>Transcript Key<span class="sucssesIcon"></span></h3>
          <div class="p15">
          <table width="100%" border="0" cellspacing="0" cellpadding="0" class="contentForm">
	    	    <tr>
	    	      <td width="45%" align="left" valign="top">
	    	       <label class="noti-label w130">Institution Name:<span class="astric">*</span></label>
	                    <span class="textview"><b>${transferCourse.institution.name}</b></span>
	                  	<br  class="clear"/>
	                <label class="noti-label w130">Institution Id:<span class="astric">*</span></label>
	                    <span class="textview">${transferCourse.institution.institutionID}</span>
	                  	<br  class="clear"/> 
	    	      	<label class="noti-label w130">TR Course Code:<span class="astric">*</span></label>
	                    <span class="textview">${transferCourse.trCourseCode}</span>
	                  	<br  class="clear"/>
	                   	<label class="noti-label w130">Course Title:<span class="astric">*</span></label>
	                     <span class="textview">${transferCourse.trCourseTitle}</span>
	                    <br  class="clear"/>
	                    
	                   <label class="noti-label w130">Transcript Credits:<span class="astric">*</span></label>
	                  	<span class="textview">${transferCourse.transcriptCredits }</span>
	                    <br  class="clear"/>
	                    
	                     <label class="noti-label w130">Semester Credits:</label>
	                     <span class="textview">${transferCourse.semesterCredits }</span>
	                     <br  class="clear"/>
	                    
	                     <label class="noti-label w130">Accepted Transfer Grades:</label>
	                     <div style="width:245px; float:left;"><c:forEach items="${transferCourse.transferCourseInstitutionTranscriptKeyGradeAssocList }" var="transferCourseInstitutionTranscriptKeyGradeAssoc" varStatus="gradeIndex">
	                     		<span class="textview w100">${transferCourseInstitutionTranscriptKeyGradeAssoc.gradeFrom }<c:if test="${! empty transferCourseInstitutionTranscriptKeyGradeAssoc.gradeTo }">-${transferCourseInstitutionTranscriptKeyGradeAssoc.gradeTo }</c:if></span>
	                     	<c:if test="${gradeIndex.index ne 0 && (gradeIndex.index%2) ne 0}">
	                        			
	                      </c:if>
	                     </c:forEach></div>
	                     <div class="clear"></div>
	                    <br  class="clear"/>
	                    
	                    
	                 
	              </td>
	    	      <td width="5%" class="tblBordr">&nbsp;</td>
	    	      <td width="45%" align="left" valign="top"><label class="noti-label w130">Course Level:<span class="astric">*</span></label>
	                  <span class="textview">${transferCourse.courseLevelId}</span><br  class="clear"/>
	                    <label class="noti-label w130">Clock Hours:</label>
	                     <span class="textview">${transferCourse.clockHours}</span>
	                    <br  class="clear"/>
	                    <label class="noti-label w130">Course Type:<span class="astric">*</span></label>
                    	<span class="textview">${transferCourse.courseType}</span>
                    	<br  class="clear"/>
	                    <label class="noti-label w130">Effective Date:<span class="astric">*</span></label>
	                    <span class="textview"><fmt:formatDate value="${transferCourse.effectiveDate}" pattern="MM/dd/yyyy"/></span>
	                    <br  class="clear"/>
	                    
	                    <label class="noti-label w130">End Date:</label>
	                    <span class="textview"><fmt:formatDate value="${transferCourse.endDate}" pattern="MM/dd/yyyy"/></span>
	                    <br  class="clear"/>
	                    
	                     <label class="noti-label w130">Catalog Course Description:</label>
	                     <span class="textview">${transferCourse.catalogCourseDescription }</span>
	                     <br  class="clear"/>
	                    
	                     <label class="noti-label w130">Transfer Status:</label>
	                     <span class="textview">${transferCourse.transferStatus }</span>
	                     <br  class="clear"/>
	                 
					</td>
	  	      </tr>
	  	    </table>
  	    
  	    </div>
          </div>
          <div class="divider"></div>
          
          <c:choose> 
	          	<c:when test="${fn:length(transferCourse.courseMappings)>0 || fn:length(transferCourse.courseCategoryMappings)>0}">
	          	<div class="markBordr2">
	          	<div class="markBordr">
	         	 	<h3>Course Relationship<span class="sucssesIcon"></span></h3>
	         	 </div>
	          </c:when>
	          <c:otherwise>
	          		<div class="markBordr2 orangBordr">  
	          		<div class="markBordr">  
	          			<h3>Course Relationship<span class="alrtIcon"></span> </h3>
	          		</div>
	          </c:otherwise>
          </c:choose>
         
          <div>
		          <div>
			          <table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl3 noti-bbn tabTBLborder contentForm">
						  <tr>
							    <th width="10%" scope="col" class="dividerGrey">GCU Course Code</th>
							    <th width="40%" scope="col" class="dividerGrey">Course Title</th>
							    <th width="15%" scope="col" class="dividerGrey">GCU Course Level</th>
							    <th width="5%" scope="col" class="dividerGrey">Credit</th>
							    <th width="10%" scope="col" class="dividerGrey">Effective Date</th>
							    <th width="10%" scope="col" class="dividerGrey">End Date</th>
							    <th width="5%" scope="col" class="dividerGrey">AND</th>
						  </tr>
			          	 <c:choose>
							<c:when test="${fn:length(transferCourse.courseMappings)>0}">  
	       						<c:forEach items="${transferCourse.courseMappings}" var="courseMapping" varStatus="index">
				       				<c:forEach items="${courseMapping.courseMappingDetails }" var="courseMappingDetail" varStatus="courseMappingDetailIndex">
				       	
						  <tr   <c:choose><c:when test="${index.index % 2 eq 0 }"> class="groupSele"</c:when><c:otherwise> class="groupSele2"</c:otherwise></c:choose> id="courseTitle_${courseMappingIndex.index }_${courseMappingDetailIndex.index}">
							    <td> ${courseMappingDetail.gcuCourse.courseCode }</td>
							    <td>${courseMappingDetail.gcuCourse.title}  </td>
							  	<td> ${courseMappingDetail.gcuCourse.gcuCourseLevel.name}</td>
							  	<td> ${courseMappingDetail.gcuCourse.credits}</td>
								<td><fmt:formatDate value='${courseMappingDetail.effectiveDate }' pattern="MM/dd/yyyy"/></td>
								<td><fmt:formatDate value='${courseMappingDetail.endDate }' pattern="MM/dd/yyyy"/></td>
								<td> <c:if test="${fn:length(courseMapping.courseMappingDetails)-1 >courseMappingDetailIndex.index }"><strong>AND</strong></c:if></td>
					    </tr>
					     </c:forEach>
				    </c:forEach>							
							</c:when>
							<c:when test="${fn:length(transferCourse.courseMappings)>0 && fn:length(transferCourse.courseCategoryMappings)>0}">
							 	<td colspan="4"><span><em>No Record Found.</em></span></td>						
							</c:when>
						</c:choose>
					</table>		
				</div>
		
				<div class="mt10">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl3 noti-bbn tabTBLborder contentForm">
							  <tr>
							    <th width="70%" scope="col" class="dividerGrey">GCU Course Category</th>
							    <th width="10%" scope="col" class="dividerGrey">Effective Date</th>
							    <th width="10%" scope="col" class="dividerGrey">End Date</th>
							  </tr>
							   <c:forEach items="${transferCourse.courseCategoryMappings}" var="courseCategoryMapping" varStatus="index">
									<tr>
									    <td>${courseCategoryMapping.gcuCourseCategory.name} </td>
									    <td><fmt:formatDate value="${courseCategoryMapping.effectiveDate}" pattern="MM/dd/yyyy"/></td>
									    <td><fmt:formatDate value="${courseCategoryMapping.endDate}" pattern="MM/dd/yyyy"/></td>
								    </tr>
							  </c:forEach>
						  
						</table>
				</div>

		</div>
          </div>
          <div class="clear"></div>
          <div class="divider3 mt10"></div>
          <div class="fr mt10">
          	<c:if test="${fn:toUpperCase(transferCourse.evaluationStatus) eq 'NOT EVALUATED' && (userRoleName ne 'Institution Evaluation Manager' && userRoleName ne 'Administrator') && ((! empty transferCourse.checkedBy && transferCourse.checkedBy eq userCurrentId) ||(! empty transferCourse.confirmedBy && transferCourse.confirmedBy eq userCurrentId) )}">
         	
          		<input type="submit" name="MarkComplete" value="Mark Complete" id="markComplete" class="button">
           </c:if>
            <c:if test="${fn:toUpperCase(userRoleName) eq 'INSTITUTION EVALUATION MANAGER' }">
          	<input type="button" name="list" onClick="javaScript:loadCorrespondingPage('<c:url value="${courseDetailLink}"/>');" value="Back To Course Details" class="button">
           </c:if>
		</div>
        <div class="clear"></div>
      </div>
                
     <%--OLDER CODE
        
    	<div class="infoContnr"><div class="infoTopArow infoarow5"></div>
    	  <div class="markBordr">
          <h3>Course Details <span class="sucssesIcon"></span></h3>
          <div class="p15"><table width="100%" border="0" cellspacing="0" cellpadding="0" class="contentForm">
    	    <tr>
    	      <td width="43%" align="left" valign="top"> <label class="noti-label w130">School Code:</label>
                    <span class="textview">${transferCourse.institution.schoolcode }</span>
                    <br  class="clear"/>
                    <label class="noti-label w130">School Title:</label>
                    <span class="textview">${transferCourse.institution.name }</span>
                    <br  class="clear"/>
                    <label class="noti-label w130">TR Course Code:</label>
                    <span class="textview">${transferCourse.trCourseCode}</span>
                    <br  class="clear"/>
                    <label class="noti-label w130">Course Title:</label>
                    <span class="textview">${transferCourse.trCourseTitle}</span>
                    <br  class="clear"/>
                    <label class="noti-label w130">Transcript Credits:</label>
                    <span class="textview">${transferCourse.transcriptCredits }</span>
                    <br  class="clear"/>
                    <label class="noti-label w130">Semester Credits:</label>
                    <span class="textview">${transferCourse.semesterCredits }</span>
                    <br  class="clear"/>
                    <label class="noti-label w130">Pass/Fail:</label>
                    <span class="textview">${transferCourse.passFail}</span>
                    <br  class="clear"/>
              </td>
    	      <td width="10%" class="tblBordr">&nbsp;</td>
    	      <td width="45%" align="left" valign="top"><label class="noti-label w130">Minimum Grade: </label>
                    <span class="textview">${transferCourse.minimumGrade }</span><br  class="clear"/>
                    <label class="noti-label w130">Course Level:</label>
                     <span class="textview1">${transferCourse.courseLevelId}</span>
                    <br  class="clear"/>
                    <label class="noti-label w130">Clock Hours:</label>
                    <span class="textview">${transferCourse.clockHours}</span><br  class="clear"/>
                    <label class="noti-label w130">Effective Date:</label>
                    <span class="textview"><fmt:formatDate value="${transferCourse.effectiveDate}" pattern="MM/dd/yyyy"/></span><br  class="clear"/>
                    <label class="noti-label w130">End Date:</label>
                    <span class="textview"><fmt:formatDate value="${transferCourse.endDate}" pattern="MM/dd/yyyy"/></span><br  class="clear"/>
                    <label class="noti-label w130">Catalog Course Description:</label>
                    <span class="textview">${transferCourse.catalogCourseDescription }</span><br  class="clear"/>
                      <label class="noti-label w130">Transfer Status:</label>
                    <span class="textview">${transferCourse.transferStatus }</span><br  class="clear"/>
</td>
  	      </tr>
  	    </table></div>
          </div>
          <div class="divider"></div>
          
          <c:choose> <c:when test="${fn:length(transferCourse.titleList)>0}">
          <div class="markBordr ">
          <h3>Titles  <span class="sucssesIcon"></span> </h3> </c:when>
          <c:otherwise>  <div class="markBordr orangBordr"> 
          <h3>Titles  <span class="alrtIcon"></span> </h3></c:otherwise></c:choose>
          <div>
          <table width="100%" cellspacing="0" cellpadding="0" border="0" class="noti-tbl">
       <tbody>
       <tr>
         		<th width="20%" class="dividerGrey" >Course Title</th>
                <th width="10%" class="dividerGrey" >Effective Date</th>
                <th width="10%" class="dividerGrey" >End Date</th>
                <th width="10%" class="dividerGrey" >Evaluation Status</th>
                <th width="10%" class="dividerGrey" >Effective</th>
         
       </tr>
     <c:choose>

        <c:when test="${fn:length(transferCourse.titleList)>0}">  
       <c:forEach items="${transferCourse.titleList}" var="courseTitle" varStatus="index">
       <tr>
         <td><span>${courseTitle.title}</span></td>
         
         <td><span><fmt:formatDate value="${courseTitle.effectiveDate}" pattern="MM/dd/yyyy"/></span></td>
         <td><span><fmt:formatDate value="${courseTitle.endDate}" pattern="MM/dd/yyyy"/></span></td>
         <td><span>${courseTitle.evaluationStatus}</span></td>
         <td><span>
       <c:choose>
     	<c:when test="${courseTitle.effective == 'true'}"> YES  </c:when>
         <c:otherwise>NO</c:otherwise>
       </c:choose>
         </span></td>
        
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
           <c:choose> <c:when test="${fn:length(transferCourse.courseMappings)>0}">
          <div class="markBordr">
          <h3>Course Relationship<span class="sucssesIcon"></span></h3>
          </c:when>
          <c:otherwise>  <div class="markBordr orangBordr">  
          <h3>Course Relationship<span class="alrtIcon"></span> </h3></c:otherwise></c:choose>
          
          <div><table width="100%" cellspacing="0" cellpadding="0" border="0" class="noti-tbl">
       <tbody>
       <tr>
          <th width="15%" class="dividerGrey" >GCU Course Code</th>
                <th width="20%" class="dividerGrey" >GCU Course Title</th>
                <th width="10%" class="dividerGrey" >Credits</th>
                <th width="10%" class="dividerGrey" >Min TR Grade</th>
                <th width="10%" class="dividerGrey" >Effective Date</th>
                <th width="10%" class="dividerGrey" >End Date</th>
                <th width="10%" class="dividerGrey" >Evaluation Status</th>
                <th width="10%" class="dividerGrey" >Effective</th>
         
       </tr>
        <c:choose>

        <c:when test="${fn:length(transferCourse.courseMappings)>0}">  
       <c:forEach items="${transferCourse.courseMappings}" var="courseMapping" varStatus="index">
       <tr>
         <td><span>${courseMapping.gcuCourse.courseCode}</span></td>
         <td><span>${courseMapping.gcuCourse.title}</span></td>
         <td><span>${courseMapping.credits}</span></td>
         <td><span>${courseMapping.minTransferGrade}</span></td>
         <td><span><fmt:formatDate value="${courseMapping.effectiveDate}" pattern="MM/dd/yyyy"/></span></td>
         <td><span><fmt:formatDate value="${courseMapping.endDate}" pattern="MM/dd/yyyy"/></span></td>
         <td><span>${courseMapping.evaluationStatus}</span></td> <td><span>
	        <c:choose>
	     	<c:when test="${courseMapping.effective == 'true'}"> YES  </c:when>
	         <c:otherwise>NO</c:otherwise>
	       </c:choose>
         </span></td>
        
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
           <c:choose> <c:when test="${fn:length(transferCourse.courseCategoryMappings)>0}">
          <div class="markBordr">
          <h3>Course Category Relationship <span class="sucssesIcon"></span></h3>
           </c:when>
          <c:otherwise>
          <div class="markBordr orangBordr">
          <h3>Course Category Relationship <span class="alrtIcon"></span></h3></c:otherwise></c:choose>
          <div><table width="100%" cellspacing="0" cellpadding="0" border="0" class="noti-tbl">
       <tbody>
       <tr>
          		<th width="30%" class="dividerGrey" >GCU Course Category</th>
                <th width="10%" class="dividerGrey" >Credits</th>
                <th width="10%" class="dividerGrey" >Min TR Grade</th>
                <th width="10%" class="dividerGrey" >Effective Date</th>
                <th width="10%" class="dividerGrey" >End Date</th>
                <th width="10%" class="dividerGrey" >Evaluation Status</th>
                <th width="10%" class="dividerGrey" >Effective</th>
         
       </tr>
       <c:choose>
		  <c:when test="${fn:length(transferCourse.courseCategoryMappings)>0}">  
			 <c:forEach items="${transferCourse.courseCategoryMappings}" var="courseCategoryMapping" varStatus="index">
		<tr>
		 <td><span>${courseCategoryMapping.gcuCourseCategory.name}</span></td>
         <td><span>${courseCategoryMapping.credits}</span></td>
         <td><span>${courseCategoryMapping.minTransferGrade}</span></td>
         <td><span><fmt:formatDate value="${courseCategoryMapping.effectiveDate}" pattern="MM/dd/yyyy"/></span></td>
         <td><span><fmt:formatDate value="${courseCategoryMapping.endDate}" pattern="MM/dd/yyyy"/></span></td>
         <td><span>${courseCategoryMapping.evaluationStatus}</span></td>
			<td><span>
			 <c:choose>
	     	<c:when test="${courseCategoryMapping.effective == 'true'}"> YES  </c:when>
	         <c:otherwise>NO</c:otherwise>
	       </c:choose></span></td>
			
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
        
          <div class="fr mt10">
          <c:if test="${role ne 'MANAGER' }">
         	
          	<input type="submit" name="MarkComplete" value="Mark Complete" id="markComplete" class="button">
           </c:if>
		</div>
        <div class="clear"></div>
        </div>
        
        
    </div>
  </div>
    
  
</div> --%>   