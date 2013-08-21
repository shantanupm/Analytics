package com.ss.institution.dao;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ss.common.dao.BaseAbstractDAO;
import com.ss.institution.value.ArticulationAgreementDetails;
import com.ss.institution.value.GcuCourseLevel;
import com.ss.institution.value.InstitutionTranscriptKey;
import com.ss.institution.value.InstitutionTranscriptKeyDetails;
import com.ss.institution.value.InstitutionTranscriptKeyGrade;
import com.ss.institution.value.TransferCourseInstitutionTranscriptKeyGradeAssoc;
import com.ss.common.logging.RequestContext;

@Repository
public class InstitutionTranscriptKeyDaoImpl extends BaseAbstractDAO<InstitutionTranscriptKey, Serializable>   
implements InstitutionTranscriptKeyDao {
	private static transient Logger log = LoggerFactory.getLogger(InstitutionTranscriptKeyDaoImpl.class);
	@Override
	public void addInstitutionTranscriptKey(
			InstitutionTranscriptKey institutionTranscriptKey) {
		try{
		getHibernateTemplate().saveOrUpdate(institutionTranscriptKey);
		//First Delete All Child InstitutionTranscriptKeyDetails and again Add new one
		List<InstitutionTranscriptKeyDetails> listExistingInstitutionTranscriptKeyDetails = getInstitutionTranscriptKeyDetailsList(institutionTranscriptKey.getId());
		if( listExistingInstitutionTranscriptKeyDetails != null && listExistingInstitutionTranscriptKeyDetails.size() > 0 ) {
			getHibernateTemplate().deleteAll(listExistingInstitutionTranscriptKeyDetails);
		}
		
		for(InstitutionTranscriptKeyDetails iTkd:institutionTranscriptKey.getInstitutionTranscriptKeyDetailsList()){
			if(iTkd.getFrom()!=null ){
				if(!iTkd.getFrom().isEmpty()){
					iTkd.setInstitutionTranscriptKey(new InstitutionTranscriptKey());
					iTkd.getInstitutionTranscriptKey().setId(institutionTranscriptKey.getId());
					getHibernateTemplate().saveOrUpdate(iTkd);
				}
			}
		}
		
		List<InstitutionTranscriptKeyGrade> listExistingInstitutionTranscriptKeyGrade = getInstitutionTranscriptKeyGradeList(institutionTranscriptKey.getId());
		
		/*if( listExistingInstitutionTranscriptKeyGrade != null && listExistingInstitutionTranscriptKeyGrade.size() > 0 ) {
			getHibernateTemplate().deleteAll(listExistingInstitutionTranscriptKeyGrade);
		}-*/
		Map<String,InstitutionTranscriptKeyGrade> itGrdMap= new HashMap<String,InstitutionTranscriptKeyGrade>();
		for(InstitutionTranscriptKeyGrade iTkGrdExist:listExistingInstitutionTranscriptKeyGrade){
			
			itGrdMap.put(iTkGrdExist.getId(),iTkGrdExist);
		}
		
		
		
		for(InstitutionTranscriptKeyGrade iTkGrd:institutionTranscriptKey.getInstitutionTranscriptKeyGradeList()){
			if((iTkGrd.getGradeFrom()!=null && iTkGrd.getGradeTo()!=null)  ){
				if((!iTkGrd.getGradeFrom().isEmpty() && !iTkGrd.getGradeTo().isEmpty()) ){
					iTkGrd.setInstitutionTranscriptKey(new InstitutionTranscriptKey());
					iTkGrd.getInstitutionTranscriptKey().setId(institutionTranscriptKey.getId());
					getHibernateTemplate().merge(iTkGrd);
				}
			}
			if(iTkGrd.getGradeAlpha()!=null && !iTkGrd.getGradeAlpha().isEmpty()){
				iTkGrd.setInstitutionTranscriptKey(new InstitutionTranscriptKey());
				iTkGrd.getInstitutionTranscriptKey().setId(institutionTranscriptKey.getId());
				getHibernateTemplate().merge(iTkGrd);
			}
			if(iTkGrd.getId()!=null && !iTkGrd.getId().isEmpty()){
				if(itGrdMap.containsKey(iTkGrd.getId())){
					itGrdMap.remove(iTkGrd.getId());
				}
				
			}
		}
		
		
		if(itGrdMap.size()>0){
			getHibernateTemplate().deleteAll(itGrdMap.values());
		}
		
		}catch (Exception e) {
			//log.error( "TranscripKEy Addition ---Error"+e.getMessage(),e);
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("TranscripKEy Addition ---Error."+e+" RequestId:"+uniqueId, e);
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<InstitutionTranscriptKey> getAllInstitutionTranscriptKey(
			String institutionId) {
		List<InstitutionTranscriptKey> institutionTranscriptKeys=getHibernateTemplate().find( "from InstitutionTranscriptKey itk  where itk.institutionId=?  order by modifiedDate  desc" ,institutionId);
		List<InstitutionTranscriptKeyDetails> institutionTranscriptKeyDetailsList;
		for(InstitutionTranscriptKey itk:institutionTranscriptKeys){
			institutionTranscriptKeyDetailsList=getInstitutionTranscriptKeyDetailsList(itk.getId());
			itk.setInstitutionTranscriptKeyDetailsList(institutionTranscriptKeyDetailsList);
			itk.setInstitutionTranscriptKeyGradeList(getInstitutionTranscriptKeyGradeList(itk.getId()));
			itk.setInstitutionTranscriptKeyGradeAlphaList(getInstitutionTranscriptKeyGradeList(itk.getId(), false));
			itk.setInstitutionTranscriptKeyGradeNumberList(getInstitutionTranscriptKeyGradeList(itk.getId(), true));
			
		
		}
		return institutionTranscriptKeys;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GcuCourseLevel> getAllGcuCourseLevel() {
		return getHibernateTemplate().find( "from GcuCourseLevel gcuCourseLevel order by name");
	}
	
	@Override
	public	List<InstitutionTranscriptKeyDetails> getInstitutionTranscriptKeyDetailsList(String institutionTranscriptKeyId){
		return getHibernateTemplate().find( "from InstitutionTranscriptKeyDetails itkdet  where itkdet.institutionTranscriptKey.id=?  order by modifiedDate  desc" ,institutionTranscriptKeyId);
			
	}
	
	@Override
	public	List<InstitutionTranscriptKeyGrade> getInstitutionTranscriptKeyGradeList(String institutionTranscriptKeyId, boolean isNumber){
		return getHibernateTemplate().find( "from InstitutionTranscriptKeyGrade itkGrd  where itkGrd.institutionTranscriptKey.id=? and number=?  order by modifiedDate  desc" ,institutionTranscriptKeyId,isNumber);
			
	}
	
	
	public	List<InstitutionTranscriptKeyGrade> getInstitutionTranscriptKeyGradeList(String institutionTranscriptKeyId ){
		return getHibernateTemplate().find( "from InstitutionTranscriptKeyGrade itkGrd  where itkGrd.institutionTranscriptKey.id=?  order by modifiedDate  desc" ,institutionTranscriptKeyId);
			
	}
	

	@Override
	public void effectiveTranscriptKey(String institutionId,String transcriptKeyId) {
		String queryString="UPDATE InstitutionTranscriptKey SET effective = '0' WHERE institutionId=?";
		getHibernateTemplate().bulkUpdate(queryString, institutionId);
		String queryString1="UPDATE InstitutionTranscriptKey SET effective = '1' WHERE id=?";
		getHibernateTemplate().bulkUpdate(queryString1, transcriptKeyId);
		
	}
	@Override
	public List<InstitutionTranscriptKeyGrade> findInstitutionTranscriptKeyGradeListByInstitutionId(String institutionId) {
		List<InstitutionTranscriptKeyGrade> institutionTranscriptKeyGradeList = new ArrayList<InstitutionTranscriptKeyGrade>();
		try{
			institutionTranscriptKeyGradeList = getHibernateTemplate().find("FROM InstitutionTranscriptKeyGrade WHERE institutionTranscriptKey.id=(SELECT id FROM InstitutionTranscriptKey WHERE institutionId=?)",new Object[]{institutionId});
		}catch (Exception e) {
				//log.error( "TranscripKEy Addition ---Error"+e.getMessage(),e);
				String uniqueId = RequestContext.getRequestIdFromContext();
				log.error("No InstitutionTranscriptKeyGrade found"+e+" RequestId:"+uniqueId, e);
		}
		return institutionTranscriptKeyGradeList;
	}
	@Override
	public List<TransferCourseInstitutionTranscriptKeyGradeAssoc> findTransferCourseInstitutionTranscriptKeyGradeList(
			String transferCourseId, String institutionId) {
		List<TransferCourseInstitutionTranscriptKeyGradeAssoc> institutionTranscriptKeyGradeAssocList = new ArrayList<TransferCourseInstitutionTranscriptKeyGradeAssoc>();
		try{
			institutionTranscriptKeyGradeAssocList = getHibernateTemplate().find("FROM TransferCourseInstitutionTranscriptKeyGradeAssoc WHERE institutionId=? AND transferCourse.id=?",new Object[]{institutionId,transferCourseId});
		}catch (Exception e) {
				//log.error( "TranscripKEy Addition ---Error"+e.getMessage(),e);
				String uniqueId = RequestContext.getRequestIdFromContext();
				log.error("No grade associated with course"+e+" RequestId:"+uniqueId, e);
		}
		return institutionTranscriptKeyGradeAssocList;
	}
}
