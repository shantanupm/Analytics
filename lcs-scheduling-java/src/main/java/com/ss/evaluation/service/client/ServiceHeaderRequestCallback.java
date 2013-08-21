package com.ss.evaluation.service.client;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.http.client.ClientHttpRequest;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RequestCallback;
import org.springframework.http.MediaType;

public class ServiceHeaderRequestCallback implements RequestCallback {

	private final List<MediaType> mediaTypes = new ArrayList<MediaType>();
	private String requestBody = null;
	private String requestContentType = "application/xml; charset=utf-8";

	/**
	 * Sets the requestContentType
	 * 
	 * @param requestContentType
	 */
	public void addRequestContentType(String requestContentType) {
		if (requestContentType != null) {
			this.requestContentType = requestContentType;
		}
	}

	@Override
	public void doWithRequest(ClientHttpRequest request) throws IOException {
		addAcceptHeader(request, mediaTypes);
		if (StringUtils.hasText(requestBody)) {
			request.getHeaders().add("Content-Type", requestContentType);
			request.getHeaders().add("Content-Length",
					"" + requestBody.length());
			request.getBody().write(requestBody.getBytes());
		}
	}

	public void addRequestBody(String payload) {
		this.requestBody = payload;
	}

	/**
	 * Adds the passed mediaTypes to the acceptHeaders
	 * 
	 * @param request
	 * @param mediaTypes
	 */
	private void addAcceptHeader(ClientHttpRequest request,
			List<MediaType> mediaTypes) {
		request.getHeaders().setAccept(mediaTypes);
	}

	public void addMediaType(MediaType mediaType) {
		if (mediaType != null) {
			mediaTypes.add(mediaType);
		}
	}

}
