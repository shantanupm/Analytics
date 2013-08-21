<%@include file="../init.jsp" %>
<script>
	function reAssignCourse(){
		
		if(jQuery("#selFromId").val() == '' || jQuery("#selToId").val() == ''){
			if(jQuery("#selFromId").val() == ''){
				alert("please select the 'From Evaluator'");
				return;
			}
			if(jQuery("#selToId").val() == ''){
				alert("please select the 'To Evaluator'");
				return;
			}
		}
		else{
			window.location = "/scheduling_system/evaluation/ieManager.html?operation=reAssignCourse&transferCourseId=${transferCourse.id}&fromId="+jQuery("#selFromId").val()+"&toId="+jQuery("#selToId").val();
		}
		
	}
</script>

<div class="popCont popUpsm">
       <h1><a href="#" class="close"></a> 
       Re-Assign Course</h1>
       <table cellpadding="0" cellspacing="5" width="50%">
       	<tr>
       		<td> <label class="noti-pop-labl"> Course Code :</label></td>
       		<td> <label><b>${transferCourse.trCourseCode }</b></label> </td>
       	</tr>
       	<tr>
       		<td> <label class="noti-pop-labl"> Course Title :</label></td>
       		<td> <label><b>${transferCourse.trCourseTitle }</b></label> </td>
       	</tr>
       	<tr>
       		<td><label class="noti-pop-labl">Assign From : </label></td>
       		<td>
       			<select id="selFromId" class="required frm-stxbx w200">
       				<option id="" value="">From Evaluator</option>
       				<c:if test="${ not empty transferCourse.evaluator1}"><option value="${transferCourse.evaluator1.id}">${transferCourse.evaluator1.firstName} ${transferCourse.evaluator1.lastName} </option></c:if>
       				<c:if test="${ not empty transferCourse.evaluator2}"><option value="${transferCourse.evaluator2.id}">${transferCourse.evaluator2.firstName} ${transferCourse.evaluator2.lastName} </option></c:if>
       			</select>
       		</td>
       	</tr>
       	<tr>
       		<td><label class="noti-pop-labl">Assign To : </label></td>
       		<td>
       			<select id="selToId" class="required frm-stxbx w200">
       				<option value="">To Evaluator</option>
       				<c:forEach var="user"  items="${assignableEvaluators}">
       					<option value="${user.id}">${user.firstName} ${user.lastName}</option>
       				</c:forEach>
       			</select>
       		</td>
       	</tr>
       </table><br><br><br>
       <input type="button" class="button" value="Assign" onclick="reAssignCourse();"/>
       <input name="" type="button"  class="close"  value="Cancel" />
  
    </div>
