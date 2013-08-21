package com.ss.common.util;

import java.beans.XMLDecoder;
import java.beans.XMLEncoder;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ss.common.logging.RequestContext;

public class ObjectXMLConversion {

	private static transient Logger log = LoggerFactory
			.getLogger(ObjectXMLConversion.class);

	public static String encodeObjectToXML(Object object) {
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		XMLEncoder encoder = new XMLEncoder(os);
		encoder.writeObject(object);
		encoder.close();
		String xml = null;
		try {
			xml = os.toString("UTF-8");
		} catch (UnsupportedEncodingException e) {
			log.error(
					"Exception Occurred while serializing object to xml. Request ReferenceId:"
							+ RequestContext.getRequestIdFromContext(), e);
		}
		return xml;
	}

	public static Object decodeXMLToObject(String xml) {
		InputStream is = null;
		try {
			is = new ByteArrayInputStream(xml.getBytes("UTF-8"));
		} catch (Exception exception) {
			log.error(
					"Exception Occurred while deserializing xml to object. Request ReferenceId:"
							+ RequestContext.getRequestIdFromContext(),
					exception);
		}
		XMLDecoder decoder = new XMLDecoder(is);
		return decoder.readObject();
	}
}
