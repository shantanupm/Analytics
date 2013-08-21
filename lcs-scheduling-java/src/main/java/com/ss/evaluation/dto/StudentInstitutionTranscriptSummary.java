package com.ss.evaluation.dto;

import java.util.Date;

import com.ss.evaluation.value.StudentInstitutionTranscript;

/**
 * Data transfer object to display the institution transcript summary for a student, when the student record is pulled up by the DEO
 *
 */
public class StudentInstitutionTranscriptSummary {

	private StudentInstitutionTranscript studentInstitutionTranscript;
	private String transcriptEvaluationStatus;
	private Date dateCreated;
	private Date dateModified;

	public StudentInstitutionTranscript getStudentInstitutionTranscript() {
		return studentInstitutionTranscript;
	}

	public void setStudentInstitutionTranscript(
			StudentInstitutionTranscript studentInstitutionTranscript) {
		this.studentInstitutionTranscript = studentInstitutionTranscript;
	}

	public String getTranscriptEvaluationStatus() {
		return transcriptEvaluationStatus;
	}

	public void setTranscriptEvaluationStatus(String transcriptEvaluationStatus) {
		this.transcriptEvaluationStatus = transcriptEvaluationStatus;
	}

	public Date getDateCreated() {
		return dateCreated;
	}

	public void setDateCreated(Date dateCreated) {
		this.dateCreated = dateCreated;
	}

	public Date getDateModified() {
		return dateModified;
	}

	public void setDateModified(Date dateModified) {
		this.dateModified = dateModified;
	}

	@Override
	public String toString() {
		return String
				.format("StudentInstitutionTranscriptSummary [studentInstitutionTranscript=%s, transcriptEvaluationStatus=%s, dateCreated=%s, dateModified=%s]",
						studentInstitutionTranscript,
						transcriptEvaluationStatus, dateCreated, dateModified);
	}

}
