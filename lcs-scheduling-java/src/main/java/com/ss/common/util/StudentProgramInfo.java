package com.ss.common.util;

import java.io.Serializable;
import java.util.Date;

/**
 * Transfer object representing the data about a lead (student) and program.
 * @author binoy.mathew
 */
public class StudentProgramInfo implements Serializable {

	private static final long serialVersionUID = 4666985895395827141L;

	private String studentCrmId;	
	private String programName;
	private String programCode;
	private String programVersionCode;
	private String programDesc;
	private String programOfStudyStatus;
    private String programOfStudyId;
    private String enrollmentStatus;
	private String catalogCode;
	private String stateCode;
	private Date expectedStartDate;
	private String evaluatorName;
	private String evaluationStatus;
	
	
	/**
	 * @return the studentCrmId
	 */
	public String getStudentCrmId() {
		return studentCrmId;
	}

	/**
	 * @param studentCrmId the studentCrmId to set
	 */
	public void setStudentCrmId(String studentCrmId) {
		this.studentCrmId = studentCrmId;
	}

	/**
	 * @return the programVersionCode
	 */
	public String getProgramVersionCode() {
		return programVersionCode;
	}

	/**
	 * @param programVersionCode the programVersionCode to set
	 */
	public void setProgramVersionCode(String programVersionCode) {
		this.programVersionCode = programVersionCode;
	}

	/**
	 * @return the programName
	 */
	public String getProgramDesc() {
		return programDesc;
	}

	/**
	 * @param programName the programName to set
	 */
	public void setProgramDesc(String programDesc) {
		this.programDesc = programDesc;
	}

	/**
	 * @return the catalogCode
	 */
	public String getCatalogCode() {
		return catalogCode;
	}

	/**
	 * @param catalogCode the catalogCode to set
	 */
	public void setCatalogCode(String catalogCode) {
		this.catalogCode = catalogCode;
	}

	/**
	 * @return the stateCode
	 */
	public String getStateCode() {
		return stateCode;
	}

	/**
	 * @param stateCode the stateCode to set
	 */
	public void setStateCode(String stateCode) {
		this.stateCode = stateCode;
	}

	/**
	 * @return the expectedStartDate
	 */
	public Date getExpectedStartDate() {
		return expectedStartDate;
	}

	/**
	 * @param expectedStartDate the expectedStartDate to set
	 */
	public void setExpectedStartDate(Date expectedStartDate) {
		this.expectedStartDate = expectedStartDate;
	}

	/**
	 * @return the evaluatorName
	 */
	public String getEvaluatorName() {
		return evaluatorName;
	}

	/**
	 * @param evaluatorName the evaluatorName to set
	 */
	public void setEvaluatorName(String evaluatorName) {
		this.evaluatorName = evaluatorName;
	}

	/**
	 * @return the evaluationStatus
	 */
	public String getEvaluationStatus() {
		return evaluationStatus;
	}

	/**
	 * @param evaluationStatus the evaluationStatus to set
	 */
	public void setEvaluationStatus(String evaluationStatus) {
		this.evaluationStatus = evaluationStatus;
	}

	public String getProgramName() {
		return programName;
	}

	public void setProgramName(String programName) {
		this.programName = programName;
	}

	public String getProgramCode() {
		return programCode;
	}

	public void setProgramCode(String programCode) {
		this.programCode = programCode;
	}

	public String getProgramOfStudyStatus() {
		return programOfStudyStatus;
	}

	public void setProgramOfStudyStatus(String programOfStudyStatus) {
		this.programOfStudyStatus = programOfStudyStatus;
	}

	public String getProgramOfStudyId() {
		return programOfStudyId;
	}

	public void setProgramOfStudyId(String programOfStudyId) {
		this.programOfStudyId = programOfStudyId;
	}

	public String getEnrollmentStatus() {
		return enrollmentStatus;
	}

	public void setEnrollmentStatus(String enrollmentStatus) {
		this.enrollmentStatus = enrollmentStatus;
	}
}
