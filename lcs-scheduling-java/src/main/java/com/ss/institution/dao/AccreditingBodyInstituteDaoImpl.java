package com.ss.institution.dao;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ss.common.dao.BaseAbstractDAO;
import com.ss.institution.value.AccreditingBody;
import com.ss.institution.value.AccreditingBodyInstitute;
import com.ss.common.logging.RequestContext;

@Repository
public class AccreditingBodyInstituteDaoImpl extends BaseAbstractDAO<AccreditingBodyInstitute, Serializable> 
implements AccreditingBodyInstituteDao {

	private static transient Logger log = LoggerFactory.getLogger(AccreditingBodyInstituteDaoImpl.class);
	@Override
	public void addAccreditingBodyInstitute(AccreditingBodyInstitute ab) {
		getHibernateTemplate().saveOrUpdate(ab);
	}
	
	@Override
	public List<AccreditingBodyInstitute> getAllAccreditingBodyInstitute(String institutionId) {
		List<AccreditingBodyInstitute> accreditingBodyInstitutes= new ArrayList<AccreditingBodyInstitute>();
		
		accreditingBodyInstitutes= getHibernateTemplate().find( "from AccreditingBodyInstitute where instituteId=? order by modifiedDate  desc", institutionId);
		return accreditingBodyInstitutes;
	}

	@Override
	public List<AccreditingBody> getAllAccreditingBody() {
		return getHibernateTemplate().find( "from AccreditingBody ab order by regional desc,name");
	}
	
	@Override
	public void effectiveAccreditingBody(String institutionId,String accreditingBodyId) {
		String queryString="UPDATE AccreditingBodyInstitute SET effective = '0' WHERE instituteId=?";
		getHibernateTemplate().bulkUpdate(queryString, institutionId);
		String queryString1="UPDATE AccreditingBodyInstitute SET effective = '1' WHERE id=?";
		getHibernateTemplate().bulkUpdate(queryString1, accreditingBodyId);
		
	}
	
	@Override
	public void addAccreditingBodyInstituteList(List<AccreditingBodyInstitute> abList,String institutionId) {
		
		try{
			
			//First Delete All  AccreditingBodyInstitute and again Add new one
			List<AccreditingBodyInstitute> listExistingAccreditingBodyInstitute = getAllAccreditingBodyInstitute(institutionId);
			if( listExistingAccreditingBodyInstitute != null && listExistingAccreditingBodyInstitute.size() > 0 ) {
				getHibernateTemplate().deleteAll(listExistingAccreditingBodyInstitute);
			}
			
			for(AccreditingBodyInstitute abi:abList){
				if(abi.getAccreditingBody()!=null){
					if(abi.getAccreditingBody().getId()!=null&& !abi.getAccreditingBody().getId().isEmpty() && abi.getEffectiveDate()!=null && !abi.getEffectiveDate().isEmpty() ){
							getHibernateTemplate().saveOrUpdate(abi);
						
					}
				}
			}
			}catch (Exception e) {
				//log.error( "TranscripKEy Addition ---Error"+e.getMessage(),e);
				String uniqueId = RequestContext.getRequestIdFromContext();
				log.error("AccreditingBodyInstitute Addition ---Error."+e+" RequestId:"+uniqueId, e);
			}
	}
	
	
	
}
