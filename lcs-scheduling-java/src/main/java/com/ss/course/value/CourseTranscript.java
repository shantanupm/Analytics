package com.ss.course.value;

import java.sql.Timestamp;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

import com.ss.common.value.BaseEntity;

@Entity
@Table(name="ss_tbl_transfer_course_transcript")
public class CourseTranscript {
	
	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")
	@Column(name = "id")
	private String id;
	
	@Column(name = "transfer_course_id")
	private String trCourseId;
	
	@Column(name = "student_institution_transcript_id")
	private String studentInstitutionTranscriptId;
	
	
	@Column(name = "modified_date")
	private Date modifiedDate;


	public String getId() {
		return id;
	}


	public void setId(String id) {
		this.id = id;
	}


	public String getTrCourseId() {
		return trCourseId;
	}


	public void setTrCourseId(String trCourseId) {
		this.trCourseId = trCourseId;
	}


	public String getStudentInstitutionTranscriptId() {
		return studentInstitutionTranscriptId;
	}


	public void setStudentInstitutionTranscriptId(
			String studentInstitutionTranscriptId) {
		this.studentInstitutionTranscriptId = studentInstitutionTranscriptId;
	}


	public Date getModifiedDate() {
		return modifiedDate;
	}


	public void setModifiedDate(Date modifiedDate) {
		this.modifiedDate = modifiedDate;
	}
	
}
