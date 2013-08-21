package com.ss.course.dao;

import java.io.Serializable;
import java.util.List;

import com.ss.common.dao.BaseDAO;
import com.ss.course.value.CourseCategoryMapping;
import com.ss.course.value.CourseMapping;
import com.ss.course.value.CourseMappingDetail;
import com.ss.course.value.GCUCourseCategory;
import com.ss.course.value.TransferCourse;
import com.ss.course.value.TransferCourseMirror;
import com.ss.course.value.GCUCourse;
import com.ss.course.value.TransferCourseTitle;
import com.ss.institution.value.GcuCourseLevel;
import com.ss.institution.value.TransferCourseInstitutionTranscriptKeyGradeAssoc;


public interface CourseMgmtDAO extends BaseDAO<TransferCourse, Serializable> {
	
	public void createCourse(TransferCourse transferCourse);
	public void createGCUCourse(GCUCourse gcuCourse);

	public TransferCourse getTransferCourseByCodeTitle(String courseCode,String courseTitle);
	public TransferCourse getTransferCourseById(String transferCourseId);
	public List<TransferCourse> getAllNotEvalutedTransferCourse();
	
	public void addCourseRelationShip(CourseMapping courseMapping);
	public void addCourseCategoryRelationShip(CourseCategoryMapping courseCategoryMapping);
	public List<CourseCategoryMapping> getAllCourseCategoryMapping();
	
	public List<GCUCourseCategory> getAllGCUCourseCategories();
	public List<CourseMapping> getAllCourseMapping();
	
	public List<CourseCategoryMapping> getCourseCategoryMappingByTransferCourseId(String transferCourseId);
	public List<CourseMapping> getCourseMappingByTransferCourseId(String transferCourseId);
	
	public CourseMapping getCourseMapping(String courseMappingId);
	public CourseCategoryMapping getCourseCategoryMapping(String courseCategoryMappingId);

	public List<TransferCourse> getAllTransferCourse();

	public TransferCourse getOldestNotEvaluatedCourse();
	public List<TransferCourse> getNotEvaluatedCoursesByInstitutionId(String institutionId);
	public List<TransferCourse> getNotEvaluatedTransferCoursesforJob();

	public List<TransferCourse> getConflictCourses();

	public List<TransferCourse> getConflictCoursesByInstitutionId(String institutionId);
	
	public List<TransferCourse> getCoursesForReAssignment();

	public void effectiveCourseRelationship(String transferCourseId,String courseMappingId);

	public void effectiveCourseCtgRelationship(String transferCourseId,String courseCategoryMappingId);

	public void effectiveCourseTitle(String transferCourseId, String courseTitleId);
	
	public List<GCUCourse> getGCUCourseList(String gcuCourseCode);

	public List<TransferCourse> getAllNotEvalutedTransferCourseForCurrentUser(String currentUserId);

	public TransferCourseTitle findEffectiveCourseTitleForCourseId(String transferCourseId);
	
	public List<GCUCourse> findAllGCUCourseList();

	public void removeCourseMappingList(List<CourseMapping> courseMappingList);

	public void addCourseMappings(List<CourseMapping> courseMappingsList);

	public void removeCourseCategoryMappingList(List<CourseCategoryMapping> courseCategoryMappingList);

	public void addCourseCategoryMappingListRelationShip(List<CourseCategoryMapping> courseCategoryMappingList);
	
	public List<TransferCourse> getTodayCompletedCourse(String institutionId);

	public void addTransferCourseInstitutionTranscriptKeyGradeAssocList(List<TransferCourseInstitutionTranscriptKeyGradeAssoc> transferCourseInstitutionTranscriptKeyGradeAssocNewList);

	public List<TransferCourseInstitutionTranscriptKeyGradeAssoc> loadAllTransferCourseInstitutionTranscriptKeyGradeAssocByTransferCourseId(String transferCourseId);

	public void deleteAllGradeAssoc(List<TransferCourseInstitutionTranscriptKeyGradeAssoc> transferCourseInstitutionTranscriptKeyGradeAssocReadList);

	public TransferCourseMirror findTransferCourseMirrorByTransferCourseId(String transferCourseId);

	public TransferCourseMirror findTransferCourseMirrorByTransferCourseIdAndCurrentUserId(
			String transferCourseId, String evaluatorId);
	void createGCUCourseList(List<GCUCourse> gcuCourseList);

	public GcuCourseLevel getGcuCourseLevelById(String gcuCourseLevelId);

	public void addCourseRelationShipDetail(CourseMappingDetail courseMappingDetail);

	public List<CourseMappingDetail> getCourseMappingDetailByCourseMappingId(String courseMappingId);

	public void removeCourseMapping(CourseMapping courseMapping);

	public void removeCourseMappingDetailList(List<CourseMappingDetail> courseMappingDetailList);
	public TransferCourse findTransferCourseByCodeAndInstitution(String courseCode,
			String institutionId);
	public void addTransferCourse(TransferCourse transferCourse);
	/**Added separate Save method of Hibernate because sometimes saveOrUpdate() not works perfectly*/
	public void saveTransferCourse(TransferCourse transferCourse);
	/**Added separate update method of Hibernate because sometimes saveOrUpdate() not works perfectly*/
	public void updateTransferCourse(TransferCourse transferCourse);
}
