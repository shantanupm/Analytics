package com.ss.course.value;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.GenericGenerator;

import com.ss.common.value.BaseEntity;
import com.ss.evaluation.value.StudentInstitutionTranscript;


@Entity
@Table(name ="ss_tbl_transfer_course_gcucourse_mapping")
public class CourseMapping extends BaseEntity implements  Comparable<CourseMapping> {
	
	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")
	@Column(name = "id")
	private String id;	
	
	
	@Column(name = "tr_courseId")
	private String trCourseId;
	
	@Transient
	private List<CourseMappingDetail> courseMappingDetails=new ArrayList<CourseMappingDetail>();
	
	@Transient
	private String relatedGCUCourseCode;
	
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

	public List<CourseMappingDetail> getCourseMappingDetails() {
		return courseMappingDetails;
	}

	public void setCourseMappingDetails(List<CourseMappingDetail> courseMappingDetails) {
		this.courseMappingDetails = courseMappingDetails;
	}

	public String getRelatedGCUCourseCode() {
		return relatedGCUCourseCode;
	}

	public void setRelatedGCUCourseCode(String relatedGCUCourseCode) {
		this.relatedGCUCourseCode = relatedGCUCourseCode;
	}

	
	@Override
	public int compareTo(CourseMapping obj) {
		if(this.getModifiedDate() != null && obj.getModifiedDate() != null) {
			return this.getModifiedDate().compareTo(obj.getModifiedDate());
		}
		return 0;
	}
	

	/* @Override public boolean equals(Object aThat) {
		    //check for self-comparison
		    if ( this == aThat ) return true;
		    
		    if ( !(aThat instanceof CourseMapping) ) return false;
		    //Alternative to the above line : if ( aThat == null || aThat.getClass() != this.getClass() ) return false;
		    
		    //cast to native object is now safe
		    CourseMapping that = (CourseMapping)aThat;

		    //now a proper field-by-field evaluation can be made
		    return
		      EqualsUtil.areEqual(this.trCourseId, that.trCourseId) &&
		      EqualsUtil.areEqual(this.gcuCourse.getId(), that.gcuCourse.getId()) &&
		      EqualsUtil.areEqual(this.credits, that.credits) &&
		      EqualsUtil.areEqual(this.minTransferGrade, that.minTransferGrade) &&
		      EqualsUtil.areEqual(this.effectiveDate, that.effectiveDate) &&
		      EqualsUtil.areEqual(this.endDate, that.endDate) &&
		      EqualsUtil.areEqual(this.evaluationStatus, that.evaluationStatus) ;
		  }*/

	
}
