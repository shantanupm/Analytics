package com.ss.institution.value;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.GenericGenerator;

import com.ss.common.value.BaseEntity;


@Entity
@Table(name = "ss_tbl_institute_transcriptkey_grade")
public class InstitutionTranscriptKeyGrade extends BaseEntity implements
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
	@JoinColumn(name="institution_transcriptkey_id", referencedColumnName="id")
	private InstitutionTranscriptKey institutionTranscriptKey;
	
	@Column(name = "grade_from")
	private String gradeFrom;
	

	@Column(name = "grade_to")
	private String gradeTo;
	
	@Column(name = "grade_alpha")
	private String gradeAlpha;
	
	@Column(name = "short_description")
	private String shortDescription;
	
	@Column(name = "long_description")
	private String longDescription;
	
	@Column(name = "is_number")
	private boolean number;

	@Transient
	private boolean selected;
	
	@Transient
	private String gradeAssocId;
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public InstitutionTranscriptKey getInstitutionTranscriptKey() {
		return institutionTranscriptKey;
	}

	public void setInstitutionTranscriptKey(
			InstitutionTranscriptKey institutionTranscriptKey) {
		this.institutionTranscriptKey = institutionTranscriptKey;
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

	public String getGradeAlpha() {
		return gradeAlpha;
	}

	public void setGradeAlpha(String gradeAlpha) {
		this.gradeAlpha = gradeAlpha;
	}

	public String getShortDescription() {
		return shortDescription;
	}

	public void setShortDescription(String shortDescription) {
		this.shortDescription = shortDescription;
	}

	public String getLongDescription() {
		return longDescription;
	}

	public void setLongDescription(String longDescription) {
		this.longDescription = longDescription;
	}

	public boolean isNumber() {
		return number;
	}

	public void setNumber(boolean number) {
		this.number = number;
	}

	public boolean isSelected() {
		return selected;
	}

	public void setSelected(boolean selected) {
		this.selected = selected;
	}

	public String getGradeAssocId() {
		return gradeAssocId;
	}

	public void setGradeAssocId(String gradeAssocId) {
		this.gradeAssocId = gradeAssocId;
	}

		
	
}
