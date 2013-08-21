<%@page import="com.ss.common.util.UserUtil"%>
<%@include file="../init.jsp"%>
<% request.setAttribute("userCurrentId", UserUtil.getCurrentUser().getId()); %>
<c:if test="${!empty transcriptCommentsList}">
<div class="mt10" id="addedNote">
	<c:forEach items="${transcriptCommentsList}" var="transcriptComment" varStatus="index">
	            
             <div class="notebg2 p10">
            	<div class="noteLeft">${transcriptComment.user.firstName}&nbsp;${transcriptComment.user.lastName}: <br />
				<em class="mandatoryTxt"><fmt:formatDate value="${transcriptComment.createdDate}" pattern="MMM dd,yyyy HH:mm" /></em></div>
                <div class="noteRight">
                 ${transcriptComment.comment}
                </div>
                <div class="clear"></div>
                </div>
                <c:if test="${transcriptComment.user.id eq userCurrentId}">
                <div class="fr mt10">
		            <input type="button" commentId="${transcriptComment.id}" divindex="${divindex}" transcriptId="${transcriptComment.transcriptId}" value="Remove" class="button removeBtn" >
				</div>
				</c:if>
                <div class="clear"></div>
                 <div class="notedashbdr"></div>
         
	</c:forEach>  
	</div>
	
</c:if>

