/**
 * 
 */
package com.ss.messaging;

import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.Session;

import org.springframework.jms.core.MessageCreator;

/**
 * @author avinash
 *
 */
public class AbstractTEAmessageCreator implements MessageCreator {

	/* (non-Javadoc)
	 * @see org.springframework.jms.core.MessageCreator#createMessage(javax.jms.Session)
	 */
	@Override
	public Message createMessage(Session session) throws JMSException {
		// TODO Auto-generated method stub
		return null;
	}

}
