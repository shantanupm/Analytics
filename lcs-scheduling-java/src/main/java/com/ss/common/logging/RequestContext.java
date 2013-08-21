package com.ss.common.logging;

/**
 *RequestContext class maintains a seperate context for every request that gets
 * to the Application.Used for the building the request activity log for the
 * Request as it moves through the Application
 * TODO:  Need to construct a request activity log as the request goes through the application
 * TODO:  Add a userId as a part of this
 * 
 */
public class RequestContext {

	private static final ThreadLocal<RequestContext> threadLocal = new ThreadLocal<RequestContext>();
 	private String requestId;

	private RequestContext() {
 	}

	/**
	 * Creates a context
	 * 
	 */
	public static void create() {
		if (threadLocal.get() != null) {
			close();
		}
		threadLocal.set(new RequestContext());
	}

	/**
	 * Returns the ReuqestContext for the request from threadLocal.Throws
	 * Exception if the context is null
	 */
	public static RequestContext get() {
		if (threadLocal.get() == null) {
			create();
		}
		return threadLocal.get();
	}

	/**
	 * Returns the requestId from RequestContext
	 * 
	 * @return
	 */
	public static String getRequestIdFromContext() {
		RequestContext context = get();
		return context.requestId;
	}

	/**
	 * Sets the RequestId in the RequestContext
	 */
	public static void setRequestIdInContext(String requestId) {
		RequestContext context = get();
		context.setRequestId(requestId);
	}
	
	private void setRequestId(String requestId) {
		this.requestId = requestId;
	}

	/**
	 * Removes the RequestContext
	 */
	public static void close() {
		threadLocal.remove();
	}

}
