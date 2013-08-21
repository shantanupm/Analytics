package com.ss.institution.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ss.common.util.CustomUUIDGenerator;
import com.ss.common.util.ObjectXMLConversion;
import com.ss.institution.dao.InstitutionMirrorMgmtDao;
import com.ss.institution.dao.InstitutionTranscriptKeyDao;
import com.ss.institution.value.AccreditingBodyInstitute;
import com.ss.institution.value.ArticulationAgreement;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionMirror;
import com.ss.institution.value.InstitutionTranscriptKey;
import com.ss.institution.value.InstitutionTranscriptKey;
import com.ss.institution.value.GcuCourseLevel;
import com.ss.institution.value.InstitutionTranscriptKeyGrade;
import com.ss.institution.value.TransferCourseInstitutionTranscriptKeyGradeAssoc;

@Service
public class InstitutionTranscriptKeyServiceImpl implements
		InstitutionTranscriptKeyService {

	@Autowired
	InstitutionTranscriptKeyDao institutionTranscriptKeyDao;
	
	@Autowired
	InstitutionMirrorMgmtDao institutionMirrorMgmtDao;
	
	@Override
	@Transactional( propagation=Propagation.REQUIRED, readOnly=false, rollbackForClassName={"java.lang.Exception"} )
	public void addInstitutionTranscriptKey(InstitutionTranscriptKey institutionTranscriptKey) {
		institutionTranscriptKeyDao.addInstitutionTranscriptKey(institutionTranscriptKey);
		
	}

	@Override
	public List<InstitutionTranscriptKey> getAllInstitutionTranscriptKey(String institutionId) {
	
		return institutionTranscriptKeyDao.getAllInstitutionTranscriptKey(institutionId);
	}

	@Override
	public InstitutionTranscriptKey getInstitutionTranscriptKey(String institutionTranscriptKeyId){
		InstitutionTranscriptKey institutionTranscriptKey=institutionTranscriptKeyDao.findById(institutionTranscriptKeyId);
		institutionTranscriptKey.setInstitutionTranscriptKeyDetailsList( 
			institutionTranscriptKeyDao.getInstitutionTranscriptKeyDetailsList(institutionTranscriptKey.getId()));
		return institutionTranscriptKey;
	}

	@Override
	public List<GcuCourseLevel> getAllGcuCourseLevel() {
		
		return institutionTranscriptKeyDao.getAllGcuCourseLevel();
	}

	@Override
	public List<InstitutionTranscriptKey> getInstitutionTranscriptKeyList(
			String institutionMirrorId) {
		InstitutionMirror im = institutionMirrorMgmtDao.findById(institutionMirrorId);
		Institution institution = (Institution)ObjectXMLConversion.decodeXMLToObject(im.getInstitutionDetails());
		return institution.getInstitutionTranscriptKeys();
	}

	@Override
	public InstitutionTranscriptKey getInstitutionTranscriptKeyByInititutionMirrorId(
			String institutionMirrorId, String institutionTranscriptKeyId) {
		List<InstitutionTranscriptKey> itkList = getInstitutionTranscriptKeyList(institutionMirrorId);
		for(InstitutionTranscriptKey itk : itkList){
			if((itk.getId()).equals(institutionTranscriptKeyId)){
				return itk;
			}
		}
		return null;
	}

	@Override
	public void addInstitutionTranscriptKeyToMirror(String institutionMirrorId,
			InstitutionTranscriptKey itk) {
		InstitutionMirror im = institutionMirrorMgmtDao.findById(institutionMirrorId);
		Institution institution = (Institution)ObjectXMLConversion.decodeXMLToObject(im.getInstitutionDetails());
		
		itk.setInstitutionId(institution.getId());
		List<InstitutionTranscriptKey> institutionTranscriptKeys = institution.getInstitutionTranscriptKeys();
		InstitutionTranscriptKey itkOld = null;
		if(itk.getId()!=null && !itk.getId().isEmpty()){
			for(InstitutionTranscriptKey itkInst : institutionTranscriptKeys){
				if(itkInst.getId().equalsIgnoreCase(itk.getId())){
					itkOld = itkInst;
					break;
				}
			}
			institutionTranscriptKeys.remove(itkOld);
		}
		else{
			itk.setId(CustomUUIDGenerator.generateId());
		}
		institutionTranscriptKeys.add(itk);
		
		im.setInstitutionDetails(ObjectXMLConversion.encodeObjectToXML(institution));
		institutionMirrorMgmtDao.saveInstitutionMirror(im);	
		
	}

	
	@Override
	public void effectiveTranscriptKey(String institutionId,
			String transcriptKeyId) {
		
		institutionTranscriptKeyDao.effectiveTranscriptKey(institutionId, transcriptKeyId);
	}
	
	@Override
	public void effectiveTranscriptKeyMirror(String institutionMirrorId,String transcriptKeyId) {
		
		InstitutionMirror im = institutionMirrorMgmtDao.findById(institutionMirrorId);
		Institution institution = (Institution)ObjectXMLConversion.decodeXMLToObject(im.getInstitutionDetails());
		for(InstitutionTranscriptKey itk:institution.getInstitutionTranscriptKeys()){
			if(itk.getId().equals(transcriptKeyId)){
				itk.setEffective(true);
			}else{
				itk.setEffective(false);
			}
		}
		im.setInstitutionDetails(ObjectXMLConversion.encodeObjectToXML(institution));
		institutionMirrorMgmtDao.saveInstitutionMirror(im);
	}
	
	@Override
	public	List<InstitutionTranscriptKeyGrade> getInstitutionTranscriptKeyGradeList(String institutionTranscriptKeyId, boolean isNumber){
		return institutionTranscriptKeyDao.getInstitutionTranscriptKeyGradeList(institutionTranscriptKeyId, isNumber);
	}
	@Override
	public List<InstitutionTranscriptKeyGrade> getInstitutionTranscriptKeyGradeListByInstitutionId(
			String institutionId) {
		// TODO Auto-generated method stub
		return institutionTranscriptKeyDao.findInstitutionTranscriptKeyGradeListByInstitutionId(institutionId);
	}
	@Override
	public List<TransferCourseInstitutionTranscriptKeyGradeAssoc> getTransferCourseInstitutionTranscriptKeyGradeList(
			String transferCourseId, String institutionId) {
		// TODO Auto-generated method stub
		return institutionTranscriptKeyDao.findTransferCourseInstitutionTranscriptKeyGradeList(transferCourseId,institutionId);
	}
}
