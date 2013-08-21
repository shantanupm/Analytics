package com.ss.course.value;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

import com.ss.common.util.EqualsUtil;

@Entity
@Table(name = "ss_tbl_transfer_course_title_assoc")
public class TransferCourseTitle implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")
	@Column(name = "id")
	private String id;	

	@Column(name = "transfer_course_id")
	private String transferCourseId;
	
	@Column(name = "title")
	private String title;
	
	@Column(name = "effective_date")
	private Date effectiveDate;
	
	@Column(name = "end_date")
	private Date endDate;
	
	@Column(name = "evaluation_status")
	private String evaluationStatus;

	@Column(name = "is_effective")
	private boolean effective;
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getTransferCourseId() {
		return transferCourseId;
	}

	public void setTransferCourseId(String transferCourseId) {
		this.transferCourseId = transferCourseId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
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

	public String getEvaluationStatus() {
		return evaluationStatus;
	}

	public void setEvaluationStatus(String evaluationStatus) {
		this.evaluationStatus = evaluationStatus;
	}
	
	 @Override public boolean equals(Object aThat) {
		    //check for self-comparison
		    if ( this == aThat ) return true;
		    
		    if ( !(aThat instanceof TransferCourseTitle) ) return false;
		    //Alternative to the above line : if ( aThat == null || aThat.getClass() != this.getClass() ) return false;
		    
		    //cast to native object is now safe
		    TransferCourseTitle that = (TransferCourseTitle)aThat;

		    //now a proper field-by-field evaluation can be made
		    return
		      EqualsUtil.areEqual(this.title, that.title) &&
		      EqualsUtil.areEqual(this.effectiveDate, that.effectiveDate) &&
		      EqualsUtil.areEqual(this.endDate, that.endDate) ;
		  }

	public void setEffective(boolean effective) {
		this.effective = effective;
	}

	public boolean isEffective() {
		return effective;
	}
}
