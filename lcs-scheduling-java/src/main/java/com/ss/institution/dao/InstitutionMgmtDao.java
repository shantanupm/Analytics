package com.ss.institution.dao;

import java.io.Serializable;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import com.ss.common.dao.BaseDAO;
import com.ss.evaluation.value.*;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionAddress;
import com.ss.institution.value.InstitutionDegree;
import com.ss.institution.value.InstitutionTranscript;


/**
 * DAO Interface for operations on a {@link Institution}
 * @author binoy.mathew
 */
public interface InstitutionMgmtDao extends BaseDAO<Institution, Serializable> {
	
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
	
	/**
	 * Persists the InstitutionDegree.
	 * @param institutionDegree
	 */
	public void saveInstitutionDegree( InstitutionDegree institutionDegree );
	
	/**
	 * Persists the StudentInstitutionDegree.
	 * @param studentInstitutionDegree
	 */
	public void saveStudentInstitutionDegree( StudentInstitutionDegree studentInstitutionDegree );
	
	
	/**
	 * Retrieves the Institution associated with the studentProgramEvaluation Id.
	 * @param studentCrmId
	 */
	public Institution getInstitutionForStudentProgramEvaluation( String studentProgramEvalId );
	
	/**
	 * Retrieves the list of StudentInstitutionDegrees associated with the Transcript.
	 * @param studentInstitutionTranscript
	 * @return
	 */
	public List<StudentInstitutionDegree> getStudentInstitutionDegreeListForStudentInstitutionTranscript( StudentInstitutionTranscript studentInstitutionTranscript );
	
	public List<Institution> findByPartSchoolCode(String sc);
	public List<Country> getAllCountries();
	
	public void addInstitution(Institution i);
	
	public void addCountry(Country c);

	public InstitutionDegree getInstitutionDegreeByInstituteIDAndDegreeName(
			String institutionId, String degreeName);
	public List<StudentInstitutionDegree> getStudentInstitutionDegreeList(String programEvaluationId);
	
	public Institution getInstitutionByCodeTitle(String schoolCode, String instituteTitle);
	
	/**
	 * 
	 * @param institutionId
	 * @return list of Institution excluding the passed parameter institutionId
	 */
	public List<Institution> getAllInstitutions(String institutionId);
	
	public List<Institution> getAllNotEvalutedInstitutions();
	
	public boolean schoolCodeExist(String schoolCode,String institutionId);
	public boolean schoolTitleExist(String schoolTitle,String institutionId);
	
	public Institution getOldestUnEvaluatedInstitution();
	public List<Institution> getNotEvaluatedInstitutionListForJob();

	public List<Institution> getAllConflictInstitutions();
	
	public List<Institution> getAllEvaluatedInstitutions();

	public List<Institution>  getInstitutionsList(String searchBy, String searchText,String status, String byState);

	public void skipInstitutionNCourse(String institutionId);
	
	public List<Institution> getInstitutionsForReassignment();
	
	public void reAssignCoursesOfInstitution(String institutionId, String toId, String fromId);

	public InstitutionTranscript getInstitutionTranscript(String institutionId);

	public void addInstitutionTranscript(InstitutionTranscript it);

	public List<Institution> findInstituteForState(String state);
	
	public List<Institution> findInstituteForEvalutationForCurrentUserNotIn(String currenUserId,List<String> institutionIds);

	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptAwatingForIENotIn(
			List<String> institutionIds);

	

	public List<Institution> getInstitutionByState(String stateCode, String title);

	public List<InstitutionAddress> getInstitutionAddresses(String institutionId);

	public void addInstitutionAddress(InstitutionAddress institutionAddress);

	public InstitutionAddress getInstitutionAddress(String addressId);

	public boolean institutionInTranscriptExist(String studentId, String institutionId);

	public Institution getInstitutionByTitle(String instituteTitle);
	
	public void resetConfirmByCheckedBy(String institutionId);

	public int getTotalEvaluated(String userId);
	
	public int getLast6MonthEvaluated(String userId);
	
	public int getLast7DaysEvaluated(String userId);
	
	public int getLast3MonthEvaluated(String userId);
	
	public int getTodaysEvaluated(String userId);

	public Institution getAssignedInstitution();

	public boolean institutionCodeExist(String institutionCode, String institutionId);

	public List<College> findAllCollege();

	public void saveInstitution(Institution institution);

	public void updateInstitution(Institution institution);

	public Student getLastStudentbyInstitutionId(String institutionId);
}
