package com.ss.evaluation.dao;

import java.io.Serializable;
import java.math.BigInteger;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.stereotype.Repository;

import com.ss.common.dao.BaseAbstractDAO;
import com.ss.common.logging.RequestContext;
import com.ss.course.value.GCUDegree;
import com.ss.evaluation.enums.TranscriptStatusEnum;
import com.ss.evaluation.value.ChartValueObject;
import com.ss.evaluation.value.Student;
import com.ss.evaluation.value.StudentInstitutionTranscript;
import com.ss.evaluation.value.StudentProgramEvaluation;
import com.ss.evaluation.value.StudentTranscriptCourse;
import com.ss.institution.dao.InstitutionMgmtDaoImpl;
import com.ss.institution.value.Institution;
import com.ss.user.value.User;

/**
 *	Dao Implementation for operations on a Student Evaluation.
 */
@Repository
public class StudentEvaluationDaoImpl extends BaseAbstractDAO<StudentProgramEvaluation, Serializable>  implements StudentEvaluationDao {

	private static transient Logger log = LoggerFactory.getLogger( StudentEvaluationDaoImpl.class );
	@Override
	public void saveStudentProgramEvaluation( StudentProgramEvaluation studentProgramEvaluation ) {
		getHibernateTemplate().saveOrUpdate( studentProgramEvaluation );
	}
	
	@Override
	public StudentProgramEvaluation getEvaluationForStudentCrmIdAndProgramCode( String studentCrmId, String programVersionCode ) {
		List<StudentProgramEvaluation> evalList = getHibernateTemplate().find( "from StudentProgramEvaluation where studentId = ? and programVersionCode = ?", studentCrmId, programVersionCode );
		if( evalList == null || evalList.size() == 0 ) {
			return null;
		}
		
		return evalList.get(0);
	}

	@Override
	public StudentProgramEvaluation getEvaluationForStudentByCrmId( String studentCrmId ) {
		List<StudentProgramEvaluation> evalList = getHibernateTemplate().find( "from StudentProgramEvaluation where studentId = ? ", studentCrmId );
		if( evalList == null || evalList.size() == 0 ) {
			return null;
		}
		
		return evalList.get(0);
	}
	
	@Override
	public void saveStudentInstitutionTranscript( StudentInstitutionTranscript studentInstitutionTranscript ) {
		getHibernateTemplate().saveOrUpdate( studentInstitutionTranscript );
	}
	
	@Override
	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptForStudentProgramEval( StudentProgramEvaluation studentProgramEvaluation ) {
		//List<StudentInstitutionTranscript> sitList = getHibernateTemplate().find( "from StudentInstitutionTranscript sit join fetch sit.institutionDegreeSet idset where sit.studentProgramEvaluation.id = ? order by sit.id", studentProgramEvaluation.getId() );
		List<StudentInstitutionTranscript> sitList = getHibernateTemplate().find( "from StudentInstitutionTranscript sit where sit.studentProgramEvaluation.id = ? order by sit.createdDate", studentProgramEvaluation.getId() );
		return sitList;
	}
	
	
	@Override
	public StudentInstitutionTranscript getStudentInstitutionTranscriptForStudentAndInstitution( String studentId, String institutionId ) {
		List<StudentInstitutionTranscript> sitList = getHibernateTemplate().find( "from StudentInstitutionTranscript sit where sit.studentProgramEvaluation.studentId = ? and sit.institution.id = ?", studentId, institutionId );
		if( sitList == null || sitList.size() == 0 ) {
			return null;
		}
		
		return sitList.get(0);
	}
	
	
	@Override
	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptListForStudentAndInstitution( String studentId, String institutionId ) {
		List<StudentInstitutionTranscript> sitList = getHibernateTemplate().find( "from StudentInstitutionTranscript sit where sit.student.id = ? and sit.institution.id = ?", studentId, institutionId );
		if( sitList == null || sitList.size() == 0 ) {
			return null;
		}
		
		return sitList;
	}
	
	
	@Override
	public StudentInstitutionTranscript getStudentInstitutionTranscriptById( String studentInstitutionTranscriptId ) {
		List<StudentInstitutionTranscript> sitList = getHibernateTemplate().find( "from StudentInstitutionTranscript sit where sit.id = ?", studentInstitutionTranscriptId );
		if( sitList == null || sitList.size() == 0 ) {
			return null;
		}
		
		return sitList.get(0);
	}
	
	@Override
	public void removeStudentInstitutionTranscript( List<StudentInstitutionTranscript> studentInstitutionTranscriptList ) {
		getHibernateTemplate().deleteAll( studentInstitutionTranscriptList );
	}
	
	@Override
	public List<StudentInstitutionTranscript> getUnofficialStudentInstitutionTranscriptList(){
		List<StudentInstitutionTranscript> sitList = getHibernateTemplate().find("from StudentInstitutionTranscript sit where sit.official=? order by sit.createdDate",false);
		return sitList;
	}
	
	@Override
	public List<StudentInstitutionTranscript> getOfficialStudentInstitutionTranscriptList(){
		List<StudentInstitutionTranscript> sitList = getHibernateTemplate().find("from StudentInstitutionTranscript sit where sit.official=? order by sit.createdDate",true);
		return sitList;
	}
	
	@Override
	public List<StudentInstitutionTranscript> getAwaitingIEorIEMSITList(){
		List<StudentInstitutionTranscript> sitList = getHibernateTemplate().find("from StudentInstitutionTranscript sit where upper(sit.evaluationStatus) like 'AWAITING IE%' order by sit.createdDate");
		return sitList;
	}
	
	@Override
	public StudentInstitutionTranscript getOldestSITForLOPES(){
		List<StudentInstitutionTranscript> sitList = getHibernateTemplate().find("from StudentInstitutionTranscript sit where upper(sit.evaluationStatus) = 'AWAITING LOPE' order by sit.createdDate");
		if(sitList!=null&&sitList.size()>0){
			return sitList.get(0);
		}
		else return null;
	}
	
	@Override
	public StudentInstitutionTranscript getOldestSITForSLE(){
		List<StudentInstitutionTranscript> sitList = getHibernateTemplate().find("from StudentInstitutionTranscript sit where upper(sit.evaluationStatus) = 'AWAITING SLE' order by sit.createdDate");
		if(sitList!=null&&sitList.size()>0){
			return sitList.get(0);
		}
		else return null;
	}
	
	@Override
	public List<StudentInstitutionTranscript> getAllSITListOrderByStatus(){
		List<StudentInstitutionTranscript> sitList = getHibernateTemplate().find("from StudentInstitutionTranscript sit order by sit.evaluationStatus");
		return sitList;
	}

	@Override
	public List<StudentInstitutionTranscript> getAllSITList(String status, String crmId){
		List<StudentInstitutionTranscript> sitList = null;
		try{
		
			DetachedCriteria criteria = DetachedCriteria.forClass(StudentInstitutionTranscript.class);
		
			if(null != status ){
				if( !status.isEmpty()){
					criteria.add(Restrictions.eq("evaluationStatus", status));
				}
			}
		
			if(null != crmId ){
				if( !crmId.isEmpty()){
					criteria.add(Restrictions.eq("spe.studentId", crmId));
				}
			}
			//criteria.addOrder(Order.asc("evaluationStatus"));
			criteria.createAlias("studentProgramEvaluation", "spe");
			criteria.addOrder(Order.asc("spe.studentId"));
			sitList =  getHibernateTemplate().findByCriteria(criteria);
		}catch (Exception e) {
			//log.error("No  Transcript found"+e, e);
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No  Transcript found."+e+" RequestId:"+uniqueId, e);
		}
		return sitList;
		
	}

	@Override
	public int getTotalTranscripts(String userId){
		List list = getHibernateTemplate().find("SELECT count(id) FROM StudentInstitutionTranscript WHERE  createdBy=?",userId );
        Long count = (Long) list.get(0);
        return count.intValue();
	}
	@Override
	public int getLastMonthTranscripts(String userId){
		
		//final String query="SELECT COUNT(id) FROM ss_tbl_student_institution_transcript WHERE created_by="+userId+" AND MONTH(created_date)=MONTH(DATE_SUB(CURRENT_DATE , INTERVAL 1 MONTH))";
		final String query="SELECT COUNT(id) FROM ss_tbl_student_institution_transcript WHERE  created_by='"+userId+"'   AND created_date>=DATEADD(month, -1, GETDATE())";
		
		try{
			String tempCount=null;
	        List<Long> list=getHibernateTemplate().executeFind(new HibernateCallback() {
	        	@Override
	        	public Object doInHibernate(Session s)
	        	throws HibernateException, SQLException {
	        	List<Long> l=s.createSQLQuery(query).list();
	        	return l;
	        	}
	        });
	        
	        if(list.get(0)!=null )
	        {
		        tempCount=String.valueOf(list.get(0));
		        int count=Integer.valueOf(tempCount);
		        return count;
	        }else{
	        	return 0;	
	        }
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Exception Occured."+e+" RequestId:"+uniqueId, e);
		} 	
		try{
			String tempCount=null;
	        List<Long> list=getHibernateTemplate().executeFind(new HibernateCallback() {
	        	@Override
	        	public Object doInHibernate(Session s)
	        	throws HibernateException, SQLException {
	        	List<Long> l=s.createSQLQuery(query).list();
	        	return l;
	        	}
	        });
	        
	        if(list.get(0)!=null )
	        {
		        tempCount=String.valueOf(list.get(0));
		        int count=Integer.valueOf(tempCount);
		        return count;
	        }else{
	        	return 0;	
	        }
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Exception Occured."+e+" RequestId:"+uniqueId, e);
		} 	

		return 0;
	}
	@Override
	public int getLast7DaysTranscripts(String userId){
		
        //final String query="SELECT COUNT(id) FROM ss_tbl_student_institution_transcript WHERE created_by="+userId+" AND created_date>=DATE_SUB(CURRENT_DATE ,INTERVAL 7 DAY)";
        final String query="SELECT COUNT(id) FROM ss_tbl_student_institution_transcript WHERE  created_by='"+userId+"' AND created_date>=DATEADD(day, -7, GETDATE())";

		String tempCount=null;
        List<Long> list=getHibernateTemplate().executeFind(new HibernateCallback() {
        	@Override
        	public Object doInHibernate(Session s)
        	throws HibernateException, SQLException {
        	List<Long> l=s.createSQLQuery(query).list();
        	return l;
        	}
        });
        
        if(list.get(0)!=null )
        {
	        tempCount=String.valueOf(list.get(0));
	        int count=Integer.valueOf(tempCount);
	        return count;
        }else{
        	return 0;	
        }
	}
	@Override
	public int getTodaysTranscripts(String userId){
		String sql="SELECT COUNT(id) FROM StudentInstitutionTranscript WHERE createdBy=? AND createdDate=current_date()";
		List list = getHibernateTemplate().find(sql,userId );
        Long count = (Long) list.get(0);
        return count.intValue();
	}
	
	@Override
	public List<ChartValueObject> getChartValues( final String userId){
		
		/*List results = getHibernateTemplate().find("SELECT CONCAT(cast(MONTH(createdDate) as string),' ',cast(YEAR(createdDate) as string)) ,COUNT(id) " +
				" FROM StudentInstitutionTranscript " +
				" WHERE createdBy=? GROUP BY MONTH(createdDate),YEAR(createdDate)  ",userId);*/
		
		final String msSqlQuery=	"SELECT  D,LEFT(cast(DATENAME(month,D)as varchar),3)+' '+cast(YEAR(D)as varchar) t1 ," +
			" count (id) t2 FROM (SELECT CAST(CAST(YEAR(created_date) AS VARCHAR(4)) " +
			"+ RIGHT('0' + CAST(month(created_date) AS VARCHAR(2)), 2) + '01' AS DATETIME) AS D," +
			" ID FROM ss_tbl_student_institution_transcript  where created_by='"+userId+"'    ) a  " +
			" GROUP BY D  ORDER BY 1";
	
		
	List results=(List)getHibernateTemplate().execute(new HibernateCallback<List>() {
    	@Override
    	public List doInHibernate(Session s) throws HibernateException, SQLException {
    		SQLQuery sq=s.createSQLQuery(msSqlQuery);
    			//sq.setString("userId",userId);
    		return 	sq.list();
    	
    	}
    });
	
	//List results = getHibernateTemplate().find(msSqlQuery,userId);	
		
		List<ChartValueObject> chartList= new ArrayList<ChartValueObject>();
		ChartValueObject chartValueObject;
		for (Iterator iter = results.iterator(); iter.hasNext(); ) {
			chartValueObject= new ChartValueObject();
		    Object[] objs = (Object[])iter.next();
		    
		     chartValueObject.setxValue((String)objs[1]);
		     chartValueObject.setyValue(String.valueOf(objs[2]));
		     chartList.add(chartValueObject);
		}
		return chartList;
	}

	@Override
	public void mergeStudentInstitutionTranscript(
			StudentInstitutionTranscript sit) {
		getHibernateTemplate().merge(sit);
		
	}
	@Override
	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptForStudent(Student student) {
		List<StudentInstitutionTranscript> sitList = getHibernateTemplate().find( "from StudentInstitutionTranscript sit where sit.student.id = ? order by sit.createdDate", student.getId() );
		return sitList;
	}

	@Override
	public List<StudentInstitutionTranscript> getAllRejectedSITByUser(User user) {
		List<StudentInstitutionTranscript> sitList = getHibernateTemplate().find("from StudentInstitutionTranscript sit where upper(sit.evaluationStatus) like 'REJECTED%' and sit.createdBy = ? order by sit.modifiedDate",user.getId());
	    return sitList;
	}
	@Override
	public List<StudentInstitutionTranscript> findDistinctRejectedSITByUser(
			User user) {
		List<StudentInstitutionTranscript> sitList = new ArrayList<StudentInstitutionTranscript>();
		try{											  
			sitList = getHibernateTemplate().find("SELECT DISTINCT(sit) from StudentInstitutionTranscript sit where upper(sit.evaluationStatus) like 'REJECTED%' and sit.createdBy = ?  AND sit.student.id IN(SELECT DISTINCT(sit2.student.id) FROM StudentInstitutionTranscript sit2 WHERE sit2.institution.id IN(SELECT DISTINCT(sit3.institution.id) FROM StudentInstitutionTranscript sit3 WHERE sit3.createdBy=?))",new Object[]{user.getId(),user.getId()});
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No Rejected Transcript found."+e+" RequestId:"+uniqueId, e);
		}
	    return sitList;
	}
	@Override
	public List<StudentInstitutionTranscript> findAllRejectedSITByUserForStudentAndInstitute(
			String studentId, String instituteId, User user) {
		List<StudentInstitutionTranscript> sitList = new ArrayList<StudentInstitutionTranscript>();
		try{											  
			sitList = getHibernateTemplate().find("FROM StudentInstitutionTranscript sit where upper(sit.evaluationStatus) LIKE 'REJECTED%' AND sit.createdBy = ? AND sit.student.id=? AND sit.institution.id=? order by sit.createdDate",new Object[]{user.getId(),studentId,instituteId});
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No Rejected Transcript found."+e+" RequestId:"+uniqueId, e);
		}
	    return sitList;
	}
	@Override
	public List<StudentTranscriptCourse> findAllRejectedSTCByUserForStudentAndInstitute(
			String studentInstitutionTranscriptId, String studentId,
			String institutionId, User user) {
		List<StudentTranscriptCourse> stcList = new ArrayList<StudentTranscriptCourse>();
		try{											  
			stcList = getHibernateTemplate().find("FROM StudentTranscriptCourse stc where upper(stc.transcriptStatus) LIKE 'REJECTED%' AND stc.createdBy = ? AND stc.studentInstitutionTranscript.id=?  AND stc.studentInstitutionTranscript.student.id=? AND stc.institution.id=? order by stc.createdDate",new Object[]{user.getId(),studentInstitutionTranscriptId,studentId,institutionId});
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No Rejected TranscriptCourse found."+e+" RequestId:"+uniqueId, e);
		}
	    return stcList;
	}
	@Override
	public StudentInstitutionTranscript findOldestStudentInstitutionTranscriptAlreadyOccupyByUser(String occupyById, String evaluationStatus) {
		List<StudentInstitutionTranscript> sitList = new ArrayList<StudentInstitutionTranscript>();
		StudentInstitutionTranscript studentInstitutionTranscript = null;
		try{	
			sitList = getHibernateTemplate().find("FROM StudentInstitutionTranscript sit where upper(sit.evaluationStatus) = ? AND occupyById = ?  order by sit.createdDate",new Object[]{evaluationStatus,occupyById});
			if(sitList != null && sitList.size()>0)
				studentInstitutionTranscript =  sitList.get(0);
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No Rejected TranscriptCourse found."+e+" RequestId:"+uniqueId, e);
		}
	    return studentInstitutionTranscript;
	}
	@Override
	public StudentInstitutionTranscript findNextOldestStudentInstitutionTranscriptAlreadyOccupyByUser(Date createdDate,String transcriptIds) {
		List<StudentInstitutionTranscript> sitList = getHibernateTemplate().find("FROM StudentInstitutionTranscript sit where upper(sit.evaluationStatus) = 'AWAITING SLE' AND sit.occupyById =null AND sit.createdDate >=? and sit.id NOT IN(?) ORDER BY sit.createdDate ASC LIMIT 1",new Object[]{createdDate,transcriptIds});
		if(sitList!=null&&sitList.size()>0){
			return sitList.get(0);
		}
		else return null;
	}
	@Override
	public StudentInstitutionTranscript findOldestSITForSLEWhichhaveCourses(String userId) {
		List<StudentInstitutionTranscript> sitList = new ArrayList<StudentInstitutionTranscript>();
		StudentInstitutionTranscript studentInstitutionTranscript = null;
		try{	
			sitList = getHibernateTemplate().find("SELECT DISTINCT(sit) FROM StudentInstitutionTranscript sit " +
					" , StudentTranscriptCourse stc" +
					" , Institution institution WHERE sit.id = stc.studentInstitutionTranscript.id AND sit.institution.id = institution.id" +
					" AND upper(stc.transferCourse.evaluationStatus)=? AND upper(sit.evaluationStatus)=? AND sit.markCompleted=? " +
					"AND upper(institution.evaluationStatus)=? AND sit.occupyById=? AND sit.collegeCode IN(SELECT collegeCode FROM SleCollege WHERE userId=?) " +
					" ORDER BY sit.createdDate",new Object[]{"EVALUATED","AWAITING SLE",true,"EVALUATED",userId,userId});
			if(sitList != null && sitList.size()>0){
				studentInstitutionTranscript =  sitList.get(0);
			}else{
				sitList = getHibernateTemplate().find("SELECT DISTINCT(sit) FROM StudentInstitutionTranscript sit " +
						" , StudentTranscriptCourse stc" +
						" , Institution institution WHERE sit.id = stc.studentInstitutionTranscript.id AND sit.institution.id = institution.id" +
						" AND upper(stc.transferCourse.evaluationStatus)=? AND upper(sit.evaluationStatus)=? AND sit.markCompleted=? " +
						"AND upper(institution.evaluationStatus)=? AND sit.occupyById is null AND sit.collegeCode IN(SELECT collegeCode FROM SleCollege WHERE userId=?)" +
						"  ORDER BY sit.createdDate",new Object[]{"EVALUATED","AWAITING SLE",true,"EVALUATED",userId});
				if(sitList != null && sitList.size()>0)
					studentInstitutionTranscript =  sitList.get(0);
			}
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No Transcript FOUND FOR SLE."+e+" RequestId:"+uniqueId, e);
		}
	    return studentInstitutionTranscript;
	}
	@Override
	public StudentInstitutionTranscript findOldestSITForLOPESWhichhaveCourses(String userId) {
		List<StudentInstitutionTranscript> sitList = new ArrayList<StudentInstitutionTranscript>();
		StudentInstitutionTranscript studentInstitutionTranscript = null;
		try{	
			sitList = getHibernateTemplate().find("SELECT DISTINCT(sit) FROM StudentInstitutionTranscript sit " +
					" , StudentTranscriptCourse stc" +
					" , Institution institution WHERE sit.id = stc.studentInstitutionTranscript.id AND sit.institution.id = institution.id" +
					" AND upper(stc.transferCourse.evaluationStatus)=? AND upper(sit.evaluationStatus)=? AND sit.markCompleted=? " +
					"AND upper(institution.evaluationStatus)=? AND sit.occupyById=? ORDER BY sit.createdDate",new Object[]{"EVALUATED","AWAITING LOPE",true,"EVALUATED",userId});
			if(sitList != null && sitList.size()>0){
				studentInstitutionTranscript =  sitList.get(0);
			}else{
				sitList = getHibernateTemplate().find("SELECT DISTINCT(sit) FROM StudentInstitutionTranscript sit " +
						" , StudentTranscriptCourse stc" +
						" , Institution institution WHERE sit.id = stc.studentInstitutionTranscript.id AND sit.institution.id = institution.id" +
						" AND upper(stc.transferCourse.evaluationStatus)=? AND upper(sit.evaluationStatus)=? AND sit.markCompleted=? " +
						"AND upper(institution.evaluationStatus)=? AND sit.occupyById is null ORDER BY sit.createdDate",new Object[]{"EVALUATED","AWAITING LOPE",true,"EVALUATED"});
				if(sitList != null && sitList.size()>0)
					studentInstitutionTranscript =  sitList.get(0);
			}
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No Transcript FOUND  FOR LOPES."+e+" RequestId:"+uniqueId, e);
		}
	    return studentInstitutionTranscript;
	}
	@Override
	public List<GCUDegree> findGCUInsitutionDegree() {
		List<GCUDegree> gCUDegreeList = new ArrayList<GCUDegree>();
		try{
			gCUDegreeList =  getHibernateTemplate().find("FROM GCUDegree order by degree");
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No Degree found "+e+" RequestId:"+uniqueId, e);
		}
		return gCUDegreeList;
	}
	@Override
	public List<StudentTranscriptCourse> getAllNotEvaluatedStudentTranscriptCourses(String studentId,String institutionId,
			boolean isOfficial,boolean statusInclude) {
		List<StudentTranscriptCourse> stcList = new ArrayList<StudentTranscriptCourse>();
		try{
			if(statusInclude){
				stcList = getHibernateTemplate().find("FROM StudentTranscriptCourse WHERE institution.id=? AND studentInstitutionTranscript.id IN(SELECT id FROM StudentInstitutionTranscript WHERE student.id=? AND institution.id=? AND markCompleted =? AND official=?) AND upper(evaluationStatus)!=? ",new Object[]{institutionId,studentId,institutionId,true,isOfficial,TranscriptStatusEnum.EVALUATED.getValue()});
			}else{
				stcList = getHibernateTemplate().find("FROM StudentTranscriptCourse WHERE institution.id=? AND studentInstitutionTranscript.id IN(SELECT id FROM StudentInstitutionTranscript WHERE student.id=? AND institution.id=? AND markCompleted =? AND official=?) ",new Object[]{institutionId,studentId,institutionId,true,isOfficial});
			}
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No StudentTranscriptCourse."+e+" RequestId:"+uniqueId, e);
		}
	    return stcList;
	}
	@Override
	public List<StudentInstitutionTranscript> getAllMarkCompletedSITForStudentAndInstitute(
			String studentId, String institutionId) {
		List<StudentInstitutionTranscript> sitList = new ArrayList<StudentInstitutionTranscript>();
		try{											  
			sitList = getHibernateTemplate().find("FROM StudentInstitutionTranscript sit where sit.student.id=? AND sit.institution.id=? AND sit.markCompleted=?",new Object[]{studentId,institutionId,true});
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No Mark Completed Transcript found."+e+" RequestId:"+uniqueId, e);
		}
	    return sitList;
	}	
	@Override
	public List<StudentInstitutionTranscript> findOldestSITListForSLEWhichhaveCourses(
			String userId) {
		List<StudentInstitutionTranscript> sitList = new ArrayList<StudentInstitutionTranscript>();
		try{	
			sitList = getHibernateTemplate().find("SELECT DISTINCT(sit) FROM StudentInstitutionTranscript sit " +
					" , StudentTranscriptCourse stc" +
					" , Institution institution WHERE sit.id = stc.studentInstitutionTranscript.id AND sit.institution.id = institution.id" +
					" AND upper(stc.transferCourse.evaluationStatus)=? AND upper(sit.evaluationStatus)=? AND sit.markCompleted=? " +
					"AND upper(institution.evaluationStatus)=? AND sit.occupyById=? AND sit.collegeCode IN(SELECT collegeCode FROM SleCollege WHERE userId=?) " +
					" ORDER BY sit.createdDate",new Object[]{"EVALUATED","AWAITING SLE",true,"EVALUATED",userId,userId});
			if(sitList != null && sitList.size()>0){
				
			}else{
				sitList = getHibernateTemplate().find("SELECT DISTINCT(sit) FROM StudentInstitutionTranscript sit " +
						" , StudentTranscriptCourse stc" +
						" , Institution institution WHERE sit.id = stc.studentInstitutionTranscript.id AND sit.institution.id = institution.id" +
						" AND upper(stc.transferCourse.evaluationStatus)=? AND upper(sit.evaluationStatus)=? AND sit.markCompleted=? " +
						"AND upper(institution.evaluationStatus)=? AND sit.occupyById is null AND sit.collegeCode IN(SELECT collegeCode FROM SleCollege WHERE userId=?)" +
						"  ORDER BY sit.createdDate",new Object[]{"EVALUATED","AWAITING SLE",true,"EVALUATED",userId});
				
			}
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No Transcript FOUND FOR SLE."+e+" RequestId:"+uniqueId, e);
		}
	    return sitList;
	}
}
