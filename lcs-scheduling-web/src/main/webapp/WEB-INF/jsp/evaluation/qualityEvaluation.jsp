<%@include file="../init.jsp" %>
<style>
.heading{
	text-align: center;
}
</style>
<br/>
<div class="tblFormDiv" style="padding-left:30px;" >
<table style= "width:95%; align:center;">
<tr><td  style="width: 45%; vertical-align: top;" >
        <table class="tableForm" width="100%" border="1" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <th class="heading" colspan="5"><strong>Newly Added Institutions</strong></th>
            </tr>
            <tr>
                <th class="heading" width="15%">
                    School Code
                </th>
                <th class="heading" width="20%">
                    Institution</th>
                <th class="heading" width="20%">
                    Institution Type</th>
                <th class="heading" width="30%">
                    Institution Address</th>
                <th class="heading" width="15%">
                    Action
                </th>
            </tr>
            
             <c:forEach items="${institutionList}" var="institution" varStatus="index">
	             <tr>
	                <td align="center" ><c:out value="${institution.schoolcode}" /></td>
	                <td align="center" ><c:out value="${institution.name}" /></td>
	                <td align="center" ><c:out value="${institution.institutionType.name}" /></td>
	                <td align="center" ><c:out value="${institution.address1}" /></td>
	                <td align="center">
	                
	                <a onclick='window.location = "/scheduling_system/institution/manageInstitution.html?operation=createInstitution&institutionId="+"${institution.id}"'   href="#">Edit</a></td>
	            </tr>
            </c:forEach>
            
            
            <tr><td></td><td></td><td></td><td></td></tr>
        </table>
       </td>
       <td style="width: 45%; vertical-align: top;" >
        <table class="tableForm" width="100%" border="1" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <th class="heading" colspan="4"><strong>Newly Added Courses</strong></th>
            </tr>
            <tr>
            	<th class="heading" width="30%">Institution</th>
                <th class="heading" width="20%">TR Course Code</th>
                <th class="heading" width="30%">TR Course Title</th>
                
                <th class="heading" width="20%">Action</th>
            </tr>
            
            <c:forEach items="${transferCourseList}" var="transferCourse" varStatus="index">
	             <tr>
	              	<td  align="center"><c:out value="${transferCourse.strInstName}" /></td>
	                <td  align="center"><c:out value="${transferCourse.trCourseCode}" /></td>
	                <td  align="center"><c:out value="${transferCourse.trCourseTitle}" /></td>
	                <td align="center">
	                <a onclick='window.location = "/scheduling_system/course/manageCourse.html?operation=createCourse&transferCourseId="+"${transferCourse.id}"'   href="#">Edit</a></td>
	            </tr>
            </c:forEach>
            
            
            <tr><td></td><td></td><td></td><td></td></tr>
        </table>
        </td>
        </tr>
		<tr><td>&nbsp;</td><td>&nbsp;</td></tr>
        <tr><td>&nbsp;</td>
		<td> <input type="button" value="Manage Institutions" onclick='window.location = "/scheduling_system/institution/manageInstitution.html?operation=initParams"' class="button"/>
		 <input type="button" value="Manage Courses"  onclick='window.location = "/scheduling_system/course/manageCourse.html?operation=initParams"' class="button"/>
		</td></tr>
    </table>    
    </div>