package com.ss.course.value;

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

@Entity
@Table(name="ss_tbl_transfer_course_gcucourse_mapping_detail")
public class CourseMappingDetail extends BaseEntity implements  Comparable<CourseMappingDetail>{
	
	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name="customuuid", strategy="com.ss.common.util.CustomUUIDGenerator")
	@Column(name="id")
	private String id;
	
	@ManyToOne
	@JoinColumn(name="gcu_course_id")
	private GCUCourse gcuCourse;
	

	@Column(name="course_mapping_id")
	private String courseMappingId;
	
	
	@Column(name = "effective_date")
	private Date effectiveDate;
	
	@Column(name = "end_date")
	private Date endDate;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public GCUCourse getGcuCourse() {
		return gcuCourse;
	}

	public void setGcuCourse(GCUCourse gcuCourse) {
		this.gcuCourse = gcuCourse;
	}

	public String getCourseMappingId() {
		return courseMappingId;
	}

	public void setCourseMappingId(String courseMappingId) {
		this.courseMappingId = courseMappingId;
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
	
	@Override
	public int compareTo(CourseMappingDetail obj) {
		if(this.getModifiedDate() != null && obj.getModifiedDate() != null) {
			return this.getModifiedDate().compareTo(obj.getModifiedDate());
		}
		return 0;
	}

}
