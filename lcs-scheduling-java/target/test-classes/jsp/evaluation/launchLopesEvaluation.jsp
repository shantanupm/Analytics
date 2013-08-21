<%@include file="../init.jsp" %>
<head>
 <!-- <link rel="stylesheet" href="<c:url value="/css/jquery.ui.all.css"/>" /> -->         
	<script type="text/javascript" src="<c:url value="/js/jquery.js"/>"></script>     
     <script type='text/javascript' src="<c:url value="/js/jquery.ui.core.js"/>"></script>
     <script type='text/javascript' src="<c:url value="/js/jquery.ui.widget.js"/>"></script>
     <script type='text/javascript' src="<c:url value="/js/jquery.ui.position.js"/>"></script>
     <script type='text/javascript' src="<c:url value="/js/jquery.ui.autocomplete.js"/>"></script>   
     <script type='text/javascript' src="<c:url value="/js/jquery-ui-1.8.23.custom.min.js"/>"></script>
	<script type='text/javascript' src="<c:url value="/js/expand.js"/>"></script>
</head>
<title>Evaluate Courses</title>
	
<script>
		var comment = "";
		jQuery(document).ready( function() {
			
			jQuery(".flagClass").click(function(){
				var currElement=jQuery(this);
				var noFlag = true;
				
				if(currElement.attr('flagAttr')=="true"){
					currElement.attr('flagAttr','false')
					currElement.text('Flag as Correct');
					jQuery("#btnSendBack").attr('disabled','');
					jQuery("#btnApprove").attr('disabled','disabled');
					
				}else{
					currElement.attr('flagAttr','true')
					currElement.text('Flag as InCorrect');
					
					jQuery(".flagClass").each(function(){
						if(jQuery(this).attr('flagAttr')=='false'){
							noFlag = false;
						}
						
					})
					if(noFlag){
						jQuery("#btnSendBack").attr('disabled','disabled');
						jQuery("#btnApprove").attr('disabled','');
						
					}
				}
				
			})
			
	/*		jQuery("#MakeOfficialBtn").click(function(){
				var currElement=jQuery(this);
				
				
				if(currElement.attr('offAttr')=="true"){
					currElement.attr('offAttr','false')
					currElement.val('Make Official');
					jQuery("#offLabel").text("Un-official ");
					if(jQuery("#btnApprove").attr('disabled')==false){
						jQuery("#btnApprove").attr('disabled','disabled');
					}
					
				}else{
					currElement.attr('offAttr','true')
					currElement.val('Make Un-official');
					jQuery("#offLabel").text("Official ");
					if(jQuery("#btnSendBack").attr('disabled')==true){
						jQuery("#btnApprove").attr('disabled','');
					}
				}

				
				
			})*/
					
		} );
		
		function approve(){
			var url = "<c:url value='/evaluation/launchEvaluation.html?operation=approveSITForLOPE&studentInstitutionTranscriptId=${studentInstitutionTranscript.id}'/>";
			window.location.href=url;
		}
		
		function sendBack(){
			var url;
			var errorInInstitution = false;
			var errorCourseIds = "";
			
			if(jQuery("#instDetailsFlag").attr('flagAttr')=='false'){
				errorInInstitution = true;
			}
			jQuery(".flagCourse").each(function(){
			
				if(jQuery(this).attr('flagAttr')=='false'){
					errorCourseIds = errorCourseIds + jQuery(this).attr('stcId') + ',';
				}
				
			} );
			url = "<c:url value='/evaluation/launchEvaluation.html?operation=disapproveSITForLOPE&studentInstitutionTranscriptId=${studentInstitutionTranscript.id}&errorCourseIds="+errorCourseIds+"&errorInInstitution="+errorInInstitution+"&comment="+comment+"'/>";
			window.location.href=url;
		}
		
		function comment_prompt(){
			comment=prompt("Please comment on the errors","");
			if(comment==""){
				alert("comment cannot be left empty");
				comment_prompt();
			}
			if(comment!=null){
				sendBack();	
			}
			
		}
				
</script>
<script type="text/javascript">
jQuery(function() {
    jQuery("h1.expand").toggler(); 
    jQuery("#divContBoxLft").expandAll({trigger: "h1.expand"});
	jQuery("#divContBoxRgt").expandAll({trigger: "h1.expand"});
	
	 jQuery('.collapse:first').show();
	 jQuery('h1.expand:first a:first').addClass("open"); 
});
</script>


	<c:choose>
		<c:when test="${transcriptDataAvailable ne true}">
			<br/><br/>
			<div>
				<span>No transcripts were found for evaluation.</span>
			</div>
		</c:when>
		<c:otherwise>
		
			<div class="deoInfo">
				<form name="leadInformationForm">
					<h1 class="expand">FirstName LastName</h1>
						<div class="deoExpandDetails collapse" style="display:block;"> 
			            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="contentForm">
			              <tr>
			                <td width="33%">
			                    <label class="noti-label w130">Lead CRM ID:</label>
			                    <label class="noti-label w130">${courseInfo.studentCrmId}</label>
			                </td>
			                <td width="33%">
			                    <label class="noti-label w130">Catalog Code:</label>
			                    <label class="noti-label w130">${courseInfo.catalogCode}</label>
			                </td>
			                <td width="5%" rowspan="3" valign="top" class="brdLeft">&nbsp;</td>
			                <td width="27%" rowspan="3" valign="top">
			                    <label class="noti-label w130">Evaluator Name:</label>
			                    <input type="text" value="-  -" class="textField" readonly="readonly">
			                </td>
			              </tr>
			              
			              <tr>
			                <td width="33%">
			                    <label class="noti-label w130">Program Version Code:</label>
			                    <label class="noti-label w130">${courseInfo.programVersionCode}</label>
			                </td>
			                <td width="33%">
			                    <label class="noti-label w130">State Code:</label>
			                    <label class="noti-label w130">${courseInfo.stateCode}</label>
			                </td>
			              </tr>
			              
			              <tr>
			                <td width="33%">
			                    <label class="noti-label w130">Program Name:</label>
			                    <label class="noti-label w130">${courseInfo.programDesc}</label>
			                </td>
			                <td width="33%">
			                    <label class="noti-label w130">Expected Start Date:</label>
			                    <label class="noti-label w130"><fmt:formatDate value="${courseInfo.expectedStartDate}" pattern="MM/dd/yyyy"/></label>
			                </td>
			              </tr>
			            </table>
			        </div>
				</form>
			</div>
    
    
    <c:if test="${displayTranscriptListing == true}">
    	<div class="divCover" style="height:100%;">
	    	<table id="" name="" class="tableS1" width="100%" border="1" cellspacing="0" style="border-collapse:collapse;" cellpadding="0">
	    		<tr>
		    		<th width="5%" style="text-align:center;"><strong>Sr No</strong></th>
		    		<th><strong>Institution</strong></th>
		    		<th width="15%"><strong>Degree(s)</strong></th>
		    		<th width="15%"><strong>Last Date of Last Course</strong></th>
		    		<th width="15%"><strong>Data Entry Date</strong></th>
		    		<th width="15%"><strong>Transcript Status</strong></th>
	    		</tr>
	    	
		    	<c:forEach items="${transcriptList}" var="transcript" varStatus="loop">
		    		<tr>
		    			<td style="text-align:center; vertical-align:top; padding-top:6px;"><strong>${loop.count}</strong></td>
		    			<td style="vertical-align:top; padding-top:6px;"><strong><a href="studentEvaluator.html?operation=getCoursesForStudentTranscript&studentInstitutionTranscriptId=${transcript.id}&institutionId=${transcript.institution.id}" id="${transcript.id}">${transcript.institution.name}</a></strong></td>
		    			
		    			<td>
		    				<div>
		    					<table width="100%" cellspacing="0" cellpadding="0" style="margin-left:-15px;">
				    			<c:forEach items="${transcript.studentInstitutionDegreeSet}" var="sidset">
				    				<tr>
				    					<td style="border:none;"><strong>${sidset.institutionDegree.degree}</strong></td>
				    				</tr>
				    			</c:forEach>
				    			</table>
			    			</div>
		    			</td>
		    			<td style="vertical-align:top; padding-top:6px;"><strong><fmt:formatDate value="${transcript.lastDateForLastCourse}" pattern="MM/dd/yyyy"/></strong></td>
		    			<td style="vertical-align:top; padding-top:6px;"><strong><fmt:formatDate value="${transcript.modifiedTime}" pattern="MM/dd/yyyy"/></strong></td>
		    			<td style="vertical-align:top; padding-top:6px;"><strong><c:out value="${transcript.evaluationStatus}"/></strong></td>
		    			
		    			<input type="hidden" name="transcriptId_${loop.index}" id="transcriptId_${loop.index}" value="${transcript.id}" />
		    		</tr>
		    	</c:forEach>
	    	</table>
	    </div>
    </c:if>
    
    <!-- Transcript Courses block -->
     <c:if test="${displayTransferCoursesBlock == true}">
     	<div class="deoInfo">
    		<h1 class="expand">Transfer Institute
				<div class="collapse1" style="display: block;">
			    	 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="contentForm">
			    	 	<tr>
			                <td width="70%">
								<label class="noti-label">Institution Name:</label>
								<label class="noti-label w210">${studentInstitutionTranscript.institution.name}</label>
							</td>
							<td width="30%">
								<label class="noti-label">Institution ID:&nbsp; </label>
								<label class="noti-label w130">${studentInstitutionTranscript.institution.institutionID}</label>
							</td>
			             </tr>
					 </table>
			   </div>
			</h1>
    		<div class="deoExpandDetails collapse" style="display: block;">
    			<c:if test="${userRole.title != 'Administrator'}">
					<div class="fr"><span><a id="instDetailsFlag" class="flagClass" flagAttr="true" href="javaScript:void(0);">Flag as Incorrect</a></span></div><br class="clear"/>
				</c:if>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="contentForm">
					<tr>
		                <td width="50%">
		                    <label class="noti-label w130">School Code:</label>
		                    <label class="noti-label w130">${studentInstitutionTranscript.institution.schoolcode}</label>
		                    
		                </td>
		                <td width="50%">
		                    <label class="noti-label w130">Location Type:</label>
		                    <label class="noti-label w130">${studentInstitutionTranscript.institution.locationId}</label>
		                    
		                </td>
		            </tr>
		            <tr>
		                <td width="50%">
		                    <label class="noti-label w130">Institution Address:</label>
		                    <label class="noti-label w130">${studentInstitutionTranscript.institution.address1}, ${studentInstitutionTranscript.institution.address2}</label>
		                    
		                </td>
		                <td width="50%">
		                    <label class="noti-label w130">Accrediting Body:</label>
		                    <label class="noti-label w130"></label>
		                    
		                </td>
		            </tr>
		            <tr>
		                <td width="50%">
		                    <label class="noti-label w130">City:</label>
		                    <label class="noti-label w130">${studentInstitutionTranscript.institution.city}</label>
		                    
		                </td>
		                <td width="50%">
		                    <label class="noti-label w130">Term Type:</label>
		                    <label class="noti-label w130">${institutionTermType.termType.name}</label>
		                    
		                </td>
		            </tr>
		            <tr>
		                <td width="50%">
		                    <label class="noti-label w130">State:</label>
		                    <label class="noti-label w130">${studentInstitutionTranscript.institution.state}</label>
		                    
		                </td>
		                <td width="50%">
		                    <label class="noti-label w130">Parent Institute:</label>
		                    <label class="noti-label w130">${studentInstitutionTranscript.institution.parentInstitutionId}</label>
		                    
		                </td>
		            </tr>
		            <tr>
		                <td width="50%">
		                    <label class="noti-label w130">Zip Code:</label>
		                    <label class="noti-label w130">${studentInstitutionTranscript.institution.zipcode}</label>
		                    
		                </td>
		                <td width="50%">
		                    
		                    
		                </td>
		            </tr>
		            <tr>
		                <td width="50%">
		                    <label class="noti-label w130">Phone:</label>
		                    <label class="noti-label w130">${studentInstitutionTranscript.institution.phone}</label>
		                    
		                </td>
		                <td width="50%">
		                   
		                    
		                </td>
		            </tr>
		            <tr>
		                <td width="50%">
		                    <label class="noti-label w130">Fax:</label>
		                    <label class="noti-label w130">${studentInstitutionTranscript.institution.fax}</label>
		                    
		                </td>
		                <td width="50%">
		                  
		                    
		                </td>
		            </tr>
					<tr>
		                <td width="50%">
		                    <label class="noti-label w130">Country:</label>
		                    <label class="noti-label w130">${studentInstitutionTranscript.institution.country.name}</label>
		                    
		                </td>
		                <td width="50%">
		                   
		                    
		            	</td>
		            </tr>
		            <tr>
		                <td width="50%">
		                    <label class="noti-label w130">Website:</label>
		                    <label class="noti-label w130">${studentInstitutionTranscript.institution.website}</label>
		                    
		                </td>
		                <td width="50%">
		                   
		                    
						</td>
		        	</tr>
		        </table>
			</div>
		</div>
		<div class="deoInfo">
			<h1 class="expand">Transfer Receipt History</h1> 
			<div class="collapse" style="display: block;">
			 	 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="contentForm noti-tbl6">
			           <tr>
			              <th class="dividerGrey" width="25%"><strong>Institution Degree</strong></td>
			              <th class="dividerGrey" width="25%"><strong>Degree Major</strong></td>
			              <th class="dividerGrey" width="25%"><strong>Degree Date</strong></td>
			              <th class="dividerGrey" width="25%"><strong>GPA</strong></td>
			          </tr>	                
			          <c:forEach items="${studentInstitutionDegreeList}" var="sInstDegList" varStatus="index">
			           <tr>
			            <td><span>${sInstDegList.institutionDegree.degree}</span></td>
			            <td><span>${sInstDegList.major}</span></td>
			            <td class="dgCompletionDate"><span><fmt:formatDate value='${sInstDegList.completionDate}' pattern='MM/dd/yyyy'/></span></td>
			            <td><span>${sInstDegList.gpa}</span></td>
			           </tr>
			          </c:forEach>
			       </table> 
			     <br class="clear"/> 
			</div>
		</div>
					            
    	
	    
	    <!-- Transfer Course Data -->
	    <div style="border:1px solid #e7e7e7; background:#FFFFFF;" class="transcript">
	    	<table name="transferCourseTbl" id="transferCourseTbl" width="100%" cellspacing="0" cellpadding="0" border="0" class="noti-tbl3 noti-bbn contentForm">
				<tr>
			        <th width="10%" scope="col" class="dividerGrey"><span>Completion Date <br/>(MM/dd/yyyy)</span></th>
			        <th width="10%" scope="col" class="dividerGrey"><span>TR Course ID</span></th>
			        <th width="25%" scope="col" class="dividerGrey"><span>TR Course Title</span></th>
			        <th width="8%" scope="col" class="dividerGrey"><span>Grade</span></th>
			        <th width="8%" scope="col" class="dividerGrey"><span>Credits</span></th>
			        <th width="8%" scope="col" class="dividerGrey"><span>Equivalent <br />Semester Credits</span></th>
			        <th width="14%" scope="col" class="dividerGrey">Course Evaluation<br />Status</th>
			        <c:if test="${userRole.title != 'Administrator'}">
			            <th width="11%" scope="col" class="dividerGrey"><strong>Flag</strong></th>
			        </c:if>
				</tr>     
		        <c:choose>
		        	<c:when test="${empty studentTranscriptCourseList}">
			        	<tr>
				            <td colspan=8>
				            	<label>There are no courses added to this transcript.</label>
				            </td>
			        	</tr>	
		        	</c:when>
		        	<c:otherwise>
		        		<c:forEach items="${studentTranscriptCourseList}" var="studentTranscriptCourse" varStatus="loop">
		        		
		        		<tr>
		        			<td>
				            	<label><strong><fmt:formatDate value='${studentTranscriptCourse.completionDate}' pattern='MM/dd/yyyy'/></strong></label>
				            </td>
				            <td>
				            	<label><strong><c:out value="${studentTranscriptCourse.trCourseId}" /></strong></label>
				            </td>
				            <td>
				            	<label><strong><c:out value="${studentTranscriptCourse.courseTitle}" /></strong></label>
				            </td>
				            <td>
				            	<label><strong><c:out value="${studentTranscriptCourse.grade}" /></strong></label>
				            </td>
				            <td>
				            	<label><strong><c:out value="${studentTranscriptCourse.creditsTransferred}" /></strong></label>
				            </td>
				            <td>
				            	<c:choose>
				            		<c:when test="${fn:toUpperCase(studentInstitutionTranscript.institution.evaluationStatus) == 'EVALUATED'}">
				            			<c:choose>
				            				<c:when test="${institutionTermType.termType.name == 'Quarter'}">
				            					<label><strong><c:out value="${studentTranscriptCourse.creditsTransferred*2/3}" /></strong></label> 
				            				</c:when>
				            				<c:when test="${institutionTermType.termType.name == '4-1-4'}">
				            					<label><strong><c:out value="${studentTranscriptCourse.creditsTransferred*4}" /></strong></label>
				            				</c:when>
				            				<c:otherwise>
				            					<label><strong><c:out value="${studentTranscriptCourse.creditsTransferred}" /></strong></label>
				            				</c:otherwise>
				            			</c:choose>
				            		</c:when>
				            		<c:otherwise>
				            			<label><strong><c:out value="---" /></strong></label>
				            		</c:otherwise> 
				            	</c:choose>	
						    </td>
				          
				            		            
				            <td>
				            	<label><strong><c:out value="${studentTranscriptCourse.transferCourse.evaluationStatus == 'EVALUATED' ? 'Evaluated' : 'Not Evaluated' }" /></strong></label>
				            </td>
				            
				            <td>
					           <a href="javaScript:void(0);" class="flagClass flagCourse" flagAttr="true" id="courseflag_${loop.index}" stcId="${studentTranscriptCourse.id}">Flag as Incorrect</a> 
				            </td>
	            		    
			        	</tr>
			        	</c:forEach>
		        	</c:otherwise>
		        </c:choose>
		        
		    </table>
		  </div>
		  
		    <input type="hidden" name="coursesAdded" value="" />
		    <input type="hidden" name="expectedStartDateString" id="expectedStartDateString" value="<fmt:formatDate value='${courseInfo.expectedStartDate}' pattern='MM/dd/yyyy' />" />
		   	<input type="hidden" name="studentCrmId" id="studentCrmId" value="${courseInfo.studentCrmId}" />
		   	<input name="programVersionCode" type="hidden" value="${courseInfo.programVersionCode}" />
		   	<input name="programDesc" type="hidden" value="${courseInfo.programDesc}" />
		   	<input name="catalogCode" type="hidden" value="${courseInfo.catalogCode}" />
		   	<input name="stateCode" type="hidden" value="${courseInfo.stateCode}" />
		   	<input type="hidden" name="studentId" id="studentId" value="${courseInfo.studentCrmId}" />
		   	<input type="hidden" name="evaluationStatus" id="evaluationStatus" value="Unofficial" />
		   	<input type="hidden" name="studentProgramEvaluationId" id="studentProgramEvaluationId" value="${studentProgramEvaluation.id}" />
		   	<input type="hidden" name="studentInstitutionTranscriptId" id="studentInstitutionTranscriptId" value="${studentInstitutionTranscript.id}" />
		   	
		   	<input type="hidden" name="isSaveDraftInProgress" id="isSaveDraftInProgress" value="0" />
		   	
		   	<br/>		   	
		   

    </c:if>
    <div style="float:right;margin-right:25px;">
		<input type="submit" value="Approve" name="" id="btnApprove" class="button"  onclick="javascript:approve()"/>
		<input type="submit" value="Send Back to Data Entry" name="" id="btnSendBack" class="button" disabled="disabled" onclick="javascript:comment_prompt()"/>
	</div>
  	</c:otherwise>
</c:choose>
	