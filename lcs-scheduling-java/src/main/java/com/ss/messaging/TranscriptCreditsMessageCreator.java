package com.ss.messaging;

import javax.jms.DeliveryMode;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.ObjectMessage;
import javax.jms.Session;

import org.springframework.jms.core.MessageCreator;

import com.ss.common.logging.RequestContext;
import com.ss.evaluation.dto.TranscriptTransferCreditsDTO;
import com.ss.evaluation.value.StudentInstitutionTranscript;

public class TranscriptCreditsMessageCreator implements MessageCreator {

	private TranscriptTransferCreditsDTO transcriptTransferCreditsDTO;

	public TranscriptCreditsMessageCreator(TranscriptTransferCreditsDTO transcriptTransferCreditsDTO) {
 		this.transcriptTransferCreditsDTO = transcriptTransferCreditsDTO;
	}

	public Message createMessage(Session session) throws JMSException {
		ObjectMessage message = session.createObjectMessage(transcriptTransferCreditsDTO);
		String studentInsitutionTranscriptId =null;
		StudentInstitutionTranscript sit = transcriptTransferCreditsDTO.getStudentInstitutionTranscript();
		if(sit!=null) {
			studentInsitutionTranscriptId = sit.getId();
		}
		message.setStringProperty("studentInstitutionTranscriptId", studentInsitutionTranscriptId);
 		message.setStringProperty("messageType", "STUDENT_TRANSFER_CREDITS");
		message.setStringProperty("requestContextId", RequestContext.getRequestIdFromContext());
		message.setJMSDeliveryMode(DeliveryMode.PERSISTENT);
		message.setJMSCorrelationID(studentInsitutionTranscriptId);
		return message;
	}
	 
}
