package com.ss.course.value;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name="ss_tbl_transfer_course_mirror")
public class TransferCourseMirror implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")
	@Column(name = "id")
	private String id;
	@Column(name="transfer_course_id")
	private String transferCourseId;
	@Column(name="evaluator_id")
	private String evaluatorId;
	@Column(name="evaluation_status")
	private String evaluationStatus;
	@Column(name="course_details")
	private String courseDetails;
	@Column(name="institution_mirror_id")
	private String institutionMirrorId;
	
	
	
	@Column(name="created_date")
	private Date createdTime;
	@Column(name="modified_by")
	private String modifiedBy;
	@Column(name="modified_date")
	private Date modifiedTime;
	
	
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
	public String getCourseDetails() {
		return courseDetails;
	}
	public void setCourseDetails(String courseDetails) {
		this.courseDetails = courseDetails;
	}
	public String getInstitutionMirrorId() {
		return institutionMirrorId;
	}
	public void setInstitutionMirrorId(String institutionMirrorId) {
		this.institutionMirrorId = institutionMirrorId;
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
	public Date getModifiedTime() {
		return modifiedTime;
	}
	public void setModifiedTime(Date modifiedTime) {
		this.modifiedTime = modifiedTime;
	}
	
	
}
