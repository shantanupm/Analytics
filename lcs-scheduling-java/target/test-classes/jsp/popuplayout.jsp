<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@include file="init.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
  <head>
  	 <script type="text/javascript" src="<c:url value='/js/jquery-1.8.0.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value="/js/jquery-ui-1.9.0.js"/>" ></script> 
    
     <script type='text/javascript' src="<c:url value="/js/jquery.validate.js"/>"></script>
     <script type='text/javascript' src="<c:url value="/js/expand.js"/>"></script>
     <script type='text/javascript' src="<c:url value="/js/jquery.maskedinput-1.3.js"/>"></script>
     <script type='text/javascript' src="<c:url value="/js/dateValidation.js"/>"></script>
     <script type="text/javascript" src="<c:url value="/js/jquery.boxy.js"/>"></script>
     <script type="text/javascript">
    	 jQuery.noConflict();
  	 </script>
  	 
  	 <link rel="stylesheet" href="<c:url value="/css/schSysStylesheet.css"/>" /> 
    <link rel="stylesheet" href="<c:url value="/css/boxy.css"/>" />
    <link rel="stylesheet" media="screen" href="<c:url value="/css/jquery-ui-1.8.23.custom.css"/>" />
	<link rel="stylesheet" media="screen" href="<c:url value="/css/style.css"/>" />
	
     <link rel="stylesheet" href="<c:url value="/css/boxypopupscrollfix.css"/>" />
   
  </head>
  <body>    
		<tiles:insertAttribute name="body" />       
  </body>
</html>