<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@include file="init.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
  <head>
    <title><tiles:getAsString name="title"/></title>
    <LINK REL="SHORTCUT ICON" href="<c:url value="/images/LCS.ico"/>">
	<meta http-equiv="X-UA-Compatible" content="IE=8" />
     
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
  	 
	 <script type="text/javascript">
	 
	 	var urlPatname = location.href;
	 	var mappingPath = urlPatname.split("/scheduling_system/");
	 	var mappingUrlString = mappingPath[1].split("?");
	 	var mappingString = mappingUrlString[0];
	 	<c:set var="myParams">
	 		<c:forEach items="${param}" var="urlKey">${urlKey.key}=${urlKey.value}&</c:forEach>
	 	</c:set>
	 	var saveLinkParams = '<c:out value="${myParams}" escapeXml="true"/>';
	 	var linkUrl = mappingString + "?" + saveLinkParams;



		//lcsIframeObj creation
		jQuery(document).ready(function(){
	 		lcsIFrameObj = new lcsIFrame();	 	
	 		jQuery('.backlink').click(function() {
	 			history.back()
	 		});	
	 		
	 		/*Filter Tooltip popup*/
	 		jQuery(".filterType").click(function() {
				jQuery(this).find('ul').toggle();
			});

			 jQuery(".filterType dd ul li").click(function(e) {
				jQuery(this).closest('ul').hide();
				if(jQuery(this).find('a span').html()=='All'){
					jQuery(this).closest('.filterType').removeClass("filterSeletect");		
				}else{
					jQuery(this).closest('.filterType').addClass("filterSeletect");
				}
				e.stopPropagation();
			});
		});
	 	function lcsIFrame(){
			this.timerId;
			this.body =jQuery("html>body");
			this.openBoxyCount = 0;
			this.incrementOpenBoxyCount = function(){
				this.openBoxyCount++;
			}
			this.decrementOpenBoxyCount = function(){
				this.openBoxyCount--;
			}
			this.getOpenBoxyCount = function(){
				return this.openBoxyCount;
			}
			
			this.updateIframeHeight = function(){
				if(jQuery(this.body)){
					this.setIframeHeight(jQuery(this.body).height());
				}else{
					this.setIframeHeight(480);
				}
			}
			this.increaseIframeHeight= function(incriment){
				this.setIframeHeight(jQuery(this.body).height()+incriment);
			}
			this.increaseIframeHeightByIncrement = function( increment ) {
				if( jQuery(this.body) ){
					this.setIframeHeight( jQuery(this.body).height() + increment );
				}
			}
			this.setIframeHeight = function(height){
			} 
			this.setUpdateFrequency =function(millis){
				this.updateIframeHeight();				
			}
			this.cancelTimer = function(){
				if(this.timerId){
					clearInterval(this.timerId);
					this.timerId=null;
				}
			}
			this.getHeight = function(){
				return jQuery(this.body).height();
			}
			this.scrollMainPage = function(offset){
			}
			this.setCourseTitle=function(){
				jQuery("#lcsCourseTopicTitle").remove();
			}
			
		}
		var lcsIFrameObj;		


	
			
	
		settingMaskInput();
		
		//For Masking the field give the class name of field as below
		function settingMaskInput(){
			jQuery(function($){
				$.mask.definitions['d']='[0123]';
				$.mask.definitions['m']='[01]';
				$.mask.definitions['y']='[12]';
				$(".maskDate").mask("m9/d9/y999" );
				$(".maskYear").mask("y999");
				$(".phone").mask("(999) 999-9999"); //same for Fax
				$(".zipCode").mask("99999-9999");
				$(".tollFree").mask("1-9999999999"); //Toll-Free
				$(".maskEndDate").mask("m9/d9/y999" );
			});

			jQuery(".maskDate").blur(function() {
				if(jQuery(this).val()!=''){
					if (jQuery(this).val().length=0 && !isDate(jQuery(this).val())) {
						alert('Invalid date format!'+ jQuery(this).val().length);
						jQuery(this).val("");
					}
				}
			});
			jQuery(".maskEndDate").blur(function() {
				if(jQuery(this).val()!=''){
					if (jQuery(this).val().length=0 && !isDate(jQuery(this).val())) {
						alert('Invalid date format!');
						jQuery(this).val("");
					}
				}
			});
		}
		
		
    </script>


    <link rel="stylesheet" href="<c:url value="/css/boxy.css"/>" />
    <link rel="stylesheet" media="screen" href="<c:url value="/css/jquery-ui-1.8.23.custom.css"/>" />
	<link rel="stylesheet" media="screen" href="<c:url value="/css/style.css"/>" />
	
    <style type="text/css">
    	
    </style>
    
  </head>
  <body> 
  <div class="wrapper">
 	<c:choose> 
 	<c:when test="${param.evaluator eq 'true'}">
	 	<div class="floatRight">
	    	<div class="">
	        	<a href="#" onclick="window.close()">Close Record</a>
	        </div>
	         <div class="clear"></div>
	    </div>
 	 </c:when>
 	 <c:otherwise>
 	 	<jsp:include page="header.jsp" />
 	 	<jsp:include page="navigation.jsp" />
 	 
 	 </c:otherwise>	
 	 </c:choose>
	  	<div class="fixColMast" style="margin-bottom:50px">
	  		<tiles:insertAttribute name="body" /> 
	  		<input type="hidden" name="saveLinkParams" id="saveLinkParamsInput" value="<c:out value="${myParams}" escapeXml="true"/>"/>		
	 	</div>
	 	<jsp:include page="footer.jsp" />
 	</div>
  </body>
</html>