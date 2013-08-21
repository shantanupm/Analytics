package com.ss.tests.util;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;

import com.ss.evaluation.service.model.StudentSearchResponse;
import com.ss.evaluation.service.model.StudentSearchResult;

 

public class JaxbTest {

  private static final String BOOKSTORE_XML = "./bookstore-jaxb.xml";

  public static void main(String[] args) throws JAXBException, IOException {
	  
	  ArrayList<StudentSearchResult> results = new ArrayList<StudentSearchResult>();
	  
	  StudentSearchResponse res = new StudentSearchResponse();
	  //res.setStudent(results);
	  
	  StudentSearchResult s1 = new StudentSearchResult();
	  s1.setCity("Tempe");
	  s1.setCrmId("111");
	  results.add(s1);
	  
	  StudentSearchResult s2 = new StudentSearchResult();
	  s2.setCity("Giblert");
	  s2.setCrmId("2222");
	  results.add(s2);
 
//    // create JAXB context and instantiate marshaller
   JAXBContext context = JAXBContext.newInstance(StudentSearchResponse.class);
    Marshaller m = context.createMarshaller();
    m.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE);

    // Write to System.out
    m.marshal(res, System.out);

    // Write to File
    m.marshal(res, new File("//Users/Avinash//test//results1.xml"));

    // get variables from our xml file, created before
    System.out.println();
    System.out.println("Output from our XML File: ");
    Unmarshaller um = context.createUnmarshaller();
    StudentSearchResponse response = (StudentSearchResponse) um.unmarshal(new FileReader("//Users/Avinash//test//results.xml"));
   // List<StudentSearchResult> list = response.getStudent();
     
     // System.out.println("############## Student result count: "+list.size());
     
  }
} 
