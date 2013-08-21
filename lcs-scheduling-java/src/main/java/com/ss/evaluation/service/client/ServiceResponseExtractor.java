package com.ss.evaluation.service.client;

import java.io.IOException;

import org.springframework.http.ResponseEntity;
import org.springframework.http.client.ClientHttpResponse;
import org.springframework.web.client.HttpMessageConverterExtractor;
import org.springframework.web.client.ResponseExtractor;
import org.springframework.web.client.RestTemplate;

public class ServiceResponseExtractor<T> implements
		ResponseExtractor<ResponseEntity<T>> {

	private final RestTemplate restTemplate;
	private final HttpMessageConverterExtractor<T> delegate;

	public ServiceResponseExtractor(Class<T> responseType,
			RestTemplate restTemplate) {
		this.restTemplate = restTemplate;
		if (responseType != null) {
			this.delegate = new HttpMessageConverterExtractor<T>(responseType,
					restTemplate.getMessageConverters());
		} else {
			this.delegate = null;
		}
	}

	@Override
	public ResponseEntity<T> extractData(ClientHttpResponse response)
			throws IOException {

		if (delegate != null) {
			T body = delegate.extractData(response);
			return new ResponseEntity<T>(body, response.getHeaders(),
					response.getStatusCode());
		} else {
			return new ResponseEntity<T>(response.getHeaders(),
					response.getStatusCode());
		}
	}
}
