<%@include file="../init.jsp" %>
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
//	jQuery('#tabs').tabs({ selected: 2 });		
	
	jQuery("#status").val('${status}');
	jQuery("#searchBy").val('${searchBy}');
	jQuery("#searchText").val('${searchText}');
	
	jQuery("#status").change(function(){
		window.location.href='ieManager.html?operation=getInstitutionList&status='+jQuery(this).val();
	});
	
	jQuery("#resetSearch").click(function(){
		jQuery("#searchBy").val("2");
		jQuery("#searchText").val("");
		jQuery("#status").val("ALL");
		window.location.href='ieManager.html?operation=getInstitutionList';
	});
	
	jQuery("#searchCourse").click(function(){
		window.location.href='ieManager.html?operation=getInstitutionList&searchBy='+jQuery("#searchBy").val()+'&searchText='+jQuery("#searchText").val()+'&status='+jQuery("#status").val();
	});
	
	jQuery('#searchText').keypress(function(e) {
		 var code = (e.keyCode ? e.keyCode : e.which);
		 if(code == 13) { //Enter keycode
		   window.location.href='ieManager.html?operation=getInstitutionList&searchBy='+jQuery("#searchBy").val()+'&searchText='+jQuery("#searchText").val()+'&status='+jQuery("#status").val();	 	
		 }
		 
	});
  

	jQuery( "#searchText" ).autocomplete({
		//source: availableTags,
		
		source: function( request, response ) {
			if (jQuery("#searchBy").val()==2 ){
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
					}else if (jQuery("#searchBy").val()==2){
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
		}
	},
	
	minLength: 2,
	 search: function(event, ui) { if (jQuery("#searchBy").val()==2){jQuery(this).addClass("auto-load"); }},
	  open: function(event, ui) { jQuery(this).removeClass("auto-load"); }
	  
	
	});
});

function getAssignees(institutionId) {
	
	var url="<c:url value='ieManager.html?operation=getInstitutionAssignDetails&institutionId="+institutionId+"'/>";
	
	Boxy.load(url,
	{ unloadOnHide : true	
	});
	
	
}
function getByStatus(statusValue){
	window.location.href='ieManager.html?operation=getInstitutionList&status='+jQuery(statusValue).attr('val');
	
}
</script>


 <div class="stateCollege">
            <div>
           
            <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" class="mb10">
              <tr>
              <td align="left" valign="top">
                	<div style="border:1px solid #e7e7e7; border-top:none;">
 <div class="noti-bordr">
 <div class="institutionHeader">
                	<a class="fr" href="<c:url value="ieManager.html?operation=createInstitution"/>"> <img src="../images/institutionIcon.png" width="12" height="12" alt="" />Create Institution</a>
                <br class="clear"></div><br class="clear">
            <div class="noti-tools">
                <div class="mt10">
                <label class="noti-label" for="View by">Search By:</label>
                    <select class="frm-stxbx" id="searchBy" name="searchBy">
                      <option value="1">Institution Id</option>
                      <option value="2">Institution Name</option>                      
                       
                    </select>
                <span class="fl"> 
                	<input type="text" id="searchText" class="txbx noti-txbx " name="searchText">
                    
                </span>
                <span style="margin-left: 4px;">
                    <input type="button" value="Go" id="searchCourse" name="searchCourse">
                    <input type="button" value="Reset" id="resetSearch" name="resetSearch">
                </span>
                <div class="fr orgColorbackground">
                <span> <label class="noti-label noti-mrgl">Re-assignable</label>  <span style="margin-top:-3px" class="notification">${reassignableCount }</span>                  
                </span></div>
                <br class="clear">
                </div><br class="clear">
                
            </div>
            
			 <display:table name="institutionList" class="noti-tbl" id="inst" pagesize="10"   requestURI="ieManager.html" export="false" sort="list">  
				<%-- <display:column title="Institution Id"  headerClass=" thW08"  value=" ${inst.institutionID}"/> --%> 
			 	  <display:column  title="<span class='sort_d'>Institution Id</span>" sortable="true"  headerClass="dividerGrey thW13" >
					   ${inst.institutionID}
				   </display:column>
				    
				  <display:column  title="<span class='sort_d'>Institution Name</span>" sortable="true" headerClass="dividerGrey p05 " >
					   <a href="<c:url value="ieManager.html?operation=createInstitution&institutionId=${inst.id}"/>">${inst.name}</a> 
				   </display:column>
				   <display:column  title="<dl class='dropdown dropdown1 filterSeletect3 filterType' id='status'>
					    <dt><a title='Status' href='javascript:void(0);'>Status </a></dt>
					         <dd>
					             <ul id='status' style='width: 160px; '>
					                <li><a onclick='javscript:getByStatus(this);' val='ALL' href='javascript:void(0);'><span class='' >ALL </span></a></li>
					                <li><a onclick='javscript:getByStatus(this);' val='Evaluated' href='javascript:void(0)'><span class='smalAsignmentIcon'>EVALUATED</span></a></li>
									<li><a onclick='javscript:getByStatus(this);' val='Not Evaluated' href='javascript:void(0)'><span class='smalQuizIcon'>NOT EVALUATED</span></a></li>
									
								</ul>
					         </dd>
				  </dl>" sortable="false"  headerClass="dividerGrey thW13" >
				    ${fn:toUpperCase(inst.evaluationStatus)}
					   <c:choose>
					  		 <c:when test="${inst.reassignable && userRoleName eq  'Institution Evaluator Manager'}">
							   		&nbsp;<a href="javascript:void(0)" onclick="getAssignees('${inst.id}');">(Re-assignable)</a>
							   </c:when>
							   <c:when test="${inst.evaluationStatus eq 'CONFLICT' && userRoleName ne 'Institution Evaluator Manager'}">
							   		&nbsp;<a href="/scheduling_system/evaluation/ieManager.html?operation=conflictInstitution&institutionId=${inst.id}">(Resolve)</a>
							   </c:when>
							   
						</c:choose>
				   </display:column>
		
				   <display:column  title="<span class='sort_d'>Evaluator</span>" sortable="false"  headerClass="dividerGrey thW13" >
				   		 ${inst.evaluator1.userName}    ${inst.evaluator2.userName}
				  </display:column>
				  <display:column   property="modifiedDate" format="{0,date,MM/dd/yyyy}" title="<span class='sort_d' >
	   					Modified Date</span>"  sortable="true" headerClass="dividerGrey thW13" />
				   
				
			</display:table> 
			
         
        </div>
        
        
        
        <br class="clear" />
</div>
	</div>
                  	
                </td>
              </tr>
            </table>
			
        </div>

</div>

