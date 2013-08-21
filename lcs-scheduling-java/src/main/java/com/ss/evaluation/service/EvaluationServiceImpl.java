package com.ss.evaluation.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ss.common.logging.RequestContext;
import com.ss.common.util.SchedulingSystemConstants;
import com.ss.common.util.StudentProgramInfo;
import com.ss.common.util.UserUtil;
import com.ss.course.value.GCUDegree;
import com.ss.course.value.MilitarySubject;
import com.ss.course.value.TransferCourse;
import com.ss.course.value.TransferCourseTitle;
import com.ss.evaluation.comparators.StudentInstitutionTranscriptDateComparator;
import com.ss.evaluation.dao.StudentEvaluationDao;
import com.ss.evaluation.dao.TranscriptMgmtDAO;
import com.ss.evaluation.dao.TransferCourseMgmtDAO;
import com.ss.evaluation.dto.StudentInstitutionTranscriptSummary;
import com.ss.evaluation.enums.TranscriptStatusEnum;
import com.ss.evaluation.value.ChartValueObject;
import com.ss.evaluation.value.Student;
import com.ss.evaluation.value.StudentInstitutionDegree;
import com.ss.evaluation.value.StudentInstitutionTranscript;
import com.ss.evaluation.value.StudentProgramEvaluation;
import com.ss.evaluation.value.StudentTranscriptCourse;
import com.ss.evaluation.value.TranscriptCourseSubject;
import com.ss.institution.dao.InstitutionMgmtDao;
import com.ss.institution.service.InstitutionService;
import com.ss.institution.service.InstitutionTermTypeService;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionDegree;
import com.ss.institution.value.InstitutionTermType;
import com.ss.user.value.User;

/**
 * Service Implementation for the {@link EvaluationService}.
 * 
 * @author binoy.mathew
 */
@Service
public class EvaluationServiceImpl implements EvaluationService {
	private static final Logger log = LoggerFactory
			.getLogger(EvaluationServiceImpl.class);

	@Autowired
	private InstitutionMgmtDao institutionMgmtDao;

	@Autowired
	private StudentEvaluationDao studentEvaluationDao;

	@Autowired
	private TransferCourseMgmtDAO transferCourseMgmtDAO;

	@Autowired
	private InstitutionService institutionService;

	@Autowired
	TranscriptService transcriptService;

	@Autowired
	TranscriptMgmtDAO transcriptMgmtDAO;
	@Autowired
	private TransferCourseService transferCourseService;
	
	@Autowired
	private InstitutionTermTypeService institutionTermTypeService;

	//TODO:Are we using this method
	@Override
	@Transactional
	public void createEvaluationForStudent(
			StudentProgramEvaluation studentProgramEvaluation,
			List<StudentInstitutionDegree> studentInstitutionDegrees,
			Institution institution, Date expectedStartDate,
			Date lastDateOfLastCourse, Boolean isTranscriptOfficial,
			StudentInstitutionTranscript sit) {
		studentProgramEvaluation.setExpectedStartDate(expectedStartDate);
		studentProgramEvaluation
				.setDataEntryStatus(SchedulingSystemConstants.TRANSCRIPT_DATA_ENTRY_STATUS_INSTITUTION_ADDED);
		studentEvaluationDao
				.saveStudentProgramEvaluation(studentProgramEvaluation);

		institutionService.addInstitution(institution);

		/*
		 * Get existing StudentInstitutionTranscript for this
		 * StudentProgramEvaluation (if any), along with the corresponding
		 * StudentInstitutionDegree and StudentTranscriptCourse. Copy them to
		 * archive table. Delete the SIT and SID from the active tables. Create
		 * new SIT and SIDs. Copy the existing STC to the archive table. Modify
		 * the existing STC to point to the newly created SIT.
		 */
		List<StudentInstitutionTranscript> sitListForArchival = getStudentInstitutionTranscriptListForStudentAndInstitution(
				studentProgramEvaluation.getStudentId(), institution.getId());

		List<StudentTranscriptCourse> stcForModificationList = new ArrayList<StudentTranscriptCourse>();
		List<StudentInstitutionDegree> sidForDeletionList = new ArrayList<StudentInstitutionDegree>();

		// TODO: Commented by Avinash -- Need to lookinto the usage of archive
		// tables as we removed them

		// if( sitListForArchival != null && sitListForArchival.size() > 0 ) {
		//
		// List<StudentTranscriptCourseArchive> stcArchiveList = new
		// ArrayList<StudentTranscriptCourseArchive>();
		// List<StudentInstitutionDegreeArchive> sidArchiveList = new
		// ArrayList<StudentInstitutionDegreeArchive>();
		//
		// for( StudentInstitutionTranscript activeSit : sitListForArchival ) {
		//
		// StudentInstitutionTranscriptArchive sitArchive = new
		// StudentInstitutionTranscriptArchive();
		// sitArchive.copyIntoArchive( activeSit );
		// studentEvaluationDao.saveStudentInstitutionTranscriptArchive(
		// sitArchive );
		//
		// List<StudentTranscriptCourse> stcList =
		// transcriptService.getStudentTranscriptCoursesByTranscriptId(
		// activeSit.getId(), activeSit.getInstitution().getId() );
		// if( stcList != null && stcList.size() > 0 ) {
		// for( StudentTranscriptCourse activeStc : stcList ) {
		// StudentTranscriptCourseArchive stcArchive = new
		// StudentTranscriptCourseArchive();
		// stcArchive.copyIntoArchive( activeStc, sitArchive );
		// stcArchiveList.add( stcArchive );
		// stcForModificationList.add( activeStc );
		// }
		// }
		//
		// if( activeSit.getStudentInstitutionDegreeSet() != null &&
		// activeSit.getStudentInstitutionDegreeSet().size() > 0 ) {
		// for( StudentInstitutionDegree activeSid :
		// activeSit.getStudentInstitutionDegreeSet() ) {
		// StudentInstitutionDegreeArchive sidArchive = new
		// StudentInstitutionDegreeArchive();
		// sidArchive.copyIntoArchive( activeSid, sitArchive );
		// sidArchiveList.add( sidArchive );
		// sidForDeletionList.add( activeSid );
		// }
		// }
		// }
		//
		// if( stcArchiveList.size() > 0 ) {
		// transcriptService.saveTranscriptCourseArchiveList( stcArchiveList );
		// }
		//
		// if( sidArchiveList.size() > 0 ) {
		// transcriptService.saveStudentInstitutionDegreeArchiveList(
		// sidArchiveList );
		// }
		//
		// if( sidForDeletionList.size() > 0 ) {
		// transcriptService.removeStudentInstitutionDegreeList(
		// sidForDeletionList );
		// }
		//
		// studentEvaluationDao.removeStudentInstitutionTranscript(
		// sitListForArchival );
		// }

		// Create new SIT.
		// StudentInstitutionTranscript sit = new
		// StudentInstitutionTranscript();
		sit.setInstitution(institution);
		// sit.setStudent( studentProgramEvaluation );
		sit.setCreatedDate(new Date());
		sit.setCreatedBy(UserUtil.getCurrentUser().getId());
		sit.setLastDateForLastCourse(lastDateOfLastCourse);
		sit.setEvaluationStatus(TranscriptStatusEnum.DRAFT.getValue());
		sit.setOfficial(isTranscriptOfficial);
		saveStudentInstitutionTranscript(sit);

		// Modify existing STC to refer to new SIT.
		if (stcForModificationList.size() > 0) {
			for (StudentTranscriptCourse stcModify : stcForModificationList) {
				stcModify.setStudentInstitutionTranscript(sit);
			}
			transcriptService.saveStudentTranscripts(stcForModificationList);
		}

		// Create new SIDs (along with new InstitutionDegrees when required).
		for (int i = 0; i < studentInstitutionDegrees.size(); i++) {
			StudentInstitutionDegree studentInstitutionDegree = studentInstitutionDegrees
					.get(i);
			// studentInstitutionDegree.setStudentProgramEvaluationId(studentProgramEvaluation.getId());
			InstitutionDegree insDegree = studentInstitutionDegree
					.getInstitutionDegree();
			if (insDegree == null) {
				insDegree = new InstitutionDegree();
			}
			insDegree.setInstitution(institution);
			studentInstitutionDegree.setInstitutionDegree(insDegree);
			// studentInstitutionDegree.setStudentProgramEvaluationId(
			// studentProgramEvaluation.getId() );
			studentInstitutionDegree.setStudentInstitutionTranscript(sit);
			if (studentInstitutionDegree.getInstitutionDegree() == null
					|| studentInstitutionDegree.getInstitutionDegree().getId() == null) {
				institutionMgmtDao
						.saveInstitutionDegree(studentInstitutionDegree
								.getInstitutionDegree());
			}
			institutionMgmtDao
					.saveStudentInstitutionDegree(studentInstitutionDegree);
		}
	}

	@Override
	public void archiveTranscript(String studentId, String institutionId) {

		List<StudentInstitutionTranscript> sitListForArchival = getStudentInstitutionTranscriptListForStudentAndInstitution(
				studentId, institutionId);

		List<StudentTranscriptCourse> stcForDeletionList = new ArrayList<StudentTranscriptCourse>();
		List<StudentInstitutionDegree> sidForDeletionList = new ArrayList<StudentInstitutionDegree>();

		// TODO: Commented by Avinash -- Need to lookinto the usage of archive
		// tables as we removed them

		// if( sitListForArchival != null && sitListForArchival.size() > 0 ) {
		// List<StudentTranscriptCourseArchive> stcArchiveList = new
		// ArrayList<StudentTranscriptCourseArchive>();
		// List<StudentInstitutionDegreeArchive> sidArchiveList = new
		// ArrayList<StudentInstitutionDegreeArchive>();
		//
		// for( StudentInstitutionTranscript activeSit : sitListForArchival ){
		// StudentInstitutionTranscriptArchive sitArchive = new
		// StudentInstitutionTranscriptArchive();
		// sitArchive.copyIntoArchive( activeSit );
		// studentEvaluationDao.saveStudentInstitutionTranscriptArchive(
		// sitArchive );
		//
		// List<StudentTranscriptCourse> stcList =
		// transcriptService.getStudentTranscriptCoursesByTranscriptId(
		// activeSit.getId(), activeSit.getInstitution().getId() );
		// if( stcList != null && stcList.size() > 0 ) {
		// for( StudentTranscriptCourse activeStc : stcList ) {
		// StudentTranscriptCourseArchive stcArchive = new
		// StudentTranscriptCourseArchive();
		// stcArchive.copyIntoArchive( activeStc, sitArchive );
		// stcArchiveList.add( stcArchive );
		// stcForDeletionList.add(activeStc);
		// }
		// }
		//
		// if( activeSit.getStudentInstitutionDegreeSet() != null &&
		// activeSit.getStudentInstitutionDegreeSet().size() > 0 ) {
		// for( StudentInstitutionDegree activeSid :
		// activeSit.getStudentInstitutionDegreeSet() ) {
		// StudentInstitutionDegreeArchive sidArchive = new
		// StudentInstitutionDegreeArchive();
		// sidArchive.copyIntoArchive( activeSid, sitArchive );
		// sidArchiveList.add( sidArchive );
		// sidForDeletionList.add( activeSid );
		// }
		// }
		// }
		//
		//
		//
		// if( stcArchiveList.size() > 0 ) {
		// transcriptService.saveTranscriptCourseArchiveList( stcArchiveList );
		// }
		//
		// if( sidArchiveList.size() > 0 ) {
		// transcriptService.saveStudentInstitutionDegreeArchiveList(
		// sidArchiveList );
		// }
		//
		// if( sidForDeletionList.size() > 0 ) {
		// transcriptService.removeStudentInstitutionDegreeList(
		// sidForDeletionList );
		// }
		//
		// if(stcForDeletionList.size() > 0) {
		// transcriptService.removeStudentTranscriptCourses(stcForDeletionList);
		// }
		//
		// studentEvaluationDao.removeStudentInstitutionTranscript(sitListForArchival);
		// }

	}

	@Override
	public void saveStudentInstitutionTranscript(
			StudentInstitutionTranscript studentInstitutionTranscript) {
		studentEvaluationDao
				.saveStudentInstitutionTranscript(studentInstitutionTranscript);
	}

	@Override
	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptForStudentProgramEval(
			StudentProgramEvaluation studentProgramEvaluation) {
		List<StudentInstitutionTranscript> sitList = studentEvaluationDao
				.getStudentInstitutionTranscriptForStudentProgramEval(studentProgramEvaluation);
		if (sitList != null && sitList.size() > 0) {
			for (StudentInstitutionTranscript studentInstitutionTranscript : sitList) {
				List<StudentInstitutionDegree> idList = institutionService
						.getStudentInstitutionDegreeListForStudentInstitutionTranscript(studentInstitutionTranscript);
				studentInstitutionTranscript
						.setStudentInstitutionDegreeSet(idList);
			}
		}
		return sitList;
	}

	@Override
	public List<StudentInstitutionTranscript> getLatestStudentInstitutionTranscriptForStudentProgramEval(
			StudentProgramEvaluation studentProgramEvaluation) {
		List<StudentInstitutionTranscript> sitList = studentEvaluationDao
				.getStudentInstitutionTranscriptForStudentProgramEval(studentProgramEvaluation);

		/*
		 * Reverse the list of SITs, then choose only the first SIT for each
		 * institution in that list to be added to the latestSitList. Again
		 * reverse the latestSitList to maintain creation order.
		 */
		List<StudentInstitutionTranscript> latestSitList = new ArrayList<StudentInstitutionTranscript>();
		List<String> institutionIdList = new ArrayList<String>();
		if (sitList != null && sitList.size() > 0) {
			Collections.reverse(sitList);
			for (StudentInstitutionTranscript studentInstitutionTranscript : sitList) {
				if (!institutionIdList.contains(studentInstitutionTranscript
						.getInstitution().getId())) {
					latestSitList.add(studentInstitutionTranscript);
					institutionIdList.add(studentInstitutionTranscript
							.getInstitution().getId());
				}
			}
			Collections.reverse(latestSitList);
		}

		if (latestSitList != null && latestSitList.size() > 0) {
			for (StudentInstitutionTranscript studentInstitutionTranscript : latestSitList) {
				List<StudentInstitutionDegree> idList = institutionService
						.getStudentInstitutionDegreeListForStudentInstitutionTranscript(studentInstitutionTranscript);
				studentInstitutionTranscript
						.setStudentInstitutionDegreeSet(idList);
			}
		}
		return latestSitList;
	}

	@Override
	public StudentInstitutionTranscript getStudentInstitutionTranscriptForStudentAndInstitution(
			String studentId, String institutionId) {
		return studentEvaluationDao
				.getStudentInstitutionTranscriptForStudentAndInstitution(
						studentId, institutionId);
	}

	@Override
	@Transactional
	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptListForStudentAndInstitution(
			String studentId, String institutionId) {
		return studentEvaluationDao
				.getStudentInstitutionTranscriptListForStudentAndInstitution(
						studentId, institutionId);
	}

	@Override
	public StudentInstitutionTranscript getStudentInstitutionTranscriptById(
			String studentInstitutionTranscriptId) {
		return studentEvaluationDao
				.getStudentInstitutionTranscriptById(studentInstitutionTranscriptId);
	}

	@Override
	public StudentProgramEvaluation getStudentProgramEvaluationById(String speId) {
		return studentEvaluationDao.findById(speId);
	}

	@Override
	public List<TransferCourse> getAllTransferCourseByInstitutionId(String sc) {
		return transferCourseMgmtDAO.getAllEvaluatedCoursesByInstId(sc);
	}

	@Override
	public StudentProgramEvaluation getEvaluationForStudentCrmIdAndProgramCode(
			String studentCrmId, String programVersionCode) {
		return studentEvaluationDao.getEvaluationForStudentCrmIdAndProgramCode(
				studentCrmId, programVersionCode);
	}

	@Override
	public StudentProgramEvaluation getEvaluationForStudentByCrmId(
			String studentCrmId) {
		return studentEvaluationDao
				.getEvaluationForStudentByCrmId(studentCrmId);
	}

	@Override
	public StudentInstitutionTranscript getStudentInstitutionTranscriptForLOPES(String userId) {
		/*
		 * boolean coursesEvaluated; List<StudentInstitutionTranscript> sitList
		 * =
		 * studentEvaluationDao.getUnofficialStudentInstitutionTranscriptList();
		 * for(StudentInstitutionTranscript sit : sitList){ coursesEvaluated =
		 * true; if(sit.getInstitution().getEvaluationStatus().equalsIgnoreCase(
		 * "EVALUATED")){ List<StudentTranscriptCourse> stcList =
		 * transcriptMgmtDAO
		 * .getStudentTransferCoursesByTranscriptId(sit.getId(),
		 * sit.getInstitution().getId()); for(StudentTranscriptCourse stc :
		 * stcList){
		 * if(!stc.getTransferCourse().getEvaluationStatus().equalsIgnoreCase
		 * ("EVALUATED")){ coursesEvaluated = false; break; } }
		 * if(coursesEvaluated){ return sit; } } } return null;
		 */

		//return studentEvaluationDao.getOldestSITForLOPES();
		return studentEvaluationDao.findOldestSITForLOPESWhichhaveCourses(userId);
	}

	@Override
	public StudentInstitutionTranscript getStudentInstitutionTranscriptForSLE(String userId) {
		// boolean coursesEvaluated;
		/*
		 * List<StudentInstitutionTranscript> sitList =
		 * studentEvaluationDao.getOfficialStudentInstitutionTranscriptList();
		 * 
		 * for(StudentInstitutionTranscript sit : sitList){
		 * if(isTranscriptEligibleForLOPESOrSLE(sit)){ return sit; } }
		 */

		/*
		 * coursesEvaluated = true;
		 * if(sit.getInstitution().getEvaluationStatus()
		 * .equalsIgnoreCase("EVALUATED")){ List<StudentTranscriptCourse>
		 * stcList =
		 * transcriptMgmtDAO.getStudentTransferCoursesByTranscriptId(sit
		 * .getId(), sit.getInstitution().getId()); for(StudentTranscriptCourse
		 * stc : stcList){
		 * if(!stc.getTransferCourse().getEvaluationStatus().equalsIgnoreCase
		 * ("EVALUATED")){ coursesEvaluated = false; break; } }
		 * if(coursesEvaluated){ return sit; } }
		 */
		//return studentEvaluationDao.getOldestSITForSLE();
		return studentEvaluationDao.findOldestSITForSLEWhichhaveCourses(userId);
		
	}

	@Override
	public boolean isTranscriptEligibleForLOPESOrSLE(
			StudentInstitutionTranscript sit) {
		if (sit.getInstitution() != null && sit.getInstitution().getEvaluationStatus() != null && !sit.getInstitution().getEvaluationStatus().isEmpty() && !sit.getInstitution().getEvaluationStatus()
				.equalsIgnoreCase(TranscriptStatusEnum.EVALUATED.getValue())) {
			return false;
		} else if (sit.getInstitution() != null && sit.getInstitution().getEvaluationStatus() != null && !sit.getInstitution().getEvaluationStatus().isEmpty() && sit.getInstitution().getEvaluationStatus()
				.equalsIgnoreCase(TranscriptStatusEnum.EVALUATED.getValue())) {
			List<StudentTranscriptCourse> stcList = transcriptMgmtDAO
					.getStudentTranscriptCoursesByTranscriptId(sit.getId(), sit
							.getInstitution().getId());
			if (stcList != null && stcList.size() > 0) {
				for (StudentTranscriptCourse stc : stcList) {
					if (stc.getTransferCourse() != null && stc.getTransferCourse().getEvaluationStatus() != null && !stc.getTransferCourse().getEvaluationStatus().isEmpty() && !stc.getTransferCourse().getEvaluationStatus()
							.equalsIgnoreCase(TranscriptStatusEnum.EVALUATED.getValue())) {
						return false;
					}
				}
			}
		}
		return true;
	}

	@Override
	public boolean isTranscriptForIEM(StudentInstitutionTranscript sit) {
		if (sit.getInstitution().getEvaluationStatus()
				.equalsIgnoreCase(TranscriptStatusEnum.CONFLICT.getValue())) {
			return true;
		} else {
			List<StudentTranscriptCourse> stcList = transcriptMgmtDAO
					.getStudentTranscriptCoursesByTranscriptId(sit.getId(), sit
							.getInstitution().getId());
			if (stcList != null && stcList.size() > 0) {
				for (StudentTranscriptCourse stc : stcList) {
					if (stc.getTransferCourse().getEvaluationStatus()
							.equalsIgnoreCase(TranscriptStatusEnum.CONFLICT.getValue())) {
						return true;
					}
				}
			}
			return false;
		}
	}

	@Override
	public List<StudentInstitutionTranscript> getAllSITListOrderByStatus() {
		return studentEvaluationDao.getAllSITListOrderByStatus();
	}

	@Override
	public StudentInstitutionTranscript getOldestREJECTEDSITByUser(User user) {
		List<StudentInstitutionTranscript> sitList = studentEvaluationDao.getAllRejectedSITByUser(user);
		if(sitList!=null&&sitList.size()>0){
			return sitList.get(0);
		}			
		return null;
	}
		
	@Override
	public List<TransferCourse> getTransferCourseByInstitutionIdAndString(
			String institutionId, String courseCode) {
		return transferCourseMgmtDAO.getTransferCourseByInstitutionIdAndString(
				institutionId, courseCode);
	}

	@Override
	public List<StudentInstitutionTranscript> getAllSITList(String status,
			String crmId) {
		return studentEvaluationDao.getAllSITList(status, crmId);
	}

	@Override
	public int getTotalTranscripts(String userId) {
		return studentEvaluationDao.getTotalTranscripts(userId);
	}

	@Override
	public int getLastMonthTranscripts(String userId) {
		return studentEvaluationDao.getLastMonthTranscripts(userId);
	}

	@Override
	public int getLast7DaysTranscripts(String userId) {
		return studentEvaluationDao.getLast7DaysTranscripts(userId);
	}

	@Override
	public int getTodaysTranscripts(String userId) {
		return studentEvaluationDao.getTodaysTranscripts(userId);
	}

	@Override
	public List<ChartValueObject> getChartValues(String userId) {
		return studentEvaluationDao.getChartValues(userId);
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, readOnly = false, rollbackForClassName = { "java.lang.Exception" })
	public void createStudentInstitutionDegrees(
			StudentProgramEvaluation studentProgramEvaluation,
			List<StudentInstitutionDegree> studentInstitutionDegrees,
			Institution institution, Date lastDateOfLastCourse,
			StudentInstitutionTranscript sit) {
		// TODO Auto-generated method stub
		List<StudentInstitutionTranscript> sitListForArchival = getStudentInstitutionTranscriptListForStudentAndInstitution(
				studentProgramEvaluation.getStudentId(), institution.getId());

		List<StudentTranscriptCourse> stcForModificationList = new ArrayList<StudentTranscriptCourse>();
		List<StudentInstitutionDegree> sidForDeletionList = new ArrayList<StudentInstitutionDegree>();

		// TODO: Commented by Avinash -- Need to lookinto the usage of archive
		// tables as we removed them
		// if( sitListForArchival != null && sitListForArchival.size() > 0 ) {
		//
		// List<StudentTranscriptCourseArchive> stcArchiveList = new
		// ArrayList<StudentTranscriptCourseArchive>();
		// List<StudentInstitutionDegreeArchive> sidArchiveList = new
		// ArrayList<StudentInstitutionDegreeArchive>();
		//
		// for( StudentInstitutionTranscript activeSit : sitListForArchival ) {
		//
		// StudentInstitutionTranscriptArchive sitArchive = new
		// StudentInstitutionTranscriptArchive();
		// sitArchive.copyIntoArchive( activeSit );
		// studentEvaluationDao.saveStudentInstitutionTranscriptArchive(
		// sitArchive );
		//
		// List<StudentTranscriptCourse> stcList =
		// transcriptService.getStudentTranscriptCoursesByTranscriptId(
		// activeSit.getId(), activeSit.getInstitution().getId() );
		// if( stcList != null && stcList.size() > 0 ) {
		// for( StudentTranscriptCourse activeStc : stcList ) {
		// StudentTranscriptCourseArchive stcArchive = new
		// StudentTranscriptCourseArchive();
		// stcArchive.copyIntoArchive( activeStc, sitArchive );
		// stcArchiveList.add( stcArchive );
		// stcForModificationList.add( activeStc );
		// }
		// }
		//
		// if( activeSit.getStudentInstitutionDegreeSet() != null &&
		// activeSit.getStudentInstitutionDegreeSet().size() > 0 ) {
		// for( StudentInstitutionDegree activeSid :
		// activeSit.getStudentInstitutionDegreeSet() ) {
		// StudentInstitutionDegreeArchive sidArchive = new
		// StudentInstitutionDegreeArchive();
		// sidArchive.copyIntoArchive( activeSid, sitArchive );
		// sidArchiveList.add( sidArchive );
		// sidForDeletionList.add( activeSid );
		// }
		// }
		// }
		//
		// if( stcArchiveList.size() > 0 ) {
		// transcriptService.saveTranscriptCourseArchiveList( stcArchiveList );
		// }
		//
		// if( sidArchiveList.size() > 0 ) {
		// transcriptService.saveStudentInstitutionDegreeArchiveList(
		// sidArchiveList );
		// }
		//
		// if( sidForDeletionList.size() > 0 ) {
		// transcriptService.removeStudentInstitutionDegreeList(
		// sidForDeletionList );
		// }
		//
		// studentEvaluationDao.removeStudentInstitutionTranscript(
		// sitListForArchival );
		// }

		// Create new SIT.
		// StudentInstitutionTranscript sit = new
		// StudentInstitutionTranscript();
		/*
		 * sit.setInstitution( institution ); sit.setStudentProgramEvaluation(
		 * studentProgramEvaluation ); sit.setCreatedTime( new Date() );
		 * sit.setCreatedBy(UserUtil.getCurrentUser().getId());
		 * sit.setLastDateForLastCourse( lastDateOfLastCourse );
		 * sit.setEvaluationStatus( TranscriptStatusEnum.DRAFT.getValue() );
		 * sit.setOfficial( false );
		 */
		/*
		 * StudentInstitutionTranscript sit = new
		 * StudentInstitutionTranscript(); sit.setId(null);
		 * sit.setStudentInstitutionDegreeSet
		 * (studentInstitutionTranscript.getStudentInstitutionDegreeSet());
		 * sit.setInstitution( institution ); sit.setStudentProgramEvaluation(
		 * studentProgramEvaluation ); sit.setCreatedTime( new Date() );
		 * sit.setCreatedBy(UserUtil.getCurrentUser().getId());
		 * sit.setLastDateForLastCourse( lastDateOfLastCourse );
		 * sit.setStudentProgramEvaluation(studentProgramEvaluation);
		 * sit.setEvaluationStatus( TranscriptStatusEnum.DRAFT.getValue() );
		 * sit.setOfficial( false );//Need discussion on it TODO
		 * sit.setModifiedTime(new Date());
		 */
		try {
			// saveStudentInstitutionTranscript( sit );

			// Modify existing STC to refer to new SIT.
			if (stcForModificationList.size() > 0) {
				for (StudentTranscriptCourse stcModify : stcForModificationList) {
					stcModify.setStudentInstitutionTranscript(sit);
				}
				transcriptService
						.saveStudentTranscripts(stcForModificationList);
			}

			// Create new SIDs (along with new InstitutionDegrees when
			// required).
			for (int i = 0; i < studentInstitutionDegrees.size(); i++) {
				StudentInstitutionDegree studentInstitutionDegree = studentInstitutionDegrees
						.get(i);
				// studentInstitutionDegree.setStudentProgramEvaluationId(studentProgramEvaluation.getId());
				InstitutionDegree insDegree = studentInstitutionDegree
						.getInstitutionDegree();
				if (insDegree == null) {
					insDegree = new InstitutionDegree();
				}
				insDegree.setInstitution(institution);
				studentInstitutionDegree.setInstitutionDegree(insDegree);
				// studentInstitutionDegree.setStudentProgramEvaluationId(
				// studentProgramEvaluation.getId() );
				studentInstitutionDegree.setStudentInstitutionTranscript(sit);
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
		} catch (Exception e) {
			e.printStackTrace();
			// System.out.println("Exception Occured="+e);
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Exception Occured=" + e + " RequestId:" + uniqueId, e);
		}
	}

	@Override
	public StudentInstitutionTranscript createTranscriptForStudent(
			Student student, List<StudentInstitutionDegree> sids,
			Institution institution, Date expectedStartDate, Date ldlc,
			Boolean isTranscriptOfficial, StudentInstitutionTranscript sit) {
		
		institutionService.addInstitution(institution);

		/*
		 * Get existing StudentInstitutionTranscript for this
		 * StudentProgramEvaluation (if any), along with the corresponding
		 * StudentInstitutionDegree and StudentTranscriptCourse. Copy them to
		 * archive table. Delete the SIT and SID from the active tables. Create
		 * new SIT and SIDs. Copy the existing STC to the archive table. Modify
		 * the existing STC to point to the newly created SIT.
		 */
		List<StudentInstitutionTranscript> sitListForArchival = getStudentInstitutionTranscriptListForStudentAndInstitution(
				student.getId(), institution.getId());

		List<StudentTranscriptCourse> stcForModificationList = new ArrayList<StudentTranscriptCourse>();
		List<StudentInstitutionDegree> sidForDeletionList = new ArrayList<StudentInstitutionDegree>();

		 if( sitListForArchival != null && sitListForArchival.size() > 0 ) {
			  
			  for( StudentInstitutionTranscript activeSit : sitListForArchival ) {
				  
				  List<StudentTranscriptCourse> stcList = transcriptService.getStudentTranscriptCoursesByTranscriptId( activeSit.getId(), activeSit.getInstitution().getId() );
					if( stcList != null && stcList.size() > 0 ) {
						for( StudentTranscriptCourse activeStc : stcList ) {
							stcForModificationList.add( activeStc );
						} 
					}
			  		  			  
				  if(activeSit.isMarkCompleted() != true && activeSit.getStudentInstitutionDegreeSet() != null && activeSit.getStudentInstitutionDegreeSet().size() > 0 ) { 
					  for(StudentInstitutionDegree activeSid : activeSit.getStudentInstitutionDegreeSet() ) {
						  sidForDeletionList.add( activeSid ); 
					  } 
					 } 
				  }
				 
				  if( sidForDeletionList.size() > 0 ) {
					  transcriptService.removeStudentInstitutionDegreeList(sidForDeletionList ); 
				  }
			  
			}

		// Update the SIT.
		// StudentInstitutionTranscript sit1 = new
		// StudentInstitutionTranscript();
		// sit1.setInstitution( institution );
		// sit1.setStudentProgramEvaluation( studentProgramEvaluation );
		sit.setCreatedDate(sit.getCreatedDate());
		sit.setModifiedDate(new Date());
		sit.setCreatedBy(UserUtil.getCurrentUser().getId());
		sit.setModifiedBy(UserUtil.getCurrentUser().getId());
		sit.setLastDateForLastCourse(ldlc);
		sit.setEvaluationStatus(TranscriptStatusEnum.DRAFT.getValue());
		sit.setOfficial(sit.getOfficial());
		sit.setStudentInstitutionDegreeSet(sit.getStudentInstitutionDegreeSet());
		sit.setStudentTranscriptCourse(sit.getStudentTranscriptCourse());
		sit.setInstitutionAddress(sit.getInstitutionAddress());

		// Modify existing STC to refer to new SIT ONLY for those Couses which are not marked as COMPLETED.
		List<StudentTranscriptCourse> stcForNotCompletedList = new ArrayList<StudentTranscriptCourse>();
		if (stcForModificationList.size() > 0) {
			for (StudentTranscriptCourse stcModify : stcForModificationList) {
				if(!stcModify.isMarkCompleted()){
					stcModify.setStudentInstitutionTranscript(sit);
					stcForNotCompletedList.add(stcModify);
				}
			}
			if(stcForNotCompletedList!=null && stcForNotCompletedList.size()>0){
				transcriptService.saveStudentTranscripts(stcForNotCompletedList);
			}
		}

		// Create new SIDs (along with new InstitutionDegrees when required).
		List<StudentInstitutionDegree> studentInstitutionDegreeList = sit.getStudentInstitutionDegreeSet();
		if (studentInstitutionDegreeList != null
				&& studentInstitutionDegreeList.size() > 0) {
			for (StudentInstitutionDegree studentInstitutionDegree : studentInstitutionDegreeList) {

				InstitutionDegree insDegree = studentInstitutionDegree
						.getInstitutionDegree();
				if (insDegree == null) {
					insDegree = new InstitutionDegree();
				}
				insDegree.setInstitution(institution);
				insDegree.setCreatedBy(UserUtil.getCurrentUser().getId());
				insDegree.setModifiedBy(UserUtil.getCurrentUser().getId());
				studentInstitutionDegree.setInstitutionDegree(insDegree);
				studentInstitutionDegree.setCreatedBy(UserUtil.getCurrentUser().getId());
				studentInstitutionDegree.setModifiedBy(UserUtil.getCurrentUser().getId());
				// studentInstitutionDegree.setStudentId( student.getId() );
				studentInstitutionDegree.setStudentInstitutionTranscript(sit);
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
		mergeStudentInstitutionTranscript(sit);
		return sit;
	}

	private void mergeStudentInstitutionTranscript(
			StudentInstitutionTranscript sit) {
		studentEvaluationDao.mergeStudentInstitutionTranscript(sit);

	}

	@Override
	public List<StudentInstitutionTranscript> getLatestStudentInstitutionTranscriptForStudent(
			Student student) {

		List<StudentInstitutionTranscript> sitList = studentEvaluationDao
				.getStudentInstitutionTranscriptForStudent(student);

		/*
		 * Reverse the list of SITs, then choose only the first SIT for each
		 * institution in that list to be added to the latestSitList. Again
		 * reverse the latestSitList to maintain creation order.
		 */
		List<StudentInstitutionTranscript> latestSitList = new ArrayList<StudentInstitutionTranscript>();
		List<String> institutionIdList = new ArrayList<String>();
		if (sitList != null && sitList.size() > 0) {
			Collections.reverse(sitList);
			for (StudentInstitutionTranscript studentInstitutionTranscript : sitList) {
				if (!institutionIdList.contains(studentInstitutionTranscript
						.getInstitution().getId())) {
					latestSitList.add(studentInstitutionTranscript);
					institutionIdList.add(studentInstitutionTranscript
							.getInstitution().getId());
				}
			}
			Collections.reverse(latestSitList);
		}

		if (latestSitList != null && latestSitList.size() > 0) {
			for (StudentInstitutionTranscript studentInstitutionTranscript : latestSitList) {
				List<StudentInstitutionDegree> idList = institutionService
						.getStudentInstitutionDegreeListForStudentInstitutionTranscript(studentInstitutionTranscript);
				studentInstitutionTranscript
						.setStudentInstitutionDegreeSet(idList);
			}
		}
		return latestSitList;
	}

	@Override
	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptForStudent(
			Student student) {
		List<StudentInstitutionTranscript> sitList = studentEvaluationDao
				.getStudentInstitutionTranscriptForStudent(student);
		if (sitList != null && sitList.size() > 0) {
			for (StudentInstitutionTranscript studentInstitutionTranscript : sitList) {
				List<StudentInstitutionDegree> idList = institutionService
						.getStudentInstitutionDegreeListForStudentInstitutionTranscript(studentInstitutionTranscript);
				studentInstitutionTranscript
						.setStudentInstitutionDegreeSet(idList);
			}
		}
		return sitList;
	}

	/**
	 * Returns a summary of the transcripts for all institutions for the
	 * student.
	 */
	@Override
	public List<StudentInstitutionTranscriptSummary> getStudentTranscriptSummary(
			Student student) {
		List<StudentInstitutionTranscriptSummary> stdInstTrnstSummaryList = new ArrayList<StudentInstitutionTranscriptSummary>();
		List<StudentInstitutionTranscript> sitList = studentEvaluationDao
				.getStudentInstitutionTranscriptForStudent(student);
		Map<String, List<StudentInstitutionTranscript>> institutionStdTranscriptMap = new HashMap<String, List<StudentInstitutionTranscript>>();
		if (sitList != null && !sitList.isEmpty()) {
			for (StudentInstitutionTranscript sit : sitList) {
				List<StudentInstitutionTranscript> stdInstTrnstList = institutionStdTranscriptMap
						.get(sit.getInstitution().getId());
				if (stdInstTrnstList == null) {
					stdInstTrnstList = new ArrayList<StudentInstitutionTranscript>();
					institutionStdTranscriptMap.put(sit.getInstitution().getId(), stdInstTrnstList);
				}
				stdInstTrnstList.add(sit);
			}
		}
		for (String instId : institutionStdTranscriptMap.keySet()) {
			stdInstTrnstSummaryList
					.add(getStdInstTrnstSummaryForInstitution(institutionStdTranscriptMap
							.get(instId)));
		}
		for(StudentInstitutionTranscriptSummary  studentInstitutionTranscriptSummary : stdInstTrnstSummaryList){
			List<StudentInstitutionTranscript>  sitListToCheckIfExist = studentEvaluationDao.getAllMarkCompletedSITForStudentAndInstitute(student.getId(),studentInstitutionTranscriptSummary.getStudentInstitutionTranscript().getInstitution().getId());
			
			if(sitListToCheckIfExist != null && !sitListToCheckIfExist.isEmpty() && sitListToCheckIfExist.size()>0){
					List<StudentTranscriptCourse> officalStudentTranscriptCourseList = studentEvaluationDao.getAllNotEvaluatedStudentTranscriptCourses(student.getId(),studentInstitutionTranscriptSummary.getStudentInstitutionTranscript().getInstitution().getId(),true,true);
					
					if(officalStudentTranscriptCourseList != null && !officalStudentTranscriptCourseList.isEmpty() && officalStudentTranscriptCourseList.size()>0){
						studentInstitutionTranscriptSummary.setTranscriptEvaluationStatus(TranscriptStatusEnum.INPROGRESS.getValue());
					}else{
						List<StudentTranscriptCourse> officalStudentTranscriptCourseNotExistList = studentEvaluationDao.getAllNotEvaluatedStudentTranscriptCourses(student.getId(),studentInstitutionTranscriptSummary.getStudentInstitutionTranscript().getInstitution().getId(),true,false);
						
						List<StudentTranscriptCourse> unOfficalStudentTranscriptCourseList = studentEvaluationDao.getAllNotEvaluatedStudentTranscriptCourses(student.getId(),studentInstitutionTranscriptSummary.getStudentInstitutionTranscript().getInstitution().getId(),false,true);
						
						List<StudentTranscriptCourse> unOfficalStudentTranscriptCourseNotExistList = studentEvaluationDao.getAllNotEvaluatedStudentTranscriptCourses(student.getId(),studentInstitutionTranscriptSummary.getStudentInstitutionTranscript().getInstitution().getId(),false,false);
						
						
						
						if(unOfficalStudentTranscriptCourseList != null && !unOfficalStudentTranscriptCourseList.isEmpty() && unOfficalStudentTranscriptCourseList.size()>0){
							studentInstitutionTranscriptSummary.setTranscriptEvaluationStatus(TranscriptStatusEnum.INPROGRESS.getValue());
						}else{
							if(officalStudentTranscriptCourseNotExistList != null && !officalStudentTranscriptCourseNotExistList.isEmpty() && officalStudentTranscriptCourseNotExistList.size()>0){
								studentInstitutionTranscriptSummary.setTranscriptEvaluationStatus(TranscriptStatusEnum.OFFICIALLYEVALUATED.getValue());
							}else{
								if(unOfficalStudentTranscriptCourseNotExistList != null && !unOfficalStudentTranscriptCourseNotExistList.isEmpty() && unOfficalStudentTranscriptCourseNotExistList.size()>0){
									studentInstitutionTranscriptSummary.setTranscriptEvaluationStatus(TranscriptStatusEnum.AWAITINGOFFICIALTRANSCRIPT.getValue());
								}else if(unOfficalStudentTranscriptCourseNotExistList == null || unOfficalStudentTranscriptCourseNotExistList.isEmpty()){
									studentInstitutionTranscriptSummary.setTranscriptEvaluationStatus(TranscriptStatusEnum.AWAITINGOFFICIALTRANSCRIPT.getValue());
								}else if((officalStudentTranscriptCourseNotExistList == null || officalStudentTranscriptCourseNotExistList.isEmpty() ) && (unOfficalStudentTranscriptCourseNotExistList == null || unOfficalStudentTranscriptCourseNotExistList.isEmpty())){
									studentInstitutionTranscriptSummary.setTranscriptEvaluationStatus(TranscriptStatusEnum.OFFICIALLYEVALUATED.getValue());
								}
							}
		
						}
					}
			}else{
				studentInstitutionTranscriptSummary.setTranscriptEvaluationStatus(TranscriptStatusEnum.DRAFT.getValue());
			}	
			
		}
		return stdInstTrnstSummaryList;
	}

	/**
	 * Returns a transcript summary for the student from the list of all the
	 * transcripts for student from anInstitution
	 * 
	 * @param list
	 * @return
	 */
	private StudentInstitutionTranscriptSummary getStdInstTrnstSummaryForInstitution(
			List<StudentInstitutionTranscript> sitList) {
		// sort the studentInstitutionTranscripts by dateModified By
		Collections.sort(sitList,
				new StudentInstitutionTranscriptDateComparator());
		StudentInstitutionTranscriptSummary sitSummary = new StudentInstitutionTranscriptSummary();
		sitSummary
				.setTranscriptEvaluationStatus(getTrnstEvaluationStatus(sitList));
		if (sitList.size() > 0) {
			// TODO:Need to set the dateCreated and dateModified Appropriattely
			sitSummary.setDateCreated(sitList.get(0).getModifiedDate());
			sitSummary.setDateModified(sitList.get(0).getModifiedDate());
			sitSummary.setStudentInstitutionTranscript(sitList.get(0));
		}

		return sitSummary;
	}

	/**
	 * Returns a summarized transcript evaluation status from a list of
	 * studentInstitutiontranscripts
	 * 
	 * @param sitList
	 * @return
	 */
	private String getTrnstEvaluationStatus(
			List<StudentInstitutionTranscript> sitList) {
		// check to see if any transcript status is in Progress
		for (StudentInstitutionTranscript sit : sitList) {
			String trnscriptStatus = sit.getEvaluationStatus();
			if (trnscriptStatus != null
					&& TranscriptStatusEnum.INPROGRESS.getValue()
							.equalsIgnoreCase(trnscriptStatus)) {
				return TranscriptStatusEnum.INPROGRESS.getValue();
			}
		}
		if (sitList.size() > 0) {
			return sitList.get(0).getEvaluationStatus();
		}
		return null;
	}

	@Override
	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptForStudentAndInstitute(
			String studentId, String institutionId) {
		// TODO Auto-generated method stub
		return transcriptMgmtDAO.getStudentInstitutionTranscriptForStudentAndInstitute(studentId, institutionId);
	}
	@Override
	public StudentInstitutionTranscript getOldestStudentInstitutionTranscriptForStudentAndInstitute(
			String studentId, String institutionId,boolean markCompleted) {
		// TODO Auto-generated method stub
		return transcriptMgmtDAO.findOldestStudentInstitutionTranscriptForStudentAndInstitute(studentId,institutionId,markCompleted);
	}
	@Override
	public List<StudentInstitutionTranscript> getAllRejectedSITByUser(User user) {
		return studentEvaluationDao.getAllRejectedSITByUser(user);
	}

	@Override
	public List<StudentInstitutionTranscript> getAllTranscriptForStudentAndInstitute(String studentId, String institutionId, boolean transcriptType, String evaluationStatus) {
		// TODO Auto-generated method stub
		return transcriptMgmtDAO.getStudentInstitutionTranscriptForStudentAndInstituteForTranscriptTypeWithEvaluationStatus(studentId, institutionId,transcriptType,evaluationStatus);
	}

	@Override
	public boolean isTranscriptEligibleForLOPESOrSLEForEvaluation(StudentInstitutionTranscript sit) {
		if (!sit.getInstitution().getEvaluationStatus()
				.equalsIgnoreCase(TranscriptStatusEnum.EVALUATED.getValue())) {
			return false;
		} else if (sit.getInstitution().getEvaluationStatus().equalsIgnoreCase(TranscriptStatusEnum.EVALUATED.getValue())) {
			List<StudentTranscriptCourse> stcList = transcriptMgmtDAO.getStudentTranscriptCoursesByTranscriptId(sit.getId(), sit.getInstitution().getId());
			List<InstitutionTermType> instTermTypeList = institutionTermTypeService.getAllInstitutionTermType(sit.getInstitution().getId());
			sit.setStudentTranscriptCourse(stcList);
			if (stcList != null && stcList.size() > 0) {
				for (StudentTranscriptCourse stc : stcList) {
					TransferCourseTitle transferCourseTitle = transferCourseService.getTransferCourseTitleById(stc.getTransferCourseTitleId());
					if(transferCourseTitle!=null){
						stc.setTransferCourseTitle(transferCourseTitle);
						stc.setCourseTitle( transferCourseTitle.getTitle() );
					}
					if (!stc.getTransferCourse().getEvaluationStatus()
							.equalsIgnoreCase(TranscriptStatusEnum.EVALUATED.getValue())) {
						return false;
					}else{
						InstitutionTermType institutionTermType = null;
						for(InstitutionTermType institutionTermTypes: instTermTypeList){
							if(institutionTermTypes.getEffectiveDate().compareTo(stc.getCompletionDate())<0 && ((institutionTermTypes.getEndDate()!=null && institutionTermTypes.getEndDate().compareTo(stc.getCompletionDate())>0) || institutionTermTypes.getEndDate()==null)){
								institutionTermType = institutionTermTypes;
							}
						}
						if(institutionTermType !=null){
							stc.setInstitutionTermType(institutionTermType);
						}
						/**START FOR MILITARY TRANSCRIPT*/
						if(sit.getInstitution() != null && sit.getInstitution().getInstitutionType() != null && sit.getInstitution().getInstitutionType().getId().equals("5")){
							List<TranscriptCourseSubject> transcriptCourseSubjectList = transferCourseService.getAllTranscriptCourseSubjectByStudentTranscriptCourseId(stc.getId());
							
							if(transcriptCourseSubjectList != null && !transcriptCourseSubjectList.isEmpty()){
								
								for(TranscriptCourseSubject transcriptCourseSubject : transcriptCourseSubjectList){
									 List<MilitarySubject> militarySubjectList = transferCourseService.getMilitarySubjectByTransferCourseId(stc.getTransferCourse().getId());
									 if(militarySubjectList != null && !militarySubjectList.isEmpty()){
										 
										 for(MilitarySubject militarySubject : militarySubjectList){
											 if(militarySubject.getId().equals(transcriptCourseSubject.getSubjectId())){
												 transcriptCourseSubject.setMilitarySubject(militarySubject);
											 }
										 }
										 stc.setMilitarySubjectList(militarySubjectList);
									 }
								}								
								stc.setTranscriptCourseSubjectList(transcriptCourseSubjectList);
							}
						}
						/**END*/
					}
				}
				
			}
		}
		return true;
	}
	@Override
	public List<StudentInstitutionTranscript> getDistinctRejectedSITByUser(
			User user) {
		// TODO Auto-generated method stub
		return studentEvaluationDao.findDistinctRejectedSITByUser(user);
	}
	@Override
	public List<StudentInstitutionTranscript> getAllRejectedSITByUserForStudentAndInstitute(
			String studentId, String instituteId, User currentUser) {
		// TODO Auto-generated method stub
		return studentEvaluationDao.findAllRejectedSITByUserForStudentAndInstitute(studentId,instituteId,currentUser);
	}
	@Override
	public List<StudentTranscriptCourse> getAllRejectedSTCByUserForStudentAndInstitute(
			String studentInstitutionTranscriptId, String studentId, String institutionId, User currentUser) {
		// TODO Auto-generated method stub
		return studentEvaluationDao.findAllRejectedSTCByUserForStudentAndInstitute(studentInstitutionTranscriptId,studentId,institutionId,currentUser);
	}
	@Override
	public StudentInstitutionTranscript getOldestStudentInstitutionTranscriptAlreadyOccupyByUser(
			String OccupyById, String evaluationStatus) {
		
		return studentEvaluationDao.findOldestStudentInstitutionTranscriptAlreadyOccupyByUser(OccupyById,evaluationStatus);
	}
	@Override
	public StudentInstitutionTranscript getNextOldestStudentInstitutionTranscriptAlreadyOccupyByUser(
			Date createdDate,String transcriptIds) {
		return studentEvaluationDao.findNextOldestStudentInstitutionTranscriptAlreadyOccupyByUser(createdDate, transcriptIds);
	}
	@Override
	public List<GCUDegree> getGCUInsitutionDegree() {
			
		return studentEvaluationDao.findGCUInsitutionDegree();
	}
	@Override
	public StudentInstitutionTranscript createMilitaryTranscriptForStudent(
			Student student, Institution institution, Date expectedStartDate,
			Boolean isTranscriptOfficial,
			StudentInstitutionTranscript sit) {
		institutionService.addInstitution(institution);

		/*
		 * Get existing StudentInstitutionTranscript for this
		 * StudentProgramEvaluation (if any), along with the corresponding
		 * StudentInstitutionDegree and StudentTranscriptCourse. Copy them to
		 * archive table. Delete the SIT and SID from the active tables. Create
		 * new SIT and SIDs. Copy the existing STC to the archive table. Modify
		 * the existing STC to point to the newly created SIT.
		 */
		List<StudentInstitutionTranscript> sitListForArchival = getStudentInstitutionTranscriptListForStudentAndInstitution(
				student.getId(), institution.getId());

		List<StudentTranscriptCourse> stcForModificationList = new ArrayList<StudentTranscriptCourse>();

		 if( sitListForArchival != null && sitListForArchival.size() > 0 ) {
			  
			  for( StudentInstitutionTranscript activeSit : sitListForArchival ) {
				  
				  List<StudentTranscriptCourse> stcList = transcriptService.getStudentTranscriptCoursesByTranscriptId( activeSit.getId(), activeSit.getInstitution().getId() );
					if( stcList != null && stcList.size() > 0 ) {
						for( StudentTranscriptCourse activeStc : stcList ) {
							stcForModificationList.add( activeStc );
						} 
					}
			  	 
				  }
			  
			}

		// Update the SIT.
		// StudentInstitutionTranscript sit1 = new
		// StudentInstitutionTranscript();
		// sit1.setInstitution( institution );
		// sit1.setStudentProgramEvaluation( studentProgramEvaluation );
		sit.setCreatedDate(sit.getCreatedDate());
		sit.setModifiedDate(new Date());
		sit.setCreatedBy(UserUtil.getCurrentUser().getId());
		sit.setModifiedBy(UserUtil.getCurrentUser().getId());
		sit.setLastDateForLastCourse(new Date());
		sit.setEvaluationStatus(TranscriptStatusEnum.DRAFT.getValue());
		sit.setOfficial(sit.getOfficial());
		sit.setStudentInstitutionDegreeSet(sit.getStudentInstitutionDegreeSet());
		sit.setStudentTranscriptCourse(sit.getStudentTranscriptCourse());
		sit.setInstitutionAddress(sit.getInstitutionAddress());

		// Modify existing STC to refer to new SIT ONLY for those Couses which are not marked as COMPLETED.
		List<StudentTranscriptCourse> stcForNotCompletedList = new ArrayList<StudentTranscriptCourse>();
		if (stcForModificationList.size() > 0) {
			for (StudentTranscriptCourse stcModify : stcForModificationList) {
				if(!stcModify.isMarkCompleted()){
					stcModify.setStudentInstitutionTranscript(sit);
					stcForNotCompletedList.add(stcModify);
				}
			}
			if(stcForNotCompletedList!=null && stcForNotCompletedList.size()>0){
				transcriptService.saveStudentTranscripts(stcForNotCompletedList);
			}
		}
		mergeStudentInstitutionTranscript(sit);
		return sit;
	}
	@Override
	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptListForSLE(
			String userId) {
		
		return studentEvaluationDao.findOldestSITListForSLEWhichhaveCourses(userId);
	}
}
