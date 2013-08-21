package com.ss.institution.service;

import java.util.List;

import com.ss.course.value.CourseCategoryMapping;
import com.ss.course.value.GCUCourseCategory;
import com.ss.institution.value.ArticulationAgreement;

public interface ArticulationAgreementService {

	public void addArticulationAgreement(ArticulationAgreement articulationAgreement);
	public List<ArticulationAgreement> getAllArticulationAgreement(String institutionId);
	public ArticulationAgreement getArticulationAgreement(String ArticulationAgreementId);
	public List<GCUCourseCategory> getAllGcuCourseCategory();
	
	public List<ArticulationAgreement> getArticulationAgreementList(String institutionMirrorId);
	public ArticulationAgreement getArticulationAgreementByInititutionMirrorId(String institutionMirrorId, String articulationAgreementId);
	public void addArticulationAgreementToMirror(String institutionMirrorId, ArticulationAgreement aa);
	public GCUCourseCategory getgGcuCourseCategoryById(String id);
	public void effectiveArticulationAgreement(String institutionId,String articulationAgreementId);
	public void effectiveArticulationAgreementMirror(String institutionMirrorId,String transcriptKeyId);
}
