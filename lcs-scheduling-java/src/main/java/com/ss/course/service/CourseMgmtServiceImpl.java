package com.ss.course.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ss.common.logging.RequestContext;
import com.ss.common.util.CustomUUIDGenerator;
import com.ss.common.util.ObjectXMLConversion;
import com.ss.common.util.UserUtil;
import com.ss.course.dao.CourseMgmtDAO;
import com.ss.course.dao.CourseMirrorMgmtDAO;
import com.ss.course.value.CourseCategoryMapping;
import com.ss.course.value.CourseMapping;
import com.ss.course.value.CourseMappingDetail;
import com.ss.course.value.GCUCourse;
import com.ss.course.value.MilitarySubject;
import com.ss.course.value.TransferCourse;
import com.ss.course.value.TransferCourseMirror;
import com.ss.course.value.TransferCourseTitle;
import com.ss.evaluation.dao.TranscriptMgmtDAO;
import com.ss.evaluation.dao.TransferCourseMgmtDAO;
import com.ss.evaluation.enums.TranscriptStatusEnum;
import com.ss.evaluation.service.TranscriptService;
import com.ss.evaluation.service.TransferCourseService;
import com.ss.evaluation.value.StudentTranscriptCourse;
import com.ss.institution.dao.InstitutionMirrorMgmtDao;
import com.ss.institution.service.InstitutionService;
import com.ss.institution.service.InstitutionTranscriptKeyService;
import com.ss.institution.value.GcuCourseLevel;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionMirror;
import com.ss.institution.value.TransferCourseInstitutionTranscriptKeyGradeAssoc;
import com.ss.user.dao.UserDAO;
import com.ss.user.service.UserService;
import com.ss.user.value.User;
@Service
public class CourseMgmtServiceImpl implements CourseMgmtService {
	private static transient Logger log = LoggerFactory.getLogger( CourseMgmtServiceImpl.class);
	
	@Autowired
	private CourseMgmtDAO courseMgmtDAO;
	
	@Autowired
	private InstitutionService institutionService;
	
	@Autowired
	private InstitutionMirrorMgmtDao institutionMirrorMgmtDao;
	
	@Autowired
	private CourseMirrorMgmtDAO courseMirrorMgmtDAO;
	
	@Autowired
	private TransferCourseMgmtDAO transferCourseMgmtDAO;
	
	@Autowired
	private TransferCourseService transferCourseService;
	
	@Autowired
	private UserDAO userDAO;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private InstitutionTranscriptKeyService institutionTranscriptKeyService;
	
	@Autowired
	private TranscriptService transcriptService;
	
	@Autowired
	private TranscriptMgmtDAO transcriptMgmtDAO;
	
	@Override
	@Transactional( propagation=Propagation.REQUIRED, readOnly=false, rollbackForClassName={"java.lang.Exception"} )
	public void createCourse(TransferCourse transferCourse) {
		courseMgmtDAO.createCourse(transferCourse);
		
	}

	@Override
	public TransferCourse getTransferCourseByCodeTitle(String courseCode,String courseTitle){
		
		return courseMgmtDAO.getTransferCourseByCodeTitle(courseCode,courseTitle);
	}
	
	@Override
	public TransferCourse getTransferCourseById(String transferCourseId) {
		return courseMgmtDAO.getTransferCourseById(transferCourseId);
	}
	
	
	@Override
	public void addCourseRelationShip(CourseMapping courseMapping) {
		courseMgmtDAO.addCourseRelationShip(courseMapping);
		
	}

	@Override
	public void addCourseCategoryRelationShip(
			CourseCategoryMapping courseCategoryMapping) {
		courseMgmtDAO.addCourseCategoryRelationShip(courseCategoryMapping);
		
	}

	@Override
	public List<CourseCategoryMapping> getAllCourseCategoryMapping() {
		return courseMgmtDAO.getAllCourseCategoryMapping();
	}

	@Override
	public List<CourseMapping> getAllCourseMapping() {
		return courseMgmtDAO.getAllCourseMapping();
	}

	
	@Override
	public List<CourseCategoryMapping> getCourseCategoryMappingByTransferCourseId(
			String transferCourseId) {
		
		return courseMgmtDAO.getCourseCategoryMappingByTransferCourseId(transferCourseId);
	}

	@Override
	public List<CourseMapping> getCourseMappingByTransferCourseId(
			String transferCourseId) {
		List<CourseMapping> courseMappingList=courseMgmtDAO.getCourseMappingByTransferCourseId(transferCourseId);
		List<CourseMappingDetail> courseMappingDetailList = new ArrayList<CourseMappingDetail>();
		GCUCourse gcuCourse;
		if(courseMappingList != null && courseMappingList.size()>0){
			String relatedGCUCourse = null;
			for(CourseMapping cm:courseMappingList){
				courseMappingDetailList = courseMgmtDAO.getCourseMappingDetailByCourseMappingId(cm.getId());
				Collections.sort(courseMappingDetailList);
				if(courseMappingDetailList != null && courseMappingDetailList.size()>0){
					int courseMappingDetailCounter = 0;
					
					for(CourseMappingDetail cmd:courseMappingDetailList){
						gcuCourse=cmd.getGcuCourse();
						if(gcuCourse != null && gcuCourse.getId() != null && !gcuCourse.getId().isEmpty()){
							GcuCourseLevel gcuCourseLevel  = courseMgmtDAO.getGcuCourseLevelById(String.valueOf((int)gcuCourse.getCourseLevelId()));
							if(gcuCourseLevel != null && gcuCourseLevel.getName() != null && !gcuCourseLevel.getName().isEmpty()){
								cmd.getGcuCourse().setGcuCourseLevel(gcuCourseLevel);
							}
						
							if(cm.getId().equals(cmd.getCourseMappingId())){
								if(courseMappingDetailCounter == 0){
									relatedGCUCourse = gcuCourse.getCourseCode();
								}else if(courseMappingDetailCounter > 0 && courseMappingDetailList.size() >1 ){
									relatedGCUCourse = relatedGCUCourse + "<b> AND </b> " + gcuCourse.getCourseCode();
								}
							}
							
							courseMappingDetailCounter = courseMappingDetailCounter + 1;
						}
					}
					
				}
				cm.setRelatedGCUCourseCode(relatedGCUCourse);
				cm.setCourseMappingDetails(courseMappingDetailList);
			}
		}
		return courseMappingList;
	}

	@Override
	public CourseMapping getCourseMapping(String courseMappingId) {
		return courseMgmtDAO.getCourseMapping(courseMappingId);
	}
	
	/**
	 * returns a CourseMapping Object with the CourseMappingDetails populated inside it
	 * @param courseMappingId
	 * @return
	 */
	@Override
	public CourseMapping getCourseMappingWithDetails(String courseMappingId) {
       CourseMapping courseMapping=  courseMgmtDAO.getCourseMapping(courseMappingId);
       List<CourseMappingDetail> courseMappingDetailList = courseMgmtDAO.getCourseMappingDetailByCourseMappingId(courseMapping.getId());
       courseMapping.setCourseMappingDetails(courseMappingDetailList);
 		return courseMapping;
	}
	

	@Override
	public CourseCategoryMapping getCourseCategoryMapping(String courseCategoryMappingId) {
		return courseMgmtDAO.getCourseCategoryMapping(courseCategoryMappingId);
	}

	@Override
	public List<TransferCourse> getAllNotEvalutedTransferCourse() {
		List<TransferCourse> traList=courseMgmtDAO.getAllNotEvalutedTransferCourse();
		Institution institution;
		/*for(TransferCourse tr:traList){
			institution=institutionService.getInstitutionByCodeTitle(tr.getInstitution().getSchoolcode(), "");
			tr.setStrInstName(institution.getName());
		}*/
		return traList;
	}

	
	@Override
	public List<TransferCourse> getAllTransferCourse() {
		return courseMgmtDAO.getAllTransferCourse();
	}

	@Override
	public TransferCourse getOldestNotEvaluatedCourse() {
		return courseMgmtDAO.getOldestNotEvaluatedCourse();
	}

	@Override
	public List<TransferCourse> getTransferCoursesForEvaluation(String institutionId, String evaluatorId) {
		List<TransferCourse> tcList = new ArrayList<TransferCourse>();
		try{
			List<TransferCourseMirror> tcmList =null;
			InstitutionMirror im =null;
			TransferCourse transferCourse;
			im= institutionMirrorMgmtDao.getNotCompletedInstitutionMirrorByEvaluatorIdAndInstitutionId(evaluatorId, institutionId);
			
			if(im!=null){
				// course mirrors associated with the intitution mirror
				tcmList = courseMirrorMgmtDAO.getTransferCourseMirrorsByInstMirrorId(im.getId());
			}
			else{
				// course mirrors with out institution mirror
				tcmList = courseMirrorMgmtDAO.getTEMPCourseMirrorsByEvaluatorId(evaluatorId);
			}
			
			if(tcmList!=null){
				if(tcmList.size() != 0){
					for(TransferCourseMirror tcMirror : tcmList){
						transferCourse= new TransferCourse();
						transferCourse=(TransferCourse)ObjectXMLConversion.decodeXMLToObject(tcMirror.getCourseDetails());
						transferCourse.setId(tcMirror.getTransferCourseId());
						tcList.add(transferCourse);
					}
				}
			}
			
		}catch (Exception e) {
			//log.error("-----"+e,e);
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No Course found for evaluation."+e+" RequestId:"+uniqueId, e);
		}
		
		return tcList;
	}
	
	@Override
	public void markCourseMirrorsAsCompleted(String institutionMirrorId){
		List<TransferCourseMirror> tcmList = courseMirrorMgmtDAO.getTransferCourseMirrorsByInstMirrorId(institutionMirrorId);
		for(TransferCourseMirror tcm : tcmList){
			tcm.setEvaluationStatus("COMPLETED");
			courseMirrorMgmtDAO.addOrUpdateTransferCourseMirror(tcm);
		}
	}

	@Override
	public List<TransferCourse> getNotEvaluatedCoursesByInstitutionId(String institutionId) {
		String currentUserId = UserUtil.getCurrentUser().getId();
		List<TransferCourse> tcList = courseMgmtDAO.getNotEvaluatedCoursesByInstitutionId(institutionId);
		List<TransferCourse> tcListNew = new ArrayList<TransferCourse>();
		for(TransferCourse tc : tcList){
			TransferCourseMirror tcm = courseMirrorMgmtDAO.getTransferCourseMirrorByCourseIdAndEvaluatorId(tc.getId(), currentUserId);
			if(tcm!=null){
				if(!tcm.getEvaluationStatus().equalsIgnoreCase("COMPLETED")){
					tcListNew.add(tc);
				}
			}
			else{
				tcListNew.add(tc);
				if(tc.getCheckedBy() == null){
					tc.setCheckedBy(currentUserId);
				}
				else if(!tc.getCheckedBy().equalsIgnoreCase(currentUserId) && tc.getConfirmedBy() == null){
					tc.setConfirmedBy(currentUserId);
				}
				courseMgmtDAO.addTransferCourse(tc);
			}
			
		}
		
		return tcListNew;
	}

	@Override
	public void updateCourseMirror(TransferCourseMirror transferCourseMirror){
		
		TransferCourse tcInst = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(transferCourseMirror.getCourseDetails());
		String currentUserId = UserUtil.getCurrentUser().getId();
		if(transferCourseMirror.getId()!=null && !transferCourseMirror.getId().isEmpty()){
			TransferCourseMirror tcmOld = courseMirrorMgmtDAO.findById(transferCourseMirror.getId());
			TransferCourse tcOld = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(tcmOld.getCourseDetails());
			
			tcInst.setCourseMappings(tcOld.getCourseMappings());
			tcInst.setCourseCategoryMappings(tcOld.getCourseCategoryMappings());
			tcInst.setTitleList(tcOld.getTitleList());
		}
		else{
			TransferCourse tcourse = courseMgmtDAO.findById(transferCourseMirror.getTransferCourseId());
			tcourse.setTrCourseTitle(tcInst.getTrCourseTitle());
			if(tcourse.getCheckedBy() == null){
				tcourse.setCheckedBy(currentUserId);
				tcourse.setCheckedDate(new Date());
			}
			else if(!tcourse.getCheckedBy().equalsIgnoreCase(currentUserId) && tcourse.getConfirmedBy() == null){
				tcourse.setConfirmedBy(currentUserId);
				tcourse.setConfirmedDate(new Date());
			}
				
			courseMgmtDAO.addTransferCourse(tcourse);
		}
		transferCourseMirror.setCourseDetails(ObjectXMLConversion.encodeObjectToXML(tcInst));
		transferCourseMirror.setModifiedBy(UserUtil.getCurrentUser().getId());
		transferCourseMirror.setModifiedTime(new Date());
		courseMirrorMgmtDAO.saveTransferCourseMirror(transferCourseMirror);
	}
	
	@Override
	public TransferCourseMirror getTempTransferCourseMirrorByTransferCourseIdAndUserId(String transferCourseId, String userId){
		return courseMirrorMgmtDAO.getTempTransferCourseMirrorByCourseIdAndEvaluatorId(transferCourseId, userId);
	}

	@Override
	public void createCourseMirrors(String institutionMirrorId) {
		List<TransferCourseMirror> tcmList = courseMirrorMgmtDAO.getTransferCourseMirrorsByInstMirrorId(institutionMirrorId);
		TransferCourseMirror tcm;
		User currentUser = UserUtil.getCurrentUser();
		if(tcmList==null || tcmList.size()==0){
			InstitutionMirror im = institutionMirrorMgmtDao.findById(institutionMirrorId);
			List<TransferCourse> tcList = courseMgmtDAO.getNotEvaluatedCoursesByInstitutionId(im.getInstitutionId());
			for(TransferCourse tc : tcList){
				tc.getInstitution().setId(im.getInstitutionId());
				tcm = new TransferCourseMirror();
				tcm.setCourseDetails(ObjectXMLConversion.encodeObjectToXML(tc));
				tcm.setCreatedTime(new Date());
				tcm.setEvaluationStatus("TEMP");
				tcm.setEvaluatorId(currentUser.getId());
				tcm.setInstitutionMirrorId(institutionMirrorId);
				tcm.setTransferCourseId(tc.getId());
				
				courseMirrorMgmtDAO.saveTransferCourseMirror(tcm);
				
				if(tc.getCheckedBy() == null || tc.getCheckedBy().isEmpty()){
					tc.setCheckedBy(currentUser.getId());
					tc.setCheckedDate(new Date());
				}
				else if(!tc.getCheckedBy().equalsIgnoreCase(currentUser.getId()) && (tc.getConfirmedBy() == null || tc.getConfirmedBy().isEmpty())){
					tc.setConfirmedBy(currentUser.getId());
					tc.setConfirmedDate(new Date());
				}
				courseMgmtDAO.addTransferCourse(tc);
			}
		}
	}

	@Override
	public List<CourseMapping> getCourseMappingList(String courseMirrorId) {
		TransferCourseMirror tcm = courseMirrorMgmtDAO.findById(courseMirrorId);
		TransferCourse tc = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(tcm.getCourseDetails());
		return tc.getCourseMappings();
	}

	@Override
	public CourseMapping getCourseMappingByCourseMirrorId(
			String courseMirrorId, String courseMappingId) {
		List<CourseMapping> cmList = getCourseMappingList(courseMirrorId);
		for(CourseMapping cm : cmList){
			if((cm.getId()).equals(courseMappingId)){
				return cm;
			}
		}
		return null;
	}

	@Override
	public void addCourseMappingToMirror(String courseMirrorId, CourseMapping cm) {
		TransferCourseMirror tcm = courseMirrorMgmtDAO.findById(courseMirrorId);
		TransferCourse tc = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(tcm.getCourseDetails());
		
		cm.setTrCourseId(tc.getId());
		List<CourseMapping> courseMappings = tc.getCourseMappings();
		CourseMapping cmOld = null;
		if(cm.getId()!=null&&!cm.getId().isEmpty()){
			for(CourseMapping cmInst : courseMappings){
				if(cmInst.getId().equalsIgnoreCase(cm.getId())){
					cmOld = cmInst;
					break;
				}
			}
			courseMappings.remove(cmOld);
		}
		else{
			cm.setId(CustomUUIDGenerator.generateId());
		}
		courseMappings.add(cm);
		tc.setCourseMappings(courseMappings);
		tcm.setCourseDetails(ObjectXMLConversion.encodeObjectToXML(tc));
		courseMirrorMgmtDAO.saveTransferCourseMirror(tcm);
	}

	@Override
	public List<CourseCategoryMapping> getCourseCategoryMappingList(
			String courseMirrorId) {
		TransferCourseMirror tcm = courseMirrorMgmtDAO.findById(courseMirrorId);
		TransferCourse tc = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(tcm.getCourseDetails());
		return tc.getCourseCategoryMappings();
	}

	@Override
	public CourseCategoryMapping getCourseCategoryMappingByCourseMirrorId(
			String courseMirrorId, String courseCategoryMappingId) {
		List<CourseCategoryMapping> ccmList = getCourseCategoryMappingList(courseMirrorId);
		for(CourseCategoryMapping ccm : ccmList){
			if((ccm.getId()).equals(courseCategoryMappingId)){
				return ccm;
			}
		}
		return null;
	}

	@Override
	public void addCourseCategoryMappingToMirror(String courseMirrorId,
			CourseCategoryMapping ccm) {
		TransferCourseMirror tcm = courseMirrorMgmtDAO.findById(courseMirrorId);
		TransferCourse tc = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(tcm.getCourseDetails());
		
		ccm.setTrCourseId(tc.getId());
		List<CourseCategoryMapping> courseCategoryMappings = tc.getCourseCategoryMappings();
		CourseCategoryMapping ccmOld = null;
		if(ccm.getId()!=null&&!ccm.getId().isEmpty()){
			for(CourseCategoryMapping ccmInst : courseCategoryMappings){
				if(ccmInst.getId().equalsIgnoreCase(ccm.getId())){
					ccmOld = ccmInst;
					break;
				}
			}
			courseCategoryMappings.remove(ccmOld);
		}
		else{
			ccm.setId(CustomUUIDGenerator.generateId());
		}
		courseCategoryMappings.add(ccm);
		tc.setCourseCategoryMappings(courseCategoryMappings);
		
		tcm.setCourseDetails(ObjectXMLConversion.encodeObjectToXML(tc));
		courseMirrorMgmtDAO.saveTransferCourseMirror(tcm);
	}
	
	@Override
	public void markTransferCourseMirrorAsCompleted(String transferCourseMirrorId){
		TransferCourseMirror tcm = courseMirrorMgmtDAO.findById(transferCourseMirrorId);
		tcm.setEvaluationStatus(TranscriptStatusEnum.COMPLETED.getValue());
		courseMirrorMgmtDAO.saveTransferCourseMirror(tcm);	
	}
	
	@Override
	public TransferCourseMirror getTransferCourseMirrorById(String transferCourseMirrorId){
		return courseMirrorMgmtDAO.findById(transferCourseMirrorId);
	}

	@Override
	public List<TransferCourse> getConflictCourses() {
		
		return courseMgmtDAO.getConflictCourses();
	}
	
	@Override
	public List<TransferCourse> getConflictCoursesByInstitutionId(String institutionId) {
		
		return courseMgmtDAO.getConflictCoursesByInstitutionId(institutionId);
	}
	
	public List<GCUCourse> getGCUCourseList(String gcuCourseCode){
		List<GCUCourse> gcuCourseList=courseMgmtDAO.getGCUCourseList(gcuCourseCode);
		for(GCUCourse gcuCourse:gcuCourseList){
			gcuCourse.setGcuCourseLevel(courseMgmtDAO.getGcuCourseLevelById(String.valueOf((int)gcuCourse.getCourseLevelId())));
		}
		return gcuCourseList;
	}
	@Override
	public LinkedHashMap<String, TransferCourse> getConflictTransferCourseList(String transferCourseId){
	
		LinkedHashMap<String, TransferCourse> transferCoursesMap= new LinkedHashMap<String, TransferCourse>();
		//List<TransferCourse> transferCourses=new ArrayList<TransferCourse>();
		List<TransferCourseMirror> institutionMirrors = courseMirrorMgmtDAO.getCompletedTransferCourseMirrors(transferCourseId);
		TransferCourse transferCourse;
		if(institutionMirrors != null && !institutionMirrors.isEmpty()){
			for (TransferCourseMirror iMirror:institutionMirrors){
				transferCourse= new TransferCourse();
				transferCourse = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(iMirror.getCourseDetails());
				if(transferCourse != null && transferCourse.getCheckedBy() != null && !transferCourse.getCheckedBy().isEmpty()){
					transferCourse.setEvaluator1(userService.getUserByUserId(iMirror.getEvaluatorId())); 
				}
				transferCoursesMap.put(iMirror.getId(),transferCourse);
			}
		}
		return transferCoursesMap;
		
	}
	
	@Override
	@Transactional( propagation=Propagation.REQUIRED, readOnly=false, rollbackForClassName={"java.lang.Exception"} )
	public void addCoursesWithChilds(TransferCourse transferCourse, boolean isEvalutated){
		if(isEvalutated){
			transferCourse.setEvaluationStatus("EVALUATED");
		}else{
			transferCourse.setEvaluationStatus("NOT EVALUATED");
		}
		
		transferCourse.setModifiedBy(UserUtil.getCurrentUser().getId());
		courseMgmtDAO.addTransferCourse(transferCourse);
		
		if(transferCourse.getCourseMappings().size()>0){
			int cmCount = 0;
			for(CourseMapping cm:transferCourse.getCourseMappings()){
				//for Addition set Id null
				if(cm.getCourseMappingDetails().get(0).getEffectiveDate()!=null){
					
					cm.setId(null);
				/*	if(cmCount == 0){
						cm.setEffective(true);
					}*/
					addCourseRelationShip(cm);
					cmCount = cmCount + 1;
				}
			}
			
		}
		
		if(transferCourse.getCourseCategoryMappings().size()>0){
			int ccmCount = 0;
			for(CourseCategoryMapping ccm : transferCourse.getCourseCategoryMappings()){
				if(ccm.getGcuCourseCategory() != null && ccm.getGcuCourseCategory().getId() != null){
					addCourseCategoryRelationShip(ccm);
					ccmCount = ccmCount + 1;
				}
			}
			
		}
		TransferCourseTitle tctOld;
		if(transferCourse.getTitleList()!=null && transferCourse.getTitleList().size()>0){
			for(TransferCourseTitle tct:transferCourse.getTitleList()){
				//if title already present in main table then edit it else add new title
				int tctCount = 0;
				tctOld=transferCourseMgmtDAO.courseTitlePresentInMain(transferCourse.getId(),tct.getId());
				if(tctOld!=null){
					if(tctCount == 0){
						tctOld.setEffective(true);
					}
					tctOld.setTitle(tct.getTitle());
					tctOld.setEffectiveDate(tct.getEffectiveDate());
					tctOld.setEndDate(tct.getEndDate());
					if(isEvalutated){
						tctOld.setEvaluationStatus("EVALUATED");
					}else{
						tctOld.setEvaluationStatus(tct.getEvaluationStatus());
					}
					tctOld.setTransferCourseId(tct.getTransferCourseId());
					transferCourseMgmtDAO.addTransferCourseTitle(tctOld);
					tctCount = tctCount + 1;
				}else{
					tct.setId(null);
					if(tctCount == 0){
						tct.setEffective(true);
					}
					if(isEvalutated){
						tct.setEvaluationStatus("EVALUATED");
					}
					transferCourseMgmtDAO.addTransferCourseTitle(tct);
					tctCount = tctCount + 1;
				}
					
				
			}
			
		}
		
	}
	
	@Override
	public void removeTransferCourseMirrors(String transferCourseId){
		courseMirrorMgmtDAO.removeTransferCourseMirrors(transferCourseId);
	}

	@Override
	public List<TransferCourseTitle> getCourseTitleList(String courseMirrorId) {
		TransferCourseMirror tcm = courseMirrorMgmtDAO.findById(courseMirrorId);
		TransferCourse tc = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(tcm.getCourseDetails());
		return tc.getTitleList();
	}
	
	@Override
	public TransferCourseTitle getCourseTitleByCourseMirrorId(String courseMirrorId, String courseTitleId){
		List<TransferCourseTitle> ctList = getCourseTitleList(courseMirrorId);
		for(TransferCourseTitle ct : ctList){
			if((ct.getId()).equals(courseTitleId)){
				return ct;
			}
		}
		return null;
	}

	@Override
	public void addCourseTitleToMirror(String courseMirrorId,
			TransferCourseTitle ct) {
		TransferCourseMirror tcm = courseMirrorMgmtDAO.findById(courseMirrorId);
		TransferCourse tc = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(tcm.getCourseDetails());
		
		ct.setTransferCourseId(tc.getId());
		List<TransferCourseTitle> courseTitles = tc.getTitleList();
		TransferCourseTitle ctOld = null;
		if(ct.getId()!=null&&!ct.getId().isEmpty()){
			for(TransferCourseTitle ctInst : courseTitles){
				if(ctInst.getId().equalsIgnoreCase(ct.getId())){
					ctOld = ctInst;
					break;
				}
			}
			courseTitles.remove(ctOld);
		}
		else{
			ct.setId(CustomUUIDGenerator.generateId());
		}
		courseTitles.add(ct);
		tc.setTitleList(courseTitles);
		
		tcm.setCourseDetails(ObjectXMLConversion.encodeObjectToXML(tc));
		courseMirrorMgmtDAO.saveTransferCourseMirror(tcm);
		
	}
	
	@Override
	public List<TransferCourse> getCoursesForReAssignment(){
		List<TransferCourse> reAssignCourseList =  courseMgmtDAO.getCoursesForReAssignment();
		if(reAssignCourseList!=null){
			for(TransferCourse tc : reAssignCourseList){
				if(tc.getCheckedBy()!= null){
					tc.setEvaluator1(userDAO.findById(tc.getCheckedBy()));
				}
				if(tc.getConfirmedBy()!=null){
					tc.setEvaluator2(userDAO.findById(tc.getConfirmedBy()));
				}
			}
		}
		return reAssignCourseList;
	}

	@Override
	public TransferCourse setTransferCourseWithTempMirrorEvaluators(
			String transferCourseId) {
		TransferCourse tc = courseMgmtDAO.findById(transferCourseId);
		TransferCourseMirror tcm1 = getTempTransferCourseMirrorByTransferCourseIdAndUserId(transferCourseId, tc.getCheckedBy());
		TransferCourseMirror tcm2 = getTempTransferCourseMirrorByTransferCourseIdAndUserId(transferCourseId, tc.getConfirmedBy());
		if(tcm1 != null){
			tc.setEvaluator1(userDAO.findById(tc.getCheckedBy()));
		}
		if(tcm2 != null){
			tc.setEvaluator2(userDAO.findById(tc.getConfirmedBy()));
		}
		return tc;
	}

	@Override
	public List<User> getAssignableEvaluatorsForTransferCourse(TransferCourse tc) {
		
		List<User> assignableEvaluatorlist = userDAO.findUsersByRoleId("4");
		List<User> newAssignableEvaluatorList = new ArrayList<User>();
		for(User user : assignableEvaluatorlist){
			if(tc.getCheckedBy() != null){
				if(user.getId().equals(tc.getCheckedBy())){
					continue;
				}
			}
			if(tc.getConfirmedBy() != null){
				if(user.getId().equals(tc.getConfirmedBy())){
					continue;
				}
			}
			newAssignableEvaluatorList.add(user);
			
		}
		return newAssignableEvaluatorList;
	}
	
	@Override
	public void reAssignCourse(String transferCourseId, String fromId, String toId){
		TransferCourseMirror tcm = courseMirrorMgmtDAO.getTransferCourseMirrorByCourseIdAndEvaluatorId(transferCourseId, fromId);
		TransferCourse tc = courseMgmtDAO.findById(transferCourseId);
		if(fromId.equals(tc.getCheckedBy())){
			tc.setCheckedBy(toId);
		}
		else if(fromId.equals(tc.getConfirmedBy())){
			tc.setConfirmedBy(toId);
		}
		tcm.setEvaluatorId(toId);
		
		transferCourseMgmtDAO.addTransferCourse(tc);
		courseMirrorMgmtDAO.saveTransferCourseMirror(tcm);
	}
	
	@Override
	public void effectiveCourseRelationship(String transferCourseId,String courseMappingId) {
		courseMgmtDAO.effectiveCourseRelationship(transferCourseId, courseMappingId);
	}
	@Override
	public void effectiveCourseCtgRelationship(String transferCourseId,String courseCategoryMappingId) {
		courseMgmtDAO.effectiveCourseCtgRelationship(transferCourseId, courseCategoryMappingId);
	}
	@Override
	public void effectiveCourseTitle(String transferCourseId,String courseTitleId) {
		courseMgmtDAO.effectiveCourseTitle(transferCourseId, courseTitleId);
	}

	@Override
	public void effectiveCourseTitleMirror(String transferCourseMirrorId,String courseTitleId) {
		TransferCourseMirror tcm = courseMirrorMgmtDAO.findById(transferCourseMirrorId);
		TransferCourse tc = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(tcm.getCourseDetails());
		for(TransferCourseTitle ct : tc.getTitleList()){
			if(ct.getId().equals(courseTitleId)){
				ct.setEffective(true);
			}else{
				ct.setEffective(false);
			}
		}
		tcm.setCourseDetails(ObjectXMLConversion.encodeObjectToXML(tc));
		courseMirrorMgmtDAO.saveTransferCourseMirror(tcm);
	}
	
	@Override
	public void effectiveCourseCtgRelationshipMirror(String transferCourseMirrorId,String courseCtgRelationshipId) {
		TransferCourseMirror tcm = courseMirrorMgmtDAO.findById(transferCourseMirrorId);
		TransferCourse tc = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(tcm.getCourseDetails());
		for(CourseCategoryMapping ct : tc.getCourseCategoryMappings()){
			if(ct.getId().equals(courseCtgRelationshipId)){
				ct.setEffective(true);
			}else{
				ct.setEffective(false);
			}
		}
		tcm.setCourseDetails(ObjectXMLConversion.encodeObjectToXML(tc));
		courseMirrorMgmtDAO.saveTransferCourseMirror(tcm);
	}
	
	@Override
	public void effectiveCourseRelationshipMirror(String transferCourseMirrorId,String courseRelationshipId) {
		TransferCourseMirror tcm = courseMirrorMgmtDAO.findById(transferCourseMirrorId);
		TransferCourse tc = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(tcm.getCourseDetails());
		for(CourseMapping cm : tc.getCourseMappings()){
			/*if(cm.getId().equals(courseRelationshipId)){
				cm.setEffective(true);
			}else{
				cm.setEffective(false);
			}*/
		}
		tcm.setCourseDetails(ObjectXMLConversion.encodeObjectToXML(tc));
		courseMirrorMgmtDAO.saveTransferCourseMirror(tcm);
	}

	@Override
	public TransferCourse getTransferCourseWithChilds(String transferCourseId) {
		TransferCourse transferCourse=courseMgmtDAO.getTransferCourseById(transferCourseId);
		transferCourse.setTitleList(transferCourseService.getTransferCourseTitlesByTransferCourseId(transferCourseId));
		List<CourseMapping>  courseMappingList = getCourseMappingByTransferCourseId(transferCourseId); 
		Collections.sort(courseMappingList);
		transferCourse.setCourseMappings(courseMappingList != null && !courseMappingList.isEmpty()?courseMappingList:null);
		List<CourseCategoryMapping> courseCategoryMappingList = getCourseCategoryMappingByTransferCourseId(transferCourseId);
		transferCourse.setCourseCategoryMappings(courseCategoryMappingList != null && !courseCategoryMappingList.isEmpty() ? courseCategoryMappingList:null);
		
		if(transferCourse.getInstitution() != null && transferCourse.getInstitution().getId() !=null){
				List<TransferCourseInstitutionTranscriptKeyGradeAssoc>  transferCourseInstitutionTranscriptKeyGradeAssocList = institutionTranscriptKeyService.getTransferCourseInstitutionTranscriptKeyGradeList(transferCourseId, transferCourse.getInstitution().getId());
				transferCourse.setTransferCourseInstitutionTranscriptKeyGradeAssocList(transferCourseInstitutionTranscriptKeyGradeAssocList);
		}
	
		
		return transferCourse;
	}

	@Override
	public List<TransferCourse> getAllNotEvalutedTransferCourseForCurrentUser(
			String currentUserId) {
		// TODO Auto-generated method stub
		return courseMgmtDAO.getAllNotEvalutedTransferCourseForCurrentUser(currentUserId);
	}
	@Override
	public TransferCourseTitle getEffectiveCourseTitleForCourseId(String transferCourseId) {
		return courseMgmtDAO.findEffectiveCourseTitleForCourseId(transferCourseId);
	}
	@Override
	public void updateCourseTitleToMirror(String transferCourseMirrorId,TransferCourse transferCourse,List<TransferCourseTitle> transferCourseTitlelist,TransferCourseTitle transferCourseTitle) {
		
		TransferCourseMirror tcm = courseMirrorMgmtDAO.findById(transferCourseMirrorId);
		TransferCourse tc = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(tcm.getCourseDetails());
		tc.setTrCourseTitle(transferCourseTitle.getTitle());//setting currently effective title
		List<TransferCourseTitle> courseTitles = tc.getTitleList();
		//remove old title list
		tc.getTitleList().removeAll(courseTitles);
		//set New Title List
		tc.setTitleList(transferCourseTitlelist);
		
		tcm.setCourseDetails(ObjectXMLConversion.encodeObjectToXML(tc));
		//courseMirrorMgmtDAO.saveTransferCourseMirror(tcm);
		/**Update the TransferCourse title with effective one
		 * */
		if(transferCourse != null && transferCourse.getId() != null){
			transferCourse.setTrCourseTitle(transferCourseTitle.getTitle());
			courseMgmtDAO.updateTransferCourse(transferCourse);/**Added separate update method of Hibernate because sometimes saveOrUpdate() not works perfectly*/
		}
		if(tcm !=null && tcm.getId() != null && tcm.getId().equalsIgnoreCase(transferCourseMirrorId)){
			courseMirrorMgmtDAO.updateTransferCourseMirror(tcm);
		}
		
	}
	@Override
	public List<GCUCourse> getAllGCUCourseList() {
		// TODO Auto-generated method stub
		return courseMgmtDAO.findAllGCUCourseList();
	}
	@Override
	public void addCourseCategoryMappingListToMirror(String courseMirrorId,List<CourseCategoryMapping> ccm) {
		TransferCourseMirror tcm = courseMirrorMgmtDAO.findById(courseMirrorId);
		TransferCourse tc = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(tcm.getCourseDetails());
		
		List<CourseCategoryMapping> ccmNewList = new ArrayList<CourseCategoryMapping>();
		if(ccm != null && !ccm.isEmpty() ){
			for(CourseCategoryMapping courseCategoryMapping: ccm){
				if(courseCategoryMapping.getGcuCourseCategory() != null && courseCategoryMapping.getGcuCourseCategory().getId() != null){
					courseCategoryMapping.setTrCourseId(tc.getId());
					if(courseCategoryMapping.getGcuCourseCategory().getName() != null && !courseCategoryMapping.getGcuCourseCategory().getName().isEmpty()){
						ccmNewList.add(courseCategoryMapping);					
					}
				}
			}
			
		}
		//Remove Old List
		tc.getCourseCategoryMappings().removeAll(tc.getCourseCategoryMappings());
		//Refer to New List
		tc.setCourseCategoryMappings(ccmNewList);
		if(tc.getCourseMappings() != null && !tc.getCourseMappings().isEmpty()){
			tc.getCourseMappings().removeAll(tc.getCourseMappings());
		}
		tcm.setCourseDetails(ObjectXMLConversion.encodeObjectToXML(tc));
		courseMirrorMgmtDAO.saveTransferCourseMirror(tcm);
	}
	@Override
	public void addCourseMappingListToMirror(String courseMirrorId, List<CourseMapping> cm) {
		TransferCourseMirror tcm = courseMirrorMgmtDAO.findById(courseMirrorId);
		TransferCourse tc = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(tcm.getCourseDetails());
		List<CourseMapping> cmNewList = new ArrayList<CourseMapping>();
		if(cm != null && !cm.isEmpty() ){
			for(CourseMapping courseMapping: cm){
				if(courseMapping.getCourseMappingDetails().size()>0){
					courseMapping.setTrCourseId(tc.getId());
					cmNewList.add(courseMapping);
				}	
			}
			
		}
		//Remove Old List
		tc.getCourseMappings().removeAll(tc.getCourseMappings());
		//Refer to New List
		tc.setCourseMappings(cmNewList);
		if(tc.getCourseCategoryMappings() != null && !tc.getCourseCategoryMappings().isEmpty()){
			tc.getCourseCategoryMappings().removeAll(tc.getCourseCategoryMappings());
		}
		
		tcm.setCourseDetails(ObjectXMLConversion.encodeObjectToXML(tc));
		courseMirrorMgmtDAO.saveTransferCourseMirror(tcm);
	}
	@Override
	public List<TransferCourse> getTodayCompletedCourse(String institutionId){
		return courseMgmtDAO.getTodayCompletedCourse(institutionId);
	}
	
	@Transactional( propagation=Propagation.REQUIRED, readOnly=false, rollbackForClassName={"java.lang.Exception"} )
	@Override
	public void removeCourseMappingList(List<CourseMapping> courseMappingList) {
		for(CourseMapping cm:courseMappingList){
			courseMgmtDAO.removeCourseMappingDetailList(cm.getCourseMappingDetails());
			courseMgmtDAO.removeCourseMapping(cm);
		}
		
	}
	@Override
	public void addCourseMappings(List<CourseMapping> courseMappingsList) {
		
		courseMgmtDAO.addCourseMappings(courseMappingsList);
	}
	@Override
	public void removeCourseCategoryMappingList(List<CourseCategoryMapping> courseCategoryMappingList) {
		
		courseMgmtDAO.removeCourseCategoryMappingList(courseCategoryMappingList);
		
	}
	@Override
	public void addCourseCategoryMappingListRelationShip(List<CourseCategoryMapping> courseCategoryMappingList) {
		
		courseMgmtDAO.addCourseCategoryMappingListRelationShip(courseCategoryMappingList);
		
	}
	@Override
	public void addTrCoursesWithChilds(TransferCourse transferCourse, boolean isEvalutated,boolean isNeedToAddTitle) {
		if(isEvalutated){
			transferCourse.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
		}else{
			transferCourse.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
		}
		transferCourse.setModifiedDate(new Date());
		transferCourse.setModifiedBy(UserUtil.getCurrentUser().getId());
		courseMgmtDAO.addTransferCourse(transferCourse);
		if(isEvalutated && transferCourse.getInstitution() != null && !transferCourse.getInstitution().getId().isEmpty()){
			List<StudentTranscriptCourse> studentTranscriptCourseList = transcriptService.getAllStudentTranscriptCourseByTransferCourseIdAndInstitutionId(transferCourse.getId() ,transferCourse.getInstitution().getId());
			if(studentTranscriptCourseList != null && !studentTranscriptCourseList.isEmpty()){
				for(StudentTranscriptCourse studentTranscriptCourse :studentTranscriptCourseList){
					studentTranscriptCourse.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
					studentTranscriptCourse.setTranscriptStatus(transferCourse.getTransferStatus());
				}				
				transcriptMgmtDAO.saveTranscriptList( studentTranscriptCourseList );
			}
		}
		
		if(transferCourse.getCourseMappings() != null && transferCourse.getCourseMappings().size()>0){
			int cmCount = 0;
			for(CourseMapping cm:transferCourse.getCourseMappings()){
				
				boolean isPersistable = false;
				if(cm.getTrCourseId() != null && !cm.getTrCourseId().isEmpty()){
					
					if(cm.getCourseMappingDetails() != null && !cm.getCourseMappingDetails().isEmpty()){
						
						for(CourseMappingDetail courseMappingDetail : cm.getCourseMappingDetails()){
							
							if(courseMappingDetail.getGcuCourse() != null && courseMappingDetail.getGcuCourse().getId() != null && !courseMappingDetail.getGcuCourse().getId().isEmpty()){
								isPersistable = true;
								break;
							}
						}
					}
				}
				if(isPersistable){
					courseMgmtDAO.addCourseRelationShip(cm);
				}
				
				if(cm.getCourseMappingDetails() != null && !cm.getCourseMappingDetails().isEmpty() && cm.getId() != null){
					
					for(CourseMappingDetail courseMappingDetail : cm.getCourseMappingDetails()){
						
						if(courseMappingDetail.getGcuCourse() != null && courseMappingDetail.getGcuCourse().getId() != null && !courseMappingDetail.getGcuCourse().getId().isEmpty()){
							courseMappingDetail.setCourseMappingId(cm.getId());
							courseMgmtDAO.addCourseRelationShipDetail(courseMappingDetail);
						}
					}
				}
			}
			
		}
		
		if(transferCourse.getCourseCategoryMappings() != null && transferCourse.getCourseCategoryMappings().size()>0){
			int ccmCount = 0;
			for(CourseCategoryMapping ccm:transferCourse.getCourseCategoryMappings()){
					if(ccm.getGcuCourseCategory() != null && ccm.getGcuCourseCategory().getName() != null){
						ccm.setId(null);
						if(ccmCount == 0){
							ccm.setEffective(true);
						}
						addCourseCategoryRelationShip(ccm);
						ccmCount = ccmCount + 1;
				}
			}
		}
		TransferCourseTitle tctOld;
		if(isNeedToAddTitle == true && transferCourse.getTitleList()!=null && transferCourse.getTitleList().size()>0){
			for(TransferCourseTitle tct:transferCourse.getTitleList()){
				//if title already present in main table then edit it else add new title
				int tctCount = 0;
				tctOld=transferCourseMgmtDAO.courseTitlePresentInMain(transferCourse.getId(),tct.getId());
				if(tctOld!=null){
					if(tctCount == 0){
						tctOld.setEffective(true);
					}
					tctOld.setTitle(tct.getTitle());
					tctOld.setEffectiveDate(tct.getEffectiveDate());
					tctOld.setEndDate(tct.getEndDate());
					if(isEvalutated){
						tctOld.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
					}else{
						tctOld.setEvaluationStatus(tct.getEvaluationStatus());
					}
					tctOld.setTransferCourseId(tct.getTransferCourseId());
					transferCourseMgmtDAO.addTransferCourseTitle(tctOld);
					tctCount = tctCount + 1;
				}else{
					tct.setId(null);
					if(tctCount == 0){
						tct.setEffective(true);
					}
					if(isEvalutated){
						tct.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
					}
					tct.setTransferCourseId(transferCourse.getId());
					transferCourseMgmtDAO.addTransferCourseTitle(tct);
					tctCount = tctCount + 1;
				}			
				
			}
			
		}
		List<TransferCourseInstitutionTranscriptKeyGradeAssoc>  transferCourseInstitutionTranscriptKeyGradeAssocNewList= new ArrayList<TransferCourseInstitutionTranscriptKeyGradeAssoc>();
		List<TransferCourseInstitutionTranscriptKeyGradeAssoc>  transferCourseInstitutionTranscriptKeyGradeAssocList= transferCourse.getTransferCourseInstitutionTranscriptKeyGradeAssocList();
		if(transferCourseInstitutionTranscriptKeyGradeAssocList != null && transferCourseInstitutionTranscriptKeyGradeAssocList.size()>0){
			
			for(TransferCourseInstitutionTranscriptKeyGradeAssoc  transferCourseInstitutionTranscriptKeyGradeAssoc : transferCourseInstitutionTranscriptKeyGradeAssocList){
				if(transferCourseInstitutionTranscriptKeyGradeAssoc.getInstitutionTranscriptKeyGradeId() != null && !transferCourseInstitutionTranscriptKeyGradeAssoc.getInstitutionTranscriptKeyGradeId().isEmpty()){
					transferCourseInstitutionTranscriptKeyGradeAssocNewList.add(transferCourseInstitutionTranscriptKeyGradeAssoc);
				}
			}
			List<TransferCourseInstitutionTranscriptKeyGradeAssoc>  transferCourseInstitutionTranscriptKeyGradeAssocReadList= courseMgmtDAO.loadAllTransferCourseInstitutionTranscriptKeyGradeAssocByTransferCourseId(transferCourse.getId());
			if(transferCourseInstitutionTranscriptKeyGradeAssocReadList != null && !transferCourseInstitutionTranscriptKeyGradeAssocReadList.isEmpty()){
				courseMgmtDAO.deleteAllGradeAssoc(transferCourseInstitutionTranscriptKeyGradeAssocReadList);
			}
			courseMgmtDAO.addTransferCourseInstitutionTranscriptKeyGradeAssocList(transferCourseInstitutionTranscriptKeyGradeAssocNewList);
		}
		
	}
	@Override
	public void addTransferCourseInstitutionTranscriptKeyGradeAssocList(
			List<TransferCourseInstitutionTranscriptKeyGradeAssoc> transferCourseInstitutionTranscriptKeyGradeAssocNewList) {
			courseMgmtDAO.addTransferCourseInstitutionTranscriptKeyGradeAssocList(transferCourseInstitutionTranscriptKeyGradeAssocNewList);		
	}
	@Override
	public void deleteAllGradeAssoc(
			List<TransferCourseInstitutionTranscriptKeyGradeAssoc> transferCourseInstitutionTranscriptKeyGradeAssocReadList) {
		courseMgmtDAO.deleteAllGradeAssoc(transferCourseInstitutionTranscriptKeyGradeAssocReadList);
		
	}
	@Override
	public List<TransferCourseInstitutionTranscriptKeyGradeAssoc> loadAllTransferCourseInstitutionTranscriptKeyGradeAssocByTransferCourseId(
			String transferCourseId) {
		// TODO Auto-generated method stub
		return courseMgmtDAO.loadAllTransferCourseInstitutionTranscriptKeyGradeAssocByTransferCourseId(transferCourseId);
	}
	@Override
	public TransferCourseMirror getTransferCourseMirrorByTransferCourseId(
			String transferCourseId) {
		return courseMgmtDAO.findTransferCourseMirrorByTransferCourseId(transferCourseId);
	}
	@Override/*
	@Transactional( propagation=Propagation.REQUIRED, readOnly=false, rollbackForClassName={"java.lang.Exception"} )*/
	public void updateTransferCourseIntoMirror(TransferCourseMirror transferCourseMirror,TransferCourse transferCourse) {
		
		TransferCourse tcInst = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(transferCourseMirror.getCourseDetails());
		String currentUserId = UserUtil.getCurrentUser().getId();
		
		if(transferCourseMirror.getId()!=null && !transferCourseMirror.getId().isEmpty()){
			TransferCourseMirror tcmOld = courseMirrorMgmtDAO.findById(transferCourseMirror.getId());
			TransferCourse tcOld = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(tcmOld.getCourseDetails());
			
			tcInst.setCourseMappings(tcOld.getCourseMappings());
			tcInst.setCourseCategoryMappings(tcOld.getCourseCategoryMappings());
			tcInst.setTitleList(tcOld.getTitleList());
			tcmOld.setCourseDetails(null);
		}else{
			
			if(transferCourse.getCheckedBy() == null){
				transferCourse.setCheckedBy(currentUserId);
				transferCourse.setCheckedDate(new Date());
			}
			else if(transferCourse.getConfirmedBy() == null && !currentUserId.equalsIgnoreCase(transferCourse.getCheckedBy())){
				transferCourse.setConfirmedBy(currentUserId);
				transferCourse.setConfirmedDate(new Date());
			}
				
			
		}
		if(transferCourse.getId() == null || transferCourse.getId().isEmpty()){
			transferCourse.setCreatedBy(UserUtil.getCurrentUser().getId());
			transferCourse.setCreatedDate(new Date());
			transferCourse.setModifiedBy(UserUtil.getCurrentUser().getId());
			transferCourse.setModifiedDate(new Date());
			transferCourse.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
			tcInst.setCreatedBy(UserUtil.getCurrentUser().getId());
			tcInst.setCreatedDate(new Date());
			tcInst.setModifiedBy(UserUtil.getCurrentUser().getId());
			tcInst.setModifiedDate(new Date());
			tcInst.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
			if(transferCourse.getCheckedBy() == null){
				transferCourse.setCheckedBy(currentUserId);
				transferCourse.setCheckedDate(new Date());
			}
			else if(transferCourse.getConfirmedBy() == null && !currentUserId.equalsIgnoreCase(transferCourse.getCheckedBy())){
				transferCourse.setConfirmedBy(currentUserId);
				transferCourse.setConfirmedDate(new Date());
				tcInst.setConfirmedBy(transferCourse.getConfirmedBy()!=null && !transferCourse.getConfirmedBy().isEmpty()?transferCourse.getConfirmedBy():UserUtil.getCurrentUser().getId());
			}
			tcInst.setCheckedBy(transferCourse.getCheckedBy()!=null && !transferCourse.getCheckedBy().isEmpty()?transferCourse.getCheckedBy():null);
		}else{
			transferCourse.setModifiedBy(UserUtil.getCurrentUser().getId());
			transferCourse.setModifiedDate(new Date());
			if(transferCourse.getCheckedBy() == null){
				transferCourse.setCheckedBy(currentUserId);
				transferCourse.setCheckedDate(new Date());
			}
			else if(transferCourse.getConfirmedBy() == null && !currentUserId.equalsIgnoreCase(transferCourse.getCheckedBy())){
				transferCourse.setConfirmedBy(currentUserId);
				transferCourse.setConfirmedDate(new Date());
				tcInst.setConfirmedBy(transferCourse.getConfirmedBy()!=null && !transferCourse.getConfirmedBy().isEmpty()?transferCourse.getConfirmedBy():UserUtil.getCurrentUser().getId());
			}
			tcInst.setModifiedBy(UserUtil.getCurrentUser().getId());
			tcInst.setModifiedDate(new Date());
			tcInst.setCheckedBy(transferCourse.getCheckedBy()!=null && !transferCourse.getCheckedBy().isEmpty()?transferCourse.getCheckedBy():null);
			
		}
		List<TransferCourseTitle> transferCourseTitleList = transferCourse.getTitleList();
		TransferCourse tc = courseMgmtDAO.findTransferCourseByCodeAndInstitution(transferCourse.getTrCourseCode(), transferCourse.getInstitution().getId());
		if(tc == null){
			courseMgmtDAO.saveTransferCourse(transferCourse);/**Added separate Save method of Hibernate because sometimes saveOrUpdate() not works perfectly*/
		}else{
			courseMgmtDAO.updateTransferCourse(transferCourse);/**Added separate update method of Hibernate because sometimes saveOrUpdate() not works perfectly*/
		}
		if(transferCourseTitleList != null && !transferCourseTitleList.isEmpty()){
			for(TransferCourseTitle transferCourseTitle : transferCourseTitleList){
				transferCourseTitle.setTransferCourseId(transferCourse.getId());
			}
		}
		
		/*List<TransferCourseTitle> courseTitleList=transferCourseService.getTransferCourseTitlesByTransferCourseId(transferCourse.getId());
			if(courseTitleList != null && courseTitleList.size()>0){
				transferCourseService.removeTransferCourseTitles(courseTitleList);
		}*/		
		transferCourseService.addTransferCourseTitles(transferCourseTitleList);
		
		/**when we come from create new course at that point we do not have the Transfer Course id,so first save the TransferCourse then set it back to mirror
		 * */
		if(transferCourseMirror.getId() != null && !transferCourseMirror.getId().isEmpty()){
			
			tcInst.setId(transferCourse.getId());
		}
		/**END
		 * */
		transferCourseMirror.setTransferCourseId(transferCourse.getId());
		transferCourseMirror.setCourseDetails(ObjectXMLConversion.encodeObjectToXML(tcInst));
		transferCourseMirror.setModifiedBy(UserUtil.getCurrentUser().getId());
		transferCourseMirror.setModifiedTime(new Date());
		if(transferCourseMirror.getId() != null && !transferCourseMirror.getId().isEmpty()){
			courseMirrorMgmtDAO.mergeTransferCourseMirror(transferCourseMirror);
		}else{
			TransferCourseMirror tCMirror = courseMirrorMgmtDAO.findTransferCourseMirrorByTransferCourseIdUserIdAndInstitutionId(transferCourse.getId(),transferCourseMirror.getEvaluatorId(), transferCourse.getInstitution().getId());
			//courseMirrorMgmtDAO.addOrUpdateTransferCourseMirror(transferCourseMirror);
			
			if(tCMirror == null){
				courseMirrorMgmtDAO.addTransferCourseMirror(transferCourseMirror);
			}else{
				courseMirrorMgmtDAO.updateTransferCourseMirror(transferCourseMirror);
			}
		}
		
	}
	@Override
	public void addTransferCourse(TransferCourse transferCourse) {
		courseMgmtDAO.addTransferCourse(transferCourse);
		
	}
	@Override
	public TransferCourseMirror getTransferCourseMirrorByTransferCourseIdAndCurrentUserId(
			String transferCourseId, String evaluatorId) {
		return courseMgmtDAO.findTransferCourseMirrorByTransferCourseIdAndCurrentUserId(transferCourseId,evaluatorId);
	}
	
	@Override
	public GcuCourseLevel getGcuCourseLevelById(String gcuCourseLevelId){
		return courseMgmtDAO.getGcuCourseLevelById(gcuCourseLevelId);
	}
	@Override
	public void addCourseRelationShipDetail(CourseMappingDetail courseMappingDetail) {
		courseMgmtDAO.addCourseRelationShipDetail(courseMappingDetail);
		
	}
	@Override
	public void updateCourseTitleToMirror(String transferCourseMirrorId,String transferCourseId,
			List<MilitarySubject> militarySubjectList) {
		
		TransferCourseMirror tcm = courseMirrorMgmtDAO.findById(transferCourseMirrorId);
		TransferCourse tc = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(tcm.getCourseDetails());
		
		List<MilitarySubject> militarySubjects = tc.getMilitarySubjectList();
		//remove old title list
		tc.getMilitarySubjectList().removeAll(militarySubjects);
		//set New Title List
		tc.setMilitarySubjectList(militarySubjectList);
		
		tcm.setCourseDetails(ObjectXMLConversion.encodeObjectToXML(tc));
		
		//courseMirrorMgmtDAO.saveTransferCourseMirror(tcm);
		if(tcm !=null && tcm.getId() != null && tcm.getId().equalsIgnoreCase(transferCourseMirrorId)){
			courseMirrorMgmtDAO.updateTransferCourseMirror(tcm);
		}
		
		
	}
	@Override
	public TransferCourse getTransferCourseByCodeAndInstitution(
			String courseCode, String institutionId) {
		return courseMgmtDAO.findTransferCourseByCodeAndInstitution(courseCode,institutionId);
	}
	@Override
	public void saveTransferCourse(TransferCourse transferCourse) {
		courseMgmtDAO.saveTransferCourse(transferCourse);
		
	}
	@Override
	public void updateTransferCourse(TransferCourse transferCourse) {
		courseMgmtDAO.updateTransferCourse(transferCourse);
		
	}
}
