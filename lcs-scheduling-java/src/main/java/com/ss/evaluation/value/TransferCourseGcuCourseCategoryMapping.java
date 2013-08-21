package com.ss.evaluation.value;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.GenericGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ss.common.value.BaseEntity;
import com.ss.institution.value.GcuCourseLevel;

@Entity
@Table(name = "ss_tbl_transfer_course_gcu_coursecategory_mapping")
public class TransferCourseGcuCourseCategoryMapping extends BaseEntity  implements Serializable{

	private static final long serialVersionUID = 14574463497894423L;

	private static transient Logger log = LoggerFactory.getLogger(GcuCourseLevel.class);
	
	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")
	@Column(name = "id")
	private String id;	
	
	
	@Column(name = "trCourseId")
	private String trCourseId;
	
	@Column(name = "gcuCourseCategoryCode")
	private String gcuCourseCategoryCode;
	
	@Column(name = "credits")
	private float credits;	
	
	@Column(name = "minTransferGrade")
	private float minTransferGrade;
	
	@Column(name = "effectiveDate")
	private Date effectiveDate;
	
	@Column(name = "endDate")
	private Date endDate;
	
	@Column(name = "evaluationStatus")
	private boolean evaluationStatus;
	
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

	

	public float getCredits() {
		return credits;
	}

	public void setCredits(float credits) {
		this.credits = credits;
	}
	
	public String getGcuCourseCategoryCode() {
		return gcuCourseCategoryCode;
	}

	public void setGcuCourseCategoryCode(String gcuCourseCategoryCode) {
		this.gcuCourseCategoryCode = gcuCourseCategoryCode;
	}

	public float getMinTransferGrade() {
		return minTransferGrade;
	}

	public void setMinTransferGrade(float minTransferGrade) {
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

	

	public boolean isEvaluationStatus() {
		return evaluationStatus;
	}

	public void setEvaluationStatus(boolean evaluationStatus) {
		this.evaluationStatus = evaluationStatus;
	}

	
	
	

}
