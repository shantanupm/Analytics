package com.ss.evaluation.service;

/**
 * Exception Wrapper that is returned from the StudentService
 *
 */
public class StudentServiceException extends RuntimeException {
	
	private static final long serialVersionUID = 1L;
	private String referenceNo;
	private Integer httpResponseCode;
	private String transactionId;
	private String errorMessage;

	public StudentServiceException() {
		
	}

	public StudentServiceException(String errorMessage,String referenceNumber) {
		super(errorMessage);
		referenceNo =referenceNumber;
		this.errorMessage = errorMessage;
 	}

	public StudentServiceException(Throwable arg0) {
		super(arg0);
 	}

	 
	/**
	 * Returns the referenceNumber for this Message
	 * @return
	 */
	public String getReferenceNo() {
		return referenceNo;
	}

	public void setTransactionId(String transactionId) {
		this.transactionId=transactionId;
	}

	public Integer getHttpResponseCode() {
		return httpResponseCode;
	}

	public void setHttpResponseCode(Integer httpResponseCode) {
		this.httpResponseCode = httpResponseCode;
	}

	public void setReferenceNo(String referenceNo) {
		this.referenceNo = referenceNo;
	}

	public String getTransactionId() {
		return transactionId;
	}

	public String getErrorMessage() {
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}

}
