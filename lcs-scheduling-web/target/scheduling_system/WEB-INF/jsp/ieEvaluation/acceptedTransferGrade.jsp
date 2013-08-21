<%@include file="../init.jsp"%>
<script type="text/javascript">
function evalSemEq(textBox){
	var semEqValue = jQuery('input[name$=transcriptCredits]').val();
	if("${institution.evaluationStatus}".toUpperCase() == "EVALUATED" && semEqValue != ''){
		if("${institutionTermType.termType.name}"=="Quarter"){
			semEqValue = parseFloat(semEqValue)*2/3;
			jQuery('input[name$=semesterCredits]').val(semEqValue.toFixed(2));	
		}
		else if("${institutionTermType.termType.name}"=="4-1-4"){
			semEqValue = parseFloat(semEqValue)*4;
			jQuery('input[name$=semesterCredits]').val(semEqValue.toFixed(2));
		}
		else if("${institutionTermType.termType.name}"=="Semester"){
			jQuery('input[name$=semesterCredits]').val(semEqValue.toFixed(2));
		}
		else{
			jQuery('input[name$=semesterCredits]').val("---");
		}
	}
	else{
		jQuery('input[name$=semesterCredits]').val("---");
	}
	
}
</script>
	<c:if test="${! empty institutionTermType.termType.name}">
		<c:set var="termTypeName" value="${institutionTermType.termType.name}"/>
	</c:if>
	<c:forEach items="${institutionTranscriptKeyGradeList }" var="institutionTranscriptKeyGrade" varStatus="institutionTranscriptKeyGradeIndex">
	      				<label>
	                        
	                        <c:choose>
	                        	  
	                       		 <c:when test="${institutionTranscriptKeyGrade.number }">
	                       		 	
	                       		 	<input type="checkbox" <c:if test="${institutionTranscriptKeyGrade.selected }"> checked="checked" </c:if> 
	                       		 		   assocId="${institutionTranscriptKeyGrade.gradeAssocId }" gradeTrcId="${transferCourse.id}"
	                       		 		   transcriptKeyGradeId="${institutionTranscriptKeyGrade.id }" gradeInstitutionId="${transferCourse.institution.id}"
	                       		 		   gradeFrom="${institutionTranscriptKeyGrade.gradeFrom }"
	                       		 		   gradeTo="${institutionTranscriptKeyGrade.gradeTo }"
	                       		 		   createdBy="${institutionTranscriptKeyGrade.createdBy }"
	                       		 		   modifiedBy="${institutionTranscriptKeyGrade.modifiedBy }"
	                       		 		   createdDate='<fmt:formatDate value="${institutionTranscriptKeyGrade.createdDate}" pattern="MM/dd/yyyy"/>'
	                       		 		   modifiedDate='<fmt:formatDate value="${institutionTranscriptKeyGrade.modifiedDate}" pattern="MM/dd/yyyy"/>'
	                       		 		   name="checkBox_${institutionTranscriptKeyGradeIndex.index }" value="${institutionTranscriptKeyGrade.id }" 
	                       		 		   id="institutionTranscriptKeyGradeId_${institutionTranscriptKeyGradeIndex.index }"/>
	                       		 			${institutionTranscriptKeyGrade.gradeFrom }&nbsp;-&nbsp;${institutionTranscriptKeyGrade.gradeTo }
	                       		 </c:when>
	                       		 <c:otherwise>
	                       		 <input type="checkbox" <c:if test="${institutionTranscriptKeyGrade.selected }"> checked="checked" </c:if> 
	                       		 		assocId="${institutionTranscriptKeyGrade.gradeAssocId }" gradeTrcId="${transferCourse.id}"
	                       		 		transcriptKeyGradeId="${institutionTranscriptKeyGrade.id }" gradeInstitutionId="${transferCourse.institution.id}"
	                       		 		gradeFrom="${institutionTranscriptKeyGrade.gradeAlpha }"
	                       		 		gradeTo=""
	                       		 		createdBy="${institutionTranscriptKeyGrade.createdBy }"
	                       		 		createdDate='<fmt:formatDate value="${institutionTranscriptKeyGrade.createdDate}" pattern="MM/dd/yyyy"/>'
	                       		 		modifiedDate='<fmt:formatDate value="${institutionTranscriptKeyGrade.modifiedDate}" pattern="MM/dd/yyyy"/>'
	                       		 		modifiedBy="${institutionTranscriptKeyGrade.modifiedBy }"
	                       		 		
	                       		 		name="checkBox_${institutionTranscriptKeyGradeIndex.index }"  id="institutionTranscriptKeyGradeId_${institutionTranscriptKeyGradeIndex.index }" />
	                       		 		${institutionTranscriptKeyGrade.gradeAlpha }
	                       		 </c:otherwise>
	                       		 
	                        </c:choose>
	                       
	                    </label>
	                      <c:if test="${institutionTranscriptKeyGradeIndex.index ne 0 && (institutionTranscriptKeyGradeIndex.index%2) ne 0}">
	                        	<div class="clear"></div>
	                      </c:if>
	                      <input type="hidden" name="transferCourseInstitutionTranscriptKeyGradeAssocList[${institutionTranscriptKeyGradeIndex.index }].id" id="institutionTranscriptKeyGradeAsscocId_${institutionTranscriptKeyGradeIndex.index }" value="">
	                      <input type="hidden" name="transferCourseInstitutionTranscriptKeyGradeAssocList[${institutionTranscriptKeyGradeIndex.index }].transferCourse.id" id="institutionTranscriptKeyGradeAsscocTransferCourseId_${institutionTranscriptKeyGradeIndex.index }" value=""> 
	                      <input type="hidden" name="transferCourseInstitutionTranscriptKeyGradeAssocList[${institutionTranscriptKeyGradeIndex.index }].institutionTranscriptKeyGradeId" id="institutionTranscriptKeyGradeAsscocInstitutionTranscriptKeyGradeId_${institutionTranscriptKeyGradeIndex.index }" value="">
	                      <input type="hidden" name="transferCourseInstitutionTranscriptKeyGradeAssocList[${institutionTranscriptKeyGradeIndex.index }].institutionId" id="institutionTranscriptKeyGradeAsscocInstitutionId_${institutionTranscriptKeyGradeIndex.index }" value=""> 
	                      
	                      <input type="hidden" name="transferCourseInstitutionTranscriptKeyGradeAssocList[${institutionTranscriptKeyGradeIndex.index }].gradeFrom" id="institutionTranscriptKeyGradeAsscocGradeFromId_${institutionTranscriptKeyGradeIndex.index }" value="">
	                      <input type="hidden" name="transferCourseInstitutionTranscriptKeyGradeAssocList[${institutionTranscriptKeyGradeIndex.index }].gradeTo" id="institutionTranscriptKeyGradeAsscocGradeToId_${institutionTranscriptKeyGradeIndex.index }" value=""> 	 
	                      <input type="hidden" name="transferCourseInstitutionTranscriptKeyGradeAssocList[${institutionTranscriptKeyGradeIndex.index }].createdBy" id="institutionTranscriptKeyGradeAsscocGradeCreatedById_${institutionTranscriptKeyGradeIndex.index }" value="">
	                      <input type="hidden" name="transferCourseInstitutionTranscriptKeyGradeAssocList[${institutionTranscriptKeyGradeIndex.index }].createdDate" id="institutionTranscriptKeyGradeAsscocGradeCreatedDateId_${institutionTranscriptKeyGradeIndex.index }" value="">
	                      <input type="hidden" name="transferCourseInstitutionTranscriptKeyGradeAssocList[${institutionTranscriptKeyGradeIndex.index }].modifiedBy" id="institutionTranscriptKeyGradeAsscocGradeModifiedById_${institutionTranscriptKeyGradeIndex.index }" value="">
	                      <input type="hidden" name="transferCourseInstitutionTranscriptKeyGradeAssocList[${institutionTranscriptKeyGradeIndex.index }].modifiedDate" id="institutionTranscriptKeyGradeAsscocGradeModifiedDateId_${institutionTranscriptKeyGradeIndex.index }" value="">
	                      			
      				</c:forEach>