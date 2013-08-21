package com.ss.course.value;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

import com.ss.common.value.BaseEntity;


@Entity
@Table(name = "ss_tbl_military_subject")
public class MilitarySubject extends BaseEntity   implements Serializable  {

	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")
	@Column(name = "id")
	private String id;	
	
	@Column(name = "transfer_course_id")
	private String transferCourseId;
	
	@Column(name = "name")
	private String name;
	
	@Column(name = "course_level")
	private String courseLevel;
	
	
	@Column(name = "soc_category_code")
	private String socCategoryCode;

	/*@Column(name = "transfer_credit_gcu")
	private int transferCredit;*/

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


	public String getName() {
		return name;
	}


	public void setName(String name) {
		this.name = name;
	}


	public String getCourseLevel() {
		return courseLevel;
	}


	public void setCourseLevel(String courseLevel) {
		this.courseLevel = courseLevel;
	}


	public String getSocCategoryCode() {
		return socCategoryCode;
	}


	public void setSocCategoryCode(String socCategoryCode) {
		this.socCategoryCode = socCategoryCode;
	}


/*	public int getTransferCredit() {
		return transferCredit;
	}


	public void setTransferCredit(int transferCredit) {
		this.transferCredit = transferCredit;
	}*/


}
