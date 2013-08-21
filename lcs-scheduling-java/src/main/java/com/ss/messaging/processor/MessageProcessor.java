package com.ss.messaging.processor;

import javax.jms.Message;

public interface MessageProcessor {

	public void process(Message message) throws Exception;

}
