package com.ss.evaluation.dto;

import java.io.Serializable;

public class Phone implements Serializable{
	
	private String countryCode;
	private String areaCode;
	private String number;
	private String extension;
	
	public Phone(String countryCode, String areaCode, String number,
			String extension) {
		super();
		this.countryCode = countryCode;
		this.areaCode = areaCode;
		this.number = number;
		this.extension = extension;
	}
	public String getCountryCode() {
		return countryCode;
	}
	public void setCountryCode(String countryCode) {
		this.countryCode = countryCode;
	}
	public String getAreaCode() {
		return areaCode;
	}
	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}
	public String getNumber() {
		return number;
	}
	public void setNumber(String number) {
		this.number = number;
	}
	public String getExtension() {
		return extension;
	}
	public void setExtension(String extension) {
		this.extension = extension;
	}
	@Override
	public String toString() {
		return String.format(
				"Phone [countryCode=%s, areaCode=%s, number=%s, extension=%s]",
				countryCode, areaCode, number, extension);
	}

}
