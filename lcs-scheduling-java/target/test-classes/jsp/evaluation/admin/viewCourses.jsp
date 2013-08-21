<%@include file="../../init.jsp" %>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>
<!-- <link rel="stylesheet" href="../css/displaytag.css" type="text/css">  --> 



<script>
jQuery(document).ready(function(){
	
	jQuery("#status").val('${status}');
	jQuery("#searchBy").val('${searchBy}');
	jQuery("#searchText").val('${searchText}');
	
	jQuery("#status").change(function(){
		window.location.href='admin.html?operation=viewCourses&institutionId=${institution.id}&status='+jQuery(this).val();
	});
	
	jQuery("#resetSearch").click(function(){
		jQuery("#searchBy").val("2");
		jQuery("#searchText").val("");
		jQuery("#status").val("ALL");
		window.location.href='admin.html?operation=viewCourses&institutionId=${institution.id}';
	});
	
	jQuery("#searchCourse").click(function(){
		window.location.href='admin.html?operation=viewCourses&institutionId=${institution.id}&searchBy='+jQuery("#searchBy").val()+'&searchText='+jQuery("#searchText").val()+'&status='+jQuery("#status").val();
	});
	
	jQuery('#searchText').keypress(function(e) {
		 var code = (e.keyCode ? e.keyCode : e.which);
		 if(code == 13) { //Enter keycode
			 window.location.href='admin.html?operation=viewCourses&institutionId=${institution.id}&searchBy='+jQuery("#searchBy").val()+'&searchText='+jQuery("#searchText").val()+'&status='+jQuery("#status").val();	 	
		 }
	});
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
	
	minLength: 2,
	 search: function(event, ui) { jQuery(this).addClass("auto-load"); },
	  open: function(event, ui) { jQuery(this).removeClass("auto-load"); }
	  
	
	});
});
</script>

<div class="noti-bordr">
	<div class="noti-tools">
    	<div class="fl">
        	<label class="noti-label" for="View by">Status:</label>
            <select class="frm-stxbx" id="status" name="status">
            	<option value="ALL">All</option>
            	<option value="EVALUATED">Evaluated</option>
				<option value="NOT EVALUATED">Not Evaluated</option>
				<option value="CONFLICT">Conflict</option>
		    </select>
           	<span class="fl"> <label class="noti-label noti-mrgl">Search:</label>
	           	<input type="text" id="searchText" class="txbx noti-txbx hasDatepicker" name="searchText">
	           	<select class="frm-stxbx" id="searchBy" name="searchBy">
	           		<option value="2">Course Title</option>
	           		<option value="1">Course Code</option>
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
            
             <display:table name="courseList"  class="noti-tbl" id="course" pagesize="10"   requestURI="admin.html" export="false" sort="external">  
			 	<display:column title="Sr. No."   headerClass="dividerGrey thW08"  value="${course_rowNum}"/> 
			    <display:column property="trCourseCode"  title="<span class='sort_d'>Course Code</span>"  sortable="true"  headerClass="dividerGrey thW20" />
			     <display:column style="width:500px" title="Course Title" headerClass="dividerGrey" >
			                <a href="<c:url value="admin.html?operation=viewCourseDetails&courseId=${course.id}"/>">${course.trCourseTitle}</a> 
			            </display:column>
				 
			</display:table> 
</div>
        
<!-- 
<center>
<div class="tblFormDiv divCover outLine"  >

All Courses For ${institution.name} (${institution.schoolcode})	<br><br>


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
 <display:table name="courseList"  id="course" pagesize="10"   requestURI="admin.html" export="false" sort="external">  
 	<display:column title="Sr. No."   headerClass="heading"  value="${course_rowNum}"/> 
    <display:column property="trCourseCode" title="Course Code"  sortable="true"  />
     <display:column style="width:500px" title="Course Title" headerClass="heading" >
                <a href="<c:url value="admin.html?operation=viewCourseDetails&courseId=${course.id}"/>">${course.trCourseTitle}</a> 
            </display:column>
	 
</display:table> 
	<table width="100%"  cellspacing="1"  border="1" style="border-collapse: collapse;" cellpadding="0" class="">
		<tr>
    	  	<th class="heading">&nbsp;Sr.No</th>
	  		<th class="heading">&nbsp;Course Code</th>
	  		<th class = "heading">&nbsp;Course Title</th>
    	</tr>

		<tr height="40px">
	    		<td  colspan="5">&nbsp; EVALUATED <c:if test="${fn:length(evaluatedCourses) == 0}"> &nbsp; &nbsp;  ---- No Courses</c:if>
	    </tr>
    	<c:forEach items="${evaluatedCourses}" var="course" varStatus="index">
    	
    		<tr>
    		<td align="left" valign="top" class="table-content">${index.count}</td>
    		<td align="left" valign="top" class="table-content">${course.trCourseId}</td>
    		<td align="left" valign="top" class="table-content">${course.trCourseTitle}</td>
    		</tr>
    		
    	</c:forEach>
    	<tr height="40px">
	    		<td  colspan="5">&nbsp; NOT EVALUATED <c:if test="${fn:length(notEvaluatedCourses) == 0}"> &nbsp; &nbsp;  ---- No Courses</c:if>
	    </tr>
    	<c:forEach items="${notEvaluatedCourses}" var="course" varStatus="index">
    	
    		<tr>
    		<td align="left" valign="top" class="table-content">${index.count}</td>
    		<td align="left" valign="top" class="table-content">${course.trCourseId}</td>
    		<td align="left" valign="top" class="table-content">${course.trCourseTitle}</td>
    		</tr>
    		
    	</c:forEach>
    	<tr height="40px">
	    		<td  colspan="5">&nbsp; CONFLICT  <c:if test="${fn:length(conflictCourses) == 0}">&nbsp; &nbsp;&nbsp; ---- No Courses</c:if>
	    </tr>
    	<c:forEach items="${conflictCourses}" var="course" varStatus="index">
    	
    		<tr>
    		<td align="left" valign="top" class="table-content">${index.count}</td>
    		<td align="left" valign="top" class="table-content">${course.trCourseId}</td>
    		<td align="left" valign="top" class="table-content">${course.trCourseTitle}</td>
    		</tr>
    		
    	</c:forEach>
	</table>  
</div>
<table>
<tr>
<td width=27%><a href="/scheduling_system/evaluation/admin.html?operation=viewInstitutions">Back to institution list</a></td>
<td width="23%"><a href="/scheduling_system/evaluation/admin.html?operation=adminView">Home Page</a></td>
</tr>
</table>
</div>
</center>
 -->     