package edu.gcu.campusvue.service.interceptor;

import java.io.StringWriter;
import java.util.UUID;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.stream.StreamResult;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ws.WebServiceMessage;
import org.springframework.ws.client.WebServiceClientException;
import org.springframework.ws.client.support.interceptor.ClientInterceptor;
import org.springframework.ws.context.MessageContext;
import org.springframework.ws.soap.SoapMessage;
import org.springframework.xml.transform.TransformerObjectSupport;

import com.ss.common.logging.CvueServiceContext;

import edu.gcu.campusvue.service.CVueServiceActivityLog;
import edu.gcu.campusvue.service.audit.AuditLogWriter;

public class ClientLoggingInterceptor extends TransformerObjectSupport
		implements ClientInterceptor {

	final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Autowired
	private AuditLogWriter auditLogWriter;

	@Override
	public boolean handleRequest(MessageContext messageContext)
			throws WebServiceClientException {
		try {
 			CVueServiceActivityLog activityLog = CvueServiceContext
					.getCampusVueServiceActivityLog();
			activityLog
					.setServiceRequest(logMessageSource(getSource(messageContext
							.getRequest())));
			CvueServiceContext.setRequestIdInContext(UUID.randomUUID()
					.toString());
			logMessageSource(getSource(messageContext.getRequest()));
		} catch (Exception e) {
			logger.error("Exception Ocurred while logging", e);
		}
		return true;
	}

	@Override
	public boolean handleResponse(MessageContext messageContext)
			throws WebServiceClientException {
		try {
			CVueServiceActivityLog activityLog = CvueServiceContext
					.getCampusVueServiceActivityLog();
			activityLog
					.setServiceResponse(logMessageSource(getSource(messageContext
							.getResponse())));
			CvueServiceContext.setRequestIdInContext(UUID.randomUUID()
					.toString());
			logMessageSource(getSource(messageContext.getResponse()));
			activityLog.setEndTimeInMillis(System.currentTimeMillis());
			auditLogWriter.process(activityLog);
			CvueServiceContext.close();
		} catch (Exception e) {
			logger.error("Exception Ocurred while logging", e);
		}
		return true;
	}

	@Override
	public boolean handleFault(MessageContext messageContext)
			throws WebServiceClientException {
		CVueServiceActivityLog activityLog = CvueServiceContext
				.getCampusVueServiceActivityLog();
		activityLog.setServiceRequest(logMessageSource(getSource(messageContext
				.getResponse())));
		CvueServiceContext.setRequestIdInContext(UUID.randomUUID().toString());
		logMessageSource(getSource(messageContext.getResponse()));
		activityLog.setCallStatus(false);
		activityLog.setEndTimeInMillis(System.currentTimeMillis());
		auditLogWriter.process(activityLog);
		CvueServiceContext.close();
		return true;
	}

	private Transformer createNonIndentingTransformer()
			throws TransformerConfigurationException {
		Transformer transformer = createTransformer();
		transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
		transformer.setOutputProperty(OutputKeys.INDENT, "no");
		return transformer;
	}

	protected String logMessageSource(Source source) {
		try {
			if (source != null) {
				Transformer transformer = createNonIndentingTransformer();
				StringWriter writer = new StringWriter();
				transformer.transform(source, new StreamResult(writer));
	            logMessage(writer.toString());
				return writer.toString();
			}
		} catch (Exception exec) {
			logger.error("Error Occurred while retrieving the message Source",
					exec);
		}
		return "";
	}

	/**
	 * Logs the given string message.
	 * <p/>
	 * By default, this method uses a "debug" level of logging. Subclasses can
	 * override this method to change the level of logging used by the logger.
	 * 
	 * @param message
	 *            the message
	 */
	protected void logMessage(String message) {
		logger.debug(message);
	}

	protected Source getSource(WebServiceMessage message) {
		if (message instanceof SoapMessage) {
			SoapMessage soapMessage = (SoapMessage) message;
			return soapMessage.getEnvelope().getSource();
		} else {
			return null;
		}
	}

	/**
	 * @return the auditLogWriter
	 */
	public AuditLogWriter getAuditLogWriter() {
		return auditLogWriter;
	}

	/**
	 * @param auditLogWriter
	 *            the auditLogWriter to set
	 */
	public void setAuditLogWriter(AuditLogWriter auditLogWriter) {
		this.auditLogWriter = auditLogWriter;
	}

}
