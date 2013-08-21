package com.ss.evaluation.service.client;

import java.net.SocketTimeoutException;
import java.util.HashMap;
import java.util.Map;

import org.apache.http.HttpStatus;
import org.apache.http.conn.ConnectTimeoutException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestTemplate;

import com.ss.common.logging.RequestContext;
import com.ss.evaluation.service.StudentServiceException;
import com.ss.evaluation.service.model.ProgramOfStudyResponse;
import com.ss.evaluation.service.model.StudentSearchResponse;
import com.ss.evaluation.value.Student;

@Component
public class StudentSearchClient {

	@Autowired
	private RestTemplate restTemplate;
	private static transient Logger log = LoggerFactory
			.getLogger(StudentSearchClient.class);
	private static String searchUri = "students?InquiryId={inquiryId}&StudentId={studentId}&StudentNumber={studentNumber}&FirstName={firstName}&LastName={lastName}&MiddleName={middleName}&MaidenName={maidenName}&DateOfBirth={dateOfBirth}&SSN={SSN}&City={city}&State={state}&Country={country}";
	private static String programOfStudyUri = "programsofstudy?InquiryId={inquiryId}&StudentId={studentId}&StudentNumber={studentNumber}";

	@Autowired
	private String crmServiceEndpoint="http://crm11soa.qa.gcu.edu:963/crm.search/api/";

	public StudentSearchClient() {

	}

	/**
	 * Makes a webservice call to CRM for searching a student. The criteria for search is set into the Student object that is passed.
	 * @param studentDTO
	 * @return
	 * @throws Exception 
	 */
	public StudentSearchResponse searchBy(Student studentDTO) throws StudentServiceException {
	     StudentSearchResponse searchResponse =null;
		try {
			String restResourceUrl =crmServiceEndpoint+searchUri;
 			ServiceHeaderRequestCallback requestCallback = new ServiceHeaderRequestCallback();
			MediaType mediaType = new MediaType("application", "json");
			requestCallback.addMediaType(mediaType);
			ServiceResponseExtractor<StudentSearchResponse> responseExtractor = new ServiceResponseExtractor<StudentSearchResponse>(
					StudentSearchResponse.class, restTemplate);
			ResponseEntity<StudentSearchResponse>  response = restTemplate.execute(restResourceUrl, HttpMethod.GET,
					requestCallback, responseExtractor,getQueryVariablesMap(studentDTO));
			if(response!=null){
				searchResponse =  response.getBody();
			}
		} catch (StudentServiceException e) {
			log.error(String.format("Failure in student search call:%s", e),e);
			throw e;
		} catch(Exception e){
			log.error(String.format("Failure in student search call:%s", e),e);
 			StudentServiceException serviceException = resolveAccessException(e);

			throw serviceException;
		}
		return searchResponse;
	}
	

	/**
	 * Makes a webservice call to CRM for retrieving the program of study information.The studentNumber/Inquiry Id is set into the Student object that is passed.
	 * @param studentDTO
	 * @return
	 * @throws Exception 
	 */
	public ProgramOfStudyResponse getProgramsOfStudy(Student studentDTO) throws StudentServiceException {
	     ProgramOfStudyResponse programOfStudyResponse =null;
		try {
			String restResourceUrl =crmServiceEndpoint+programOfStudyUri;
 			ServiceHeaderRequestCallback requestCallback = new ServiceHeaderRequestCallback();
			MediaType mediaType = new MediaType("application", "json");
			requestCallback.addMediaType(mediaType);
			ServiceResponseExtractor<ProgramOfStudyResponse> responseExtractor = new ServiceResponseExtractor<ProgramOfStudyResponse>(
					ProgramOfStudyResponse.class, restTemplate);
			ResponseEntity<ProgramOfStudyResponse>  response = restTemplate.execute(restResourceUrl, HttpMethod.GET,
					requestCallback, responseExtractor,getQueryVariablesMap(studentDTO));
			if(response!=null){
				programOfStudyResponse =  response.getBody();
			}
		} catch (StudentServiceException e) {
			log.error(String.format("Failure in programOfStudy call:%s", e));
			throw e;
		}catch(Exception e){
			log.error(String.format("Failure in programOfStudy call:%s", e));
			StudentServiceException serviceException = new StudentServiceException(e.getMessage(),RequestContext.getRequestIdFromContext());
			throw serviceException;
		}
		return programOfStudyResponse;
	}


	/**
	 * Returns the URL for the rest call. Parameters are being passed as Query
	 * Parameters
	 * 
	 * @param studentDTO
	 * @return
	 */
	private Map<String,String> getQueryVariablesMap(Student studentDTO) {
		Map<String,String> uriVariablesMap = new HashMap<String,String>();
		uriVariablesMap.put("firstName", studentDTO.getDemographics().getFirstName());
		uriVariablesMap.put("lastName", studentDTO.getDemographics().getLastName());
		uriVariablesMap.put("maidenName", studentDTO.getDemographics().getMaidenName());
		uriVariablesMap.put("inquiryId", studentDTO.getCrmId());
		uriVariablesMap.put("studentId",null);
		uriVariablesMap.put("studentNumber", studentDTO.getCampusvueId());
		uriVariablesMap.put("dateOfBirth", studentDTO.getDemographics().getDateOfBirth());
		uriVariablesMap.put("SSN", studentDTO.getDemographics().getSSN());
		uriVariablesMap.put("city", studentDTO.getCity());
		uriVariablesMap.put("state", studentDTO.getState());
		uriVariablesMap.put("country", studentDTO.getCountry());
		uriVariablesMap.put("middleName", studentDTO.getDemographics().getMiddleName());
	    return uriVariablesMap;
	}
	
	/**
	 * Introspects the ResourceException and returns a StudentServiceException with the appropriate error message
	 * @param exception
	 * @return
	 */
	private StudentServiceException resolveAccessException(Exception exception) {
		Throwable rootCause = exception.getCause();
		String errorMessage = exception.getMessage();
		Integer httpStatusCode = 500;
		if(rootCause!=null){
			errorMessage = rootCause.getMessage();
			if(rootCause instanceof SocketTimeoutException){
				httpStatusCode = HttpStatus.SC_REQUEST_TIMEOUT;
			}else if(rootCause instanceof ConnectTimeoutException){
				httpStatusCode = HttpStatus.SC_SERVICE_UNAVAILABLE;
			}
		}
		StudentServiceException serviceException = new StudentServiceException(errorMessage,RequestContext.getRequestIdFromContext());
		serviceException.setHttpResponseCode(httpStatusCode);
		return serviceException;
	}
}
