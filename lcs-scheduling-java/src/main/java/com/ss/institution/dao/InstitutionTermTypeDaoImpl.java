package com.ss.institution.dao;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Repository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ss.common.dao.BaseAbstractDAO;
import com.ss.evaluation.value.Country;
import com.ss.evaluation.value.StudentInstitutionDegree;
import com.ss.institution.value.InstitutionTermType;
import com.ss.institution.value.InstitutionType;
import com.ss.institution.value.TermType;
import com.ss.common.logging.RequestContext;

@Repository
public class InstitutionTermTypeDaoImpl extends BaseAbstractDAO<InstitutionTermType, Serializable>  
implements InstitutionTermTypeDao {
	
	private static transient Logger log = LoggerFactory.getLogger(InstitutionTermTypeDaoImpl.class);

	@Override
	public void addInstitutionTermType(InstitutionTermType institutionTermType) {
		getHibernateTemplate().saveOrUpdate(institutionTermType);

	}

	@SuppressWarnings("unchecked")
	@Override
	public List<InstitutionTermType> getAllInstitutionTermType(String institutionId) {
		List<InstitutionTermType> institutionTermTypes=new ArrayList<InstitutionTermType>();
		institutionTermTypes=getHibernateTemplate().find( "from InstitutionTermType  where instituteId=?  order by modifiedDate  desc" ,institutionId);
		return institutionTermTypes;
	}

	

	@SuppressWarnings("unchecked")
	@Override
	public List<TermType> getAllTermType() {
		return getHibernateTemplate().find( "from TermType termType order by name");
	}

	@Override
	public List<InstitutionType> getAllInstitutionType() {
		return getHibernateTemplate().find( "from InstitutionType institutionType order by name");
	}
	
	@Override
	public List<Country> getAllCountry() {
		return getHibernateTemplate().find( "from Country country order by name");
	}
	
	@Override
	public void effectiveTermType(String institutionId,String termTypeId) {
		String queryString="UPDATE InstitutionTermType SET effective = '0' WHERE instituteId=?";
		getHibernateTemplate().bulkUpdate(queryString, institutionId);
		String queryString1="UPDATE InstitutionTermType SET effective = '1' WHERE id=?";
		getHibernateTemplate().bulkUpdate(queryString1, termTypeId);
		
	}

	@Override
	public Country findCountryById(String countryId) {
		// TODO Auto-generated method stub
		return (Country)getHibernateTemplate().find("FROM Country WHERE id="+countryId).get(0);
	}

	@Override
	public void addInstitutionTermTypeList(List<InstitutionTermType> iTermTypeList,String institutionId) {
		
		try{
			
			//First Delete All  InstitutionTermType and again Add new one
			List<InstitutionTermType> listExistingInstitutionTermType = getAllInstitutionTermType(institutionId);
			if( listExistingInstitutionTermType != null && listExistingInstitutionTermType.size() > 0 ) {
				getHibernateTemplate().deleteAll(listExistingInstitutionTermType);
			}
			
			for(InstitutionTermType itt:iTermTypeList){
				if(itt.getTermType()!=null){
					if(itt.getTermType().getId()!=null&& !itt.getTermType().getId().isEmpty() && itt.getEffectiveDate()!=null && !itt.getEffectiveDate().toString().isEmpty() ){
							getHibernateTemplate().saveOrUpdate(itt);
						
					}
				}
			}
			}catch (Exception e) {
				
				String uniqueId = RequestContext.getRequestIdFromContext();
				log.error("InstitutionTermType Addition ---Error."+e+" RequestId:"+uniqueId, e);
			}
	}
	@Override
	public InstitutionTermType findEffectiveInstitutionTermTypeByInititutionId(
			String institutionId) {
		InstitutionTermType  institutionTermType = new InstitutionTermType();		
		try{
			institutionTermType = (InstitutionTermType)getHibernateTemplate().find("FROM InstitutionTermType WHERE instituteId=? AND effective =?",new Object[]{institutionId,true}).get(0);
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No Term Type found."+e+" RequestId:"+uniqueId, e);
		}
		return institutionTermType;
	}
	@Override
	public InstitutionTermType findCurrentlyEffectiveInstitutionTermType(Date compareDate,
			String institutionId) {
		InstitutionTermType  institutionTermType = new InstitutionTermType();		
		try{
			List<InstitutionTermType> institutionTermTypeList = getHibernateTemplate().find("FROM InstitutionTermType WHERE instituteId=? AND CONVERT(VARCHAR(10),effective_date,111)<= CONVERT(VARCHAR(10),?,111) "+
								"AND (CONVERT(VARCHAR(10),end_date,111)>=CONVERT(VARCHAR(10),?,111) OR  end_date is null)",new Object[]{institutionId,compareDate,compareDate});
			
			if(institutionTermTypeList!=null && institutionTermTypeList.size()>0){
				
				institutionTermType= institutionTermTypeList.get(0);
			}
			return institutionTermType;
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No Term Type found."+e+" RequestId:"+uniqueId, e);
		}
		return institutionTermType;
	}
}
