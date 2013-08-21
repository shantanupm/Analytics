 <%@include file="../init.jsp" %>
 <script >
function addTermType(institutionTermTypeId) {
		
		 var url;
		 if(institutionTermTypeId=="0"){
			 url="<c:url value='/institution/manageInstitution.html?operation=addInstitutionTermType&institutionId=${institutionId}'/>";
		 }else{
			 url="<c:url value='/institution/manageInstitution.html?operation=addInstitutionTermType&institutionId=${institutionId}&institutionTermTypeId="+institutionTermTypeId+"'/>";
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
                <th class="heading" colspan="4"><strong>View / Edit Term Type</strong></th>
            </tr>
            <tr>
                <th width="40%">
                    Term Type
                </th>
                <th width="20%">
                    Effective Date</th>
                <th width="20%">
                    End Date</th>
                <th width="20%">
                    Action
                </th>
            </tr>
               <c:forEach items="${institutionTermTypeList}" var="institutionTermType" varStatus="index">
	             <tr>
	                <td ><c:out value="${institutionTermType.termType.name}" /></td>
	                <td align="center"><fmt:formatDate value="${institutionTermType.effectiveDate}" pattern="MM/dd/yyyy"/></td>
	                <td align="center" ><fmt:formatDate value="${institutionTermType.endDate}" pattern="MM/dd/yyyy"/></td>
	                <td align="center"><!--
	                <a onclick='Boxy.load("<c:url value='/institution/manageInstitution.html?operation=addInstitutionTermType&institutionId=${institutionId}&institutionTermTypeId=${institutionTermType.id}'/>",{ unloadOnHide : true})'   href="#">Edit</a>
	                -->
	                <a onclick='addTermType("${institutionTermType.id}")'   href="#">Edit</a>
	                </td>
	            </tr>
            </c:forEach>
           
            <tr><td></td><td></td><td></td><td></td></tr>
        </table>
        <table class="" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <td width="35%"> </td>
                <td width="65%" align="right" style="padding-top:10px">
                    <!--<input type="button" value="Add New Term Type" name="P Institution" class="button" onclick='Boxy.load("<c:url value='/institution/manageInstitution.html?operation=addInstitutionTermType&institutionId=${institutionId}'/>",{ unloadOnHide : true})'   />
                    --><input type="button" value="Add New Term Type" name="P Institution" class="button" onclick="addTermType(0)" />
                       <input type="button" value="Back"  class="button backlink" />
                </td>
            </tr>
        </table>
        
</div>        
    </div>
  </center>