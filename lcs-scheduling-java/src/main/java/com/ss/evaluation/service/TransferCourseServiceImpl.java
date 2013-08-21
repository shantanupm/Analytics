package com.ss.evaluation.service;

import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ss.paging.helper.ExtendedPaginatedList;
import com.ss.common.logging.RequestContext;
import com.ss.course.value.CourseTranscript;
import com.ss.course.value.MilitarySubject;
import com.ss.course.value.TransferCourse;
import com.ss.course.value.TransferCourseTitle;
import com.ss.evaluation.value.*;
import com.ss.evaluation.dao.*;
import com.ss.institution.dao.InstitutionMgmtDao;




/**
 * Service Implementation for the {@link EvaluationService}.
 * @author binoy.mathew
 */
@Service
public class TransferCourseServiceImpl implements TransferCourseService {
	private static final Logger log = LoggerFactory.getLogger(TransferCourseServiceImpl.class);
	
	@Autowired
	private InstitutionMgmtDao institutionMgmtDao;
	
	@Autowired
	private StudentEvaluationDao studentEvaluationDao;
	
	@Autowired
	private TransferCourseMgmtDAO transferCourseMgmtDAO;
	
	@Autowired
	private TranscriptMgmtDAO transcriptMgmtDAO;
	
	@Override
	public TransferCourse getTransferCourseByCourseCodeAndInstitutionId(String transferCourseCode, String institutionId) {
		// TODO Auto-generated method stub
		return transferCourseMgmtDAO.getTransferCourseByCourseCodeAndInstitutionId(transferCourseCode, institutionId);
	}

	@Override
	public List<TransferCourse> getAllTransferCourse() {
		// TODO Auto-generated method stub
		return transferCourseMgmtDAO.getAllTransferCourse();
	}

	@Override
	public List<TransferCourse> getAllTransferCourseForEvaluation() {
		// TODO Auto-generated method stub
		return transferCourseMgmtDAO.getAllTransferCourseForEvaluation();
	}

	@Override
	public List<TransferCourse> getAllEvaluatedCoursesByInstId(String instId) {
		// TODO Auto-generated method stub
		return transferCourseMgmtDAO.getAllEvaluatedCoursesByInstId(instId);
	}

	@Override
	public TransferCourse getTransferCourseByInstitutionIdAndCourseNumber(
			String instId, String cn) {
		// TODO Auto-generated method stub
		return transferCourseMgmtDAO.getTransferCourseByInstitutionIdAndCourseNumber(instId, cn);
	}

	@Override
	public List<TransferCourse> getTransferCourseByInstitutionIdAndInstProgramId(
			String instId, String iPId) {
		// TODO Auto-generated method stub
		return transferCourseMgmtDAO.getTransferCourseByInstitutionIdAndInstProgramId(instId, iPId);
	}

	@Override
	public TransferCourse getTransferCourseByInstitutionAndPartCourseTitle(
			String instId, String pct) {
		// TODO Auto-generated method stub
		return transferCourseMgmtDAO.getTransferCourseByInstitutionAndPartCourseTitle(instId, pct);
	}

	@Override
	public void addTransferCourse(TransferCourse tc) {
		// TODO Auto-generated method stub
		transferCourseMgmtDAO.addTransferCourse(tc);
	}
	
	
	@Override
	public void saveTransferCourse( TransferCourse transferCourse ) {
		transferCourseMgmtDAO.saveTransferCourse( transferCourse );
	}

	@Override
	public List<TransferCourse> getAllNotEvaluatedCoursesByInstId(String instId) {
		return transferCourseMgmtDAO.getAllNotEvaluatedCoursesByInstId(instId);
	}

	@Override
	public List<TransferCourse> getAllConflictCoursesByInstId(String instId) {
		return transferCourseMgmtDAO.getAllConflictCoursesByInstId(instId);
	}
	
	@Override
	public List<TransferCourse> getAllCoursesByInstId(String institutionId,String status){
		return transferCourseMgmtDAO.getAllCoursesByInstId(institutionId,status);
	}
	
	@Override
	 @SuppressWarnings("unchecked")
    public ExtendedPaginatedList getAllRecordsPage(Class clazz,
            ExtendedPaginatedList paginatedList,String institutionId,String status, String searchBy, String searchText) {
        List results = transferCourseMgmtDAO.getAllRecordsPage(clazz, paginatedList
                .getFirstRecordIndex(), paginatedList.getPageSize(), paginatedList
                .getSortDirection(), paginatedList.getSortCriterion(), institutionId, status, searchBy, searchText);
        paginatedList.setList(results);
        paginatedList.setTotalNumberOfRows(transferCourseMgmtDAO.getAllRecordsCount(clazz, institutionId, status, searchBy, searchText));
        return paginatedList;
    }

	@Override
	public List<TransferCourse> getAllCoursesForApproval() {
	
		return transferCourseMgmtDAO.getAllCoursesForApproval();
	}
	
	@Override
	public List<TransferCourseTitle> getTransferCourseTitlesByTransferCourseId(String transferCourseId){
		return transferCourseMgmtDAO.getTransferCourseTitlesByTransferCourseId(transferCourseId);
	}
	
	@Override
	public TransferCourseTitle getTransferCourseTitleById(String id){
		return transferCourseMgmtDAO.getTransferCourseTitleById(id);
	}
	
	@Override
	public void addTransferCourseTitle(TransferCourseTitle tct){
		if(tct.getTitle()!=null && !tct.getTitle().isEmpty()){
			TransferCourse tc = transferCourseMgmtDAO.findById(tct.getTransferCourseId());
			tc.setTrCourseTitle(tct.getTitle());
			/*if("NOT EVALUATED".equalsIgnoreCase(tct.getEvaluationStatus())){
				tc.setEvaluationStatus(tct.getEvaluationStatus());
			}*/
			transferCourseMgmtDAO.addTransferCourse(tc);
			transferCourseMgmtDAO.addTransferCourseTitle(tct);
		}
	}
	
	@Override
	public TransferCourseTitle getTransferCourseTitleByDate(Date date, String transferCourseId){
		List<TransferCourseTitle> titleList = getTransferCourseTitlesByTransferCourseId(transferCourseId);
		if(titleList != null){
			for(TransferCourseTitle tct : titleList){
				if(tct.getEffectiveDate()!=null){
					if(tct.getEffectiveDate().before(date)){
						if(tct.getEndDate() == null || tct.getEndDate().after(date)){
							return tct;
						}
					}
				}
			}
		}
		return null;
	}
	
	@Override
	public TransferCourseTitle getTransferCourseTitleByCourseIdAndTitle(String trCourseId, String title){
		return transferCourseMgmtDAO.getTransferCourseTitleByCourseIdAndTitle(trCourseId,title);
	}
	
	@Override
	public TransferCourseTitle getNotEvaluatedTransferCourseTitleByCourseIdAndTitle(String trCourseId, String title){
		return transferCourseMgmtDAO.getNotEvaluatedTransferCourseTitleByCourseIdAndTitle(trCourseId, title);
	}
	
	@Override
	public int getRequiredApprovalCount(){
		try{
			return transferCourseMgmtDAO.getAllCoursesForApproval()!=null?transferCourseMgmtDAO.getAllCoursesForApproval().size():0;
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Exception Occured."+e+" RequestId:"+uniqueId, e);
			return 0;
		}
	}

	@Override
	public List<TransferCourse> getCourseByInstitutionIdAndString(
			String institutionId, String searchBy, String searchText) {
		
		return transferCourseMgmtDAO.getCourseByInstitutionIdAndString(institutionId, searchBy, searchText);
	}

	@Override
	public void addCourseTranscript(CourseTranscript ct) {
		transferCourseMgmtDAO.addCourseTranscript(ct);
	}

	@Override
	public CourseTranscript getCourseTranscript(String transferCourseId){
		return transferCourseMgmtDAO.getCourseTranscript(transferCourseId);
		
	}
	@Override
	@Transactional( propagation=Propagation.REQUIRED, readOnly=false, rollbackForClassName={"java.lang.Exception"} )
	public void addTransferCourseTitles(List<TransferCourseTitle> tcts) {
		transferCourseMgmtDAO.addTransferCourseTitles(tcts);
	}
	@Override
	@Transactional( propagation=Propagation.REQUIRED, readOnly=false, rollbackForClassName={"java.lang.Exception"} )
	public void removeTransferCourseTitles(List<TransferCourseTitle> courseTitleList) {
		transferCourseMgmtDAO.removeTransferCourseTitles(courseTitleList);
		
	}
	@Override
	public TransferCourse getTransferCourseById(String transferCourseId) {
		
		return transferCourseMgmtDAO.findById(transferCourseId);
	}
	@Override
	public void addTransferCourseTitle(TransferCourseTitle tct, int tctSize) {
		if(tct.getTitle()!=null && !tct.getTitle().isEmpty()){
			if(tctSize == 0){
				TransferCourse tc = transferCourseMgmtDAO.findById(tct.getTransferCourseId());
				tc.setTrCourseTitle(tct.getTitle());
				/*if("NOT EVALUATED".equalsIgnoreCase(tct.getEvaluationStatus())){
					tc.setEvaluationStatus(tct.getEvaluationStatus());
				}*/
				transferCourseMgmtDAO.addTransferCourse(tc);
			}
			transferCourseMgmtDAO.addTransferCourseTitle(tct);
		}
		
	}
	
	@Override
	public List<MilitarySubject> getMilitarySubjectByTransferCourseId(String transferCourseId){
		return transferCourseMgmtDAO.getMilitarySubjectByTransferCourseId(transferCourseId);
	}
	@Override
	public void addMilitarySubject(List<MilitarySubject> titleList) {
		transferCourseMgmtDAO.addMilitarySubject(titleList);
	
	}
	@Override
	public void addMilitarySubjectPerTranscriptCourseSubject(
			MilitarySubject militarySubject) {
		transferCourseMgmtDAO.addMilitarySubjectPerTranscriptCourseSubject(militarySubject);
		
	}
	@Override
	public void addTranscriptCourseSubjectList(
			List<TranscriptCourseSubject> transcriptCourseSubjectList) {
		transferCourseMgmtDAO.addTranscriptCourseSubjectList(transcriptCourseSubjectList);
		
	}
	@Override
	public List<TranscriptCourseSubject> getAllTranscriptCourseSubjectByStudentTranscriptCourseId(
			String studentTranscriptCourseId) {
		return transferCourseMgmtDAO.getAllTranscriptCourseSubjectByStudentTranscriptCourseId(studentTranscriptCourseId);
		
	}
	@Override
	public MilitarySubject isMilitarySubjectExit(String subjectName,
			String transferCourseId) {
		
		return transferCourseMgmtDAO.isMilitarySubjectExit(subjectName,transferCourseId);
	}
	@Override
	public TranscriptCourseSubject getTranscriptCourseSubjectByTranscriptCourseIdAndSubjectId(
			String subjectId, String studentTranscriptCourseId) {
		
		return transferCourseMgmtDAO.findTranscriptCourseSubjectByTranscriptCourseIdAndSubjectId(subjectId,studentTranscriptCourseId);
	}
	
	@Override
	public void addOrUpdateTranscriptCourseSubject(
			TranscriptCourseSubject transcriptCourseSubject) {
		transferCourseMgmtDAO.addOrUpdateTranscriptCourseSubject(transcriptCourseSubject);
		
	}
	@Override
	public void removeRejectedStudentTranscriptCourseSubjectMarkForDelection(
			List<TranscriptCourseSubject> tcsubjectRejectedListForDeletion) {
		transferCourseMgmtDAO.removeRejectedStudentTranscriptCourseSubjectMarkForDelection(tcsubjectRejectedListForDeletion);
		
	}
	@Override
	public MilitarySubject getMilitarySubjectById(String militarySubjectId) {
		
		return transferCourseMgmtDAO.getMilitarySubjectById(militarySubjectId);
	}
	
	@Override
	public TranscriptCourseSubject getTranscriptCourseSubjectById(String transcriptCourseSubjectId){
		return transferCourseMgmtDAO.getTranscriptCourseSubjectById(transcriptCourseSubjectId);
	}

	@Override
	public void updateAllTranscriptCourseSubjects(List<TranscriptCourseSubject> transcriptCourseSubjectList) {
		transferCourseMgmtDAO.saveOrUpdateTranscriptCourseSubjects(transcriptCourseSubjectList);		
	}
	
	
}
