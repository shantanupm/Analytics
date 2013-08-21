<%@include file="../init.jsp" %>
<script >
function addAccreditingBody(accreditingBodyInstituteId) {
		
		 var url;
		 if(accreditingBodyInstituteId=="0"){
			 url="<c:url value='/institution/manageInstitution.html?operation=addAccreditingBody&institutionId=${institutionId}'/>";
		 }else{
			 url="<c:url value='/institution/manageInstitution.html?operation=addAccreditingBody&institutionId=${institutionId}&accreditingBodyInstId="+accreditingBodyInstituteId+"'/>";
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
                <th class="heading" colspan="4"><strong>View / Edit Accrediting Body</strong></th>
            </tr>
            <tr>
                <th width="40%">
                    Accrediting Body
                </th>
                <th width="20%">
                    Effective Date</th>
                <th width="20%">
                    End Date</th>
                <th width="20%">
                    Action
                </th>
            </tr>
            
             <c:forEach items="${accreditingBodyList}" var="accreditingBodyInstitute" varStatus="index">
	             <tr>
	                <td ><c:out value="${accreditingBodyInstitute.accreditingBody.name}" /></td>
	                <td align="center">${accreditingBodyInstitute.effectiveDate}</td>
	                <td align="center" >${accreditingBodyInstitute.endDate}</td>
	                
	            	<td><a onclick='addAccreditingBody"${accreditingBodyInstitute.id}")'   href="#">Edit</a></td>
	            </tr>
            </c:forEach>
            
            
            <tr><td></td><td></td><td></td><td></td></tr>
        </table>
        <table class="" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <td width="35%"> </td>
                <td width="65%" align="right" style="padding-top:10px">
                    <!--<input type="button" value="Add New Accrediting Body" name="P Institution" class="button" 
                    onclick='Boxy.load("<c:url value='/institution/manageInstitution.html?operation=addAccreditingBody&institutionId=${institutionId}'/>",{ unloadOnHide : true})'   /> -->
                   <input type="button" value="Add New Accrediting Body" name="P Institution" class="button" onclick='addAccreditingBody(0)'/>
                      <input type="button" value="Back"  class="button backlink" />
                </td>
            </tr>
        </table>
        
        
    </div>
    </div>
    </center>