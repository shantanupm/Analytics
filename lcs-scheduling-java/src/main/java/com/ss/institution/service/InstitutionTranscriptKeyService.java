package com.ss.institution.service;

import java.util.List;

import com.ss.institution.value.GcuCourseLevel;
import com.ss.institution.value.InstitutionTranscriptKey;
import com.ss.institution.value.InstitutionTranscriptKeyGrade;
import com.ss.institution.value.TransferCourseInstitutionTranscriptKeyGradeAssoc;

public interface InstitutionTranscriptKeyService {
	
	public void addInstitutionTranscriptKey(InstitutionTranscriptKey institutionTranscriptKey);
	public List<InstitutionTranscriptKey> getAllInstitutionTranscriptKey(String institutionId);
	public InstitutionTranscriptKey getInstitutionTranscriptKey(String institutionTranscriptKeyId);
	public List<GcuCourseLevel> getAllGcuCourseLevel();
	
	public List<InstitutionTranscriptKey> getInstitutionTranscriptKeyList(String institutionMirrorId);
	public InstitutionTranscriptKey getInstitutionTranscriptKeyByInititutionMirrorId(String institutionMirrorId, String institutionTranscriptKeyId);
	public void addInstitutionTranscriptKeyToMirror(String institutionMirrorId, InstitutionTranscriptKey itk);
	public void effectiveTranscriptKey(String institutionId, String transcriptKeyId);
	public void effectiveTranscriptKeyMirror(String institutionMirrorId,String transcriptKeyId);
	public List<InstitutionTranscriptKeyGrade> getInstitutionTranscriptKeyGradeList(String institutionTranscriptKeyId, boolean isNumber);
	public List<InstitutionTranscriptKeyGrade> getInstitutionTranscriptKeyGradeListByInstitutionId(String institutionId);
	public List<TransferCourseInstitutionTranscriptKeyGradeAssoc> getTransferCourseInstitutionTranscriptKeyGradeList(String transferCourseId, String institutionId);
}
