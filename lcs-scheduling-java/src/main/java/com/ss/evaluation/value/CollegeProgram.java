package com.ss.evaluation.value;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

import com.ss.common.value.BaseEntity;

@Entity
@Table(name="ss_tbl_college_program")
public class CollegeProgram extends BaseEntity implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")	
	@Column(name="id")
	private String id;	
	
	@Column(name="program_code")
	private String programCode;	
	
	@Column(name="description")
	private String description;
	
	@Column(name="college_code")
	private String collegeCode;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getProgramCode() {
		return programCode;
	}

	public void setProgramCode(String programCode) {
		this.programCode = programCode;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getCollegeCode() {
		return collegeCode;
	}

	public void setCollegeCode(String collegeCode) {
		this.collegeCode = collegeCode;
	}	
	
}
