<%@include file="../../init.jsp" %>
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

		jQuery(document).ready( function() {

			/*
			jQuery( ".flagTranscript" ).click( function() {

				alert(jQuery(this).parent());
				var rowNum = jQuery(this).parent().parent().parent().children().index( jQuery(this).parent() );
				alert( rowNum );

				var tr = jQuery(this).closest('tr');
				alert( tr.index );
				

			});
			*/
			if(${userRole.title == 'Administrator'}){
				jQuery('#tabs').tabs({ selected: 1 });	
			}
			
			jQuery(".flagClass").click(function(){
				var currElement=jQuery(this);
				
				
				if(currElement.attr('flagAttr')=="true"){
					currElement.attr('flagAttr','false')
					currElement.text('Flag as Correct');
					
				}else{
					currElement.attr('flagAttr','true')
					currElement.text('Flag as InCorrect');
				}
				jQuery(".flagClass").each(function(){
				
					if(jQuery(this).attr('flagAttr')=='false'){
						jQuery("#btnApprove").attr('disabled','disabled');
						return false;
					}else{
						jQuery("#btnApprove").attr('disabled','');
					}
					
				})
				
			})
			
			
			
		} );
		
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

<div id="tabs">
	<ul>
        <li><a href="#tabs-1" onclick="window.location='/scheduling_system/evaluation/admin.html?operation=viewInstitutions'">View Institutions &amp; Courses</a></li>
        <li><a href="#tabs-2" onclick="window.location='/scheduling_system/evaluation/admin.html?operation=viewTranscripts'">View Transcripts</a> </li>
        <li><a href="#tabs-3" onclick="window.location='/scheduling_system/user/user.html?operation=manageUsers'">Manage Users</a></li>
    </ul>
    <div id="tabs-1"></div>
    <div id="tabs-2">
    	<c:choose>
		<c:when test="${transcriptDataAvailable ne true}">
			<br/><br/>
			<div>
				<span>No transcripts were found for this Student. Please click <a href="studentEvaluator.html?operation=initEvaluatorParams">here</a> to go back</span>
			</div>
		</c:when>
		<c:otherwise>
			<div class="deoInfo">
				<form name="leadInformationForm">
			        <h1 class="expand">Lead Information</h1>
			    	
			        <div class="deoExpandDetails collapse" style="display:block;"> 
			            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="contentForm">
			              <tr>
			                <td width="33%">
			                    <label class="noti-label w130">Lead CRM ID:</label>
			                    <input name="studentCrmId" id="homeStudentCrmId" type="text" value="${courseInfo.studentCrmId}" class="textField" readonly="readonly">
			                </td>
			                <td width="33%">
			                    <label class="noti-label w130">Catalog Code:</label>
			                    <input name="catalogCode" id="" readonly="readonly" type="text" value="${courseInfo.catalogCode}" class="textField">
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
			                    <input name="programVersionCode" id="homeProgramVersionCode" readonly="readonly" type="text" value="${courseInfo.programVersionCode}" class="textField">
			                </td>
			                <td width="33%">
			                    <label class="noti-label w130">State Code:</label>
			                    <input name="stateCode" id="homeStateCode" readonly="readonly" type="text" value="${courseInfo.stateCode}" class="textField">
			                </td>
			              </tr>
			              
			              <tr>
			                <td width="33%">
			                    <label class="noti-label w130">Program Name: </label>
			                    <input name="programDesc" id="homeProgramDesc" readonly="readonly" type="text" value="${courseInfo.programDesc}" class="textField">
			                </td>
			                <td width="33%">
			                    <label class="noti-label w130">Expected Start Date:</label>
			                    <input name="expectedStartDate" id="homeExpectedStartDate" readonly="readonly" type="text"  value='<fmt:formatDate value="${courseInfo.expectedStartDate}" pattern="MM/dd/yyyy"/>' class="textField">
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
					<h1 class="expand">Institution Details</h1>
					<div class="deoExpandDetails collapse" style="display: block;">
						<c:if test="${userRole.title != 'Administrator'}">
							<div class="fr"><span><a id="instDetailsFlag" class="flagClass" flagAttr="true" href="#">Flag as Incorrect</a></span></div>
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
					                    <label class="noti-label w130">Name:</label>
					                    <label class="noti-label w130">${studentInstitutionTranscript.institution.name}</label>
					                    
					                </td>
					                <td width="50%">
					                    <label class="noti-label w130">Institution Type:</label>
					                    <label class="noti-label w130"></label>
					                    
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
			  <h1 class="expand">Institution Degree Details</h1> 
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
				  	<div class="noti-tools1">
				        <div class="fr institutionHeader">
				        	<c:choose>
								<c:when test="${userRole.title != 'Administrator' }">     	
							     	<a href="studentEvaluator.html?operation=launchEvaluationHome&programVersionCode=${studentProgramEvaluation.programVersionCode}&studentCrmId=${studentProgramEvaluation.studentId}"><img width="15" height="14" alt="back" src="../images/back_icon.jpg">Back to Transcript List</a>
							    </c:when>
							    <c:otherwise>
							    	<a href="admin.html?operation=viewTranscripts"><img width="15" height="14" alt="back" src="../images/back_icon.jpg">Back to Transcript List</a>
							    </c:otherwise>	
							</c:choose>
				        </div><br class="clear">

				    </div>
					<form name="transferCourseForm" id="transferCourseForm" method="post" action="launchEvaluation.html?operation=markTranscriptComplete">
				    <table name="transferCourseTbl" id="transferCourseTbl" width="100%" cellspacing="0" cellpadding="0" border="0" class="noti-tbl3 noti-bbn contentForm">
				      <tr>
				        <th width="15%" scope="col" class="dividerGrey"><span>Completion Date (MM/dd/yyyy)</span></th>
				        <th width="10%" scope="col" class="dividerGrey"><span>TR Course ID</span></th>
				        <th width="25%" scope="col" class="dividerGrey"><span>TR Course Title</span></th>
				        <th width="8%" scope="col" class="dividerGrey"><span>Grade</span></th>
				        <th width="8%" scope="col" class="dividerGrey"><span>Credits</span></th>
				        <th width="6%" scope="col" class="dividerGrey"><span>Equivalent <br />Semester Credits</span></th>
				        
				        <th width="14%" scope="col" class="dividerGrey">Course Evaluation<br />Status</th>
				        <c:if test="${userRole.title != 'Administrator'}">
				            <th width="6%" scope="col" class="dividerGrey"><strong>Flag</strong></th>
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
								    	<label><strong><c:out value="${studentTranscriptCourse.transferCourse.evaluationStatus == true ? 'Evaluated' : 'Not Evaluated' }" /></strong></label>
								    </td>
								    <td>
								    	<c:if test="${userRole.title != 'Administrator'}">
							          		 <a href="#" class="flagClass" flagAttr="true" id="courseflag_${loop.index}">Flag as Incorrect</a> 						            
						            	</c:if>
						            </td>
							    </tr>
							</c:forEach>
						</c:otherwise>
					  </c:choose>
					</table>	        	
				    		<input type="hidden" name="coursesAdded" value="" />
						    <input type="hidden" name="expectedStartDateString" id="expectedStartDateString" value="<fmt:formatDate value='${courseInfo.expectedStartDate}' pattern='MM/dd/yyyy' />" />
						   	<input type="hidden" name="studentCrmId" id="studentCrmId" value="${courseInfo.studentCrmId}" />
						   	<input name="programVersionCode" id="programVersionCode" type="hidden" value="${courseInfo.programVersionCode}" />
						   	<input name="programDesc" type="hidden" value="${courseInfo.programDesc}" />
						   	<input name="catalogCode" type="hidden" value="${courseInfo.catalogCode}" />
						   	<input name="stateCode" type="hidden" value="${courseInfo.stateCode}" />
						   	<input type="hidden" name="studentId" id="studentId" value="${courseInfo.studentCrmId}" />
						   	<input type="hidden" name="evaluationStatus" id="evaluationStatus" value="Unofficial" />
						   	<input type="hidden" name="studentProgramEvaluationId" id="studentProgramEvaluationId" value="${studentProgramEvaluation.id}" />
						   	<input type="hidden" name="studentInstitutionTranscriptId" id="studentInstitutionTranscriptId" value="${studentInstitutionTranscript.id}" /> 	
						   	<input type="hidden" name="isSaveDraftInProgress" id="isSaveDraftInProgress" value="0" />
						   	
						   	<br/>
							<c:if test="${userRole.title != 'Administrator' }">
								<div style="float:right;margin-right:25px;">
									<input type="submit" value="Approve" name="" id="btnApprove" class="button"   />
									<input type="submit" value="Send Back to Data Entry" name="" id="btnSendBack" class="button"   />
								</div>
							</c:if> 
					</form>    
				    <br class="clear" />
				    
				    <div>&nbsp;</div>
    		</div>
			   
		    </c:if>
    
			
	    
    		</c:otherwise>
    	</c:choose>
    </div>
    <div id="tabs-3"></div>
</div>
	
		


    
    
    
    

	