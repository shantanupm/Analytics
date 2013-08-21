package com.ss.evaluation.service.model;


import org.codehaus.jackson.annotate.JsonIgnoreProperties;
import org.codehaus.jackson.annotate.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown=true)
public class StudentSearchResult {
	
	@JsonProperty("CrmId")
 	private String crmId;
	@JsonProperty("InquiryId")
 	private String inquiryId;
	@JsonProperty("StudentId")
 	private String studentId;
	@JsonProperty("StudentNumber")
 	private String studentNumber;
	@JsonProperty("FirstName")
 	private String firstName;
	@JsonProperty("MiddleName")
 	private String middleName;
	@JsonProperty("LastName")
 	private String lastName;
 	@JsonProperty("MaidenName")
 	private String maidenName;
 	@JsonProperty("DateOfBirth")
 	private String dateOfBirth;
 	@JsonProperty("SSN")
 	private String SSN;
 	@JsonProperty("Street1")
  	private String street1;
 	@JsonProperty("Street2")
 	private String street2;
 	@JsonProperty("City")
 	private String city;
 	@JsonProperty("StateProvince")
 	private String stateProvince;
	@JsonProperty("ZipPostalCode")
 	private String zipPostalCode;
 	@JsonProperty("Country")
 	private String country;
 	@JsonProperty("DayTimePhone")
 	private String dayTimePhone;
 	@JsonProperty("EveningPhone")
 	private String eveningPhone;
 	@JsonProperty("MobilePhone")
 	private String mobilePhone;
 	
	public String getCrmId() {
		return crmId;
	}

	public void setCrmId(String crmId) {
		this.crmId = crmId;
	}

	public String getInquiryId() {
		return inquiryId;
	}

	public void setInquiryId(String inquiryId) {
		this.inquiryId = inquiryId;
	}

	public String getStudentId() {
		return studentId;
	}

	public void setStudentId(String studentId) {
		this.studentId = studentId;
	}

	public String getStudentNumber() {
		return studentNumber;
	}

	public void setStudentNumber(String studentNumber) {
		this.studentNumber = studentNumber;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getMiddleName() {
		return middleName;
	}

	public void setMiddleName(String middleName) {
		this.middleName = middleName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getMaidenName() {
		return maidenName;
	}

	public void setMaidenName(String maidenName) {
		this.maidenName = maidenName;
	}

	public String getDateOfBirth() {
		return dateOfBirth;
	}

	public void setDateOfBirth(String dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}

	public String getSSN() {
		return SSN;
	}

	public void setSSN(String sSN) {
		SSN = sSN;
	}

	public String getStreet1() {
		return street1;
	}

	public void setStreet1(String street1) {
		this.street1 = street1;
	}

	public String getStreet2() {
		return street2;
	}

	public void setStreet2(String street2) {
		this.street2 = street2;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getStateProvince() {
		return stateProvince;
	}

	public void setStateProvince(String stateProvince) {
		this.stateProvince = stateProvince;
	}

	public String getZipPostalCode() {
		return zipPostalCode;
	}

	public void setZipPostalCode(String zipPostalCode) {
		this.zipPostalCode = zipPostalCode;
	}

	public String getCountry() {
		return country;
	}

	public void setCountry(String country) {
		this.country = country;
	}

	public String getDayTimePhone() {
		return dayTimePhone;
	}

	public void setDayTimePhone(String dayTimePhone) {
		this.dayTimePhone = dayTimePhone;
	}

	public String getEveningPhone() {
		return eveningPhone;
	}

	public void setEveningPhone(String eveningPhone) {
		this.eveningPhone = eveningPhone;
	}

	public String getMobilePhone() {
		return mobilePhone;
	}

	public void setMobilePhone(String mobilePhone) {
		this.mobilePhone = mobilePhone;
	}

}
