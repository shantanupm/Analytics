<%@include file="../init.jsp" %>

<h1 class="expand">${student.demographics.firstName} ${student.demographics.lastName}</h1>
	    	
	        <div class="deoExpandDetails collapse" style="display:block;"> 
	            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="contentForm">
	              <tr>
	                <td width="46%">
		                <label class="noti-label w130">Student No:</label>
		                <label class="noti-label2">${student.campusvueId}</label>
	                </td>
	                <td width="2%" valign="top" class="brdLeft">&nbsp;</td>
	                <td width="52%" valign="top">
	                	<label class="noti-label w130">Program Name:</label>
	               		<label class="noti-label2">${courseInfo.programName}</label>
	               	</td>
	              </tr>
	              <tr>
	                <td>
		                <label class="noti-label w130">Lead CRM ID:</label>
		                <label class="noti-label2">${student.crmId}</label>
	                </td>
	                <td valign="top" class="brdLeft">&nbsp;</td>
	                <td valign="top">
		                <label class="noti-label w130">PV Code:</label>
		                <label class="noti-label2">${courseInfo.programVersionCode}</label>
	                </td>
	              </tr>
	              <tr>
	                <td>
			             <label class="noti-label w130"> State Code:</label>
			             <label class="noti-label2">${student.state}</label>
	                </td>
	                <td valign="top" class="brdLeft">&nbsp;</td>
	                <td valign="top"><label class="noti-label w130">Expected Start Date:</label>
	                <label class="noti-label2"><fmt:formatDate value="${courseInfo.expectedStartDate}" pattern="MM/dd/yyyy"/></label></td>
	              </tr>
	              <tr>
	                <td>&nbsp;</td>
	                <td valign="top" class="brdLeft">&nbsp;</td>
	                <td valign="top"><label class="noti-label w130">Catalog Code:</label>
	                <label class="noti-label2">${courseInfo.catalogCode}</label></td>
	              </tr>
	            </table>
	        </div>