package com.ss.course.dao;

import java.io.Serializable;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Query;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.stereotype.Repository;

import com.ss.common.dao.BaseAbstractDAO;
import com.ss.common.util.UserUtil;
import com.ss.course.value.CourseCategoryMapping;
import com.ss.course.value.CourseMapping;
import com.ss.course.value.CourseMappingDetail;
import com.ss.course.value.GCUCourse;
import com.ss.course.value.GCUCourseCategory;
import com.ss.course.value.TransferCourse;
import com.ss.course.value.TransferCourseMirror;
import com.ss.course.value.TransferCourseTitle;
import com.ss.common.logging.RequestContext;
import com.ss.evaluation.enums.TranscriptStatusEnum;
import com.ss.evaluation.value.StudentInstitutionDegree;
import com.ss.institution.service.InstitutionService;
import com.ss.institution.value.GcuCourseLevel;
import com.ss.institution.value.Institution;
import com.ss.institution.value.TransferCourseInstitutionTranscriptKeyGradeAssoc;

@Repository
public class CourseMgmtDaoImpl extends BaseAbstractDAO<TransferCourse, Serializable> implements CourseMgmtDAO {

	private static transient Logger log = LoggerFactory.getLogger( CourseMgmtDaoImpl.class );
	@Autowired
	private InstitutionService institutionService;
	
	@Autowired
	private CourseMirrorMgmtDAO courseMirrorMgmtDAO;
	
	
	@Override
	public void createCourse(TransferCourse transferCourse) {
		getHibernateTemplate().saveOrUpdate(transferCourse);
		if(transferCourse.getEvaluationStatus().equalsIgnoreCase("Evaluated")){
			String queryString="UPDATE StudentTranscriptCourse SET evaluationStatus = '"+ TranscriptStatusEnum.EVALUATED.getValue()+"' WHERE trCourseId=?";
			getHibernateTemplate().bulkUpdate(queryString, transferCourse.getTrCourseCode());
		}

	}
	
	@Override
	public void createGCUCourse(GCUCourse gcuCourse){
		getHibernateTemplate().saveOrUpdate(gcuCourse);
	}
	
	@Override
	public void createGCUCourseList(List<GCUCourse> gcuCourseList){
		getHibernateTemplate().saveOrUpdateAll(gcuCourseList);
	}
	
	@Override
	public TransferCourse getTransferCourseByCodeTitle(String courseCode,String courseTitle){
		TransferCourse transferCourse =new TransferCourse();
		try{
			DetachedCriteria criteria = DetachedCriteria.forClass(TransferCourse.class);
			if(null!=courseCode){
				if(!courseCode.isEmpty()){
					criteria.add(Restrictions.eq("trCourseCode", courseCode));
				}
			}
			if(null!=courseTitle){
				if(!courseTitle.isEmpty()){
					criteria.add(Restrictions.like("trCourseTitle", courseTitle+"%"));
				}
			}
			
			List<TransferCourse> tcList=getHibernateTemplate().findByCriteria(criteria);
			 transferCourse = tcList.get( 0 );
		}catch (Exception e) {
			//log.error("No  Course found"+e, e);
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No  Course found."+e+" RequestId:"+uniqueId, e);
		}
		return transferCourse;
	}
	
	@Override
	public TransferCourse getTransferCourseById(String transferCourseId) {
		 List<TransferCourse> tcList =getHibernateTemplate().find( "from TransferCourse where id= ?", transferCourseId);
		 TransferCourse transferCourse = tcList !=null && tcList.size()>0 ?tcList.get( 0 ):null;
		 return transferCourse;
	}
	
	@Override
	public List<TransferCourse> getAllNotEvalutedTransferCourse(){
		 List<TransferCourse> tcList =getHibernateTemplate().find( "from TransferCourse where evaluationStatus!='Evaluated'");
		
		return tcList;
	}

	@Override
	public void addCourseRelationShip(CourseMapping courseMapping) {
		getHibernateTemplate().saveOrUpdate(courseMapping);
		
	}

	@Override
	public void addCourseCategoryRelationShip(
			CourseCategoryMapping courseCategoryMapping) {
		getHibernateTemplate().saveOrUpdate(courseCategoryMapping);
		
	}

	@Override
	public List<CourseCategoryMapping> getAllCourseCategoryMapping() {
		return getHibernateTemplate().find( "from CourseCategoryMapping ");
		
	}
	
	@Override
	public List<GCUCourseCategory> getAllGCUCourseCategories(){
		return getHibernateTemplate().find("from GCUCourseCategory");
	}

	@Override
	public List<CourseMapping> getAllCourseMapping() {
		return getHibernateTemplate().find( "from CourseMapping ");
	}

	@Override
	public List<CourseCategoryMapping> getCourseCategoryMappingByTransferCourseId(
			String transferCourseId) {
		
		 return getHibernateTemplate().find( "from CourseCategoryMapping where trCourseId= ?", transferCourseId);
	}

	@Override
	public List<CourseMapping> getCourseMappingByTransferCourseId(
			String transferCourseId) {
		return getHibernateTemplate().find( "from CourseMapping where trCourseId= ?", transferCourseId);
	}
	
	@Override
	public CourseMapping getCourseMapping(String courseMappingId) {
		List<CourseMapping> cmList=getHibernateTemplate().find( "from CourseMapping where id= ?", courseMappingId);
		CourseMapping courseMapping = cmList.get( 0 );
		return courseMapping;
	}

	@Override
	public CourseCategoryMapping getCourseCategoryMapping(String courseCategoryMappingId) {
		List<CourseCategoryMapping> cmList=getHibernateTemplate().find( "from CourseCategoryMapping where id= ?", courseCategoryMappingId);
		CourseCategoryMapping courseCategoryMapping = cmList.get( 0 );
		return courseCategoryMapping;
	}

	@Override
	public List<TransferCourse> getAllTransferCourse(){
		 List<TransferCourse> tcList =getHibernateTemplate().find( "from TransferCourse ");
		
		return tcList;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GCUCourse> getGCUCourseList(final String gcuCourseCode){
		List<GCUCourse> gcuclist = new ArrayList<GCUCourse>();
		
		gcuclist = getHibernateTemplate().executeFind(new HibernateCallback() {

			public List<GCUCourse> doInHibernate(Session session) throws HibernateException, SQLException {

			org.hibernate.Query query = session.createQuery( "from GCUCourse where courseCode LIKE :gcuCourseCode");
			query.setMaxResults(10);
			List<GCUCourse> objList =query.setParameter("gcuCourseCode", gcuCourseCode+"%").list(); 
			return objList;
			}
			});		
		return gcuclist;
	}
	
	@Override
	public TransferCourse getOldestNotEvaluatedCourse(){
		final String userId= UserUtil.getCurrentUser().getId();
	/*	List<TransferCourse> list1 = getHibernateTemplate().find("from TransferCourse where upper(evaluationStatus) = 'NOT EVALUATED' " +
				" AND collegeApprovalRequired=0 AND ((checkedBy =? OR checkedBy IS NULL) OR (confirmedBy =? OR confirmedBy is NULL)) " +
				"AND id NOT IN( select transferCourseId from TransferCourseMirror  group by transferCourseId  having   count(transferCourseId)>1 union" +
				" select transferCourseId from TransferCourseMirror  where  evaluatorId =? and evaluationStatus='COMPLETED') ORDER BY createdDate",userId,userId,userId);*/
		// above query in comments will yield wrong results
		//List<TransferCourse> list = getHibernateTemplate().find("from TransferCourse where upper(evaluationStatus) = 'NOT EVALUATED' and confirmedBy is NULL ORDER BY createdDateTime");
		
		
		final String queryStr="select * from ss_tbl_transfer_course where evaluation_status= 'NOT EVALUATED' and college_approval_required=0" +
				" and ((checked_by=? or checked_by is null) OR (confirmed_by=? or confirmed_by is null )) " +
				"AND id NOT IN( select transfer_course_id from ss_tbl_transfer_course_mirror  group by transfer_course_id  having   count(transfer_course_id)>1 union" +
				" select transfer_course_id from ss_tbl_transfer_course_mirror  where  evaluator_id =? and evaluation_status='COMPLETED' union " +
				"select transfer_course_id from ss_tbl_transfer_course_mirror where evaluator_id!=? and evaluation_status='TEMP' ) order by created_date";
		List resultList = (List<TransferCourse>)getHibernateTemplate().execute(new HibernateCallback() {
			public Object doInHibernate(Session session) throws HibernateException, SQLException {
			Query query = session.createSQLQuery(queryStr);
			query.setString(0, userId);
			query.setString(1, userId);
			query.setString(2, userId);
			query.setString(3, userId);
			List list = query.list();
			
			return list;
			}});
		
			List<TransferCourse> transferCourseList= new ArrayList<TransferCourse>();
			TransferCourse transferCourseReturn= new TransferCourse();
			TransferCourse transferCourse= new TransferCourse();
			  if(resultList.size()>0){
				  for(int i=0;i<resultList.size();i++){
					  Object[] row = (Object[]) resultList.get(i);
						  
					  transferCourse=getTransferCourseById((String)row[0]);
					  
					  
					  //IF checked by or confirmed by is not null and if they have mirror entry which is TEMP then dont assign to another IE
					  //IF checked by of confirmed by is not null and if they don't have mirror entry then also dont assign to another IE
					  if(transferCourse!=null){
						 if(transferCourse.getCheckedBy()==null&& transferCourse.getConfirmedBy()==null){
							 transferCourseReturn= transferCourse; 
							 break;
						 }
						  else if(transferCourse.getCheckedBy()!=null ){
							  TransferCourseMirror transferCourseMirror=  courseMirrorMgmtDAO.getTransferCourseMirrorByCourseIdAndEvaluatorId(transferCourse.getId(), userId);
							  if(transferCourseMirror!=null && transferCourseMirror.getEvaluationStatus().equalsIgnoreCase("TEMP")){
								  
							  }else if(transferCourseMirror==null){
								  transferCourseReturn= transferCourse;
								  break;
							  }
							  else{
								  transferCourseReturn= transferCourse;
								  break;
							  }
						  }
						  else if(transferCourse.getConfirmedBy()!=null ){
							  TransferCourseMirror transferCourseMirror=  courseMirrorMgmtDAO.getTransferCourseMirrorByCourseIdAndEvaluatorId(transferCourse.getId(), userId);
							  if(transferCourseMirror!=null && transferCourseMirror.getEvaluationStatus().equalsIgnoreCase("TEMP")){
								 
							  }else if(transferCourseMirror==null){
								  transferCourseReturn= transferCourse;
								  break;
							  }else{
								  transferCourseReturn= transferCourse;
								  break;
							  }
						  }
						 
			
					  }
				  }
			}
			 return transferCourseReturn;
		
		
	}
	
	@Override
	public List<TransferCourse> getNotEvaluatedCoursesByInstitutionId(final String institutionId){
		final String userId= UserUtil.getCurrentUser().getId();
		//return getHibernateTemplate().find("from TransferCourse where upper(evaluationStatus) = 'NOT EVALUATED'  AND (checkedBy !=? OR checkedBy IS NULL) and confirmedBy is NULL and institution.id = ?",userId, institutionId);
		//above query in comments will yield wrong results for ie2
		/*return getHibernateTemplate().find("from TransferCourse where upper(evaluationStatus) = 'NOT EVALUATED' " +
				" AND ((checkedBy =? OR checkedBy IS NULL) OR (confirmedBy =? OR confirmedBy is NULL)) and institution.id = ? AND collegeApprovalRequired=0 " +
				" AND id NOT IN(select transferCourseId from TransferCourseMirror group by transferCourseId  having count(transferCourseId)>1)",userId,userId, institutionId);*/
		
		final String queryStr="select * from ss_tbl_transfer_course where evaluation_status= 'NOT EVALUATED' and college_approval_required=0" +
				" and ((checked_by=? or checked_by is null) OR (confirmed_by=? or confirmed_by is null ))  and institution_id=?" +
				"AND id NOT IN( select transfer_course_id from ss_tbl_transfer_course_mirror  group by transfer_course_id  having   count(transfer_course_id)>1 union" +
				" select transfer_course_id from ss_tbl_transfer_course_mirror  where  evaluator_id =? and evaluation_status='COMPLETED' ) order by created_date";
		
		List resultList = (List<TransferCourse>)getHibernateTemplate().execute(new HibernateCallback() {
			public Object doInHibernate(Session session) throws HibernateException, SQLException {
			Query query = session.createSQLQuery(queryStr);
			query.setString(0, userId);
			query.setString(1, userId);
			query.setString(2, institutionId);
			query.setString(3, userId);
			List list = query.list();
			
			return list;
			}});
		
			List<TransferCourse> transferCourseList= new ArrayList<TransferCourse>();
			
			TransferCourse transferCourse;
			  if(resultList.size()>0){
				  for(int i=0;i<=resultList.size()-1;i++){
					  transferCourse= new TransferCourse();
					  Object[] row = (Object[]) resultList.get(i);
					  
					  transferCourse=getTransferCourseById((String)row[0]);
					  transferCourseList.add(transferCourse);
				  }
			  }
			  
			  return transferCourseList;
		
	}
	
	@Override
	public List<TransferCourse> getNotEvaluatedTransferCoursesforJob(){
		return getHibernateTemplate().find("from TransferCourse where upper(evaluationStatus) = 'NOT EVALUATED' and checkedBy IS NOT NULL and confirmedBy IS NOT NULL");
	}
	
	@Override
	public List<TransferCourse> getConflictCourses(){
		return getHibernateTemplate().find("from TransferCourse where upper(evaluationStatus) = 'CONFLICT' ");
	}
	
	
	@Override
	public List<TransferCourse> getConflictCoursesByInstitutionId(String institutionId){
		return getHibernateTemplate().find("from TransferCourse where upper(evaluationStatus) = 'CONFLICT' AND  institution.id=?",institutionId);
	}
	
	@Override
	public List<TransferCourse> getCoursesForReAssignment(){
		List<TransferCourse> list = getHibernateTemplate().find("select tc from TransferCourse tc, TransferCourseMirror tcm  where tc.id = tcm.transferCourseId and upper(tc.evaluationStatus) = 'NOT EVALUATED' and (tc.checkedBy IS NOT NULL OR tc.confirmedBy IS NOT NULL) and upper(tcm.evaluationStatus) = 'TEMP' and upper(tc.institution.evaluationStatus) = 'EVALUATED' ");
		if(list != null && list.size()!=0){
			return list;
		}
		else return null;
	}
	
	@Override
	public void effectiveCourseRelationship(String transferCourseId,String courseMappingId) {
		String queryString="UPDATE CourseMapping SET effective = '0' WHERE trCourseId=?";
		getHibernateTemplate().bulkUpdate(queryString, transferCourseId);
		String queryString1="UPDATE CourseMapping SET effective = '1' WHERE id=?";
		getHibernateTemplate().bulkUpdate(queryString1, courseMappingId);
		
	}
	@Override
	public void effectiveCourseCtgRelationship(String transferCourseId,String courseCategoryMappingId) {
		String queryString="UPDATE CourseCategoryMapping SET effective = '0' WHERE trCourseId=?";
		getHibernateTemplate().bulkUpdate(queryString, transferCourseId);
		String queryString1="UPDATE CourseCategoryMapping SET effective = '1' WHERE id=?";
		getHibernateTemplate().bulkUpdate(queryString1, courseCategoryMappingId);
		
	}
	@Override
	public void effectiveCourseTitle(String transferCourseId,String courseTitleId) {
		String queryString="UPDATE TransferCourseTitle SET effective = '0' WHERE transferCourseId=?";
		getHibernateTemplate().bulkUpdate(queryString, transferCourseId);
		String queryString1="UPDATE TransferCourseTitle SET effective = '1' WHERE id=?";
		getHibernateTemplate().bulkUpdate(queryString1, courseTitleId);
		
	}

	@Override
	public List<TransferCourse> getAllNotEvalutedTransferCourseForCurrentUser(
			String currentUserId) {
		//List<TransferCourse> transferCourselist = getHibernateTemplate().find("from TransferCourse where upper(evaluationStatus) = 'NOT EVALUATED' AND collegeApprovalRequired=0 AND (checkedBy !=? OR checkedBy IS NULL) and confirmedBy is NULL ORDER BY createdDateTime",currentUserId);
		//List<TransferCourse> transferCourselist = getHibernateTemplate().find("from TransferCourse where upper(evaluationStatus) = 'NOT EVALUATED' AND collegeApprovalRequired=0 AND confirmedBy is NULL ORDER BY createdDate");
		List<TransferCourse> transferCourselist = getHibernateTemplate().find("from TransferCourse where upper(evaluationStatus) = 'NOT EVALUATED' AND collegeApprovalRequired=0  AND (checkedBy=? or confirmedBy=?) " +
				"AND id NOT IN(select transferCourseId from TransferCourseMirror where evaluationStatus='COMPLETED' and evaluatorId=?) ORDER BY createdDate",currentUserId,currentUserId,currentUserId);
		if(transferCourselist!=null && transferCourselist.size()>0){
			return transferCourselist;
		}
		return null;
	}
	@Override
	public TransferCourseTitle findEffectiveCourseTitleForCourseId(
			String transferCourseId) {
		TransferCourseTitle transferCourseTitle = null;
		List<TransferCourseTitle> transferCourseTitleList = new ArrayList<TransferCourseTitle>();
		try{
			transferCourseTitleList = getHibernateTemplate().find("FROM TransferCourseTitle WHERE transferCourseId=? AND effective=?",new Object[]{transferCourseId,true});
			if(transferCourseTitleList != null && transferCourseTitleList.size()>0){
				transferCourseTitle =  transferCourseTitleList.get(0);
			}
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No Title found."+e+" RequestId:"+uniqueId, e);
		}
		return transferCourseTitle;
	}
	@Override
	public List<GCUCourse> findAllGCUCourseList() {
		List<GCUCourse> gcuCourseList = new ArrayList<GCUCourse>();
		try{
			gcuCourseList = getHibernateTemplate().find("FROM GCUCourse");
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No GCU Course found."+e+" RequestId:"+uniqueId, e);
		}
		return gcuCourseList;
	}
	@Override
	public List<TransferCourse> getTodayCompletedCourse(String institutionId){
		String userId= UserUtil.getCurrentUser().getId();
		List<TransferCourse> transferCourseList = new ArrayList<TransferCourse>();
		//try{
			String query="select c from TransferCourse c,TransferCourseMirror  cm  where c.id=cm.transferCourseId and upper(cm.evaluationStatus)='COMPLETED' " +
					" and  CONVERT(VARCHAR(10),cm.modifiedTime,111) =CONVERT(VARCHAR(10),GETDATE(),111) and cm.evaluatorId=? AND c.institution.id=?";
			transferCourseList = getHibernateTemplate().find(query,userId,institutionId);
		/*}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No transfer Course found."+e+" RequestId:"+uniqueId, e);
		}*/
		return transferCourseList;
	}
	@Override
	public void removeCourseMappingList(List<CourseMapping> courseMappingList) {
		getHibernateTemplate().deleteAll(courseMappingList);
	}
	@Override
	public void addCourseMappings(List<CourseMapping> courseMappingsList) {
		getHibernateTemplate().saveOrUpdateAll(courseMappingsList);
		
	}
	@Override
	public void removeCourseCategoryMappingList(List<CourseCategoryMapping> courseCategoryMappingList) {
		getHibernateTemplate().deleteAll(courseCategoryMappingList);
		
	}
	@Override
	public void addCourseCategoryMappingListRelationShip(
			List<CourseCategoryMapping> courseCategoryMappingList) {
		getHibernateTemplate().saveOrUpdateAll(courseCategoryMappingList);
		
	}
	@Override
	public void addTransferCourseInstitutionTranscriptKeyGradeAssocList(
			List<TransferCourseInstitutionTranscriptKeyGradeAssoc> transferCourseInstitutionTranscriptKeyGradeAssocNewList) {
		getHibernateTemplate().saveOrUpdateAll(transferCourseInstitutionTranscriptKeyGradeAssocNewList);
		
	}
	@Override
	public List<TransferCourseInstitutionTranscriptKeyGradeAssoc> loadAllTransferCourseInstitutionTranscriptKeyGradeAssocByTransferCourseId(
			String transferCourseId) {
		List<TransferCourseInstitutionTranscriptKeyGradeAssoc> transferCourseInstitutionTranscriptKeyGradeAssocList = new ArrayList<TransferCourseInstitutionTranscriptKeyGradeAssoc>();
		try{
			transferCourseInstitutionTranscriptKeyGradeAssocList = getHibernateTemplate().find("FROM TransferCourseInstitutionTranscriptKeyGradeAssoc WHERE transferCourse.id=?",new Object[]{transferCourseId});
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No TransferCourseInstitutionTranscriptKeyGradeAssoc found."+e+" RequestId:"+uniqueId, e);
		}
		return transferCourseInstitutionTranscriptKeyGradeAssocList;
	}
	@Override
	public void deleteAllGradeAssoc(
			List<TransferCourseInstitutionTranscriptKeyGradeAssoc> transferCourseInstitutionTranscriptKeyGradeAssocReadList) {
		getHibernateTemplate().deleteAll(transferCourseInstitutionTranscriptKeyGradeAssocReadList);
		
	}
	@Override
	public TransferCourseMirror findTransferCourseMirrorByTransferCourseId(
			String transferCourseId) {
		TransferCourseMirror transferCourseMirror = null;
		try{
			
			transferCourseMirror = (TransferCourseMirror)getHibernateTemplate().find("FROM TransferCourseMirror WHERE transferCourseId=?", new Object[]{transferCourseId}).get(0);
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No TransferCourseMirror found."+e+" RequestId:"+uniqueId, e);
		}
		return transferCourseMirror;
	}
	@Override
	public TransferCourseMirror findTransferCourseMirrorByTransferCourseIdAndCurrentUserId(
			String transferCourseId, String evaluatorId) {
		TransferCourseMirror transferCourseMirror = null;
		try{
			
			transferCourseMirror = (TransferCourseMirror)getHibernateTemplate().find("FROM TransferCourseMirror WHERE transferCourseId=? AND evaluatorId=?", new Object[]{transferCourseId,evaluatorId}).get(0);
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No TransferCourseMirror found."+e+" RequestId:"+uniqueId, e);
		}
		return transferCourseMirror;
	}
	
	@Override
	public GcuCourseLevel getGcuCourseLevelById(String gcuCourseLevelId) {
		GcuCourseLevel gcuCourseLevel = null;
		try{
			
			gcuCourseLevel = (GcuCourseLevel)getHibernateTemplate().find("FROM GcuCourseLevel WHERE id=? ", new Object[]{gcuCourseLevelId}).get(0);
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No gcuCourseLevel found."+e+" RequestId:"+uniqueId, e);
		}
		return gcuCourseLevel;
	}
	
	@Override
	public void addCourseRelationShipDetail(CourseMappingDetail courseMappingDetail) {
		getHibernateTemplate().saveOrUpdate(courseMappingDetail);
		
	}
	
	@Override
	public List<CourseMappingDetail> getCourseMappingDetailByCourseMappingId(
			String courseMappingId) {
		return getHibernateTemplate().find( "from CourseMappingDetail where courseMappingId= ?", courseMappingId);
	}
	@Override
	public void removeCourseMapping(CourseMapping courseMapping) {
		getHibernateTemplate().delete(courseMapping);
	}
	
	@Override
	public void removeCourseMappingDetailList(List<CourseMappingDetail> courseMappingDetailList) {
		getHibernateTemplate().deleteAll(courseMappingDetailList);
	}
	@Override
	public TransferCourse findTransferCourseByCodeAndInstitution(String courseCode,String institutionId) {
		TransferCourse transferCourse = null;
		try{
			
			transferCourse = (TransferCourse)getHibernateTemplate().find("FROM TransferCourse WHERE trCourseCode=?  AND institution.id=? ", new Object[]{courseCode,institutionId}).get(0);
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No TransferCourse found."+e+" RequestId:"+uniqueId, e);
		}
		return transferCourse;
	}
	@Override
	public void addTransferCourse(TransferCourse transferCourse) {
		getHibernateTemplate().saveOrUpdate(transferCourse);
		
	}
	@Override
	public void saveTransferCourse(TransferCourse transferCourse) {
		getHibernateTemplate().save(transferCourse);
	}
	@Override
	public void updateTransferCourse(TransferCourse transferCourse) {
		getHibernateTemplate().update(transferCourse);
	}
}
