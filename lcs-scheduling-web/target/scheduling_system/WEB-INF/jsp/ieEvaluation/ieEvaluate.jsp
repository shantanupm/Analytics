<%@include file="../init.jsp" %>
<script type="text/javascript">
jQuery(document).ready(function(){


	if('${institution.evaluationStatus}'.toLowerCase()=='EVALUATED'.toLowerCase() ){
		jQuery('.institutionEvlClass').attr('href','#');
		jQuery('.institutionEvlClass').text('Completed')
		jQuery('.institutionEvlClass').addClass('disabledTxt');
		jQuery('.courseEvlClass').show();
		jQuery('#markComplete').hide();
		//jQuery('.courseEvaluation').show();
	}else{
		//jQuery('.courseEvaluation').hide();
		jQuery('.institutionEvlClass').show();
		if('${institutionMirror.id}'!=''){
			jQuery('.courseEvlClass').show();
			jQuery('#markComplete').show();			
		}else{
			jQuery('.courseEvlClass').hide();
			jQuery('#markComplete').hide();
		}
	
	}
	if('${institution.checkedBy}'=='${userID}' && '${institution.checkedStatus}'.toLowerCase()=='COMPLETED'.toLowerCase() ){
		jQuery('.courseEvaluation').show();
		jQuery('.institutionEvlClass').text('Completed')
	}
	else if('${institution.confirmedBy}'=='${userID}' &&'${institution.confirmedStatus}'.toLowerCase()=='COMPLETED'.toLowerCase() ){
		jQuery('.courseEvaluation').show();
		jQuery('.institutionEvlClass').text('Completed')
	}else if('${institution.evaluationStatus}'.toLowerCase()=='EVALUATED'.toLowerCase()){
		jQuery('.courseEvaluation').show();
		jQuery('.institutionEvlClass').text('Completed')
	}
	else{
		jQuery('.courseEvaluation').hide();
	}
});


function getEvalutationQueue(){
	Boxy.load("<c:url value='/evaluation/quality.html?operation=selectInstitueQueueEvaluation'/>",{ unloadOnHide : true});
}
</script>


<div class="deo2">
  <div style="border:1px solid #e7e7e7; border-top:none;" class="institute">
  	<div class="noti-tools2">
    <div>
      <div class="mt30 mb10">
       		<span class="iegrayInfo">There are currently <span class="ieOrngInfo">${evaluationCount} evaluations</span> waiting in the queue</span>
       
       <div class="fr">
   		<a  class="getNew mr10"  href="/scheduling_system/evaluation/quality.html?operation=skipInstitution&institutionId=${institution.id}" >Get new</a> 
   		<a href="/scheduling_system/evaluation/quality.html?operation=releaseToQueue&institutionId=${institution.id}" class="releaseQueue">Release to Queue </a></div>
       <div class="clear"></div>
       
       
       </div>
       
       <c:if test="${ !empty institution.id }">
       <div>
      	 	<div class="tabHeader">Institution Details</div>
            <div class="tabTBLborder mb30">
        	
            <div><table width="100%" border="0" cellspacing="0" cellpadding="0" class="deosrc-tbl">
  <tr>
    <th width="10%" scope="col" class="brdRight">Institution ID</th>
    <th width="60%" scope="col" class="brdRight">Institution Title</th>
    <th width="10%" scope="col" ><span class="sort_d">Status</span></th>
    <th width="1%" scope="col" >&nbsp;</th>
  </tr>
</table>
</div>
            <div class="deosrcScroll2">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" class="deosrc-tbl">
                <tr>
                  <td width="10%" class="noBorder">${institution.institutionID}</td>
                  <td width="62%" class="noBorder">${institution.name}</td>
                  <td width="11%" class="noBorder"><a  class="institutionEvlClass" 
                  href="/scheduling_system/evaluation/ieManager.html?operation=createInstitution&institutionId=${institution.id}">Evaluate</a></td>
                </tr>
              </table>
            </div>
        
        
        </div>
       
       </div>
       
       <div>
      	 	<div class="tabHeader">Course(s) Details</div>
          <div class="tabTBLborder mb30">
        	
            <div><table width="100%" border="0" cellspacing="0" cellpadding="0" class="deosrc-tbl">
  <tr>
    <th width="10%" scope="col" class="brdRight">TR Course Code</th>
    <th width="60%" scope="col" class="brdRight">TR Course Title</th>
    <th width="10%" scope="col" ><span class="sort_d">Status</span></th>
    <th width="1%" scope="col" >&nbsp;</th>
  </tr>
</table>
</div>
            <div class="deosrcScroll2">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" class="deosrc-tbl">
              <c:forEach items="${transferCourseList}" var="transferCourse" varStatus="index">
			  <c:if test="${institution.id eq transferCourse.institution.id }">
		    
                <tr>
                  <td width="10%" >${transferCourse.trCourseCode} </td>
                  <td width="64%"  >${transferCourse.trCourseTitle}</td>
                  <td width="11%">
                  	<label class="courseEvaluation">
                  		<a class="courseEvaluation" href="<c:url value='/evaluation/quality.html?operation=ieCourse&institutionMirrorId=${institution.id}&transferCourseId=${transferCourse.id}&directLink=1'/>">Evaluate</a>
                  	</label>
                  </td>
                </tr>
                </c:if>
                </c:forEach>
                
                <c:forEach items="${transferCourseTodayCompletedList}" var="transferCourseTodayCompleted" varStatus="index">
			 
		    
                <tr>
                  <td width="10%" <c:if test="${index.index eq fn:length(transferCourseTodayCompletedList)-1 }"> class="noBorder"</c:if>>${transferCourseTodayCompleted.trCourseCode} </td>
                  <td width="64%"  <c:if test="${index.index eq fn:length(transferCourseTodayCompletedList)-1 }"> class="noBorder"</c:if>>${transferCourseTodayCompleted.trCourseTitle}</td>
                  <td width="11%"  <c:if test="${index.index eq fn:length(transferCourseTodayCompletedList)-1 }"> class="noBorder"</c:if> >
                  <label class="courseEvaluation disabledTxt"><a class="courseEvaluation" href="<c:url value='/evaluation/quality.html?operation=ieCourse&institutionMirrorId=${institution.id}&transferCourseId=${transferCourseTodayCompleted.id}&directLink=1'/>">Completed</a></label></td>
                </tr>
                
                </c:forEach>
            
                      
              </table>
            </div>
        
        
        </div>
       
       </div>
    </div>
    </c:if>
  	  <div class="deoTranscription">
    	<table style="background:none" width="100%" border="0" cellspacing="0" cellpadding="0" class="contentForm">
            <tr>
              <td width="30" align="center" valign="middle"><img src="images/evaluated_institution_courses.png" width="11" height="189" alt="" /></td>
              <td valign="top" width="20%">
              
              	<div class="graphposit">
                    <img src="images/chart.png" width="499" height="275" border="0" />
                </div>
              </td>
              <td valign="top">
              	<div class="graphpositDtl">
			
                    <div class="transBorderbtm">Total Evaluated Institutions & Courses:<span class="col1"> ${totalEvaluatedCount}</span></div><br class="clear" />
                    <div class="transBorderbtm">Last 6 Month  Evaluated Institutions & Courses:<span class="col2">${last6MonthEvaluatedCount}</span></div><br class="clear" />
                    <div class="transBorderbtm">Last 3 Month Evaluated Institutions & Courses:<span class="col3"> ${last3MonthEvaluatedCount}</span></div><br class="clear" />
                    <div class="transBorderbtm">This Week Evaluated Institutions & Courses: <span class="col4">${last7DaysEvaluatedCount}</span></div><br class="clear" />
                    <div class="transBorderbtm">Todays Evaluated Institutions & Courses: <span class="col5">${todaysEvaluatedCount}</span></div><br class="clear" />
                </div>
              </td>
          </tr>
            </table>
    </div>
    
  
    </div>
      
    </div>
  </div>

</div>
<br class="clear" />







<%-- <div id="getResponse">
<div class="deo">
	<div class="deoInfo">
        <h1 class="expand">Institution Details</h1>
    	
   
		<table width="100%" cellspacing="0" cellpadding="0" border="0" class="noti-tbl2 noti-bbn" 
		style="border-left:1px solid #e7e7e7; border-right:1px solid #e7e7e7; border-bottom:1px solid #e7e7e7;">
		  <tbody>
		  <tr>
			<td width="10%"><span>${institution.schoolcode}</span></td>
			<td width="50%"><span>${institution.name}</span></td>
			<td width="8%"><a href="#" onClick="window.location.reload()"><img src="../images/refreshIcon.png" width="14" height="14" alt="" /> Refresh</a></td>
			<td width="5%"><a class="institutionEvlClass" href="/scheduling_system/evaluation/quality.html?operation=ieInstitution&institutionId=${institution.id}"> Evaluate</a></td>
			<td width="5%"><a href="/scheduling_system/evaluation/quality.html?operation=skipInstitution&institutionId=${institution.id}">Skip</a></td>
			<!-- <td width="8%"><a  id="markComplete"  href='/scheduling_system/evaluation/quality.html?operation=markComplete&institutionMirrorId=${institutionMirror.id}' >Mark Complete</a></td> -->
		 	<td width="25%"><a href="javascript:void(0);" onclick="javascript:getEvalutationQueue();">Evaluation Queue</a></td> 
			<td colspan="5"  class="noBorder">&nbsp;</td>
			</tr>
		  </tbody>
		</table>
       
        
    </div>
    
    <div style="border:1px solid #e7e7e7;">
 
	
    <table width="100%" cellspacing="0" cellpadding="0" border="0" class="noti-tbl2 noti-bbn">
      <tbody>
      <tr>
        <th width="10%" scope="col" class="lBlue"><span>TR Course Code</span></th>
        <th width="50%" scope="col" class="dividerGrey"><span>TR Course Title</span></th>
        <th width="40%" scope="col" class="dividerGrey"><span>Action</span></th>
        </tr>
		  <c:forEach items="${transferCourseList}" var="transferCourse" varStatus="index">
			  <c:if test="${institution.id eq transferCourse.institution.id }">
		      <tr>
		      
			        <td width="10%"><span>${transferCourse.trCourseCode}</span></td>
			        <td width="50%"> ${transferCourse.trCourseTitle}</td>
			        <td width="40%"><a class="courseEvaluation" href="/scheduling_system/evaluation/quality.html?operation=ieCourse&institutionMirrorId=${institutionMirror.id}&transferCourseId=${transferCourse.id}">Evaluate</a></td>
		        </tr>
	        </c:if>
		 </c:forEach>
      <tr>
      	<td colspan="2" class="noBorder">&nbsp;</td>
      </tr>
      </tbody>
    </table>
    </div>
</div>
<br class="clear" />

</div>
 --%>





