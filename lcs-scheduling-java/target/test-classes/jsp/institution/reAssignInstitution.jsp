<%@include file="../init.jsp" %>
<script>
	function reAssignInstitution(){
		
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
			window.location = "/scheduling_system/evaluation/ieManager.html?operation=reAssignInstitution&institutionId=${institution.id}&fromId="+jQuery("#selFromId").val()+"&toId="+jQuery("#selToId").val();
		}
		
	}
</script>

<div class="popCont popUpsm">
       <h1><a href="#" class="close"></a> 
       Re-Assign Institution</h1>
       <table cellpadding="0" cellspacing="5" width="50%">
       	<tr>
       		<td> <label class="noti-pop-labl"> Institution Code :</label></td>
       		<td> <label><b>${institution.schoolcode }</b></label> </td>
       	</tr>
       	<tr>
       		<td> <label class="noti-pop-labl"> Institution Title :</label></td>
       		<td> <label><b>${institution.name }</b></label> </td>
       	</tr>
       	<tr>
       		<td><label class="noti-pop-labl">Assign From : </label></td>
       		<td>
       			<select id="selFromId" class="required frm-stxbx w200">
       				<option id="" value="">From Evaluator</option>
       				<c:if test="${ not empty institution.evaluator1}"><option value="${institution.evaluator1.id}">${institution.evaluator1.firstName} ${institution.evaluator1.lastName} </option></c:if>
       				<c:if test="${ not empty institution.evaluator2}"><option value="${institution.evaluator2.id}">${institution.evaluator2.firstName} ${institution.evaluator2.lastName} </option></c:if>
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
       <input type="button" class="button" value="Assign" onclick="reAssignInstitution();"/>
       <input name="" type="button"  class="close"  value="Cancel" />
  
    </div>
