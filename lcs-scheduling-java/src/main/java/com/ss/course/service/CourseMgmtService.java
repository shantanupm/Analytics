package com.ss.course.service;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

import com.ss.course.value.CourseCategoryMapping;
import com.ss.course.value.CourseMapping;
import com.ss.course.value.CourseMappingDetail;
import com.ss.course.value.GCUCourse;
import com.ss.course.value.MilitarySubject;
import com.ss.course.value.TransferCourse;
import com.ss.course.value.TransferCourseMirror;
import com.ss.course.value.TransferCourseTitle;
import com.ss.institution.value.GcuCourseLevel;
import com.ss.institution.value.TransferCourseInstitutionTranscriptKeyGradeAssoc;

import com.ss.user.value.User;


public interface CourseMgmtService {
	
	public void createCourse(TransferCourse transferCourse);
	
	public TransferCourse getTransferCourseByCodeTitle(String courseCode,String courseTitle);
	public TransferCourse getTransferCourseById(String transferCourseId);
	
	public List<TransferCourse> getAllNotEvalutedTransferCourse();
	
	public void addCourseRelationShip(CourseMapping courseMapping);
	public void addCourseCategoryRelationShip(CourseCategoryMapping courseCategoryMapping);
	
	public List<CourseCategoryMapping> getAllCourseCategoryMapping();
	public List<CourseMapping> getAllCourseMapping();
	
	public List<CourseCategoryMapping> getCourseCategoryMappingByTransferCourseId(String transferCourseId);
	public List<CourseMapping> getCourseMappingByTransferCourseId(String transferCourseId);
	
	public CourseMapping getCourseMapping(String courseMappingId);
	public CourseCategoryMapping getCourseCategoryMapping(String courseCategoryMappingId);

	public List<TransferCourse> getAllTransferCourse();
	
	public TransferCourse getOldestNotEvaluatedCourse();
	
	public List<TransferCourse> getTransferCoursesForEvaluation(String institutionId, String evaluatorId);

	public List<TransferCourse> getNotEvaluatedCoursesByInstitutionId(String institutionId);
	
	public void markCourseMirrorsAsCompleted(String institutionMirrorId);
	
	public void updateCourseMirror(TransferCourseMirror transferCourseMirror);
	
	public TransferCourseMirror getTempTransferCourseMirrorByTransferCourseIdAndUserId(String transferCourseId, String userId);
	
	public void createCourseMirrors(String institutionMirrorId);
	
	public List<CourseMapping> getCourseMappingList(String courseMirrorId);
	public CourseMapping getCourseMappingByCourseMirrorId(String courseMirrorId, String courseMappingId);
	public void addCourseMappingToMirror(String courseMirrorId, CourseMapping cm);
	
	public List<CourseCategoryMapping> getCourseCategoryMappingList(String courseMirrorId);
	public CourseCategoryMapping getCourseCategoryMappingByCourseMirrorId(String courseMirrorId, String courseCategoryMappingId);
	public void addCourseCategoryMappingToMirror(String courseMirrorId, CourseCategoryMapping ccm); 
	
	public List<TransferCourseTitle> getCourseTitleList(String courseMirrorId);
	public TransferCourseTitle getCourseTitleByCourseMirrorId(String courseMirrorId, String courseTitleId);
	public void addCourseTitleToMirror(String courseMirrorId, TransferCourseTitle ct);
	
	public void markTransferCourseMirrorAsCompleted(String transferCourseMirrorId);
	
	public TransferCourseMirror getTransferCourseMirrorById(String transferCourseMirrorId);
	
	public List<TransferCourse> getConflictCourses();

	public List<TransferCourse> getConflictCoursesByInstitutionId(String institutionId);

	public LinkedHashMap<String, TransferCourse> getConflictTransferCourseList(String transferCourseId);

	public void addCoursesWithChilds(TransferCourse transferCourse, boolean isEvalutated);

	
	public void removeTransferCourseMirrors(String transferCourseId);
	
	public List<TransferCourse> getCoursesForReAssignment();
	
	public TransferCourse setTransferCourseWithTempMirrorEvaluators(String transferCourseId);
	
	public List<User> getAssignableEvaluatorsForTransferCourse(TransferCourse tc);
	
	public void reAssignCourse(String transferCourseId, String fromId, String toId);

	public void effectiveCourseRelationship(String transferCourseId,String courseMappingId);

	public void effectiveCourseCtgRelationship(String transferCourseId,String courseCategoryMappingId);

	public void effectiveCourseTitle(String transferCourseId, String courseTitleId);
	
	public List<GCUCourse> getGCUCourseList(String gcuCourseCode);

	public void effectiveCourseTitleMirror(String transferCourseMirrorId,String courseTitleId);

	public void effectiveCourseCtgRelationshipMirror(String transferCourseMirrorId,String courseCtgRelationshipId);

	public void effectiveCourseRelationshipMirror(String transferCourseMirrorId,String courseRelationshipId);

	public TransferCourse getTransferCourseWithChilds(String transferCourseId);
	
	public List<TransferCourse> getAllNotEvalutedTransferCourseForCurrentUser(String currentUserId);

	public TransferCourseTitle getEffectiveCourseTitleForCourseId(String transferCourseId);

	public void updateCourseTitleToMirror(String transferCourseMirrorId,TransferCourse transferCourse, List<TransferCourseTitle> transferCourseTitlelist, TransferCourseTitle transferCourseTitle);
	
	public List<GCUCourse> getAllGCUCourseList();
	
	public void addCourseCategoryMappingListToMirror(String courseMirrorId,List<CourseCategoryMapping> ccm);
	
	public void addCourseMappingListToMirror(String courseMirrorId, List<CourseMapping> cm);
	
	public List<TransferCourse> getTodayCompletedCourse(String institutionId);
	
	public void removeCourseMappingList(List<CourseMapping> courseMappingList);

	public void addCourseMappings(List<CourseMapping> courseMappingsList);

	public void removeCourseCategoryMappingList(List<CourseCategoryMapping> courseCategoryMappingList);

	public void addCourseCategoryMappingListRelationShip(List<CourseCategoryMapping> courseCategoryMappingList);

	public void addTrCoursesWithChilds(TransferCourse transferCourse, boolean isEvalutated, boolean isNeedToAddTitle);

	public void addTransferCourseInstitutionTranscriptKeyGradeAssocList(List<TransferCourseInstitutionTranscriptKeyGradeAssoc> transferCourseInstitutionTranscriptKeyGradeAssocNewList);

	public void deleteAllGradeAssoc(List<TransferCourseInstitutionTranscriptKeyGradeAssoc> transferCourseInstitutionTranscriptKeyGradeAssocReadList);

	public List<TransferCourseInstitutionTranscriptKeyGradeAssoc> loadAllTransferCourseInstitutionTranscriptKeyGradeAssocByTransferCourseId(String transferCourseId);

	public TransferCourseMirror getTransferCourseMirrorByTransferCourseId(String transferCourseId);

	public void updateTransferCourseIntoMirror(TransferCourseMirror transferCourseMirror,TransferCourse transferCourse);

	public void addTransferCourse(TransferCourse transferCourse);

	public TransferCourseMirror getTransferCourseMirrorByTransferCourseIdAndCurrentUserId(
			String transferCourseId, String evaluatorId);

	public GcuCourseLevel getGcuCourseLevelById(String gcuCourseLevelId);

	public void addCourseRelationShipDetail(CourseMappingDetail courseMappingDetail);

	public void updateCourseTitleToMirror(String transferCourseMirrorId,String transferCourseId, List<MilitarySubject> militarySubjectList);

	public TransferCourse getTransferCourseByCodeAndInstitution(String courseCode, String institutionId);

	/**
	 * returns a CourseMapping Object with the CourseMappingDetails populated inside it
	 * @param courseMappingId
	 * @return
	 */
	public CourseMapping getCourseMappingWithDetails(String courseMappingId);

	/**Added separate Save method of Hibernate because sometimes saveOrUpdate() not works perfectly*/
	public void saveTransferCourse(TransferCourse transferCourse);
	/**Added separate update method of Hibernate because sometimes saveOrUpdate() not works perfectly*/
	public void updateTransferCourse(TransferCourse transferCourse);
	
}
