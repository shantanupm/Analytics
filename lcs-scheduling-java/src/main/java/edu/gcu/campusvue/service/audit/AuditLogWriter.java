package edu.gcu.campusvue.service.audit;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.RejectedExecutionHandler;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.thoughtworks.xstream.XStream;

 
import edu.gcu.campusvue.service.CVueServiceActivityLog;

/**
 * Asynchronously writes the logs from the service to a file/DB. The maximum
 * limit in the inMemory queue is 10000 service logs. It is non blocking
 * in-memory queue so will start discarding the logs once the queue reaches
 * 10000.
 * 
 */
@Component
public class AuditLogWriter {
	
	@Autowired
	private CvueServiceAuditDAO auditingDAO;
	
	private final ThreadPoolExecutor svc;
	private int MAX_SIZE_OF_QUEUE = 10000;
	private final BlockingQueue<Runnable> AUDIT_QUEUE = new LinkedBlockingQueue<Runnable>(
			MAX_SIZE_OF_QUEUE);
	private int DEFAULT_MIN_WORKER_THREADS = 5;
	private int DEFAULT_MAX_WORKER_THREADS = 10;
	private long DEFAULT_THREAD_INACTIVITY_PERIOD = 300;
	final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	public AuditLogWriter() {
		this.svc = new ThreadPoolExecutor(DEFAULT_MIN_WORKER_THREADS,
				DEFAULT_MAX_WORKER_THREADS, DEFAULT_THREAD_INACTIVITY_PERIOD,
				TimeUnit.SECONDS, AUDIT_QUEUE, new Reject());
	}

	public void process(CVueServiceActivityLog log) {
		svc.execute(new AuditWriter(log,auditingDAO));
	}

	void shutdown() {
		svc.shutdown();
	}

	public int getActiveWorkers() {
		return svc.getActiveCount();
	}

	public int getWorkerPoolSize() {
		return svc.getCorePoolSize();
	}

	public int getMaxWorkerPoolSize() {
		return svc.getMaximumPoolSize();
	}

	public long getLogsProcessedCount() {
		return svc.getCompletedTaskCount();
	}

	public int getWorkerInactivityTimeout() {
		return (int) svc.getKeepAliveTime(TimeUnit.SECONDS);
	}

	public int getLargestHistoricalPoolSize() {
		return svc.getLargestPoolSize();
	}

	public void setWorkerPoolSize(int newSize) {
		svc.setCorePoolSize(newSize);
	}

	public void setWorkerInactivityTimeout(int newTimeout) {
		svc.setKeepAliveTime(newTimeout, TimeUnit.SECONDS);
	}

	public void setMaxWorkerPoolSize(int newSize) {
		svc.setMaximumPoolSize(newSize);
	}

	public int getQueueElementCount() {
		return AUDIT_QUEUE.size();
	}

	public int getQueueRemainingCapacity() {
		return AUDIT_QUEUE.remainingCapacity();
	}

	public int getQueueSize() {
		int rv;
		long size = getQueueElementCount() + getQueueRemainingCapacity();
		rv = (size > Integer.MAX_VALUE) ? Integer.MAX_VALUE : (int) size;
		return rv;
	}

	private class AuditWriter implements Runnable {
		private final CVueServiceActivityLog activityLog;
		private CvueServiceAuditDAO cvueServiceAuditDAO;
		private final XStream xstream = new XStream();
		
		public AuditWriter(CVueServiceActivityLog activityLog,CvueServiceAuditDAO cvueServiceAuditDAO) {
			this.activityLog = activityLog;
			this.cvueServiceAuditDAO = cvueServiceAuditDAO;
			xstream.alias("activityLog", CVueServiceActivityLog.class);
 		}

		public void run() {		
 		   // String log = xstream.toXML(serviceLog);
           // logger.info("Summary Log=" + log);
//            ServiceLogModel serviceLogModel = new ServiceLogModel();
//            serviceLogModel.setTxnid(serviceLog.getTransactionId());
//            serviceLogModel.setXmlCL(log);            
//            serviceLogModel.setServiceStatus(serviceLog.getServiceStatus());
//            serviceLogModel.setServiceRequest(serviceLog.getServiceRequest());
//            serviceLogModel.setServiceResponse(serviceLog.getServiceResponse());
//            serviceLogModel.setIpAddress(serviceLog.getIpAddress());
//            serviceLogModel.setServerName(serviceLogModel.getServerName());
//            long timeTakeInMillis =  serviceLog.getEndTimeInMillis() - serviceLog.getStartTimeInMillis();
//            serviceLogModel.setTimeTakenInMillis(timeTakeInMillis);
            cvueServiceAuditDAO.insert(activityLog);
		}
	}

	private class Reject implements RejectedExecutionHandler {
		public void rejectedExecution(Runnable r, ThreadPoolExecutor executor) {
 			logger.error("In memory queue is full so discarding the service logs!!! **");
		}
	}

	
}
