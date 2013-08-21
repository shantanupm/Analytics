package com.ss.evaluation.service;

import java.util.Date;
import java.util.List;

import com.ss.course.value.CourseTranscript;
import com.ss.course.value.MilitarySubject;
import com.ss.course.value.TransferCourse;
import com.ss.course.value.TransferCourseTitle;
import com.ss.evaluation.value.StudentTranscriptCourse;
import com.ss.evaluation.value.TranscriptCourseSubject;
import com.ss.paging.helper.ExtendedPaginatedList;

public interface TransferCourseService{
	public TransferCourse getTransferCourseByCourseCodeAndInstitutionId( String transferCourseCode, String institutionId);
	public List<TransferCourse> getAllTransferCourse();
	public List<TransferCourse> getAllTransferCourseForEvaluation();
	public List<TransferCourse> getAllEvaluatedCoursesByInstId(String instId);
	public List<TransferCourse> getAllNotEvaluatedCoursesByInstId(String instId);
	public List<TransferCourse> getAllConflictCoursesByInstId(String instId);
	public TransferCourse getTransferCourseByInstitutionIdAndCourseNumber(String instId,String cn);
	public List<TransferCourse> getTransferCourseByInstitutionIdAndInstProgramId(String instId,String iPId);
	public TransferCourse getTransferCourseByInstitutionAndPartCourseTitle(String instId,String pct);
	public void addTransferCourse(TransferCourse tc);
	
	/**
	 * Persists a Transfer Course to the database.
	 * @param transferCourse
	 */
	public void saveTransferCourse( TransferCourse transferCourse );
	public List<TransferCourse> getAllCoursesByInstId(String institutionId,String status);
	public ExtendedPaginatedList getAllRecordsPage(Class clazz,
			ExtendedPaginatedList paginatedList,String institutionId,String status, String searchBy, String searchText);
	List<TransferCourse> getAllCoursesForApproval();
	public List<TransferCourseTitle> getTransferCourseTitlesByTransferCourseId(String transferCourseId);
	public TransferCourseTitle getTransferCourseTitleById(String id);
	
	public void addTransferCourseTitle(TransferCourseTitle tct);
	
	public TransferCourseTitle getTransferCourseTitleByDate(Date date, String transferCourseId);
	public TransferCourseTitle getTransferCourseTitleByCourseIdAndTitle(String trCourseId, String title);
	public TransferCourseTitle getNotEvaluatedTransferCourseTitleByCourseIdAndTitle(String trCourseId, String title);
	public int getRequiredApprovalCount();
	public List<TransferCourse> getCourseByInstitutionIdAndString(String institutionId, String searchBy, String searchText);
	public void addCourseTranscript(CourseTranscript ct);
	public CourseTranscript getCourseTranscript(String transferCourseId);
	public void addTransferCourseTitles(List<TransferCourseTitle> tcts);
	public void removeTransferCourseTitles(List<TransferCourseTitle> courseTitleList);
	public TransferCourse getTransferCourseById(String transferCourseId);
	public void addTransferCourseTitle(TransferCourseTitle tct, int tctSize);
	public List<MilitarySubject> getMilitarySubjectByTransferCourseId(String transferCourseId);
	public void addMilitarySubject(List<MilitarySubject> titleList);
	public void addMilitarySubjectPerTranscriptCourseSubject(MilitarySubject militarySubject);
	public void addTranscriptCourseSubjectList(List<TranscriptCourseSubject> newTranscriptCourseSubjectList);
	public List<TranscriptCourseSubject> getAllTranscriptCourseSubjectByStudentTranscriptCourseId(String studentTranscriptCourseId);
	public MilitarySubject isMilitarySubjectExit(String subjectName, String transferCourseId);
	public TranscriptCourseSubject getTranscriptCourseSubjectByTranscriptCourseIdAndSubjectId(String subjectId, String studentTranscriptCourseId);
	public void addOrUpdateTranscriptCourseSubject(TranscriptCourseSubject transcriptCourseSubject);
	public void updateAllTranscriptCourseSubjects(List<TranscriptCourseSubject> transcriptCourseSubjectList);

	public void removeRejectedStudentTranscriptCourseSubjectMarkForDelection(
			List<TranscriptCourseSubject> tcsubjectRejectedListForDeletion);
	public MilitarySubject getMilitarySubjectById(String militarySubjectId);
	public TranscriptCourseSubject getTranscriptCourseSubjectById(String transcriptCourseSubjectId);
}