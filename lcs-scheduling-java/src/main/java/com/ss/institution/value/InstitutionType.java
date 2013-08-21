package com.ss.institution.value;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.GenericGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ss.common.value.BaseEntity;


@Entity
@Table(name = "ss_tbl_institution_type")
public class InstitutionType extends BaseEntity implements Serializable{

	private static final long serialVersionUID = 14574463497894423L;

	private static transient Logger log = LoggerFactory.getLogger(GcuCourseLevel.class);
	
	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")
	@Column(name = "id")
	private String id;	
	@Column(name = "name")
	private String name;
	
	@Column(name = "description")
	private String description;
	
	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
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
	
	@Override
	public String toString() {
		return String
				.format("InstitutionType [id=%s, name=%s, description=%s, createdBy=%s, createdDate=%s, modifiedBy=%s, modifiedDate=%s]",
						id, name, description, createdBy, createdDate,
						modifiedBy, modifiedDate);
	}
}
