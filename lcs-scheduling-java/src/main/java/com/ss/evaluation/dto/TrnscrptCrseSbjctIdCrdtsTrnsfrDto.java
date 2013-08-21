package com.ss.evaluation.dto;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ss.evaluation.dao.CourseIdCreditsMapDto;

public class TrnscrptCrseSbjctIdCrdtsTrnsfrDto {
	
	private String transcriptCourseSubjectId;
	private String creditsToTransfer;
	private static transient Logger log = LoggerFactory.getLogger( TrnscrptCrseSbjctIdCrdtsTrnsfrDto.class );

	
	/**
	 * @return the transcriptCourseSubjectId
	 */
	public String getTranscriptCourseSubjectId() {
		return transcriptCourseSubjectId;
	}
	/**
	 * @return the creditsToTransfer
	 */
	public String getCreditsToTransfer() {
		return creditsToTransfer;
	}
	/**
	 * @param transcriptCourseSubjectId the transcriptCourseSubjectId to set
	 */
	public void setTranscriptCourseSubjectId(String transcriptCourseSubjectId) {
		this.transcriptCourseSubjectId = transcriptCourseSubjectId;
	}
	/**
	 * @param creditsToTransfer the creditsToTransfer to set
	 */
	public void setCreditsToTransfer(String creditsToTransfer) {
		this.creditsToTransfer = creditsToTransfer;
	}
	
	/**
	 * Returns the number of credits in Floating point representation
	 * 
	 * @return
	 */
	public float getCreditsToTransferInFloat() {
		float totalCredits = 0.0f;
		try {
			totalCredits = Float.valueOf(this.getCreditsToTransfer());
		} catch (Exception e) {
           log.error("Error Occurred while converting the transfer credits to a floating point number",e);
           log.error(toString());
		}
		return totalCredits;
	}
	
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return String.format("TrnscrptCrseSbjctIdCrdtsTrnsfrDto [transcriptCourseSubjectId=%s, creditsToTransfer=%s]", transcriptCourseSubjectId,
			creditsToTransfer);
	}

}
