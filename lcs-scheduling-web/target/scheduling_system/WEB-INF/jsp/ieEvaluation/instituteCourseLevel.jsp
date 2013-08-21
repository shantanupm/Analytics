 <%@include file="../init.jsp" %>
 <script type="text/javascript">
 
</script> 
 <script type="text/javascript">
	
 </script>
<form method="post" id="instituteCourseLevelId" name="instituteCourseLevel">
<div class="popCont popUpBig" style="width:700px;">
    <h1><a class="close" title="close"></a>Course Level</h1>
    
    <div style="height:190px; overflow:auto" class="mt25">
    <div style="border:1px solid #e7e7e7;" class="institute">
  	
	
    <table width="100%" cellspacing="0" cellpadding="0" border="0" class="noti-tbl3" id="courseTitleBodyId">
       <tbody>
       <tr>
   			 <th width="10%" scope="col" class="dividerGrey">From</th>
    		 <th width="10%" scope="col" class="dividerGrey">To</th>
    		 <th width="60%" scope="col" class="dividerGrey" colspan="2">GCU Course Level</th>
    	</tr>
    	 <c:forEach items="${institutionTranscriptKey.institutionTranscriptKeyDetailsList}" var="institutionTranscriptKeyDetails" varStatus="status">
            
			<tr id="trAbRow_${status.index}">
                <td><Span>${institutionTranscriptKeyDetails.from}</span></td>
                <td><Span>${institutionTranscriptKeyDetails.to}</span></td>
                <td>
                	<span>
						<c:forEach items="${gcuCourseLevelList}" var="gcuCourseLevel">
							<c:if test="${institutionTranscriptKeyDetails.gcuCourseLevel.id == gcuCourseLevel.id}"> ${gcuCourseLevel.name} </c:if> 
						</c:forEach>
					</span>
                
                </td>
                <td>
                </td>
            </tr>
			
            </c:forEach>
         
       </tbody>
     </table>
    </div>    
      <div class="dividerPopup mt25"></div>
      
  </div>
   <div class="btn-cnt">
   		<div class="fr">
			<input type="button" name="cancel" value="Cancel" id="cancelInstitution" class="close">
		</div>
            <div class="clear"></div>
  </div>
  
</div>
</form> 