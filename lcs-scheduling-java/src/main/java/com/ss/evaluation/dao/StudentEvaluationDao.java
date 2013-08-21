package com.ss.evaluation.dao;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import com.ss.common.dao.BaseDAO;
import com.ss.course.value.GCUDegree;
import com.ss.evaluation.value.ChartValueObject;
import com.ss.evaluation.value.Student;
import com.ss.evaluation.value.StudentInstitutionTranscript;
import com.ss.evaluation.value.StudentProgramEvaluation;
import com.ss.evaluation.value.StudentTranscriptCourse;
import com.ss.user.value.User;

/**
 * Dao interface for operations on Student evaluations.
 */
public interface StudentEvaluationDao extends BaseDAO<StudentProgramEvaluation, Serializable>  {

	/**
	 * Creates a new StudentProgramEvaluation record.
	 * 
	 * @param studentProgramEvaluation
	 */
	public void saveStudentProgramEvaluation( StudentProgramEvaluation studentProgramEvaluation );
	
	/**
	 * Retrieves a StudentProgramEvaluation record based on the Student CRM Id and ProgramVersionCode.
	 * @param studentCrmId
	 * @param programVersionCode 
	 * @return
	 */
	public StudentProgramEvaluation getEvaluationForStudentCrmIdAndProgramCode( String studentCrmId, String programVersionCode );
	
	/**
	 * Saves the studentInstitutionTranscript to the database.
	 * @param studentInstitutionTranscript
	 */
	public void saveStudentInstitutionTranscript( StudentInstitutionTranscript studentInstitutionTranscript );
	
	/**
	 * Retrieves the list of StudentInstitutionTranscripts for this Student Program Evaluation ordered by creation time.
	 * @param studentProgramEvaluation
	 * @return
	 */
	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptForStudentProgramEval( StudentProgramEvaluation studentProgramEvaluation );
	
	/**
	 * Retrieves the StudentInstitutionTranscripts for this student and institution.
	 * @param studentId
	 * @param institutionId
	 * @return
	 */
	public StudentInstitutionTranscript getStudentInstitutionTranscriptForStudentAndInstitution( String studentId, String institutionId );
	
	/**
	 * Retrieves the StudentInstitutionTranscript List for this student and institution.
	 * @param studentId
	 * @param institutionId
	 * @return
	 */
	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptListForStudentAndInstitution( String studentId, String institutionId );
	
	/**
	 * Retrieves the StudentInstitutionTranscripts by Id.
	 * @param studentInstitutionTranscriptId
	 * @return
	 */
	public StudentInstitutionTranscript getStudentInstitutionTranscriptById( String studentInstitutionTranscriptId );
	
	/**
	 * Removes the list of StudentInstitutionTranscript from the database.
	 * @param studentInstitutionTranscriptList
	 */
	public void removeStudentInstitutionTranscript( List<StudentInstitutionTranscript> studentInstitutionTranscriptList );
	
	public List<StudentInstitutionTranscript> getUnofficialStudentInstitutionTranscriptList();
	public List<StudentInstitutionTranscript> getOfficialStudentInstitutionTranscriptList();
	
	public List<StudentInstitutionTranscript> getAwaitingIEorIEMSITList();
	
	public StudentInstitutionTranscript getOldestSITForLOPES();
	
	public StudentInstitutionTranscript getOldestSITForSLE();
	
	public List<StudentInstitutionTranscript> getAllSITListOrderByStatus();
	
	/**
	 * Returns a list of all the rejected student institution transcripts entered by a user ordered by ascending order
	 * @param user
	 * @return
	 */
	public List<StudentInstitutionTranscript> getAllRejectedSITByUser(User user);

	public List<StudentInstitutionTranscript> getAllSITList(String status, String crmId);

	public StudentProgramEvaluation getEvaluationForStudentByCrmId(String studentCrmId);

	public int getTotalTranscripts(String userId);

	public int getLastMonthTranscripts(String userId);

	public int getLast7DaysTranscripts(String userId);

	public int getTodaysTranscripts(String userId);

	public List<ChartValueObject> getChartValues(String userId);

	public void mergeStudentInstitutionTranscript(
			StudentInstitutionTranscript sit);

	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptForStudent(Student student);

	public List<StudentInstitutionTranscript> findDistinctRejectedSITByUser(User user);

	public List<StudentInstitutionTranscript> findAllRejectedSITByUserForStudentAndInstitute(String studentId, String instituteId, User currentUser);

	public List<StudentTranscriptCourse> findAllRejectedSTCByUserForStudentAndInstitute(
			String studentInstitutionTranscriptId, String studentId,
			String institutionId, User currentUser);

	public StudentInstitutionTranscript findOldestStudentInstitutionTranscriptAlreadyOccupyByUser(String occupyById, String evaluationStatus);
	
	public StudentInstitutionTranscript findNextOldestStudentInstitutionTranscriptAlreadyOccupyByUser(Date createdDate, String transcriptIds);

	public StudentInstitutionTranscript findOldestSITForSLEWhichhaveCourses(String userId);

	public StudentInstitutionTranscript findOldestSITForLOPESWhichhaveCourses(String userId);

	public List<GCUDegree> findGCUInsitutionDegree();

	public List<StudentTranscriptCourse> getAllNotEvaluatedStudentTranscriptCourses(String studentId,String institutionId,boolean isOfficial,boolean statusInclude);

	public List<StudentInstitutionTranscript> getAllMarkCompletedSITForStudentAndInstitute(String studentId,
			String institutionId);

	public List<StudentInstitutionTranscript> findOldestSITListForSLEWhichhaveCourses(
			String userId);
}
