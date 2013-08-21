package com.ss.evaluation.service;

import java.util.List;

import com.ss.evaluation.value.SleCollege;
import com.ss.evaluation.value.StudentInstitutionDegree;
import com.ss.evaluation.value.StudentInstitutionTranscript;
import com.ss.evaluation.value.StudentTranscriptCourse;
import com.ss.institution.value.InstitutionTranscriptKey;
import com.ss.institution.value.InstitutionTranscriptKeyDetails;


public interface TranscriptService{
	public StudentTranscriptCourse getTranscriptById( String transcriptId );
	public InstitutionTranscriptKey getTranscriptKeyById( String instTranscriptKeyId );
	public List<InstitutionTranscriptKeyDetails> getTranscriptKeyDetailsByTranscriptKeyId( String instTranscriptKeyId );
	public List<StudentTranscriptCourse> getTranscriptByStudentProgEvalId(String studentProgEvalId, String institutionId);
	public void putTranscriptKey(InstitutionTranscriptKey tk);
	
	public List<StudentTranscriptCourse> getAllTranscripts();
	public List<StudentTranscriptCourse> getAllTranscriptsById(String studentId);
	public void putTranscript(StudentTranscriptCourse s);	
	public void putStudentInstitutionDegreeAssoc(StudentInstitutionDegree sid);
	public List<StudentInstitutionDegree> getStudentInstitutionDegreeList(String programEvaluationId);
	public StudentInstitutionDegree getStudentInstituteDegreeDetails(String sid);
	public void saveStudentTranscripts(List<StudentTranscriptCourse> stList);
	
	/**
	 * Deletes and adds new Transcript Courses for a Student Institution Transcript.
	 * @param studentInstitutionTranscript
	 * @param studentProgramEvalList
	 */
	public void saveNewDraftTranscriptsForStudentInstitutionTranscript( StudentInstitutionTranscript studentInstitutionTranscript,  List<StudentTranscriptCourse> studentTranscriptList  );
	
	
	/**
	 * Deletes and adds new Transcript Courses for a Student Institution Transcript. Also sets the status of the Student Institution Transcript to Complete.
	 * @param studentInstitutionTranscriptId
	 * @param studentProgramEvalList
	 */
	public void saveTranscriptsForStudentInstitutionTranscript( String studentInstitutionTranscriptId,  List<StudentTranscriptCourse> studentTranscriptList  );
	
	
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
	
	public void saveTranscriptsForStudentInstitutionTranscriptasMarkComplete(
			StudentInstitutionTranscript studentInstitutionTranscript, List<StudentTranscriptCourse> studentTranscriptList,String comment);
	public List<StudentInstitutionDegree> getStudentInstitutionDegreeListForTranscriptAndInstitute(String studentId,String institutionId);
	public void saveRejectedTranscriptsForStudentInstitutionTranscriptasMarkComplete(
			StudentInstitutionTranscript studentInstitutionTranscript,
			List<StudentTranscriptCourse> studentTranscriptList,List<StudentInstitutionDegree> studentInstitutionDegreeList);
	public void removeRejectedStudentTranscriptCourseMarkForDelection(
			List<StudentTranscriptCourse> stcRejectedListForDeletion);
	public List<StudentTranscriptCourse> getStudentTranscriptCoursesByTranscriptIdForStudentAndInstitution(String studentInstitutionTranscriptId, String studentId, String institutionId);
	public List<StudentInstitutionDegree> getStudentInstitutionDegreeListForStudentTranscriptAndInstitute(String studentInstitutionTranscriptId, String institutionId);
	
	public List<StudentTranscriptCourse> getAllStudentTranscriptCourseByTransferCourseIdAndInstitutionId(String transferCourseId, String institutionId);
	public void updateAllRespectiveCoursesForStudent(String CourseMappingId,String transferCourseId, String studentId,
			String instituteId);
	public void updateAllRespectiveCoursesCategoryForStudent(String coursesCategoryMappingId,String transferCourseId, String studentId,
			String instituteId);
	public void saveNewDraftMilitaryTranscriptsForStudentInstitutionTranscript(
			StudentInstitutionTranscript studentInsTrans,
			List<StudentTranscriptCourse> studentTranscriptList);
	public void saveMilitaryTranscriptsForStudentInstitutionTranscriptAsMarkComplete(
			StudentInstitutionTranscript studentInstitutionTranscript,
			List<StudentTranscriptCourse> studentTranscriptList,
			String oldStudentInstitutionTranscriptId);
	public void updateRespectiveSubjectCoursesForStudent(String courseMappingId,
			String subjectId, String transferCourseId, String studentId, String instituteId);
	public void updateAllRespectiveCoursesCategoryForStudent(String courseCategoryMappingId,
			String subjectId, String transferCourseId, String studentId, String instituteId);
	public void saveRejectedMilitaryTranscriptsForStudentInstitutionTranscriptAsMarkComplete(
			StudentInstitutionTranscript studentInstitutionTranscript,
			List<StudentTranscriptCourse> studentTranscriptList,
			List<StudentInstitutionDegree> sids);
	
	/**
	 * Returns a list of StudentTranscriptCourses with the corresponding GCU Course or Category Mappings in it. Makes sense to use it only 
	 * in cases where the transcript is already evaluated
	 * @param transcriptId
	 * @return
	 */
	public List<StudentTranscriptCourse> getStudentTranscriptCoursesWithCourseMappingDetailsByTranscriptId(String transcriptId);
	public void saveSLES(List<SleCollege> sleCollegeList);
	public List<SleCollege> getAllSLEForCollegeCode(String collegeCode);
	public void deleteAllSLEAssignToCollegeCode(String collegeCode);
	public void resetStudentInstitutionTranscriptForCollegeCode(
			String collegeCode, List<SleCollege> sleCollegeList);
}