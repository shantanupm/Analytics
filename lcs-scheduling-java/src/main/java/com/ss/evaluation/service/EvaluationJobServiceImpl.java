package com.ss.evaluation.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ss.course.dao.CourseMgmtDAO;
import com.ss.course.dao.CourseMirrorMgmtDAO;
import com.ss.course.value.TransferCourse;
import com.ss.course.value.TransferCourseMirror;
import com.ss.evaluation.dao.StudentEvaluationDao;
import com.ss.evaluation.value.StudentInstitutionTranscript;
import com.ss.institution.dao.InstitutionMgmtDao;
import com.ss.institution.dao.InstitutionMirrorMgmtDao;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionMirror;

@Service
public class EvaluationJobServiceImpl implements EvaluationJobService{

	@Autowired
	InstitutionMgmtDao institutionMgmtDao;
	@Autowired
	InstitutionMirrorMgmtDao institutionMirrorMgmtDao;
	@Autowired
	CourseMgmtDAO courseMgmtDAO;
	@Autowired
	CourseMirrorMgmtDAO courseMirrorMgmtDAO;
	@Autowired
	StudentEvaluationDao studentEvaluationDao;
	
	@Override
	public List<Institution> getNotEvaluatedInstitutionsForJob() {
		return institutionMgmtDao.getNotEvaluatedInstitutionListForJob();
	}

	@Override
	public List<InstitutionMirror> getCompletedInstitutionMirrors(String institutionId) {
		return institutionMirrorMgmtDao.getCompletedInstitutionMirrorList(institutionId);
	}

	@Override
	public List<TransferCourse> getNotEvaluatedTransferCourses() {
		return courseMgmtDAO.getNotEvaluatedTransferCoursesforJob();
	}

	@Override
	public List<TransferCourseMirror> getCompletedTransferCourseMirrors(String transferCourseId) {
		return courseMirrorMgmtDAO.getCompletedTransferCourseMirrors(transferCourseId);
	}

	@Override
	public List<StudentInstitutionTranscript> getAwaitingIEorIEMSITList() {
		return studentEvaluationDao.getAwaitingIEorIEMSITList();
	}
	
}
