package com.ss.institution.value;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

import com.ss.common.value.BaseEntity;
import com.ss.course.value.TransferCourse;


@Entity
@Table(name = "ss_tbl_transfercourse_institute_transcriptkey_grade_assoc")
public class TransferCourseInstitutionTranscriptKeyGradeAssoc extends BaseEntity implements
		Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7812780830413852301L;
	
	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")
	@Column(name = "id")
	private String id;	
	
	
	@ManyToOne
	@JoinColumn(name="transferCourse_id", referencedColumnName="id")
	private TransferCourse transferCourse;
	
	
	@Column(name="institutionTranscriptKeyGrade_id")
	private String institutionTranscriptKeyGradeId;
	
	@Column(name="institution_id")
	private String institutionId;
	
	@Column(name = "grade_from")
	private String gradeFrom;
	

	@Column(name = "grade_to")
	private String gradeTo;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public TransferCourse getTransferCourse() {
		return transferCourse;
	}

	public void setTransferCourse(TransferCourse transferCourse) {
		this.transferCourse = transferCourse;
	}

	public String getInstitutionTranscriptKeyGradeId() {
		return institutionTranscriptKeyGradeId;
	}

	public void setInstitutionTranscriptKeyGradeId(
			String institutionTranscriptKeyGradeId) {
		this.institutionTranscriptKeyGradeId = institutionTranscriptKeyGradeId;
	}

	public String getInstitutionId() {
		return institutionId;
	}

	public void setInstitutionId(String institutionId) {
		this.institutionId = institutionId;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getGradeFrom() {
		return gradeFrom;
	}

	public void setGradeFrom(String gradeFrom) {
		this.gradeFrom = gradeFrom;
	}

	public String getGradeTo() {
		return gradeTo;
	}

	public void setGradeTo(String gradeTo) {
		this.gradeTo = gradeTo;
	}

	
	
}
