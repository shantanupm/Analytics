package com.ss.evaluation.dto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.ss.course.value.CourseCategoryMapping;
import com.ss.evaluation.value.StudentTranscriptCourse;

public class StudentTransferCredits implements Serializable {
	
	
	private static final long serialVersionUID = 1L;
	private StudentTranscriptCourse studentTranscriptCourse;
	private List<SLETransferCreditSplit> transferCreditSplitList = new ArrayList<SLETransferCreditSplit>();
 	private boolean isMilitaryTransacriptCredit = false;
	
	
	public void addSLECourseCreditSplitInfo(String courseCode, float courseCredit,String courseCategoryMappingId) {
		SLETransferCreditSplit sleTransferCreditSplit = new SLETransferCreditSplit();
		sleTransferCreditSplit.setCourseCode(courseCode);
		sleTransferCreditSplit.setCreditsToTransfer(String.valueOf(courseCredit));
		sleTransferCreditSplit.setCourseCategoryMappingId(courseCategoryMappingId);
		transferCreditSplitList.add(sleTransferCreditSplit);		
	}


	/**
	 * @return the studentTranscriptCourse
	 */
	public StudentTranscriptCourse getStudentTranscriptCourse() {
		return studentTranscriptCourse;
	}


	/**
	 * @return the transferCreditSplitList
	 */
	public List<SLETransferCreditSplit> getTransferCreditSplitList() {
		return transferCreditSplitList;
	}


	/**
	 * @param studentTranscriptCourse the studentTranscriptCourse to set
	 */
	public void setStudentTranscriptCourse(
			StudentTranscriptCourse studentTranscriptCourse) {
		this.studentTranscriptCourse = studentTranscriptCourse;
	}


	/**
	 * @param transferCreditSplitList the transferCreditSplitList to set
	 */
	public void setTransferCreditSplitList(
			List<SLETransferCreditSplit> transferCreditSplitList) {
		this.transferCreditSplitList = transferCreditSplitList;
	}

	/**
	 * @return the isMilitaryTransacriptCredit
	 */
	public boolean isMilitaryTransacriptCredit() {
		return isMilitaryTransacriptCredit;
	}


	/**
	 * @param isMilitaryTransacriptCredit the isMilitaryTransacriptCredit to set
	 */
	public void setMilitaryTransacriptCredit(boolean isMilitaryTransacriptCredit) {
		this.isMilitaryTransacriptCredit = isMilitaryTransacriptCredit;
	}


	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return String.format("StudentTransferCredits [studentTranscriptCourse=%s, transferCreditSplitList=%s, isMilitaryTransacriptCredit=%s]",
			studentTranscriptCourse, transferCreditSplitList, isMilitaryTransacriptCredit);
	}

}
