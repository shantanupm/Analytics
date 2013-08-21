<%@include file="../init.jsp" %>
<link rel="stylesheet" href="<c:url value="/css/jquery.ui.all.css"/>" />
 <link rel="stylesheet" href="<c:url value="/css/schSysStylesheet.css"/>" />

<script type="text/javascript" src="<c:url value="/js/jquery.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.maskedinput-1.3.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.core.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.widget.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.position.js"/>"></script>
<script type='text/javascript' src="<c:url value="/js/jquery.ui.autocomplete.js"/>"></script> 
<script type="text/javascript" src="<c:url value="/js/jquery.validate.js"/>"></script>



<div class="popCont popUpBig">
<h1><a class="close" title="close"></a>Add New Student</h1>
<form id="launchEvaluationForm" name="launchEvaluationForm" action="launchEvaluation.html?operation=launchEvaluationHome" method="post">
<div class="mt25">
	
    <label for="Display on" class="noti-pop-labl1">Student CRM ID: </label>
    <input type="text" value="" name="studentCrmId" class="txbx required">
    <br class="clear" />
    
    <label for="Display on" class="noti-pop-labl1">Program Version Code: </label>
    <input type="text" value="" class="txbx required" name="programVersionCode">
    
	<br class="clear" />
    
    <label for="Display on" class="noti-pop-labl1">Catalog Code:</label>
    <input type="text" value="" class="txbx required" name="catalogCode">
   
    <br class="clear" />
    
    <label for="Display on" class="noti-pop-labl1">State Code:</label>
    <input type="text" value="" id="state" class="txbx required" name="stateCode">
   
    <br class="clear" />
    
    <label for="Display on" class="noti-pop-labl1">Expected Start Date (MM/dd/yyyy):</label>
    <input type="text" class="txbx noti-pop-txbx maskDate required"  name="expectedStartDate"/>
    
   
    <br class="clear" />
    
    
        <div class="dividerPopup mt25"></div>
        <div class="btn-cnt">
            <input class="fr close" name="" type="button" value="Cancel" />
            <input class="fr" type="submit" value="ok" />
        	<div class="clear"></div>
    	</div>
	</div>
	<input type='hidden' name="role" value="Student"/>
	<input type='hidden' name="evaluatorId" value="Dummy"/>
  
</form>
</div>
 

