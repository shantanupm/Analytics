package edu.gcu.campusvue.service.dto;

import java.io.Serializable;
import java.util.Date;

/**
 * DTO class that is used for passing information required for posting credits to CampusVue
 * @author avinash
 *
 */
public class TransferCreditsServiceDTO implements Serializable {

	private static final long serialVersionUID = 1L;
	private String studentNumber;
	private String FromTransferCourseCode;
	private String toCampusCourseCode;
	private String creditsToTransfer;
	private String creditsEarned;
	private String gradeReceived;
	private String institutionCode;
	private Date dateStarted;
	private Date dateCompleted;
	private String status;
	private int correlationId;

	/**
	 * @return the studentNumber
	 */
	public String getStudentNumber() {
		return studentNumber;
	}

	/**
	 * @return the fromTransferCourseCode
	 */
	public String getFromTransferCourseCode() {
		return FromTransferCourseCode;
	}

	/**
	 * @return the toCampusCourseCode
	 */
	public String getToCampusCourseCode() {
		return toCampusCourseCode;
	}

	/**
	 * @return the creditsToTransfer
	 */
	public String getCreditsToTransfer() {
		return creditsToTransfer;
	}

	/**
	 * @return the creditsEarned
	 */
	public String getCreditsEarned() {
		return creditsEarned;
	}

	/**
	 * @return the gradeReceived
	 */
	public String getGradeReceived() {
		return gradeReceived;
	}

	/**
	 * @return the institutionCode
	 */
	public String getInstitutionCode() {
		return institutionCode;
	}

	/**
	 * @return the dateStarted
	 */
	public Date getDateStarted() {
		return dateStarted;
	}

	/**
	 * @return the dateCompleted
	 */
	public Date getDateCompleted() {
		return dateCompleted;
	}

	/**
	 * @return the status
	 */
	public String getStatus() {
		return status;
	}

	/**
	 * @param studentNumber
	 *            the studentNumber to set
	 */
	public void setStudentNumber(String studentNumber) {
		this.studentNumber = studentNumber;
	}

	/**
	 * @param fromTransferCourseCode
	 *            the fromTransferCourseCode to set
	 */
	public void setFromTransferCourseCode(String fromTransferCourseCode) {
		FromTransferCourseCode = fromTransferCourseCode;
	}

	/**
	 * @param toCampusCourseCode
	 *            the toCampusCourseCode to set
	 */
	public void setToCampusCourseCode(String toCampusCourseCode) {
		this.toCampusCourseCode = toCampusCourseCode;
	}

	/**
	 * @param creditsToTransfer
	 *            the creditsToTransfer to set
	 */
	public void setCreditsToTransfer(String creditsToTransfer) {
		this.creditsToTransfer = creditsToTransfer;
	}

	/**
	 * @param creditsEarned
	 *            the creditsEarned to set
	 */
	public void setCreditsEarned(String creditsEarned) {
		this.creditsEarned = creditsEarned;
	}

	/**
	 * @param gradeReceived
	 *            the gradeReceived to set
	 */
	public void setGradeReceived(String gradeReceived) {
		this.gradeReceived = gradeReceived;
	}

	/**
	 * @param institutionCode
	 *            the institutionCode to set
	 */
	public void setInstitutionCode(String institutionCode) {
		this.institutionCode = institutionCode;
	}

	/**
	 * @param dateStarted
	 *            the dateStarted to set
	 */
	public void setDateStarted(Date dateStarted) {
		this.dateStarted = dateStarted;
	}

	/**
	 * @param dateCompleted
	 *            the dateCompleted to set
	 */
	public void setDateCompleted(Date dateCompleted) {
		this.dateCompleted = dateCompleted;
	}

	/**
	 * @param status
	 *            the status to set
	 */
	public void setStatus(String status) {
		this.status = status;
	}

	/**
	 * @return the correlationId
	 */
	public int getCorrelationId() {
		return correlationId;
	}

	/**
	 * @param correlationId the correlationId to set
	 */
	public void setCorrelationId(int correlationId) {
		this.correlationId = correlationId;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return String
				.format("TransferCreditsServiceDTO [studentNumber=%s, FromTransferCourseCode=%s, toCampusCourseCode=%s, creditsToTransfer=%s, creditsEarned=%s, gradeReceived=%s, institutionCode=%s, dateStarted=%s, dateCompleted=%s, status=%s, correlationId=%s]",
						studentNumber, FromTransferCourseCode,
						toCampusCourseCode, creditsToTransfer, creditsEarned,
						gradeReceived, institutionCode, dateStarted,
						dateCompleted, status, correlationId);
	}
}
