package com.ss.evaluation.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ss.common.util.UserUtil;
import com.ss.course.value.MilitarySubject;
import com.ss.evaluation.dao.TranscriptMgmtDAO;
import com.ss.evaluation.dao.TransferCourseMgmtDAO;
import com.ss.evaluation.enums.TranscriptStatusEnum;
import com.ss.evaluation.value.SleCollege;
import com.ss.evaluation.value.Student;
import com.ss.evaluation.value.StudentInstitutionDegree;
import com.ss.evaluation.value.StudentInstitutionTranscript;
import com.ss.evaluation.value.StudentTranscriptCourse;
import com.ss.evaluation.value.TranscriptComments;
import com.ss.evaluation.value.TranscriptCourseSubject;
import com.ss.institution.dao.InstitutionMgmtDao;
import com.ss.institution.value.InstitutionDegree;
import com.ss.institution.value.InstitutionTranscriptKey;
import com.ss.institution.value.InstitutionTranscriptKeyDetails;




/**
 * Service Implementation for the {@link EvaluationService}.
 * @author binoy.mathew
 */
@Service
public class TranscriptServiceImpl implements TranscriptService {

	@Autowired
	private InstitutionMgmtDao institutionMgmtDao;
	
	@Autowired
	private EvaluationService evaluationService;
	
	@Autowired
	private TranscriptMgmtDAO transcriptMgmtDAO;
	
	@Autowired
	private TranscriptCommentService transcriptCommentService; 
	
	@Autowired
	private TransferCourseService transferCourseService;
	
	@Autowired
	private TransferCourseMgmtDAO transferCourseMgmtDAO;
	
	@Override
	@Transactional
	public void saveNewDraftTranscriptsForStudentInstitutionTranscript( StudentInstitutionTranscript studentInstitutionTranscript,  List<StudentTranscriptCourse> studentTranscriptList  ) {
		List<StudentTranscriptCourse> listExistingTranscripts = getStudentTranscriptCoursesByTranscriptId( studentInstitutionTranscript.getId(), studentInstitutionTranscript.getInstitution().getId() );
		List<StudentTranscriptCourse> listOfTranscriptsCoursesWithNotMarkeCompleted =  new ArrayList<StudentTranscriptCourse>();
		if(listExistingTranscripts!=null && listExistingTranscripts.size()>0){
			for(StudentTranscriptCourse studentTranscriptCourse : listExistingTranscripts){
				if(!studentTranscriptCourse.isMarkCompleted()){
					listOfTranscriptsCoursesWithNotMarkeCompleted.add(studentTranscriptCourse);
				}
			}
		}
		if( listOfTranscriptsCoursesWithNotMarkeCompleted != null && listOfTranscriptsCoursesWithNotMarkeCompleted.size() > 0 ) {
			transcriptMgmtDAO.removeStudentTranscriptCourses( listOfTranscriptsCoursesWithNotMarkeCompleted );
		}
		if(studentTranscriptList!=null && studentTranscriptList.size()>0){
			transcriptMgmtDAO.saveTranscriptList( studentTranscriptList );
		}
	}
	
	@Override
	@Transactional
	public void saveTranscriptsForStudentInstitutionTranscript( String studentInstitutionTranscriptId,  List<StudentTranscriptCourse> studentTranscriptList  ) {
		boolean institutionFlag=false,courseFlag = true,officialFlag=false,campusViewIdPresent=true;
		StudentInstitutionTranscript studentInstitutionTranscript = evaluationService.getStudentInstitutionTranscriptById( studentInstitutionTranscriptId );
		List<StudentTranscriptCourse> listExistingTranscripts = getStudentTranscriptCoursesByTranscriptId( studentInstitutionTranscriptId, studentInstitutionTranscript.getInstitution().getId() );
		if( listExistingTranscripts != null && listExistingTranscripts.size() > 0 ) {
			transcriptMgmtDAO.removeStudentTranscriptCourses( listExistingTranscripts );
		}

		if(studentInstitutionTranscript.getInstitution().getEvaluationStatus()!=null){
			if(studentInstitutionTranscript.getInstitution().getEvaluationStatus().equalsIgnoreCase("Evaluated"))
				institutionFlag=true;
			
		}
		if(studentInstitutionTranscript.getOfficial()!=null)
			officialFlag=studentInstitutionTranscript.getOfficial();
		
			
		
		for(StudentTranscriptCourse st:studentTranscriptList){
			if(!(st.getTransferCourse().getEvaluationStatus().equalsIgnoreCase("Evaluated"))){
				courseFlag=false;
				break;
			}
		}
			
		
		String evaluationStatus=""; 
		if(!institutionFlag || !courseFlag){
			evaluationStatus=TranscriptStatusEnum.AWAITINGIE.getValue() ;
		}else if(institutionFlag && courseFlag && !officialFlag){
			evaluationStatus=TranscriptStatusEnum.AWAITINGLOPE.getValue() ;
		}else if(institutionFlag && courseFlag && officialFlag && campusViewIdPresent){
			evaluationStatus=TranscriptStatusEnum.AWAITINGSLE.getValue() ;
		}
		studentInstitutionTranscript.setEvaluationStatus(evaluationStatus);
		
		
		transcriptMgmtDAO.saveTranscriptList( studentTranscriptList );
		evaluationService.saveStudentInstitutionTranscript( studentInstitutionTranscript );
	}
	
	@Override
	public void removeStudentTranscriptCourses( List<StudentTranscriptCourse> studentTranscriptCourseList ) {
		transcriptMgmtDAO.removeStudentTranscriptCourses( studentTranscriptCourseList );
	}
	
	@Override
	public void removeStudentInstitutionDegreeList( List<StudentInstitutionDegree> studentInstitutionDegreeList ) {
		transcriptMgmtDAO.removeStudentInstitutionDegreeList( studentInstitutionDegreeList );
	}
	
	@Override
	public List<StudentTranscriptCourse> getStudentTranscriptCoursesByTranscriptId( String studentInstitutionTranscriptId, String institutionId ) {
		return transcriptMgmtDAO.getStudentTranscriptCoursesByTranscriptId( studentInstitutionTranscriptId, institutionId );
	}


	@Override
	public List<StudentInstitutionDegree> getStudentInstitutionDegreeListForStudentInstitutionTranscript( String studentInstitutionTranscriptId ) {
		return transcriptMgmtDAO.getStudentInstitutionDegreeListForStudentInstitutionTranscript( studentInstitutionTranscriptId );
	}
	
	@Override
	public StudentTranscriptCourse getTranscriptById(String transcriptId) {
		// TODO Auto-generated method stub
		return transcriptMgmtDAO.getTranscriptById(transcriptId);
	}

	@Override
	public InstitutionTranscriptKey getTranscriptKeyById(
			String instTranscriptKeyId) {
		// TODO Auto-generated method stub
		return transcriptMgmtDAO.getTranscriptKeyById(instTranscriptKeyId);
	}

	@Override
	public List<InstitutionTranscriptKeyDetails> getTranscriptKeyDetailsByTranscriptKeyId(
			String instTranscriptKeyId) {
		// TODO Auto-generated method stub
		return transcriptMgmtDAO.getTranscriptKeyDetailsByTranscriptKeyId(instTranscriptKeyId);
	}

	@Override
	public List<StudentTranscriptCourse> getTranscriptByStudentProgEvalId(String studentProgEvalId, String institutionId) {
		
		return transcriptMgmtDAO.getTranscriptByStudentProgEvalId(studentProgEvalId, institutionId);
	}

	@Override
	public void putTranscriptKey(InstitutionTranscriptKey tk) {
		// TODO Auto-generated method stub
		transcriptMgmtDAO.putTranscriptKey(tk);
	}

	

	

	

	@Override
	public List<StudentTranscriptCourse> getAllTranscripts() {
		// TODO Auto-generated method stub
		return transcriptMgmtDAO.getAllTranscripts();
	}

	@Override
	public List<StudentTranscriptCourse> getAllTranscriptsById(String studentId) {
		// TODO Auto-generated method stub
		return transcriptMgmtDAO.getAllTranscriptsById(studentId);
	}

	@Override
	public void putTranscript(StudentTranscriptCourse s) {
		// TODO Auto-generated method stub
		transcriptMgmtDAO.putTranscript(s);
	}

	@Override
	public void putStudentInstitutionDegreeAssoc(StudentInstitutionDegree sid) {
		// TODO Auto-generated method stub
		transcriptMgmtDAO.putStudentInstitutionDegreeAssoc(sid);
	}

	@Override
	public StudentInstitutionDegree getStudentInstituteDegreeDetails(String sid) {
		// TODO Auto-generated method stub
		return transcriptMgmtDAO.getStudentInstituteDegreeDetails(sid);
	}

	@Override
	public void saveStudentTranscripts(List<StudentTranscriptCourse> stList) {
		for (StudentTranscriptCourse studentTranscript : stList) {
			//This logic will be changed after transcript key is introduced.
			if(studentTranscript.getGrade() == null){
				studentTranscript.setGcuRequirementMet(true);
			}else if(studentTranscript.getGrade() !=null && studentTranscript.getGrade().equals("F")||studentTranscript.getGrade().equals("I")||studentTranscript.getGrade().equals("W") ){
				studentTranscript.setGcuRequirementMet(false);
			}else{
				studentTranscript.setGcuRequirementMet(true);
			}
			putTranscript(studentTranscript);
		}
	}

	@Override
	public List<StudentInstitutionDegree> getStudentInstitutionDegreeList(
			String programEvaluationId) {
		// TODO Auto-generated method stub
		return institutionMgmtDao.getStudentInstitutionDegreeList(programEvaluationId);
	}
	
	@Override
	public void saveStudentInstitutionDegreeList( List<StudentInstitutionDegree> studentInstitutionDegreeList ) {
		transcriptMgmtDAO.saveStudentInstitutionDegreeList( studentInstitutionDegreeList );
	}

	@Override
	@Transactional
	public void saveTranscriptsForStudentInstitutionTranscriptasMarkComplete(
			StudentInstitutionTranscript studentInstitutionTranscript,
			List<StudentTranscriptCourse> studentTranscriptList,String oldStudentInstitutionTranscriptId) {

		
	
		
		boolean institutionFlag=false,courseFlag = true,officialFlag=false,campusViewIdPresent=true;
		
		/*List<StudentTranscriptCourse> listExistingTranscripts = getStudentTranscriptCoursesByTranscriptId( studentInstitutionTranscriptId, studentInstitutionTranscript.getInstitution().getId() );
		if( listExistingTranscripts != null && listExistingTranscripts.size() > 0 ) {
			transcriptMgmtDAO.removeStudentTranscriptCourses( listExistingTranscripts );
		}*/

		if(studentInstitutionTranscript.getInstitution().getEvaluationStatus()!=null){
			if(studentInstitutionTranscript.getInstitution().getEvaluationStatus().equalsIgnoreCase("Evaluated"))
				institutionFlag=true;
			
		}
		if(studentInstitutionTranscript.getOfficial()!=null)
			officialFlag=studentInstitutionTranscript.getOfficial();
		
			
		
		for(StudentTranscriptCourse st:studentTranscriptList){
			if(!(st.getTransferCourse().getEvaluationStatus().equalsIgnoreCase("Evaluated"))){
				courseFlag=false;
				break;
			}
		}
			
		
		String evaluationStatus=""; 
		if(!institutionFlag || !courseFlag){
			evaluationStatus=TranscriptStatusEnum.AWAITINGIE.getValue() ;
		}else if(institutionFlag && courseFlag && !officialFlag){
			evaluationStatus=TranscriptStatusEnum.AWAITINGLOPE.getValue() ;
		}else if(institutionFlag && courseFlag && officialFlag && campusViewIdPresent){
			evaluationStatus=TranscriptStatusEnum.AWAITINGSLE.getValue() ;
		}
		studentInstitutionTranscript.setEvaluationStatus(evaluationStatus);
		
		StudentInstitutionTranscript sit1 = new StudentInstitutionTranscript(); 
		
		sit1.setInstitution( studentInstitutionTranscript.getInstitution() );
		sit1.setStudent(studentInstitutionTranscript.getStudent());
		//sit1.setStudentProgramEvaluation( studentInstitutionTranscript.getStudentProgramEvaluation() );
		sit1.setCreatedDate(new Date());
		sit1.setLastDateForLastCourse( studentInstitutionTranscript.getLastDateForLastCourse() );
		sit1.setEvaluationStatus( evaluationStatus );
		sit1.setOfficial( officialFlag );
		sit1.setCreatedBy(studentInstitutionTranscript.getCreatedBy());
		sit1.setModifiedBy(UserUtil.getCurrentUser().getId());
		sit1.setStudentInstitutionDegreeSet(studentInstitutionTranscript.getStudentInstitutionDegreeSet());
		sit1.setDateReceived(studentInstitutionTranscript.getDateReceived());
		sit1.setLastAttendenceDate(studentInstitutionTranscript.getLastAttendenceDate());
		sit1.setMarkCompleted(true);
		sit1.setInstitutionAddress(studentInstitutionTranscript.getInstitutionAddress()!=null ? studentInstitutionTranscript.getInstitutionAddress() : null);
		
		sit1.setStudentTranscriptCourse(studentInstitutionTranscript.getStudentTranscriptCourse());
		if(studentInstitutionTranscript.getCollegeCode()!=null){
			sit1.setCollegeCode(studentInstitutionTranscript.getCollegeCode());
		}
		
		evaluationService.saveStudentInstitutionTranscript( sit1 );
		//create the Degree for StudentInstitutionTranscript which MarkAsComplete
		List<StudentInstitutionDegree> studentInstitutionDegreeList = studentInstitutionTranscript.getStudentInstitutionDegreeSet();
		if (studentInstitutionDegreeList != null && studentInstitutionDegreeList.size() > 0) {
			
			for (StudentInstitutionDegree studentInstitutionDegree : studentInstitutionDegreeList) {

				InstitutionDegree insDegree = studentInstitutionDegree
						.getInstitutionDegree();
				if (insDegree == null) {
					insDegree = new InstitutionDegree();
				}
				insDegree.setInstitution(sit1.getInstitution());
				insDegree.setCreatedBy(UserUtil.getCurrentUser().getId());
				insDegree.setModifiedBy(UserUtil.getCurrentUser().getId());
				studentInstitutionDegree.setInstitutionDegree(insDegree);
				studentInstitutionDegree.setCreatedBy(UserUtil.getCurrentUser().getId());
				studentInstitutionDegree.setModifiedBy(UserUtil.getCurrentUser().getId());
				// studentInstitutionDegree.setStudentId( student.getId() );
				studentInstitutionDegree.setStudentInstitutionTranscript(sit1);
				if (studentInstitutionDegree.getInstitutionDegree() == null
						|| studentInstitutionDegree.getInstitutionDegree()
								.getId() == null) {
					institutionMgmtDao.saveInstitutionDegree(studentInstitutionDegree.getInstitutionDegree());
				}
				institutionMgmtDao.saveStudentInstitutionDegree(studentInstitutionDegree);
			}
		}
		
		for(StudentTranscriptCourse st:studentTranscriptList){
			st.setCreatedBy(UserUtil.getCurrentUser().getId());
			st.setModifiedBy(UserUtil.getCurrentUser().getId());
			st.setMarkCompleted(true);
			st.setStudentInstitutionTranscript(sit1);
		}
		
		if(studentTranscriptList!=null && studentTranscriptList.size()>0){
			transcriptMgmtDAO.saveTranscriptList( studentTranscriptList );
		}
		if(oldStudentInstitutionTranscriptId != null && !oldStudentInstitutionTranscriptId.isEmpty() && studentInstitutionTranscript.getInstitution() != null && !studentInstitutionTranscript.getInstitution().getId().isEmpty()){
			List<StudentTranscriptCourse> draftStudentTranscriptCourseList = transcriptMgmtDAO.getStudentTranscriptCoursesByTranscriptId( oldStudentInstitutionTranscriptId, studentInstitutionTranscript.getInstitution().getId() );
				if(draftStudentTranscriptCourseList!= null && !draftStudentTranscriptCourseList.isEmpty()){
					transcriptMgmtDAO.removeStudentTranscriptCourses(draftStudentTranscriptCourseList);
				}	
		}
		List<TranscriptComments> transcriptCommentsList =transcriptCommentService.getTranscriptComment(oldStudentInstitutionTranscriptId);
		if(transcriptCommentsList != null && !transcriptCommentsList.isEmpty()){
			for(TranscriptComments transcriptComments:transcriptCommentsList){
			
				transcriptComments.setTranscriptId(sit1.getId());
				transcriptCommentService.addTranscriptComment(transcriptComments);
			}
		}
	}

	@Override
	public List<StudentInstitutionDegree> getStudentInstitutionDegreeListForTranscriptAndInstitute(String studentId, String institutionId) {
		// TODO Auto-generated method stub
		return transcriptMgmtDAO.getStudentInstitutionDegreeListForTranscriptAndInstitute(studentId, institutionId) ;
	}
	@Override
	public void saveRejectedTranscriptsForStudentInstitutionTranscriptasMarkComplete(
			StudentInstitutionTranscript studentInstitutionTranscript,
			List<StudentTranscriptCourse> studentTranscriptList,List<StudentInstitutionDegree> sidsList) {
		boolean institutionFlag=false,courseFlag = true,officialFlag=false,campusViewIdPresent=true;
		
		/*List<StudentTranscriptCourse> listExistingTranscripts = getStudentTranscriptCoursesByTranscriptId( studentInstitutionTranscriptId, studentInstitutionTranscript.getInstitution().getId() );
		if( listExistingTranscripts != null && listExistingTranscripts.size() > 0 ) {
			transcriptMgmtDAO.removeStudentTranscriptCourses( listExistingTranscripts );
		}*/
		if(studentInstitutionTranscript.getStudentInstitutionDegreeSet() != null && studentInstitutionTranscript.getStudentInstitutionDegreeSet().size() > 0){
			removeStudentInstitutionDegreeList(studentInstitutionTranscript.getStudentInstitutionDegreeSet());
		}
		// Create new SIDs (along with new InstitutionDegrees when required).
		if (sidsList != null && sidsList.size() > 0) {
					for (StudentInstitutionDegree studentInstitutionDegree : sidsList) {

						InstitutionDegree insDegree = studentInstitutionDegree.getInstitutionDegree();
						if (insDegree == null) {
							insDegree = new InstitutionDegree();
						}
						insDegree.setInstitution(studentInstitutionTranscript.getInstitution());
						insDegree.setCreatedBy(UserUtil.getCurrentUser().getId());
						insDegree.setModifiedBy(UserUtil.getCurrentUser().getId());
						studentInstitutionDegree.setInstitutionDegree(insDegree);
						studentInstitutionDegree.setCreatedBy(UserUtil.getCurrentUser().getId());
						studentInstitutionDegree.setModifiedBy(UserUtil.getCurrentUser().getId());
						// studentInstitutionDegree.setStudentId( student.getId() );
						studentInstitutionDegree.setStudentInstitutionTranscript(studentInstitutionTranscript);
						if (studentInstitutionDegree.getInstitutionDegree() == null
								|| studentInstitutionDegree.getInstitutionDegree()
										.getId() == null) {
							institutionMgmtDao
									.saveInstitutionDegree(studentInstitutionDegree
											.getInstitutionDegree());
						}
						institutionMgmtDao
								.saveStudentInstitutionDegree(studentInstitutionDegree);
					}
				}
		if(studentInstitutionTranscript.getInstitution().getEvaluationStatus()!=null){
			if(studentInstitutionTranscript.getInstitution().getEvaluationStatus().equalsIgnoreCase(TranscriptStatusEnum.EVALUATED.getValue()))
				institutionFlag=true;
			
		}
		if(studentInstitutionTranscript.getOfficial()!=null)
			officialFlag=studentInstitutionTranscript.getOfficial();
		
			
		
		for(StudentTranscriptCourse st:studentTranscriptList){
			if(!(st.getTransferCourse().getEvaluationStatus().equalsIgnoreCase(TranscriptStatusEnum.EVALUATED.getValue()))){
				courseFlag=false;
				break;
			}
		}
			
		
		String evaluationStatus=""; 
		if(!institutionFlag || !courseFlag){
			evaluationStatus=TranscriptStatusEnum.AWAITINGIE.getValue() ;
		}else if(institutionFlag && courseFlag && !officialFlag){
			evaluationStatus=TranscriptStatusEnum.AWAITINGLOPE.getValue() ;
		}else if(institutionFlag && courseFlag && officialFlag && campusViewIdPresent){
			evaluationStatus=TranscriptStatusEnum.AWAITINGSLE.getValue() ;
		}
		
		studentInstitutionTranscript.setEvaluationStatus(evaluationStatus);
		
		studentInstitutionTranscript.setInstitution( studentInstitutionTranscript.getInstitution() );
		studentInstitutionTranscript.setStudent(studentInstitutionTranscript.getStudent());
		//sit1.setStudentProgramEvaluation( studentInstitutionTranscript.getStudentProgramEvaluation() );
		studentInstitutionTranscript.setModifiedDate(new Date());
		studentInstitutionTranscript.setLastDateForLastCourse( studentInstitutionTranscript.getLastDateForLastCourse() );
		studentInstitutionTranscript.setEvaluationStatus( evaluationStatus );
		studentInstitutionTranscript.setOfficial( officialFlag );
		studentInstitutionTranscript.setCreatedBy(studentInstitutionTranscript.getCreatedBy());
		studentInstitutionTranscript.setModifiedBy(UserUtil.getCurrentUser().getId());
		studentInstitutionTranscript.setStudentInstitutionDegreeSet(studentInstitutionTranscript.getStudentInstitutionDegreeSet());
		studentInstitutionTranscript.setDateReceived(studentInstitutionTranscript.getDateReceived());
		studentInstitutionTranscript.setLastAttendenceDate(studentInstitutionTranscript.getLastAttendenceDate());
		studentInstitutionTranscript.setMarkCompleted(true);
		studentInstitutionTranscript.setInstitutionAddress(studentInstitutionTranscript.getInstitutionAddress()!=null ? studentInstitutionTranscript.getInstitutionAddress() : null);
		
		studentInstitutionTranscript.setStudentTranscriptCourse(studentInstitutionTranscript.getStudentTranscriptCourse());
		
		if(studentInstitutionTranscript.getCollegeCode()!=null){
			studentInstitutionTranscript.setCollegeCode(studentInstitutionTranscript.getCollegeCode());
		}
		evaluationService.saveStudentInstitutionTranscript( studentInstitutionTranscript );
		
		for(StudentTranscriptCourse st:studentTranscriptList){
			st.setMarkCompleted(true);
			st.setStudentInstitutionTranscript(studentInstitutionTranscript);
		}
		if(studentTranscriptList!=null && studentTranscriptList.size()>0){
			transcriptMgmtDAO.saveTranscriptList( studentTranscriptList );
		}
		
		
	}
	@Override
	public void removeRejectedStudentTranscriptCourseMarkForDelection(
			List<StudentTranscriptCourse> stcRejectedListForDeletion) {
		transcriptMgmtDAO.removeRejectedStudentTranscriptCourseMarkForDelection(stcRejectedListForDeletion);		
	}
	@Override
	public List<StudentTranscriptCourse> getStudentTranscriptCoursesByTranscriptIdForStudentAndInstitution(
			String studentInstitutionTranscriptId, String studentId,
			String institutionId) {
		// TODO Auto-generated method stub
		return transcriptMgmtDAO.findStudentTranscriptCoursesByTranscriptIdForStudentAndInstitution(studentInstitutionTranscriptId,studentId,institutionId);
	}
	@Override
	public List<StudentInstitutionDegree> getStudentInstitutionDegreeListForStudentTranscriptAndInstitute(
			String studentInstitutionTranscriptId, String institutionId) {
		// TODO Auto-generated method stub
		return transcriptMgmtDAO.findStudentInstitutionDegreeListForStudentTranscriptAndInstitute(studentInstitutionTranscriptId,institutionId);
	}
	@Override
	public List<StudentTranscriptCourse> getAllStudentTranscriptCourseByTransferCourseIdAndInstitutionId(
			String transferCourseId, String institutionId) {
		
		return transcriptMgmtDAO.findAllStudentTranscriptCourseByTransferCourseIdAndInstitutionId(transferCourseId,institutionId);
		
	}
	@Override
	public void updateAllRespectiveCoursesForStudent(String courseMappingId,String transferCourseId,
			String studentId, String instituteId) {
		// TODO Auto-generated method stub
		transcriptMgmtDAO.updateAllRespectiveCoursesForStudent(courseMappingId,transferCourseId,studentId,instituteId);
	}
	@Override
	public void updateAllRespectiveCoursesCategoryForStudent(
			String coursesCategoryMappingId, String transferCourseId,
			String studentId, String instituteId) {
		// TODO Auto-generated method stub
		transcriptMgmtDAO.updateAllRespectiveCoursesCategoryForStudent(coursesCategoryMappingId,transferCourseId,studentId,instituteId);
	}
	@Override
	public void saveNewDraftMilitaryTranscriptsForStudentInstitutionTranscript(
			StudentInstitutionTranscript studentInstitutionTranscript,
			List<StudentTranscriptCourse> studentTranscriptList) {
		List<StudentTranscriptCourse> listExistingTranscripts = getStudentTranscriptCoursesByTranscriptId( studentInstitutionTranscript.getId(), studentInstitutionTranscript.getInstitution().getId() );
		List<StudentTranscriptCourse> listOfTranscriptsCoursesWithNotMarkeCompleted =  new ArrayList<StudentTranscriptCourse>();
		if(listExistingTranscripts!=null && listExistingTranscripts.size()>0){
			for(StudentTranscriptCourse studentTranscriptCourse : listExistingTranscripts){
				if(!studentTranscriptCourse.isMarkCompleted()){
					listOfTranscriptsCoursesWithNotMarkeCompleted.add(studentTranscriptCourse);
				}
			}
		}
		if( listOfTranscriptsCoursesWithNotMarkeCompleted != null && listOfTranscriptsCoursesWithNotMarkeCompleted.size() > 0 ) {
			for(StudentTranscriptCourse studentTranscriptCourse : listOfTranscriptsCoursesWithNotMarkeCompleted){
				List<TranscriptCourseSubject> transcriptCourseSubjectList = transferCourseService.getAllTranscriptCourseSubjectByStudentTranscriptCourseId(studentTranscriptCourse.getId());
				if(transcriptCourseSubjectList != null && !transcriptCourseSubjectList.isEmpty()){
					transferCourseMgmtDAO.removeTranscriptCourseSubjectList(transcriptCourseSubjectList);
				}
			}
		}
		if( listOfTranscriptsCoursesWithNotMarkeCompleted != null && listOfTranscriptsCoursesWithNotMarkeCompleted.size() > 0 ) {
			transcriptMgmtDAO.removeStudentTranscriptCourses( listOfTranscriptsCoursesWithNotMarkeCompleted );
		}
		if(studentTranscriptList!=null && studentTranscriptList.size()>0){
			for(StudentTranscriptCourse studentTranscriptCourse : studentTranscriptList){
				//First persist StudentTranscriptCourse
				transcriptMgmtDAO.putTranscript(studentTranscriptCourse);
				
				List<TranscriptCourseSubject> transcriptCourseSubjectList =  studentTranscriptCourse.getTranscriptCourseSubjectList();
				if(transcriptCourseSubjectList != null && !transcriptCourseSubjectList.isEmpty()){
					List<TranscriptCourseSubject> newTranscriptCourseSubjectList = new ArrayList<TranscriptCourseSubject>();
					for(TranscriptCourseSubject transcriptCourseSubject : transcriptCourseSubjectList){
						
						MilitarySubject militarySubject = transcriptCourseSubject.getMilitarySubject();	
						if(militarySubject != null && militarySubject.getName() != null && !militarySubject.getName().isEmpty()){							
							
							militarySubject.setTransferCourseId(studentTranscriptCourse.getTransferCourse().getId());
							if(militarySubject.getCreatedBy() != null && !militarySubject.getCreatedBy().isEmpty()){
								militarySubject.setCreatedBy(militarySubject.getCreatedBy());
							}
							if(militarySubject.getModifiedBy() != null && !militarySubject.getModifiedBy().isEmpty()){
								militarySubject.setCreatedBy(militarySubject.getModifiedBy());
							}
							if(militarySubject.getCreatedDate() != null){
								militarySubject.setCreatedDate(new Date());
							}
							militarySubject.setModifiedDate(new Date());
							MilitarySubject militarySubjectExist = transferCourseService.isMilitarySubjectExit(militarySubject.getName(),militarySubject.getTransferCourseId());
							if(militarySubjectExist != null && militarySubjectExist.getName() != null && !militarySubjectExist.getName().isEmpty()){
								militarySubject = militarySubjectExist;							
							}else{
								militarySubject.setCourseLevel(transcriptCourseSubject.getCourseLevel());
								transferCourseService.addMilitarySubjectPerTranscriptCourseSubject(militarySubject);
							}
							
							transcriptCourseSubject.setSubjectId(militarySubject.getId());
							transcriptCourseSubject.setTranscriptCourseId(studentTranscriptCourse.getId());
							if(transcriptCourseSubject.getCreatedBy() != null && !transcriptCourseSubject.getCreatedBy().isEmpty()){
								transcriptCourseSubject.setCreatedBy(UserUtil.getCurrentUser().getId());
							}
							if(transcriptCourseSubject.getModifiedBy() != null && !transcriptCourseSubject.getModifiedBy().isEmpty()){
								transcriptCourseSubject.setModifiedBy(UserUtil.getCurrentUser().getId());
							}
							if(transcriptCourseSubject.getCreatedDate() != null){
								transcriptCourseSubject.setCreatedDate(new Date());
							}
							transcriptCourseSubject.setModifiedDate(new Date());
							newTranscriptCourseSubjectList.add(transcriptCourseSubject);
							
								
						}
					}
					if(newTranscriptCourseSubjectList != null && !newTranscriptCourseSubjectList.isEmpty()){
						transferCourseService.addTranscriptCourseSubjectList(newTranscriptCourseSubjectList);
					}
				}
				
			}
		}
		
	}
	@Override
	public void saveMilitaryTranscriptsForStudentInstitutionTranscriptAsMarkComplete(
			StudentInstitutionTranscript studentInstitutionTranscript,
			List<StudentTranscriptCourse> studentTranscriptList,
			String oldStudentInstitutionTranscriptId) {	
	
		
		boolean institutionFlag=false,courseFlag = true,officialFlag=false,campusViewIdPresent=true;
		

		if(studentInstitutionTranscript.getInstitution().getEvaluationStatus()!=null){
			if(studentInstitutionTranscript.getInstitution().getEvaluationStatus().equalsIgnoreCase(TranscriptStatusEnum.EVALUATED.getValue()))
				institutionFlag=true;
			
		}
		if(studentInstitutionTranscript.getOfficial()!=null)
			officialFlag=studentInstitutionTranscript.getOfficial();
		
			
		
		for(StudentTranscriptCourse st:studentTranscriptList){
			if(!(st.getTransferCourse().getEvaluationStatus().equalsIgnoreCase(TranscriptStatusEnum.EVALUATED.getValue()))){
				courseFlag=false;
				break;
			}
		}
			
		
		String evaluationStatus=""; 
		if(!institutionFlag || !courseFlag){
			evaluationStatus=TranscriptStatusEnum.AWAITINGIE.getValue() ;
		}else if(institutionFlag && courseFlag && !officialFlag){
			evaluationStatus=TranscriptStatusEnum.AWAITINGLOPE.getValue() ;
		}else if(institutionFlag && courseFlag && officialFlag && campusViewIdPresent){
			evaluationStatus=TranscriptStatusEnum.AWAITINGSLE.getValue() ;
		}
		studentInstitutionTranscript.setEvaluationStatus(evaluationStatus);
		
		StudentInstitutionTranscript sit1 = new StudentInstitutionTranscript(); 
		
		sit1.setInstitution( studentInstitutionTranscript.getInstitution() );
		sit1.setStudent(studentInstitutionTranscript.getStudent());
		//sit1.setStudentProgramEvaluation( studentInstitutionTranscript.getStudentProgramEvaluation() );
		sit1.setCreatedDate(new Date());
		sit1.setLastDateForLastCourse( studentInstitutionTranscript.getLastDateForLastCourse() );
		sit1.setEvaluationStatus( evaluationStatus );
		sit1.setOfficial( officialFlag );
		sit1.setCreatedBy(studentInstitutionTranscript.getCreatedBy());
		sit1.setModifiedBy(UserUtil.getCurrentUser().getId());
		sit1.setDateReceived(studentInstitutionTranscript.getDateReceived());
		sit1.setLastAttendenceDate(studentInstitutionTranscript.getLastAttendenceDate());
		sit1.setMarkCompleted(true);
		sit1.setInstitutionAddress(studentInstitutionTranscript.getInstitutionAddress()!=null ? studentInstitutionTranscript.getInstitutionAddress() : null);
		
		sit1.setStudentTranscriptCourse(studentInstitutionTranscript.getStudentTranscriptCourse());
		if(studentInstitutionTranscript.getCollegeCode()!=null){
			sit1.setCollegeCode(studentInstitutionTranscript.getCollegeCode());
		}
		evaluationService.saveStudentInstitutionTranscript( sit1 );
		List<StudentTranscriptCourse> listExistingTranscriptCourses = getStudentTranscriptCoursesByTranscriptId(oldStudentInstitutionTranscriptId, studentInstitutionTranscript.getInstitution().getId() );
		
		if(studentTranscriptList!=null && studentTranscriptList.size()>0){
			for(StudentTranscriptCourse studentTranscriptCourse : studentTranscriptList){
				//First persist StudentTranscriptCourse
				studentTranscriptCourse.setCreatedBy(UserUtil.getCurrentUser().getId());
				studentTranscriptCourse.setModifiedBy(UserUtil.getCurrentUser().getId());
				studentTranscriptCourse.setMarkCompleted(true);
				studentTranscriptCourse.setStudentInstitutionTranscript(sit1);
				
				transcriptMgmtDAO.putTranscript(studentTranscriptCourse);
				
				List<TranscriptCourseSubject> transcriptCourseSubjectList =  studentTranscriptCourse.getTranscriptCourseSubjectList();
				if(transcriptCourseSubjectList != null && !transcriptCourseSubjectList.isEmpty()){
					List<TranscriptCourseSubject> newTranscriptCourseSubjectList = new ArrayList<TranscriptCourseSubject>();
					for(TranscriptCourseSubject transcriptCourseSubject : transcriptCourseSubjectList){
						
						
						MilitarySubject militarySubject = transcriptCourseSubject.getMilitarySubject();	
						if(militarySubject != null && militarySubject.getName() != null && !militarySubject.getName().isEmpty()){							
							
							militarySubject.setTransferCourseId(studentTranscriptCourse.getTransferCourse().getId());
							if(militarySubject.getCreatedBy() != null && !militarySubject.getCreatedBy().isEmpty()){
								militarySubject.setCreatedBy(militarySubject.getCreatedBy());
							}
							if(militarySubject.getModifiedBy() != null && !militarySubject.getModifiedBy().isEmpty()){
								militarySubject.setCreatedBy(militarySubject.getModifiedBy());
							}
							if(militarySubject.getCreatedDate() != null){
								militarySubject.setCreatedDate(new Date());
							}
							militarySubject.setModifiedDate(new Date());
							MilitarySubject militarySubjectExist = transferCourseService.isMilitarySubjectExit(militarySubject.getName(),militarySubject.getTransferCourseId());
							if(militarySubjectExist != null && militarySubjectExist.getName() != null && !militarySubjectExist.getName().isEmpty()){
								militarySubject = militarySubjectExist;							
							}else{
								militarySubject.setCourseLevel(transcriptCourseSubject.getCourseLevel());
								transferCourseService.addMilitarySubjectPerTranscriptCourseSubject(militarySubject);
							}
							
							transcriptCourseSubject.setSubjectId(militarySubject.getId());
							transcriptCourseSubject.setTranscriptCourseId(studentTranscriptCourse.getId());
							if(transcriptCourseSubject.getCreatedBy() != null && !transcriptCourseSubject.getCreatedBy().isEmpty()){
								transcriptCourseSubject.setCreatedBy(UserUtil.getCurrentUser().getId());
							}
							if(transcriptCourseSubject.getModifiedBy() != null && !transcriptCourseSubject.getModifiedBy().isEmpty()){
								transcriptCourseSubject.setModifiedBy(UserUtil.getCurrentUser().getId());
							}
							if(transcriptCourseSubject.getCreatedDate() != null){
								transcriptCourseSubject.setCreatedDate(new Date());
							}
							transcriptCourseSubject.setModifiedDate(new Date());
							newTranscriptCourseSubjectList.add(transcriptCourseSubject);
							
								
						}
					}
					if(newTranscriptCourseSubjectList != null && !newTranscriptCourseSubjectList.isEmpty()){
						transferCourseService.addTranscriptCourseSubjectList(newTranscriptCourseSubjectList);
					}
				}
				
			}
		}
		List<TranscriptComments> transcriptCommentsList = transcriptCommentService.getTranscriptComment(oldStudentInstitutionTranscriptId);
		if(transcriptCommentsList != null && !transcriptCommentsList.isEmpty()){
			for(TranscriptComments transcriptComments:transcriptCommentsList){
			
				transcriptComments.setTranscriptId(sit1.getId());
				transcriptCommentService.addTranscriptComment(transcriptComments);
			}
		}
		if(listExistingTranscriptCourses != null && !listExistingTranscriptCourses.isEmpty()){
			transcriptMgmtDAO.removeStudentTranscriptCourses(listExistingTranscriptCourses);
		}
		
	}
	@Override
	public void updateRespectiveSubjectCoursesForStudent(
			String courseMappingId, String subjectId, String transferCourseId,
			String studentId, String instituteId) {
		transcriptMgmtDAO.updateRespectiveSubjectCoursesForStudent(courseMappingId,subjectId,transferCourseId,studentId,instituteId);
		
	}
	@Override
	public void updateAllRespectiveCoursesCategoryForStudent(
			String courseCategoryMappingId, String subjectId, String transferCourseId,
			String studentId, String instituteId) {
		transcriptMgmtDAO.updateAllRespectiveCoursesCategoryForStudent(courseCategoryMappingId,subjectId,transferCourseId,studentId,instituteId);
		
	}
	@Override
	@Transactional(propagation=Propagation.REQUIRED,readOnly=false,rollbackForClassName="{java.lang.Exception}")
	public void saveRejectedMilitaryTranscriptsForStudentInstitutionTranscriptAsMarkComplete(
			StudentInstitutionTranscript studentInstitutionTranscript,
			List<StudentTranscriptCourse> studentTranscriptList,
			List<StudentInstitutionDegree> sidsList) {
		boolean institutionFlag=false,courseFlag = true,officialFlag=false,campusViewIdPresent=true;
		
		/*List<StudentTranscriptCourse> listExistingTranscripts = getStudentTranscriptCoursesByTranscriptId( studentInstitutionTranscriptId, studentInstitutionTranscript.getInstitution().getId() );
		if( listExistingTranscripts != null && listExistingTranscripts.size() > 0 ) {
			transcriptMgmtDAO.removeStudentTranscriptCourses( listExistingTranscripts );
		}*/
		if(studentInstitutionTranscript.getStudentInstitutionDegreeSet() != null && studentInstitutionTranscript.getStudentInstitutionDegreeSet().size() > 0){
			removeStudentInstitutionDegreeList(studentInstitutionTranscript.getStudentInstitutionDegreeSet());
		}
		// Create new SIDs (along with new InstitutionDegrees when required).
		if (sidsList != null && sidsList.size() > 0) {
					for (StudentInstitutionDegree studentInstitutionDegree : sidsList) {

						InstitutionDegree insDegree = studentInstitutionDegree.getInstitutionDegree();
						if (insDegree == null) {
							insDegree = new InstitutionDegree();
						}
						insDegree.setInstitution(studentInstitutionTranscript.getInstitution());
						insDegree.setCreatedBy(UserUtil.getCurrentUser().getId());
						insDegree.setModifiedBy(UserUtil.getCurrentUser().getId());
						studentInstitutionDegree.setInstitutionDegree(insDegree);
						studentInstitutionDegree.setCreatedBy(UserUtil.getCurrentUser().getId());
						studentInstitutionDegree.setModifiedBy(UserUtil.getCurrentUser().getId());
						// studentInstitutionDegree.setStudentId( student.getId() );
						studentInstitutionDegree.setStudentInstitutionTranscript(studentInstitutionTranscript);
						if (studentInstitutionDegree.getInstitutionDegree() == null
								|| studentInstitutionDegree.getInstitutionDegree()
										.getId() == null) {
							institutionMgmtDao
									.saveInstitutionDegree(studentInstitutionDegree
											.getInstitutionDegree());
						}
						institutionMgmtDao
								.saveStudentInstitutionDegree(studentInstitutionDegree);
					}
				}
		if(studentInstitutionTranscript.getInstitution().getEvaluationStatus()!=null){
			if(studentInstitutionTranscript.getInstitution().getEvaluationStatus().equalsIgnoreCase(TranscriptStatusEnum.EVALUATED.getValue()))
				institutionFlag=true;
			
		}
		if(studentInstitutionTranscript.getOfficial()!=null)
			officialFlag=studentInstitutionTranscript.getOfficial();
		
			
		
		for(StudentTranscriptCourse st:studentTranscriptList){
			if(!(st.getTransferCourse().getEvaluationStatus().equalsIgnoreCase(TranscriptStatusEnum.EVALUATED.getValue()))){
				courseFlag=false;
				break;
			}
		}
			
		
		String evaluationStatus=""; 
		if(!institutionFlag || !courseFlag){
			evaluationStatus=TranscriptStatusEnum.AWAITINGIE.getValue() ;
		}else if(institutionFlag && courseFlag && !officialFlag){
			evaluationStatus=TranscriptStatusEnum.AWAITINGLOPE.getValue() ;
		}else if(institutionFlag && courseFlag && officialFlag && campusViewIdPresent){
			evaluationStatus=TranscriptStatusEnum.AWAITINGSLE.getValue() ;
		}
		
		studentInstitutionTranscript.setEvaluationStatus(evaluationStatus);
		
		studentInstitutionTranscript.setInstitution( studentInstitutionTranscript.getInstitution() );
		studentInstitutionTranscript.setStudent(studentInstitutionTranscript.getStudent());
		//sit1.setStudentProgramEvaluation( studentInstitutionTranscript.getStudentProgramEvaluation() );
		studentInstitutionTranscript.setModifiedDate(new Date());
		studentInstitutionTranscript.setLastDateForLastCourse( studentInstitutionTranscript.getLastDateForLastCourse() );
		studentInstitutionTranscript.setEvaluationStatus( evaluationStatus );
		studentInstitutionTranscript.setOfficial( officialFlag );
		studentInstitutionTranscript.setCreatedBy(studentInstitutionTranscript.getCreatedBy());
		studentInstitutionTranscript.setModifiedBy(UserUtil.getCurrentUser().getId());
		studentInstitutionTranscript.setStudentInstitutionDegreeSet(studentInstitutionTranscript.getStudentInstitutionDegreeSet());
		studentInstitutionTranscript.setDateReceived(studentInstitutionTranscript.getDateReceived());
		studentInstitutionTranscript.setLastAttendenceDate(studentInstitutionTranscript.getLastAttendenceDate());
		studentInstitutionTranscript.setMarkCompleted(true);
		studentInstitutionTranscript.setInstitutionAddress(studentInstitutionTranscript.getInstitutionAddress()!=null ? studentInstitutionTranscript.getInstitutionAddress() : null);
		
		studentInstitutionTranscript.setStudentTranscriptCourse(studentInstitutionTranscript.getStudentTranscriptCourse());
		if(studentInstitutionTranscript.getCollegeCode()!=null){
			studentInstitutionTranscript.setCollegeCode(studentInstitutionTranscript.getCollegeCode());
		}
		evaluationService.saveStudentInstitutionTranscript( studentInstitutionTranscript );
		
		if(studentTranscriptList!=null && studentTranscriptList.size()>0){
			for(StudentTranscriptCourse studentTranscriptCourse : studentTranscriptList){
				//First persist StudentTranscriptCourse
				studentTranscriptCourse.setCreatedBy(studentInstitutionTranscript.getCreatedBy());
				studentTranscriptCourse.setModifiedBy(UserUtil.getCurrentUser().getId());
				studentTranscriptCourse.setMarkCompleted(true);
				studentTranscriptCourse.setStudentInstitutionTranscript(studentInstitutionTranscript);
				
				transcriptMgmtDAO.putTranscript(studentTranscriptCourse);
				
				List<TranscriptCourseSubject> transcriptCourseSubjectList =  studentTranscriptCourse.getTranscriptCourseSubjectList();
				if(transcriptCourseSubjectList != null && !transcriptCourseSubjectList.isEmpty()){
					List<TranscriptCourseSubject> newTranscriptCourseSubjectList = new ArrayList<TranscriptCourseSubject>();
					for(TranscriptCourseSubject transcriptCourseSubject : transcriptCourseSubjectList){
						
						
						MilitarySubject militarySubject = transcriptCourseSubject.getMilitarySubject();	
						if(militarySubject != null && militarySubject.getName() != null && !militarySubject.getName().isEmpty()){							
							
							militarySubject.setTransferCourseId(studentTranscriptCourse.getTransferCourse().getId());
							if(militarySubject.getCreatedBy() != null && !militarySubject.getCreatedBy().isEmpty()){
								militarySubject.setCreatedBy(militarySubject.getCreatedBy());
							}
							if(militarySubject.getModifiedBy() != null && !militarySubject.getModifiedBy().isEmpty()){
								militarySubject.setCreatedBy(militarySubject.getModifiedBy());
							}
							if(militarySubject.getCreatedDate() != null){
								militarySubject.setCreatedDate(new Date());
							}
							militarySubject.setModifiedDate(new Date());
							MilitarySubject militarySubjectExist = transferCourseService.isMilitarySubjectExit(militarySubject.getName(),militarySubject.getTransferCourseId());
							if(militarySubjectExist != null && militarySubjectExist.getName() != null && !militarySubjectExist.getName().isEmpty()){
								militarySubject = militarySubjectExist;							
							}else{
								militarySubject.setCourseLevel(transcriptCourseSubject.getCourseLevel());
								transferCourseService.addMilitarySubjectPerTranscriptCourseSubject(militarySubject);
							}
							
							transcriptCourseSubject.setSubjectId(militarySubject.getId());
							transcriptCourseSubject.setTranscriptCourseId(studentTranscriptCourse.getId());
							if(transcriptCourseSubject.getCreatedBy() != null && !transcriptCourseSubject.getCreatedBy().isEmpty()){
								transcriptCourseSubject.setCreatedBy(UserUtil.getCurrentUser().getId());
							}
							if(transcriptCourseSubject.getModifiedBy() != null && !transcriptCourseSubject.getModifiedBy().isEmpty()){
								transcriptCourseSubject.setModifiedBy(UserUtil.getCurrentUser().getId());
							}
							if(transcriptCourseSubject.getCreatedDate() != null){
								transcriptCourseSubject.setCreatedDate(new Date());
							}
							transcriptCourseSubject.setTranscriptStatus(TranscriptStatusEnum.EVALUATED.getValue());
							transcriptCourseSubject.setModifiedDate(new Date());							
							newTranscriptCourseSubjectList.add(transcriptCourseSubject);	
						}
					}
					if(newTranscriptCourseSubjectList != null && !newTranscriptCourseSubjectList.isEmpty()){
						transferCourseService.addTranscriptCourseSubjectList(newTranscriptCourseSubjectList);
					}
				}
				
			}
		}
		
	}

	@Override
	public List<StudentTranscriptCourse> getStudentTranscriptCoursesWithCourseMappingDetailsByTranscriptId(
			String transcriptId) {
		 List<StudentTranscriptCourse> stcList = transcriptMgmtDAO.getStudentTranscriptCoursesByTranscriptId(transcriptId, null);
		return stcList;
	}
	@Override
	public void saveSLES(List<SleCollege> sleCollegeList) {
		transcriptMgmtDAO.saveSLES(sleCollegeList);
		
	}
	@Override
	public List<SleCollege> getAllSLEForCollegeCode(String collegeCode) {
		// TODO Auto-generated method stub
		return transcriptMgmtDAO.findAllSLEForCollegeCode(collegeCode);
	}
	@Override	
	public void deleteAllSLEAssignToCollegeCode(String collegeCode) {
		 transcriptMgmtDAO.deleteAllSLEAssignToCollegeCode(collegeCode);
	}
	@Override
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false , rollbackForClassName="{java.lang.Exception}")
	public void resetStudentInstitutionTranscriptForCollegeCode(String collegeCode,List<SleCollege> sleCollegeList) {
		transcriptMgmtDAO.resetStudentInstitutionTranscriptForCollegeCode(collegeCode);
		deleteAllSLEAssignToCollegeCode(collegeCode);
		saveSLES(sleCollegeList);
	}
}