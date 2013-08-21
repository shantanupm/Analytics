package com.ss.evaluation.value;

import java.io.Serializable;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.GenericGenerator;

import com.ss.common.value.BaseEntity;
import com.ss.course.value.CourseCategoryMapping;
import com.ss.course.value.CourseMapping;
import com.ss.course.value.MilitarySubject;
import com.ss.course.value.TransferCourse;
import com.ss.course.value.TransferCourseTitle;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionTermType;

@Entity
@Table(name = "ss_tbl_student_transcript_course")
public class StudentTranscriptCourse  extends BaseEntity implements Serializable,Comparator<StudentTranscriptCourse>{

	private static final long serialVersionUID = 14574463497894423L;

	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")
	@Column(name = "id")
	private String id;	
	
	
	@ManyToOne
	@JoinColumn( name="student_institution_transcript_id" )
	private StudentInstitutionTranscript studentInstitutionTranscript;
	
	@ManyToOne
	@JoinColumn( name="institution_id" )
	private Institution institution;
	
	@ManyToOne
	@JoinColumn( name="transfer_course_id" )
	private TransferCourse transferCourse;
	
	@Column(name = "tr_Course_id")
	private String trCourseId;
	
	@Column(name = "transcript_status")
	private String transcriptStatus;
	
	@Column(name = "grade")
	private String grade;
	
	@Column( name="clock_hours" )
	private int clockHours;
	
	@Column(name = "completion_date")
	private Date completionDate;
	
	@Column(name = "evaluation_status")
	private String evaluationStatus;
	
	@Column(name = "gcu_requirement_met")
	private boolean gcuRequirementMet;

	@Column( name="course_sequence" )
	private int courseSequence;
	
	@Column(name = "credits_transferred")
	private int creditsTransferred;
	
	
	@Column(name = "transfer_course_title_id")
	private String transferCourseTitleId;
	
	@Column(name="is_mark_complete")
	private boolean markCompleted = false;
	
	@Column(name="courseMapping_id")
	private String courseMappingId;
	
	@Column(name="courseCategoryMapping_id")
	private String courseCategoryMappingId;
	
	@Column(name="transfer_credit_gcu")
	private float transferCredit;
	
	
	
	@Transient
	private TransferCourseTitle transferCourseTitle;
	
	@Transient
	private List<TransferCourseTitle> transferCourseTitleList;
	
	@Transient
	private InstitutionTermType institutionTermType;
	
	@Transient
	private List<CourseMapping> courseMappingList;
	
	@Transient
	private List<CourseCategoryMapping> courseCategoryMappingList;
	
	@Transient
	private List<TranscriptCourseSubject> transcriptCourseSubjectList;
	
	@Transient
	private List<MilitarySubject> militarySubjectList;
	
	public String getTransferCourseTitleId() {
		return transferCourseTitleId;
	}

	public void setTransferCourseTitleId(String transferCourseTitleId) {
		this.transferCourseTitleId = transferCourseTitleId;
	}

	@Transient
	private String courseTitle;
	
	public String getCourseTitle() {
		return courseTitle;
	}

	public void setCourseTitle(String courseTitle) {
		this.courseTitle = courseTitle;
	}

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

	public String getTranscriptStatus() {
		return transcriptStatus;
	}

	public void setTranscriptStatus(String transcriptStatus) {
		this.transcriptStatus = transcriptStatus;
	}

	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	public Date getCompletionDate() {
		return completionDate;
	}

	public void setCompletionDate(Date completionDate) {
		this.completionDate = completionDate;
	}

	public String getEvaluationStatus() {
		return evaluationStatus;
	}

	public void setEvaluationStatus(String evaluationStatus) {
		this.evaluationStatus = evaluationStatus;
	}

	public boolean isGcuRequirementMet() {
		return gcuRequirementMet;
	}

	public void setGcuRequirementMet(boolean gcuRequirementMet) {
		this.gcuRequirementMet = gcuRequirementMet;
	}

	public int getCreditsTransferred() {
		return creditsTransferred;
	}

	public void setCreditsTransferred(int creditsTransferred) {
		this.creditsTransferred = creditsTransferred;
	}

	
	/**
	 * @return the clockHours
	 */
	public int getClockHours() {
		return clockHours;
	}

	/**
	 * @param clockHours the clockHours to set
	 */
	public void setClockHours(int clockHours) {
		this.clockHours = clockHours;
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
	 * @return the studentInstitutionTranscript
	 */
	public StudentInstitutionTranscript getStudentInstitutionTranscript() {
		return studentInstitutionTranscript;
	}

	/**
	 * @param studentInstitutionTranscript the studentInstitutionTranscript to set
	 */
	public void setStudentInstitutionTranscript(
			StudentInstitutionTranscript studentInstitutionTranscript) {
		this.studentInstitutionTranscript = studentInstitutionTranscript;
	}

	/**
	 * @return the courseSequence
	 */
	public int getCourseSequence() {
		return courseSequence;
	}

	/**
	 * @param courseSequence the courseSequence to set
	 */
	public void setCourseSequence(int courseSequence) {
		this.courseSequence = courseSequence;
	}

	/**
	 * @return the transferCourse
	 */
	public TransferCourse getTransferCourse() {
		return transferCourse;
	}

	/**
	 * @param transferCourse the transferCourse to set
	 */
	public void setTransferCourse(TransferCourse transferCourse) {
		this.transferCourse = transferCourse;
	}

	public TransferCourseTitle getTransferCourseTitle() {
		return transferCourseTitle;
	}

	public void setTransferCourseTitle(TransferCourseTitle transferCourseTitle) {
		this.transferCourseTitle = transferCourseTitle;
	}

	public boolean isMarkCompleted() {
		return markCompleted;
	}

	public void setMarkCompleted(boolean markCompleted) {
		this.markCompleted = markCompleted;
	}

	public InstitutionTermType getInstitutionTermType() {
		return institutionTermType;
	}

	public void setInstitutionTermType(InstitutionTermType institutionTermType) {
		this.institutionTermType = institutionTermType;
	}
	@Override
	public int compare(StudentTranscriptCourse o1, StudentTranscriptCourse o2) {
		int result = 0;
		if(o1.getCompletionDate() != null && o2.getCompletionDate() != null){
			result = o1.getCompletionDate().compareTo(o2.getCompletionDate());
			if(result == 0){
				if(o1.getModifiedDate() != null && o2.getModifiedDate() != null){
					result = o1.getModifiedDate().compareTo(o2.getModifiedDate());
				}
			}
		}
		return result;
	}

	public List<TransferCourseTitle> getTransferCourseTitleList() {
		return transferCourseTitleList;
	}

	public void setTransferCourseTitleList(List<TransferCourseTitle> transferCourseTitleList) {
		this.transferCourseTitleList = transferCourseTitleList;
	}

	public List<CourseMapping> getCourseMappingList() {
		return courseMappingList;
	}

	public void setCourseMappingList(List<CourseMapping> courseMappingList) {
		this.courseMappingList = courseMappingList;
	}

	public String getCourseMappingId() {
		return courseMappingId;
	}

	public void setCourseMappingId(String courseMappingId) {
		this.courseMappingId = courseMappingId;
	}

	public List<CourseCategoryMapping> getCourseCategoryMappingList() {
		return courseCategoryMappingList;
	}

	public void setCourseCategoryMappingList(
			List<CourseCategoryMapping> courseCategoryMappingList) {
		this.courseCategoryMappingList = courseCategoryMappingList;
	}

	public String getCourseCategoryMappingId() {
		return courseCategoryMappingId;
	}

	public void setCourseCategoryMappingId(String courseCategoryMappingId) {
		this.courseCategoryMappingId = courseCategoryMappingId;
	}

	public List<TranscriptCourseSubject> getTranscriptCourseSubjectList() {
		return transcriptCourseSubjectList;
	}

	public void setTranscriptCourseSubjectList(
			List<TranscriptCourseSubject> transcriptCourseSubjectList) {
		this.transcriptCourseSubjectList = transcriptCourseSubjectList;
	}

	public List<MilitarySubject> getMilitarySubjectList() {
		return militarySubjectList;
	}

	public void setMilitarySubjectList(List<MilitarySubject> militarySubjectList) {
		this.militarySubjectList = militarySubjectList;
	}

	public float getTransferCredit() {
		return transferCredit;
	}

	public void setTransferCredit(float transferCredit) {
		this.transferCredit = transferCredit;
	}

				
}
