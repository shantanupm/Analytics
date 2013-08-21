package com.ss.evaluation.dto;

import java.io.Serializable;

public class SLETransferCreditSplit implements Serializable{
	 
	private static final long serialVersionUID = 1L;
	private String courseCode;
	private String creditsToTransfer;
	private String courseCategoryMappingId;
	
	/**
	 * @return the courseCode
	 */
	public String getCourseCode() {
		return courseCode;
	}
	/**
	 * @return the creditsToTransfer
	 */
	public String getCreditsToTransfer() {
		return creditsToTransfer;
	}
	/**
	 * @param courseCode the courseCode to set
	 */
	public void setCourseCode(String courseCode) {
		this.courseCode = courseCode;
	}
	/**
	 * @param creditsToTransfer the creditsToTransfer to set
	 */
	public void setCreditsToTransfer(String creditsToTransfer) {
		this.creditsToTransfer = creditsToTransfer;
	}
	
	 
	/**
	 * @return the courseCategoryMappingId
	 */
	public String getCourseCategoryMappingId() {
		return courseCategoryMappingId;
	}
	/**
	 * @param courseCategoryMappingId the courseCategoryMappingId to set
	 */
	public void setCourseCategoryMappingId(String courseCategoryMappingId) {
		this.courseCategoryMappingId = courseCategoryMappingId;
	}
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return String.format(
				"SLETransferCreditSplit [courseCode=%s, creditsToTransfer=%s]",
				courseCode, creditsToTransfer);
	}

}
