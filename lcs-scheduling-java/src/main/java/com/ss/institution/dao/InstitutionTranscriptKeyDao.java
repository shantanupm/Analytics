package com.ss.institution.dao;

import java.io.Serializable;
import java.util.List;

import com.ss.common.dao.BaseDAO;
import com.ss.institution.value.GcuCourseLevel;
import com.ss.institution.value.InstitutionTranscriptKey;
import com.ss.institution.value.InstitutionTranscriptKeyDetails;
import com.ss.institution.value.InstitutionTranscriptKeyGrade;
import com.ss.institution.value.TransferCourseInstitutionTranscriptKeyGradeAssoc;

public interface InstitutionTranscriptKeyDao extends BaseDAO<InstitutionTranscriptKey, Serializable> {

	public void addInstitutionTranscriptKey(InstitutionTranscriptKey institutionTranscriptKey);
	public List<InstitutionTranscriptKey> getAllInstitutionTranscriptKey(String institutionId);
	public List<GcuCourseLevel> getAllGcuCourseLevel();
	public List<InstitutionTranscriptKeyDetails> getInstitutionTranscriptKeyDetailsList(String institutionTranscriptKeyId);
	public void effectiveTranscriptKey(String institutionId, String transcriptKeyId);
	public	List<InstitutionTranscriptKeyGrade> getInstitutionTranscriptKeyGradeList(String institutionTranscriptKeyId, boolean isNumber);
	public List<InstitutionTranscriptKeyGrade> findInstitutionTranscriptKeyGradeListByInstitutionId(String institutionId);
	public List<TransferCourseInstitutionTranscriptKeyGradeAssoc> findTransferCourseInstitutionTranscriptKeyGradeList(String transferCourseId, String institutionId);
}
