package com.ss.evaluation.dto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import org.springframework.util.StringUtils;

public class Demographics implements Serializable{
	
	private String firstName;
	private String lastName;
	private String middleName;
	private String maidenName;
	private List<Address> addressList = new ArrayList<Address>();
	private List<Phone> phoneList = new ArrayList<Phone>();
	private String SSN;
	private String last4SSN;
	private String dateOfBirth;
	
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
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
	public List<Address> getAddressList() {
		return addressList;
	}
	public void setAddressList(List<Address> addressList) {
		this.addressList = addressList;
	}
	public List<Phone> getPhoneList() {
		return phoneList;
	}
	public void setPhoneList(List<Phone> phoneList) {
		this.phoneList = phoneList;
	}
	public String getLast4SSN() {
		return last4SSN;
	}
	public void setLast4SSN(String last4ssn) {
		last4SSN = last4ssn;
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
		maskSSNandSetlast4SSN(sSN);
	}
	
	/**
	 * masks the full SSN to last 4 digits and sets a value for last4 Digits
	 * @param sSN2
	 */
	private void maskSSNandSetlast4SSN(String fullSSN) {
        if(StringUtils.hasText(fullSSN) && (fullSSN.length() >4)){
        	setLast4SSN(fullSSN.substring((fullSSN.length()-4)));
        }
	}
	public String getMiddleName() {
		return middleName;
	}
	public void setMiddleName(String middleName) {
		this.middleName = middleName;
	}
	@Override
	public String toString() {
		return String
				.format("Demographics [firstName=%s, lastName=%s, maidenName=%s, addressList=%s, phoneList=%s, last4SSN=%s, dateOfBirth=%s]",
						firstName, lastName, maidenName, addressList,
						phoneList, last4SSN, dateOfBirth);
	}
	

}
