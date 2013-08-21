package com.ss.evaluation.value;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

import com.ss.common.value.BaseEntity;

@Entity
@Table(name = "ss_tbl_student_program_evaluation")
public class StudentProgramEvaluation extends BaseEntity implements Serializable{

	private static final long serialVersionUID = 14574463497894423L;

	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")
	@Column(name = "id")
	private String id;	
	
	@Column(name = "student_id")
	private String studentId;
	
	@Column(name = "data_entry_status")
	private String dataEntryStatus;
	
	@Column(name = "evaluator_id")
	private String evaluatorId;
	
	@Column(name = "program_version_code")
	private String programVersionCode;
	
	@Column( name="program_desc" )
	private String programDescription;
	
	@Column(name = "evaluation_status")
	private String evaluationStatus;
	
	@Column(name = "state_code")
	private String stateCode;
	
	@Column(name = "expected_start_date")
	private Date expectedStartDate;
	
	@Column(name = "catalog_code")
	private String catalogCode;
	
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getStudentId() {
		return studentId;
	}

	public void setStudentId(String studentId) {
		this.studentId = studentId;
	}
	
	public String getProgramVersionCode() {
		return programVersionCode;
	}

	public void setProgramVersionCode(String programVersionCode) {
		this.programVersionCode = programVersionCode;
	}

		public String getDataEntryStatus() {
		return dataEntryStatus;
	}

	public void setDataEntryStatus(String dataEntryStatus) {
		this.dataEntryStatus = dataEntryStatus;
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

	public String getStateCode() {
		return stateCode;
	}

	public void setStateCode(String stateCode) {
		this.stateCode = stateCode;
	}

	public Date getExpectedStartDate() {
		return expectedStartDate;
	}

	public void setExpectedStartDate(Date expectedStartDate) {
		this.expectedStartDate = expectedStartDate;
	}

	public String getCatalogCode() {
		return catalogCode;
	}

	public void setCatalogCode(String catalogCode) {
		this.catalogCode = catalogCode;
	}

	/**
	 * @return the programDescription
	 */
	public String getProgramDescription() {
		return programDescription;
	}

	/**
	 * @param programDescription the programDescription to set
	 */
	public void setProgramDescription(String programDescription) {
		this.programDescription = programDescription;
	}

			
}
