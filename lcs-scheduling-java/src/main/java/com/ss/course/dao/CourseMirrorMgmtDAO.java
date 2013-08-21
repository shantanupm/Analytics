package com.ss.course.dao;

import java.io.Serializable;
import java.util.List;

import com.ss.common.dao.BaseDAO;
import com.ss.course.value.TransferCourseMirror;

public interface CourseMirrorMgmtDAO extends BaseDAO<TransferCourseMirror, Serializable>{
	
	public List<TransferCourseMirror> getCompletedTransferCourseMirrors(String transferCourseId); 
	public List<TransferCourseMirror> getTransferCourseMirrorsByInstMirrorId(String institutionMirrorId);
	public List<TransferCourseMirror> getTEMPCourseMirrorsByEvaluatorId(String evaluatorId);
	public TransferCourseMirror getTempTransferCourseMirrorByCourseIdAndEvaluatorId(String transferCourseId, String evaluatorId);
	public TransferCourseMirror getTransferCourseMirrorByCourseIdAndEvaluatorId(String transferCourseId, String evaluatorId);
	public void removeTransferCourseMirrors(String transferCourseId);
	public void addOrUpdateTransferCourseMirror(TransferCourseMirror transferCourseMirror);
	public void mergeTransferCourseMirror(TransferCourseMirror transferCourseMirror);
	public TransferCourseMirror findTransferCourseMirrorByTransferCourseIdUserIdAndInstitutionId(String transferCourseId, String evaluatorId, String institutionId);
	public void saveTransferCourseMirror(TransferCourseMirror transferCourseMirror);
	public void addTransferCourseMirror(TransferCourseMirror transferCourseMirror);
	public void updateTransferCourseMirror(TransferCourseMirror transferCourseMirror);
	
}
