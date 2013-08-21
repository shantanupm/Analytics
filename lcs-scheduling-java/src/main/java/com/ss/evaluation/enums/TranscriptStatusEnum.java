package com.ss.evaluation.enums;

/**
 * Enumeration representing the status for a Transcript.
 */
public enum TranscriptStatusEnum {

	DRAFT( "DRAFT" ),
	REJECTED( "REJECTED" ),
	COMPLETED( "COMPLETED" ),
	INCOMPLETE( "INCOMPLETE" ),
	AWAITINGIE("AWAITING IE"),
	AWAITINGSLE("AWAITING SLE"),
	AWAITINGLOPE("AWAITING LOPE"),
	AWAITINGIEM("AWAITING IEM"),
	EVALUATEDLOPE("EVALUATED LOPE"),
	EVALUATEDOFFICIAL("EVALUATED OFFICIAL"),
	NOTEVALUATED("NOT EVALUATED"),
	INPROGRESS("IN PROGRESS"),
	EVALUATED("EVALUATED"),
	PENDINGEVAL("PENDING EVAL"),
	NOTELIGIBLE("NOT ELIGIBLE"),
	ELIGIBLE("ELIGIBLE"), 
	AWAITINGOFFICIAL("AWAITING OFFICIAL"),
	REJECTEDINSTITUTION( "REJECTED INSTITUTION"), 
	TEMP("TEMP"), 
	CONFLICT("CONFLICT"),
	MANAGERROLE("Institution Evaluation Manager"),
	SLEROLE("Student Level Evaluator"),
	LOPESROLE("Lopes Center"),
	ADMINROLE("Administrator"),
	IEROLE("Institution Evaluator"),
	DEOROLE("Data Entry Operator"),
	OFFICIALLYEVALUATED("OFFICIALLY EVALUATED"),
	AWAITINGOFFICIALTRANSCRIPT("AWAITING OFFICIAL TRANSCRIPT");
	private String value;
	
	TranscriptStatusEnum( String value ) {
		this.value = value;
	}
	
	public String getValue() {
    	return this.value;
    }
	
}
