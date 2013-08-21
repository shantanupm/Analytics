<%@include file="../init.jsp" %>

<form method="post" action="/scheduling_system/course/manageCourse.html?operation=saveCourseCtgRelationship">
<div class="popCont">
        <h1><a href="#" class="close"></a>
        <c:choose>
        <c:when test="${not empty courseCategoryMappingId}">
        	Edit
        </c:when>
        <c:otherwise>
        	Add
        </c:otherwise>
        </c:choose> Course Category Relationship</h1>

        <label class="caption">Category Code:</label>
        <input name="gcuCourseCategoryCode" type="text" value="${courseCategoryMapping.gcuCourseCategoryCode}" class="textField small" /><br class="clear" />

        <label class="caption">Category Title:</label>
        <input name="" type="text" class="textField big" disabled="disabled" style="border:0px" /><br class="clear" />

        <label class="caption">Credits:</label>
        <input name="credits" type="text" value="${courseCategoryMapping.credits}" class="textField small" /><br class="clear" />

        <label class="caption">Min TR Grade:</label>
        <input name="minTransferGrade" type="text" value="${courseCategoryMapping.minTransferGrade}" class="textField small" /><br class="clear" />

        <label class="caption">Effective Date:</label>
        <input name="effectiveDate" type="text" value='<fmt:formatDate value="${courseCategoryMapping.endDate}" pattern="MM/dd/yyyy"/>' class="textField small maskDate" /><br class="clear" />

        <label class="caption">End Date:</label>
        <input name="endDate" type="text" value='<fmt:formatDate value="${courseCategoryMapping.endDate}" pattern="MM/dd/yyyy"/>' class="textField small maskDate" /><br class="clear" />

        <label class="caption">Evaluation Status:</label>
         <select name="evaluationStatus">
            <option value="0">Eligible</option>
        </select><br class="clear" />

        <br class="clear" />
        <div class="buttonRow">
        <input type="hidden" name="trCourseId" value="${transferCourseId}">
        <c:if test="${not empty courseCategoryMappingId}">
        	<input type="hidden" name="id" value="${courseCategoryMappingId}">
        </c:if>
            <input name="saveCourseCategoryMapping" type="submit" value="Save" />
            <input name=""  class="close" type="button" value="Cancel" /></div>
    </div>
  </form>