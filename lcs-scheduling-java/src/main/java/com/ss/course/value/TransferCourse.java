package com.ss.course.value;

import java.io.Serializable;
import java.util.ArrayList;
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
import org.hibernate.annotations.Type;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ss.common.util.EqualsUtil;
import com.ss.common.value.BaseEntity;
import com.ss.institution.value.Institution;
import com.ss.institution.value.TransferCourseInstitutionTranscriptKeyGradeAssoc;
import com.ss.user.value.User;

@Entity
@Table(name = "ss_tbl_transfer_course")
public class TransferCourse extends BaseEntity   implements Serializable  , Comparable<TransferCourse>{

	private static final long serialVersionUID = 14574463497894423L;

	private static transient Logger log = LoggerFactory.getLogger(TransferCourse.class);
	
	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")
	@Column(name = "id")
	private String id;	
	/*@Column(name = "school_code")
	private String schoolCode;*/
	
	
	@ManyToOne
	@JoinColumn(name="institution_id", referencedColumnName="id")
	private Institution institution;
	
	@Column(name = "institution_degree_id")
	private String institutionDegreeId;
	
	@Column(name = "tr_course_code")
	private String trCourseCode;
	
	
	@Column(name = "tr_course_title")
	private String trCourseTitle;
	
	@Column(name = "transcript_credits")
	private String transcriptCredits;
	
	@Column(name = "semester_credits")
	private String semesterCredits;
	
	
	@Column(name = "pass_fail")
	private boolean passFail;
	
	
	@Column(name = "minimum_grade")
	private String minimumGrade;
	
	@Column(name = "course_level_id")
	private String courseLevelId;
	
	@Column(name = "clock_hours")
	private int clockHours;
	
	@Column(name = "effective_date")
	private Date effectiveDate;
	
	@Column(name = "end_date")
	private Date endDate;
	
	@Column(name = "transfer_status")
	private String transferStatus;
	
	@Column(name = "catalog_course_description")
	private String catalogCourseDescription;
	
	@Column(name = "evaluation_status")
	private String evaluationStatus;
		
	
	
	
	@Column(name = "checked_by")
	private String checkedBy;
	@Column(name = "checked_date")
	
	private Date checkedDate;
	
	@Column(name = "confirmed_by")
	private String confirmedBy;
	@Column(name = "confirmed_date")
	private Date confirmedDate;
	

	@Column(name = "college_approval_required")
	private boolean collegeApprovalRequired ;
	
	@Column(name = "iem_comment")
	private String iemComment;
	
	@Column(name = "course_type")
	private String courseType;
	
	@Column(name = "clock_hours_chk")
	private boolean clockHoursChk ;
	
	@Column(name = "ace_exhibit_no")
	private String aceExhibitNo ;

	@Column(name = "campusvue_transfercourse_id")
	private String campusVueTransferCourseId ;
	
	@Transient
	private List<TransferCourseTitle> titleList = new ArrayList<TransferCourseTitle>();

	@Transient
	private String strInstName;
	
	@Transient
	private List<CourseMapping> courseMappings=new ArrayList<CourseMapping>();
	@Transient
	private List<CourseCategoryMapping> courseCategoryMappings= new ArrayList<CourseCategoryMapping>();
	
	@Transient
	private List<TransferCourseInstitutionTranscriptKeyGradeAssoc> transferCourseInstitutionTranscriptKeyGradeAssocList = new ArrayList<TransferCourseInstitutionTranscriptKeyGradeAssoc>();
	
	@Transient
	private User evaluator1 = null;
	
	@Transient
	private User evaluator2 = null ;

	@Transient
	private CourseTranscript courseTranscript;
	
	@Transient
	private boolean reassignable = false;
	
	@Transient
	private List<MilitarySubject> militarySubjectList = new ArrayList<MilitarySubject>();


	public User getEvaluator1() {
		return evaluator1;
	}

	public void setEvaluator1(User evaluator1) {
		this.evaluator1 = evaluator1;
	}

	public User getEvaluator2() {
		return evaluator2;
	}

	public void setEvaluator2(User evaluator2) {
		this.evaluator2 = evaluator2;
	}

	public List<CourseMapping> getCourseMappings() {
		return courseMappings;
	}

	public void setCourseMappings(List<CourseMapping> courseMappings) {
		this.courseMappings = courseMappings;
	}

	public List<CourseCategoryMapping> getCourseCategoryMappings() {
		return courseCategoryMappings;
	}

	public void setCourseCategoryMappings(
			List<CourseCategoryMapping> courseCategoryMappings) {
		this.courseCategoryMappings = courseCategoryMappings;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	/*public String getSchoolCode() {
		return schoolCode;
	}

	public void setSchoolCode(String schoolCode) {
		this.schoolCode = schoolCode;
	}*/

	public Institution getInstitution() {
		return institution;
	}

	public void setInstitution(Institution institution) {
		this.institution = institution;
	}

	public String getTrCourseCode() {
		return trCourseCode;
	}

	public void setTrCourseCode(String trCourseCode) {
		this.trCourseCode = trCourseCode;
	}

	public String getTrCourseTitle() {
		return trCourseTitle;
	}

	public void setTrCourseTitle(String trCourseTitle) {
		this.trCourseTitle = trCourseTitle;
	}

	
	public String getTranscriptCredits() {
		return transcriptCredits;
	}

	public void setTranscriptCredits(String transcriptCredits) {
		this.transcriptCredits = transcriptCredits;
	}

	
	public String getSemesterCredits() {
		return semesterCredits;
	}

	public void setSemesterCredits(String semesterCredits) {
		this.semesterCredits = semesterCredits;
	}

	public boolean isPassFail() {
		return passFail;
	}

	public void setPassFail(boolean passFail) {
		this.passFail = passFail;
	}

	public String getMinimumGrade() {
		return minimumGrade;
	}

	public void setMinimumGrade(String minimumGrade) {
		this.minimumGrade = minimumGrade;
	}

	public String getCourseLevelId() {
		return courseLevelId;
	}

	public void setCourseLevelId(String courseLevelId) {
		this.courseLevelId = courseLevelId;
	}

	public int getClockHours() {
		return clockHours;
	}

	public void setClockHours(int clockHours) {
		this.clockHours = clockHours;
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

	public String getTransferStatus() {
		return transferStatus;
	}

	public void setTransferStatus(String transferStatus) {
		this.transferStatus = transferStatus;
	}
	
	public String getCatalogCourseDescription() {
		return catalogCourseDescription;
	}

	public void setCatalogCourseDescription(String catalogCourseDescription) {
		this.catalogCourseDescription = catalogCourseDescription;
	}

	public String getEvaluationStatus() {
		return evaluationStatus;
	}

	public void setEvaluationStatus(String evaluationStatus) {
		this.evaluationStatus = evaluationStatus;
	}

	

	public String getCheckedBy() {
		return checkedBy;
	}
	public void setCheckedBy(String checkedBy) {
		this.checkedBy = checkedBy;
	}
	public Date getCheckedDate() {
		return checkedDate;
	}
	public void setCheckedDate(Date checkedDate) {
		this.checkedDate = checkedDate;
	}
	public String getConfirmedBy() {
		return confirmedBy;
	}
	public void setConfirmedBy(String confirmedBy) {
		this.confirmedBy = confirmedBy;
	}
	public Date getConfirmedDate() {
		return confirmedDate;
	}
	public void setConfirmedDate(Date confirmedDate) {
		this.confirmedDate = confirmedDate;
	}
	
	
	public String getInstitutionDegreeId() {
		return institutionDegreeId;
	}

	public void setInstitutionDegreeId(String institutionDegreeId) {
		this.institutionDegreeId = institutionDegreeId;
	}

	public String getStrInstName() {
		return strInstName;
	}
	
	public List<TransferCourseTitle> getTitleList() {
		return titleList;
	}

	public void setTitleList(List<TransferCourseTitle> titleList) {
		this.titleList = titleList;
	}
	
	public void setStrInstName(String strInstName) {
		this.strInstName = strInstName;
	}
	
	 public boolean isCollegeApprovalRequired() {
			return collegeApprovalRequired;
		}

	public void setCollegeApprovalRequired(boolean isCollegeApprovalRequired) {
		this.collegeApprovalRequired = isCollegeApprovalRequired;
	}

	 public String getIemComment() {
			return iemComment;
		}

		public void setIemComment(String iemComment) {
			this.iemComment = iemComment;
		}

	
	/*Course Code Course Title Transcript Credits	Pass/Fail Course Level Clock Hours Effective Date (if entered) End Date (if entered)
	Transfer Status 	Course/Course Category Relationship	*/
	
	
	@Override 
	 public boolean equals(Object aThat) {
		    //check for self-comparison
		    if ( this == aThat ) return true;
		    
		    if ( !(aThat instanceof TransferCourse) ) return false;
		    //Alternative to the above line : if ( aThat == null || aThat.getClass() != this.getClass() ) return false;
		    
		    //cast to native object is now safe
		    TransferCourse that = (TransferCourse)aThat;

		    //now a proper field-by-field evaluation can be made
		    return
		      EqualsUtil.areEqual(this.trCourseCode, that.trCourseCode) &&
		      EqualsUtil.areEqual(this.trCourseTitle, that.trCourseTitle) &&
		      EqualsUtil.areEqual(this.transcriptCredits, that.transcriptCredits) &&
		      EqualsUtil.areEqual(this.passFail, that.passFail) &&
		      EqualsUtil.areEqual(this.courseLevelId, that.courseLevelId) &&
		      EqualsUtil.areEqual(this.clockHours, that.clockHours) &&
		      EqualsUtil.areEqual(this.effectiveDate, that.effectiveDate) &&
		      EqualsUtil.areEqual(this.endDate, that.endDate) &&
		      EqualsUtil.areEqual(this.transferStatus, that.transferStatus) ;
		  }

	
	public void setCourseTranscript(CourseTranscript courseTranscript) {
		this.courseTranscript = courseTranscript;
	}

	public CourseTranscript getCourseTranscript() {
		return courseTranscript;
	}

	public void setReassignable(boolean reassignable) {
		this.reassignable = reassignable;
	}

	public boolean isReassignable() {
		return reassignable;
	}

	@Override
	public int compareTo(TransferCourse obj) {
		// TODO Auto-generated method stub
		if(this.getModifiedDate() != null && obj.getModifiedDate() != null){
			return this.getModifiedDate().compareTo((obj.getModifiedDate()));
		}
		
		return 0;
	}

	public List<TransferCourseInstitutionTranscriptKeyGradeAssoc> getTransferCourseInstitutionTranscriptKeyGradeAssocList() {
		return transferCourseInstitutionTranscriptKeyGradeAssocList;
	}

	public void setTransferCourseInstitutionTranscriptKeyGradeAssocList(
			List<TransferCourseInstitutionTranscriptKeyGradeAssoc> transferCourseInstitutionTranscriptKeyGradeAssocList) {
		this.transferCourseInstitutionTranscriptKeyGradeAssocList = transferCourseInstitutionTranscriptKeyGradeAssocList;
	}

	public boolean isClockHoursChk() {
		return clockHoursChk;
	}

	public void setClockHoursChk(boolean clockHoursChk) {
		this.clockHoursChk = clockHoursChk;
	}

	public String getCourseType() {
		return courseType;
	}

	public void setCourseType(String courseType) {
		this.courseType = courseType;
	}

	public String getAceExhibitNo() {
		return aceExhibitNo;
	}

	public void setAceExhibitNo(String aceExhibitNo) {
		this.aceExhibitNo = aceExhibitNo;
	}

	public List<MilitarySubject> getMilitarySubjectList() {
		return militarySubjectList;
	}

	public void setMilitarySubjectList(List<MilitarySubject> militarySubjectList) {
		this.militarySubjectList = militarySubjectList;
	}

	public String getCampusVueTransferCourseId() {
		return campusVueTransferCourseId;
	}

	public void setCampusVueTransferCourseId(String campusVueTransferCourseId) {
		this.campusVueTransferCourseId = campusVueTransferCourseId;
	}

	
	 
	 
	
}
