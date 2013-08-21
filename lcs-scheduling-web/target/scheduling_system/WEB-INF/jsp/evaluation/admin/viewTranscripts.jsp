<%@include file="../../init.jsp" %>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>
<script type='text/javascript' src="<c:url value="/js/jquery-1.8.0.min.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery-ui-1.8.23.custom.min.js"/>"></script>

<script>
jQuery(document).ready(function(){
		
	
	jQuery("#status").val('${status}');
	
	jQuery("#status").change(function(){
		window.location.href='admin.html?operation=viewTranscripts&status='+jQuery(this).val();
	});
	
	jQuery("#searchTranscript").click(function(){
		window.location.href='admin.html?operation=viewTranscripts&crmId='+jQuery("#searchText").val();
	});
	
	jQuery("#resetSearch").click(function(){
		jQuery("#searchText").val("");
		window.location.href='admin.html?operation=viewTranscripts';
	});
});
function getByStatus(statusValue){
	window.location.href='admin.html?operation=viewTranscripts&status='+jQuery(statusValue).attr('val');

}
function selectAnotherStudent(){
	Boxy.load("<c:url value='launchEvaluation.html?operation=newStudent'/>",
		{ unloadOnHide : true, 
		afterShow : function() {
			var stateList = new Array("","AK","AL","AR","AS","AZ","CA","CO","CT","DC","DE","FL","GA","GU","HI","IA","ID",
					"IL","IN","KS","KY","LA","MA","MD","ME","MH","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY",
					"OH","OK","OR","PA","PR","PW","RI","SC","SD","TN","TX","UT","VA","VI","VT","WA","WI","WV","WY");

				  jQuery("#state").autocomplete({source: stateList});
				  jQuery(function($){
						$.mask.definitions['d']='[0123]';
						$.mask.definitions['m']='[01]';
						$.mask.definitions['y']='[12]';
						$(".maskDate").mask("m9/d9/y999" );
				  })
				  jQuery("#launchEvaluationForm").validate();
		}
		});
}
</script>


		<div class="noti-bordr">
    		<div class="noti-tools">
    		   <div class="fr mb10">
		            <label class="captiongray floatLeft mr10 mt5"> View By:</label>
		            <div class="floatLeft">
		            <a href="/scheduling_system/evaluation/admin.html?operation=viewTranscripts" class="viewbyBtnleft1" title="List View"></a>
		            <a href="/scheduling_system/evaluation/admin.html?operation=viewTranscriptsGroup" class="viewbyBtnright" title="Status View"></a>
		            </div>
		          
		      </div>
		     
           		<div class="fl">
           			<!-- <label class="noti-label" for="View by">Status:</label>
					<select class="frm-stxbx" id="status" name="status">
               			<option value="">ALL</option>
                		<option value="AWAITING IE">AWAITING IE</option>
						<option value="AWAITING IEM">AWAITING IEM</option>
						<option value="AWAITING LOPE">AWAITING LOPE</option>
						<option value="DRAFT">DRAFT</option>
						<option value="EVALUATED LOPE">EVALUATED LOPE</option>
	
					</select> -->
					 <span class="fl"> <label class="noti-label noti-mrgl">Search by CRM ID:</label>
                <input type="text" id="searchText" class="txbx noti-txbx hasDatepicker" name="searchText">
                   
                </span>
                <span>
                    <input type="button" value="Search" id="searchTranscript" name="searchCourse">
                    <input type="button" value="Reset"  id="resetSearch" name="resetSearch">
                </span>
                <br class="clear">
				</div>
				<br class="clear">
				<div class="clear"></div>
				 <div class="fr institutionHeader mb-15" style="margin-right: -8px;padding-bottom: 10px;">
		            <a class="mr10" id="newStudent" href="javascript:void(0)" onclick="selectAnotherStudent();">
		            <img width="17" height="17" alt="" src="../images/addStudentIcon.png">New Student</a>
		          
		      </div> 
		      <br class="clear">
		      <br class="clear">
		      <div class="clear"></div>
		      <br class="clear">
			</div>
        
	<display:table name="sitList" class="noti-tbl" id="sit" pagesize="10"   requestURI="admin.html" export="false" sort="list">  
	 
	 <display:column  title="<span class='sort_d'>CRM Id </span>" sortable="true" group="2" headerClass="dividerGrey thW10" >
		   ${sit.studentProgramEvaluation.studentId} 
	   </display:column>	 
	 <display:column  title="<span class='sort_d'>Institution name</span>" sortable="true" sortProperty="institution.name" headerClass="dividerGrey thW30" >
		  <a href='/scheduling_system/evaluation/launchEvaluation.html?operation=getCoursesForStudentTranscript&studentInstitutionTranscriptId=${sit.id}&institutionId=${sit.institution.id}'> ${sit.institution.name}</a>
	   </display:column>
	   <display:column  title="<dl class='dropdown dropdown1 filterSeletect3' id='status'>
		    <dt><a title='Status' href='javascript:void(0);'>Evaluation Status </a></dt>
		         <dd>
		             <ul id='status' style='width: 160px; display: none;'>
		                <li><a onclick='javscript:getByStatus(this);' val='' href='javascript:void(0);'><span class='' >All </span></a></li>
		                <li><a onclick='javscript:getByStatus(this);' val='AWAITING IE' href='javascript:void(0)'><span class='smalAsignmentIcon'>AWAITING IE</span></a></li>
						<li><a onclick='javscript:getByStatus(this);' val='AWAITING IEM' href='javascript:void(0)'><span class='smalQuizIcon'>AWAITING IEM</span></a></li>
						<li><a onclick='javscript:getByStatus(this);' val='DRAFT' href='javascript:void(0)'><span class='smalForumIcon'>DRAFT</span></a></li>
						<li><a onclick='javscript:getByStatus(this);' val='AWAITING LOPE' href='javascript:void(0)'><span class='smalForumIcon'>AWAITING LOPE</span></a></li>
						<li><a onclick='javscript:getByStatus(this);' val='EVALUATED LOPE' href='javascript:void(0)'><span class='smalForumIcon'>EVALUATED LOPE</span></a></li>
						<li><a onclick='javscript:getByStatus(this);' val='AWAITING SLE' href='javascript:void(0)'><span class='smalForumIcon'>AWAITING SLE</span></a></li>
						<li><a onclick='javscript:getByStatus(this);' val='EVALUATED OFFICIAL' href='javascript:void(0)'><span class='smalForumIcon'>EVALUATED OFFICIAL</span></a></li>
						
					</ul>
		         </dd>
	  </dl>"  headerClass="dividerGrey thW20" >
		   ${sit.evaluationStatus}
	   </display:column>
	  
	   <display:column  title="<span class='sort_d'>Type</span>" sortable="true" headerClass="dividerGrey thW10" >
		   <c:choose><c:when test="${sit.official}">Official</c:when> <c:otherwise>UnOfficial</c:otherwise> </c:choose> 
	   </display:column>
	   <display:column  title="Entry Date"  headerClass="dividerGrey thW10" >
		   <fmt:formatDate pattern="MM/dd/yyyy" value="${sit.createdDate}" />
	   </display:column>
	 <display:column  title="Modified Date"  headerClass="dividerGrey thW10" >
		   <fmt:formatDate pattern="MM/dd/yyyy" value="${sit.modifiedDate}" />
	   </display:column>
	 
	<%--  <display:column property="id" title="View Details"  headerClass="dividerGrey"  
	 format="<a href='/scheduling_system/evaluation/studentEvaluator.html?operation=getCoursesForStudentTranscript&studentInstitutionTranscriptId='{0}'&institutionId=${sit.institution.id}' > 
	 <img src='/scheduling_system/images/viewIcon.png' width='15' height='15' alt='View' />View</a>
	 <a href='/scheduling_system/evaluation/launchEvaluation.html?operation=getCoursesForStudentTranscript&studentInstitutionTranscriptId=${sit.id}&institutionId=${sit.institution.id}'> Add Transcripts</a> "/>
	  --%>
	</display:table> 

     <br class="clear">
    </div>
	

        
        
        


<!-- 

<center>
<div class="tblFormDiv divCover outLine"  >
All Transcripts List <br><br>
Total : ${fn:length(sitList)} 
<div class="innerDiv" >   
 
 
 
	<table width="100%"  cellspacing="1"  border="1" style="border-collapse: collapse;" cellpadding="0" class="">
		<tr>
    	  	<th class="heading">&nbsp;Sr.No</th>
	  		<th class="heading">&nbsp;Institution name</th>
	  		<th class="heading">&nbsp;Evaluation Status</th>
			<th class="heading">&nbsp;CRM Id</th>
	  		<th class="heading">&nbsp;Type</th>
	  		<th class = "heading">&nbsp;View Details</th>
    	</tr>
    	<c:set var="estatus" value=""></c:set> 
    	<c:forEach items="${sitList}" var="sit" varStatus="index">
    	
    	<c:if test="${estatus!= sit.evaluationStatus}">
    	
	    	<tr>
	    		<td  colspan="5">&nbsp;${sit.evaluationStatus}
	    	</tr>
			<c:set var="count" value="1"></c:set>    	
    	</c:if>
    		<tr>
    		<td align="left" valign="top" class="table-content">${count}</td>
    		<td align="left" valign="top" class="table-content">${sit.institution.name}</td>
    		<td align="left" valign="top" class="table-content">${sit.evaluationStatus}</td>
			<td align="left" valign="top" class="table-content">${sit.studentProgramEvaluation.studentId}</td>
    		<td align="left" valign="top" class="table-content"><c:choose><c:when test="${sit.official}">Official</c:when> <c:otherwise>UnOfficial</c:otherwise> </c:choose> </td>
    		<td width="20%" align="center" valign="middle" ><a href="/scheduling_system/evaluation/studentEvaluator.html?operation=getCoursesForStudentTranscript&studentInstitutionTranscriptId=${sit.id}&institutionId=${sit.institution.id}">View</a></td>
    		</tr>
    		
    		<c:set var="estatus" value="${sit.evaluationStatus}"></c:set>
    		<c:set var="count" value="${count+1}"></c:set>
    	</c:forEach>
	</table>
</div>
<a href="/scheduling_system/evaluation/admin.html?operation=adminView">Home Page</a>
</div>
</center>
 -->