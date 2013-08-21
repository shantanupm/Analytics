<%@include file="../init.jsp" %>


  
<form id="frmAccreditingBody" method="post" action="launchEvaluation.html?operation=saveDeoComments">
<div class="popCont popUpsm">
        <h1><a href="#" class="close"></a>DEO Comments</h1>

        <label class="noti-pop-labl">Previous Comments:</label>
        
		
		<br class="clear" />
  <c:forEach items="${speCommentList}" var="speComment" varStatus="index">
        <label >${speComment.comment}</label>
        <label >${speComment.user.userName}</label>
        <label >${speComment.dateTime}</label>
        <br class="clear" />
  </c:forEach>      
        
        <label class="noti-pop-labl">Add New Comment</label>
        <textarea name="comment"> </textarea>
        
		<div class="dividerPopup mt25"></div>
		
        <div class="btn-cnt fr">
			 <input type="hidden" id="studentProgramEvaluationId" name="studentProgramEvaluationId" value="${studentProgramEvaluationId}" />
			 <input type="hidden" id="programVersionCode" name="programVersionCode" value="${programVersionCode}" />
			 <input type="hidden" id="studentCrmId" name="studentCrmId" value="${studentCrmId}" />
			
            <input name="" type="submit" value="Save" />
            <input name="" type="button"  class="close"  value="Cancel" /></div>
    </div>
    </form>