package com.ss.messaging;

import javax.jms.DeliveryMode;
import javax.jms.JMSException;
import javax.jms.MapMessage;
import javax.jms.Message;
import javax.jms.Session;

import org.springframework.jms.core.MessageCreator;

import com.ss.common.logging.RequestContext;
import com.ss.course.value.TransferCourse;
import com.ss.institution.value.Institution;

public class InstitutionMessageCreator implements MessageCreator {
	private Institution institution;

	public InstitutionMessageCreator(Institution institution) {
		super();
		this.institution = institution;
	}

	public Message createMessage(Session session) throws JMSException {
		MapMessage message = session.createMapMessage();
 		message.setString("institutionId", institution.getId());
 		message.setStringProperty("institutionId", institution.getId());
		message.setStringProperty("messageType", "INSTITUTION");
		message.setStringProperty("requestContextId", RequestContext.getRequestIdFromContext());
		message.setJMSDeliveryMode(DeliveryMode.PERSISTENT);
		message.setJMSCorrelationID(institution.getId());
		return message;
	}

}
