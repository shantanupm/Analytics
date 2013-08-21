package com.ss.messaging.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jms.core.JmsTemplate;
import org.springframework.stereotype.Service;

import com.ss.course.value.TransferCourse;
import com.ss.evaluation.dto.TranscriptTransferCreditsDTO;
import com.ss.evaluation.value.StudentInstitutionTranscript;
import com.ss.institution.value.Institution;
import com.ss.messaging.InstitutionMessageCreator;
import com.ss.messaging.TranscriptCreditsMessageCreator;
import com.ss.messaging.TransferCourseMessageCreator;

@Service("jmsMessageSenderService")
public class JMSMessageSenderService {

	@Autowired
	private JmsTemplate jmsTemplate;

	/**
	 * Puts a message in the JMS queue with transferCourseId.This method needs
	 * to be invoked when the tranferCourse needs to be created or updated in
	 * CampusVue
	 * 
	 * @param transferCourse
	 */
	public void sendTransferCourseMessage(TransferCourse transferCourse) {
		jmsTemplate.setDeliveryPersistent(true);
		TransferCourseMessageCreator messageCreator = new TransferCourseMessageCreator(transferCourse);
		jmsTemplate.send("SendToCampusVue",messageCreator);
	}

	/**
	 * Puts a message in the JMS queue with institutionId.This method needs to
	 * be invoked when an Institution needs to be created or updated in
	 * CampusVue
	 * 
	 * @param institution
	 * @param messageType
	 */
	public void sendCreateOrUpdateInstitutionEvent(Institution institution) {
		jmsTemplate.setDeliveryPersistent(true);
		InstitutionMessageCreator messageCreator = new InstitutionMessageCreator(institution);
		jmsTemplate.send("SendToCampusVue", messageCreator);
	}
	
	/**
	 * Puts a message in the JMS queue with TranscriptTransferCreditsDTO object
	 * @param transcriptTransferCredits
	 */
	public void sendTransferCreditsToCampusVue(TranscriptTransferCreditsDTO transcriptTransferCredits) {
		jmsTemplate.setDeliveryPersistent(true);
		TranscriptCreditsMessageCreator messageCreator = new TranscriptCreditsMessageCreator(transcriptTransferCredits);
		jmsTemplate.send("SendToCampusVue", messageCreator);
	}

	public JmsTemplate getTemplate() {
		return jmsTemplate;
	}

	public void setTemplate(JmsTemplate template) {
		this.jmsTemplate = template;
	}

}
