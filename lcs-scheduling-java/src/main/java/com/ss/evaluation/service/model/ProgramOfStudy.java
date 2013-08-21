package com.ss.evaluation.service.model;

import java.sql.Date;

import org.codehaus.jackson.annotate.JsonProperty;

public class ProgramOfStudy {

	@JsonProperty("ProgramOfStudyId")
 	private String programOfStudyId;
	@JsonProperty("EnrollmentId")
 	private String enrollmentId;
	@JsonProperty("ProgramCode")
	private String programCode;
	@JsonProperty("ProgramVersion")
	private String programVersion;
	@JsonProperty("ProgramVersionCode")
	private String programVersionCode;
	@JsonProperty("ExpectedStartDate")
	private String expectedStartDate;
	@JsonProperty("StartDate")
	private String startDate;
	@JsonProperty("ProgramOfStudyStatus")
	private String programOfStudyStatus;
	@JsonProperty("EnrollmentStatus")
	private String enrollmentStatus;
	
	public String getProgramOfStudyId() {
		return programOfStudyId;
	}
	public void setProgramOfStudyId(String programOfStudyId) {
		this.programOfStudyId = programOfStudyId;
	}
	public String getEnrollmentId() {
		return enrollmentId;
	}
	public void setEnrollmentId(String enrollmentId) {
		this.enrollmentId = enrollmentId;
	}
	public String getProgramCode() {
		return programCode;
	}
	public void setProgramCode(String programCode) {
		this.programCode = programCode;
	}
	public String getProgramVersion() {
		return programVersion;
	}
	public void setProgramVersion(String programVersion) {
		this.programVersion = programVersion;
	}
	public String getProgramVersionCode() {
		return programVersionCode;
	}
	public void setProgramVersionCode(String programVersionCode) {
		this.programVersionCode = programVersionCode;
	}
	public String getExpectedStartDate() {
		return expectedStartDate;
	}
	public void setExpectedStartDate(String expectedStartDate) {
		this.expectedStartDate = expectedStartDate;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getProgramOfStudyStatus() {
		return programOfStudyStatus;
	}
	public void setProgramOfStudyStatus(String programOfStudyStatus) {
		this.programOfStudyStatus = programOfStudyStatus;
	}
	public String getEnrollmentStatus() {
		return enrollmentStatus;
	}
	public void setEnrollmentStatus(String enrollmentStatus) {
		this.enrollmentStatus = enrollmentStatus;
	}
  	
}
