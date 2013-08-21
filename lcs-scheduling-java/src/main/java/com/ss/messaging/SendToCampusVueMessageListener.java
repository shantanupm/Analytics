package com.ss.messaging;

import javax.jms.Message;
import javax.jms.MessageListener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.ss.messaging.processor.InstitutionMessageProcessor;
import com.ss.messaging.processor.TranscriptCreditsMessageProcessor;
import com.ss.messaging.processor.TransferCourseMessageProcessor;

public class SendToCampusVueMessageListener implements MessageListener {
	
	 private static final Logger logger = LoggerFactory.getLogger(SendToCampusVueMessageListener.class);
	 @Autowired
     private InstitutionMessageProcessor institutionMessageProcessor;
	 
	 @Autowired
     private TransferCourseMessageProcessor transferCourseMessageProcessor;
	 @Autowired
     private TranscriptCreditsMessageProcessor transcriptCreditsMessageProcessor;
	 
	@Override
	public void onMessage(Message message) {
		logger.debug("Received message: {}", message);
		try {
			String messageType = message.getStringProperty("messageType");
            if(messageType.equalsIgnoreCase("Institution")) {
            	institutionMessageProcessor.process(message);
            }else if(messageType.equalsIgnoreCase("TransferCourse")){
            	transferCourseMessageProcessor.process(message);
            }else if(messageType.equalsIgnoreCase("STUDENT_TRANSFER_CREDITS")){
            	transcriptCreditsMessageProcessor.process(message);
            }
			
		}catch(Exception e) {
			
		  logger.error("Error occurred while processing the message:",e);
		  throw new RuntimeException();
		}
		
		
	}

}
