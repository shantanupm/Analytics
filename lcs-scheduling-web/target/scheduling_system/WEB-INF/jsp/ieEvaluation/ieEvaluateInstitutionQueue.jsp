<%@include file="../init.jsp" %>   
<script type="text/javascript">
function selectForEvalutation(){
		jQuery.ajax({
			url: "<c:url value='/evaluation/quality.html?operation=ieEvaluateInstituteAndCourse&institutionId='/>"+jQuery("#institutionForEval:checked").val(),
			
			success: function( data ) {
				jQuery("#getResponse").html("");
				jQuery("#getResponse").html(data);
			},
			error: function(xhr, textStatus, errorThrown){
				var dataTopaint = jQuery("#getResponse").html();
				jQuery("#getResponse").html("");
				jQuery("#getResponse").html(dataTopaint);
				//jQuery("#getResponse").html(errorThrown);
			},
		});
	
	//jQuery(".close").click();
}
</script>
<div class="popCont popUpBig" style="width:700px;">
    <h1><a class="close" title="close"></a>Select From Evaluation Queue</h1>
    
    <div style="height:400px; overflow:auto" class="mt25">
      
       <table width="100%" cellspacing="0" cellpadding="0" border="0" class="noti-tbl1 borderEva">
         <tbody>
          <tr>
            <th align="left" scope="col">Institution(s) Title</th>
            <th width="35%" align="left" class="dividerGrey" scope="col"><span>Course(s) Title</span></th>
            <th width="15%" align="left" class="dividerGrey" scope="col">Entry Date</th>
           </tr>  
           <c:forEach items="${institutionList }" var="institution" varStatus="index">
	            <tr>
	            	<c:choose>
	            		<c:when test="${fn:length(institution.transferCourses) gt 0}">
	            			<td  width="30%" rowspan="${fn:length(institution.transferCourses)}" align="left">
	            		</c:when>
	            		<c:otherwise>
	            			<td  width="30%" rowspan="2" align="left">
	            		</c:otherwise>
	            	</c:choose>
	            	
		            <input type="radio" name="radio" id="institutionForEval" value="${institution.id }" class="floatLeft mt5" />
		            	<label for="radio" class="captionmt3">${institution.name}</label></td>
		            	<c:choose>
		            	<c:when test="${fn:length(institution.transferCourses) gt 0}">
		            	 <c:forEach items="${institution.transferCourses }" var="transferCourse" begin="0" end="1" varStatus="institutionIndex">
		           			<td align="left"><span class="captionmt3">
			           			<c:choose>
			           			<c:when test="${!empty transferCourse.trCourseTitle }">
			           				${transferCourse.trCourseTitle }
			           			</c:when>
			           			<c:otherwise>
			           				${transferCourse.trCourseCode }
			           			</c:otherwise>
			           			</c:choose>
			           			
			           			</span>
		           			</td>
		           			<td align="left"><span class="captionmt3"><c:if test="${institutionIndex.index eq 0 }"><fmt:formatDate pattern="MMM,dd yyyy" value="${institution.modifiedDateTime}" /></c:if></span></td>
		           		</tr>
		           		</c:forEach>
		           		<c:forEach items="${institution.transferCourses }" var="transferCourse" begin="2" end="${fn:length(institution.transferCourses) }">
		           		<tr>
		           			<td align="left"><span class="captionmt3">
			           			<c:choose>
			           			<c:when test="${!empty transferCourse.trCourseTitle }">
			           				${transferCourse.trCourseTitle }
			           			</c:when>
			           			<c:otherwise>
			           				${transferCourse.trCourseCode }
			           			</c:otherwise>
			           			</c:choose>
			           			
			           			</span>
		           			</td>
		           			<td align="left"><span class="captionmt3"><%-- <fmt:formatDate pattern="MMM,dd yyyy" value="${institution.modifiedDateTime}" /> --%></span></td>
		           		</tr>
		           		</c:forEach>
		            </c:when>	
           
	           <c:otherwise>
	          	 <tr>
	           			<td align="left"><span class="captionmt3">&nbsp;</span></td>
	            		<td align="left"><span class="captionmt3"><fmt:formatDate pattern="MMM,dd yyyy" value="${institution.modifiedDateTime}" /></span></td>
	          		</tr>
	           </c:otherwise>
           </c:choose>
           </c:forEach>
       </table>
        
      <div class="dividerPopup mt25"></div>
        
  </div>
   <div class="btn-cnt">
            <input class="fr close" type="button" value="Select" onclick="javascript:selectForEvalutation();"/>
            <div class="clear"></div>
  </div> 
</div>