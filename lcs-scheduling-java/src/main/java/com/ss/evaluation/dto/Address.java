package com.ss.evaluation.dto;

import java.io.Serializable;

public class Address implements Serializable {
	
	private String line1;
	private String line2;
	private String line3;
	private String city;
	private String state;
	private String country;
	private String zipcode;
	
	public Address(String line1, String line2, String line3,String city, String state,
			String country, String zipcode) {
		super();
		this.line1 = line1;
		this.line2 = line2;
		this.line3 = line3;
		this.city = city;
		this.state = state;
		this.country = country;
		this.zipcode = zipcode;
	}
	
	public String getLine1() {
		return line1;
	}
	public void setLine1(String line1) {
		this.line1 = line1;
	}
	public String getLine2() {
		return line2;
	}
	public void setLine2(String line2) {
		this.line2 = line2;
	}
	public String getLine3() {
		return line3;
	}
	public void setLine3(String line3) {
		this.line3 = line3;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	public String getZipcode() {
		return zipcode;
	}
	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}
	
	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	@Override
	public String toString() {
		return String
				.format("Address [line1=%s, line2=%s, line3=%s, state=%s, country=%s, zipcode=%s]",
						line1, line2, line3, state, country, zipcode);
	}

}
