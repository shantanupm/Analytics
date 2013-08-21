package com.ss.institution.dao;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.HibernateException;

import org.hibernate.Query;

import org.hibernate.Session;
import java.sql.SQLException;


import org.springframework.orm.hibernate3.HibernateCallback;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.ss.common.dao.BaseAbstractDAO;
import com.ss.common.util.UserUtil;
import com.ss.course.value.CourseTranscript;
import com.ss.course.value.TransferCourse;
import com.ss.evaluation.controller.EvaluationController;
import com.ss.evaluation.value.College;
import com.ss.evaluation.value.Country;
import com.ss.evaluation.value.Student;
import com.ss.evaluation.value.StudentInstitutionDegree;
import com.ss.evaluation.value.StudentInstitutionTranscript;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionAddress;
import com.ss.institution.value.InstitutionDegree;
import com.ss.institution.value.InstitutionTranscript;
import com.ss.common.logging.RequestContext;

/**
 * Interface Implementation of {@link InstitutionMgmtDao}
 * @author binoy.mathew
 */
@Repository
public class InstitutionMgmtDaoImpl extends BaseAbstractDAO<Institution, Serializable> implements InstitutionMgmtDao {

	private static transient Logger log = LoggerFactory.getLogger( InstitutionMgmtDaoImpl.class );
	@Override
	public Institution getInstitutionById( String institutionId ) {
		List<Institution> list = getHibernateTemplate().find( "from Institution where id = ? ", institutionId );
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list.get(0);
	}
	
	@Override
	public List<Institution> findByPartSchoolCode(String sc) {
		List<Institution> list = getHibernateTemplate().find( "from Institution where schoolCode like ?", sc );
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list;
	}
	
	@Override
	public List<Institution> getAllInstitutions() {
		return getHibernateTemplate().find( "from Institution i order by name");
	}
	
	@Override
	public void saveInstitutionDegree( InstitutionDegree institutionDegree ) {
		getHibernateTemplate().saveOrUpdate( institutionDegree );
	}
	
	@Override
	public void saveStudentInstitutionDegree( StudentInstitutionDegree studentInstitutionDegree ) {
		getHibernateTemplate().saveOrUpdate( studentInstitutionDegree );
	}
	
	@Override
	public Institution getInstitutionForStudentProgramEvaluation( String studentProgramEvalId ) {
		List<StudentInstitutionDegree> sidList = getHibernateTemplate().find( "from StudentInstitutionDegree where studentProgramEvaluationId = ?", studentProgramEvalId );
		if(sidList!=null && sidList.size()>0){
			StudentInstitutionDegree sid = sidList.get( 0 );
			return sid.getInstitutionDegree().getInstitution();
		}
		return null;
	}
	
	
	public List<StudentInstitutionDegree> getStudentInstitutionDegreeListForStudentInstitutionTranscript( StudentInstitutionTranscript studentInstitutionTranscript ) {
		return getHibernateTemplate().find( "from StudentInstitutionDegree where studentInstitutionTranscript.id = ?", studentInstitutionTranscript.getId() );
	}
	
	@Override
	public List<Country> getAllCountries() {
		return getHibernateTemplate().find( "from Country c order by name");
	}
	
	

	
	@Override
	public void addInstitution(Institution i) {
		getHibernateTemplate().saveOrUpdate(i);
	}
	
	@Override
	public void addCountry(Country c) {
		getHibernateTemplate().saveOrUpdate(c);
	}
	
	
	@Override
	public InstitutionDegree getInstitutionDegreeByInstituteIDAndDegreeName(
			String institutionId, String degreeName){
		List<InstitutionDegree> list = getHibernateTemplate().find( "from InstitutionDegree insDeg where insDeg.institution.id = ? and insDeg.degree=?", institutionId,degreeName);
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list.get(0);
	}
	@Override
	public List<StudentInstitutionDegree> getStudentInstitutionDegreeList(String programEvaluationId){
		List<StudentInstitutionDegree> list = getHibernateTemplate().find( "from StudentInstitutionDegree where studentProgramEvaluationId = ?", programEvaluationId );
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list;
	}

	@Override
	public Institution getInstitutionByCodeTitle(String schoolCode,
			String instituteTitle) {
		Institution institution= new Institution();
		try{
		
			DetachedCriteria criteria = DetachedCriteria.forClass(Institution.class);
			if(null!=schoolCode){
				if(  !schoolCode.isEmpty() ){
					criteria.add(Restrictions.eq("schoolcode", schoolCode));
				}
			}
			if(null !=instituteTitle ){
				if( !instituteTitle.isEmpty()){
					criteria.add(Restrictions.like("name", instituteTitle+"%"));
				}
			}
			
			List<Institution> instList=  getHibernateTemplate().findByCriteria(criteria);
			institution = instList.get( 0 );
		}catch (Exception e) {
			//log.error("No  Institution found"+e, e);
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No  Institution found."+e+" RequestId:"+uniqueId, e);
		}
		return institution;
	}

	@Override
	public List<Institution> getAllInstitutions(String institutionId) {
		DetachedCriteria criteria = DetachedCriteria.forClass(Institution.class);
		
		if( institutionId!=null && !institutionId.isEmpty()){
			criteria.add(Restrictions.ne("id", institutionId));
		}
		List<Institution> instList=getHibernateTemplate().findByCriteria(criteria);
		return instList;
	}

	@Override
	public List<Institution> getAllNotEvalutedInstitutions(){
		List<Institution> list = getHibernateTemplate().find( "from Institution inst where upper(inst.evaluationStatus) = 'NOT EVALUATED'");
		return list;
	}

	
	
	@Override
	public boolean schoolCodeExist(String schoolCode, String institutionId) {
		DetachedCriteria criteria = DetachedCriteria.forClass(Institution.class);
		criteria.add(Restrictions.eq("schoolcode", schoolCode));
		
		if(schoolCode == null ||schoolCode.isEmpty()){
			return false;
		}
		
		if(institutionId!=null && !institutionId.isEmpty()){
			criteria.add(Restrictions.ne("id", institutionId));
		}
		
		List<Institution> instList=  getHibernateTemplate().findByCriteria(criteria);
		if(instList.size()>0)
			return true;
		
		return false;
	}

	@Override
	public boolean schoolTitleExist(String schoolTitle, String institutionId) {
		DetachedCriteria criteria = DetachedCriteria.forClass(Institution.class);
		
		criteria.add(Restrictions.eq("name", schoolTitle));
		
		if(schoolTitle == null || schoolTitle.isEmpty()){
			return false;
		}
		if(institutionId!=null && !institutionId.isEmpty()){
			criteria.add(Restrictions.ne("id", institutionId));
		}
		
		List<Institution> instList=  getHibernateTemplate().findByCriteria(criteria);
		if(instList.size()>0)
			return true;
		
		return false;
		
	}

	@Override
	public Institution getOldestUnEvaluatedInstitution(){
		String userId= UserUtil.getCurrentUser().getId();
		List<Institution> instList = getHibernateTemplate().find("from Institution where upper(evaluationStatus) = 'NOT EVALUATED'  AND confirmedBy is NULL AND (checkedBy !=? OR checkedBy IS NULL) ORDER BY createdDate ASC",userId);
		if(instList.size() == 0){
			return null;
		}
		return instList.get(0);
	}
	
	@Override
	public List<Institution> getNotEvaluatedInstitutionListForJob(){
		List<Institution> instList= new ArrayList<Institution>();
		try{
		 instList = getHibernateTemplate().find("from Institution where upper(evaluationStatus) = 'NOT EVALUATED' and checkedBy IS NOT NULL and confirmedBy IS NOT NULL");
		}catch (Exception e) {
			//log.error("Error"+e,e);
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Exception Occured."+e+" RequestId:"+uniqueId, e);
		}
		return instList;
	}
	
	@Override
	public List<Institution> getAllConflictInstitutions(){
		
		List<Institution> list = getHibernateTemplate().find( "from Institution  where upper(evaluationStatus) = 'CONFLICT'");
		return list;
	}
	
	@Override
	public List<Institution> getAllEvaluatedInstitutions(){
		
		List<Institution> list = getHibernateTemplate().find("from Institution  where upper(evaluationStatus) = 'EVALUATED'");
		return list;
	}
	
	@Override
	public List<Institution>  getInstitutionsList(String searchBy, String searchText,String status, String byState){
		
		List<Institution> institutionList = null;
		try{
		
			DetachedCriteria criteria = DetachedCriteria.forClass(Institution.class);
			if(null!=searchBy){
				if(  !searchBy.isEmpty() ){
					if(null!=searchText){
						if(  !searchText.isEmpty() ){
							if(searchBy.equalsIgnoreCase("1")){
								criteria.add(Restrictions.eq("institutionID", Integer.parseInt(searchText)));
							}
							else if(searchBy.equalsIgnoreCase("2")){
								criteria.add(Restrictions.like("name", searchText+"%"));
							}else if(searchBy.equalsIgnoreCase("3")){								
								if (searchText.substring(0,2).equalsIgnoreCase("FC")){
									criteria.add(Restrictions.ne("country.id", "1"));
								}else{
									criteria.add(Restrictions.like("state", searchText+"%"));
								}
							}
						}
					}
				}
			}
			if(null != status ){
				if( !status.isEmpty()){
					if(!"ALL".equals(status)){
						criteria.add(Restrictions.eq("evaluationStatus", status));
					}
				}
			}
			if(null!=byState && !searchBy.equalsIgnoreCase("3")){
				if(  !byState.isEmpty() ){
					if (byState.substring(0,2).equalsIgnoreCase("FC")){
						criteria.add(Restrictions.ne("country.id", "1"));
					}else{
						criteria.add(Restrictions.like("state", byState+"%"));
					}
				}
			}
			
			institutionList =  getHibernateTemplate().findByCriteria(criteria);
		}catch (Exception e) {
			//log.error("No  Institution found"+e, e);
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No  Institution found."+e+" RequestId:"+uniqueId, e);
		}
		return institutionList;
	}

	@Override
	public void skipInstitutionNCourse(String institutionId){
		String userId= UserUtil.getCurrentUser().getId();
		String queryString="UPDATE Institution SET createdDate = CURRENT_TIMESTAMP WHERE upper(evaluationStatus) = 'NOT EVALUATED' AND id=?";
		/*String queryString="UPDATE Institution SET createdDate = CURRENT_TIMESTAMP WHERE upper(evaluationStatus) = 'NOT EVALUATED' AND id=?" +
				"AND id NOT IN(select id from Institution where (checkedBy=? and checkedStatus='COMPLETED') " +
				" OR  (confirmedBy=? and confirmedStatus='COMPLETED') )";*/
		getHibernateTemplate().bulkUpdate(queryString, institutionId);
		
		String queryString1="UPDATE TransferCourse SET createdDate = CURRENT_TIMESTAMP WHERE upper(evaluationStatus) = 'NOT EVALUATED' AND institution.id=?" ;
		/*String queryString1="UPDATE TransferCourse SET createdDate = CURRENT_TIMESTAMP WHERE upper(evaluationStatus) = 'NOT EVALUATED' AND institution.id=?" +
				"AND id NOT IN(select id from TransferCourseMirror where evaluationStatus='COMPLETED' and evaluatorId=?)";*/
		getHibernateTemplate().bulkUpdate(queryString1, institutionId);
		resetConfirmByCheckedBy(institutionId);
	}
	
	@Override
	public void resetConfirmByCheckedBy(String institutionId){
		String userId= UserUtil.getCurrentUser().getId();
		String checkedByString="UPDATE Institution SET checkedBy = NULL WHERE upper(evaluationStatus) = 'NOT EVALUATED' AND id=? and checkedBy=? and (checkedStatus!='COMPLETED' OR checkedStatus IS NULL)";
		int result=getHibernateTemplate().bulkUpdate(checkedByString, institutionId,userId);
		if(result==0){
			String confirmedByString="UPDATE Institution SET confirmedBy = NULL WHERE upper(evaluationStatus) = 'NOT EVALUATED' AND id=? and confirmedBy=?  and (confirmedStatus!='COMPLETED' OR confirmedStatus IS NULL)";
			getHibernateTemplate().bulkUpdate(confirmedByString, institutionId,userId);
			
		}
		String checkedByCourseString="UPDATE TransferCourse SET checkedBy = NULL WHERE upper(evaluationStatus) = 'NOT EVALUATED' AND institution.id=? and checkedBy=?" +
				"AND id NOT IN(select transferCourseId from TransferCourseMirror where evaluationStatus='COMPLETED' and evaluatorId=?)";
		int resultCourse=getHibernateTemplate().bulkUpdate(checkedByCourseString, institutionId,userId,userId);
		if(resultCourse==0){
			String confirmedByCourseString="UPDATE TransferCourse SET confirmedBy = NULL WHERE upper(evaluationStatus) = 'NOT EVALUATED' AND institution.id=? and confirmedBy=?" +
					"AND id NOT IN(select transferCourseId from TransferCourseMirror where evaluationStatus='COMPLETED' and evaluatorId=?)";
			getHibernateTemplate().bulkUpdate(confirmedByCourseString, institutionId,userId,userId);
			
		}
	}
	@Override
	public List<Institution> getInstitutionsForReassignment(){
		String query="select i from Institution i  where  upper(i.evaluationStatus) = 'NOT EVALUATED'" +
				" and (i.checkedBy IS NOT NULL OR i.confirmedBy IS NOT NULL)";
				
		List<Institution> list = getHibernateTemplate().find(query);
		if(list != null && list.size()!=0){
			return list;
		}
		else return null;
	}
	
	@Override
	public void reAssignCoursesOfInstitution(final String institutionId, final String toId, final String fromId){
	/*	String queryString = "UPDATE TransferCourse tc, TransferCourseMirror tcm SET tc.checkedBy=? , tcm.evaluatorId=? WHERE tc.institution.id = ? AND tc.checkedBy=? AND tc.id=tcm.transferCourseId AND tcm.evaluationStatus='TEMP'";
		getHibernateTemplate().bulkUpdate(queryString, toId, toId, institutionId, fromId);
		String queryString1 = "UPDATE TransferCourse tc, TransferCourseMirror tcm SET tc.confirmedBy=? , tcm.evaluatorId=? WHERE tc.institution.id = ? AND tc.confirmedBy=? AND tc.id=tcm.transferCourseId AND tcm.evaluationStatus='TEMP'";
		getHibernateTemplate().bulkUpdate(queryString1, toId, toId, institutionId, fromId);
	*/	
		
		
		
		Integer updatedData = (Integer)getHibernateTemplate().execute(new HibernateCallback () {
		    public Object doInHibernate(Session session) throws HibernateException, SQLException {
		        // update courses which are checked by fromId
		       /* Query updateQuery = session.createSQLQuery(
		        		"UPDATE ss_tbl_transfer_course tc, ss_tbl_transfer_course_mirror tcm SET tc.checked_by=? , tcm.evaluator_id=? " +
		        		"WHERE tc.institution_id = ? AND tc.checked_by=? AND tc.id=tcm.transfer_course_id AND tcm.evaluation_status='TEMP'");*/
		    	Query updateQueryCheckedMain = session.createSQLQuery(
			        		"update tc  set checked_by=?  FROM ss_tbl_transfer_course tc INNER  Join  ss_tbl_transfer_course_mirror tcm"+
			        		" on tc.id=tcm.transfer_course_id where  tc.institution_id =? AND tc.checked_by=? AND tcm.evaluation_status='TEMP'");
		    	updateQueryCheckedMain.setString(0, toId);
		    	updateQueryCheckedMain.setString(1, institutionId);
		    	updateQueryCheckedMain.setString(2, fromId);
		        int updatedChecked = updateQueryCheckedMain.executeUpdate();
		        
		        Query updateQueryCheckedMirror = session.createSQLQuery(
		        		"update tcm  set evaluator_id=?  FROM ss_tbl_transfer_course_mirror tcm INNER  JOIN  ss_tbl_transfer_course tc" +
		        		" on tc.id=tcm.transfer_course_id where  tc.institution_id = ? AND tc.checked_by=? AND tcm.evaluation_status='TEMP'");
		        updateQueryCheckedMirror.setString(0, toId);
		        updateQueryCheckedMirror.setString(1, institutionId);
		        updateQueryCheckedMirror.setString(2, fromId);
		        int updatedChecked1 = updateQueryCheckedMirror.executeUpdate();
		      
		        
		        // update courses which are confirmed by fromId
		      /*  Query updateQuery1 = session.createSQLQuery(
		        		"UPDATE ss_tbl_transfer_course tc, ss_tbl_transfer_course_mirror tcm SET tc.confirmed_by=? , tcm.evaluator_id=? " +
		        		"WHERE tc.institution_id = ? AND tc.confirmed_by=? AND tc.id=tcm.transfer_course_id AND tcm.evaluation_status='TEMP'");*/
		        Query updateQueryConfirmMain = session.createSQLQuery(
		        		"update tc  set confirmed_by=?  FROM ss_tbl_transfer_course tc INNER  Join  ss_tbl_transfer_course_mirror tcm"+
		        		" on tc.id=tcm.transfer_course_id where  tc.institution_id =? AND tc.confirmed_by=? AND tcm.evaluation_status='TEMP'");
		        updateQueryConfirmMain.setString(0, toId);
		        updateQueryConfirmMain.setString(1, institutionId);
		        updateQueryConfirmMain.setString(2, fromId);
		        int updatedConfirm = updateQueryConfirmMain.executeUpdate();
		        
		        Query updateQueryConfirmMirror = session.createSQLQuery(
		        		"update tcm  set evaluator_id=?  FROM ss_tbl_transfer_course_mirror tcm INNER  JOIN  ss_tbl_transfer_course tc" +
		        		" on tc.id=tcm.transfer_course_id where  tc.institution_id = ? AND tc.confirmed_by=? AND tcm.evaluation_status='TEMP'");
		        updateQueryConfirmMirror.setString(0, toId);
		        updateQueryConfirmMirror.setString(1, institutionId);
		        updateQueryConfirmMirror.setString(2, fromId);
		        int updatedConfirm1 = updateQueryConfirmMirror.executeUpdate();
		        
		        return updatedChecked+updatedConfirm;
		    }
		});
		if (log.isDebugEnabled()) {
		    log.debug("rows updated for courses reassignment : " + updatedData);
		}
		
	}

	@Override
	public void addInstitutionTranscript(InstitutionTranscript it) {
		getHibernateTemplate().saveOrUpdate(it);
	}
	
	@Override
	public InstitutionTranscript getInstitutionTranscript(String institutionId){
		List<InstitutionTranscript> list = getHibernateTemplate().find("FROM InstitutionTranscript WHERE institutionId=? ORDER BY modifiedDate ",institutionId);
		if(list!=null&&list.size()!=0){
			return list.get(0);
		}
		else return null;
		
	}

	@Override
	public List<Institution> findInstituteForState(String state) {
		// TODO Auto-generated method stub
		try{
			
			DetachedCriteria criteria = DetachedCriteria.forClass(Institution.class);
			if(!state.equals("FC")){
				criteria.add(Restrictions.like("state", state+"%"));
				criteria.add(Restrictions.eq("country.id", "1"));
			}
			else
				criteria.add(Restrictions.ne("country.id", "1"));
			
			List<Institution> instituteList=  getHibernateTemplate().findByCriteria(criteria);
		if(instituteList!=null && instituteList.size()>0){
			return instituteList;
		}else 
			return null;
	}catch (Exception e) {
		//log.error("No  Institution found"+e, e);
		String uniqueId = RequestContext.getRequestIdFromContext();
		log.error("No  Institution found."+e+" RequestId:"+uniqueId, e);
		return null;
	}
	}
	@Override
	public List<Institution> findInstituteForEvalutationForCurrentUserNotIn(String currenUserId,
			List<String> institutionIds) {
		return getHibernateTemplate().findByNamedParam("from Institution where upper(evaluationStatus) = 'NOT EVALUATED'  AND confirmedBy is NULL AND (checkedBy !=:currentUserId OR checkedBy IS NULL) AND id NOT IN(:institutionIds) ORDER BY createdDate ASC", new String[]{"currentUserId","institutionIds"}, new Object[]{currenUserId,institutionIds});
	}

	@Override
	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptAwatingForIENotIn(
			List<String> institutionIds) {
		return getHibernateTemplate().findByNamedParam("SELECT DISTINCT(sit) FROM StudentInstitutionTranscript sit WHERE sit.institution.id NOT IN(:institutionIds) AND upper(sit.evaluationStatus)='AWAITING IE'",new String[]{"institutionIds"}, new Object[]{institutionIds});
	}
	@Override
	public List<Institution> getInstitutionByState(String stateCode,String title){
		List<Institution> list = new ArrayList<Institution>();
		try {
			list = getHibernateTemplate().find("SELECT DISTINCT(i) FROM Institution i , InstitutionAddress a WHERE i.id=a.institutionId AND a.state=? AND i.name LIKE ?",stateCode,title+"%");
		}
		 catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No  Institution found."+e+" RequestId:"+uniqueId, e);
		}
		return list;
	}
	
	@Override
	public List<InstitutionAddress> getInstitutionAddresses(String institutionId){
		DetachedCriteria criteria = DetachedCriteria.forClass(InstitutionAddress.class);
		criteria.add(Restrictions.eq("institutionId", institutionId));
		List<InstitutionAddress> list = new ArrayList<InstitutionAddress>();
		try {
			list = getHibernateTemplate().findByCriteria(criteria);
		}
		 catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No  Institution Address Found."+e+" RequestId:"+uniqueId, e);
		}
		return list;
	}
	
	@Override
	public InstitutionAddress getInstitutionAddress(String addressId){
		DetachedCriteria criteria = DetachedCriteria.forClass(InstitutionAddress.class);
		criteria.add(Restrictions.eq("id", addressId));
		InstitutionAddress institutionAddress = new InstitutionAddress();
		try {
			List<InstitutionAddress> 	list = getHibernateTemplate().findByCriteria(criteria);
			if(list!=null&&list.size()!=0){
				institutionAddress=list.get(0);
			}
		}
		 catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No  Institution Address Found."+e+" RequestId:"+uniqueId, e);
		}
		return institutionAddress;
	}
	
	@Override
	public void addInstitutionAddress(InstitutionAddress institutionAddress) {
		getHibernateTemplate().saveOrUpdate(institutionAddress);
	}
	
	@Override
	public boolean institutionInTranscriptExist(String studentId, String institutionId) {
		
		List<StudentInstitutionTranscript> list = new ArrayList<StudentInstitutionTranscript>();
		try {
			list = getHibernateTemplate().find("SELECT s FROM StudentInstitutionTranscript s where s.student.id=? and s.institution.id=?",studentId,institutionId);
		}
		 catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No  Transcript  found."+e+" RequestId:"+uniqueId, e);
		}
		 if(list.size()>0)
				return true;
		return false;
	}
	@Override
	public Institution getInstitutionByTitle(	String instituteTitle) {
		Institution institution = null;
		try{
		
			DetachedCriteria criteria = DetachedCriteria.forClass(Institution.class);
			
			if(null !=instituteTitle ){
				if( !instituteTitle.isEmpty()){
					criteria.add(Restrictions.eq("name", instituteTitle));
				}
			}
			
			List<Institution> instList=  getHibernateTemplate().findByCriteria(criteria);
			if(instList!=null && instList.size()>0)
				institution = instList.get( 0 );
		}catch (Exception e) {
			//log.error("No  Institution found"+e, e);
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No  Institution found."+e+" RequestId:"+uniqueId, e);
		}
		return institution;
	}

	@Override
	public int getTotalEvaluated(String userId){
        final String query="select (select count(id) from ss_tbl_institution where evaluationStatus='EVALUATED' and (checked_by=? or confirmed_by=?))+(" +
        		"select count(id) from ss_tbl_transfer_course where evaluation_status='EVALUATED' and (checked_by=? or confirmed_by=?))";

		return getIntCountFromQuery(query,userId);
		
	}
	
	@Override
	public int getLast6MonthEvaluated(String userId){
        final String query="select (select count(id) from ss_tbl_institution where evaluationStatus='EVALUATED' and (checked_by=? or confirmed_by=?) " +
        		" AND modified_date>=DATEADD(month, -6, GETDATE()) )+(" +
        		"select count(id) from ss_tbl_transfer_course where evaluation_status='EVALUATED' and (checked_by=? or confirmed_by=?)" +
        				"AND modified_date>=DATEADD(month, -6, GETDATE()))";

		return getIntCountFromQuery(query,userId);
		
	}
	
	@Override
	public int getLast7DaysEvaluated(String userId){
        final String query="select (select count(id) from ss_tbl_institution where evaluationStatus='EVALUATED' and (checked_by=? or confirmed_by=?) " +
        		" AND modified_date>=DATEADD(day, -7, GETDATE()) )+(" +
        		"select count(id) from ss_tbl_transfer_course where evaluation_status='EVALUATED' and (checked_by=? or confirmed_by=?)" +
        				"AND modified_date>=DATEADD(day, -7, GETDATE()))";

		return getIntCountFromQuery(query,userId);
		
	}

	
	@Override
	public int getLast3MonthEvaluated(String userId){
        final String query="select (select count(id) from ss_tbl_institution where evaluationStatus='EVALUATED' and (checked_by=? or confirmed_by=?) " +
        		" AND modified_date>=DATEADD(month, -3, GETDATE()) )+(" +
        		"select count(id) from ss_tbl_transfer_course where evaluation_status='EVALUATED' and (checked_by=? or confirmed_by=?)" +
        				"AND modified_date>=DATEADD(month, -3, GETDATE()))";

		return getIntCountFromQuery(query,userId);
		
	}
	
	@Override
	public int getTodaysEvaluated(String userId){
        final String query="select (select count(id) from ss_tbl_institution where evaluationStatus='EVALUATED' and (checked_by=? or confirmed_by=?) " +
        		" AND modified_date>=dateadd(dd,datediff(dd,0,getdate()),0))+(" +
        		"select count(id) from ss_tbl_transfer_course where evaluation_status='EVALUATED' and (checked_by=? or confirmed_by=?)" +
        				"AND modified_date>=dateadd(dd,datediff(dd,0,getdate()),0))";

		return getIntCountFromQuery(query,userId);
		
	}
	
	
	public int getIntCountFromQuery(final String queryStr, final String userId) {
		String tempCount = null;
		List<Long> list = getHibernateTemplate().executeFind(
				new HibernateCallback() {
					@Override
					public Object doInHibernate(Session s)
							throws HibernateException, SQLException {
						Query query = s.createSQLQuery(queryStr);
						query.setString(0, userId);
						query.setString(1, userId);
						query.setString(2, userId);
						query.setString(3, userId);

						List<Long> l = query.list();
						return l;
					}
				});

		if (list.get(0) != null) {
			tempCount = String.valueOf(list.get(0));
			int count = Integer.valueOf(tempCount);
			return count;
		} else {
			return 0;
		}

	}
	
	@Override
	public Institution getAssignedInstitution(){
		String userId= UserUtil.getCurrentUser().getId();
		List<Institution> instList = new ArrayList<Institution>();
		String queryCheckedBy="from Institution where upper(evaluationStatus) = 'NOT EVALUATED'   AND checkedBy =? AND (checkedStatus!='COMPLETED' OR checkedStatus IS NULL) ORDER BY createdDate ASC";
		String queryConfirmedBy="from Institution where upper(evaluationStatus) = 'NOT EVALUATED'   AND confirmedBy =? AND (confirmedStatus!='COMPLETED' OR confirmedStatus IS NULL) ORDER BY createdDate ASC";
		 instList = getHibernateTemplate().find(queryCheckedBy,userId);
		if(instList.size() == 0){
			instList=getHibernateTemplate().find(queryConfirmedBy,userId);
			if(instList.size()==0){
				return null;
			}
		}
		return instList.get(0);
	}
	
	
	
	@Override
	public boolean institutionCodeExist(String  institutionCode, String institutionId) {
		DetachedCriteria criteria = DetachedCriteria.forClass(Institution.class);
		criteria.add(Restrictions.eq("institutionID", institutionCode));
		
		if(institutionCode == null || institutionCode.isEmpty()){
			return false;
		}
		if(institutionId!=null && !institutionId.isEmpty()){
			criteria.add(Restrictions.ne("id", institutionId));
		}
		
		List<Institution> instList=  getHibernateTemplate().findByCriteria(criteria);
		if(instList.size()>0)
			return true;
		
		return false;
		
	}
	@Override
	public List<College> findAllCollege() {
		List<College> collegeList = new ArrayList<College>();
		try{											  
			collegeList = getHibernateTemplate().find("FROM College");
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No College found."+e+" RequestId:"+uniqueId, e);
		}
	    return collegeList;	
	}
	@Override
	public void saveInstitution(Institution institution) {
		getHibernateTemplate().save(institution);
		
	}
	@Override
	public void updateInstitution(Institution institution) {
		getHibernateTemplate().update(institution);
		
	}

	@Override
	public Student getLastStudentbyInstitutionId( String institutionId ) {
		String queryString="select  st from StudentInstitutionTranscript sit ,Student st " +
				" where sit.institution.id=? and sit.student.id=st.id order by sit.modifiedDate desc ";
		List<Student> list=null;
		try{	
			list = getHibernateTemplate().find(queryString,institutionId);
			if( list == null || list.size() == 0 ) {
				return null;
			}
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No Student found."+e+" RequestId:"+uniqueId, e);
		}
		
		return list.get(0);
	}
}
