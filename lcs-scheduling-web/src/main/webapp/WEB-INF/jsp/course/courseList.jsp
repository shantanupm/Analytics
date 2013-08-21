<%@include file="../init.jsp" %>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>

<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>
<link rel="stylesheet" media="screen" href="<c:url value="/css/jquery.ui.autocomplete.css"/>" />
<script type="text/javascript" src="<c:url value="/js/jquery.js"/>"></script>

<script type='text/javascript' src="<c:url value="/js/jquery.ui.core.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.widget.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.position.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.autocomplete.js"/>"></script> 

<script type='text/javascript' src="<c:url value="/js/jquery-ui-1.8.23.custom.min.js"/>"></script> 


<script>
jQuery(document).ready(function(){
	
	jQuery("#status").val('${status}');
	jQuery("#searchBy").val('${searchBy}');
	jQuery("#searchText").val('${searchText}');
	
	jQuery("#status").change(function(){
		window.location.href='ieManager.html?operation=getCoursesForInstitution&institutionId=${institution.id}&status='+jQuery(this).val();
	});
	
	jQuery("#resetSearch").click(function(){
		jQuery("#searchBy").val("2");
		jQuery("#searchText").val("");
		jQuery("#status").val("ALL");
		window.location.href='ieManager.html?operation=getCoursesForInstitution&institutionId=${institution.id}';
	});
	
	jQuery("#searchCourse").click(function(){
		var statusValue=jQuery("#status").val();
		if(statusValue===undefined||statusValue.length==0){
			statusValue='ALL'
		}
		window.location.href='ieManager.html?operation=getCoursesForInstitution&institutionId=${institution.id}&searchBy='+jQuery("#searchBy").val()+'&searchText='+jQuery("#searchText").val()+'&status='+statusValue;
	});
	
	jQuery('#searchText').keypress(function(e) {
		var statusValue=jQuery("#status").val();
		if(statusValue===undefined||statusValue.length==0){
			statusValue='ALL'
		}
		 var code = (e.keyCode ? e.keyCode : e.which);
		 if(code == 13) { //Enter keycode
			 window.location.href='ieManager.html?operation=getCoursesForInstitution&institutionId=${institution.id}&searchBy='+jQuery("#searchBy").val()+'&searchText='+jQuery("#searchText").val()+'&status='+statusValue;	 	
		 }
	});
	/*Dont Provide Autocomplete as for course it is very Heavy*/ 
	//autoCompleteCourse();
	
	
});

function getByStatus(statusValue){
	window.location.href='ieManager.html?operation=getCoursesForInstitution&institutionId=${institution.id}&status='+jQuery(statusValue).attr('val');
	
	
}
function getAssignees(transferCourseId) {
	
	var url="<c:url value='ieManager.html?operation=getCourseAssignDetails&transferCourseId="+transferCourseId+"'/>";
	
	Boxy.load(url,
	{ unloadOnHide : true	
	});
	
	
}
function autoCompleteCourse(){
	
	jQuery( "#searchText" ).autocomplete({
		//source: availableTags
		source: function( request, response ) {
			jQuery.ajax({
			url: "ieManager.html?operation=getTransferCourseByInstitutionIdAndString&institutionId=${institution.id}&searchBy="+jQuery("#searchBy").val()+"&searchText="+request.term,
			dataType: "json",
			data: {
				style: "full",
				maxRows: 5,
				name_startsWith: request.term
			},
			success: function( data ) {
				jQuery("#searchText").removeClass('auto-load');
				response( jQuery.map( data, function( item ) {
					
					if(jQuery("#searchBy").val()==1){
						return {
							label: item.trCourseCode ,
							value: item.trCourseCode
						}
					}else{
						return {
							label: item.trCourseTitle ,
							value: item.trCourseTitle
						}
					}
				}));
			},
			error: function(xhr, textStatus, errorThrown){
				jQuery("#searchText").removeClass('auto-load');
			},
			

		});
	},
	
	minLength: 4,
	 search: function(event, ui) { jQuery(this).addClass("auto-load"); },
	  open: function(event, ui) { jQuery(this).removeClass("auto-load"); }
	  
	
	});
}
</script>

  
  
<div class="">
<div class="fr addCourse">
   		<a href="<c:url value="ieManager.html?operation=createCourse&directLink=0"/>"> 
   		Create Course</a>
   	 </div>  <br class="clear">
            <div class="noti-tools">
                <div class="fl">
    <!--             <label class="noti-label" for="View by">Status:</label>
                    <select class="frm-stxbx" id="status" name="status">
                        <option value="ALL">All</option>
                        <option value="EVALUATED">Evaluated</option>
						<option value="NOT EVALUATED">Not Evaluated</option>
						<option value="CONFLICT">Conflict</option>
                    </select>  -->
                <span class="fl"> <label class="noti-label">Search By:</label>
                
                    <select class="frm-stxbx" id="searchBy" name="searchBy">
                       <option value="2">Course Title</option>
                       <option value="1">Course Code</option>
                       <option value="3">Institution Id</option>
                       <option value="4">Institution Name</option>
                    </select>
                   <input type="text" id="searchText" class="txbx noti-txbx " name="searchText">
                </span>
                <span style="margin-left: 4px;">
                    <input type="button" value="Go" id="searchCourse" name="searchCourse">
                    <input type="button" value="Reset" id="resetSearch" name="resetSearch">
                </span>
                <br class="clear">
                </div>
                
               
         
          	  <div class="fr orgColorbackground">
	          	  <span> 
	          	  		<label class="noti-label noti-mrgl fl"><a onclick='javscript:getByStatus(this);' val='Conflict' href='javascript:void(0)'>Conflict</a></label> 
	          	  		<span style="margin-top:-3px" class="notification fr">${conflictCount }</span>                   
	              </span>
	              <span> <label class="noti-label noti-mrgl">Re-assignable</label> 
	                 <span style="margin-top:-3px" class="notification">${reassignableCount }</span>                  
	              </span>
	             <span> <label class="noti-label noti-mrgl"><a onclick='javscript:getByStatus(this);' val='Approval' href='javascript:void(0)'>For Approval</a></label> 
	                 <span style="margin-top:-3px" class="notification">${approvalCount }</span>                  
	             </span>
              </div>
                <br class="clear">
            </div>
    
    
    <display:table name="courseList"  class="noti-tbl" id="course" pagesize="10"   requestURI="ieManager.html" export="false" sort="external">
     <display:column property="trCourseCode"  title="<span class='sort_d'>Course Code</span>"  sortable="true"  headerClass="dividerGrey thW10" />
     <display:column style="width:500px" title="Course Title" headerClass="dividerGrey" >
     	<c:choose>
		    <c:when test="${(userRoleName eq 'Institution Evaluation Manager' || userRoleName eq 'Administrator') && (fn:toUpperCase(course.evaluationStatus) ne 'CONFLICT' && course.reassignable ne true && course.collegeApprovalRequired ne true)}">     	 		
     	 		<a href="<c:url value="ieManager.html?operation=createCourse&institutionId=${course.institution.id }&transferCourseId=${course.id}"/>">${course.trCourseTitle}</a>
     	 	</c:when>     	 	
     	 	<c:when test="${userRoleName eq 'Institution Evaluator' && (fn:toUpperCase(course.evaluationStatus) eq 'NOT EVALUATED' && ((! empty course.checkedBy && course.checkedBy eq userCurrentId) || (! empty course.confirmedBy && course.confirmedBy eq userCurrentId)) ) && (course.reassignable ne true && course.collegeApprovalRequired ne true)}">     	 		
     	 		<a href="<c:url value="/evaluation/quality.html?operation=ieCourse&institutionMirrorId=${course.institution.id }&transferCourseId=${course.id}"/>">${course.trCourseTitle}</a>
     	 	</c:when>
     	 	<c:when test="${userRoleName eq 'Institution Evaluator' && (fn:toUpperCase(course.evaluationStatus) eq 'NOT EVALUATED' || fn:toUpperCase(course.evaluationStatus) eq 'EVALUATED' ) && (course.reassignable ne true && course.collegeApprovalRequired ne true)}">     	 		
     	 		<a href="<c:url value="ieManager.html?operation=createCourse&institutionId=${course.institution.id }&transferCourseId=${course.id}"/>">${course.trCourseTitle}</a>
     	 	</c:when>
     	 	<c:otherwise>
     	 		${course.trCourseTitle}
     	 	</c:otherwise>
     </c:choose>         
     </display:column>
     <display:column property="institution.institutionID"  title="<span class=''>Institution Id</span>"    headerClass="dividerGrey thW10" />
     <display:column property="institution.name"  title="<span class='sort_d'>Institution Name</span>"   sortable="true" headerClass="dividerGrey thW20" />
       <display:column  title="<dl class='dropdown dropdown1 filterSeletect3 filterType' id='status'>
		    <dt><a title='Status' href='javascript:void(0);'>Status </a></dt>
		         <dd>
		             <ul id='status' style='width: 160px; display: none;'>
		                <li><a onclick='javscript:getByStatus(this);' val='ALL' href='javascript:void(0);'><span class='' >ALL </span></a></li>
		                <li><a onclick='javscript:getByStatus(this);' val='Evaluated' href='javascript:void(0)'><span class='smalAsignmentIcon'>EVALUATED</span></a></li>
						<li><a onclick='javscript:getByStatus(this);' val='Not Evaluated' href='javascript:void(0)'><span class='smalQuizIcon'>NOT EVALUATED</span></a></li>
						<li><a onclick='javscript:getByStatus(this);' val='Conflict' href='javascript:void(0)'><span class='smalForumIcon'>CONFLICT</span></a></li>
					</ul>
		         </dd>
	  </dl>" sortable="false"  headerClass="dividerGrey thW15" >
		   <c:choose>
		    	 <c:when test="${course.collegeApprovalRequired && userRoleName eq'Institution Evaluation Manager'}">
				   		${fn:toUpperCase(course.evaluationStatus)}&nbsp;<a href="<c:url value="ieManager.html?operation=createCourse&institutionId=${course.institution.id }&transferCourseId=${course.id}"/>" >(For Approval)</a>
				   </c:when>
				   <c:when test="${course.reassignable && userRoleName eq'Institution Evaluation Manager'}">
				   		${fn:toUpperCase(course.evaluationStatus)}&nbsp;<a href="javascript:void(0)" onclick="getAssignees('${course.id}');">(Re-assignable)</a>
				   </c:when>
				   <c:when test="${course.evaluationStatus eq 'CONFLICT' && userRoleName eq'Institution Evaluation Manager'}">
				   		${fn:toUpperCase(course.evaluationStatus)}&nbsp;<a href='<c:url value="ieManager.html?operation=conflictCourse&transferCourseId=${course.id}"/>'>(Resolve)</a>
				   </c:when>
				   <c:otherwise>
				   		${fn:toUpperCase(course.evaluationStatus)}
				   </c:otherwise>
			</c:choose>
	   </display:column>
	   <display:column  title="<span >Evaluator</span>"   headerClass="dividerGrey thW10" >
 		 ${course.evaluator1.userName}  <c:if test="${!empty course.evaluator1.userName && !empty course.evaluator2.userName}">,</c:if> 
 		  ${course.evaluator2.userName}
    	</display:column>
	   <display:column   property="modifiedDate" format="{0,date,MM/dd/yyyy}" title="<span class='sort_d' >
	   Modified Date</span>"  sortable="true" headerClass="dividerGrey thW10" />
	   
    </display:table>
    <br class="clear"/>
            
          
 <!--             <display:table name="courseList"  class="noti-tbl" id="course" pagesize="10"   requestURI="ieManager.html" export="false" sort="external">  
			 	<display:column title="Sr. No."   headerClass="dividerGrey thW08"  value="${course_rowNum}"/> 
			    <display:column property="trCourseCode"  title="<span class='sort_d'>Course Code</span>"  sortable="true"  headerClass="dividerGrey thW20" />
			     <display:column style="width:500px" title="Course Title" headerClass="dividerGrey" >
			                <a href="<c:url value="ieManager.html?operation=createCourse&institutionId=${institution.id}&transferCourseId=${course.id}"/>">${course.trCourseTitle}</a> 
			            </display:column>
				 
			</display:table>
			 --> 
        </div>
   


<!-- 

<center>
<div class="tblFormDiv divCover outLine"  >

All Courses For ${institution.name} (${institution.schoolcode})	<br><br><!--

Total : ${fn:length(evaluatedCourses) + fn:length(notEvaluatedCourses) + fn:length(conflictCourses)}
->
<div class="" >   
<div style="text-align:left">

<label>
 Search by: </label>
 <select name="searchBy" id="searchBy">
	<option value="1">Course Code</option>
	<option value="2">Course Title </option>
</select> 
<input id="searchText" name="searchText" type="text" value="" />
<input name="searchCourse" type="button" value="Go" class="go" id="searchCourse"/>
<input name="resetSearch"  type="button" value="Reset" class="go" id="resetSearch"/>

<label>Status: </label>
 <select id="status" name="status">
    <option value="EVALUATED">Evaluated</option>
    <option value="NOT EVALUATED">Not Evaluated</option>
    <option value="CONFLICT">Conflict</option>
    
</select>
</div>
<br class="clear" />
 <display:table name="courseList"  id="course" pagesize="10"   requestURI="ieManager.html" export="false" sort="external">  
 	<display:column title="Sr. No."   headerClass="heading"  value="${course_rowNum}"/> 
    <display:column property="trCourseCode" title="Course Code"  sortable="true"  />
     <display:column style="width:500px" title="Course Title" headerClass="heading" >
                <a href="<c:url value="ieManager.html?operation=createCourse&institutionId=${institution.id}&transferCourseId=${course.id}"/>">${course.trCourseTitle}</a> 
            </display:column>
	 
</display:table> 

 

 
	
</div>
<table>
<tr>

<td width=27%><input type="button" value="Back to institution list"  onclick='window.location = "/scheduling_system/evaluation/ieManager.html?operation=getInstitutionList"' class="button" /></td>
<td width=23%><input type="button" value="Create Course"  onclick='window.location = "ieManager.html?operation=createCourse&institutionId=${institution.id}"' class="button" /></td>


</tr>
</table>
</div>
</center>
-->