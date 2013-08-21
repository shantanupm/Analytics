package com.ss.evaluation.value;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.GenericGenerator;

import com.ss.common.value.BaseEntity;
import com.ss.course.value.MilitarySubject;


@Entity
@Table(name = "ss_tbl_transcript_course_subject")
public class TranscriptCourseSubject extends BaseEntity   implements Serializable  {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")
	@Column(name = "id")
	private String id;	
	
	@Column(name = "transcript_course_id")
	private String transcriptCourseId;
	
	@Column(name = "credit")
	private int credit;
	
	@Column(name = "subject_id")
	private String subjectId;
	
	@Column(name = "category_id")
	private String categoryId;
	
	@Column(name = "course_mapping_id")
	private String courseMappingId;
	
	@Column(name = "transcript_status")
	private String transcriptStatus;
	
	@Column(name = "course_level")
	private String courseLevel;
	
	@Transient
	private MilitarySubject militarySubject;
	
	@Column(name = "transfer_credit_gcu")
	private float transferCredit;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getTranscriptCourseId() {
		return transcriptCourseId;
	}

	public void setTranscriptCourseId(String transcriptCourseId) {
		this.transcriptCourseId = transcriptCourseId;
	}

	public int getCredit() {
		return credit;
	}

	public void setCredit(int credit) {
		this.credit = credit;
	}

	public String getSubjectId() {
		return subjectId;
	}

	public void setSubjectId(String subjectId) {
		this.subjectId = subjectId;
	}

	public String getCategoryId() {
		return categoryId;
	}

	public void setCategoryId(String categoryId) {
		this.categoryId = categoryId;
	}

	public String getCourseMappingId() {
		return courseMappingId;
	}

	public void setCourseMappingId(String courseMappingId) {
		this.courseMappingId = courseMappingId;
	}

	public MilitarySubject getMilitarySubject() {
		return militarySubject;
	}

	public void setMilitarySubject(MilitarySubject militarySubject) {
		this.militarySubject = militarySubject;
	}

	public String getTranscriptStatus() {
		return transcriptStatus;
	}

	public void setTranscriptStatus(String transcriptStatus) {
		this.transcriptStatus = transcriptStatus;
	}

	public String getCourseLevel() {
		return courseLevel;
	}

	public void setCourseLevel(String courseLevel) {
		this.courseLevel = courseLevel;
	}

	public float getTransferCredit() {
		return transferCredit;
	}

	public void setTransferCredit(float transferCredit) {
		this.transferCredit = transferCredit;
	}
	
	
}
