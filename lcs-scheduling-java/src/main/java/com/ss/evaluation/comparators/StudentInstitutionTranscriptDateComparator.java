package com.ss.evaluation.comparators;

import java.util.Comparator;

import com.ss.evaluation.value.StudentInstitutionTranscript;

public class StudentInstitutionTranscriptDateComparator implements Comparator<StudentInstitutionTranscript> {

	@Override
	public int compare(StudentInstitutionTranscript sit1,
			StudentInstitutionTranscript sit2) {
		return sit1.getModifiedDate().compareTo(sit2.getModifiedDate());
	}

}
