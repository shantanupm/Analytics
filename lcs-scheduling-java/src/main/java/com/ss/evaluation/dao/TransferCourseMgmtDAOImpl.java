package com.ss.evaluation.dao;

import java.io.Serializable;
import java.util.List;

import org.displaytag.properties.SortOrderEnum;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.ss.common.dao.BaseAbstractDAO;
import com.ss.common.logging.RequestContext;
import com.ss.course.value.CourseTranscript;
import com.ss.course.value.MilitarySubject;
import com.ss.course.value.TransferCourse;
import com.ss.course.value.TransferCourseTitle;
import com.ss.evaluation.value.StudentTranscriptCourse;
import com.ss.evaluation.value.TranscriptCourseSubject;
import com.ss.institution.dao.InstitutionMgmtDao;
import com.ss.institution.value.GcuCourseLevel;

/**
 * Interface Implementation of {@link InstitutionMgmtDao}
 * @author Bharat.Ranjan
 */
@Repository
public class TransferCourseMgmtDAOImpl extends BaseAbstractDAO<TransferCourse, Serializable> implements TransferCourseMgmtDAO {
	
	private static Logger log = LoggerFactory.getLogger(TransferCourseMgmtDAOImpl.class);

	@Override
	public TransferCourse getTransferCourseByCourseCodeAndInstitutionId(String transferCourseCode, String institutionId) {
		List<TransferCourse> list = getHibernateTemplate().find( "from TransferCourse tc where tc.trCourseCode = ? and tc.institution.id = ?", transferCourseCode, institutionId );
		if( list == null || list.size() == 0 ) {
			return null;
		}		
		return list.get(0);
	}

	@Override
	public List<TransferCourse> getAllTransferCourse() {
		List<TransferCourse> list = getHibernateTemplate().find( "from TransferCourse tc where upper(tc.evaluationStatus)='EVALUATED' order by trCourseCode");
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list;
		
	}

	@Override
	public TransferCourse getTransferCourseByInstitutionIdAndCourseNumber(
			String instId, String cn) {
		List<TransferCourse> list = getHibernateTemplate().find( "from TransferCourse where institution.id = ? and trCourseCode = ? and upper(evaluationStatus)='EVALUATED' ", instId, cn );
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list.get(0);
	}

	@Override
	public TransferCourse getTransferCourseByInstitutionAndPartCourseTitle(
			String instId, String pct) {
		List<TransferCourse> list = getHibernateTemplate().find( "from TransferCourse where institution.id like ? and trCourseTitle like ? upper(evaluationStatus)='EVALUATED'", instId, pct );
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list.get(0);
	}

	@Override
	public void addTransferCourse(TransferCourse tc) {
		getHibernateTemplate().saveOrUpdate(tc);
	}

	@Override
	public List<TransferCourse> getTransferCourseByInstitutionIdAndInstProgramId(
			String instId, String iPId) {
		List<TransferCourse> list = getHibernateTemplate().find( "from TransferCourse where institution.id = ? and institutionProgramId like ? where upper(evaluationStatus)='EVALUATED'", instId, iPId);
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list;
	}

	@Override
	public List<TransferCourse> getAllEvaluatedCoursesByInstId(String institutionId) {
		List<TransferCourse> list = getHibernateTemplate().find( "from TransferCourse where institution.id = ? and upper(evaluationStatus) ='EVALUATED'", institutionId);
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list;
	}
	
	@Override
	public List<TransferCourse> getAllNotEvaluatedCoursesByInstId(String institutionId){
		List<TransferCourse> list = getHibernateTemplate().find( "from TransferCourse where institution.id = ? and upper(evaluationStatus) ='NOT EVALUATED'", institutionId);
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list;
	}
	
	@Override
	public List<TransferCourse> getAllConflictCoursesByInstId(String institutionId){
		List<TransferCourse> list = getHibernateTemplate().find( "from TransferCourse where institution.id = ? and upper(evaluationStatus) ='CONFLICT'", institutionId);
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list;
	}
	
	@Override
	public List<TransferCourse> getTransferCourseByInstitutionIdAndString(String institutionId,String courseCode) {
		List<TransferCourse> list = getHibernateTemplate().find( "from TransferCourse where institution.id = ? and upper(evaluationStatus) ='EVALUATED' AND trCourseCode LIKE ?", institutionId,courseCode+"%");
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list;
	}

	@Override
	public List<TransferCourse> getAllTransferCourseForEvaluation() {
		List<TransferCourse> list = getHibernateTemplate().find( "from TransferCourse tc where upper(evaluationStatus)!='EVALUATED' order by trCourseCode");
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list;
	}
	
	@Override
	public void saveTransferCourse( TransferCourse transferCourse ) {
		getHibernateTemplate().saveOrUpdate( transferCourse );
	}
	
	@Override
	public List<TransferCourse> getAllCoursesByInstId(String institutionId,String status){
		List<TransferCourse> list = getHibernateTemplate().find( "from TransferCourse where institution.id = ? and upper(evaluationStatus) =?", institutionId,status);
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list;
	}
	
	@Override
	@SuppressWarnings("unchecked")
    public int getAllRecordsCount(Class clazz,String institutionId,String status, 
    		String searchBy, String searchText) {
        DetachedCriteria criteria = DetachedCriteria.forClass(clazz);
        /*if(null!=searchBy){
			if(  !searchBy.isEmpty() ){
				if(null!=searchText){
					if(  !searchText.isEmpty() ){
						if(searchBy.equalsIgnoreCase("1")){
							criteria.add(Restrictions.like("trCourseCode", "%"+searchText+"%"));
						}
						else if(searchBy.equalsIgnoreCase("2")){
							criteria.add(Restrictions.like("trCourseTitle", "%"+searchText+"%"));
						}
					}
				}
			}
		}
        
       
        criteria.add(Restrictions.eq("institution.id", institutionId));
		criteria.add(Restrictions.eq("evaluationStatus", status));*/
		criteria.setProjection(Projections.rowCount());
		prepareCriteria(criteria,searchBy,searchText,institutionId,status, null);
        List results = getHibernateTemplate().findByCriteria(criteria);
       
        int count = ((Long) results.get(0)).intValue();
        return count;
    }
	
	@Override
    @SuppressWarnings("unchecked")
    public List getAllRecordsPage(Class clazz, int firstResult, int maxResults,
            SortOrderEnum sortDirection, String sortCriterion ,String institutionId,
            String status, String searchBy, String searchText) {
        DetachedCriteria criteria = DetachedCriteria.forClass(clazz);
       
        DetachedCriteria c2 = criteria.createCriteria("institution");
    	//criteria.createAlias("institution", "inst");
        if (sortCriterion != null) {
        	if(sortCriterion.contains("institution")){
        		//criteria.createAlias("institution", "inst");
        		sortCriterion=sortCriterion.replace("institution.", "");
        		
        		if (sortDirection.equals(SortOrderEnum.ASCENDING)) {
        			c2.addOrder(Order.asc(sortCriterion));
                }
                if (sortDirection.equals(SortOrderEnum.DESCENDING)) {
                	c2.addOrder(Order.desc(sortCriterion));
                }
        	}else{
	            if (sortDirection.equals(SortOrderEnum.ASCENDING)) {
	                criteria.addOrder(Order.asc(sortCriterion));
	            }
	            if (sortDirection.equals(SortOrderEnum.DESCENDING)) {
	                criteria.addOrder(Order.desc(sortCriterion));
	            }
        	}
        }else{
        	criteria.addOrder(Order.desc("modifiedDate"));
        }
        
        prepareCriteria(criteria,searchBy,searchText,institutionId,status, c2);
        List results = getHibernateTemplate().findByCriteria(criteria,
                firstResult, maxResults);
        return results;
    }

	
	
	@Override
	public List<TransferCourse> getAllCoursesForApproval() {
		List<TransferCourse> list = getHibernateTemplate().find( "from TransferCourse where collegeApprovalRequired=1");
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list;
	}
	
	@Override
	public List<TransferCourseTitle> getTransferCourseTitlesByCourseCodeandInstitutionId(String courseCode, String institutionId){
		List<TransferCourseTitle> trCoursetitleList = getHibernateTemplate().find("from TransferCourseTitle where transferCourseId in (select id from TransferCourse where trCourseCode = ? and institutionId = ?)", courseCode, institutionId);
		if(trCoursetitleList != null && !trCoursetitleList.isEmpty())
			return trCoursetitleList;
		else return null;
	}
	
	@Override
	public List<TransferCourseTitle> getTransferCourseTitlesByTransferCourseId(String transferCourseId){
		List<TransferCourseTitle> trCoursetitleList = getHibernateTemplate().find("from TransferCourseTitle where transferCourseId = ?",transferCourseId);
		if(trCoursetitleList != null && !trCoursetitleList.isEmpty())
			return trCoursetitleList;
		else return null;
	}
	
	@Override
	public TransferCourseTitle getTransferCourseTitleById(String id){
		List<TransferCourseTitle> list = getHibernateTemplate().find("from TransferCourseTitle where id=?",id);
		if(list!=null&&list.size()!=0){
			return list.get(0);
		}
		else return null;
	}
	
	@Override
	public void addTransferCourseTitle(TransferCourseTitle tct) {
		getHibernateTemplate().saveOrUpdate(tct);
	}
	
	@Override
	public TransferCourseTitle getTransferCourseTitleByCourseIdAndTitle(String trCourseId, String title){
		List<TransferCourseTitle> list = getHibernateTemplate().find("from TransferCourseTitle where transferCourseId=? and title=?", trCourseId, title);
		if(list!=null&&list.size()!=0){
			return list.get(0);
		}
		else return null;
	}
	
	@Override
	public TransferCourseTitle getNotEvaluatedTransferCourseTitleByCourseIdAndTitle(String trCourseId, String title){
		List<TransferCourseTitle> list = getHibernateTemplate().find("from TransferCourseTitle where transferCourseId=? and title=? and upper(evaluationStatus) ='NOT EVALUATED'", trCourseId, title);
		if(list!=null&&list.size()!=0){
			return list.get(0);
		}
		else return null;
	}
	
	@Override
	public TransferCourseTitle courseTitlePresentInMain(String trCourseId, String titleId){
		
		List<TransferCourseTitle> list = getHibernateTemplate().find("from TransferCourseTitle where transferCourseId=? and id=?", trCourseId, titleId);
		if(list!=null&&list.size()!=0){
			return list.get(0);
		}
		else return null;
	}
	
	private void prepareCriteria(DetachedCriteria criteria,String searchBy,
			String searchText,String institutionId, String status, DetachedCriteria newCriteria){
		if(null!=searchBy){
			if(  !searchBy.isEmpty() ){
				if(null!=searchText){
					if(  !searchText.isEmpty() ){
						 if (searchBy != null) {
						        if(searchBy.equalsIgnoreCase("3") || searchBy.equalsIgnoreCase("4")){
						    		//criteria.createAlias("institution", "institution");
						        //	DetachedCriteria c2 = criteria.createCriteria("institution");
						        	if(newCriteria==null){
						        		 newCriteria= criteria.createCriteria("institution");
						        	}
						    		 if(searchBy.equalsIgnoreCase("3")){
						    			 newCriteria.add(Restrictions.eq("institutionID", Integer.parseInt(searchText)));
									}else if(searchBy.equalsIgnoreCase("4")){
										newCriteria.add(Restrictions.like("name", "%"+searchText+"%"));
									}
						    	}
					        }
						
						if(searchBy.equalsIgnoreCase("1")){
							criteria.add(Restrictions.like("trCourseCode", "%"+searchText+"%"));
						}
						else if(searchBy.equalsIgnoreCase("2")){
							criteria.add(Restrictions.like("trCourseTitle", "%"+searchText+"%"));
						}
					}
				}
			}
		}
		if(institutionId!=null && !institutionId.isEmpty()){
			criteria.add(Restrictions.eq("institution.id", institutionId));
		}
        if(!"ALL".equals(status) && status!=null && !status.isEmpty() && !"Approval".equals(status)){
        	criteria.add(Restrictions.eq("evaluationStatus", status));
        }
        if("Approval".equals(status)){
        	criteria.add(Restrictions.eq("collegeApprovalRequired", true));
        }
	}

	@Override
	public List<TransferCourse> getCourseByInstitutionIdAndString(String institutionId,String searchBy,
			String searchText) {
		 DetachedCriteria criteria = DetachedCriteria.forClass(TransferCourse.class);
		 prepareCriteria(criteria, searchBy, searchText, institutionId, "ALL", null);
		 List<TransferCourse> list = getHibernateTemplate().findByCriteria(criteria);
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list;
	}

	
	@Override
	public void addCourseTranscript(CourseTranscript ct) {
		getHibernateTemplate().saveOrUpdate(ct);
	}
	
	@Override
	public CourseTranscript getCourseTranscript(String transferCourseId){
		List<CourseTranscript> list = getHibernateTemplate().find("FROM CourseTranscript WHERE trCourseId=? ORDER BY modifiedDate ",transferCourseId);
		if(list!=null&&list.size()!=0){
			return list.get(0);
		}
		else return null;
		
	}
	@Override
	public void addTransferCourseTitles(List<TransferCourseTitle> tcts) {
		String queryString="UPDATE TransferCourseTitle SET effective = '0' WHERE transferCourseId=?";
		if(tcts != null && !tcts.isEmpty()){
			getHibernateTemplate().bulkUpdate(queryString, tcts.get(0).getTransferCourseId());
		}
		getHibernateTemplate().saveOrUpdateAll(tcts);
	}
	@Override
	public void removeTransferCourseTitles(List<TransferCourseTitle> courseTitleList) {
		getHibernateTemplate().deleteAll(courseTitleList);
		
	}
	
	@Override
	public List<MilitarySubject> getMilitarySubjectByTransferCourseId(String transferCourseId){
		List<MilitarySubject> militarySubject =  null; 
		try{			
			militarySubject = getHibernateTemplate().find("from MilitarySubject where transferCourseId = ?",transferCourseId);
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No MilitarySubject found."+e+" RequestId:"+uniqueId, e);
		}
		return militarySubject;
	}
	@Override
	public void addMilitarySubject(List<MilitarySubject> titleList) {
		getHibernateTemplate().saveOrUpdateAll(titleList);
	}
	@Override
	public void addMilitarySubjectPerTranscriptCourseSubject(
			MilitarySubject militarySubject) {
		getHibernateTemplate().saveOrUpdate(militarySubject);		
	}
	@Override
	public void addTranscriptCourseSubjectList(
			List<TranscriptCourseSubject> transcriptCourseSubjectList) {
		getHibernateTemplate().saveOrUpdateAll(transcriptCourseSubjectList);
		
	}
	
	@Override
	public List<TranscriptCourseSubject> getAllTranscriptCourseSubjectByStudentTranscriptCourseId(
			String studentTranscriptCourseId) {
		List<TranscriptCourseSubject> transcriptCourseSubjectList = null;
		try{
			
			transcriptCourseSubjectList = getHibernateTemplate().find("FROM TranscriptCourseSubject WHERE transcriptCourseId=? ", new Object[]{studentTranscriptCourseId});
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No TranscriptCourseSubject found."+e+" RequestId:"+uniqueId, e);
		}
		return transcriptCourseSubjectList;
	}
	@Override
	public void removeTranscriptCourseSubjectList(
			List<TranscriptCourseSubject> transcriptCourseSubjectList) {
		getHibernateTemplate().deleteAll(transcriptCourseSubjectList);
		
	}
	@Override
	public MilitarySubject isMilitarySubjectExit(String subjectName,
			String transferCourseId) {
		MilitarySubject militarySubject = null;
		try{
			
			List<MilitarySubject> militarySubjectList = getHibernateTemplate().find("FROM MilitarySubject WHERE name=? and transferCourseId=?", new Object[]{subjectName,transferCourseId});
			if(militarySubjectList != null && !militarySubjectList.isEmpty()){
				return militarySubjectList.get(0);
			}
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No MilitarySubject found."+e+" RequestId:"+uniqueId, e);
		}
		return militarySubject;
	}
	@Override
	public TranscriptCourseSubject findTranscriptCourseSubjectByTranscriptCourseIdAndSubjectId(
			String subjectId, String studentTranscriptCourseId) {
		TranscriptCourseSubject transcriptCourseSubject = null;
		try{
			
			List<TranscriptCourseSubject> transcriptCourseSubjectList = getHibernateTemplate().find("FROM TranscriptCourseSubject WHERE subjectId=? and transcriptCourseId=?", new Object[]{subjectId,studentTranscriptCourseId});
			if(transcriptCourseSubjectList != null && !transcriptCourseSubjectList.isEmpty()){
				return transcriptCourseSubjectList.get(0);
			}
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No TranscriptCourseSubject found."+e+" RequestId:"+uniqueId, e);
		}
		return transcriptCourseSubject;
	}
	@Override
	public void addOrUpdateTranscriptCourseSubject(
			TranscriptCourseSubject transcriptCourseSubject) {
		try{
			getHibernateTemplate().saveOrUpdate(transcriptCourseSubject);			
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Not able to Update TranscriptCourseSubject found."+e+" RequestId:"+uniqueId, e);
		}		
	}
	@Override
	public void removeRejectedStudentTranscriptCourseSubjectMarkForDelection(
			List<TranscriptCourseSubject> tcsubjectRejectedListForDeletion) {
		getHibernateTemplate().deleteAll(tcsubjectRejectedListForDeletion);
	}
	
	@Override
	public MilitarySubject getMilitarySubjectById(String militarySubjectId) {
		MilitarySubject militarySubject = null;
		try{
			
			List<MilitarySubject> militarySubjectList = getHibernateTemplate().find("FROM MilitarySubject WHERE id=?", new Object[]{militarySubjectId});
			if(militarySubjectList != null && !militarySubjectList.isEmpty()){
				return militarySubjectList.get(0);
			}
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No MilitarySubject found."+e+" RequestId:"+uniqueId, e);
		}
		return militarySubject;
	}
	
	@Override
	public TranscriptCourseSubject getTranscriptCourseSubjectById(String transcriptCourseSubjectId) {
		TranscriptCourseSubject transcriptCourseSubject = null;
		try{
			
			List<TranscriptCourseSubject> transcriptCourseSubjectList = getHibernateTemplate().find("FROM TranscriptCourseSubject WHERE id=?", new Object[]{transcriptCourseSubjectId});
			if(transcriptCourseSubjectList != null && !transcriptCourseSubjectList.isEmpty()){
				return transcriptCourseSubjectList.get(0);
			}
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No TranscriptCourseSubject found."+e+" RequestId:"+uniqueId, e);
		}
		return transcriptCourseSubject;
	}

	@Override
	public void saveOrUpdateTranscriptCourseSubjects(List<TranscriptCourseSubject> transcriptCourseSubjectList) {
		try {
		getHibernateTemplate().saveOrUpdateAll(transcriptCourseSubjectList);
		}catch(Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Error occurred while saving or updating transcriptCourseSubjectList RequestId:"+uniqueId, e);
		}
		
	}
	
	
}