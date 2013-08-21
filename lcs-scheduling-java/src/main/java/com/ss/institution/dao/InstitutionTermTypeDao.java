package com.ss.institution.dao;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import com.ss.common.dao.BaseDAO;
import com.ss.evaluation.value.Country;
import com.ss.institution.value.InstitutionTermType;
import com.ss.institution.value.InstitutionType;
import com.ss.institution.value.TermType;

public interface InstitutionTermTypeDao extends BaseDAO<InstitutionTermType, Serializable> {

	public void addInstitutionTermType(InstitutionTermType institutionTermType);
	public List<InstitutionTermType> getAllInstitutionTermType(String institutionId);
	public List<TermType> getAllTermType();
	public List<InstitutionType> getAllInstitutionType();
	public List<Country> getAllCountry();
	public void effectiveTermType(String institutionId, String termTypeId);
	public Country findCountryById(String countryId);
	public void addInstitutionTermTypeList(List<InstitutionTermType> iTermTypeList,String institutionId) ;
	public InstitutionTermType findEffectiveInstitutionTermTypeByInititutionId(
			String institutionId);
	public InstitutionTermType findCurrentlyEffectiveInstitutionTermType(
			Date compareDate, String institutionId);
}
