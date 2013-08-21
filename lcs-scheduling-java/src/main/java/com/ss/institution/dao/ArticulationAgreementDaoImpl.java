package com.ss.institution.dao;

import java.io.Serializable;
import java.util.List;
import java.util.ArrayList;



import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.ss.common.dao.BaseAbstractDAO;
import com.ss.common.logging.RequestContext;
import com.ss.course.value.GCUCourseCategory;
import com.ss.institution.value.ArticulationAgreement;
import com.ss.institution.value.ArticulationAgreementDetails;

@Repository
public class ArticulationAgreementDaoImpl extends BaseAbstractDAO<ArticulationAgreement, Serializable>
implements ArticulationAgreementDao {

	private static transient Logger log = LoggerFactory.getLogger(ArticulationAgreementDaoImpl.class);
	

	
	@Override
	
	public void addArticulationAgreement(
			ArticulationAgreement articulationAgreement) {
		try{
			
			getHibernateTemplate().saveOrUpdate(articulationAgreement);
			
			//First Delete All Child AgreementDetails and again Add new one
			List<ArticulationAgreementDetails> listExistingArticulationAgreementDetails = getArticulationAgreementDetailsList(articulationAgreement.getId());
			if( listExistingArticulationAgreementDetails != null && listExistingArticulationAgreementDetails.size() > 0 ) {
				getHibernateTemplate().deleteAll(listExistingArticulationAgreementDetails);
			}
			
			
			for(ArticulationAgreementDetails aAgr:articulationAgreement.getArticulationAgreementDetailsList()){
				if(aAgr.getGcuCourseCategory()!=null ){
					if(!aAgr.getGcuCourseCategory().isEmpty()){
						aAgr.setArticulationAgreement(new ArticulationAgreement());
						aAgr.getArticulationAgreement().setId(articulationAgreement.getId());
						getHibernateTemplate().saveOrUpdate(aAgr);
					}
				}
			}
			}catch (Exception e) {
				log.error( "ArticulationAgreement Addition ---Error"+e.getMessage(),e);
				String uniqueId = RequestContext.getRequestIdFromContext();
				log.error("ArticulationAgreement Addition ---Error."+e+" RequestId:"+uniqueId, e);
			}

	}

	@Override
	public List<ArticulationAgreement> getAllArticulationAgreement(
			String institutionId) {
		
		List<ArticulationAgreement> articulationAgreements=new ArrayList<ArticulationAgreement>();
		articulationAgreements=getHibernateTemplate().find( "from ArticulationAgreement aAgr  where aAgr.instituteId=?  order by modifiedDate desc" ,institutionId);
		List<ArticulationAgreementDetails> articulationAgreementDetailsList;
		for(ArticulationAgreement itk:articulationAgreements){
			articulationAgreementDetailsList=getArticulationAgreementDetailsList(itk.getId());
			itk.setArticulationAgreementDetailsList(articulationAgreementDetailsList);
		}
		return articulationAgreements;
	}

	@Override
	public List<ArticulationAgreementDetails> getArticulationAgreementDetailsList(String articulationAgreementId) {
		return getHibernateTemplate().find( "from ArticulationAgreementDetails aagrkdet  where aagrkdet.articulationAgreement.id=?" ,articulationAgreementId);
	}

	@Override
	public GCUCourseCategory getgGcuCourseCategoryById(String id){
		List<GCUCourseCategory> gcuCourseCategories = getHibernateTemplate().find("from GCUCourseCategory where id=?",id);
		if(gcuCourseCategories != null && gcuCourseCategories.size() != 0){
			return gcuCourseCategories.get(0);
		}
		else {
			return null;
		}
		
	}

	@Override
	public void effectiveArticulationAgreement(String institutionId,String articulationAgreementId) {
		String queryString="UPDATE ArticulationAgreement SET effective = '0' WHERE instituteId=?";
		getHibernateTemplate().bulkUpdate(queryString, institutionId);
		String queryString1="UPDATE ArticulationAgreement SET effective = '1' WHERE id=?";
		getHibernateTemplate().bulkUpdate(queryString1, articulationAgreementId);
		
	}
}
