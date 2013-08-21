package com.ss.messaging.processor;

public class TCourseCounter {
	
	private int ecud =0;
	private int ecld = 0;
	private int ctld = 0;
	private int ctud =0;
	private int gald = 0;
	private int gaud =0;
	private int elld =0;
	private int elud=0;
	
	
	 public String getCounterValue(String dbId) {
		 int type = Integer.parseInt(dbId);
		 switch(type) {
		 case 1:
			    ecld++;
			    return generateSuffix(ecld);
		 case 2:
			    ecud++;
			    return generateSuffix(ecud);
		 case 10:
			    ctld++;
			    return generateSuffix(ctld);
		 case 11:
			    ctud++;
			    return generateSuffix(ctud);
		 case 12:
			    gald++;
			    return generateSuffix(gald);
		 case 13:
			    gaud++;
			    return generateSuffix(gaud);
		 case 14:
			    elld++;
			    return generateSuffix(elld);
		 case 15:
			    elud++;
			    return generateSuffix(elud);
	      default:
	    	    return generateSuffix(0);
		 }
	 }
	 
	 private String generateSuffix(int counter) {
		 StringBuffer buffer = new StringBuffer();
		 String count = String.valueOf(counter);
		 if(count.length()==1) {
			 buffer.append("0");
		 }
		 buffer.append(counter);
		 buffer.append("T");
		 return buffer.toString();
	 }
}
