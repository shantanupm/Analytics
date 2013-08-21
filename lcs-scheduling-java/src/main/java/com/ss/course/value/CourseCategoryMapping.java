package com.ss.course.value;


import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

import com.ss.common.util.EqualsUtil;
import com.ss.common.value.BaseEntity;

@Entity
@Table(name ="ss_tbl_transfer_course_gcu_coursecategory_mapping")
public class CourseCategoryMapping  extends BaseEntity implements Serializable {
	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")
	@Column(name = "id")
	private String id;	
	
	
	@Column(name = "tr_course_id")
	private String trCourseId;
	
	@ManyToOne
	@JoinColumn(name="gcu_course_category_id", referencedColumnName="id")
	private GCUCourseCategory gcuCourseCategory;
	
	@Column(name = "credits")
	private String credits;
	
	@Column(name = "min_transfer_grade")
	private String minTransferGrade;
	
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

	public String getTrCourseId() {
		return trCourseId;
	}

	public void setTrCourseId(String trCourseId) {
		this.trCourseId = trCourseId;
	}

	

	public String getCredits() {
		return credits;
	}

	public void setCredits(String credits) {
		this.credits = credits;
	}

	public String getMinTransferGrade() {
		return minTransferGrade;
	}

	public void setMinTransferGrade(String minTransferGrade) {
		this.minTransferGrade = minTransferGrade;
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
		    
		    if ( !(aThat instanceof CourseCategoryMapping) ) return false;
		    //Alternative to the above line : if ( aThat == null || aThat.getClass() != this.getClass() ) return false;
		    
		    //cast to native object is now safe
		    CourseCategoryMapping that = (CourseCategoryMapping)aThat;

		    //now a proper field-by-field evaluation can be made
		    return
		      EqualsUtil.areEqual(this.trCourseId, that.trCourseId) &&
		      EqualsUtil.areEqual(this.gcuCourseCategory.getName(), that.gcuCourseCategory.getName()) &&
		      EqualsUtil.areEqual(this.credits, that.credits) &&
		      EqualsUtil.areEqual(this.minTransferGrade, that.minTransferGrade) &&
		      EqualsUtil.areEqual(this.effectiveDate, that.effectiveDate) &&
		      EqualsUtil.areEqual(this.endDate, that.endDate) &&
		      EqualsUtil.areEqual(this.evaluationStatus, that.evaluationStatus) ;
		  }

	public GCUCourseCategory getGcuCourseCategory() {
		return gcuCourseCategory;
	}

	public void setGcuCourseCategory(GCUCourseCategory gcuCourseCategory) {
		this.gcuCourseCategory = gcuCourseCategory;
	}

	public void setEffective(boolean effective) {
		this.effective = effective;
	}

	public boolean isEffective() {
		return effective;
	}
}
