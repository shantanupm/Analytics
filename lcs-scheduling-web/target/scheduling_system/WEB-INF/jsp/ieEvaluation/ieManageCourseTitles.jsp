<%@include file="../init.jsp" %>
<script type="text/javascript">
var globalstatus=''
	function addCourseTitle(courseTitleId) {
		 var url;
		 if('${role}'=='MANAGER'){
			 if(courseTitleId=="0"){
				 url="<c:url value='/evaluation/ieManager.html?operation=addCourseTitle&transferCourseId=${transferCourseId}&institutionId=${institutionId}'/>";
			 }else{
				 url="<c:url value='/evaluation/ieManager.html?operation=addCourseTitle&transferCourseId=${transferCourseId}&institutionId=${institutionId}&courseTitleId="+courseTitleId+"'/>";
			}
		}else{
			 if(courseTitleId=="0"){
				 url="<c:url value='/evaluation/quality.html?operation=addCourseTitle&transferCourseMirrorId=${transferCourseMirrorId}'/>";
			 }else{
				 url="<c:url value='/evaluation/quality.html?operation=addCourseTitle&transferCourseMirrorId=${transferCourseMirrorId}&courseTitleId="+courseTitleId+"'/>";
			}
		}
		Boxy.load(url,
		{ unloadOnHide : true	,
 		afterShow : function() {
 			settingMaskInput();
 			jQuery('#evaluationStatus').val(globalstatus);
 			
 			jQuery.validator.addMethod("dateRange", function() {
 				if(jQuery("#endDate").val()!='' && isDate(jQuery("#endDate").val())){
 					return new Date(jQuery("#effectiveDate").val()) < new Date(jQuery("#endDate").val());
 				}else{
 					return true;
 				}
 			}, "End date should be greater than the effective date.");
 			
 			jQuery.validator.addClassRules({
 				requiredDateRange: {  dateRange:true}
 			});
 			
 			jQuery("#frmCourseTitle").validate();
		}
		});
	}
	jQuery(document).ready(function(){
		jQuery("[name='effective']").change(function(){
			if('${role}'=='MANAGER'){
				window.location.href='ieManager.html?operation=effectiveCourseTitles&institutionId=${institutionId}&transferCourseId=${transferCourseId}&courseTitleId='+jQuery(this).val();
			}else{
				window.location.href='quality.html?operation=effectiveCourseTitles&transferCourseMirrorId=${transferCourseMirrorId}&courseTitleId='+jQuery(this).val();
			}
		})	;
		
	});

</script>
 <c:choose>
     	<c:when test="${userRoleName =='Institution Evaluation Manager'}"> 
        	<c:set var="backLink" scope="session" value="/scheduling_system/evaluation/ieManager.html?operation=ieCourse&transferCourseId=${transferCourseId}"/>
 	 	</c:when>
 	 	<c:when test="${userRoleName =='Administrator'}"> 
        	<c:set var="backLink" scope="session" value="/scheduling_system/evaluation/admin.html?operation=viewCourseDetails&courseId=${transferCourseId}"/>
 	 	</c:when>
 		<c:otherwise>
 			<c:set var="backLink" scope="session" value="/scheduling_system/evaluation/quality.html?operation=ieCourse&institutionMirrorId=${institutionMirrorId}&transferCourseId=${transferCourseId}"/>
 	 	</c:otherwise>
 	</c:choose> 


<ul class="pageNav">
        
         <li><a href="${courseDetailLink}" style="z-index:9;" >Course Details <span class="sucssesIcon"></span></a></li>
         <li><a href="${titleLink }" style="z-index:8;" class="active"> Titles <c:choose> <c:when test="${fn:length(transferCourse.titleList)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose></a> </li>
         <li><a href="${relationLink }" style="z-index:7;" >Course Relationship <c:choose> <c:when test="${fn:length(transferCourse.courseMappings)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise > <span class="alrtIcon"></span></c:otherwise></c:choose>  </a> </li>
         <li><a href="${catRelationLink }" style="z-index:6;">Course Category Relationship <c:choose> <c:when test="${fn:length(transferCourse.courseCategoryMappings)>0}"> <span class="sucssesIcon"></span> </c:when> <c:otherwise ><span class="alrtIcon"></span> </c:otherwise></c:choose></a> </li>
         <li><a href="${markCompleteLinkCourse }" class="last">Summary</a></li>
         
        
        </ul>
<div class="infoContnr"><div class="infoTopArow2"></div>
	<div class="fr institutionHeader">
       		<a href="javascript:void(0)" onclick='addCourseTitle("0")'><img alt="" src="../images/termTypeIcon.png">Add Course Title</a>
     </div><br class="clear">
<c:choose>
        <c:when test="${fn:length(courseTitleList)>0}">

	<table width="100%" cellspacing="0" cellpadding="0" border="0" class="noti-tbl">
       <tbody>
       <tr>
                <th width="25%" class="dividerGrey" >Course Title</th>
                <th width="10%" class="dividerGrey" >Effective Date</th>
                <th width="10%" class="dividerGrey" >End Date</th>
                <th width="10%" class="dividerGrey" >Evaluation Status</th>
                <th width="10%" class="dividerGrey" >Effective</th>
                <th width="10%" class="dividerGrey" >Action</th>
       </tr>
          <c:forEach items="${courseTitleList}" var="courseTitle" varStatus="index">
       <tr>
         <td><span>${courseTitle.title}</span></td>
         
         <td><span><fmt:formatDate value="${courseTitle.effectiveDate}" pattern="MM/dd/yyyy"/></span></td>
         <td><span><fmt:formatDate value="${courseTitle.endDate}" pattern="MM/dd/yyyy"/></span></td>
         <td><span>${courseTitle.evaluationStatus}</span></td>
          <td><span>
	       <c:choose>
	     	<c:when test="${role != 'ADMIN'}"> 
		         <input type="radio" name="effective" value="${courseTitle.id}"  
		         <c:if test="${courseTitle.effective == 'true'}"> checked='checked'</c:if>/>
	         </c:when>
	         <c:otherwise>${courseTitle.effective}</c:otherwise>
	       </c:choose>
	       </span></td>
         <td><span>
         <c:if test="${role != 'ADMIN'}">
         	 <a onclick='addCourseTitle("${courseTitle.id}")'   href="#">
         	<img src="../images/editIcon.png" width="14" height="14" alt="Edit" />Edit</a> 
            </c:if>
            </span>
         </td>
         </tr>
        </c:forEach>
       </tbody>
     </table>
 	</c:when>
 		<c:otherwise> <div class="notifyMsg">No Records Found </div>
 		</c:otherwise>
 		</c:choose>
 </div>	
 	
 	

<!--  
<center>
<div class="tblFormDiv divCover outLine">
<div class="innerDiv" >
        <table class="tableForm" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <th class="heading" colspan="5"><strong>View / Edit Course Titles</strong></th>
            </tr>
        </table>
        <br class="clear" />
        <table class="tableS2" width="100%" style="border-collapse: collapse; border-color: #AAAFB2"
            border="1" cellspacing="0" cellpadding="0">
            <tr>
                <th width="5%">Record #</th>
                <th width="20%">Course Title</th>
                <th width="10%">Effective Date</th>
                <th width="10%">End Date</th>
                <th width="10%">Evaluation Status</th>
                <th width="10%">Action</th>
            </tr>
              <c:forEach items="${courseTitleList}" var="courseTitle" varStatus="index">
	             <tr>
	                <td align="center"><c:out value="${index.count}" /></td>
	                <td align="center"><c:out value="${courseTitle.title}" /></td>
	                <td align="center"><fmt:formatDate value="${courseTitle.effectiveDate}" pattern="MM/dd/yyyy"/></td>
	                <td align="center" ><fmt:formatDate value="${courseTitle.endDate}" pattern="MM/dd/yyyy"/></td>
	                <td align="center" ><c:out value="${courseTitle.evaluationStatus}" /></td>
	               
	                <td align="center"><c:if test="${role != 'ADMIN'}"><a onclick='addCourseTitle("${courseTitle.id}")'   href="#">Edit</a></c:if></td>
	            </tr>
            </c:forEach>
           
            
            
        </table>
        <table class="" width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
            <tr>
                <td width="35%"> </td>
                <td width="65%" align="right" style="padding-top:10px">
                 <c:if test="${role != 'ADMIN'}">
                    <input type="button" value="Add Course Title"  class="button" onclick='addCourseTitle(0)'  />
                    </c:if>
                    <input type="button" value="Back" onclick='window.location = "${backLink}"' class="button" />
                </td>
            </tr>
        </table>
        
</div>        
    </div>
   </center>  -->
