<%@include file="../init.jsp" %>
 <script type='text/javascript' src="<c:url value="/js/jquery-1.8.0.min.js"/>"></script>
	 <script type='text/javascript' src="<c:url value="/js/jquery-ui-1.8.23.custom.min.js"/>"></script>

<script>

	jQuery(document).ready(function(){
		// Tabs
		jQuery('#tabs').tabs({ selected: 0 });
	
		
		jQuery("#searchBy").val('${searchBy}');
		jQuery("#searchText").val('${searchText}');
		
		jQuery("#resetSearch").click(function(){
			jQuery("#searchBy").val("2");
			jQuery("#searchText").val("");
			window.location.href='ieManager.html?operation=managerEvaluationView';
		});
		
		jQuery("#searchCourse").click(function(){
			window.location.href='ieManager.html?operation=managerEvaluationView&searchBy='+jQuery("#searchBy").val()+'&searchText='+jQuery("#searchText").val();
		});
		
		jQuery('#searchText').keypress(function(e) {
			 var code = (e.keyCode ? e.keyCode : e.which);
			 if(code == 13) { //Enter keycode
				 window.location.href='ieManager.html?operation=managerEvaluationView&searchBy='+jQuery("#searchBy").val()+'&searchText='+jQuery("#searchText").val();	 	
			 }
		});
		settingToolTip();
	});
	
	function settingToolTip()

	{
	                                                
            jQuery('.showToolTip').live('mouseenter',function() {
            var docHeight = jQuery(document).height();
            var obj = jQuery(this).find('.toolTipBox');                                                                              
            //alert(settingBtnHeight);
            var thisPos = jQuery(this).offset().top;
                                                                                          
            if(docHeight - thisPos < obj.height()+100)
            {
                 obj.removeClass('toolTipBox1');
                 obj.addClass('toolTipBox3');
            }
            });
	}
</script>




<div id="tabs">
  <%--   <ul>
        <li><a href="#tabs-1">Conflict List</a> <span class="notification">${conflictCount}</span></li>
        <li><a href="#tabs-2" onclick="window.location='/scheduling_system/evaluation/ieManager.html?operation=getCoursesForApproval'">College/Courses Approval</a> <span class="notification">${requiredApprovalCount}</span></li>
        <li><a onclick="window.location='/scheduling_system/evaluation/ieManager.html?operation=getInstitutionList&status=EVALUATED'" href="#tabs-3">Manage Institutions/Courses</a></li>
    </ul> --%>  <%@include file="../tabsNavigation.jsp" %>
    <div id="tabs-1">
	
	<div class="noti-bordr">
                    <div class="noti-tools">
                <div class="fl">
               
                <span class="fl"> <label class="noti-label noti-mrgl">Search:</label>
                <input type="text" id="searchText" class="txbx noti-txbx hasDatepicker" name="searchText">
                    <select class="frm-stxbx" id="searchBy" name="searchBy">
                       <option value="2">Institution Title</option>
                       <option value="1">School Code</option>
                    </select>
                </span>
                <span>
                    <input type="button" value="Search" id="searchCourse" name="searchCourse">
                    <input type="button" value="Reset" id="resetSearch" name="resetSearch">
                </span>
                <br class="clear">
                </div>
                
               
                 <br class="clear">
            </div>
            
          <table width="100%" cellspacing="0" cellpadding="0" border="0" class="noti-tbl">
            <tbody>
              <tr>
                <th width="15%" scope="col" class="dividerGrey"><span>Institution Code</span></th>
                <th width="35%" scope="col" class="dividerGrey"><span >Institution Title</span></th>
                <th width="25%" scope="col" class="dividerGrey">Evaluators Name</th>
                <th width="25%" scope="col" class="dividerGrey"><span>Course</span></th>
                
              </tr>
			
    <c:choose>
        <c:when test="${fn:length(institutionList)>0}">
			<c:forEach items="${institutionList}" var="institution" varStatus="index">
              <tr>
                <td valign="top"><span>${institution.schoolcode}</span></td>
                <td valign="top" class="txi07"><c:choose>
					 <c:when test="${fn:toUpperCase(institution.evaluationStatus)=='CONFLICT'}">
					 <a href="/scheduling_system/evaluation/ieManager.html?operation=conflictInstitution&institutionId=${institution.id}">${institution.name} </a>
					 </c:when>
					 <c:otherwise>
							${institution.name}
					 </c:otherwise>
					 </c:choose>
					</td>
					<td valign="top">
					<c:choose>
					 <c:when test="${fn:toUpperCase(institution.evaluationStatus)=='CONFLICT'}">
					 		<div class="showToolTip">
                            <div class="toolTipBox toolTipBox1" style="display: none;">
                            	<span class="caltooltip"></span>
                            	<strong class="red">Evaluator Name</strong><br>
                            	<div class="divider1"></div>
                            	<div class="captiongray">Evaluator 1:${institution.evaluator1.firstName} ${institution.evaluator1.lastName}</div>
                                <div class="captiongray">Evaluator 2:${institution.evaluator2.firstName} ${institution.evaluator2.lastName}</div>
                            </div>
                            
                            <a href="" title="View Evaluator" class="smalAsignmentIcon">View Evaluator</a><br>
                            </div>
                           </c:when>
					 <c:otherwise>&nbsp;
					 </c:otherwise>
					 </c:choose>
                           </td>
                           
                <td valign="top" class="noti-td-brd">
                	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tximin05 noti-brn">
					<c:forEach items="${institution.transferCourses}" var="course" varStatus="courseIndex">
                      <tr>
                        <td width="60%">
                        <a href="/scheduling_system/evaluation/ieManager.html?operation=conflictCourse&transferCourseId=${course.id}">
                        <c:if test="${empty course.trCourseTitle}">${course.trCourseCode} </c:if>	${course.trCourseTitle}
                        </a>
                        </td>
                          <td valign="top">
                          <div class="showToolTip">
                            <div class="toolTipBox toolTipBox1" style="display: none;">
                            	<span class="caltooltip"></span>
                            	<strong class="red">Evaluator Name</strong><br>
                            	<div class="divider1"></div>
                            	<div class="captiongray">Evaluator 1:${course.evaluator1.firstName} ${course.evaluator1.lastName}</div>
                                <div class="captiongray">Evaluator 2:${course.evaluator2.firstName} ${course.evaluator2.lastName}</div>
                            </div>
                            <a href="" title="View Evaluator" class="smalAsignmentIcon">View Evaluator</a><br>
                             </div>
                            </td>
                       
                      </tr>
					   </c:forEach>
                     
                    </table>

                </td>
                
              </tr>
			   </c:forEach>
			   
			</c:when>
	    <c:otherwise>
		<tr> <td class="table-content" colspan="3">No Conflicts<td>
		</tr>
	    </c:otherwise>
    </c:choose>
             
         
            </tbody>
          </table>
        </div>
	
	
<!--	<center>
<div class="tblFormDiv divCover outLine"  >
<div style="padding:1px;" >  
    
  <table width="100%"  cellspacing="1"  border="1" style="border-collapse: collapse;" cellpadding="0" class="backgrnd">
    
    <tr>
      <th class="heading">Institution Code</th>
	  <th class="heading">Institution Title</th>
	  <th class="heading">Courses</th>
    </tr>
    <c:choose>
        <c:when test="${fn:length(institutionList)>0}">
	   
    
    <c:forEach items="${institutionList}" var="institution" varStatus="index">
    <tr>
      <td width="10%" align="left" valign="top" class="table-content">${institution.schoolcode}</td>
      <td align="left" valign="top" class="table-content">    <c:choose>
     <c:when test="${fn:toUpperCase(institution.evaluationStatus)=='CONFLICT'}">
	 <a href="/scheduling_system/evaluation/ieManager.html?operation=conflictInstitution&institutionId=${institution.id}">${institution.name} </a>
	 </c:when>
	 <c:otherwise>
			${institution.name}
	 </c:otherwise>
	 </c:choose>
	 </td>
      <td align="left" valign="top" class="table-content"><table width="100%" border="0" cellspacing="0" cellpadding="0">
	   <c:forEach items="${institution.transferCourses}" var="course" varStatus="courseIndex">
        <tr>
		  <td>${course.trCourseTitle}</td>
          <td width="20%" align="center" valign="middle" ><a href="/scheduling_system/evaluation/ieManager.html?operation=conflictCourse&transferCourseId=${course.id}">View</a></td>
        </tr>
         </c:forEach>
      </table></td>
    </tr>
	  </c:forEach>
	  
	   </c:when>
	    <c:otherwise>
		<tr> <td class="table-content" colspan="3">No Conflicts<td>
		</tr>
	    </c:otherwise>
    </c:choose>
    </table>
   </div>
   <a href="/scheduling_system/evaluation/ieManager.html?operation=getInstitutionList&status=EVALUATED">Manage institutions/courses</a>
   <br>
    <br>
   <a href="/scheduling_system/evaluation/ieManager.html?operation=getCoursesForApproval">Courses College Approval</a>
   <br><br>
   <a href="/scheduling_system/evaluation/ieManager.html?operation=getCoursesForReAssignment">Re-Assign Course Work</a>
 </div>
    </center> </div>-->
    
 <div id="tabs-2"></div>
	  <div id="tabs-3"></div>
</div>