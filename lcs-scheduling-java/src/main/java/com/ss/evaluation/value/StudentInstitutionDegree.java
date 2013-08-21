package com.ss.evaluation.value;

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

import com.ss.common.value.BaseEntity;
import com.ss.institution.value.InstitutionDegree;

@Entity
@Table(name = "ss_tbl_student_institution_degree")
public class StudentInstitutionDegree  extends BaseEntity implements Serializable {

	private static final long serialVersionUID = 14574463497894423L;

	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")
	@Column(name = "id")
	private String id;	
	
	@ManyToOne
	@JoinColumn( name="institution_degree_id" )
	private InstitutionDegree institutionDegree;
	
	@ManyToOne
	@JoinColumn( name="student_institution_transcript_id" )
	private StudentInstitutionTranscript studentInstitutionTranscript;
	
	@Column( name="completion_date" )
	private Date completionDate;
	
	@Column( name="major" )
	private String major;
	
	@Column( name="gpa" )
	private float gpa;
	
	
	
	@Column(name = "last_attendence_date")
	private Date lastAttendenceDate;
	
	

	/**
	 * @return the id
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @return the institutionDegree
	 */
	public InstitutionDegree getInstitutionDegree() {
		return institutionDegree;
	}

	/**
	 * @param institutionDegree the institutionDegree to set
	 */
	public void setInstitutionDegree(InstitutionDegree institutionDegree) {
		this.institutionDegree = institutionDegree;
	}

	/**
	 * @return the completionDate
	 */
	public Date getCompletionDate() {
		return completionDate;
	}

	/**
	 * @param completionDate the completionDate to set
	 */
	public void setCompletionDate(Date completionDate) {
		this.completionDate = completionDate;
	}

	/**
	 * @return the major
	 */
	public String getMajor() {
		return major;
	}

	/**
	 * @param major the major to set
	 */
	public void setMajor(String major) {
		this.major = major;
	}

	
	public float getGpa() {
		return gpa;
	}

	public void setGpa(float gpa) {
		this.gpa = gpa;
	}

	/**
	 * @return the studentInstitutionTranscript
	 */
	public StudentInstitutionTranscript getStudentInstitutionTranscript() {
		return studentInstitutionTranscript;
	}

	/**
	 * @param studentInstitutionTranscript the studentInstitutionTranscript to set
	 */
	public void setStudentInstitutionTranscript( StudentInstitutionTranscript studentInstitutionTranscript ) {
		this.studentInstitutionTranscript = studentInstitutionTranscript;
	}

	public Date getLastAttendenceDate() {
		return lastAttendenceDate;
	}

	public void setLastAttendenceDate(Date lastAttendenceDate) {
		this.lastAttendenceDate = lastAttendenceDate;
	}
	
	
			
}
