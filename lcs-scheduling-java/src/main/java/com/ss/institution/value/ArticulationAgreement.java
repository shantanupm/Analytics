package com.ss.institution.value;

import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

import com.ss.common.value.BaseEntity;

@Entity
@Table(name="ss_tbl_articulation_agreement")
public class ArticulationAgreement extends BaseEntity{

	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")	
	@Column(name="id")
	private String id;
	
	@Column(name = "institute_id")
	private String instituteId;
	
	
	@Column(name = "institution_degree")
	private String institutionDegree;
	
	@Column(name = "gcu_degree")
	private String gcuDegree;
	
	@OneToMany(mappedBy="articulationAgreement")
	private List<ArticulationAgreementDetails> articulationAgreementDetailsList;
	
	@Column(name="effective_date")
	private Date effectiveDate;
	
	@Column(name="end_date")
	private Date endDate;
	
	

	@Column(name = "is_effective")
	private boolean effective;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getInstituteId() {
		return instituteId;
	}
	public void setInstituteId(String instituteId) {
		this.instituteId = instituteId;
	}
	public String getInstitutionDegree() {
		return institutionDegree;
	}
	public void setInstitutionDegree(String institutionDegree) {
		this.institutionDegree = institutionDegree;
	}
	public String getGcuDegree() {
		return gcuDegree;
	}
	public void setGcuDegree(String gcuDegree) {
		this.gcuDegree = gcuDegree;
	}
	public List<ArticulationAgreementDetails> getArticulationAgreementDetailsList() {
		return articulationAgreementDetailsList;
	}
	public void setArticulationAgreementDetailsList(
			List<ArticulationAgreementDetails> articulationAgreementDetailsList) {
		this.articulationAgreementDetailsList = articulationAgreementDetailsList;
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
	
	public void setEffective(boolean effective) {
		this.effective = effective;
	}
	public boolean isEffective() {
		return effective;
	}
}
