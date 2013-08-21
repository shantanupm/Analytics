package com.ss.institution.value;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name="ss_tbl_institution_transcript")
public class InstitutionTranscript {


	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")
	@Column(name = "id")
	private String id;
	
	@Column(name = "institution_id")
	private String institutionId;
	
	@Column(name = "student_institution_transcript_id")
	private String studentInstitutionTranscriptId;
	
	
	@Column(name = "modified_date", insertable=false, updatable=false )
	private Timestamp modifiedDate;


	public String getId() {
		return id;
	}


	public void setId(String id) {
		this.id = id;
	}


	public String getInstitutionId() {
		return institutionId;
	}


	public void setInstitutionId(String institutionId) {
		this.institutionId = institutionId;
	}


	public String getStudentInstitutionTranscriptId() {
		return studentInstitutionTranscriptId;
	}


	public void setStudentInstitutionTranscriptId(
			String studentInstitutionTranscriptId) {
		this.studentInstitutionTranscriptId = studentInstitutionTranscriptId;
	}


	public Timestamp getModifiedDate() {
		return modifiedDate;
	}


	public void setModifiedDate(Timestamp modifiedDate) {
		this.modifiedDate = modifiedDate;
	}

}
