<%@include file="../../init.jsp" %>

<link rel="stylesheet" media="screen" href="<c:url value="/css/jquery.ui.autocomplete.css"/>" />
<script type="text/javascript" src="<c:url value="/js/jquery.js"/>"></script>

<script type='text/javascript' src="<c:url value="/js/jquery.ui.core.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.widget.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.position.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.autocomplete.js"/>"></script> 

<script type='text/javascript' src="<c:url value="/js/jquery-ui-1.8.23.custom.min.js"/>"></script>

<script type="text/javascript">
	jQuery(document).ready(function(){

	
		jQuery('#tabs').tabs({ selected: 0 });
	});

</script>


        	
        	<c:set var="aBodyLink" scope="session" value="/scheduling_system/evaluation/admin.html?operation=manageAccreditingBody&institutionId=${institutionId}"/>
 			<c:set var="termTypeLink" scope="session" value="/scheduling_system/evaluation/admin.html?operation=manageInstitutionTermType&institutionId=${institutionId}"/>
 			<c:set var="transcriptKeyLink" scope="session" value="/scheduling_system/evaluation/admin.html?operation=manageInstitutionTranscriptKey&institutionId=${institutionId}"/>
 			<c:set var="aAgreementLink" scope="session" value="/scheduling_system/evaluation/admin.html?operation=manageArticulationAgreement&institutionId=${institutionId}"/>

<div id="tabs">
	<ul>
        <li><a href="#tabs-1" onclick="window.location='/scheduling_system/evaluation/admin.html?operation=viewInstitutions'">View Institutions &amp; Courses</a></li>
        <li><a href="#tabs-2" onclick="window.location='/scheduling_system/evaluation/admin.html?operation=viewTranscripts'">View Transcripts</a> </li>
        <li><a href="#tabs-3" onclick="window.location='/scheduling_system/user/user.html?operation=manageUsers'">Manage Users</a></li>
    </ul>
	<div id="tabs-1">
		<div class="stateCollege" >
			<div class="noti-tools">
				<div class="fl">
					<div class="breadcrumb"> <a title="Home" href="admin.html?operation=viewInstitutions&status=ALL"> Manage Institutions</a>  ${institutionName} >
	                    <c:choose>
		                	<c:when test="${tabIndex=='1'}">
		                		Evaluate Institution
		                	</c:when>
		                	<c:when test="${tabIndex=='2'}">
		                		Accrediting Body
		                	</c:when>
		                	<c:when test="${tabIndex=='3'}">
		                		Term Type
		                	</c:when>
		                	<c:when test="${tabIndex=='4'}">
		                		Transcript Key
		                	</c:when>
		                	<c:when test="${tabIndex=='5'}">
		                		Articulation Agreement
		                	</c:when>
		                	<c:when test="${tabIndex=='6' }">
		                		 Courses 
		                		 
		                	</c:when>
		                	<c:when test="${ tabIndex=='7'}">
								<c:if test="${not empty transferCourseName}">
		                		<a  href="admin.html?operation=viewCourses&institutionId=${institutionId}"> Courses </a> ${transferCourseName}
								</c:if>
		                	</c:when>
		                	<c:when test="${tabIndex=='8'}">
		                		<a  href="admin.html?operation=viewCourses&institutionId=${institutionId}">Courses</a> ${transferCourseName}> Course Relationship 
		                	</c:when>
		                	<c:when test="${tabIndex=='9'}">
		                		<a  href="admin.html?operation=viewCourses&institutionId=${institutionId}">Courses</a> ${transferCourseName}> Course Category Relationship
		                	</c:when>
		                	<c:when test="${tabIndex=='10'}">
		                		<a  href="admin.html?operation=viewCourses&institutionId=${institutionId}">Courses</a> ${transferCourseName}> Course Titles
		                	</c:when>
		                	
		                </c:choose>
					</div>
					<br class="clear">
				</div>
				
				<br class="clear">
			</div>
			<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" class="mt10 mb10">
				<tr>
	                <td width="225" align="left" valign="top">
						<div class="leftCtrl">
	                    	<div class="leftNav">
	                        	<h1 onclick='window.location="admin.html?operation=viewInstitutionDetails&institutionId=${institutionId}"' <c:choose>
								<c:when test="${tabIndex=='1'}" >class="selected" >
	                        	 Evaluate Institution
								 </c:when>
								 <c:otherwise>
								 ><a href="#">Evaluate Institution</a>
								 </c:otherwise>
								 </c:choose> 
	                        	 </h1>
	                        	  <c:if test="${!empty institutionId}">
	                            <ul>
	                            	<li <c:if test="${tabIndex=='2'}">class="selected"</c:if> ><span></span><a href="${aBodyLink}" >Accrediting Body</a></li>
	                                <li <c:if test="${tabIndex=='3'}">class="selected"</c:if> ><span></span><a href="${termTypeLink}" >Term Types</a></li>
	                                <li <c:if test="${tabIndex=='4'}">class="selected"</c:if> ><span></span><a href="${transcriptKeyLink}" >Transcript Key</a></li>
	                                <li <c:if test="${tabIndex=='5'}">class="selected"</c:if> ><span></span><a href="${aAgreementLink}" >Articulation Agreement</a></li>
	                            </ul>
	                            
	                            <h1 <c:choose>
	                            <c:when test="${tabIndex=='6'||tabIndex=='7'}">
	                            class="selected">View Courses</c:when> 
	                            <c:otherwise> ><a href="admin.html?operation=viewCourses&institutionId=${institutionId}">View Courses</a></c:otherwise>
	                            </c:choose>
	                            </h1>
	                             </c:if>
	                            <c:if test="${!empty transferCourseId}">
	                            <ul>
	                            	<li <c:if test="${tabIndex=='10'}">class="selected"</c:if> ><a href="/scheduling_system/evaluation/admin.html?operation=manageCourseTitles&transferCourseId=${transferCourseId}&institutionId=${institutionId}"  >Titles</a></li>
	                                <li <c:if test="${tabIndex=='8'}">class="selected"</c:if> ><a href="/scheduling_system/evaluation/admin.html?operation=manageCourseRelationship&transferCourseId=${transferCourseId}&institutionId=${institutionId}" >Course Relationship</a></li>
	                                <li <c:if test="${tabIndex=='9'}">class="selected"</c:if> ><a href="/scheduling_system/evaluation/admin.html?operation=manageCourseCtgRelationship&transferCourseId=${transferCourseId}&institutionId=${institutionId}" >Course Category Relationship</a></li>
	                                
	                            </ul>
	                            </c:if>
	                            
	                        </div>
						</div>
	                </td>
	                <td align="left" valign="top">
	                	<div class="rightCtrl">
	                	<!-- Include Jsp -->
	                	<c:choose>
		                	<c:when test="${tabIndex=='1'}">
		                		<%@include file="../../ieEvaluation/institutionEvaluate.jsp" %>
		                	</c:when>
		                	<c:when test="${tabIndex=='2'}">
		                		<%@include file="../../ieEvaluation/ieManageAccreditingBody.jsp" %>
		                	</c:when>
		                	<c:when test="${tabIndex=='3'}">
		                		<%@include file="../../ieEvaluation/ieManageInstitutionTermType.jsp" %>
		                	</c:when>
		                	<c:when test="${tabIndex=='4'}">
		                		<%@include file="../../ieEvaluation/ieManageInstitutionTranscriptKey.jsp" %>
		                	</c:when>
		                	<c:when test="${tabIndex=='5'}">
		                		<%@include file="../../ieEvaluation/ieManageArticulationAgreement.jsp" %>
		                	</c:when>
		                	<c:when test="${tabIndex=='6'}">
		                		<%@include file="viewCourses.jsp" %>
		                	</c:when>
		                	<c:when test="${tabIndex=='7'}">
		                		<%@include file="viewCourseDetails.jsp" %>
		                	</c:when>
		                	<c:when test="${tabIndex=='8'}">
		                		<%@include file="../../ieEvaluation/ieManageCourseRelationship.jsp" %>
		                	</c:when>
		                	<c:when test="${tabIndex=='9'}">
		                		<%@include file="../../ieEvaluation/ieManageCourseCtgRelationship.jsp" %>
		                	</c:when>
		                	<c:when test="${tabIndex=='10'}">
		                		<%@include file="../../ieEvaluation/ieManageCourseTitles.jsp" %>
		                	</c:when>
		                	
	                	</c:choose>
	                	
	                	
	                  	</div>
	                  	
	                </td>
              </tr>
            </table>
		</div>
	</div>
	<div id="tabs-2"></div>
	 <div id="tabs-3"></div> 
</div>
<!-- 
<center>
    <div class="tblFormDiv divCover" style="width:720px; padding-left:10px;">
   
   
   <form  id="frmInstitution" method="post"  action="${actionLink}">
        <table class="tableForm" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <th class="heading" colspan="2"><strong>Evaluate Institution</strong></th>
            </tr>
            <tr>
                <td width="35%">School Code</td>
                <td width="65%"><input id="schoolcode" name="schoolcode" disabled="disabled" <c:if test="${not empty institution.id}"> readonly='readonly' </c:if>
 value="${institution.schoolcode}" type="text" class="textField small required" /><br class="clear" />
				<div id="schoolcodeErrorDisplay" ></div>
				</td>
            </tr>
            <tr>
                <td>Location Type</td>
                <td>
                    ${institution.locationId}
                </td>
            </tr>
            <tr>
                <td>Institution Name</td>
                <td><input name="name" id="schoolTitle" type="text" disabled="disabled" value="${institution.name}" class="textField big required"  /><br class="clear" />
				<div id="schoolTitleErrorDisplay" ></div></td>
            </tr>
            <tr>
                <td>Institution Address</td>
                <td><input name="address1" type="text" disabled="disabled" value="${institution.address1}" class="textField big" /><br class="clear" /></td>
            </tr>
            <tr>
                <td>Institution Address</td>
                <td><input name="address2" type="text" disabled="disabled" value="${institution.address2}" class="textField big"  /><br class="clear" /></td>
            </tr>
            <tr>
                <td>City</td>
                <td><input name="city" type="text" disabled="disabled" value="${institution.city}" class="textField small" /></td>
            </tr>
			 <tr>
                <td>Country</td>
                <td>
                    ${institution.country.id}
                    <br class="clear" />
                </td>
           
            </tr>
            <tr>
                <td>State</td>
                <td><input name="state" id="state" type="text" disabled="disabled" value="${institution.state}" class="textField small" /></td>
            </tr>
            <tr>
                <td>Zip Code</td>
                <td><input name="zipcode" id="zipcode" type="text" disabled="disabled"  value="${institution.zipcode}" class="textField small" /></td>
            </tr>
            <tr>
                <td>Phone</td>
                <td><input name="phone" id="phone"  type="text"  disabled="disabled" value="${institution.phone}" class="textField small " /></td>
            </tr>
            <tr>
                <td>Fax</td>
                <td><input name="fax" id="fax" type="text" disabled="disabled" value="${institution.fax}" class="textField small " /></td>
            </tr>
           
            <tr>
                <td>Website</td>
                <td><input name="website" type="text" disabled="disabled"  value="${institution.website}" class="textField big"  /><br class="clear" /></td>
            </tr>
            <tr>
                <td>Institution Type</td>
                <td>
                    ${institution.institutionType.id} <br class="clear" />
                </td>
            </tr>
           
            
            <tr>
                <td>Parent Institute</td>
                <td>
				<input type="text" readonly="readonly" disabled="disabled" id="parentInstituteId" value="" />
				</td>
            </tr>
           
            <tr>
            
            <td></td><td></td></tr>
        </table>
        <table class="" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <td width="35%"> </td>
                <td width="65%" align="right" style="padding-top:10px;padding-right:10px;">
                
                	<input name="id" id="institutionId" type="hidden" value="${institution.id}"   />
                	<input name="institutionMirrorId" id="institutionMirrorId" type="hidden" value="${institutionMirrorId}"   />
                	<input name="createdDateTime" id="createdDateTime" type="hidden"  value='<fmt:formatDate value="${institution.createdDateTime}" pattern="MM/dd/yyyy"/>'   />
                	<input name="createdBy" id="createdBy" type="hidden" value="${institution.createdBy}"   />
                	<input name="checkedDate" id="checkedDate" type="hidden"  value='<fmt:formatDate value="${institution.checkedDate}" pattern="MM/dd/yyyy"/>'   />
                	<input name="checkedBy" id="checkedBy" type="hidden" value="${institution.checkedBy}"   />
                	<input name="modifiedBy" id="modifiedBy" type="hidden" value="${institution.modifiedBy}"   />
                	<input name="evaluationStatus"  type="hidden" value="${institution.evaluationStatus}"   />
                
               		
                    	<input type="button" value="Back To Institution List" onclick='window.location = "/scheduling_system/evaluation/admin.html?operation=viewInstitutions"' class="button" />
                    
                    
					
                </td>
            </tr>
        </table>
        <br/>
    </form>
    
    <table class="" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <td align="center">
                    <input type="button" value="Accrediting Body" name="P Institution" class="button" <c:if test="${empty institution.id}">disabled='disabled'</c:if> onclick='window.location = "${aBodyLink}"' />
                    <input type="button" value="Term Types" name="P Institution" class="button" <c:if test="${empty institution.id}">disabled='disabled'</c:if> onclick='window.location = "${termTypeLink}"' />
                    <input type="button" value="Transcript Key" name="P Institution" class="button" <c:if test="${empty institution.id}">disabled='disabled'</c:if> onclick='window.location = "${transcriptKeyLink}"' />
                    <input type="button" value="Articulation Agreement" name="P Institution" class="button" <c:if test="${empty institution.id}">disabled='disabled'</c:if> onclick='window.location = "${aAgreementLink}"' />
					<br  />
                </td>
                <td>
               		 <c:if test="${role=='MANAGER'}"> 
                    	<input type="button" value="Home"  onclick='window.location = "/scheduling_system/evaluation/ieManager.html?operation=managerEvaluationView"' class="button" />
                    	<input type="button" value="Manage Institution/Course" id="backInstitutionList"  onclick='window.location = "/scheduling_system/evaluation/ieManager.html?operation=getInstitutionList"' class="button" />
                    </c:if>
                </td>
            </tr>
        </table>
		<br  />
   </div>     
</center>    
 -->
