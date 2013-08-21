package com.ss.course.dao;

import java.io.Serializable;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.ss.common.dao.BaseAbstractDAO;
import com.ss.common.logging.RequestContext;

import com.ss.course.value.TransferCourse;
import com.ss.course.value.TransferCourseMirror;
import com.ss.institution.value.InstitutionMirror;

@Repository
public class CourseMirrorMgmtDAOImpl extends BaseAbstractDAO<TransferCourseMirror, Serializable> implements CourseMirrorMgmtDAO{
	private static transient Logger log = LoggerFactory.getLogger( CourseMirrorMgmtDAOImpl.class );
	@Override
	public List<TransferCourseMirror> getCompletedTransferCourseMirrors(String transferCourseId){
		return getHibernateTemplate().find("from TransferCourseMirror where evaluationStatus = 'COMPLETED' and transferCourseId = ? ORDER BY createdTime", transferCourseId);
	}
	@Override
	public List<TransferCourseMirror> getTransferCourseMirrorsByInstMirrorId(String institutionMirrorId){
	//	return getHibernateTemplate().find("from TransferCourseMirror where institutionMirrorId = ?  and collegeApprovalRequired=1", institutionMirrorId);
		return getHibernateTemplate().find("from TransferCourseMirror where institutionMirrorId = ? ", institutionMirrorId);
	}
	@Override
	public List<TransferCourseMirror> getTEMPCourseMirrorsByEvaluatorId(String evaluatorId){
	//	return getHibernateTemplate().find("from TransferCourseMirror where evaluationStatus = 'TEMP' and evaluatorId = ? and collegeApprovalRequired=1 ORDER BY createdDate" , evaluatorId);
		return getHibernateTemplate().find("from TransferCourseMirror where evaluationStatus = 'TEMP' and evaluatorId = ? ORDER BY createdTime" , evaluatorId);
	}
	@Override
	public TransferCourseMirror getTempTransferCourseMirrorByCourseIdAndEvaluatorId(
			String transferCourseId, String evaluatorId) {
		List<TransferCourseMirror> tcmList = getHibernateTemplate().find("from TransferCourseMirror where evaluationStatus = 'TEMP' and transferCourseId = ? and evaluatorId = ?" , transferCourseId, evaluatorId);
		if(tcmList != null && tcmList.size()!=0){
			return tcmList.get(0);
		}
		else return null;
		
	}
	
	@Override
	public TransferCourseMirror getTransferCourseMirrorByCourseIdAndEvaluatorId(String transferCourseId, String evaluatorId){
	//	List<TransferCourseMirror> tcmList = getHibernateTemplate().find("from TransferCourseMirror where transferCourseId = ? and evaluatorId = ? AND collegeApprovalRequired=1 " , transferCourseId, evaluatorId);
		List<TransferCourseMirror> tcmList = getHibernateTemplate().find("from TransferCourseMirror where transferCourseId = ? and evaluatorId = ?" , transferCourseId, evaluatorId);
		if(tcmList != null && tcmList.size()!=0){
			return tcmList.get(0);
		}
		else return null;
	}
	
	@Override
	public void removeTransferCourseMirrors(String transferCourseId){
		String queryString="DELETE from TransferCourseMirror WHERE transferCourseId=?";
		getHibernateTemplate().bulkUpdate(queryString, transferCourseId);
	}
	@Override
	public void addOrUpdateTransferCourseMirror(
			TransferCourseMirror transferCourseMirror) {
		getHibernateTemplate().saveOrUpdate(transferCourseMirror);
		
	}
	@Override
	public void mergeTransferCourseMirror(
			TransferCourseMirror transferCourseMirror) {
		
		getHibernateTemplate().update(transferCourseMirror);
	}
	@Override
	public TransferCourseMirror findTransferCourseMirrorByTransferCourseIdUserIdAndInstitutionId(
			String transferCourseId, String evaluatorId, String institutionId) {
		TransferCourseMirror transferCourseMirror = null;
		try{
			
			transferCourseMirror = (TransferCourseMirror)getHibernateTemplate().find("FROM TransferCourseMirror WHERE transferCourseId=?  AND evaluatorId=? AND institutionMirrorId=? ", new Object[]{transferCourseId,evaluatorId,institutionId}).get(0);
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No TransferCourseMirror found."+e+" RequestId:"+uniqueId, e);
		}
		return transferCourseMirror;
	}
	@Override
	public void saveTransferCourseMirror(
			TransferCourseMirror transferCourseMirror) {
		getHibernateTemplate().saveOrUpdate(transferCourseMirror);		
	}
	@Override
	public void addTransferCourseMirror(
			TransferCourseMirror transferCourseMirror) {
		getHibernateTemplate().save(transferCourseMirror);	
	}
	@Override
	public void updateTransferCourseMirror(
			TransferCourseMirror transferCourseMirror) {
		getHibernateTemplate().update(transferCourseMirror);	
	}
}
