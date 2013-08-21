package com.ss.evaluation.service;

import java.util.Date;
import java.util.List;

import com.ss.common.util.StudentProgramInfo;
import com.ss.course.value.GCUDegree;
import com.ss.course.value.TransferCourse;
import com.ss.evaluation.dto.StudentInstitutionTranscriptSummary;
import com.ss.evaluation.value.ChartValueObject;
import com.ss.evaluation.value.Student;
import com.ss.evaluation.value.StudentInstitutionDegree;
import com.ss.evaluation.value.StudentInstitutionTranscript;
import com.ss.evaluation.value.StudentProgramEvaluation;
import com.ss.evaluation.value.StudentTranscriptCourse;
import com.ss.institution.value.Institution;
import com.ss.user.value.User;

/**
 * Service operations for evaluating courses.
 * @author binoy.mathew
 */
public interface EvaluationService {

	
	/**
	 * Creates a new Evaluation Entry.
	 * @param studentProgramEvaluation
	 * @param studentInstitutionDegree
	 * @param institution
	 * @param lastDateOfLastCourse
	 * @param isTranscriptOfficial
	 * @param sit TODO
	 */
	public void createEvaluationForStudent( StudentProgramEvaluation studentProgramEvaluation, List<StudentInstitutionDegree> studentInstitutionDegree, Institution institution, Date expectedStartDate, Date lastDateOfLastCourse, Boolean isTranscriptOfficial, StudentInstitutionTranscript sit  );
	
	/**
	 * Saves the studentInstitutionTranscript to the database.
	 * @param studentInstitutionTranscript
	 */
	public void saveStudentInstitutionTranscript( StudentInstitutionTranscript studentInstitutionTranscript );
	
	/**
	 * Retrieves the list of StudentInstitutionTranscripts for this Student Program Evaluation along with the StudentInstitutionDegrees for that Transcript.
	 * @param studentProgramEvaluation
	 * @return 
	 */
	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptForStudentProgramEval( StudentProgramEvaluation studentProgramEvaluation );
	
	/**
	 * Retrieves the list of StudentInstitutionTranscripts for this Student Program Evaluation along with the StudentInstitutionDegrees for that Transcript. <br/>
	 * It will get only the most recent transcript for an Institution.
	 * @param studentProgramEvaluation
	 * @return 
	 */
	public List<StudentInstitutionTranscript> getLatestStudentInstitutionTranscriptForStudentProgramEval( StudentProgramEvaluation studentProgramEvaluation );
	
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
	
	public StudentProgramEvaluation getStudentProgramEvaluationById(String speId);
	public List<TransferCourse> getAllTransferCourseByInstitutionId(String sc);
	
	
	/**
	 * Retrieves a StudentProgramEvaluation record based on the Student CRM Id and ProgramVersionCode.
	 * @param studentCrmId
	 * @param programVersionCode
	 * @return
	 */
	public StudentProgramEvaluation getEvaluationForStudentCrmIdAndProgramCode( String studentCrmId, String programVersionCode );
	
	public StudentInstitutionTranscript getStudentInstitutionTranscriptForLOPES(String userId);	
	public StudentInstitutionTranscript getStudentInstitutionTranscriptForSLE(String userId);
	public boolean isTranscriptEligibleForLOPESOrSLE(StudentInstitutionTranscript sit);
	
	public boolean isTranscriptForIEM(StudentInstitutionTranscript sit);
	
	public List<StudentInstitutionTranscript> getAllSITListOrderByStatus();
	
	public StudentInstitutionTranscript getOldestREJECTEDSITByUser(User user);
	
	public List<StudentInstitutionTranscript> getAllRejectedSITByUser(User user);

	public void archiveTranscript(String studentId, String institutionId);

	public List<TransferCourse> getTransferCourseByInstitutionIdAndString(
			String institutionId, String courseCode);

	List<StudentInstitutionTranscript> getAllSITList(String status, String crmId);

	public StudentProgramEvaluation getEvaluationForStudentByCrmId(String studentCrmId);

	public int getTotalTranscripts(String userId);

	public int getLastMonthTranscripts(String userId);

	public int getLast7DaysTranscripts(String userId);

	public int getTodaysTranscripts(String userId);

	public List<ChartValueObject> getChartValues(String userId);
	
	public void createStudentInstitutionDegrees( StudentProgramEvaluation studentProgramEvaluation, List<StudentInstitutionDegree> studentInstitutionDegrees, 
			Institution institution,Date lastDateOfLastCourse, StudentInstitutionTranscript studentInstitutionTranscript);

	public StudentInstitutionTranscript createTranscriptForStudent(
			Student student,
			List<StudentInstitutionDegree> sids, Institution institution,
			Date expectedStartDate, Date ldlc, Boolean isTranscriptOfficial,
			StudentInstitutionTranscript sit);

	public List<StudentInstitutionTranscript> getLatestStudentInstitutionTranscriptForStudent(Student student);

	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptForStudent(Student student);
	
	public List<StudentInstitutionTranscriptSummary> getStudentTranscriptSummary(Student student);

	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptForStudentAndInstitute(String studentId, String institutionId);

	public StudentInstitutionTranscript getOldestStudentInstitutionTranscriptForStudentAndInstitute(String studentId, String institutionId,boolean markCompleted);

	//public List<StudentInstitutionTranscript> getAllTranscriptForStudentAndInstitute(String studentId, String institutionId,boolean transcriptType);

	public boolean isTranscriptEligibleForLOPESOrSLEForEvaluation(StudentInstitutionTranscript sit);

	public List<StudentInstitutionTranscript> getDistinctRejectedSITByUser(User user);

	public List<StudentInstitutionTranscript> getAllRejectedSITByUserForStudentAndInstitute(String studentId, String instituteId, User currentUser);

	public List<StudentTranscriptCourse> getAllRejectedSTCByUserForStudentAndInstitute(
			String studentInstitutionTranscriptId, String studentId, String institutionId, User currentUser);

	public List<StudentInstitutionTranscript> getAllTranscriptForStudentAndInstitute(
			String studentId, String institutionId, boolean transcriptType, String evaluationStatus);

	public StudentInstitutionTranscript getOldestStudentInstitutionTranscriptAlreadyOccupyByUser(String OccupyById, String evaluationStatus);
	
	public StudentInstitutionTranscript getNextOldestStudentInstitutionTranscriptAlreadyOccupyByUser(Date createdDate, String transcriptIds);

	public List<GCUDegree> getGCUInsitutionDegree();

	public StudentInstitutionTranscript createMilitaryTranscriptForStudent(Student student, Institution institution, Date expectedStartDate,Boolean isTranscriptOfficial,StudentInstitutionTranscript studentInstitutionTranscript);

	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptListForSLE(
			String id);
	
}
