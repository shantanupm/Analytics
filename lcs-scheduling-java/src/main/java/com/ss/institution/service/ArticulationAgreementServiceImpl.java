package com.ss.institution.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ss.common.util.CustomUUIDGenerator;
import com.ss.common.util.ObjectXMLConversion;
import com.ss.course.dao.CourseMgmtDAO;
import com.ss.course.value.CourseCategoryMapping;
import com.ss.course.value.GCUCourseCategory;
import com.ss.institution.dao.ArticulationAgreementDao;
import com.ss.institution.dao.InstitutionMirrorMgmtDao;
import com.ss.institution.value.ArticulationAgreement;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionMirror;
import com.ss.institution.value.InstitutionTermType;

@Service
public class ArticulationAgreementServiceImpl implements ArticulationAgreementService{

	@Autowired
	ArticulationAgreementDao articulationAgreementDao;
	
	@Autowired
	private CourseMgmtDAO  courseMgmtDAO;
	
	@Autowired
	private InstitutionMirrorMgmtDao institutionMirrorMgmtDao;
	
	@Override
	@Transactional( propagation=Propagation.REQUIRED, readOnly=false, rollbackForClassName={"java.lang.Exception"} )
	public void addArticulationAgreement(ArticulationAgreement articulationAgreement) {
		articulationAgreementDao.addArticulationAgreement(articulationAgreement);
		
	}

	@Override
	public List<ArticulationAgreement> getAllArticulationAgreement(String institutionId) {
	
		return articulationAgreementDao.getAllArticulationAgreement(institutionId);
	}

	@Override
	public ArticulationAgreement getArticulationAgreement(String articulationAgreementId){
		ArticulationAgreement articulationAgreement=articulationAgreementDao.findById(articulationAgreementId);
		articulationAgreement.setArticulationAgreementDetailsList( 
			articulationAgreementDao.getArticulationAgreementDetailsList(articulationAgreement.getId()));
		return articulationAgreement;
	}

	@Override
	public List<GCUCourseCategory> getAllGcuCourseCategory() {
		
		return courseMgmtDAO.getAllGCUCourseCategories();
	}

	@Override
	public List<ArticulationAgreement> getArticulationAgreementList(
			String institutionMirrorId) {
		InstitutionMirror im = institutionMirrorMgmtDao.findById(institutionMirrorId);
		Institution institution = (Institution)ObjectXMLConversion.decodeXMLToObject(im.getInstitutionDetails());
		return institution.getArticulationAgreements();
	}

	@Override
	public ArticulationAgreement getArticulationAgreementByInititutionMirrorId(
			String institutionMirrorId, String articulationAgreementId) {
		List<ArticulationAgreement> aaList = getArticulationAgreementList(institutionMirrorId);
		for(ArticulationAgreement aa : aaList){
			if((aa.getId()).equals(articulationAgreementId)){
				return aa;
			}
		}
		return null;
	}

	@Override
	public void addArticulationAgreementToMirror(String institutionMirrorId,
			ArticulationAgreement aa) {
		InstitutionMirror im = institutionMirrorMgmtDao.findById(institutionMirrorId);
		Institution institution = (Institution)ObjectXMLConversion.decodeXMLToObject(im.getInstitutionDetails());
		
		aa.setInstituteId(institution.getId());
		List<ArticulationAgreement> articulationAgreements = institution.getArticulationAgreements();
		ArticulationAgreement aaOld = null;
		if(aa.getId()!=null && !aa.getId().isEmpty()){
			for(ArticulationAgreement aaInst : articulationAgreements){
				if(aaInst.getId().equalsIgnoreCase(aa.getId())){
					aaOld = aaInst;
					break;
				}
			}
			articulationAgreements.remove(aaOld);
		}
		else{
			aa.setId(CustomUUIDGenerator.generateId());
		}
		articulationAgreements.add(aa);
		
		im.setInstitutionDetails(ObjectXMLConversion.encodeObjectToXML(institution));
		institutionMirrorMgmtDao.saveInstitutionMirror(im);
	}

	@Override
	public GCUCourseCategory getgGcuCourseCategoryById(String id){
		return articulationAgreementDao.getgGcuCourseCategoryById(id);
	}
	
	@Override
	public void effectiveArticulationAgreement(String institutionId,String articulationAgreementId) {
		articulationAgreementDao.effectiveArticulationAgreement(institutionId,articulationAgreementId);
	}
	
	@Override
	public void effectiveArticulationAgreementMirror(String institutionMirrorId,String transcriptKeyId) {
		
		InstitutionMirror im = institutionMirrorMgmtDao.findById(institutionMirrorId);
		Institution institution = (Institution)ObjectXMLConversion.decodeXMLToObject(im.getInstitutionDetails());
		for(ArticulationAgreement aa:institution.getArticulationAgreements()){
			if(aa.getId().equals(transcriptKeyId)){
				aa.setEffective(true);
			}else{
				aa.setEffective(false);
			}
		}
		im.setInstitutionDetails(ObjectXMLConversion.encodeObjectToXML(institution));
		institutionMirrorMgmtDao.saveInstitutionMirror(im);
	}
}
