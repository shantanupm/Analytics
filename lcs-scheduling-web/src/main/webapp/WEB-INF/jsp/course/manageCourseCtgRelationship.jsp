<%@include file="../init.jsp" %>
<script type="text/javascript">
	function addCourseCtgRelationship(courseCategoryMappingId) {
		
		 var url;
		 if(courseCategoryMappingId=="0"){
			 url="<c:url value='manageCourse.html?operation=addCourseCtgRelationship&transferCourseId=${transferCourseId}'/>";
		 }else{
			 url="<c:url value='manageCourse.html?operation=addCourseCtgRelationship&transferCourseId=${transferCourseId}&courseCategoryMappingId="+courseCategoryMappingId+"'/>";
		}
		
		Boxy.load(url,
		{ unloadOnHide : true	,
 		afterShow : function() {
 			settingMaskInput();
 			jQuery('#frmCourseCtgRelationship').validate();
		}
		});
	}

</script>

<center>
<div class="tblFormDiv divCover outLine">
<div class="innerDiv" >
        <table class="tableForm" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <th class="heading" colspan="9"><strong>View / Edit Course Category Relationship</strong></th>
            </tr>
        </table>
        <br class="clear" />
        <table class="tableS2" width="100%" style="border-collapse: collapse; border-color: #AAAFB2"
            border="1" cellspacing="0" cellpadding="0">
            <tr>
                <th width="5%">Record #</th>
                <th width="15%">GCU Course Category Code</th>
                <th width="20%">GCU Course Category Title</th>
                <th width="10%">Credits</th>
                <th width="10%">Min TR Grade</th>
                <th width="10%">Effective Date</th>
                <th width="10%">End Date</th>
                <th width="10%">Evaluation Status</th>
                <th width="10%">Action</th>
            </tr>
             <c:forEach items="${courseCategoryMappingList}" var="courseCategoryMapping" varStatus="index">
	             <tr>
	                <td align="center"><c:out value="${courseCategoryMapping.id}" /></td>
	                <td align="center"><c:out value="${courseCategoryMapping.gcuCourseCategoryCode}" /></td>
	                <td><c:out value="${courseCategoryMapping.trCourseId}" /></td>
	                <td align="center"><c:out value="${courseCategoryMapping.credits}" /></td>
	                <td align="center"><c:out value="${courseCategoryMapping.minTransferGrade}" /></td>
	                <td align="center"><fmt:formatDate value="${courseCategoryMapping.effectiveDate}" pattern="MM/dd/yyyy"/></td>
	                <td align="center" ><fmt:formatDate value="${courseCategoryMapping.endDate}" pattern="MM/dd/yyyy"/></td>
	                <td align="center" ><c:out value="${courseCategoryMapping.evaluationStatus}" /></td>
	                <!-- <td align="center"><a onclick="Boxy.load('<c:url value="manageCourse.html?operation=addCourseCtgRelationship&transferCourseId=${transferCourseId}&courseCategoryMappingId=${courseCategoryMapping.id}"/>')"   href="#">Edit</a></td> -->
	            	 <td align="center"><a  onclick='addCourseCtgRelationship("${courseCategoryMapping.id}")'  href="#">Edit</a></td> 
	            </tr>
            </c:forEach>
          
        </table>
        <table class="" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <td width="35%"> </td>
                <td width="65%" align="right" style="padding-top:10px">
                    <input type="button" value="Add New Course Category Relationship" name="P Institution" class="button" onclick='addCourseCtgRelationship(0)'  />
                    <input type="button" value="Back" class="button backlink" />
                </td>
            </tr>
        </table>
        
      </div>  
    </div>
   </center>