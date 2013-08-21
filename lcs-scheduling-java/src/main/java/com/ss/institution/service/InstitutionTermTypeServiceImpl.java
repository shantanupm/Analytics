package com.ss.institution.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ss.common.util.CustomUUIDGenerator;
import com.ss.common.util.ObjectXMLConversion;
import com.ss.evaluation.value.Country;
import com.ss.institution.dao.InstitutionMirrorMgmtDao;
import com.ss.institution.dao.InstitutionTermTypeDao;
import com.ss.institution.value.AccreditingBody;
import com.ss.institution.value.AccreditingBodyInstitute;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionMirror;
import com.ss.institution.value.InstitutionTermType;
import com.ss.institution.value.InstitutionTranscriptKey;
import com.ss.institution.value.InstitutionType;
import com.ss.institution.value.TermType;

@Service
public class InstitutionTermTypeServiceImpl implements
		InstitutionTermTypeService {

	@Autowired
	InstitutionTermTypeDao institutionTermTypeDao;
	
	@Autowired
	InstitutionMirrorMgmtDao institutionMirrorMgmtDao;
	
	@Override
	public void addInstitutionTermType(InstitutionTermType institutionTermType) {
		institutionTermTypeDao.addInstitutionTermType(institutionTermType);
		
	}

	@Override
	public List<InstitutionTermType> getAllInstitutionTermType(String institutionId) {
	
		return institutionTermTypeDao.getAllInstitutionTermType(institutionId);
	}

	@Override
	public InstitutionTermType getInstitutionTermType(String institutionTermTypeId){
	
		return institutionTermTypeDao.findById(institutionTermTypeId);
	}

	@Override
	public List<TermType> getAllTermType() {
		
		return institutionTermTypeDao.getAllTermType();
	}

	@Override
	public List<InstitutionType> getAllInstitutionType() {
		
		return institutionTermTypeDao.getAllInstitutionType();
	}
	
	@Override
	public List<Country> getAllCountry() {
		
		return institutionTermTypeDao.getAllCountry();
	}

	@Override
	public List<InstitutionTermType> getInstitutionTermTypeList(
			String institutionMirrorId) {
		InstitutionMirror im = institutionMirrorMgmtDao.findById(institutionMirrorId);
		Institution institution = (Institution)ObjectXMLConversion.decodeXMLToObject(im.getInstitutionDetails());
		return institution.getInstitutionTermTypes();
	}

	@Override
	public InstitutionTermType getInstitutionTermTypeByInititutionMirrorId(
			String institutionMirrorId, String institutionTermTypeId) {
		List<InstitutionTermType> ittList = getInstitutionTermTypeList(institutionMirrorId);
		for(InstitutionTermType itt : ittList){
			if((itt.getId()).equals(institutionTermTypeId)){
				return itt;
			}
		}
		return null;
	}

	@Override
	public void addInstitutionTermTypeToMirror(String institutionMirrorId,
			InstitutionTermType itt) {
		InstitutionMirror im = institutionMirrorMgmtDao.findById(institutionMirrorId);
		Institution institution = (Institution)ObjectXMLConversion.decodeXMLToObject(im.getInstitutionDetails());
		
		itt.setInstituteId(institution.getId());
		List<InstitutionTermType> institutionTermTypes = institution.getInstitutionTermTypes();
		InstitutionTermType ittOld = null;
		if(itt.getId()!=null && !itt.getId().isEmpty()){
			for(InstitutionTermType ittInst : institutionTermTypes){
				if(ittInst.getId().equalsIgnoreCase(itt.getId())){
					ittOld = ittInst;
					break;
				}
			}
			institutionTermTypes.remove(ittOld);
		}
		else{
			itt.setId(CustomUUIDGenerator.generateId());
		}
		institutionTermTypes.add(itt);
		
		im.setInstitutionDetails(ObjectXMLConversion.encodeObjectToXML(institution));
		institutionMirrorMgmtDao.saveInstitutionMirror(im);	
	}

	@Override
	public void effectiveTermType(String institutionId,String termTypeId) {
		institutionTermTypeDao.effectiveTermType(institutionId,termTypeId);
	}
	
	@Override
	public void effectiveTermTypeMirror(String institutionMirrorId,String transcriptKeyId) {
		
		InstitutionMirror im = institutionMirrorMgmtDao.findById(institutionMirrorId);
		Institution institution = (Institution)ObjectXMLConversion.decodeXMLToObject(im.getInstitutionDetails());
		for(InstitutionTermType itt:institution.getInstitutionTermTypes()){
			if(itt.getId().equals(transcriptKeyId)){
				itt.setEffective(true);
			}else{
				itt.setEffective(false);
			}
		}
		im.setInstitutionDetails(ObjectXMLConversion.encodeObjectToXML(institution));
		institutionMirrorMgmtDao.saveInstitutionMirror(im);
	}

	@Override
	public Country getCountryById(String countryId) {
		// TODO Auto-generated method stub
		return institutionTermTypeDao.findCountryById(countryId);
	}
	
	@Override
	public void addInstitutionTermTypeList(List<InstitutionTermType> iTermTypeList,String institutionId) {
		institutionTermTypeDao.addInstitutionTermTypeList(iTermTypeList, institutionId);
	}
	@Override
	public InstitutionTermType getEffectiveInstitutionTermTypeByInititutionId(
			String institutionId) {
		// TODO Auto-generated method stub
		return institutionTermTypeDao.findEffectiveInstitutionTermTypeByInititutionId(institutionId);
	}
	@Override
	public InstitutionTermType getCurrentlyEffectiveInstitutionTermType(Date compareDate,
			String institutionId) {
		return institutionTermTypeDao.findCurrentlyEffectiveInstitutionTermType(compareDate,institutionId);
	}
}
