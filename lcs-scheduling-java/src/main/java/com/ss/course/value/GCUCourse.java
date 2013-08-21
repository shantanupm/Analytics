package com.ss.course.value;

import java.util.Date;

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
import com.ss.institution.value.GcuCourseLevel;

@Entity
@Table(name ="ss_tbl_gcu_course_master")
public class GCUCourse {
	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")	
	@Column(name="id")
	private String id;
	
	@Column(name="course_code")
	private String courseCode;
	
	@Column(name="title")
	private String title;
	
	@Column(name="credits")
	private int credits;

	@Column(name="course_level_id")
	private float courseLevelId;

	@Column(name="date_added")
	private Date dateAdded;

	@Transient
	private GcuCourseLevel gcuCourseLevel;
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	
	public String getCourseCode() {
		return courseCode;
	}

	public void setCourseCode(String courseCode) {
		this.courseCode = courseCode;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public int getCredits() {
		return credits;
	}

	public void setCredits(int credits) {
		this.credits = credits;
	}

	public float getCourseLevelId() {
		return courseLevelId;
	}

	public void setCourseLevelId(float courseLevelId) {
		this.courseLevelId = courseLevelId;
	}

	public Date getDateAdded() {
		return dateAdded;
	}

	public void setDateAdded(Date dateAdded) {
		this.dateAdded = dateAdded;
	}

	public GcuCourseLevel getGcuCourseLevel() {
		return gcuCourseLevel;
	}

	public void setGcuCourseLevel(GcuCourseLevel gcuCourseLevel) {
		this.gcuCourseLevel = gcuCourseLevel;
	}

	

}
