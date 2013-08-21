package com.ss.institution.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ss.common.util.CustomUUIDGenerator;
import com.ss.common.util.ObjectXMLConversion;
import com.ss.course.value.TransferCourseTitle;
import com.ss.institution.value.AccreditingBody;
import com.ss.institution.value.AccreditingBodyInstitute;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionMirror;
import com.ss.institution.dao.AccreditingBodyInstituteDao;
import com.ss.institution.dao.InstitutionMirrorMgmtDao;

@Service
public class AccreditingBodyInstituteServiceImpl implements AccreditingBodyInstituteService{

	@Autowired
	AccreditingBodyInstituteDao accreditingBodyDao;
	
	@Autowired
	InstitutionMirrorMgmtDao institutionMirrorMgmtDao;
	
	@Override
	public void addAccreditingBodyInstitute(AccreditingBodyInstitute ab) {
		accreditingBodyDao.addAccreditingBodyInstitute(ab);
		
	}

	@Override
	public List<AccreditingBodyInstitute> getAllAccreditingBodyInstitute(String institutionId) {
		
		return accreditingBodyDao.getAllAccreditingBodyInstitute(institutionId);
	}

	@Override
	public AccreditingBodyInstitute getAccreditingBodyInstitute(String courseMappingId) {
		
		return accreditingBodyDao.findById(courseMappingId);
	}

	@Override
	public List<AccreditingBody> getAllAccreditingBody() {
	
		return accreditingBodyDao.getAllAccreditingBody();
	}

	@Override
	public List<AccreditingBodyInstitute> getAccreditingBodyInstituteList(String institutionMirrorId) {
		
		InstitutionMirror im = institutionMirrorMgmtDao.findById(institutionMirrorId);
		Institution institution = (Institution)ObjectXMLConversion.decodeXMLToObject(im.getInstitutionDetails());
		return institution.getAccreditingBodyInstitutes();
	}

	@Override
	public AccreditingBodyInstitute getAccreditingBodyInstituteByInstitutionMirrorId(
			String institutionMirrorId, String accreditingBodyInstituteId) {
		List<AccreditingBodyInstitute> abiList = getAccreditingBodyInstituteList(institutionMirrorId);
		for(AccreditingBodyInstitute abi : abiList){
			if((abi.getId()).equals(accreditingBodyInstituteId)){
				return abi;
			}
		}
		return null;
	}

	@Override
	public void addAccreditingBodyInstituteToMirror(String institutionMirrorId,
			AccreditingBodyInstitute abi) {
		InstitutionMirror im = institutionMirrorMgmtDao.findById(institutionMirrorId);
		Institution institution = (Institution)ObjectXMLConversion.decodeXMLToObject(im.getInstitutionDetails());
		
		abi.setInstituteId(institution.getId());
		
		List<AccreditingBodyInstitute> accreditingBodyInstitutes=institution.getAccreditingBodyInstitutes();
		AccreditingBodyInstitute abiOld = null;
		if(abi.getId()!=null && !abi.getId().isEmpty()){
			for(AccreditingBodyInstitute abinst:accreditingBodyInstitutes){
				if(abinst.getId().equalsIgnoreCase(abi.getId())){
					abiOld=abinst;
					break;
				}
			
			}
			accreditingBodyInstitutes.remove(abiOld);
		}else{
			abi.setId(CustomUUIDGenerator.generateId());
		}
		accreditingBodyInstitutes.add(abi);
		institution.setAccreditingBodyInstitutes(accreditingBodyInstitutes);
		im.setInstitutionDetails(ObjectXMLConversion.encodeObjectToXML(institution));
		institutionMirrorMgmtDao.saveInstitutionMirror(im);
	}

	@Override
	public void effectiveAccreditingBody(String institutionId,String accreditingBodyId) {
		 accreditingBodyDao.effectiveAccreditingBody(institutionId,accreditingBodyId);
	}
	
	@Override
	public void effectiveAccreditingBodyMirror(String institutionMirrorId,String accreditingBodyId) {
		InstitutionMirror im = institutionMirrorMgmtDao.findById(institutionMirrorId);
		Institution institution = (Institution)ObjectXMLConversion.decodeXMLToObject(im.getInstitutionDetails());
		for(AccreditingBodyInstitute abinst:institution.getAccreditingBodyInstitutes()){
			if(abinst.getId().equals(accreditingBodyId)){
				abinst.setEffective(true);
			}else{
				abinst.setEffective(false);
			}
		}
		im.setInstitutionDetails(ObjectXMLConversion.encodeObjectToXML(institution));
		institutionMirrorMgmtDao.saveInstitutionMirror(im);
	}
	
	@Override
	public void addAccreditingBodyInstituteList(List<AccreditingBodyInstitute> abList,String institutionId) {
		accreditingBodyDao.addAccreditingBodyInstituteList(abList,institutionId);
	}
	
}
