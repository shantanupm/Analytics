package com.ss.institution.dao;

import java.io.Serializable;
import java.util.List;

import com.ss.common.dao.BaseDAO;
import com.ss.institution.value.InstitutionMirror;

public interface InstitutionMirrorMgmtDao extends BaseDAO<InstitutionMirror, Serializable>{

	public void addInstitutionMirror(InstitutionMirror im);
	
	public List<InstitutionMirror> getInstitutionMirrorList(String institutionId);
	
	public List<InstitutionMirror> getCompletedInstitutionMirrorList(String institutionId);
	
	public InstitutionMirror getNotCompletedInstitutionMirrorByEvaluatorIdAndInstitutionId(String evaluatorId, String institutionId);
	
	public InstitutionMirror getAssignedInstituteMirrorForEvaluator(String evaluatorId);
	
	public InstitutionMirror getInstitutionMirrorByEvaluatorIdAndInstitutionId(String evaluatorId, String institutionId);

	public void removeInstitutionMirrors(String institutionId);

	public void saveInstitutionMirror(InstitutionMirror im);
}
