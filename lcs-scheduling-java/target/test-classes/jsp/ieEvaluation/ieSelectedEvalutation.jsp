<%@include file="../init.jsp" %> 
<script type="text/javascript">
jQuery(document).ready(function(){


	if('${institution.evaluationStatus}'.toLowerCase()=='EVALUATED'.toLowerCase() || '${institutionMirror.evaluationStatus}'.toLowerCase()=='COMPLETED'.toLowerCase()){
		jQuery('.institutionEvlClass').hide();
		jQuery('.courseEvlClass').show();
		jQuery('#markComplete').hide();
		jQuery('.courseEvaluation').show();
	}else{
		jQuery('.courseEvaluation').hide();
		jQuery('.institutionEvlClass').show();
		if('${institutionMirror.id}'!=''){
			jQuery('.courseEvlClass').show();
			jQuery('#markComplete').show();			
		}else{
			jQuery('.courseEvlClass').hide();
			jQuery('#markComplete').hide();
		}
	
	}
});
</script>
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
      <tr>
        <td width="10%"><span>${transferCourse.trCourseCode}</span></td>
        <td width="50%"> ${transferCourse.trCourseTitle}</td>
        <td width="40%"><a class="courseEvaluation" href="/scheduling_system/evaluation/quality.html?operation=ieCourse&institutionMirrorId=${institutionMirror.id}&transferCourseId=${transferCourse.id}">Evaluate</a></td>
        </tr>
		 </c:forEach>
      <tr>
      	<td colspan="2" class="noBorder">&nbsp;</td>
      </tr>
      </tbody>
    </table>
    </div>
</div>
<br class="clear" />
