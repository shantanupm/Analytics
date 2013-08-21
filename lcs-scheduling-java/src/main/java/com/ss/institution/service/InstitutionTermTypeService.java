package com.ss.institution.service;

import java.util.Date;
import java.util.List;

import com.ss.evaluation.value.Country;
import com.ss.institution.value.InstitutionType;
import com.ss.institution.value.TermType;
import com.ss.institution.value.InstitutionTermType;

public interface InstitutionTermTypeService {

	public void addInstitutionTermType(InstitutionTermType institutionTermType);
	public List<InstitutionTermType> getAllInstitutionTermType(String institutionId);
	public InstitutionTermType getInstitutionTermType(String institutionTermTypeId);
	public List<TermType> getAllTermType();
	public List<InstitutionType> getAllInstitutionType();
	public List<Country> getAllCountry();
	
	public List<InstitutionTermType> getInstitutionTermTypeList(String institutionMirrorId);
	public InstitutionTermType getInstitutionTermTypeByInititutionMirrorId(String institutionMirrorId, String institutionTermTypeId);
	public void addInstitutionTermTypeToMirror(String institutionMirrorId, InstitutionTermType itt);
	public void effectiveTermType(String institutionId, String termTypeId);
	public void effectiveTermTypeMirror(String institutionMirrorId,String transcriptKeyId);
	public Country getCountryById(String countryId);
	public void addInstitutionTermTypeList(List<InstitutionTermType> iTermTypeList,String institutionId);
	public InstitutionTermType getEffectiveInstitutionTermTypeByInititutionId(String institutionId);
	public InstitutionTermType getCurrentlyEffectiveInstitutionTermType(Date compareDate,String institutionId);
}
