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
@Table(name="ss_tbl_college_master")
public class College extends BaseEntity implements Serializable {
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")	
	@Column(name="id")
	private String id;	
	
	@Column(name="code")
	private String code;	
	
	@Column(name="description")
	private String description;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}		
	

}
