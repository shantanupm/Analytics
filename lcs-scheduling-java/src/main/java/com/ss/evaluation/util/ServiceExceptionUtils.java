package com.ss.evaluation.util;

import org.apache.http.HttpStatus;

import com.ss.common.logging.RequestContext;
import com.ss.evaluation.service.StudentServiceException;

public class ServiceExceptionUtils {

	private static String refineSearchCriteriaMessage = "Total number of matching results exceed 40. Refine your search for more accurate results.";
	private static String timedoutMessage = "Unable to retreive the results in the allotted time.Refine your search criteria.";
	private static String searchServiceErrorMessage = "Search failed due to system error. Please try again later.";
	private static String programServiceErrorMessage = "Program retrieval failed due to system error. Please try again later.";

	private static String searchServiceDown = "The CRM search service is currently down.Please try again later.";
	private static String programServiceDown = "The CRM program service is currently down.Please try again later.";


	public static String translateStudentServiceException(
			StudentServiceException sse) {
		Integer httpCode = sse.getHttpResponseCode();
		switch (httpCode) {
		case HttpStatus.SC_INTERNAL_SERVER_ERROR:
			return searchServiceErrorMessage;
		case HttpStatus.SC_FORBIDDEN:
			return refineSearchCriteriaMessage;
		case HttpStatus.SC_BAD_REQUEST:
			return searchServiceErrorMessage;
		case HttpStatus.SC_REQUEST_TIMEOUT:
			return timedoutMessage;
		case HttpStatus.SC_SERVICE_UNAVAILABLE:
			return searchServiceDown;
		default:
			return searchServiceErrorMessage;
		}
	}
	
	public static String translateStudentServiceExceptionForPofStudy(
			StudentServiceException sse) {
		Integer httpCode = sse.getHttpResponseCode();
		switch (httpCode) {
		case 500:
			return (programServiceErrorMessage);
		case 400:
			return (programServiceErrorMessage);
		case 408:
			return (programServiceDown);
		default:
			return (programServiceErrorMessage);
		}
	}

}
