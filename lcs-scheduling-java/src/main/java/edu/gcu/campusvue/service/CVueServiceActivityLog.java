package edu.gcu.campusvue.service;


/**
 * Captures all the integration activity with CampusVue.The captured data is collected
 * and written to the database so that an audit trail is maintained for all the data 
 * that is sent to campusVue
 * @author avinash
 *
 */
public class CVueServiceActivityLog {
	
	private String id;
	private String serviceRequest; 
	private String serviceResponse;
	private String serviceName;
	private String studentNumber;
	private String studentId;
	private boolean callStatus;
	private boolean isPartialFailure;
    private String endpoint;
    private String tokenUsed;
    private long startTimeInMillis = System.currentTimeMillis();
	private long endTimeInMillis;
	private String userInitiatingTheCall;
	
	
	/**
	 * @return the id
	 */
	public String getId() {
		return id;
	}
	/**
	 * @return the serviceRequest
	 */
	public String getServiceRequest() {
		return serviceRequest;
	}
	/**
	 * @return the serviceResponse
	 */
	public String getServiceResponse() {
		return serviceResponse;
	}
	/**
	 * @return the studentNumber
	 */
	public String getStudentNumber() {
		return studentNumber;
	}
	/**
	 * @return the studentId
	 */
	public String getStudentId() {
		return studentId;
	}
	/**
	 * @return the callStatus
	 */
	public boolean isCallStatus() {
		return callStatus;
	}
	/**
	 * @return the isPartialFailure
	 */
	public boolean isPartialFailure() {
		return isPartialFailure;
	}
	/**
	 * @return the endpoint
	 */
	public String getEndpoint() {
		return endpoint;
	}
	/**
	 * @return the tokenUsed
	 */
	public String getTokenUsed() {
		return tokenUsed;
	}
	/**
	 * @return the startTimeInMillis
	 */
	public long getStartTimeInMillis() {
		return startTimeInMillis;
	}
	/**
	 * @return the endTimeInMillis
	 */
	public long getEndTimeInMillis() {
		return endTimeInMillis;
	}
	/**
	 * @param id the id to set
	 */
	public void setId(String id) {
		this.id = id;
	}
	/**
	 * @param serviceRequest the serviceRequest to set
	 */
	public void setServiceRequest(String serviceRequest) {
		this.serviceRequest = serviceRequest;
	}
	/**
	 * @param serviceResponse the serviceResponse to set
	 */
	public void setServiceResponse(String serviceResponse) {
		this.serviceResponse = serviceResponse;
	}
	/**
	 * @param studentNumber the studentNumber to set
	 */
	public void setStudentNumber(String studentNumber) {
		this.studentNumber = studentNumber;
	}
	/**
	 * @param studentId the studentId to set
	 */
	public void setStudentId(String studentId) {
		this.studentId = studentId;
	}
	/**
	 * @param callStatus the callStatus to set
	 */
	public void setCallStatus(boolean callStatus) {
		this.callStatus = callStatus;
	}
	/**
	 * @param isPartialFailure the isPartialFailure to set
	 */
	public void setPartialFailure(boolean isPartialFailure) {
		this.isPartialFailure = isPartialFailure;
	}
	/**
	 * @param endpoint the endpoint to set
	 */
	public void setEndpoint(String endpoint) {
		this.endpoint = endpoint;
	}
	/**
	 * @param tokenUsed the tokenUsed to set
	 */
	public void setTokenUsed(String tokenUsed) {
		this.tokenUsed = tokenUsed;
	}
	/**
	 * @param startTimeInMillis the startTimeInMillis to set
	 */
	public void setStartTimeInMillis(long startTimeInMillis) {
		this.startTimeInMillis = startTimeInMillis;
	}
	/**
	 * @param endTimeInMillis the endTimeInMillis to set
	 */
	public void setEndTimeInMillis(long endTimeInMillis) {
		this.endTimeInMillis = endTimeInMillis;
	}
	/**
	 * @return the userInitiatingTheCall
	 */
	public String getUserInitiatingTheCall() {
		return userInitiatingTheCall;
	}
	/**
	 * @param userInitiatingTheCall the userInitiatingTheCall to set
	 */
	public void setUserInitiatingTheCall(String userInitiatingTheCall) {
		this.userInitiatingTheCall = userInitiatingTheCall;
	}
	/**
	 * @return the serviceName
	 */
	public String getServiceName() {
		return serviceName;
	}
	/**
	 * @param serviceName the serviceName to set
	 */
	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}
    
    
}
