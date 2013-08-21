<%@include file="../../init.jsp" %>
<link href="../css/style.css" rel="stylesheet" type="text/css" />
<div class="popCont popUpBig" style="width:700px;">
    <h1><a class="close" title="close"></a>Program Name List</h1>
    
    <div style="height:400px; overflow:auto" class="mt25">
      
       <table width="100%" cellspacing="0" cellpadding="0" border="0" class="noti-tblp borderEva">
         <tbody>
          <tr>
            <th width="40%" align="left" scope="col">Program Name</th>
            <th width="20%" align="left" class="dividerGrey" scope="col">PV Code</th>
            <th width="20%" align="left" class="dividerGrey" scope="col">Expected Start Date</th>
            <th width="20%" align="left" class="dividerGrey" scope="col">Catalog Code</th>
           </tr>
	           <c:choose>
				    <c:when test="${fn:length(programList) gt 0}">
				      	<c:forEach items="${programList}" var="program" varStatus="loop">	
				      	    <tr>		         
					            <td width="30%" align="left">${program.programName}</td>
					            <td align="left">${program.programVersionCode}</td>
					            <td align="left"><fmt:formatDate value='${program.expectedStartDate}' pattern='MM/dd/yyyy'/></td>
					            <td align="left">${program.catalogCode}</td>
					        </tr>
				   	  	 </c:forEach>
		            </c:when>
		             <c:when test="${hasError}">
				      	 <div class="errorMessageDv">${errorMessage}</div>	 
		            </c:when>
		            <c:otherwise>
		               <tr>No Programs found for the studentss</tr>
		            </c:otherwise>
	           </c:choose>            
          </tbody>
        </table>       
  </div>
</div>