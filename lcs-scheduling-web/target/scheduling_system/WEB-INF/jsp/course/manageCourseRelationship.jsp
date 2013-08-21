<%@include file="../init.jsp" %>
<script type="text/javascript">
	function addCourseRelationship(courseMappingId) {
		 var url
		 if(courseMappingId=="0"){
			 url="<c:url value='manageCourse.html?operation=addCourseRelationship&transferCourseId=${transferCourseId}'/>";
		 }else{
			 url="<c:url value='manageCourse.html?operation=addCourseRelationship&transferCourseId=${transferCourseId}&courseMappingId="+courseMappingId+"'/>";
		}
		
		Boxy.load(url,
		{ unloadOnHide : true	,
 		afterShow : function() {
 			settingMaskInput();
		}
		});
	}

</script>
<center>
<div class="tblFormDiv divCover outLine">
<div class="innerDiv" >
        <table class="tableForm" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <th class="heading" colspan="5"><strong>View / Edit Course Relationship</strong></th>
            </tr>
        </table>
        <br class="clear" />
        <table class="tableS2" width="100%" style="border-collapse: collapse; border-color: #AAAFB2"
            border="1" cellspacing="0" cellpadding="0">
            <tr>
                <th width="5%">Record #</th>
                <th width="15%">GCU Course Code</th>
                <th width="20%">GCU Course Title</th>
                <th width="10%">Credits</th>
                <th width="10%">Min TR Grade</th>
                <th width="10%">Effective Date</th>
                <th width="10%">End Date</th>
                <th width="10%">Evaluation Status</th>
                <th width="10%">Action</th>
            </tr>
              <c:forEach items="${courseMappingList}" var="courseMapping" varStatus="index">
	             <tr>
	                <td align="center"><c:out value="${courseMapping.id}" /></td>
	                <td align="center"><c:out value="${courseMapping.gcuCourseCode}" /></td>
	                <td><c:out value="${courseMapping.trCourseId}" /></td>
	                <td align="center"><c:out value="${courseMapping.credits}" /></td>
	                <td align="center"><c:out value="${courseMapping.minTransferGrade}" /></td>
	                <td align="center"><fmt:formatDate value="${courseMapping.effectiveDate}" pattern="MM/dd/yyyy"/></td>
	                <td align="center" ><fmt:formatDate value="${courseMapping.endDate}" pattern="MM/dd/yyyy"/></td>
	                <td align="center" ><c:out value="${courseMapping.evaluationStatus}" /></td>
	               <!--  <td align="center"><a onclick="Boxy.load('<c:url value="manageCourse.html?operation=addCourseRelationship&transferCourseId=${transferCourseId}&courseMappingId=${courseMapping.id}"/>')"   href="#">Edit</a></td> -->
	                <td align="center"><a onclick='addCourseRelationship("${courseMapping.id}")'   href="#">Edit</a></td>
	            </tr>
            </c:forEach>
           
            
            
        </table>
        <table class="" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <td width="35%"> </td>
                <td width="65%" align="right" style="padding-top:10px">
                    <input type="button" value="Add New Course Relationship" name="P Institution" class="button" onclick='addCourseRelationship(0)'  />
                    <input type="button" value="Back"  class="button backlink" />
                </td>
            </tr>
        </table>
        
</div>        
    </div>
   </center>