package com.ss.evaluation.service;

import java.util.List;

import com.ss.course.value.TransferCourse;
import com.ss.course.value.TransferCourseMirror;
import com.ss.evaluation.value.StudentInstitutionTranscript;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionMirror;

public interface EvaluationJobService {
	
	public List<Institution> getNotEvaluatedInstitutionsForJob();
	public List<InstitutionMirror> getCompletedInstitutionMirrors(String institutionId);
	public List<TransferCourse> getNotEvaluatedTransferCourses();
	public List<TransferCourseMirror> getCompletedTransferCourseMirrors(String transferCourseId);
	public List<StudentInstitutionTranscript> getAwaitingIEorIEMSITList();
	
}
