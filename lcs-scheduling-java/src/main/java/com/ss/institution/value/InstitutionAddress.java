package com.ss.institution.value;

import java.io.Serializable;
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
import com.ss.evaluation.value.Country;

@Entity
@Table(name="ss_tbl_institution_address")
public class InstitutionAddress extends BaseEntity implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -1553692591610322627L;
	
	
	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")
	@Column(name = "id")
	private String id;	
	
	@Column(name="institution_id")
	private String institutionId;
	
	@Column(name="address1")
	private String address1;
	@Column(name="address2")
	private String address2;
	
	@Column(name="city")
	private String city;
	
	@ManyToOne()
	@JoinColumn(name="countryId")
	private Country country = new Country();
	
	
	
	@Column(name="state")
	private String state;
	@Column(name="zipcode")
	private String zipcode;
	@Column(name="phone1")
	private String phone1;
	
	@Column(name="phone2")
	private String phone2;
	
	
	@Column(name = "tollFree")
	private String tollFree;

	@Column(name="fax")
	private String fax;
	@Column(name="website")
	private String website;
	
	@Column(name="email1")
	private String email1;
	
	@Column(name="email2")
	private String email2;
	
	
	
	
	public void setId(String id) {
		this.id = id;
	}
	public String getId() {
		return id;
	}
	public String getAddress1() {
		return address1;
	}
	public void setAddress1(String address1) {
		this.address1 = address1;
	}
	public String getAddress2() {
		return address2;
	}
	public void setAddress2(String address2) {
		this.address2 = address2;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public Country getCountry() {
		return country;
	}
	public void setCountry(Country country) {
		this.country = country;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getZipcode() {
		return zipcode;
	}
	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}
	public String getPhone1() {
		return phone1;
	}
	public void setPhone1(String phone1) {
		this.phone1 = phone1;
	}
	public String getTollFree() {
		return tollFree;
	}
	public void setTollFree(String tollFree) {
		this.tollFree = tollFree;
	}
	public String getFax() {
		return fax;
	}
	public void setFax(String fax) {
		this.fax = fax;
	}
	public String getWebsite() {
		return website;
	}
	public void setWebsite(String website) {
		this.website = website;
	}
	public String getInstitutionId() {
		return institutionId;
	}
	public void setInstitutionId(String institutionId) {
		this.institutionId = institutionId;
	}
	public void setPhone2(String phone2) {
		this.phone2 = phone2;
	}
	public String getPhone2() {
		return phone2;
	}
	public void setEmail1(String email1) {
		this.email1 = email1;
	}
	public String getEmail1() {
		return email1;
	}
	public void setEmail2(String email2) {
		this.email2 = email2;
	}
	public String getEmail2() {
		return email2;
	}
	
}
