<%@include file="../init.jsp" %>

<form method="post" action="/scheduling_system/course/manageCourse.html?operation=saveCourseRelationship">
 <div class="popCont">
        <h1><a href="#" class="close"></a> 
        <c:choose>
        <c:when test="${not empty courseMappingId}">
        	Edit
        </c:when>
        <c:otherwise>
        	Add
        </c:otherwise>
        </c:choose> Course  Relationship</h1>
        
        

        <label class="caption">Course Code:</label>
        <input name="gcuCourseCode" type="text"  value="${courseMapping.gcuCourseCode}" class="textField small" /><br class="clear" />

        <label class="caption">Course Title:</label>
        <input name="" type="text" class="textField big" disabled="disabled" style="border:0px" /><br class="clear" />

        <label class="caption">Credits:</label>
        <input name="credits" type="text" value="${courseMapping.credits}" class="textField small" /><br class="clear" />

        <label class="caption">Min TR Grade:</label>
        <input name="minTransferGrade" type="text" value="${courseMapping.minTransferGrade}" class="textField small" /><br class="clear" />

        <label class="caption">Effective Date:</label>
        <input name="effectiveDate" type="text" value='<fmt:formatDate value="${courseMapping.effectiveDate}" pattern="MM/dd/yyyy"/>'  class="textField small maskDate" /><br class="clear" />

        <label class="caption">End Date:</label>
       <input name="endDate" type="text"  value='<fmt:formatDate value="${courseMapping.endDate}" pattern="MM/dd/yyyy"/>' class="textField small maskDate" /><br class="clear" />

        <label class="caption">Evaluation Status:</label>
         <select  name="evaluationStatus">
            <option value="0">Eligible</option>
        </select><br class="clear" />
        <br class="clear" />
        <div class="buttonRow">
       		 <input type="hidden" name="trCourseId" value="${transferCourseId}">
			 <c:if test="${not empty courseMappingId}">
				<input type="hidden" name="id" value="${courseMappingId}">
			 </c:if>
            <input name="saveCourseMapping" type="submit" value="Save" />
            <input name=""  class="close" type="button" value="Cancel" /></div>
    </div>
   </form>