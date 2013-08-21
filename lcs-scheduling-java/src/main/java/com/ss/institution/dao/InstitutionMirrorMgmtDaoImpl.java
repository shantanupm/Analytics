package com.ss.institution.dao;

import java.io.Serializable;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.ss.common.dao.BaseAbstractDAO;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionMirror;
@Repository
public class InstitutionMirrorMgmtDaoImpl extends BaseAbstractDAO<InstitutionMirror, Serializable> implements InstitutionMirrorMgmtDao {

	@Override
	public void addInstitutionMirror(InstitutionMirror im){
		getHibernateTemplate().saveOrUpdate(im);
	}
	
	@Override
	public List<InstitutionMirror> getInstitutionMirrorList(String institutionId){
		return getHibernateTemplate().find("from InstitutionMirror where institutionId = ? and evaluationStatus != 'COMPLETED' ", institutionId);
	}
	
	@Override
	public List<InstitutionMirror> getCompletedInstitutionMirrorList(String institutionId){
		return getHibernateTemplate().find("from InstitutionMirror where evaluationStatus = 'COMPLETED' and institutionId = ?",institutionId);
	}
	
	@Override
	public InstitutionMirror getNotCompletedInstitutionMirrorByEvaluatorIdAndInstitutionId(String evaluatorId, String institutionId){
		List<InstitutionMirror> imList = getHibernateTemplate().find("from InstitutionMirror where evaluatorId = ? and institutionId  = ? and evaluationStatus!='COMPLETED'", evaluatorId , institutionId);
		if(imList.size() != 0){
			return imList.get(0);
		}
		else return null;
	}
	
	@Override
	public InstitutionMirror getAssignedInstituteMirrorForEvaluator(String evaluatorId){
		List<InstitutionMirror> imList = getHibernateTemplate().find("from InstitutionMirror where evaluationStatus = 'TEMP' and evaluatorId = ?", evaluatorId);
		if(imList.size() != 0){
			return imList.get(0);
		}
		else return null;
	}
	
	@Override
	public InstitutionMirror getInstitutionMirrorByEvaluatorIdAndInstitutionId(String evaluatorId, String institutionId){
		List<InstitutionMirror> imList = getHibernateTemplate().find("from InstitutionMirror where evaluatorId = ? and institutionId  = ?", evaluatorId , institutionId);
		if(imList.size() != 0){
			return imList.get(0);
		}
		else return null;
	}
	
	@Override
	public void removeInstitutionMirrors(String institutionId){
		
		String queryString2="UPDATE TransferCourse SET confirmedBy=NULL,checkedBy=NULL WHERE id IN(" +
				"SELECT DISTINCT(transferCourseId) FROM TransferCourseMirror WHERE institutionMirrorId IN(" +
				"SELECT id FROM InstitutionMirror WHERE institutionId=?))";
		getHibernateTemplate().bulkUpdate(queryString2, institutionId);
		String queryString1="DELETE FROM TransferCourseMirror WHERE institutionMirrorId IN(" +
				" SELECT id FROM InstitutionMirror WHERE institutionId=?)";
		getHibernateTemplate().bulkUpdate(queryString1, institutionId);
		String queryString="DELETE from InstitutionMirror WHERE institutionId=?";
		getHibernateTemplate().bulkUpdate(queryString, institutionId);
	}
	
	@Override
	public void saveInstitutionMirror(InstitutionMirror im) {
		getHibernateTemplate().saveOrUpdate(im);
	}
}
