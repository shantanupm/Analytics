package com.ss.institution.value;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

import com.ss.evaluation.value.Country;
@Entity
@Table(name="ss_tbl_institution_mirror")
public class InstitutionMirror implements Serializable {
	//private static transient Logger log = LoggerFactory.getLogger(Country.class);
	/**
	 * 
	 */
	
	
	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")	
	@Column(name="id")
	private String id;
	
	@Column(name = "institution_id")
	String institutionId;
	@Column(name = "evaluator_id")
	private String evaluatorId;
	@Column(name="evaluation_status")
	private String evaluationStatus;
	@Column(name="institution_details")
	private String institutionDetails;
	
	@Column(name = "created_date")
	private Date createdTime;
	@Column(name="modified_by")
	private String modifiedBy;
	@Column(name="modified_date")
	private String modifiedTime;
	
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
	public String getEvaluatorId() {
		return evaluatorId;
	}
	public void setEvaluatorId(String evaluatorId) {
		this.evaluatorId = evaluatorId;
	}
	public String getEvaluationStatus() {
		return evaluationStatus;
	}
	public void setEvaluationStatus(String evaluationStatus) {
		this.evaluationStatus = evaluationStatus;
	}
	public String getInstitutionDetails() {
		return institutionDetails;
	}
	public void setInstitutionDetails(String institutionDetails) {
		this.institutionDetails = institutionDetails;
	}
	public Date getCreatedTime() {
		return createdTime;
	}
	public void setCreatedTime(Date createdTime) {
		this.createdTime = createdTime;
	}
	public String getModifiedBy() {
		return modifiedBy;
	}
	public void setModifiedBy(String modifiedBy) {
		this.modifiedBy = modifiedBy;
	}
	public String getModifiedTime() {
		return modifiedTime;
	}
	public void setModifiedTime(String modifiedTime) {
		this.modifiedTime = modifiedTime;
	}
		
	
	
}
