<%@include file="../init.jsp" %>



<link rel="stylesheet" media="screen" href="<c:url value="/css/jquery.ui.autocomplete.css"/>" />

<script type="text/javascript" src="<c:url value="/js/jquery.js"/>"></script>     
<script type='text/javascript' src="<c:url value="/js/jquery.ui.core.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.widget.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.position.js"/>"></script>

 <script type='text/javascript' src="<c:url value="/js/jquery-ui-1.8.23.custom.min.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.autocomplete.js"/>"></script>    
<script type="text/javascript" src="<c:url value="/js/jquery.validate.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.maskedinput-1.3.js"/>"></script>



<c:choose>
     	<c:when test="${role=='MANAGER'}"> 
     		<c:set var="institutionDetail" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=createInstitution&institutionId=${institutionId}"/>
        	<c:set var="actionLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=ieSaveInstitution"/>
        	<c:set var="aBodyLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=manageAccreditingBody&institutionId=${institutionId}"/>
 			<c:set var="termTypeLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=manageInstitutionTermType&institutionId=${institutionId}"/>
 			<c:set var="transcriptKeyLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=manageInstitutionTranscriptKey&institutionId=${institutionId}"/>
 			<c:set var="aAgreementLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=manageArticulationAgreement&institutionId=${institutionId}"/>
 			<c:set var="markCompleteLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=summaryInstitution&institutionId=${institutionId}"/>
	 	</c:when>
 		<c:otherwise>
 			<c:set var="institutionDetail" scope="session" value="/scheduling_system/evaluation/quality.html?operation=ieInstitution&institutionId=${institutionId}"/>
 			<c:set var="actionLink" scope="session" value="/scheduling_system/evaluation/quality.html?operation=ieSaveInstitution"/>
 		</c:otherwise>
 	</c:choose> 
 			<c:set var="aBodyLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=manageAccreditingBody&institutionId=${institutionId}"/>
 			<c:set var="termTypeLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=manageInstitutionTermType&institutionId=${institutionId}"/>
 			<c:set var="transcriptKeyLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=manageInstitutionTranscriptKey&institutionId=${institutionId}"/>
 			<c:set var="aAgreementLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=manageArticulationAgreement&institutionId=${institutionId}"/>
 			<c:set var="markCompleteLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=summaryInstitution&institutionId=${institutionId}"/>
	 	
 	
   <div>
  	
 		<c:choose>
	                	<c:when test="${tabIndex=='1'}">
	                		<%@include file="institutionEvaluate.jsp" %>
	                	</c:when>
	                	<c:when test="${tabIndex=='2'}">
	                		<%@include file="ieManageAccreditingBody.jsp" %>
	                	</c:when>
	                	<c:when test="${tabIndex=='3'}">
	                		<%@include file="ieManageInstitutionTermType.jsp" %>
	                	</c:when>
	                	<c:when test="${tabIndex=='4'}">
	                		<%@include file="ieManageInstitutionTranscriptKey.jsp" %>
	                	</c:when>
	                	<c:when test="${tabIndex=='5'}">
	                		<%@include file="ieManageArticulationAgreement.jsp" %>
	                	</c:when>
	                	<c:when test="${tabIndex=='6'}">
	                		<%@include file="ieMarkCompletePreview.jsp" %>
	                	</c:when>
	                	
                	</c:choose>
 	
 	</div>
 