package com.ss.evaluation.service.client;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.client.ClientHttpResponse;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.ResponseErrorHandler;
import org.springframework.web.client.RestClientException;

import com.ss.evaluation.service.StudentServiceException;

/**
 * Copied the code from defaultResponseErrorHandler and modified for customized
 * error handling
 * 
 */
public class RestServiceErrorHandler implements ResponseErrorHandler {

	/** The logger. */
	protected Log logger = LogFactory.getLog(this.getClass());

	/**
	 * Delegates to {@link #hasError(HttpStatus)} with the response status code.
	 */
	@Override
	public boolean hasError(ClientHttpResponse response) throws IOException {
		return hasError(response.getStatusCode());
	}

	/**
	 * Template method called from {@link #hasError(ClientHttpResponse)}.
	 * <p>
	 * The default implementation checks if the given status code is
	 * {@link org.springframework.http.HttpStatus.Series#CLIENT_ERROR
	 * CLIENT_ERROR} or
	 * {@link org.springframework.http.HttpStatus.Series#SERVER_ERROR
	 * SERVER_ERROR}. Can be overridden in subclasses.
	 * 
	 * @param statusCode
	 *            the HTTP status code
	 * @return <code>true</code> if the response has an error;
	 *         <code>false</code> otherwise
	 */
	protected boolean hasError(HttpStatus statusCode) {
		return (statusCode.series() == HttpStatus.Series.CLIENT_ERROR || statusCode
				.series() == HttpStatus.Series.SERVER_ERROR);
	}

	/**
	 * {@inheritDoc}
	 * <p>
	 * The default implementation throws a {@link HttpClientErrorException} if
	 * the response status code is
	 * {@link org.springframework.http.HttpStatus.Series#CLIENT_ERROR}, a
	 * {@link HttpServerErrorException} if it is
	 * {@link org.springframework.http.HttpStatus.Series#SERVER_ERROR}, and a
	 * {@link RestClientException} in other cases.
	 */
	@Override
	public void handleError(ClientHttpResponse response) throws IOException {
		HttpStatus statusCode = response.getStatusCode();
		String errorResponse = getErrorResponseFromBody(response);
	    StudentServiceException serviceException = new StudentServiceException();
	    serviceException.setHttpResponseCode(statusCode.value());
		serviceException.setTransactionId("");
		serviceException.setErrorMessage(errorResponse);
		throw serviceException;
	}

	/**
	 * @param response
	 * @throws IOException
	 */
	private String getErrorResponseFromBody(ClientHttpResponse response)
			throws IOException {
		StringBuilder outBuilder = new StringBuilder();
		try {
			BufferedReader in = new BufferedReader(new InputStreamReader(
					response.getBody()));
			String line;
			while ((line = in.readLine()) != null) {
				outBuilder.append(line);
			}
			in.close();
		} catch (Exception e) {
		}
		logger.info("********************************");
		logger.info("*** Response Body : " + outBuilder.toString());
		logger.info("********************************");

		return outBuilder.toString();
	}

}