package com.ss.messaging;

import javax.jms.DeliveryMode;
import javax.jms.JMSException;
import javax.jms.MapMessage;
import javax.jms.Message;
import javax.jms.Session;

import org.springframework.jms.core.MessageCreator;

import com.ss.common.logging.RequestContext;
import com.ss.course.value.TransferCourse;

public class TransferCourseMessageCreator implements MessageCreator {

	private TransferCourse transferCourse;

	public TransferCourseMessageCreator(TransferCourse transferCourse) {
		super();
		this.transferCourse = transferCourse;
	}

	public Message createMessage(Session session) throws JMSException {
		MapMessage message = session.createMapMessage();
		message.setString("transferCourseId", transferCourse.getId());
		message.setStringProperty("transferCourseId", transferCourse.getId());
		message.setStringProperty("messageType", "TRANSFERCOURSE");
		message.setStringProperty("requestContextId", RequestContext.getRequestIdFromContext());
		message.setJMSDeliveryMode(DeliveryMode.PERSISTENT);
		message.setJMSCorrelationID(transferCourse.getId());
		return message;
	}

}
