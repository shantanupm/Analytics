package com.ss.institution.value;

import java.io.Serializable;
import java.util.Date;
import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ss.common.util.EqualsUtil;
import com.ss.common.value.BaseEntity;
@Entity
@Table(name="ss_tbl_institute_termtype_assoc")
public class InstitutionTermType extends BaseEntity implements Serializable {
	//private static transient Logger log = LoggerFactory.getLogger(Country.class);
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")	
	@Column(name="id")
	private String id;
	
	@Column(name="institute_id")
	private String instituteId;	
	
	
	@ManyToOne
	@JoinColumn(name="term_type_id", referencedColumnName="id")
	private TermType termType;
	
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
	public TermType getTermType() {
		return termType;
	}
	public void setTermType(TermType termType) {
		this.termType = termType;
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
	
	
	 @Override public boolean equals(Object aThat) {
		    //check for self-comparison
		    if ( this == aThat ) return true;
		    
		    if ( !(aThat instanceof InstitutionTermType) ) return false;
		    //Alternative to the above line : if ( aThat == null || aThat.getClass() != this.getClass() ) return false;
		    
		    //cast to native object is now safe
		    InstitutionTermType that = (InstitutionTermType)aThat;

		    //now a proper field-by-field evaluation can be made
		    return
		      EqualsUtil.areEqual(this.termType.getName(), that.termType.getName()) ;
		     
		     
	}
	
}
