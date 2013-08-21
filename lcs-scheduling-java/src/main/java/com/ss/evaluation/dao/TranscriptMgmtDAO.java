package com.ss.evaluation.dao;

import java.io.Serializable;
import java.util.List;

import com.ss.common.dao.BaseDAO;
import com.ss.evaluation.value.*;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionTranscriptKey;
import com.ss.institution.value.InstitutionTranscriptKeyDetails;



/**
 * DAO Interface for operations on a {@link Institution}
 * @author binoy.mathew
 */
public interface TranscriptMgmtDAO extends BaseDAO<StudentTranscriptCourse, Serializable> {
	
	public StudentTranscriptCourse getTranscriptById( String transcriptId );
	public InstitutionTranscriptKey getTranscriptKeyById( String instTranscriptKeyId );
	public List<InstitutionTranscriptKeyDetails> getTranscriptKeyDetailsByTranscriptKeyId( String instTranscriptKeyId );
	public List<StudentTranscriptCourse> getTranscriptByStudentProgEvalId(String studentProgEvalId, String institutionId);
	public void putTranscriptKey(InstitutionTranscriptKey tk);
	
	
	
	public List<StudentTranscriptCourse> getAllTranscripts();
	public List<StudentTranscriptCourse> getAllTranscriptsById(String studentId);
	public void putTranscript(StudentTranscriptCourse s);	
	public void putStudentInstitutionDegreeAssoc(StudentInstitutionDegree sid);
	public StudentInstitutionDegree getStudentInstituteDegreeDetails(String sid);
	
	/**
	 * Deletes the StudentTranscriptCourses from its table.
	 * @param studentTranscriptCourseList
	 */
	public void removeStudentTranscriptCourses( List<StudentTranscriptCourse> studentTranscriptCourseList );
	
	/**
	 * Deletes the StudentInstitutionDegree List.
	 * @param studentInstitutionDegreeList
	 */
	public void removeStudentInstitutionDegreeList( List<StudentInstitutionDegree> studentInstitutionDegreeList );
	/**
	 * Saves the StudentTranscriptCourse list to database.
	 * @param studentTranscriptList
	 */
	public void saveTranscriptList(  List<StudentTranscriptCourse> studentTranscriptList  );
	
	/**
	 * Retrieves the List of all Transfer Courses for this studentInstitutionTranscriptId.
	 * @param studentInstitutionTranscriptId
	 * @param institutionId TODO
	 * @return
	 */
	public List<StudentTranscriptCourse> getStudentTranscriptCoursesByTranscriptId( String studentInstitutionTranscriptId, String institutionId );
	
	/**
	 * Retrieves the list of Student Institution Degrees based on the Student Institution Transcript Id.
	 * @param studentInstitutionTranscriptId
	 * @return
	 */
	public List<StudentInstitutionDegree> getStudentInstitutionDegreeListForStudentInstitutionTranscript( String studentInstitutionTranscriptId );
	
	/**
	 * Persists the list of StudentInstitutionDegrees.
	 * @param studentInstitutionDegreeList
	 */
	public void saveStudentInstitutionDegreeList( List<StudentInstitutionDegree> studentInstitutionDegreeList );
	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptForStudentAndInstitute(
			String studentId, String institutionId);
	public List<StudentInstitutionDegree> getStudentInstitutionDegreeListForTranscriptAndInstitute(String studentId,String institutionId);
	public StudentInstitutionTranscript findOldestStudentInstitutionTranscriptForStudentAndInstitute(String studentId, String institutionId,boolean markCompleted);
	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptForStudentAndInstituteForTranscriptTypeWithEvaluationStatus(String studentId, String institutionId, boolean transcriptType, String evaluationStatus);
	public void removeRejectedStudentTranscriptCourseMarkForDelection(
			List<StudentTranscriptCourse> stcRejectedListForDeletion);
	public List<StudentTranscriptCourse> findStudentTranscriptCoursesByTranscriptIdForStudentAndInstitution(
			String studentInstitutionTranscriptId, String studentId,
			String institutionId);
	public List<StudentInstitutionDegree> findStudentInstitutionDegreeListForStudentTranscriptAndInstitute(String studentInstitutionTranscriptId, String institutionId);
	public List<StudentTranscriptCourse> findAllStudentTranscriptCourseByTransferCourseIdAndInstitutionId(
			String transferCourseId, String institutionId);
	public void updateAllRespectiveCoursesForStudent(String courseMappingId,String transferCourseId,
			String studentId, String instituteId);
	public void updateAllRespectiveCoursesCategoryForStudent(String coursesCategoryMappingId, String transferCourseId,
			String studentId, String instituteId);
	public void updateRespectiveSubjectCoursesForStudent(
			String courseMappingId, String subjectId, String transcriptCourseId,
			String studentId, String instituteId);
	public void updateAllRespectiveCoursesCategoryForStudent(
			String courseCategoryMappingId, String subjectId, String transcriptCourseId,
			String studentId, String instituteId);
	public void saveSLES(List<SleCollege> sleCollegeList);
	public List<SleCollege> findAllSLEForCollegeCode(String collegeCode);
	public void deleteAllSLEAssignToCollegeCode(String collegeCode);
	public void resetStudentInstitutionTranscriptForCollegeCode(
			String collegeCode);
}
