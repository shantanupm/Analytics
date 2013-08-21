<%@include file="../../init.jsp" %>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>
<!-- <link rel="stylesheet" href="../css/displaytag.css" type="text/css"> -->
<link rel="stylesheet" media="screen" href="<c:url value="/css/jquery.ui.autocomplete.css"/>" />
<script type="text/javascript" src="<c:url value="/js/jquery.js"/>"></script>

<script type='text/javascript' src="<c:url value="/js/jquery.ui.core.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.widget.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.position.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.autocomplete.js"/>"></script> 

<script type='text/javascript' src="<c:url value="/js/jquery-ui-1.8.23.custom.min.js"/>"></script>
 

<script>
jQuery(document).ready(function(){
	jQuery('#tabs').tabs({ selected: 0 });
	
	jQuery("#status").val('${status}');
	jQuery("#searchBy").val('${searchBy}');
	jQuery("#searchText").val('${searchText}');
	
	jQuery("#status").change(function(){
		window.location.href='admin.html?operation=viewInstitutions&status='+jQuery(this).val();
	});
	
	jQuery("#resetSearch").click(function(){
		jQuery("#searchBy").val("2");
		jQuery("#searchText").val("");
		jQuery("#status").val("ALL");
		window.location.href='admin.html?operation=viewInstitutions';
	});
	
	jQuery("#searchCourse").click(function(){
		window.location.href='admin.html?operation=viewInstitutions&searchBy='+jQuery("#searchBy").val()+'&searchText='+jQuery("#searchText").val()+'&status='+jQuery("#status").val();
	});
	
	jQuery('#searchText').keypress(function(e) {
		 var code = (e.keyCode ? e.keyCode : e.which);
		 if(code == 13) { //Enter keycode
			 window.location.href='admin.html?operation=viewInstitutions&searchBy='+jQuery("#searchBy").val()+'&searchText='+jQuery("#searchText").val()+'&status='+jQuery("#status").val();	 	
		 }
	});
	jQuery( "#searchText" ).autocomplete({
		//source: availableTags,
		source: function( request, response ) {
			jQuery.ajax({
			url: "ieManager.html?operation=getInstitutionByCodeAndTitle&searchBy="+jQuery("#searchBy").val()+"&searchText="+request.term,
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
							label: item.schoolcode ,
							value: item.schoolcode
						}
					}else{
						return {
							label: item.name ,
							value: item.name
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

<div id="tabs">
	<ul>
        <li><a href="#tabs-1" onclick="window.location='/scheduling_system/evaluation/admin.html?operation=viewInstitutions'">View Institutions &amp; Courses</a></li>
        <li><a href="#tabs-2" onclick="window.location='/scheduling_system/evaluation/admin.html?operation=viewTranscripts'">View Transcripts</a> </li>
        <li><a href="#tabs-3" onclick="window.location='/scheduling_system/user/user.html?operation=manageUsers'">Manage Users</a></li>
    </ul>
    <div id="tabs-1">
		<div class="instituteCourses"  >

			<div class="noti-bordr">
				<div class="noti-tools">
					<div class="fl">
						<label class="noti-label" for="status">Status: </label>
					 	<select id="status" name="status" class="frm-stxbx">
						    <option value="ALL">All</option>
						    <option value="EVALUATED">Evaluated</option>
						    <option value="NOT EVALUATED">Not Evaluated</option>
						    <option value="CONFLICT">Conflict</option>
						</select>
						<span class="fl"> <label class="noti-label noti-mrgl">Search:</label>
		                <input type="text" id="searchText" class="txbx noti-txbx" name="searchText" value=""/>
		                    <select class="frm-stxbx" id="searchBy" name="searchBy">
		                        <option value="2">Institution Title</option>
		                        <option value="1">School Code</option>
		                    </select>
		                </span>
		                <span>
                    		<input name="searchCourse" type="button" value="Search"  id="searchCourse"/>
                    		<input name="resetSearch"  type="button" value="Reset"  id="resetSearch"/>
                		</span>
                		<br class="clear">
					</div>
					<br class="clear">
				</div>
				<display:table name="institutionList"  id="inst" class="noti-tbl"  pagesize="10"  requestURI="admin.html" export="false" sort="list">  
		 			<display:column title="Sr. No."  headerClass=" thW08"  value="${inst_rowNum}"/> 
		      		<display:column  title="<span class='sort_d'>Institution Code</span>" sortable="true" sortProperty="schoolcode" headerClass="dividerGrey thW10" >
					   ${inst.schoolcode}
				   	</display:column>
		      		<display:column  title="<span class='sort_d'>Institution</span>" sortable="true" sortProperty="name" headerClass="dividerGrey	p05" >
		           		<a href="<c:url value="admin.html?operation=viewInstitutionDetails&institutionId=${inst.id}"/>">${inst.name}</a> 
			    	</display:column>
		     		<display:column property="id" title="Courses"  headerClass="dividerGrey"  format="<a href='/scheduling_system/evaluation/admin.html?operation=viewCourses&institutionId='{0}>
		     		<img src='/scheduling_system/images/viewCourseIcon.png' width='18' height='17' alt='View Course' />View Courses</a> "/>
			 	</display:table> 

			</div>
			<br class="clear" />
		</div>
	</div>
    <div id="tabs-2"></div>
</div>

