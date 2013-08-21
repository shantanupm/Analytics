package com.ss.institution.dao;

import java.io.Serializable;
import java.util.List;

import com.ss.common.dao.BaseDAO;
import com.ss.course.value.GCUCourseCategory;
import com.ss.institution.value.ArticulationAgreement;
import com.ss.institution.value.ArticulationAgreementDetails;

public interface ArticulationAgreementDao extends BaseDAO<ArticulationAgreement, Serializable> {

	public void addArticulationAgreement(ArticulationAgreement articulationAgreement);
	public List<ArticulationAgreement> getAllArticulationAgreement(String institutionId);
	public List<ArticulationAgreementDetails> getArticulationAgreementDetailsList(String articulationAgreementId);
	public GCUCourseCategory getgGcuCourseCategoryById(String id);
	public void effectiveArticulationAgreement(String institutionId,String articulationAgreementId);
}
