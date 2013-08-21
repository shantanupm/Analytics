package com.ss.institution.value;

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
@Table(name="ss_tbl_articulation_agreement_details")
public class ArticulationAgreementDetails extends BaseEntity{

	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")	
	@Column(name="id")
	private String id;
	
	
	@ManyToOne
	@JoinColumn(name="articulation_agreement_id", referencedColumnName="id")
	private ArticulationAgreement articulationAgreement;
	
	
	@Column(name = "gcu_course_category")
	private String gcuCourseCategory;
	
	
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public ArticulationAgreement getArticulationAgreement() {
		return articulationAgreement;
	}
	public void setArticulationAgreement(ArticulationAgreement articulationAgreement) {
		this.articulationAgreement = articulationAgreement;
	}
	public String getGcuCourseCategory() {
		return gcuCourseCategory;
	}
	public void setGcuCourseCategory(String gcuCourseCategory) {
		this.gcuCourseCategory = gcuCourseCategory;
	}
	
}
