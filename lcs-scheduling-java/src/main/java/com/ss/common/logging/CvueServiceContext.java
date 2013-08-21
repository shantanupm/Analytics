package com.ss.common.logging;

import edu.gcu.campusvue.service.CVueServiceActivityLog;

public class CvueServiceContext {
	
	private static final ThreadLocal<CvueServiceContext> threadLocal = new ThreadLocal<CvueServiceContext>();
 	private String requestId;
 	private CVueServiceActivityLog activityLog;

	private CvueServiceContext(CVueServiceActivityLog activityLog) {
		this.activityLog = activityLog;
	}

	/**
	 * Creates a context
	 * 
	 */
	public static void create(CVueServiceActivityLog activityLog) {
		if (threadLocal.get() != null) {
			close();
		}
		if(activityLog==null) {
			activityLog = new CVueServiceActivityLog();
		}
 		threadLocal.set(new CvueServiceContext(activityLog));
	}

	/**
	 * Returns the CvueServiceContext for the request from threadLocal if the context is null
	 */
	public static CvueServiceContext get() {
		if (threadLocal.get() == null) {
			create(new CVueServiceActivityLog());
		}
		return threadLocal.get();
	}

	/**
	 * Returns the requestId from RequestContext
	 * 
	 * @return
	 */
	public static String getRequestIdFromContext() {
		CvueServiceContext context = get();
		return context.requestId;
	}
	   
	/**
	 * Returns the CampusVueService ActivtyLog from CampusVueServiceContext
	 * 
	 * @return
	 */
	public static CVueServiceActivityLog getCampusVueServiceActivityLog() {
		CvueServiceContext context = get();
		return context.activityLog;
	}

	/**
	 * Sets the RequestId in the RequestContext
	 * 
 	 */
	public static void setRequestIdInContext(String requestId) {
		CvueServiceContext context = get();
		context.setRequestId(requestId);
	}
	
	/**
	 * Sets the CampusVueServiceActivityLog in the CampusVueServiceContext
	 * 
 	 */
	public void setCampusVueServiceActivityLog(CVueServiceActivityLog cvueActivityLog) {
		CvueServiceContext context = get();
		context.setCampusVueServiceActivityLog(cvueActivityLog);
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

	/**
	 * @return the activityLog
	 */
	public CVueServiceActivityLog getActivityLog() {
		return activityLog;
	}

	/**
	 * @param activityLog the activityLog to set
	 */
	public void setActivityLog(CVueServiceActivityLog activityLog) {
		this.activityLog = activityLog;
	}

}
