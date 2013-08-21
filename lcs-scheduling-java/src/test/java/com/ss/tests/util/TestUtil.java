package com.ss.tests.util;

import java.util.List;

import com.ss.evaluation.dto.Address;
import com.ss.evaluation.dto.Demographics;
import com.ss.evaluation.dto.Phone;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionType;

public class TestUtil {

	/**
	 * Returns a specific InstitutionType from a list of InstitutionTypes
	 * 
	 * @param type
	 *            of institution
	 * @param institutionTypes
	 * @return
	 */
	public static InstitutionType getSpecificInstitutionType(
			String typeOfInstitution, List<InstitutionType> institutionTypes) {
		for (InstitutionType instType : institutionTypes) {
			if (typeOfInstitution.equalsIgnoreCase(instType.getName())) {
				return instType;
			}
		}
		return null;
	}

	/**
	 * Returns an Institution Object based on the data that is passed.
	 * 
	 * @return
	 */
	public static Institution returnInstitutionObject(String institutionName,
			InstitutionType instituteType) {
		Institution institution = new Institution();
		institution.setName(institutionName);
		institution.setInstitutionType(instituteType);
		return institution;
	}

}
