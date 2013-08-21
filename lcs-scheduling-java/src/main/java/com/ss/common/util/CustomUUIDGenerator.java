package com.ss.common.util;

import java.io.Serializable;
import java.util.UUID;

import org.hibernate.HibernateException;
import org.hibernate.engine.SessionImplementor;
import org.hibernate.id.IdentifierGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CustomUUIDGenerator implements IdentifierGenerator {
	private static final Logger log = LoggerFactory.getLogger(CustomUUIDGenerator.class);

public Serializable generate(SessionImplementor arg0, Object arg1) throws HibernateException {
	return UUID.randomUUID().toString();
}

/* THIS METHOD SHOULD BE USED CAREFULLY. IF you are using Hibernate, than do not call this method directly for generating UUID.
*/
public static String generateId(){
	return UUID.randomUUID().toString();
}

public static void main(String[] args){
	CustomUUIDGenerator cuid = new CustomUUIDGenerator();
	String key = "INST"+UUID.randomUUID().toString();
	log.debug("KEY="+key);
}
}