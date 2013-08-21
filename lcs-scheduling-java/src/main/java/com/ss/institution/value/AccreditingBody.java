package com.ss.institution.value;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

import com.ss.common.value.BaseEntity;

@Entity
@Table(name="ss_tbl_accrediting_body")
public class AccreditingBody extends BaseEntity implements Serializable{


	private static final long serialVersionUID = 5627799175946336231L;

	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")	
	@Column(name="id")
	private String id;
	
	@Column(name = "name")
	private String name;
	
	@Column(name = "regional")
	private boolean regional;
	
	
	
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
	public boolean isRegional() {
		return regional;
	}
	public void setRegional(boolean regional) {
		this.regional = regional;
	}
	
	
}
