<%@include file="../init.jsp" %>


<link rel="stylesheet" href="<c:url value="/css/jquery.ui.all.css"/>" />
<link rel="stylesheet" media="screen" href="<c:url value="/css/jquery.ui.autocomplete.css"/>" />
<script type="text/javascript" src="<c:url value="/js/jquery.flot.js"/>"></script>
<!--[if lte IE 8]><script language="javascript" type="text/javascript" src="<c:url value="/js/excanvas.min.js"/>"></script><![endif]-->

<script type="text/javascript" src="<c:url value="/js/jquery.blockUI.js"/>"></script>

<script type="text/javascript">
window.onload = (function () {
	jQuery(document).ready(function () {
		jQuery('#searchResult').hide();
		jQuery('#srcDetail').click(function(){
			getSearchResults(jQuery("#crmId").val(),jQuery("#campusVueId").val(),jQuery("#firstName").val(),jQuery("#lastName").val(),jQuery("#maidenName").val(),jQuery("#dateOfBirth").val(),jQuery("#ssn1").val()+jQuery("#ssn2").val()+jQuery("#ssn3").val(),jQuery("#city").val(),jQuery("#state").val());
 			jQuery('#searchResult').show();
			jQuery('#searchBy').hide();
			});
		jQuery('#ReSetbtn').click(function(){
				jQuery('#searchBy').show();
				jQuery('#searchResult').hide();			
			});
		jQuery('#EditBtn').click(function(){
				jQuery('#searchBy').show();
				jQuery('#searchResult').hide();
			});
			
		jQuery('#srcReset').click(function(){
		    jQuery('#srchFrm').each(function(){
        		this.reset();
    		});
		});
			jQuery("h1.expand").toggler(); 
		    jQuery("#divContBoxLft").expandAll({trigger: "h1.expand"});
			jQuery("#divContBoxRgt").expandAll({trigger: "h1.expand"});
			jQuery('.collapse:first').show();
			jQuery('h1.expand:first a:first').addClass("open"); 
		
			jQuery('#rejTrans').click(function()
				{
					jQuery('#rejected').slideDown(500);
				})
				
			jQuery('#miniMize').click(function()
				{
					jQuery('#rejected').slideUp(500);
				})
			/*--------CHart-----------------------*/
			var d2 = [];

		    var ticksArray=[];
		    var totalBars = ${fn:length(chartValues)};
			
			var j=0;
			 <c:forEach items="${chartValues}" var="chartValue" varStatus="index">
			 
			 var xVal = '${chartValue.xValue}';
		        d2.push([j, ${chartValue.yValue}]);
		        ticksArray.push([j,xVal]);
				j++;
		     </c:forEach>
		   
		    var yFormatter = function formatter(val, axis) {
		                        return  val;
		                     }
		
							 
			var data = [
		        {
		        	color:'#0287ca',
		        	data: d2,
		            lines: { show: true},
		            points: { show: true },
		            label:''
		           
		        }
		    ]
			
			var chartOptions = {
		        legend: {show:false},
		        grid: { hoverable: true, clickable: true, autoHighlight:true, aboveData:false,color:"#999999"},
		        xaxis: {color:'#000000',axisLabel: 'Months', axisLabelUseCanvas: false, tickDecimals: 0, reserveSpace: 20, tickSize: 1,  max: totalBars-1, ticks:ticksArray},
		        yaxis: {color:'#000000',axisLabel: 'No. of Transcripts',axisLabelUseCanvas: false,tickDecimals: 0,tickFormatter:yFormatter,labelWidth:15}
		      }
		                        
		    var plot = jQuery.plot(jQuery("#placeholder"), data, chartOptions);
		    
		    
			jQuery("#placeholder").bind("plothover", function (event, pos, item) {
				if(item && !plot.selectionActive){
					jQuery("#x").text(pos.x.toFixed(2));
					jQuery("#y").text(pos.y.toFixed(2));
		
						jQuery("#tooltip").remove();
						var x = item.datapoint[0],
							y = item.datapoint[1];
							
						var datapointValue=item.datapoint[1]-item.datapoint[2];
						
						showTooltip(item.mouseX+5, item.mouseY,
									item.series.label+
									"<br /> " + item.series.xaxis.ticks[x].label 
									+"<br />Transcripts Done: " + y);				
				}
				
				if(!item){
					jQuery("#tooltip").remove();
				}
		
		    });
		    
		   
		    
		    function showTooltip(x, y, contents) {
		        jQuery('<div id="tooltip">' + contents + '</div>').css( {
		            position: 'absolute',
		            'pointer-events': 'none',
		            top: y - 15,
		            left: x + 10,
		            border: '1px solid #fdd',
		            padding: '2px',
		            'background-color': '#fee'
		        }).appendTo("body");
		    }
		    
		    /*--------CHart-----------------------*/	    
	});
});
</script>

 <script type="text/javascript">
jQuery(function () {

    
});
</script>
  


<script type="text/javascript">


/* Ajax call for search functionality  START */

function getSearchResults(crmId,campusVueId,firstname,lastname,maidenName,dob,ssn,city,state){	
	    var searchUrl ="&crmId="+crmId+"&campusVueId="+campusVueId+"&firstName="+firstname+"&lastName="+lastname+"&maidenName="+maidenName+"&dob="+dob+"&ssn="+ssn+"&city="+city+"&state="+state;
 
 		 jQuery.blockUI({ css: { 
            border: 'none', 
            padding: '15px', 
            backgroundColor: '#000', 
            '-webkit-border-radius': '10px', 
            '-moz-border-radius': '10px', 
            opacity: .5, 
            color: '#fff' 
        },
        message: "<h1>Searching.Please wait <img src='<c:url value='/images/ajax-loader.gif'/>' border='0' /></h1>"
         }); 
 
		jQuery.ajax({
		    async: "false",
			url: "<c:url value='/evaluation/launchEvaluation.html?operation=searchStudent"+searchUrl+"'/>",		
			success: function( data ) {	
			     jQuery.unblockUI();
				jQuery("#searchResult").html(data);
			},
			error: function(xhr, textStatus, errorThrown){
			       jQuery.unblockUI();
 				 jQuery('#searchResult').hide();
			     jQuery('#searchBy').show();
			}
		});
	}

/* Ajax call for search functionality END */
function loadRejectedTranscript(studentId,instituteId){
	url="<c:url value='/evaluation/launchEvaluation.html?operation=getAllCoursesAndDegreesForStudentAndInstitute&studentId="+studentId+"&institutionId="+instituteId+"'/>";
	document.launchTranScriptEvalutation.action = url;
	document.launchTranScriptEvalutation.submit();
}

</script>
 <div class="deo2">
  <div style="border:1px solid #e7e7e7; border-top:none;" class="institute">  <!-- class institute not present -->
	<div class="noti-tools2">
			<c:choose>
				 <c:when test="${fn:length(rejectedTranscriptList) gt 0}">
				 <form name="launchTranScriptEvalutation" id="launchTranScriptEvalutationId" method="post">
						   <div class="rejctdiv">
					           <div class="rejHead">There are REJECTED TRANSCRIPT   <a href="javascript:void(0)" id="rejTrans">(${rejectedSitListCount})</a></div>
					           <div class="mt10" style="display:none;" id="rejected">
					              <table width="100%" border="0" cellspacing="0" cellpadding="0" class="noti-tbl3 noti-bbn tabTBLborder">
					               <thead>
										<tr><th scope="col" class="dividerGrey">CRM ID</th>
											<th scope="col" class="dividerGrey">First Name Last Name</th>
					                        <th scope="col" class="dividerGrey">Institution Name</th>
					                        <th scope="col">Details</th>
					                    </tr>
					                 </thead>
					                 <tbody>
									    <c:forEach items="${rejectedTranscriptList}" var="rejectedTranscript" varStatus="loop">		
					                   	   <tr>
						                        <td>${rejectedTranscript.student.crmId}</td>
						                        <td>${rejectedTranscript.student.demographics.firstName} ${rejectedTranscript.student.demographics.lastName}</td>
						                        <td>${rejectedTranscript.institution.name}</td>
						                        <td>
						                        	<a href="javaScript:void(0);" onclick="javaScript:loadRejectedTranscript('${rejectedTranscript.student.id}','${rejectedTranscript.institution.id}');">
						                        	<c:if test="${rejectedTranscript.official eq true}">Official</c:if>
						                        	<c:if test="${rejectedTranscript.official eq false}">Un-official</c:if> - <fmt:formatDate value='${rejectedTranscript.modifiedDate}' pattern='MM/dd/yyyy'/></a></td>
					                       </tr>
					                     </c:forEach>
					                  </tbody>
					             </table>
					             <div class="floatRight mt10"><input type="button" class="button" value="Minimize" id="miniMize"></div>
					             <div class="clear"></div>
					         </div> <!-- end of div with class mt10 -->
					      </div> <!-- end of div with class rejctdiv -->
					  </form>
			      </c:when>
		 </c:choose>

		  <div class="DeoLanding" id="searchBy">
						  <div class="deoSearchBy">Search By:</div>
						  <div class="tblBgrndNone">
							<form onsubmit="return false;" id="srchFrm"> 
							  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="contentForm">
								<tr>
								  <td valign="top">&nbsp;</td>
								  <td valign="top" class="brdLeft">&nbsp;</td>
								  <td valign="top">&nbsp;</td>
								</tr>
								<tr>
								  <td width="50%" valign="top"><label class="noti-label w130">CRM Inquiry ID:</label>
								  <input id="crmId" type="text" value="" class="textField w200" tabindex=1 ></td>
								  <td width="2%" valign="top" class="brdLeft">&nbsp;</td>
								  <td width="50%" valign="top"><label class="noti-label w130">Date of Birth:<br/><span class="grasmalltext">(MM/DD/YYYY)</span></label>
								  <input id="dateOfBirth" type="text" value="" class="textField w200" tabindex=6></td>
								</tr>
								<tr>
								  <td valign="top"><label class="noti-label w130">Student Number:</label>
								  <input id="campusVueId" type="text" value="" class="textField w200" tabindex=2></td>
								  <td valign="top" class="brdLeft">&nbsp;</td>
								  <td valign="top"><label class="noti-label w130">SSN:</label>
									  <input id="ssn1" type="text" value="" class="textField w60" tabindex=7>
									  <input id="ssn2" type="text" value="" class="textField w30" tabindex=8>
									  <input id="ssn3" type="text" value="" class="textField w80px" tabindex=9>
								  </td>
								</tr>
								<tr>
								  <td valign="top"><label class="noti-label w130"> First Name:</label>
									<input id="firstName" type="text" value="" class="textField w200" tabindex=3>
								  </td>
								  <td valign="top" class="brdLeft">&nbsp;</td>
								  <td valign="top"><label class="noti-label w130">City:</label>
									<input id="city" type="text" value="" class="textField w200" tabindex=10>
								  </td>
								</tr>
								<tr>
								  <td valign="top"><label class="noti-label w130"> Last Name:</label>
									<input id="lastName" type="text" value="" class="textField w200" tabindex=4>
								  </td>
								  <td valign="top" class="brdLeft">&nbsp;</td>
								  <td valign="top"><label class="noti-label w130">State:</label>
									<input id="state" type="text" value="" class="textField w200" tabindex=11>
								  </td>
								</tr>
								<tr>
								  <td valign="top"><label class="noti-label w130">Maiden Name:</label>
									<input id="maidenName" type="text" value="" class="textField w200" tabindex=5>
								  </td>
								  <td valign="top" class="brdLeft">&nbsp;</td>
								  <td valign="top">&nbsp;</td>
								</tr>
							</table> 
							<div class="deoBorderTop">
								<div class="floatRight" align="right">
						  			<input type="submit" class="button" value="Search" id="srcDetail">&nbsp;
						  			<input type="button" class="button" value="Reset" id="srcReset">
						  			<input type="button" class="button" value="Cancel" id="srcCancel">
								</div>
						<div class="clear"></div>
					 </div> <!-- End of div with class deoBorderTop-->
						</form>  <!--end of srchFrm  -->
					 </div> <!--End of Div with class tblBgrndNone -->
		  </div> <!-- End of div with id SearchBy  and class DeoLanding-->
          <div id="searchResult" class="mt40">

         </div>  <!-- end of div with id searchResult -->
     <div class="deoTranscription">
    	<table style="background:none" width="100%" border="0" cellspacing="0" cellpadding="0" class="contentForm">
            <tr>
				   <td valign="top" width="40%">
			  <div id="placeholder" style="width:600px;height:292px"></div>
              </td>
				  <td valign="top">
					 <div class="graphpositDtl">
						<div class="transBorderbtm">Total Transcripts:<span class="col1">${totalTranscript}</span></div><br class="clear" />
						<div class="transBorderbtm">Last Month Transcripts:<span class="col2">${lastMonthTranscript}</span></div><br class="clear" />
						<div class="transBorderbtm">Last 7 days Transcripts:<span class="col3">${last7DaysTranscript}</span></div><br class="clear" />
						<div class="transBorderbtm">Today Transcripts:<span class="col5">${todaysTranscript}</span></div><br class="clear" />
					 </div>
				  </td>
           </tr>
        </table>
    </div> <!-- end of div with class deoTranscription -->
<!-- took off an close div-->
      

    </div><!-- end of div with class noti-tools2 -->
  </div> <!-- end of div with id class institute -->
</div> <!--end of div with class deo2 -->
<br class="clear" />
