package com.ss.evaluation.dao;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.ss.common.dao.BaseAbstractDAO;
import com.ss.common.logging.RequestContext;
import com.ss.evaluation.enums.TranscriptStatusEnum;
import com.ss.evaluation.value.SleCollege;
import com.ss.evaluation.value.StudentInstitutionDegree;
import com.ss.evaluation.value.StudentInstitutionTranscript;
import com.ss.evaluation.value.StudentTranscriptCourse;
import com.ss.institution.dao.InstitutionMgmtDao;
import com.ss.institution.value.ArticulationAgreementDetails;
import com.ss.institution.value.InstitutionDegree;
import com.ss.institution.value.InstitutionTranscriptKey;
import com.ss.institution.value.InstitutionTranscriptKeyDetails;

/**
 * Interface Implementation of {@link InstitutionMgmtDao}
 * @author Bharat.Ranjan
 */
@Repository
public class TranscriptMgmtDAOImpl extends BaseAbstractDAO<StudentTranscriptCourse, Serializable> implements TranscriptMgmtDAO {

	private static transient Logger log = LoggerFactory.getLogger( TranscriptMgmtDAOImpl.class );
	
	@Override
	public StudentTranscriptCourse getTranscriptById(String transcriptId) {
		List<StudentTranscriptCourse> list = getHibernateTemplate().find( "from StudentTranscriptCourse where id = ? ", transcriptId );
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list.get(0);
	}
	
	
		
	@Override
	public StudentInstitutionDegree getStudentInstituteDegreeDetails(String sid){
		List<StudentInstitutionDegree> list = getHibernateTemplate().find( "from StudentInstitutionDegree where id = ? order by desc completionDate ", sid );
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list.get(0);
	}

	@Override
	public InstitutionTranscriptKey getTranscriptKeyById(
			String instTranscriptKeyId) {
		List<InstitutionTranscriptKey> list = getHibernateTemplate().find( "from InstitutionTranscriptKey where id = ? ", instTranscriptKeyId );
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list.get(0);
	}

	@Override
	public List<InstitutionTranscriptKeyDetails> getTranscriptKeyDetailsByTranscriptKeyId(
			String instTranscriptKeyId) {
		List<InstitutionTranscriptKeyDetails> list = getHibernateTemplate().find( "from InstitutionTranscriptKeyDetails where institutionTranscripkeyId = ? ", instTranscriptKeyId );
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list;
	}

	@Override
	public void removeStudentTranscriptCourses( List<StudentTranscriptCourse> studentTranscriptCourseList ){
		getHibernateTemplate().deleteAll( studentTranscriptCourseList );
	}
	
	@Override
	public void removeStudentInstitutionDegreeList( List<StudentInstitutionDegree> studentInstitutionDegreeList ) {
		getHibernateTemplate().deleteAll( studentInstitutionDegreeList );
	}
	
	@Override
	public void putTranscriptKey(InstitutionTranscriptKey tk) {
		// TODO Auto-generated method stub
		getHibernateTemplate().saveOrUpdate(tk);
	}

	
	@Override
	public List<StudentTranscriptCourse> getAllTranscripts() {
		// TODO Auto-generated method stub
		List<StudentTranscriptCourse> list = getHibernateTemplate().find( "from InstitutionTranscriptKeyDetails tkd order by institutionTranscripkeyId" );
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list;
	}

	@Override
	public List<StudentTranscriptCourse> getAllTranscriptsById(String studentId) {
		// TODO Auto-generated method stub
		List<StudentTranscriptCourse> list = getHibernateTemplate().find( "from StudentTranscriptCourse st order by trCourseId" );
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list;
	}

	@Override
	public void putTranscript(StudentTranscriptCourse s) {
		// TODO Auto-generated method stub
		getHibernateTemplate().saveOrUpdate(s);
	}
	@Override
	public void putStudentInstitutionDegreeAssoc(StudentInstitutionDegree sid){
		// TODO Auto-generated method stub
		getHibernateTemplate().saveOrUpdate(sid);
	}
	
	@Override
	public void saveTranscriptList(  List<StudentTranscriptCourse> studentTranscriptList  ) {
		getHibernateTemplate().saveOrUpdateAll( studentTranscriptList );
	}
	
	public List<StudentTranscriptCourse> getTranscriptByStudentProgEvalId(String studentProgEvalId, String institutionId){
		List<StudentInstitutionTranscript> studentInstitutionTranscriptList= 
			getHibernateTemplate().find("from StudentInstitutionTranscript where studentProgramEvaluation.id=? AND institution.id=? order by modifiedDate desc ",studentProgEvalId,institutionId);
		StudentInstitutionTranscript studentInstitutionTranscript=new StudentInstitutionTranscript();
		
		//For 0th element studentInstitutionTranscript is current record which doesnot have any StudentTranscriptCourse
		// For 1th element studentInstitutionTranscript last updated modifiedDate record.
		if(studentInstitutionTranscriptList.size()>1)
			studentInstitutionTranscript= studentInstitutionTranscriptList.get(1);
		else
			studentInstitutionTranscript= studentInstitutionTranscriptList.get(0);
		
		List<StudentTranscriptCourse> list = 
			getHibernateTemplate().find( "from StudentTranscriptCourse where studentProgramEvaluationId=? AND institution.id=? AND " +
					" studentInstitutionTranscript.id=? order by courseSequence",studentProgEvalId ,institutionId,studentInstitutionTranscript.getId());
		
		
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list;
	}
	
	//TODO: why do we need to pass InstitutionId to get a list of studentTranscriptCourses for a transcript
	@Override
	public List<StudentTranscriptCourse> getStudentTranscriptCoursesByTranscriptId( String studentInstitutionTranscriptId, String institutionId ) {
		if(institutionId==null) {
			List<StudentTranscriptCourse> list = getHibernateTemplate().find( "from StudentTranscriptCourse where studentInstitutionTranscript.id=?", studentInstitutionTranscriptId);
			return list;
		}
		List<StudentTranscriptCourse> list = getHibernateTemplate().find( "from StudentTranscriptCourse where studentInstitutionTranscript.id=? AND institution.id=? order by courseSequence", studentInstitutionTranscriptId,institutionId );
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list;
	}
	
	@Override
	public List<StudentInstitutionDegree> getStudentInstitutionDegreeListForStudentInstitutionTranscript( String studentInstitutionTranscriptId ) {
		List<StudentInstitutionDegree> list = getHibernateTemplate().find( "from StudentInstitutionDegree sid where sid.studentInstitutionTranscript.id=?", studentInstitutionTranscriptId );
		if( list == null || list.size() == 0 ) {
			return null;
		}
		
		return list;
	}
	
	@Override
	public void saveStudentInstitutionDegreeList( List<StudentInstitutionDegree> studentInstitutionDegreeList ) {
		getHibernateTemplate().saveOrUpdateAll( studentInstitutionDegreeList );
	}
	
	@Override
	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptForStudentAndInstitute(String studentId, String institutionId) {
		List<StudentInstitutionTranscript> studentInstitutionTranscriptList = new ArrayList<StudentInstitutionTranscript>();
		
		try{
			studentInstitutionTranscriptList = getHibernateTemplate().find("FROM StudentInstitutionTranscript WHERE student.id=? AND institution.id=?",new Object[]{studentId,institutionId});
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No Transcript found."+e+" RequestId:"+uniqueId, e);
		}
		return studentInstitutionTranscriptList;
	}
	@Override
	public List<StudentInstitutionDegree> getStudentInstitutionDegreeListForTranscriptAndInstitute(String studentId,String institutionId) {
		List<StudentInstitutionDegree> sidList = new ArrayList<StudentInstitutionDegree>();
		List<Object[]> objectList = new ArrayList<Object[]>();
		try{
			objectList = getHibernateTemplate().find("SELECT sid.institutionDegree.degree,sid.completionDate,sid.major,sid.gpa FROM StudentInstitutionDegree sid WHERE sid.studentInstitutionTranscript.student.id=? AND sid.institutionDegree.institution.id=? GROUP BY sid.institutionDegree.degree,sid.completionDate,sid.major,sid.gpa",new Object[]{studentId,institutionId});
			if(objectList!=null && objectList.size()>0){
				for(int i=0;i<objectList.size();i++){
					Object array[] = objectList.get(i);
					
						StudentInstitutionDegree sid = new StudentInstitutionDegree();
						InstitutionDegree institutionDegree = new InstitutionDegree();					
						institutionDegree.setDegree(array[0]!=null && !"".equals(array[0])?String.valueOf(array[0]):null);
						sid.setInstitutionDegree(institutionDegree);
						SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S");
						Date date = null;
						if(array[1]!=null && !"".equals(array[1])){
							date = dateFormat.parse(String.valueOf(array[1]));
						}
						sid.setCompletionDate(date);
						sid.setMajor(array[2]!=null && !"".equals(array[2])?String.valueOf(array[2]):null);
						sid.setGpa(array[3]!=null && !"".equals(array[3])?Float.valueOf(String.valueOf(array[3])):null);
						sidList.add(sid);
					
				}
			}
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No Degree found."+e+" RequestId:"+uniqueId, e);
		}
		return sidList;
	}
	@Override
	public StudentInstitutionTranscript findOldestStudentInstitutionTranscriptForStudentAndInstitute(
			String studentId, String institutionId,boolean markCompleted) {
		StudentInstitutionTranscript studentInstitutionTranscript = new StudentInstitutionTranscript();
		try{
			studentInstitutionTranscript = (StudentInstitutionTranscript)getHibernateTemplate().find("FROM StudentInstitutionTranscript WHERE student.id=? AND institution.id=? AND markCompleted=? ORDER BY createdDate",new Object[]{studentId,institutionId,markCompleted}).get(0);
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No Transcript found."+e+" RequestId:"+uniqueId, e);
		}
		return studentInstitutionTranscript;
	}
	@Override
	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptForStudentAndInstituteForTranscriptTypeWithEvaluationStatus(
			String studentId, String institutionId, boolean transcriptType, String evaluationStatus) {
		List<StudentInstitutionTranscript> studentInstitutionTranscriptList = new ArrayList<StudentInstitutionTranscript>();		
		try{
			studentInstitutionTranscriptList = getHibernateTemplate().find("FROM StudentInstitutionTranscript sit WHERE sit.student.id=? AND sit.institution.id=? AND sit.official=? AND upper(sit.evaluationStatus) = ? AND markCompleted=?",new Object[]{studentId,institutionId,transcriptType,evaluationStatus,true});
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No Transcript found."+e+" RequestId:"+uniqueId, e);
		}
		return studentInstitutionTranscriptList;
	}
	@Override
	public void removeRejectedStudentTranscriptCourseMarkForDelection(
			List<StudentTranscriptCourse> stcRejectedListForDeletion) {
		getHibernateTemplate().deleteAll(stcRejectedListForDeletion);
	}
	@Override
	public List<StudentTranscriptCourse> findStudentTranscriptCoursesByTranscriptIdForStudentAndInstitution(
			String studentInstitutionTranscriptId, String studentId,
			String institutionId) {
		List<StudentTranscriptCourse> studentTranscriptCourseList = new ArrayList<StudentTranscriptCourse>();		
		try{
			studentTranscriptCourseList = getHibernateTemplate().find("FROM StudentTranscriptCourse WHERE studentInstitutionTranscript.student.id=? AND studentInstitutionTranscript.institution.id=? AND studentInstitutionTranscript.id=?",new Object[]{studentId,institutionId,studentInstitutionTranscriptId});
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No Transcript found."+e+" RequestId:"+uniqueId, e);
		}
		return studentTranscriptCourseList;
	}
	@Override
	public List<StudentInstitutionDegree> findStudentInstitutionDegreeListForStudentTranscriptAndInstitute(String studentInstitutionTranscriptId, String institutionId) {
		List<StudentInstitutionDegree> studentInstitutionDegreeList = new ArrayList<StudentInstitutionDegree>();		
		try{
			studentInstitutionDegreeList = getHibernateTemplate().find("SELECT DISTINCT(sid) FROM StudentInstitutionDegree sid , InstitutionDegree ind WHERE sid.institutionDegree.id=ind.id AND sid.studentInstitutionTranscript.id=? AND ind.institution.id=?",new Object[]{studentInstitutionTranscriptId,institutionId});
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No Degree found."+e+" RequestId:"+uniqueId, e);
		}
		return studentInstitutionDegreeList;
	}
	@Override
	public List<StudentTranscriptCourse> findAllStudentTranscriptCourseByTransferCourseIdAndInstitutionId(
			String transferCourseId, String institutionId) {
		List<StudentTranscriptCourse> studentTranscriptCourseList = new ArrayList<StudentTranscriptCourse>();		
		try{
			studentTranscriptCourseList = getHibernateTemplate().find("FROM StudentTranscriptCourse WHERE transferCourse.id=? AND institution.id=?",new Object[]{transferCourseId,institutionId});
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No StudentTranscriptCourse found."+e+" RequestId:"+uniqueId, e);
		}
		return studentTranscriptCourseList;
	}
	@Override
	public void updateAllRespectiveCoursesForStudent(String courseMappingId,String transferCourseId,
			String studentId, String instituteId) {
		
		try{
			getHibernateTemplate().bulkUpdate("UPDATE StudentTranscriptCourse stc set stc.courseMappingId='"+courseMappingId+"' WHERE stc.studentInstitutionTranscript.id IN(SELECT sit.id FROM StudentInstitutionTranscript sit WHERE sit.student.id='"+studentId+"' AND sit.institution.id='"+instituteId+"') AND stc.transferCourse.id='"+transferCourseId+"' ");
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Can not Update StudentTranscriptCourse "+e+" RequestId:"+uniqueId, e);
		}
	}
	@Override
	public void updateAllRespectiveCoursesCategoryForStudent(
			String coursesCategoryMappingId, String transferCourseId,
			String studentId, String instituteId) {
		try{
			getHibernateTemplate().bulkUpdate("UPDATE StudentTranscriptCourse stc set stc.courseCategoryMappingId='"+coursesCategoryMappingId+"' WHERE stc.studentInstitutionTranscript.id IN(SELECT sit.id FROM StudentInstitutionTranscript sit WHERE sit.student.id='"+studentId+"' AND sit.institution.id='"+instituteId+"') AND stc.transferCourse.id='"+transferCourseId+"' ");
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Can not Update StudentTranscriptCourse "+e+" RequestId:"+uniqueId, e);
		}
	}
	@Override
	public void updateRespectiveSubjectCoursesForStudent(
			String courseMappingId, String subjectId, String transcriptCourseId,
			String studentId, String instituteId) {
		try{
			getHibernateTemplate().bulkUpdate("UPDATE TranscriptCourseSubject tcs set tcs.courseMappingId='"+courseMappingId+"' WHERE tcs.transcriptCourseId='"+transcriptCourseId+"' AND tcs.subjectId='"+subjectId+"' ");
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Can not Update TranscriptCourseSubject "+e+" RequestId:"+uniqueId, e);
		}
	}
	@Override
	public void updateAllRespectiveCoursesCategoryForStudent(
			String courseCategoryMappingId, String subjectId, String transcriptCourseId,
			String studentId, String instituteId) {
		try{
			getHibernateTemplate().bulkUpdate("UPDATE TranscriptCourseSubject tcs set tcs.categoryId='"+courseCategoryMappingId+"' WHERE tcs.transcriptCourseId='"+transcriptCourseId+"' AND tcs.subjectId='"+subjectId+"' ");
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Can not Update TranscriptCourseSubject "+e+" RequestId:"+uniqueId, e);
		}
	}
	@Override
	public void saveSLES(List<SleCollege> sleCollegeList) {
		getHibernateTemplate().saveOrUpdateAll(sleCollegeList);
		
	}
	@Override
	public List<SleCollege> findAllSLEForCollegeCode(String collegeCode) {
		List<SleCollege> sleCollegeList = new ArrayList<SleCollege>();		
		try{
			sleCollegeList = getHibernateTemplate().find("FROM SleCollege WHERE collegeCode=?",new Object[]{collegeCode});
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No SleCollege found."+e+" RequestId:"+uniqueId, e);
		}
		return sleCollegeList;
	}
	@Override
	public void deleteAllSLEAssignToCollegeCode(String collegeCode) {
		try{
			 getHibernateTemplate().bulkUpdate("DELETE SleCollege WHERE collegeCode=?",new Object[]{collegeCode});
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Not able to delete SleCollege found."+e+" RequestId:"+uniqueId, e);
		}
		
	}
	@Override
	public void resetStudentInstitutionTranscriptForCollegeCode(
			String collegeCode) {
		try{
			 getHibernateTemplate().bulkUpdate("UPDATE StudentInstitutionTranscript SET occupyById = null WHERE collegeCode=? and official=? ",new Object[]{collegeCode,true});
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Not able to update StudentInstitutionTranscript."+e+" RequestId:"+uniqueId, e);
		}
		
	}
}

