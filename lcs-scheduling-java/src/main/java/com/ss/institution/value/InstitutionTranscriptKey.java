package com.ss.institution.value;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.GenericGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ss.common.value.BaseEntity;


@Entity
@Table(name = "ss_tbl_institution_transcriptkey")
public class InstitutionTranscriptKey extends BaseEntity implements Serializable{

	private static final long serialVersionUID = 14574463497894423L;

	
	
	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")
	@Column(name = "id")
	private String id;	
	
	 @OneToMany(mappedBy="institutionTranscriptKey")
	 private List<InstitutionTranscriptKeyDetails> institutionTranscriptKeyDetailsList;
	
	
	 @OneToMany(mappedBy="institutionTranscriptKey")
	 private List<InstitutionTranscriptKeyGrade> institutionTranscriptKeyGradeList;
	

	@Column(name = "institute_id")
	private String institutionId;
	
	@Column(name="effective_date")
	private Date effectiveDate;
	
	@Column(name="end_date")
	private Date endDate;
	
	
	@Column(name = "is_effective")
	private boolean effective;

	@Transient
	private List<InstitutionTranscriptKeyGrade> institutionTranscriptKeyGradeAlphaList;
	
	@Transient
	private List<InstitutionTranscriptKeyGrade> institutionTranscriptKeyGradeNumberList;
	
	public boolean isEffective() {
		return effective;
	}
	public void setEffective(boolean effective) {
		this.effective = effective;
	}
	

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

	public List<InstitutionTranscriptKeyDetails> getInstitutionTranscriptKeyDetailsList() {
		return institutionTranscriptKeyDetailsList;
	}

	public void setInstitutionTranscriptKeyDetailsList(
			List<InstitutionTranscriptKeyDetails> institutionTranscriptKeyDetailsList) {
		this.institutionTranscriptKeyDetailsList = institutionTranscriptKeyDetailsList;
	}
	public Date getEffectiveDate() {
		return effectiveDate;
	}

	public void setEffectiveDate(Date effectiveDate) {
		this.effectiveDate = effectiveDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	
	public void addToTranscriptKeyDetails(InstitutionTranscriptKeyDetails institutionTranscriptKeyDetails) {
		institutionTranscriptKeyDetails.setInstitutionTranscriptKey(this);
        this.institutionTranscriptKeyDetailsList.add(institutionTranscriptKeyDetails);
    }
	public List<InstitutionTranscriptKeyGrade> getInstitutionTranscriptKeyGradeList() {
		return institutionTranscriptKeyGradeList;
	}
	public void setInstitutionTranscriptKeyGradeList(
			List<InstitutionTranscriptKeyGrade> institutionTranscriptKeyGradeList) {
		this.institutionTranscriptKeyGradeList = institutionTranscriptKeyGradeList;
	}
	public List<InstitutionTranscriptKeyGrade> getInstitutionTranscriptKeyGradeAlphaList() {
		return institutionTranscriptKeyGradeAlphaList;
	}
	public void setInstitutionTranscriptKeyGradeAlphaList(
			List<InstitutionTranscriptKeyGrade> institutionTranscriptKeyGradeAlphaList) {
		this.institutionTranscriptKeyGradeAlphaList = institutionTranscriptKeyGradeAlphaList;
	}
	public List<InstitutionTranscriptKeyGrade> getInstitutionTranscriptKeyGradeNumberList() {
		return institutionTranscriptKeyGradeNumberList;
	}
	public void setInstitutionTranscriptKeyGradeNumberList(
			List<InstitutionTranscriptKeyGrade> institutionTranscriptKeyGradeNumberList) {
		this.institutionTranscriptKeyGradeNumberList = institutionTranscriptKeyGradeNumberList;
	}

		
	
}
