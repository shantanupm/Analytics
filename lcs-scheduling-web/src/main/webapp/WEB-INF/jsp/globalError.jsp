<%@page import="com.ss.common.logging.RequestContext"%>
<%@include file="init.jsp" %>
<%@page isErrorPage="true" %>
<link rel="stylesheet" media="screen" href="<c:url value="/css/style.css"/>" />
<script type="text/javascript" src="<c:url value="/js/jquery-1.8.0.min.js"/>"></script>

<script type="text/javascript">
function goBack()
{
window.history.back()
}
</script>
<%
	try{
	System.out.println(exception);
exception.printStackTrace();
	}catch(Exception e){
		e.printStackTrace();
	}
%>
<jsp:include page="header.jsp" />
 	 	<jsp:include page="navigation.jsp" />
<!-- <div class="mainColumn"> -->

<div class="deo2">
  <div style="border:1px solid #e7e7e7; border-top:none;" class="institute">
  	<div class="noti-tools2">
  	  
     <div class="errorMsgBox">
     <div class="errorMessageDv errorMsgIcon">An error has occurred, please contact technical support for assistance.</div>
     
     <div class="refranceDV">Reference No.: <%=RequestContext.getRequestIdFromContext() %></div>
     <div class="fr">
		<input type="button" name="Back" value="Back" id="Back" class="button"  onclick="goBack()">
        
		</div>
        <div class="clear"></div>
     </div>
  	</div>
      
    </div>
  </div>



    	
    