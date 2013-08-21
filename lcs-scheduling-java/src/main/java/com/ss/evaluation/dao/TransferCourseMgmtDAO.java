package com.ss.evaluation.dao;

import java.io.Serializable;
import java.util.List;

import org.displaytag.properties.SortOrderEnum;

import com.ss.common.dao.BaseDAO;
import com.ss.course.value.CourseTranscript;
import com.ss.course.value.MilitarySubject;
import com.ss.course.value.TransferCourse;
import com.ss.course.value.TransferCourseTitle;
import com.ss.evaluation.value.*;
import com.ss.institution.value.Institution;


/**
 * DAO Interface for operations on a {@link Institution}
 * @author binoy.mathew
 */
public interface TransferCourseMgmtDAO extends BaseDAO<TransferCourse, Serializable> {
	
	/**
	 * Retrieves the Institution by the id.
	 * @param institutionId
	 * @return
	 */
	public TransferCourse getTransferCourseByCourseCodeAndInstitutionId(String transferCourseCode, String institutionId);
	public List<TransferCourse> getAllTransferCourse();
	public List<TransferCourse> getAllTransferCourseForEvaluation();
	public List<TransferCourse> getAllEvaluatedCoursesByInstId(String institutionId);
	public List<TransferCourse> getAllNotEvaluatedCoursesByInstId(String institutionId);
	public List<TransferCourse> getAllConflictCoursesByInstId(String institutionId);
	public TransferCourse getTransferCourseByInstitutionIdAndCourseNumber(String instId,String cn);
	public List<TransferCourse> getTransferCourseByInstitutionIdAndInstProgramId(String instId,String iPId);
	public TransferCourse getTransferCourseByInstitutionAndPartCourseTitle(String instId,String pct);
	public void addTransferCourse(TransferCourse tc);	
	
	/**
	 * Persists a Transfer Course to the database.
	 * @param transferCourse
	 */
	public void saveTransferCourse( TransferCourse transferCourse );
	public List<TransferCourse> getTransferCourseByInstitutionIdAndString(
			String institutionId, String courseCode);
	public List<TransferCourse> getAllCoursesByInstId(String institutionId,String status);
	public int getAllRecordsCount(Class clazz,String institutionId,String status, String searchBy, String searchText);
	public List getAllRecordsPage(Class clazz, int firstResult, int maxResults,
			SortOrderEnum sortDirection, String sortCriterion,String institutionId,String status, String searchBy, String searchText);
	List<TransferCourse> getAllCoursesForApproval();
	public List<TransferCourseTitle> getTransferCourseTitlesByCourseCodeandInstitutionId(String courseCode, String institutionId);
	public List<TransferCourseTitle> getTransferCourseTitlesByTransferCourseId(String transferCourseId);
	public TransferCourseTitle getTransferCourseTitleById(String id);
	public void addTransferCourseTitle(TransferCourseTitle tct);
	
	public TransferCourseTitle getTransferCourseTitleByCourseIdAndTitle(String trCourseId, String title);
	public TransferCourseTitle getNotEvaluatedTransferCourseTitleByCourseIdAndTitle(String trCourseId, String title);
	public TransferCourseTitle courseTitlePresentInMain(String trCourseId, String titleId);
	public List<TransferCourse> getCourseByInstitutionIdAndString(String institutionId, String searchBy, String searchText);
	public void addCourseTranscript(CourseTranscript ct);
	public CourseTranscript getCourseTranscript(String transferCourseId);
	public void addTransferCourseTitles(List<TransferCourseTitle> tcts);
	public void removeTransferCourseTitles(List<TransferCourseTitle> courseTitleList);
	public List<MilitarySubject> getMilitarySubjectByTransferCourseId(String transferCourseId);
	public void addMilitarySubject(List<MilitarySubject> titleList);
	public void addMilitarySubjectPerTranscriptCourseSubject(MilitarySubject militarySubject);
	public void addTranscriptCourseSubjectList(List<TranscriptCourseSubject> transcriptCourseSubjectList);
	public List<TranscriptCourseSubject> getAllTranscriptCourseSubjectByStudentTranscriptCourseId(String studentTranscriptCourseId);
	public void removeTranscriptCourseSubjectList(List<TranscriptCourseSubject> transcriptCourseSubjectList);
	public MilitarySubject isMilitarySubjectExit(String subjectName,String transferCourseId);
	public TranscriptCourseSubject findTranscriptCourseSubjectByTranscriptCourseIdAndSubjectId(String subjectId, String studentTranscriptCourseId);
	public void addOrUpdateTranscriptCourseSubject(TranscriptCourseSubject transcriptCourseSubject);
	public void removeRejectedStudentTranscriptCourseSubjectMarkForDelection(
			List<TranscriptCourseSubject> tcsubjectRejectedListForDeletion);
	public MilitarySubject getMilitarySubjectById(String militarySubjectId);
	public TranscriptCourseSubject getTranscriptCourseSubjectById(String transcriptCourseSubjectId);
	
	/**
	 * Saves or updates a list of transcriptCourseSubjects that are passed
	 * @param transcriptCourseSubjectList
	 */
	public void saveOrUpdateTranscriptCourseSubjects(List<TranscriptCourseSubject> transcriptCourseSubjectList);
}
