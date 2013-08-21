package edu.gcu.campusvue.service;

/**
 * Exception wrapper for exceptions from CampusVue Services and CampusVueClient
 * 
 */
public class CampusVueServiceException extends RuntimeException {

	private static final long serialVersionUID = 1L;
	private String errorMessage;
	private String referenceNumber;
	private String errorCode;
	private ErrorType errorType;
	private Exception exception;


	public CampusVueServiceException(String errorMessage,
			String referenceNumber, String errorCode, ErrorType errorType) {
		super(errorMessage);
		this.errorMessage = errorMessage;
		this.referenceNumber = referenceNumber;
		this.errorCode = errorCode;
		this.setErrorType(errorType);
	}

	public CampusVueServiceException(Throwable arg0) {
		super(arg0);
	}

	public String getErrorMessage() {
		return errorMessage;
	}

	public String getReferenceNumber() {
		return referenceNumber;
	}

	public String getErrorCode() {
		return errorCode;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}

	public void setReferenceNumber(String referenceNumber) {
		this.referenceNumber = referenceNumber;
	}

	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}

	public ErrorType getErrorType() {
		return errorType;
	}

	public void setErrorType(ErrorType errorType) {
		this.errorType = errorType;
	}

}
