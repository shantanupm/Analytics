package com.ss.evaluation.value;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.GenericGenerator;

import com.ss.common.value.BaseEntity;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionAddress;
import com.ss.institution.value.InstitutionDegree;
import com.ss.user.value.User;

/**
 * Domain object representing the ss_tbl_student_institution_transcript table.
 */
@Entity
@Table( name="ss_tbl_student_institution_transcript" )
public class StudentInstitutionTranscript extends BaseEntity implements Serializable, Comparable<StudentInstitutionTranscript> {

	private static final long serialVersionUID = -3319099365489195097L;

	@Id
	@GeneratedValue( generator = "customuuid" )
	@GenericGenerator( name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator" )
	@Column(name = "id")
	private String id;
	
	@ManyToOne
	@JoinColumn( name="student_id" )
	private Student student;
	
	@ManyToOne
	@JoinColumn( name="institution_id" )
	private Institution institution;
	
	@OneToMany( mappedBy = "studentInstitutionTranscript" ,fetch=FetchType.EAGER)
	private List<StudentInstitutionDegree> studentInstitutionDegreeSet;
	
	@Column( name="evaluation_status" )
	private String evaluationStatus;
	
	@Column( name="last_course_last_date" )
	private Date lastDateForLastCourse;
	
	

	@Column( name="is_official" )
	private Boolean official;
	
	
	
	@Column(name="lope_comment")
	private String lopeComment;
	
	@Column(name="sle_comment")
	private String sleComment;
	
	@ManyToOne
	@JoinColumn( name="institution_address_id" )
	private InstitutionAddress institutionAddress;
	
	@Column(name = "date_received")
	private Date dateReceived;
	
	@Column(name = "last_attendence_date")
	private Date lastAttendenceDate;
	
	@Column(name="is_mark_complete")
	private Boolean markCompleted = false;
	
	@Column(name="occupy_by_id")
	private String occupyById;
	
	@Column(name="college_code")
	private String collegeCode;
	
	@Transient
	private List<StudentTranscriptCourse> studentTranscriptCourse;
	
	@Transient
	private User user;
	
	@Transient
	private List<TranscriptComments> transcriptCommentsList;
	

	public String getLopeComment() {
		return lopeComment;
	}

	public void setLopeComment(String lopeComment) {
		this.lopeComment = lopeComment;
	}

	public String getSleComment() {
		return sleComment;
	}

	public void setSleComment(String sleComment) {
		this.sleComment = sleComment;
	}

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
	 * @return the studentProgramEvaluation
	 */
	public Student getStudent() {
		return student;
	}

	/**
	 * @param student the studentProgramEvaluation to set
	 */
	public void setStudent(Student student) {
		this.student = student;
	}

	/**
	 * @return the institution
	 */
	public Institution getInstitution() {
		return institution;
	}

	/**
	 * @param institution the institution to set
	 */
	public void setInstitution(Institution institution) {
		this.institution = institution;
	}

	
	/**
	 * @return the lastDateForLastCourse
	 */
	public Date getLastDateForLastCourse() {
		return lastDateForLastCourse;
	}

	/**
	 * @param lastDateForLastCourse the lastDateForLastCourse to set
	 */
	public void setLastDateForLastCourse(Date lastDateForLastCourse) {
		this.lastDateForLastCourse = lastDateForLastCourse;
	}

	/**
	 * @return the evaluationStatus
	 */
	public String getEvaluationStatus() {
		return evaluationStatus;
	}

	/**
	 * @param evaluationStatus the evaluationStatus to set
	 */
	public void setEvaluationStatus(String evaluationStatus) {
		this.evaluationStatus = evaluationStatus;
	}

	/**
	 * @return the official
	 */
	public Boolean getOfficial() {
		return official;
	}

	/**
	 * @param official the official to set
	 */
	public void setOfficial(Boolean official) {
		this.official = official;
	}

	/**
	 * @return the studentInstitutionDegreeSet
	 */
	public List<StudentInstitutionDegree> getStudentInstitutionDegreeSet() {
		return studentInstitutionDegreeSet;
	}

	/**
	 * @param studentInstitutionDegreeSet the studentInstitutionDegreeSet to set
	 */
	public void setStudentInstitutionDegreeSet(List<StudentInstitutionDegree> studentInstitutionDegreeSet ) {
		this.studentInstitutionDegreeSet = studentInstitutionDegreeSet;
	}

	public List<StudentTranscriptCourse> getStudentTranscriptCourse() {
		return studentTranscriptCourse;
	}

	public void setStudentTranscriptCourse(List<StudentTranscriptCourse> studentTranscriptCourse) {
		this.studentTranscriptCourse = studentTranscriptCourse;
	}
	public void setInstitutionAddress(InstitutionAddress institutionAddress) {
		this.institutionAddress = institutionAddress;
	}

	public InstitutionAddress getInstitutionAddress() {
		return institutionAddress;
	}
	public Date getDateReceived() {
		return dateReceived;
	}

	public void setDateReceived(Date dateReceived) {
		this.dateReceived = dateReceived;
	}

	public Date getLastAttendenceDate() {
		return lastAttendenceDate;
	}

	public void setLastAttendenceDate(Date lastAttendenceDate) {
		this.lastAttendenceDate = lastAttendenceDate;
	}

	public Boolean isMarkCompleted() {
		return markCompleted;
	}

	public void setMarkCompleted(Boolean markCompleted) {
		this.markCompleted = markCompleted;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	@Override
	public int compareTo(StudentInstitutionTranscript obj) {
		if(this.getModifiedDate() != null && obj.getModifiedDate() != null) {
			return obj.getModifiedDate().compareTo(this.getModifiedDate());
		}
		return 0;
	}

	public String getOccupyById() {
		return occupyById;
	}

	public void setOccupyById(String occupyById) {
		this.occupyById = occupyById;
	}

	public List<TranscriptComments> getTranscriptCommentsList() {
		return transcriptCommentsList;
	}

	public void setTranscriptCommentsList(
			List<TranscriptComments> transcriptCommentsList) {
		this.transcriptCommentsList = transcriptCommentsList;
	}

	public String getCollegeCode() {
		return collegeCode;
	}

	public void setCollegeCode(String collegeCode) {
		this.collegeCode = collegeCode;
	}

	
	
}
