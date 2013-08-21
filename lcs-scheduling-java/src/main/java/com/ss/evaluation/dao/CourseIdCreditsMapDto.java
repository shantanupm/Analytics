package com.ss.evaluation.dao;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ss.evaluation.controller.StudentLevelEvaluatorController;
import com.ss.evaluation.dto.SLETransferCreditSplit;
import com.ss.evaluation.dto.TrnscrptCrseSbjctIdCrdtsTrnsfrDto;

public class CourseIdCreditsMapDto {

	private String studentTranscriptCourseId;
	private String mappingId;
	private String mappingType;
	private String totalCreditsToTransfer;
	private List<SLETransferCreditSplit> gcuCrseCrdsToTrnsList = new ArrayList<SLETransferCreditSplit>();
	private String militarySubjectId;
 
	private static transient Logger log = LoggerFactory.getLogger( CourseIdCreditsMapDto.class );

	/**
	 * @return the mappingId
	 */
	public String getMappingId() {
		return mappingId;
	}

	/**
	 * @return the mappingType
	 */
	public String getMappingType() {
		return mappingType;
	}

	/**
	 * @return the gcuCrseCrdsToTrnsList
	 */
	public List<SLETransferCreditSplit> getGcuCrseCrdsToTrnsList() {
		return gcuCrseCrdsToTrnsList;
	}

	/**
	 * @param mappingId
	 *            the mappingId to set
	 */
	public void setMappingId(String mappingId) {
		this.mappingId = mappingId;
	}

	/**
	 * @param mappingType
	 *            the mappingType to set
	 */
	public void setMappingType(String mappingType) {
		this.mappingType = mappingType;
	}

	/**
	 * @param gcuCrseCrdsToTrnsList
	 *            the gcuCrseCrdsToTrnsList to set
	 */
	public void setGcuCrseCrdsToTrnsList(
			List<SLETransferCreditSplit> gcuCrseCrdsToTrnsList) {
		this.gcuCrseCrdsToTrnsList = gcuCrseCrdsToTrnsList;
	}

	public void addSLECourseCreditSplitInfo(String courseCode,
			String courseCredit) {
		SLETransferCreditSplit sleTransferCreditSplit = new SLETransferCreditSplit();
		sleTransferCreditSplit.setCourseCode(courseCode);
		sleTransferCreditSplit.setCreditsToTransfer(courseCredit);
 		gcuCrseCrdsToTrnsList.add(sleTransferCreditSplit);
	}

	/**
	 * @return the totalCreditsToTransfer
	 */
	public String getTotalCreditsToTransfer() {
		return totalCreditsToTransfer;
	}

	/**
	 * @param totalCreditsToTransfer
	 *            the totalCreditsToTransfer to set
	 */
	public void setTotalCreditsToTransfer(String totalCreditsToTransfer) {
		this.totalCreditsToTransfer = totalCreditsToTransfer;
	}

	/**
	 * @return the studentTranscriptCourseId
	 */
	public String getStudentTranscriptCourseId() {
		return studentTranscriptCourseId;
	}

	/**
	 * @param studentTranscriptCourseId
	 *            the studentTranscriptCourseId to set
	 */
	public void setStudentTranscriptCourseId(String studentTranscriptCourseId) {
		this.studentTranscriptCourseId = studentTranscriptCourseId;
	}

	/**
	 * @return the militarySubjectId
	 */
	public String getMilitarySubjectId() {
		return militarySubjectId;
	}

	/**
	 * @param militarySubjectId the militarySubjectId to set
	 */
	public void setMilitarySubjectId(String militarySubjectId) {
		this.militarySubjectId = militarySubjectId;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return String
			.format(
				"CourseIdCreditsMapDto [studentTranscriptCourseId=%s, mappingId=%s, mappingType=%s, totalCreditsToTransfer=%s, gcuCrseCrdsToTrnsList=%s, militarySubjectId=%s]",
				studentTranscriptCourseId, mappingId, mappingType, totalCreditsToTransfer, gcuCrseCrdsToTrnsList, militarySubjectId);
	}

	/**
	 * Returns the total no of credits in Floating point representation
	 * 
	 * @return
	 */
	public float getTotalCreditsToTransferInFloat() {
		float totalCredits = 0.0f;
		try {
			totalCredits = Float.valueOf(this.getTotalCreditsToTransfer());
		} catch (Exception e) {
           log.error("Error Occurred while converting the total transfer credits to a floating point number",e);
           log.error(toString());
		}
		return totalCredits;
	}

}
