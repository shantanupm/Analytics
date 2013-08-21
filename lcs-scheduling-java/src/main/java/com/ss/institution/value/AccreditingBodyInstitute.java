package com.ss.institution.value;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.GenericGenerator;

import com.ss.common.util.EqualsUtil;
import com.ss.common.value.BaseEntity;

@Entity
@Table(name="ss_tbl_accreditingbody_institute_assoc")
public class AccreditingBodyInstitute extends BaseEntity implements Serializable{
	
	private static final long serialVersionUID = -4237093656170116372L;

	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")	
	@Column(name="id")
	private String id;
	
	
	
	@ManyToOne
	@JoinColumn(name="accrediting_body_id", referencedColumnName="id")
	private AccreditingBody accreditingBody;
	
	
	@Column(name = "institute_id")
	private String instituteId;
	
	@Column(name = "effective_date")
	private String effectiveDate;
	
	@Column(name = "end_date")
	private String endDate;
	
	@Column(name = "evaluator_id")
	private String evaluatorId;
	
	@Column(name = "evaluation_status")
	private String evaluationStatus;

	
	
	
	
	@Column(name = "is_effective")
	private boolean effective;
	
	
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
	public AccreditingBody getAccreditingBody() {
		return accreditingBody;
	}
	public void setAccreditingBody(AccreditingBody accreditingBody) {
		this.accreditingBody = accreditingBody;
	}
	public String getInstituteId() {
		return instituteId;
	}
	public void setInstituteId(String instituteId) {
		this.instituteId = instituteId;
	}
	public String getEffectiveDate() {
		return effectiveDate;
	}
	public void setEffectiveDate(String effectiveDate) {
		this.effectiveDate = effectiveDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
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

	 @Override public boolean equals(Object aThat) {
		    //check for self-comparison
		    if ( this == aThat ) return true;
		    
		    if ( !(aThat instanceof AccreditingBodyInstitute) ) return false;
		    //Alternative to the above line : if ( aThat == null || aThat.getClass() != this.getClass() ) return false;
		    
		    //cast to native object is now safe
		    AccreditingBodyInstitute that = (AccreditingBodyInstitute)aThat;

		    //now a proper field-by-field evaluation can be made
		    return
		      EqualsUtil.areEqual(this.accreditingBody.getName(), that.accreditingBody.getName()) ;
		     
		     
	}
}
