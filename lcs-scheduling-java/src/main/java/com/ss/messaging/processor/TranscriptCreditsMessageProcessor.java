package com.ss.messaging.processor;

import java.util.ArrayList;
import java.util.List;

import javax.jms.Message;
import javax.jms.ObjectMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import com.ss.common.util.SchedulingSystemConstants;
import com.ss.course.service.CourseMgmtService;
import com.ss.course.value.CourseCategoryMapping;
import com.ss.course.value.GCUCourseCategory;
import com.ss.evaluation.dto.SLETransferCreditSplit;
import com.ss.evaluation.dto.StudentTransferCredits;
import com.ss.evaluation.dto.TranscriptTransferCreditsDTO;
import com.ss.evaluation.enums.GCUCourseCategoryTCourseEnum;
import com.ss.evaluation.value.StudentInstitutionTranscript;
import com.ss.evaluation.value.StudentTranscriptCourse;

import edu.gcu.campusvue.service.client.CampusVueServiceClient;
import edu.gcu.campusvue.service.dto.TransferCreditsServiceDTO;

@Component
public class TranscriptCreditsMessageProcessor implements MessageProcessor {

	@Autowired
	private CampusVueServiceClient campusVueServiceClient;
	
    @Autowired
	private CourseMgmtService courseMgmtService;

	private static transient Logger log = LoggerFactory.getLogger(TranscriptCreditsMessageProcessor.class);

	@Override
	public void process(Message message) throws Exception {
		if (message instanceof ObjectMessage) {
			ObjectMessage objMsg = (ObjectMessage) message;
			TranscriptTransferCreditsDTO ttc = (TranscriptTransferCreditsDTO) objMsg.getObject();
			StudentInstitutionTranscript sit = ttc.getStudentInstitutionTranscript();
			List<StudentTransferCredits> studentTransferCreditsList = ttc.getTransferCreditsList();
			List<TransferCreditsServiceDTO> transferCreditsServiceDTOList = new ArrayList<TransferCreditsServiceDTO>();
			for (StudentTransferCredits stdTrnsCredits : studentTransferCreditsList) {
				StudentTranscriptCourse stc = stdTrnsCredits.getStudentTranscriptCourse();
				List<SLETransferCreditSplit> creditSplitList = stdTrnsCredits.getTransferCreditSplitList();
				transferCreditsServiceDTOList.addAll(convertToTrnsfrCrdtsServiceDTO(stc, stdTrnsCredits, creditSplitList, sit.getStudent().getCampusvueId()));
			}
			campusVueServiceClient.postTransferCredits(transferCreditsServiceDTOList);
		}
	}

	/**
	 * Method that returns a TransferCreditsServiceDTO list from
	 * studentTranscriptCourse, SLETransferCreditSplit list
	 * 
	 * @param stc
	 * @param stdTrnsCredits
	 * @param creditSplitList
	 * @return
	 */
	private List<TransferCreditsServiceDTO> convertToTrnsfrCrdtsServiceDTO(StudentTranscriptCourse stc, StudentTransferCredits stdTrnsCredits,
		List<SLETransferCreditSplit> creditSplitList, String studentNumber) {
		TCourseCounter tcourseCounter = new TCourseCounter();
		List<TransferCreditsServiceDTO> transferCreditsServiceDTOList = new ArrayList<TransferCreditsServiceDTO>();
		for (SLETransferCreditSplit sleTrnsCreditSplit : creditSplitList) {
				TransferCreditsServiceDTO transferCreditsServiceDTO = new TransferCreditsServiceDTO();
				transferCreditsServiceDTO.setCreditsEarned(String.valueOf(stc.getCreditsTransferred()));
				transferCreditsServiceDTO.setDateCompleted(stc.getCompletionDate());
				transferCreditsServiceDTO.setFromTransferCourseCode(stc.getTransferCourse().getTrCourseCode());
				transferCreditsServiceDTO.setGradeReceived(stc.getGrade());
				transferCreditsServiceDTO.setInstitutionCode(stc.getInstitution().getInstitutionID());
				transferCreditsServiceDTO.setStudentNumber(studentNumber);
				transferCreditsServiceDTO.setCreditsToTransfer(sleTrnsCreditSplit.getCreditsToTransfer());
				String transferStatus =getTransferStatus(stc,sleTrnsCreditSplit);
 			    transferCreditsServiceDTO.setStatus(transferStatus);
				transferCreditsServiceDTO.setToCampusCourseCode(getToCampusCourseCode(sleTrnsCreditSplit,isMappingCourseId(stc),transferStatus,tcourseCounter));
				log.info(transferCreditsServiceDTO.toString());
				transferCreditsServiceDTOList.add(transferCreditsServiceDTO);
			}

		return transferCreditsServiceDTOList;

	}

	/**
	 * Returns the ToCampusCourseCode to be used for transferring the credit
	 * @param sleTrnsCreditSplit
	 * @param mappingCourseId
	 * @param transferStatus 
	 * @param tcourseCounter 
	 * @return
	 */
	private String getToCampusCourseCode(SLETransferCreditSplit sleTrnsCreditSplit, boolean isMappingCourseId, String transferStatus, TCourseCounter tcourseCounter) {
		if(!"APPROVED".equalsIgnoreCase(transferStatus)) {
			return null;
		}
		if(isMappingCourseId) {
			return sleTrnsCreditSplit.getCourseCode();
		}else {
			String categoryMappingId = sleTrnsCreditSplit.getCourseCategoryMappingId();
			CourseCategoryMapping courseCategoryMapping = courseMgmtService.getCourseCategoryMapping(categoryMappingId);
			GCUCourseCategory gcuCourseCategory = courseCategoryMapping.getGcuCourseCategory();
			GCUCourseCategoryTCourseEnum gcuCategEnum = GCUCourseCategoryTCourseEnum.CODE_MAP.get(gcuCourseCategory.getId());
			String courseCode = getTCourseCode(tcourseCounter,gcuCategEnum);
			return courseCode;
		}
 	}

	/**
	 * Using the counter and the gcuCaegEnum builds the next available TCourse that needs to be used
	 * @param tcourseCounter
	 * @param gcuCategEnum
	 * @return
	 */
	private String getTCourseCode(TCourseCounter tcourseCounter, GCUCourseCategoryTCourseEnum gcuCategEnum) {
  		String courseCode = gcuCategEnum.getTcoursePrefix()+tcourseCounter.getCounterValue(gcuCategEnum.getDbId());
 		return courseCode;
	}

	/**
	 * Returns the transferStatus based on mappingId value
	 * 
	 * @param stc
	 * @param sleTrnsCreditSplit
	 * @return
	 */
	private String getTransferStatus(StudentTranscriptCourse stc, SLETransferCreditSplit sleTrnsCreditSplit) {
		String courseMappingId = stc.getCourseMappingId();
		String courseCategoryMappingId = sleTrnsCreditSplit.getCourseCategoryMappingId();
		if (courseMappingId == null && courseCategoryMappingId == null) {
			// if we get in here then there is something wrong and is an error case
			return null;
		}
		if (isMappingCourseId(stc)){
			if(courseMappingId.equalsIgnoreCase(SchedulingSystemConstants.Transcript_Credit_NOT_APPLIED)
				|| courseMappingId.equalsIgnoreCase(SchedulingSystemConstants.Transcript_Credit_SUBMITTED) || courseMappingId
					.equalsIgnoreCase(SchedulingSystemConstants.Transcript_Credit_NOT_APPROVED)) {
			return courseMappingId.toUpperCase();
		} 
		return SchedulingSystemConstants.Transcript_Credit_APPROVED;
		}else {
			
		if (courseCategoryMappingId.equalsIgnoreCase(SchedulingSystemConstants.Transcript_Credit_NOT_APPLIED)
			|| courseCategoryMappingId.equalsIgnoreCase(SchedulingSystemConstants.Transcript_Credit_SUBMITTED)
			|| courseCategoryMappingId.equalsIgnoreCase(SchedulingSystemConstants.Transcript_Credit_NOT_APPROVED)) {
			return courseMappingId.toUpperCase();
		}
		return SchedulingSystemConstants.Transcript_Credit_APPROVED;
		}
	}

	/**
	 * Returns true if the courseMappingId in StudentTranscriptCourse record is
	 * populated
	 * 
	 * @param stc
	 * @return
	 */
	private boolean isMappingCourseId(StudentTranscriptCourse stc) {
		if (StringUtils.hasText(stc.getCourseMappingId())) {
			return true;
		}
		return false;
	}
}
