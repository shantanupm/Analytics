package com.ss.institution.value;

import java.io.Serializable;

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
@Table(name = "ss_tbl_institution_degree")
public class InstitutionDegree extends BaseEntity  implements Serializable {

	private static final long serialVersionUID = 480308206628740196L;

	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")
	@Column(name = "id")
	private String id;	
	
	@ManyToOne
	@JoinColumn( name="institution_id" )
	private Institution institution;
	
	@Column(name = "degree")
	private String degree;
	
	@Column(name = "term_type")
	private String termType;
	
	

	public String getDegree() {
		return degree;
	}

	public void setDegree(String degree) {
		this.degree = degree;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}



	

	/**
	 * @return the termType
	 */
	public String getTermType() {
		return termType;
	}

	/**
	 * @param termType the termType to set
	 */
	public void setTermType(String termType) {
		this.termType = termType;
	}

	

	/**
	 * @return the institution
	 */
	public Institution getInstitution() {
		return institution;
	}

	/**
	 * @param institution the institution to set
	 */
	public void setInstitution(Institution institution) {
		this.institution = institution;
	}

}
