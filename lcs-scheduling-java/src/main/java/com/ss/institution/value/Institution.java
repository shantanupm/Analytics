package com.ss.institution.value;

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

import com.ss.common.util.EqualsUtil;
import com.ss.common.value.BaseEntity;
import com.ss.course.value.TransferCourse;
import com.ss.evaluation.value.Student;
import com.ss.user.value.User;
@Entity
@Table(name="ss_tbl_institution")
public class Institution extends BaseEntity implements Serializable, Comparable<Institution> {
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
	
	@Column(name="institution_id" )
	private String institutionID;
	
	@Column(name="name")
	private String name;
	@Column(name="schoolcode")
	private String schoolcode;
	@Column(name="locationId")
	private String locationId;

	@ManyToOne()
	@JoinColumn(name="institutionTypeId")
	private InstitutionType institutionType= new InstitutionType();
	
	
	
	@Column(name="parentInstitutionId")
	private String parentInstitutionId;	
	@Column(name="transcriptKeyId")
	private String transcriptKeyId;
	@Column(name="articulationAgreementId")
	private String articulationAgreementId;
	@Column(name="evaluationStatus")
	private String evaluationStatus;
	@Column(name="evaluation_type")
	private String evaluationType;
	@Column(name = "checked_by")
	private String checkedBy;
	@Column(name = "checked_date")
	private Date checkedDate;
	
	@Column(name = "confirmed_by")
	private String confirmedBy;
	@Column(name = "confirmed_date")
	private Date confirmedDate;
	

	@Column(name = "checked_status")
	private String checkedStatus;
	

	@Column(name = "confirmed_status")
	private String confirmedStatus;
	
	@Transient
	private List<AccreditingBodyInstitute> accreditingBodyInstitutes= new ArrayList<AccreditingBodyInstitute>();
	@Transient
	private List<InstitutionTermType> institutionTermTypes= new ArrayList<InstitutionTermType>();
	@Transient
	private List<ArticulationAgreement> articulationAgreements=new ArrayList<ArticulationAgreement>();
	@Transient
	private List<InstitutionTranscriptKey> institutionTranscriptKeys= new ArrayList<InstitutionTranscriptKey>();
	
	@Transient
	private List<TransferCourse> transferCourses= new ArrayList<TransferCourse>();
	
	@Transient
	private User evaluator1 = null;
	
	@Transient
	private User evaluator2 = null ;

	@Transient
	private InstitutionTranscript institutionTranscript; 
	
	@Transient
	private boolean reassignable = false;
		
	@Transient
	private String parentInstitutionName;
	
	@Transient
	private List<InstitutionAddress> addresses= new ArrayList<InstitutionAddress>();
	
	@Transient
	private InstitutionAddress institutionAddress;
	
	@Column(name="campusvue_institution_id")
	private String campusVueInstitutionId;
	
	@Transient
	private Student lastStudent;
	
	
	
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
	
	
	
	public List<AccreditingBodyInstitute> getAccreditingBodyInstitutes() {
		return accreditingBodyInstitutes;
	}
	public void setAccreditingBodyInstitutes(
			List<AccreditingBodyInstitute> accreditingBodyInstitutes) {
		this.accreditingBodyInstitutes = accreditingBodyInstitutes;
	}
	public List<ArticulationAgreement> getArticulationAgreements() {
		return articulationAgreements;
	}
	public void setArticulationAgreements(
			List<ArticulationAgreement> articulationAgreements) {
		this.articulationAgreements = articulationAgreements;
	}
	public List<InstitutionTranscriptKey> getInstitutionTranscriptKeys() {
		return institutionTranscriptKeys;
	}
	public void setInstitutionTranscriptKeys(
			List<InstitutionTranscriptKey> institutionTranscriptKeys) {
		this.institutionTranscriptKeys = institutionTranscriptKeys;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getSchoolcode() {
		return schoolcode;
	}
	public void setSchoolcode(String schoolcode) {
		this.schoolcode = schoolcode;
	}
	public String getLocationId() {
		return locationId;
	}
	public void setLocationId(String locationId) {
		this.locationId = locationId;
	}
	
	public String getParentInstitutionId() {
		return parentInstitutionId;
	}
	public void setParentInstitutionId(String parentInstitutionId) {
		this.parentInstitutionId = parentInstitutionId;
	}
	public String getTranscriptKeyId() {
		return transcriptKeyId;
	}
	public void setTranscriptKeyId(String transcriptKeyId) {
		this.transcriptKeyId = transcriptKeyId;
	}
	public String getArticulationAgreementId() {
		return articulationAgreementId;
	}
	public void setArticulationAgreementId(String articulationAgreementId) {
		this.articulationAgreementId = articulationAgreementId;
	}
	public String getEvaluationStatus() {
		return evaluationStatus;
	}
	public void setEvaluationStatus(String evaluationStatus) {
		this.evaluationStatus = evaluationStatus;
	}
	
	public String getEvaluationType() {
		return evaluationType;
	}
	public void setEvaluationType(String evaluationType) {
		this.evaluationType = evaluationType;
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
	public InstitutionType getInstitutionType() {
		return institutionType;
	}
	public void setInstitutionType(InstitutionType institutionType) {
		this.institutionType = institutionType;
	}
	public List<InstitutionTermType> getInstitutionTermTypes() {
		return institutionTermTypes;
	}
	public void setInstitutionTermTypes(List<InstitutionTermType> institutionTermTypes) {
		this.institutionTermTypes = institutionTermTypes;
	}
	public List<TransferCourse> getTransferCourses() {
		return transferCourses;
	}
	public void setTransferCourses(List<TransferCourse> transferCourses) {
		this.transferCourses = transferCourses;
	}
	

	 @Override public boolean equals(Object aThat) {
		    //check for self-comparison
		    if ( this == aThat ) return true;
		    
		    if ( !(aThat instanceof Institution) ) return false;
		    //Alternative to the above line : if ( aThat == null || aThat.getClass() != this.getClass() ) return false;
		    
		    //cast to native object is now safe
		    Institution that = (Institution)aThat;

		    //now a proper field-by-field evaluation can be made
		    return
		      EqualsUtil.areEqual(this.schoolcode, that.schoolcode) &&
		      EqualsUtil.areEqual(this.name, that.name);
		    //  &&    EqualsUtil.areEqual(this.city, that.city) &&
		     // EqualsUtil.areEqual(this.state, that.state);
		     
		  }

	public void setInstitutionTranscript(InstitutionTranscript institutionTranscript) {
		this.institutionTranscript = institutionTranscript;
	}

	public InstitutionTranscript getInstitutionTranscript() {
		return institutionTranscript;
	}

	

	public void setInstitutionID(String institutionID) {
		this.institutionID = institutionID;
	}

	public String getInstitutionID() {
		return institutionID;
	}

	public boolean isReassignable() {
		return reassignable;
	}

	public void setReassignable(boolean reassignable) {
		this.reassignable = reassignable;
	}

	public void setParentInstitutionName(String parentInstitutionName) {
		this.parentInstitutionName = parentInstitutionName;
	}

	public String getParentInstitutionName() {
		return parentInstitutionName;
	}

	

	@Override
	public int compareTo(Institution obj) {
		if(this.getModifiedDate() != null && obj.getModifiedDate() != null) {
			return obj.getModifiedDate().compareTo(this.getModifiedDate());
		}
		return 0;
	}

	public void setAddresses(List<InstitutionAddress> addresses) {
		this.addresses = addresses;
	}

	public List<InstitutionAddress> getAddresses() {
		return addresses;
	}

	public InstitutionAddress getInstitutionAddress() {
		return institutionAddress;
	}

	public void setInstitutionAddress(InstitutionAddress institutionAddress) {
		this.institutionAddress = institutionAddress;
	}

	public String getCheckedStatus() {
		return checkedStatus;
	}

	public void setCheckedStatus(String checkedStatus) {
		this.checkedStatus = checkedStatus;
	}

	public String getConfirmedStatus() {
		return confirmedStatus;
	}

	public void setConfirmedStatus(String confirmedStatus) {
		this.confirmedStatus = confirmedStatus;
	}

	public String getCampusVueInstitutionId() {
		return campusVueInstitutionId;
	}

	public void setCampusVueInstitutionId(String campusVueInstitutionId) {
		this.campusVueInstitutionId = campusVueInstitutionId;
	}

	
	public Student getLastStudent() {
		return lastStudent;
	}

	public void setLastStudent(Student lastStudent) {
		this.lastStudent = lastStudent;
	}
	
}
