<%@include file="../init.jsp" %>
<script type="text/javascript">
window.onload = (function () {
	jQuery(document).ready( function() {
	
	jQuery('.assign').click(function(){
		
		jQuery('.rptPopCenter').toggle();
		
		});
	jQuery('#MapSl').click(function(){
		
		jQuery('.mapsle').toggle();
		
		});
	jQuery('#Cancel2, #Save3').click(function(){
		
		jQuery('.rptPopCenter').hide();
		
		});
	jQuery('.mapsle').css("display:block");
	});
});
var collegeCode = "";
function fillCollgeCode(collegeCodeToWireUp){
	collegeCode = collegeCodeToWireUp;
	jQuery("#sleMatrix").html("");
	jQuery.ajax({
		url: "<c:url value='/evaluation/ieManager.html?operation=loadAllSLEForCollegeCode&collegeCode='/>"+collegeCode,
		dataType: "json",
		type: "POST",
		success: function( data ) {
			var htmlToAppend = "";
			for(var index = 0; index<data.length;index++){
				htmlToAppend = htmlToAppend + "<label><input type='checkbox' name='CheckboxGroup"+index+"' value='"+data[index].id+"' "+data[index].assignedToCollegeCode+"  id='checkboxGroup_"+index+"' />"+
								 data[index].firstName +"&nbsp;"+data[index].lastName+"</label>";
			}	
			//alert(htmlToAppend);
			jQuery("#sleMatrix").html(htmlToAppend+"<div class='clear'></div>");
		}
	});
}
function wireSLEToCollgedCode(){
	var userIdToWire = "";
	jQuery("[id^='checkboxGroup_']").each(function(){
		var trCheckBoxIdToRead = jQuery(this).attr("id");
		if(jQuery("#"+trCheckBoxIdToRead).is(':checked')){
			userIdToWire = userIdToWire + ","+jQuery("#"+trCheckBoxIdToRead).val();
		}
		
	});
	window.location.href ='<c:url value="/evaluation/ieManager.html?operation=wireSLEToCollgedCode"/>'+'&userIdToWire='+userIdToWire+'&collegeCode='+collegeCode;
}
function getByStatus(statusValue){
	window.location.href='ieManager.html?operation=getCoursesForInstitution&institutionId=${institution.id}&status='+jQuery(statusValue).attr('val');	
	
}
</script>
	
	<div class="deo2">
	  <div style="border:1px solid #e7e7e7; border-top:none;" class="institute">
	  	<div class="noti-tools2">
	        <div>
	        	<a href="javascript:void(0);" id="MapSl">Map SLE to College</a>
	            
	            <div class="fr orgColorbackground">
		          	  <span> 
		          	  		<label class="noti-label noti-mrgl fl"><a href="javascript:void(0)" onclick='javscript:getByStatus(this);' val='Conflict'>Conflict</a></label> 
		          	  		<span class="notification fr" style="margin-top:-3px">${conflictCount }</span>                   
		              </span>
		              <span> <label class="noti-label noti-mrgl">Re-assignable</label> 
		                 <span class="notification" style="margin-top:-3px">${reassignableCount }</span>                  
		              </span>
		             <span> <label class="noti-label noti-mrgl"><a href="javascript:void(0)" onclick='javscript:getByStatus(this);' val='Approval' >For Approval</a></label> 
		                 <span class="notification" style="margin-top:-3px">${approvalCount }</span>                  
		             </span>
	              </div>
	              <div class="clear"></div>
	        </div>
	        <div class="mapsle mt10">
		        <div class="rptPopCenter">
					 <span class="rptAssgnbg">Assign / Reassign SLE</span>
					 			                    
		                    <div id="sleMatrix">
		                    	<%-- <c:forEach items="${userList}" var="user" varStatus="userCount">		                      
				                        <label>
				                          <input type="checkbox" name="CheckboxGroup${userCount.index }" value="${user.id }" checked="checked" id="checkboxGroup_${userCount.index }" />
				                          	${user.firstName }&nbsp;&nbsp;${user.lastName }
				                          </label>
		                       </c:forEach> 
		                       
		                      <div class="clear"></div>--%>
		                    </div>
		                    
		                    <div class="dividerPopup"></div>
		                    <div class="btn-cnt">
							   <div class="fr">
										<input type="button" name="saveCollegeCode" value="Save" id="Save3" class="button" onclick="javaScript:wireSLEToCollgedCode();">
							            <input type="button" name="saveInstitution" value="Cancel" id="Cancel2" class="button">
							   </div>
							   <div class="clear"></div>
		  					</div>
		            </div>
	        	<c:forEach items="${collegeList }" var="college">
		        	<div class="clgcnt">
		            	
		                <div class="clglftcnt">
		                
		                	&nbsp;${college.description }
		                
		                </div>
		                <div class="clgrtcnt">
		                
		                	<div class="clgrn">
		                    	<div class="clgAssign">Assign / Reassign
								SLE</div>
								<div class="clgplsMns" collegeCodeToWire="${college.description}">
									<a href="javascript:void(0);" class="assign" onclick="javaScript:fillCollgeCode('${college.code}');"></a>
								    
								
								</div>
		                    
		                    </div>
		                
		                </div>
		                <div class="clear"></div>
		            
		            
		            </div>
	         </c:forEach>           
	        
	        </div>
	<!-- <div>
	  <div class="report-bottom">Reports:
	  
	  <div class="fr navtb">  
	  	<ul>
	    	<li class="nfirst sele"><a href="#">Last Day</a></li>
	    	<li><a href="#">Week</a></li>
	    	<li class="nlast"><a href="#">Month</a></li>                
	    
	    </ul>  
	  </div>
	  </div>
	  <div>
	  	<div class="report-tblCnt fl">
	    	<div class="report-totNo">Total No. of IE   <span class="report-totNbld">25</span></div>
	        
	        <div class="report-status fl">
	        <span>Institution(s) Status</span>
	        
	        <div class="report-statusCnt">
	        <div class="rept-stsTop">
	        
	        	<div class="rept-stsTopLeft fl">
	            
	            <span>Total</span><br />
	
	            <span class="rept-grnTxt">135</span>
	            
	            </div>
	            <div class="fl rept-stsTopRight">
	            <ul>
	            
	            	<li>Evaluated<span class="fr rept-litgrnTxt">125</span>
	                </li>
	            	<li>Not Evaluated
	                <span class="fr rept-litgrayTxt">50</span>
	                </li>                
	            
	            </ul>
	            
	            
	            </div>
	        
	        </div>
	        <div class="rept-btmWidth90per">
	        	<ul>
	            
	            	<li>Re-Assignable<span class="fr rept-litblueTxt">55</span>
	                </li>
	            	<li>For Approval
	                <span class="fr rept-litpinkTxt">NA</span>
	                </li>    
	                <li>Conflict(s)
	                <span class="fr rept-litOrangTxt">NA</span>
	                </li>             
	            
	            </ul>
	        
	        </div>
	        
	        
	        </div>
	        
	        </div>
	        <div class="report-status fr">
	        <span>Course(s) Status</span>
	        <div class="report-statusCnt">
	        <div class="rept-stsTop">
	        
	        	<div class="rept-stsTopLeft fl">
	            
	            <span>Total</span><br />
	
	            <span class="rept-grnTxt">135</span>
	            
	            </div>
	            <div class="fl rept-stsTopRight">
	            <ul>
	            
	            	<li>Evaluated<span class="fr rept-litgrnTxt">125</span>
	                </li>
	            	<li>Not Evaluated
	                <span class="fr rept-litgrayTxt">50</span>
	                </li>                
	            
	            </ul>
	            
	            
	            </div>
	        
	        </div>
	        <div class="rept-btmWidth90per">
	        	<ul>
	            
	            	<li>Re-Assignable<span class="fr rept-litblueTxt">55</span>
	                </li>
	            	<li>For Approval
	                <span class="fr rept-litpinkTxt">5</span>
	                </li>    
	                <li>Conflict(s)
	                <span class="fr rept-litOrangTxt">5</span>
	                </li>             
	            
	            </ul>
	        
	        </div>
	        
	        
	        </div>
	        </div>
	        <div class="clear"></div>
	        
	        
	    </div>
	    <div class="report-tblCnt fr">
	    <div class="report-totNo">Total No. of IE   <span class="report-totNbld">10</span></div>
	    
	    <div class="report-status fl">
	        <span>Institution(s) Status</span>
	        
	        <div class="report-statusCnt">
	        <div class="rept-stsTop">
	        
	        	<div class="rept-stsTopLeft fl">
	            
	            <span>Total</span><br />
	
	            <span class="rept-grnTxt">135</span>
	            
	            </div>
	            <div class="fl rept-stsTopRight">
	            <ul>
	            
	            	<li>Evaluated<span class="fr rept-litgrnTxt">125</span>
	                </li>
	            	<li>Not Evaluated
	                <span class="fr rept-litgrayTxt">50</span>
	                </li>                
	            
	            </ul>
	            
	            
	            </div>
	        
	        </div>
	        <div class="rept-btmWidth90per">
	        	<ul>
	            
	            	<li>Re-Assignable<span class="fr rept-litblueTxt">55</span>
	                </li>
	            	<li>For Approval
	                <span class="fr rept-litpinkTxt">NA</span>
	                </li>    
	                <li>Conflict(s)
	                <span class="fr rept-litOrangTxt">NA</span>
	                </li>             
	            
	            </ul>
	        
	        </div>
	        
	        
	        </div>
	        
	        </div>
	        <div class="report-status fr">
	        <span>Course(s) Status</span>
	        <div class="report-statusCnt">
	        <div class="rept-stsTop">
	        
	        	<div class="rept-stsTopLeft fl">
	            
	            <span>Total</span><br />
	
	            <span class="rept-grnTxt">135</span>
	            
	            </div>
	            <div class="fl rept-stsTopRight">
	            <ul>
	            
	            	<li>Evaluated<span class="fr rept-litgrnTxt">125</span>
	                </li>
	            	<li>Not Evaluated
	                <span class="fr rept-litgrayTxt">50</span>
	                </li>                
	            
	            </ul>
	            
	            
	            </div>
	        
	        </div>
	        <div class="rept-btmWidth90per">
	        	<ul>
	            
	            	<li>Re-Assignable<span class="fr rept-litblueTxt">55</span>
	                </li>
	            	<li>For Approval
	                <span class="fr rept-litpinkTxt">5</span>
	                </li>    
	                <li>Conflict(s)
	                <span class="fr rept-litOrangTxt">5</span>
	                </li>             
	            
	            </ul>
	        
	        </div>
	        
	        
	        </div>
	        </div>
	        <div class="clear"></div>
	    
	    </div>
	    <div class="clear"></div>
	  
	  
	  </div>
	    
	<div class="mt25 rept-tblBdr">
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <th width="30%" rowspan="2" valign="top" scope="col">IE Name</th>
	    <th width="20%" rowspan="2" valign="top" scope="col" style="text-align:center;">Total In Queue</th>
	    <th height="22" colspan="2" valign="top" class="rept-bdrbtm" style="text-align:center;" scope="col">Evaluated</th>
	    <th width="20%" rowspan="2" valign="top" scope="col" style="text-align:center;" class="rept-bdrrtNone">Conflict(s)</th>
	  </tr>
	  <tr>
	    <th width="15%" height="30" valign="middle" style="padding-top:1px; text-align:center;" scope="col">Institution(s)</th>
	    <th width="15%" valign="middle" scope="col" style="padding-top:1px; text-align:center;">Course(s)</th>
	    </tr>
	  <tr class="rept-grnbg">
	    <td><strong>IE:</strong> Top 5 Performers</td>
	    <td>&nbsp;</td>
	    <td>&nbsp;</td>
	    <td>&nbsp;</td>
	    <td>&nbsp;</td>
	  </tr>
	  <tr>
	    <td>Kenneth Rogers</td>
	    <td align="center">138</td>
	    <td align="center">15</td>
	    <td align="center">67</td>
	    <td align="center">2</td>
	  </tr>
	  <tr>
	    <td>Jo Smith</td>
	    <td align="center">138</td>
	    <td align="center">8</td>
	    <td align="center">60</td>
	    <td align="center">1</td>
	  </tr>
	  <tr>
	    <td>Krista Joachim</td>
	    <td align="center">138</td>
	    <td align="center">14</td>
	    <td align="center">40</td>
	    <td align="center">2</td>
	  </tr>
	  <tr>
	    <td>Kasia Christy</td>
	    <td align="center">138</td>
	    <td align="center">12</td>
	    <td align="center">36</td>
	    <td align="center">3</td>
	  </tr>
	  <tr>
	    <td>Dilek Ibic</td>
	    <td align="center">138</td>
	    <td align="center">10</td>
	    <td align="center">30</td>
	    <td align="center">1</td>
	  </tr>
	  <tr class="rept-redbg">
	    <td><strong>IE:</strong> Lowest 5 Performers</td>
	    <td align="center">&nbsp;</td>
	    <td align="center">&nbsp;</td>
	    <td align="center">&nbsp;</td>
	    <td align="center">&nbsp;</td>
	  </tr>
	  <tr>
	    <td>John Smithe</td>
	    <td align="center">138</td>
	    <td align="center">7</td>
	    <td align="center">19</td>
	    <td align="center">6</td>
	  </tr>
	  <tr>
	    <td>Jennifer Mehler</td>
	    <td align="center">138</td>
	    <td align="center">5</td>
	    <td align="center">15</td>
	    <td align="center">4</td>
	  </tr>
	  <tr>
	    <td>Barbra Smith</td>
	    <td align="center">138</td>
	    <td align="center">4</td>
	    <td align="center">11</td>
	    <td align="center">3</td>
	  </tr>
	  <tr>
	    <td>Jenny Williams</td>
	    <td align="center">138</td>
	    <td align="center">4</td>
	    <td align="center">8</td>
	    <td align="center">2</td>
	  </tr>
	  <tr>
	    <td class="rept-bdrbtmNone">Dilek Poza</td>
	    <td align="center" class="rept-bdrbtmNone">138</td>
	    <td align="center" class="rept-bdrbtmNone">2</td>
	    <td align="center" class="rept-bdrbtmNone">6</td>
	    <td align="center" class="rept-bdrbtmNone">2</td>
	  </tr>
	    </table>
	
	
	</div>
	
	</div>  --> 	  
		
	      
	      
	
	    </div>
	      
	 </div>
</div>