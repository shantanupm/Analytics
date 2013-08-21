package com.ss.institution.service;

import java.util.HashMap;
import java.util.List;

import com.ss.course.value.TransferCourse;
import com.ss.evaluation.value.College;
import com.ss.evaluation.value.StudentInstitutionDegree;
import com.ss.evaluation.value.StudentInstitutionTranscript;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionAddress;
import com.ss.institution.value.InstitutionDegree;
import com.ss.institution.value.InstitutionMirror;
import com.ss.institution.value.InstitutionTranscript;
import com.ss.user.value.User;

/**
 * Service interface for operations on a {@link Institution}
 * @author binoy.mathew
 */
public interface InstitutionService {

	/**
	 * Retrieves the Institution by the id.
	 * @param institutionId
	 * @return
	 */
	public Institution getInstitutionById( String institutionId );
	
	/**
	 * Retrieves all the institutions in the database.
	 * @return
	 */
	public List<Institution> getAllInstitutions();

	public InstitutionDegree getInstitutionDegreeByInstituteIDAndDegreeName(
			String institutionId, String degreeName);
	
	/**
	 * Retrieves the Institution associated with the studentProgramEvaluation Id.
	 * @param studentProgramEvalId
	 * @return
	 */
	public Institution getInstitutionForStudentProgramEvaluation( String studentProgramEvalId );
	
	
	/**
	 * Retrieves the list of StudentInstitutionDegrees associated with the Transcript.
	 * @param studentInstitutionTranscript
	 * @return
	 */
	public List<StudentInstitutionDegree> getStudentInstitutionDegreeListForStudentInstitutionTranscript( StudentInstitutionTranscript studentInstitutionTranscript );
	
	public Institution getInstitutionByCodeTitle(String schoolCode, String instituteTitle);
	
	public void addInstitution(Institution institution);
	
	public InstitutionMirror addInstitutionMirror(Institution institution, String evaluatorId);
	
	public InstitutionMirror getInstitutionMirrorByInstitutionId(String institutionId);
	
	/**
	 * 
	 * @param institutionId
	 * @return list of Institution excluding the passed parameter institutionId
	 */
	public List<Institution> getAllInstitutions(String institutionId);
	
	public List<Institution> getAllNotEvalutedInstitutions();
	public List<Institution> getAllEvaluatedInstitutions();
	public List<Institution> getAllConflictInstitutions();
	
	public boolean schoolCodeExist(String schoolCode,String institutionId);
	public boolean schoolTitleExist(String schoolTitle,String institutionId);
	
	public boolean isInstitutionEvaluated(String institutionId);
	
	public Institution getInstitutionForEvaluation();
	
	public void markInstitutionMirrorAsCompleted(String institutionMirrorId);

	public void updateInstitutionMirror(Institution institution, String institutionMirrorId);

	public boolean isInstituteMirrorPresent(String institutionId);
	
	public InstitutionMirror getInstitutionMirrorById(String id);

	public List<Institution> getConflictInstitutionsWithConflictCourses(String searchBy, String searchText);

	public HashMap<String, Institution> getConflictInstitutionListFromMirrors(String institutionId);

	public void addInstitutionWithChilds(Institution institution);

	public List<Institution> getInstitutionsList(String searchBy, String searchText, String status, String byState);

	public int getConflictCount();

	public void skipInstitutionNCourse(String institutionId);
	
	public List<Institution> getInstitutionsForReassignment();
	
	public Institution setInstitutionWithTempMirrorEvaluators(String institutionId);
	
	public List<User> getAssignableEvaluatorsForInstitution(Institution i);
	
	public void reAssignInstitution(String institutionId, String fromId, String toId);

	public void removeInstitutionMirrors(String institutionId);

	public void addInstitutionTranscript(InstitutionTranscript it);

	public InstitutionTranscript getInstitutionTranscript(String institutionId);

	public List<Institution> getInstituteForState(String state);
	
	public List<Institution> getAllInstituteForEvaluation();
	
	public List<Institution> getInstituteForEvalutationForCurrentUserNotIn(String currenUserId,List<String> institutionIds);

	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptAwatingForIENotIn(
			List<String> institutionIds);

	public List<Institution> getInstitutionByState(String stateCode, String title);

	public List<InstitutionAddress> getInstitutionAddresses(String institutionId);

	public void addInstitutionAddress(InstitutionAddress institutionAddress);

	public InstitutionAddress getInstitutionAddress(String addressId);

	public boolean institutionInTranscriptExist(String studentId, String institutionId);

	public Institution getInstitutionByTitle(String instituteTitle);

	public int getEvaluationCount();

	public void resetConfirmByCheckedBy(String institutionId);
	
	public int getTotalEvaluated(String userId);
	
	public int getLast6MonthEvaluated(String userId);
	
	public int getLast7DaysEvaluated(String userId);
	
	public int getLast3MonthEvaluated(String userId);
	
	public int getTodaysEvaluated(String userId);

	public boolean institutionCodeExist(String institutionCode, String institutionId);
	
	public String getProcessedInstitutionCode(Institution institution);

	public List<College> getAllCollege();

	public void saveInstitution(Institution institution);

	public void updateInstitution(Institution institution);
	
	
}
