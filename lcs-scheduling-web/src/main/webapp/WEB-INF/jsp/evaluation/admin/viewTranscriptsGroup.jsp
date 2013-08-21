<%@include file="../../init.jsp" %>



<script>


	function showhideRows(element){
		
		if (jQuery(element).closest(".expndCols").next().is(":visible") == true) {
			jQuery(element).closest(".expndCols").next().hide()
			jQuery(element).removeClass("arrowBottom1");
			jQuery(element).attr('title','Show Details');
		}
		else {
			jQuery(element).closest(".expndCols").next().show().addClass("rowSelectedBg");
			jQuery(element).addClass("arrowBottom1");
			jQuery(element).attr('title','Hide Details');
		}	
}

</script>
<div class="deo2">
  <div style="border:1px solid #e7e7e7; border-top:none;" class="institute">
  	<div class="noti-tools2">
     <div class="fr mb10">
            <label class="captiongray floatLeft mr10 mt5"> View By:</label>
            <div class="floatLeft">
            <a href="/scheduling_system/evaluation/admin.html?operation=viewTranscripts" class="viewbyBtnleft" title="List View"></a>
            <a href="/scheduling_system/evaluation/admin.html?operation=viewTranscriptsGroup" class="viewbyBtnright1" title="Status View"></a>
            </div>
          
      </div>
        <div class="clear"></div>
   <!--  <div class="fr institutionHeader mb-15">
            <a onclick='Boxy.load("popup/addNewStudent.html",{afterShow: boxyAfterShowCall});' href="javascript:void(0)" class="mr10">
            <img src="images/addStudentIcon.png" width="17" height="17" alt="" />New Student</a>
          
      </div> -->
        <div class="clear"></div>
    <div>
    	<div class="expndCols"><a onclick="showhideRows(this)" class="leftArrowClick arrowright1 arrowBottom1"
    	 title="Show Details" href="javascript:void(0)"></a>Draft<span class="studNoti">${fn:length(sitDraftList)}</span></div>
     <table width="100%" class="noti-tbl tblBorder">
<thead>
<tr>
<th width="10%" class="dividerGrey thW10 dividerGrey order1">
<span class="sort_d"><strong>CRM Id</strong> </span></th>
<th width="60%" class="dividerGrey thW30 dividerGrey order1">
  <strong>Institution name</strong></th>
<th width="10%" class="dividerGrey thW10 dividerGrey order1">
  <strong>Type</strong></span></th>
<th width="10%" class="dividerGrey thW10"><span class="sort_d"><strong>Entry Date</strong></span></th>
<th width="10%" class="dividerGrey thW10"><span class="sort_d"><strong>Modified Date</strong></span></th></tr></thead>
<tbody>
<c:set var="crmId" value=""></c:set> 
<c:forEach items="${sitDraftList}" var="sitDraft"  varStatus="index">


<tr <c:if test="${index.index %2 eq 0 }">class="odd"</c:if>>
<td><c:if test="${crmId!= sitDraft.studentProgramEvaluation.studentId}">  ${sitDraft.studentProgramEvaluation.studentId}  </c:if></td>
<td><a href="/scheduling_system/evaluation/launchEvaluation.html?operation=getCoursesForStudentTranscript&studentInstitutionTranscriptId=${sitDraft.id}&institutionId=${sitDraft.institution.id}"> ${sitDraft.institution.name}</a></td>
<td>  <c:choose><c:when test="${sitDraft.official}">Official</c:when> <c:otherwise>UnOfficial</c:otherwise> </c:choose> </td>
<td> <fmt:formatDate pattern="MM/dd/yyyy" value="${sitDraft.createdTime}" /></td>
<td>  <fmt:formatDate pattern="MM/dd/yyyy" value="${sitDraft.modifiedTime}" /></td></tr>
<c:set var="crmId" value="${sitDraft.studentProgramEvaluation.studentId}"></c:set>
</c:forEach>


</tbody></table>
    </div>
    
    <div>
    	<div class="expndCols"><a onclick="showhideRows(this)" class="leftArrowClick arrowright1" title="Show Details" href="javascript:void(0)"></a>Awaiting IE<span class="studNoti">${fn:length(sitAwaitingIEList)}</span></div>
     <table width="100%" class="noti-tbl tblBorder" style="display:none;">
<thead>
<tr>
<th width="10%" class="dividerGrey thW10 dividerGrey order1">
<span class="sort_d"><strong>CRM Id</strong> </span></th>
<th width="60%" class="dividerGrey thW30 dividerGrey order1">
  <strong>Institution name</strong></th>
<th width="10%" class="dividerGrey thW10 dividerGrey order1">
  <strong>Type</strong></span></th>
<th width="10%" class="dividerGrey thW10"><span class="sort_d"><strong>Entry Date</strong></span></th>
<th width="10%" class="dividerGrey thW10"><span class="sort_d"><strong>Modified Date</strong></span></th></tr></thead>
<tbody>
<c:set var="crmId" value=""></c:set> 
<c:forEach items="${sitAwaitingIEList}" var="sitAwaitingIE"  varStatus="index">


<tr <c:if test="${index.index %2 eq 0 }">class="odd"</c:if>>
<td><c:if test="${crmId!= sitAwaitingIE.studentProgramEvaluation.studentId}">   ${sitAwaitingIE.studentProgramEvaluation.studentId} </c:if> </td>
<td><a href="/scheduling_system/evaluation/launchEvaluation.html?operation=getCoursesForStudentTranscript&studentInstitutionTranscriptId=${sitAwaitingIE.id}&institutionId=${sitAwaitingIE.institution.id}"> ${sitAwaitingIE.institution.name}</a></td>
<td>  <c:choose><c:when test="${sitAwaitingIE.official}">Official</c:when> <c:otherwise>UnOfficial</c:otherwise> </c:choose> </td>
<td> <fmt:formatDate pattern="MM/dd/yyyy" value="${sitAwaitingIE.createdTime}" /></td>
<td>  <fmt:formatDate pattern="MM/dd/yyyy" value="${sitAwaitingIE.modifiedTime}" /></td></tr>
<c:set var="crmId" value="${sitAwaitingIE.studentProgramEvaluation.studentId}"></c:set>
</c:forEach>

</tbody></table>
    </div>
        <div>
    	<div class="expndCols"><a onclick="showhideRows(this)" class="leftArrowClick arrowright1" 
    	title="Show Details" href="javascript:void(0)"></a>Awaiting IEM<span class="studNoti">${fn:length(sitAwaitingIEMList)}</span></div>
     <table width="100%" class="noti-tbl tblBorder" style="display:none;">
<thead>
<tr>
<th width="10%" class="dividerGrey thW10 dividerGrey order1">
<span class="sort_d"><strong>CRM Id</strong> </span></th>
<th width="60%" class="dividerGrey thW30 dividerGrey order1">
  <strong>Institution name</strong></th>
<th width="10%" class="dividerGrey thW10 dividerGrey order1">
  <strong>Type</strong></span></th>
<th width="10%" class="dividerGrey thW10"><span class="sort_d"><strong>Entry Date</strong></span></th>
<th width="10%" class="dividerGrey thW10"><span class="sort_d"><strong>Modified Date</strong></span></th></tr></thead>
<tbody>
<c:set var="crmId" value=""></c:set> 
<c:forEach items="${sitAwaitingIEMList}" var="sitAwaitingIEM"  varStatus="index">


<tr <c:if test="${index.index %2 eq 0 }">class="odd"</c:if>>
<td>  <c:if test="${crmId!= sitAwaitingIEM.studentProgramEvaluation.studentId}">${sitAwaitingIEM.studentProgramEvaluation.studentId} </c:if> </td>
<td><a href="/scheduling_system/evaluation/launchEvaluation.html?operation=getCoursesForStudentTranscript&studentInstitutionTranscriptId=${sitAwaitingIEM.id}&institutionId=${sitAwaitingIEM.institution.id}"> ${sitAwaitingIEM.institution.name}</a></td>
<td>  <c:choose><c:when test="${sitAwaitingIEM.official}">Official</c:when> <c:otherwise>UnOfficial</c:otherwise> </c:choose> </td>
<td> <fmt:formatDate pattern="MM/dd/yyyy" value="${sitAwaitingIEM.createdTime}" /></td>
<td>  <fmt:formatDate pattern="MM/dd/yyyy" value="${sitAwaitingIEM.modifiedTime}" /></td></tr>
<c:set var="crmId" value="${sitAwaitingIEM.studentProgramEvaluation.studentId}"></c:set>
</c:forEach>

</tbody></table>
    </div>
    <div>
    	<div class="expndCols"><a onclick="showhideRows(this)" class="leftArrowClick arrowright1" 
    	title="Show Details" href="javascript:void(0)"></a>Awaiting SLE<span class="studNoti">${fn:length(sitAwaitingSLEList)}</span></div>
     <table width="100%" class="noti-tbl tblBorder" style="display:none;">
<thead>
<tr>
<th width="10%" class="dividerGrey thW10 dividerGrey order1">
<span class="sort_d"><strong>CRM Id</strong> </span></th>
<th width="60%" class="dividerGrey thW30 dividerGrey order1">
  <strong>Institution name</strong></th>
<th width="10%" class="dividerGrey thW10 dividerGrey order1">
  <strong>Type</strong></span></th>
<th width="10%" class="dividerGrey thW10"><span class="sort_d"><strong>Entry Date</strong></span></th>
<th width="10%" class="dividerGrey thW10"><span class="sort_d"><strong>Modified Date</strong></span></th></tr></thead>
<tbody>
<c:set var="crmId" value=""></c:set> 
<c:forEach items="${sitAwaitingSLEList}" var="sitAwaitingSLE"  varStatus="index">


<tr <c:if test="${index.index %2 eq 0 }">class="odd"</c:if>>
<td>  <c:if test="${crmId!= sitAwaitingSLE.studentProgramEvaluation.studentId}">${sitAwaitingSLE.studentProgramEvaluation.studentId}</c:if>  </td>
<td><a href="/scheduling_system/evaluation/launchEvaluation.html?operation=getCoursesForStudentTranscript&studentInstitutionTranscriptId=${sitAwaitingSLE.id}&institutionId=${sitAwaitingSLE.institution.id}"> ${sitAwaitingSLE.institution.name}</a></td>
<td>  <c:choose><c:when test="${sitAwaitingSLE.official}">Official</c:when> <c:otherwise>UnOfficial</c:otherwise> </c:choose> </td>
<td> <fmt:formatDate pattern="MM/dd/yyyy" value="${sitAwaitingSLE.createdTime}" /></td>
<td>  <fmt:formatDate pattern="MM/dd/yyyy" value="${sitAwaitingSLE.modifiedTime}" /></td></tr>
<c:set var="crmId" value="${sitAwaitingSLE.studentProgramEvaluation.studentId}"></c:set>
</c:forEach>
</tbody></table>
    </div>
    
    <div>
    	<div class="expndCols"><a onclick="showhideRows(this)" class="leftArrowClick arrowright1" 
    	title="Show Details" href="javascript:void(0)"></a>Awaiting LOPE<span class="studNoti">${fn:length(sitAwaitingLOPEList)}</span></div>
     <table width="100%" class="noti-tbl tblBorder" style="display:none;" >
<thead>
<tr>
<th width="10%" class="dividerGrey thW10 dividerGrey order1">
<span class="sort_d"><strong>CRM Id</strong> </span></th>
<th width="60%" class="dividerGrey thW30 dividerGrey order1">
  <strong>Institution name</strong></th>
<th width="10%" class="dividerGrey thW10 dividerGrey order1">
  <strong>Type</strong></span></th>
<th width="10%" class="dividerGrey thW10"><span class="sort_d"><strong>Entry Date</strong></span></th>
<th width="10%" class="dividerGrey thW10"><span class="sort_d"><strong>Modified Date</strong></span></th></tr></thead>
<tbody>
<c:set var="crmId" value=""></c:set> 
<c:forEach items="${sitAwaitingLOPEList}" var="sitAwaitingLOPE"  varStatus="index">


<tr <c:if test="${index.index %2 eq 0 }">class="odd"</c:if>>
<td> <c:if test="${crmId!= sitAwaitingLOPE.studentProgramEvaluation.studentId}"> ${sitAwaitingLOPE.studentProgramEvaluation.studentId}</c:if>  </td>
<td><a href="/scheduling_system/evaluation/launchEvaluation.html?operation=getCoursesForStudentTranscript&studentInstitutionTranscriptId=${sitAwaitingLOPE.id}&institutionId=${sitAwaitingLOPE.institution.id}"> ${sitAwaitingLOPE.institution.name}</a></td>
<td>  <c:choose><c:when test="${sitAwaitingLOPE.official}">Official</c:when> <c:otherwise>UnOfficial</c:otherwise> </c:choose> </td>
<td> <fmt:formatDate pattern="MM/dd/yyyy" value="${sitAwaitingLOPE.createdTime}" /></td>
<td>  <fmt:formatDate pattern="MM/dd/yyyy" value="${sitAwaitingLOPE.modifiedTime}" /></td></tr>
<c:set var="crmId" value="${sitAwaitingLOPE.studentProgramEvaluation.studentId}"></c:set>
</c:forEach>
</tbody></table>
    </div>
    
    <div>
    	<div class="expndCols"><a onclick="showhideRows(this)" class="leftArrowClick arrowright1" 
    	title="Show Details" href="javascript:void(0)"></a>EVALUATED LOPE<span class="studNoti">${fn:length(sitEvaluatedLOPEList)}</span></div>
     <table width="100%" class="noti-tbl tblBorder" style="display:none;">
<thead>
<tr>
<th width="10%" class="dividerGrey thW10 dividerGrey order1">
<span class="sort_d"><strong>CRM Id</strong> </span></th>
<th width="60%" class="dividerGrey thW30 dividerGrey order1">
  <strong>Institution name</strong></th>
<th width="10%" class="dividerGrey thW10 dividerGrey order1">
  <strong>Type</strong></span></th>
<th width="10%" class="dividerGrey thW10"><span class="sort_d"><strong>Entry Date</strong></span></th>
<th width="10%" class="dividerGrey thW10"><span class="sort_d"><strong>Modified Date</strong></span></th></tr></thead>
<tbody>
<c:set var="crmId" value=""></c:set> 
<c:forEach items="${sitEvaluatedLOPEList}" var="sitEvaluatedLOPE"  varStatus="index">


<tr <c:if test="${index.index %2 eq 0 }">class="odd"</c:if>>
<td>  <c:if test="${crmId!= sitEvaluatedLOPE.studentProgramEvaluation.studentId}">${sitEvaluatedLOPE.studentProgramEvaluation.studentId} </c:if> </td>
<td><a href="/scheduling_system/evaluation/launchEvaluation.html?operation=getCoursesForStudentTranscript&studentInstitutionTranscriptId=${sitEvaluatedLOPE.id}&institutionId=${sitEvaluatedLOPE.institution.id}"> ${sitEvaluatedLOPE.institution.name}</a></td>
<td>  <c:choose><c:when test="${sitEvaluatedLOPE.official}">Official</c:when> <c:otherwise>UnOfficial</c:otherwise> </c:choose> </td>
<td> <fmt:formatDate pattern="MM/dd/yyyy" value="${sitEvaluatedLOPE.createdTime}" /></td>
<td>  <fmt:formatDate pattern="MM/dd/yyyy" value="${sitEvaluatedLOPE.modifiedTime}" /></td></tr>
<c:set var="crmId" value="${sitEvaluatedLOPE.studentProgramEvaluation.studentId}"></c:set>
</c:forEach>
</tbody></table>
    </div>
    
    
    <div>
    	<div class="expndCols"><a onclick="showhideRows(this)" class="leftArrowClick arrowright1" 
    	title="Show Details" href="javascript:void(0)"></a>EVALUATED OFFICIAL<span class="studNoti">${fn:length(sitEvaluatedOfficialList)}</span></div>
     <table width="100%" class="noti-tbl tblBorder" style="display:none;">
<thead>
<tr>
<th width="10%" class="dividerGrey thW10 dividerGrey order1">
<span class="sort_d"><strong>CRM Id</strong> </span></th>
<th width="60%" class="dividerGrey thW30 dividerGrey order1">
  <strong>Institution name</strong></th>
<th width="10%" class="dividerGrey thW10 dividerGrey order1">
  <strong>Type</strong></span></th>
<th width="10%" class="dividerGrey thW10"><span class="sort_d"><strong>Entry Date</strong></span></th>
<th width="10%" class="dividerGrey thW10"><span class="sort_d"><strong>Modified Date</strong></span></th></tr></thead>
<tbody>
<c:set var="crmId" value=""></c:set> 
<c:forEach items="${sitEvaluatedOfficialList}" var="sitEvaluatedOfficial"  varStatus="index">


<tr <c:if test="${index.index %2 eq 0 }">class="odd"</c:if>>
<td>  <c:if test="${crmId!= sitEvaluatedOfficial.studentProgramEvaluation.studentId}">${sitEvaluatedOfficial.studentProgramEvaluation.studentId}</c:if>  </td>
<td><a href="/scheduling_system/evaluation/launchEvaluation.html?operation=getCoursesForStudentTranscript&studentInstitutionTranscriptId=${sitEvaluatedOfficial.id}&institutionId=${sitEvaluatedOfficial.institution.id}"> ${sitEvaluatedOfficial.institution.name}</a></td>
<td>  <c:choose><c:when test="${sitEvaluatedOfficial.official}">Official</c:when> <c:otherwise>UnOfficial</c:otherwise> </c:choose> </td>
<td> <fmt:formatDate pattern="MM/dd/yyyy" value="${sitEvaluatedOfficial.createdTime}" /></td>
<td>  <fmt:formatDate pattern="MM/dd/yyyy" value="${sitEvaluatedOfficial.modifiedTime}" /></td></tr>
<c:set var="crmId" value="${sitEvaluatedOfficial.studentProgramEvaluation.studentId}"></c:set>
</c:forEach>
</tbody></table>
    </div>
    
    
    
  
    </div>
  </div>
    
 
    </div>