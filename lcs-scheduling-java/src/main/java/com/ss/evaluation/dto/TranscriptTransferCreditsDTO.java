package com.ss.evaluation.dto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.ss.evaluation.value.StudentInstitutionTranscript;

public class TranscriptTransferCreditsDTO implements Serializable {
	
	private static final long serialVersionUID = 1L;
	private StudentInstitutionTranscript studentInstitutionTranscript;
	private List<StudentTransferCredits> transferCreditsList = new ArrayList<StudentTransferCredits>();
 
	/**
	 * @return the studentInstitutionTranscript
	 */
	public StudentInstitutionTranscript getStudentInstitutionTranscript() {
		return studentInstitutionTranscript;
	}

	/**
	 * @param studentInstitutionTranscript the studentInstitutionTranscript to set
	 */
	public void setStudentInstitutionTranscript(
			StudentInstitutionTranscript studentInstitutionTranscript) {
		this.studentInstitutionTranscript = studentInstitutionTranscript;
	}
	
	/**
	 * Add the studentTransferCredits to the transferCreditsList
	 * @param stc
	 */
	public void addStudentTransfercredits(StudentTransferCredits stc) {
		transferCreditsList.add(stc);
	}

	/**
	 * @return the transferCreditsList
	 */
	public List<StudentTransferCredits> getTransferCreditsList() {
		return transferCreditsList;
	}

	/**
	 * @param transferCreditsList the transferCreditsList to set
	 */
	public void setTransferCreditsList(
			List<StudentTransferCredits> transferCreditsList) {
		this.transferCreditsList = transferCreditsList;
	}

	
	

}
