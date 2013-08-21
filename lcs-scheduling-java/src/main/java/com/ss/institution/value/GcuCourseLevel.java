package com.ss.institution.value;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ss.common.value.BaseEntity;

@Entity
@Table(name = "ss_tbl_gcu_course_level")
public class GcuCourseLevel extends BaseEntity implements Serializable{

	private static final long serialVersionUID = 14574463497894423L;

	private static transient Logger log = LoggerFactory.getLogger(GcuCourseLevel.class);
	
	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")
	@Column(name = "id")
	private String id;	
	@Column(name="name")
	private String name;	
	@Column(name="description")
	private String description;
	
	
	
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
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	
}
