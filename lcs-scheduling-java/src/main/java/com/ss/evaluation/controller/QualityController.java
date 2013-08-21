package com.ss.evaluation.controller;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.beans.propertyeditors.StringTrimmerEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.ss.common.logging.RequestContext;
import com.ss.common.util.Constants;
import com.ss.common.util.CustomUUIDGenerator;
import com.ss.common.util.ObjectXMLConversion;
import com.ss.common.util.UserUtil;
import com.ss.course.service.CourseMgmtService;
import com.ss.course.value.CourseCategoryMapping;
import com.ss.course.value.CourseMapping;
import com.ss.course.value.GCUCourse;
import com.ss.course.value.GCUCourseCategory;
import com.ss.course.value.MilitarySubject;
import com.ss.course.value.TransferCourse;
import com.ss.course.value.TransferCourseMirror;
import com.ss.course.value.TransferCourseTitle;
import com.ss.evaluation.enums.TranscriptStatusEnum;
import com.ss.evaluation.service.EvaluationJobService;
import com.ss.evaluation.service.TransferCourseService;
import com.ss.institution.service.AccreditingBodyInstituteService;
import com.ss.institution.service.ArticulationAgreementService;
import com.ss.institution.service.InstitutionService;
import com.ss.institution.service.InstitutionTermTypeService;
import com.ss.institution.service.InstitutionTranscriptKeyService;
import com.ss.institution.value.AccreditingBodyInstitute;
import com.ss.institution.value.ArticulationAgreement;
import com.ss.institution.value.ArticulationAgreementDetails;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionAddress;
import com.ss.institution.value.InstitutionMirror;
import com.ss.institution.value.InstitutionTermType;
import com.ss.institution.value.InstitutionTranscriptKey;
import com.ss.institution.value.InstitutionTranscriptKeyDetails;
import com.ss.institution.value.InstitutionTranscriptKeyGrade;
import com.ss.institution.value.TransferCourseInstitutionTranscriptKeyGradeAssoc;
import com.ss.messaging.service.JMSMessageSenderService;
import com.ss.user.value.User;

@Controller
@RequestMapping( "/evaluation/quality.html" )
public class QualityController {
	private static transient Logger log = LoggerFactory.getLogger( QualityController.class );
	@Autowired
	private InstitutionService institutionService;
	
	@Autowired
	private CourseMgmtService courseMgmtService;
	
	@Autowired 
	private InstitutionTermTypeService institutionTermTypeService;
	
	@Autowired 
	private InstitutionTranscriptKeyService institutionTranscriptKeyService;
	
	@Autowired
	private AccreditingBodyInstituteService accreditingBodyService;
	
	@Autowired 
	private ArticulationAgreementService articulationAgreementService;
	
	@Autowired
	private TransferCourseService transferCourseService;
	
	@Autowired
	private EvaluationJobService evaluationJobService;
	
	@Autowired
	private JMSMessageSenderService jmsMessageSender;
	
	@InitBinder
	public void allowEmptyDateBinding( WebDataBinder binder )
	{
	    // Allow for null values in date fields.
	    binder.registerCustomEditor( Date.class, new CustomDateEditor( Constants.COMMON_DATE_FORMAT, true ));
	    // tell spring to set empty values as null instead of empty string.
	    binder.registerCustomEditor( String.class, new StringTrimmerEditor( true ));
	}
	
	@RequestMapping( params="operation=initParams" )
	public String initEvaluation( Model model ){	
		model.addAttribute("institutionList",institutionService.getAllNotEvalutedInstitutions());
		model.addAttribute("transferCourseList",courseMgmtService.getAllNotEvalutedTransferCourse());
		return "qualityEvaluation";
	}
	@RequestMapping(params="operation=ieEvaluate")
	public String ieEvaluate( Model model){
		User currentUser = UserUtil.getCurrentUser();
		
		Institution institution = new Institution();
		
		List<TransferCourse> transferCourseList= new ArrayList<TransferCourse>();
		List<TransferCourse> transferCourseTodayCompletedList= new ArrayList<TransferCourse>();
		
		institution=institutionService.getInstitutionForEvaluation();
		if(institution!=null){
			//from Mirror Courses
			transferCourseList=courseMgmtService.getTransferCoursesForEvaluation(institution.getId(), currentUser.getId());
			
			if(transferCourseList.size()>0){
				
			}else{
				//if not in mirror display from main course
				transferCourseList=courseMgmtService.getNotEvaluatedCoursesByInstitutionId(institution.getId());
				
			}
			transferCourseTodayCompletedList=	courseMgmtService.getTodayCompletedCourse(institution.getId());
			model.addAttribute("transferCourseTodayCompletedList",transferCourseTodayCompletedList);
			model.addAttribute("transferCourseList",transferCourseList);
			
			if(institution.getCheckedBy() == null){
				institution.setCheckedBy(currentUser.getId());
			}
			else if(!institution.getCheckedBy().equals(currentUser.getId()) && institution.getConfirmedBy() == null){
				institution.setConfirmedBy(currentUser.getId());
			}
			institutionService.addInstitution(institution);
		}	
			model.addAttribute("evaluationCount",institutionService.getEvaluationCount());
			
			model.addAttribute("institution",institution);
			model.addAttribute("totalEvaluatedCount",institutionService.getTotalEvaluated(currentUser.getId()));
			model.addAttribute("last6MonthEvaluatedCount",institutionService.getLast6MonthEvaluated(currentUser.getId()));
			model.addAttribute("last3MonthEvaluatedCount",institutionService.getLast3MonthEvaluated(currentUser.getId()));
			model.addAttribute("last7DaysEvaluatedCount",institutionService.getLast7DaysEvaluated(currentUser.getId()));
			model.addAttribute("todaysEvaluatedCount",institutionService.getTodaysEvaluated(currentUser.getId()));
			
		
		return "ieEvaluate";
	}
	
	@RequestMapping(params="operation=ieInstitution")
	public String ieInstitution(@RequestParam(value="institutionId", required=false) String institutionId,
			Model model){
		
		
		Institution institution= institutionService.getInstitutionById(institutionId);
		if (institution.getParentInstitutionId()!=null && !institution.getParentInstitutionId().isEmpty()){
			Institution parentInstitution=institutionService.getInstitutionById(institution.getParentInstitutionId());
			institution.setParentInstitutionName(parentInstitution.getName());
		}
		
		institution.setInstitutionTranscript(institutionService.getInstitutionTranscript(institution.getId()));
		
		model.addAttribute("institution",institution);
		model.addAttribute("institutionTypeList",institutionTermTypeService.getAllInstitutionType());
		model.addAttribute("countryList",institutionTermTypeService.getAllCountry());
		model.addAttribute("tabIndex","1");
		model.addAttribute("institutionId",institution.getId());
		model.addAttribute("institutionName",institution.getName());
		//return "ieInstitution";
		return "ieEvaluateInstitutionForm";
	}
	
	@RequestMapping(params="operation=ieSaveInstitution")
	public String ieSaveInstitution(Institution institution, Model model){
		
		
		institutionService.addInstitution(institution);
		return "redirect:/evaluation/quality.html?operation=ieInstitution&institutionId="+institution.getId();
	}
	@RequestMapping(params="operation=ieCourse")
	public String ieCourse(@RequestParam(value="institutionMirrorId",required=false)String institutionMirrorId,
			@RequestParam(value="transferCourseId", required=false) String transferCourseId,@RequestParam(value="effecTiveTrCourseTitle", required=false) String effecTiveTrCourseTitle,
			@RequestParam(value="vaildationMsg", required=false) String vaildationMsg  ,@RequestParam(value="directLink", required=false) String directLink, Model model){
		
		TransferCourse transferCourse = null;
		TransferCourse transferCourseOrignal = null;
		User currentUser = UserUtil.getCurrentUser();
		List<CourseMapping> courseMappingList = null;
		List<CourseCategoryMapping> courseCategoryMappingList = null;
		List<InstitutionTranscriptKeyGrade>  institutionTranscriptKeyGradeList = null;
		List<TransferCourseInstitutionTranscriptKeyGradeAssoc>  transferCourseInstitutionTranscriptKeyGradeAssocList = null;
		TransferCourseMirror transferCourseMirror = null;
		//If mirror Entry present  for currently logging user then display from mirror Otherwise check if mirror entry available for this transfer course else show from original
				
		//transferCourseMirror = courseMgmtService.getTempTransferCourseMirrorByTransferCourseIdAndUserId(transferCourseId,currentUser.getId());
		if(transferCourseId != null){
			transferCourseOrignal = courseMgmtService.getTransferCourseById(transferCourseId);
		}
		transferCourseMirror = courseMgmtService.getTransferCourseMirrorByTransferCourseIdAndCurrentUserId(transferCourseId,currentUser.getId());
		
		if(transferCourseMirror!=null  ){
			
			transferCourse=(TransferCourse)ObjectXMLConversion.decodeXMLToObject(transferCourseMirror.getCourseDetails());
			
			if(effecTiveTrCourseTitle != null && !effecTiveTrCourseTitle.isEmpty()){
				transferCourse.setTrCourseTitle(effecTiveTrCourseTitle);
			}
			model.addAttribute("currentUserHaveEntryInMirror", "1");
			model.addAttribute("transferCourseMirrorId",transferCourseMirror.getId());
			
			courseMappingList = transferCourse.getCourseMappings();
			courseCategoryMappingList = transferCourse.getCourseCategoryMappings();
			transferCourse.setId(transferCourseMirror.getTransferCourseId());
			transferCourse.setCheckedBy(transferCourseOrignal.getCheckedBy() != null && !transferCourseOrignal.getCheckedBy().isEmpty()?transferCourseOrignal.getCheckedBy():transferCourse.getCheckedBy()!=null && !transferCourse.getCheckedBy().isEmpty()?transferCourse.getCheckedBy():null);
			transferCourse.setConfirmedBy(transferCourseOrignal.getConfirmedBy() != null && !transferCourseOrignal.getConfirmedBy().isEmpty()?transferCourseOrignal.getConfirmedBy():transferCourse.getConfirmedBy()!= null && !transferCourse.getConfirmedBy().isEmpty()?transferCourse.getConfirmedBy():null);
			transferCourse.setEvaluationStatus(transferCourseOrignal.getEvaluationStatus() != null && !transferCourseOrignal.getEvaluationStatus().isEmpty() ? transferCourseOrignal.getEvaluationStatus():transferCourse.getEvaluationStatus());
			transferCourseInstitutionTranscriptKeyGradeAssocList = transferCourse.getTransferCourseInstitutionTranscriptKeyGradeAssocList();			
			
		}else{
			
			transferCourseMirror = courseMgmtService.getTransferCourseMirrorByTransferCourseId(transferCourseId);
			if(transferCourseMirror!=null ){
				transferCourse = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(transferCourseMirror.getCourseDetails());
				transferCourse.setId(transferCourseId);
				transferCourse.setCheckedBy(transferCourseOrignal.getCheckedBy() != null && !transferCourseOrignal.getCheckedBy().isEmpty()?transferCourseOrignal.getCheckedBy():transferCourse.getCheckedBy()!=null && !transferCourse.getCheckedBy().isEmpty()?transferCourse.getCheckedBy():null);
				transferCourse.setConfirmedBy(transferCourseOrignal.getConfirmedBy() != null && !transferCourseOrignal.getConfirmedBy().isEmpty()?transferCourseOrignal.getConfirmedBy():transferCourse.getConfirmedBy()!= null && !transferCourse.getConfirmedBy().isEmpty()?transferCourse.getConfirmedBy():null);
				transferCourse.setEvaluationStatus(transferCourseOrignal.getEvaluationStatus() != null && !transferCourseOrignal.getEvaluationStatus().isEmpty() ? transferCourseOrignal.getEvaluationStatus():transferCourse.getEvaluationStatus());
				if(effecTiveTrCourseTitle != null && !effecTiveTrCourseTitle.isEmpty()){
					transferCourse.setTrCourseTitle(effecTiveTrCourseTitle);
				}
				if(!transferCourseMirror.getEvaluatorId().equals(UserUtil.getCurrentUser().getId())){
					/** If current user is not the evaluator in the TransferCourseMirror for the transfer course then delete the CourseMapping and courseCategoryMapping
					 * */
					transferCourse.getCourseMappings().removeAll(transferCourse.getCourseMappings());
					transferCourse.getCourseCategoryMappings().removeAll(transferCourse.getCourseCategoryMappings());
					model.addAttribute("currentUserHaveEntryInMirror", "0");
				}else{
					model.addAttribute("currentUserHaveEntryInMirror", "1");
					model.addAttribute("transferCourseMirrorId",transferCourseMirror.getId());
				}
				List<TransferCourseMirror> transferCourseMirrors = evaluationJobService.getCompletedTransferCourseMirrors(transferCourseId);
				if(transferCourseMirrors != null && !transferCourseMirrors.isEmpty() && transferCourseMirrors.size() == 2){
					TransferCourseMirror transferCourseMirrorOfIe2 = transferCourseMirrors.get(1);
					TransferCourse transferCourseOfIe2 = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(transferCourseMirrorOfIe2.getCourseDetails());
					transferCourse.setCourseMappings(transferCourseOfIe2.getCourseMappings());
					transferCourse.setCourseCategoryMappings(transferCourseOfIe2.getCourseCategoryMappings());
					model.addAttribute("currentUserHaveEntryInMainDb", "1");//In case ie1, ie2 have mirror entry but Course still 'NOT EVALUATED'
					model.addAttribute("transferCourseMirrorId",transferCourseMirrorOfIe2.getId());//set the IE2 TransnferCoursMirrorId
				}
				
				/*
				courseMappingList = courseMgmtService.getCourseMappingList(transferCourseMirror.getId());
				courseCategoryMappingList = courseMgmtService.getCourseCategoryMappingList(transferCourseMirror.getId());*/
				transferCourseInstitutionTranscriptKeyGradeAssocList = transferCourse.getTransferCourseInstitutionTranscriptKeyGradeAssocList();
			}else{
				transferCourse=courseMgmtService.getTransferCourseById(transferCourseId);
				TransferCourseTitle transferCourseTitle = courseMgmtService.getEffectiveCourseTitleForCourseId(transferCourseId);
				transferCourse.setTrCourseTitle(transferCourseTitle!=null && transferCourseTitle.getTitle()!=null && !transferCourseTitle.getTitle().equals("")?transferCourseTitle.getTitle():transferCourse.getTrCourseTitle());
				transferCourseInstitutionTranscriptKeyGradeAssocList = institutionTranscriptKeyService.getTransferCourseInstitutionTranscriptKeyGradeList(transferCourseId,institutionMirrorId);
				if(transferCourse.getEvaluationStatus().equals(TranscriptStatusEnum.EVALUATED.getValue())){
					courseCategoryMappingList = courseMgmtService.getCourseCategoryMappingByTransferCourseId(transferCourseId);
					courseMappingList = courseMgmtService.getCourseMappingByTransferCourseId(transferCourseId);
					transferCourse.setCourseMappings(courseMappingList);
					transferCourse.setCourseCategoryMappings(courseCategoryMappingList);
					model.addAttribute("currentUserHaveEntryInMainDb", "1");
				}
			}
		}
		if(institutionMirrorId!=null && !institutionMirrorId.isEmpty()){
			InstitutionMirror institutionMirror = institutionService.getInstitutionMirrorById(institutionMirrorId);
			model.addAttribute("institutionMirror",institutionMirror!=null ? institutionMirror:institutionService.getInstitutionById(institutionMirrorId));
		}
		
		
		InstitutionTermType institutionTermType = null;
		/**START JIRA LCSCHED-240
			Semester Credits calculation on Course Details screen should display the value as of today*/
		institutionTermType = institutionTermTypeService.getCurrentlyEffectiveInstitutionTermType(new Date(),transferCourse.getInstitution().getId());
		/**END JIRA LCSCHED-240*/
		/**START IF term type does not exist according to today date then get the last modified term type from available list*/
		if(institutionTermType == null){
			List<InstitutionTermType> instTermTypeList = institutionTermTypeService.getAllInstitutionTermType(transferCourse.getInstitution().getId());
			if(instTermTypeList != null && instTermTypeList.size() > 0){
				institutionTermType = instTermTypeList.get(0);
			}
		}
		/**END*/
		transferCourse.setCourseTranscript(transferCourseService.getCourseTranscript(transferCourse.getId()));
		institutionTranscriptKeyGradeList = institutionTranscriptKeyService.getInstitutionTranscriptKeyGradeListByInstitutionId(institutionMirrorId);
		if(transferCourseInstitutionTranscriptKeyGradeAssocList != null && !transferCourseInstitutionTranscriptKeyGradeAssocList.isEmpty() && institutionTranscriptKeyGradeList != null && !institutionTranscriptKeyGradeList.isEmpty()){
			for(InstitutionTranscriptKeyGrade institutionTranscriptKeyGrade :institutionTranscriptKeyGradeList){
				boolean found = false;
				for(TransferCourseInstitutionTranscriptKeyGradeAssoc transferCourseInstitutionTranscriptKeyGradeAssoc :transferCourseInstitutionTranscriptKeyGradeAssocList){
					if(transferCourseInstitutionTranscriptKeyGradeAssoc.getInstitutionTranscriptKeyGradeId().equals(institutionTranscriptKeyGrade.getId())){
						found = true;
						institutionTranscriptKeyGrade.setGradeAssocId(transferCourseInstitutionTranscriptKeyGradeAssoc.getId());
						break;
					}
					
				}
				if(found){
					institutionTranscriptKeyGrade.setSelected(true);
				}
				
			}
		}
		model.addAttribute("transferCourse" ,transferCourse);
		
		model.addAttribute("gcuCourseLevelList",institutionTranscriptKeyService.getAllGcuCourseLevel());
		//model.addAttribute("institutionList",institutionService.getAllInstitutions());
		model.addAttribute("institution",institutionService.getInstitutionById(transferCourse.getInstitution().getId()));
		//pass inst term type to evaluate equivalent semester credits
		model.addAttribute("institutionTermType",institutionTermType);
		//pass the course mappings and course category list for validation
		model.addAttribute("courseMappingList",courseMappingList);
		model.addAttribute("courseCategoryMappingList",courseCategoryMappingList);
		
		model.addAttribute("tabIndex","1");
		model.addAttribute("transferCourseId" ,transferCourse.getId());
		model.addAttribute("institutionId",transferCourse.getInstitution().getId());
		model.addAttribute("comingFromIECycle","1");
		model.addAttribute("institutionTranscriptKeyGradeList", institutionTranscriptKeyGradeList);
		model.addAttribute("institutionTranscriptKeyGradeId", institutionTranscriptKeyGradeList!=null && !institutionTranscriptKeyGradeList.isEmpty()?institutionTranscriptKeyGradeList.get(0).getInstitutionTranscriptKey().getId():null);
		model.addAttribute("validationMSG" ,vaildationMsg);
		model.addAttribute("directLink",directLink);
		//return "ieCourse";
		return "ieEvaluateCourseForm";
	}
	
	@RequestMapping(params="operation=ieSaveCourse")
	public String ieSaveCourse(@RequestParam(value="institutionMirrorId",required=false) String institutionMirrorId,
			@RequestParam(value="transferCourseMirrorId",required=false) String transferCourseMirrorId,
			@RequestParam(value="institutionId",required=false) String institutionId,
			@RequestParam(value="saveAndNext",required=false) String saveAndNext,@RequestParam(value="directLink", required=false) String directLink, 
			TransferCourse transferCourse,Model model){
		String vaildationMsg = "";
		
		if(transferCourse.isCollegeApprovalRequired() == false){
			TransferCourseMirror transferCourseMirror= new TransferCourseMirror();
			if(transferCourseMirrorId!=null && !transferCourseMirrorId.isEmpty()){
				transferCourseMirror = courseMgmtService.getTransferCourseMirrorById(transferCourseMirrorId);
				transferCourseMirror.setId(transferCourseMirrorId);
				transferCourseMirror.setEvaluationStatus(transferCourseMirror.getEvaluationStatus());
				transferCourseMirror.setEvaluatorId(UserUtil.getCurrentUser().getId());
			}else{
				transferCourseMirror.setCreatedTime(new Date());  
				transferCourseMirror.setEvaluationStatus(TranscriptStatusEnum.TEMP.getValue());
				transferCourseMirror.setEvaluatorId(UserUtil.getCurrentUser().getId());
			}
			
			transferCourseMirror.setTransferCourseId(transferCourse.getId());
			if(institutionMirrorId !=null && !institutionMirrorId.isEmpty()){
				transferCourseMirror.setInstitutionMirrorId(institutionMirrorId);
			}
			else if(institutionId !=null && !institutionId.isEmpty()){
				institutionMirrorId = institutionId;
				transferCourseMirror.setInstitutionMirrorId(institutionMirrorId);
			}
	//		transferCourseMirror.setCollegeApprovalRequired(!transferCourse.isCollegeApprovalRequired());
			
			Institution institution= institutionService.getInstitutionById(institutionId);
			
			transferCourse.setInstitution(institution);
			transferCourse.setTrCourseTitle(transferCourse.getTitleList().get(0).getTitle());
			//before creating xml String insert the title list in transferCourse which is already present(entered by DEO)
			List<TransferCourseTitle> titleNewList = new ArrayList<TransferCourseTitle>();
			List<TransferCourseTitle> titleList=transferCourseService.getTransferCourseTitlesByTransferCourseId(transferCourse.getId());
			if(titleList != null && titleList.size() != 0){
				for(TransferCourseTitle tctTitle : titleList){
					tctTitle.setTransferCourseId(transferCourse.getId());
					
					tctTitle.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
					if(tctTitle.getTitle().equals(transferCourse.getTrCourseTitle())){
						//set the effective date and end date if the course title matches					
						tctTitle.setEffective(true);
					}else{
						tctTitle.setEffective(false);
					}
					titleNewList.add(tctTitle);
				}
			}
			else{
				if (titleList==null)
					titleList= new ArrayList<TransferCourseTitle>();
				TransferCourseTitle tct = new TransferCourseTitle();
				//tct.setId(CustomUUIDGenerator.generateId());
				tct.setTransferCourseId(transferCourse.getId());
				tct.setEffectiveDate(transferCourse.getEffectiveDate());
				tct.setEndDate(transferCourse.getEndDate());
				tct.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
				tct.setEffective(true);
				tct.setTitle(transferCourse.getTitleList().get(0).getTitle());
				
				titleNewList.add(tct);
			}
			transferCourse.setTitleList(titleNewList);
			List<TransferCourseInstitutionTranscriptKeyGradeAssoc>  transcriptKeyGradeAssocList = new ArrayList<TransferCourseInstitutionTranscriptKeyGradeAssoc>();
			if(transferCourse.getTransferCourseInstitutionTranscriptKeyGradeAssocList() != null && !transferCourse.getTransferCourseInstitutionTranscriptKeyGradeAssocList().isEmpty()){
				for(TransferCourseInstitutionTranscriptKeyGradeAssoc transferCourseInstitutionTranscriptKeyGradeAssoc : transferCourse.getTransferCourseInstitutionTranscriptKeyGradeAssocList()){
					if(transferCourseInstitutionTranscriptKeyGradeAssoc.getInstitutionTranscriptKeyGradeId() != null  &&  !transferCourseInstitutionTranscriptKeyGradeAssoc.getInstitutionTranscriptKeyGradeId().isEmpty()){
						transcriptKeyGradeAssocList.add(transferCourseInstitutionTranscriptKeyGradeAssoc);
					}
				}
			}
			transferCourse.getTransferCourseInstitutionTranscriptKeyGradeAssocList().removeAll(transferCourse.getTransferCourseInstitutionTranscriptKeyGradeAssocList());
			transferCourse.setTransferCourseInstitutionTranscriptKeyGradeAssocList(transcriptKeyGradeAssocList);
			
			transferCourseMirror.setCourseDetails(ObjectXMLConversion.encodeObjectToXML(transferCourse));		
			TransferCourse checkTransferCourse = null;
			
			if(directLink != null && !directLink.isEmpty() &&  directLink.equals("0")){/**Check If Coming from CreateCourse link directly then look for Duplicate*/
				checkTransferCourse = courseMgmtService.getTransferCourseByCodeAndInstitution(transferCourse.getTrCourseCode(), institutionId);
			}else{
				//Not require to check for duplicate
			}
			
			if(checkTransferCourse == null){
				courseMgmtService.updateTransferCourseIntoMirror(transferCourseMirror,transferCourse);
			}else{
				transferCourse.setId(checkTransferCourse.getId());
				vaildationMsg = "The Course "+transferCourse.getTrCourseCode()+" is already exist for Institution.";
				model.addAttribute("validationMSG" ,vaildationMsg);
			}
			//if Course is send for College Approval then add it in main table if it is already then it will update 
	/*		if(transferCourse.isCollegeApprovalRequired()){
				courseMgmtService.addCoursesWithChilds(transferCourse, false);
				// mirrors to be removed as the course is sent to IEM
				courseMgmtService.removeTransferCourseMirrors(transferCourse.getId());
				transferCourse.setCheckedBy(null);
				transferCourse.setConfirmedBy(null);
				transferCourseService.addTransferCourse(transferCourse);
			} */
			if(saveAndNext.equals("0")){
				return "redirect:/evaluation/quality.html?operation=ieCourse&institutionMirrorId="+institutionMirrorId+"&transferCourseId="+transferCourse.getId()+"&vaildationMsg="+vaildationMsg;
			}else{
				if(checkTransferCourse == null && transferCourse.getTransferStatus().equals("Not Eligible")){
					return "redirect:/evaluation/quality.html?operation=markCompletePreviewCourse&transferCourseMirrorId="+transferCourseMirror.getId();
				}else if(checkTransferCourse == null && transferCourse.getTransferStatus().equals("Eligible")){
					return "redirect:/evaluation/quality.html?operation=manageCourseRelationship&transferCourseMirrorId="+transferCourseMirror.getId();
				}else{
					return "redirect:/evaluation/quality.html?operation=ieCourse&institutionMirrorId="+institutionMirrorId+"&transferCourseId="+transferCourse.getId()+"&vaildationMsg="+vaildationMsg;
				}
			}
		}else{
			if(transferCourseMirrorId!=null && !transferCourseMirrorId.isEmpty()){
				TransferCourseMirror tcm = courseMgmtService.getTransferCourseMirrorById(transferCourseMirrorId);
				TransferCourse tcfromMirror = (TransferCourse) ObjectXMLConversion.decodeXMLToObject(tcm.getCourseDetails());
				courseMgmtService.addTrCoursesWithChilds(tcfromMirror, false,true);
				// mirrors to be removed as the course is sent to IEM
				courseMgmtService.removeTransferCourseMirrors(tcfromMirror.getId());
			}
			transferCourse.setCollegeApprovalRequired(true);			
			transferCourse.setCheckedBy(null);
			transferCourse.setConfirmedBy(null);
			Institution institution= institutionService.getInstitutionById(institutionId);
			transferCourse.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
			transferCourse.setInstitution(institution);
			transferCourse.setTrCourseTitle(transferCourse.getTitleList().get(0).getTitle());
			transferCourseService.addTransferCourse(transferCourse);
			
			return "redirect:/evaluation/quality.html?operation=ieEvaluate";
		}
	}
	


	@RequestMapping(params="operation=manageAccreditingBody" )
	public String manageAccreditingBody(@RequestParam("institutionMirrorId") String institutionMirrorId, Model model ){	
		List<AccreditingBodyInstitute> accreditingBodyList = accreditingBodyService.getAccreditingBodyInstituteList(institutionMirrorId);
		
		putInstitution(institutionMirrorId,model);
		model.addAttribute( "accreditingBodyList",accreditingBodyList);
		
		
		
		
		model.addAttribute("tabIndex","2");
		//return "ieManageAccreditingBody";
		return "ieEvaluateInstitutionForm";
	
	}
	

	@RequestMapping(params="operation=addAccreditingBody" )
	public String addAccreditingBody(@RequestParam("institutionMirrorId") String institutionMirrorId,
			@RequestParam(value="accreditingBodyInstId", required=false) String accreditingBodyInstId,
			Model model ){		
		
		if(accreditingBodyInstId !=  null){
			AccreditingBodyInstitute accreditingBodyInstitute= 	accreditingBodyService.getAccreditingBodyInstituteByInstitutionMirrorId(
						institutionMirrorId, accreditingBodyInstId);
			model.addAttribute("accreditingBodyInstitute",accreditingBodyInstitute);
		}
		
		model.addAttribute("institutionMirrorId",institutionMirrorId);
		model.addAttribute("accreditingBodyList",accreditingBodyService.getAllAccreditingBody());
		
		return "ieAddAccreditingBody";
	}
	
	@RequestMapping(params="operation=saveAccreditingBody" )
	public String saveAccreditingBody(@RequestParam("accreditingBody.id") String accreditingBodyId,
			@RequestParam("accreditingBodyName") String accreditingBodyName,
			@RequestParam("institutionMirrorId") String institutionMirrorId,
			AccreditingBodyInstitute abi, Model model ){
		
		// get institutionId from institutionMirrorId and set in AccreditingBodyInstitute
		abi.getAccreditingBody().setId(accreditingBodyId);
		abi.getAccreditingBody().setName(accreditingBodyName);
		accreditingBodyService.addAccreditingBodyInstituteToMirror(institutionMirrorId, abi);
		
		return "redirect:quality.html?operation=manageAccreditingBody&institutionMirrorId="+institutionMirrorId;
		
	}

	@RequestMapping(params="operation=manageInstitutionTermType" )
	public String manageInstitutionTermType(@RequestParam("institutionMirrorId") String institutionMirrorId, Model model ){	
		List<InstitutionTermType> institutionTermTypeList = institutionTermTypeService.getInstitutionTermTypeList(institutionMirrorId);
		
		putInstitution(institutionMirrorId,model);
		
		model.addAttribute( "institutionTermTypeList",institutionTermTypeList);
		model.addAttribute("institutionMirrorId",institutionMirrorId);
		
		//return "ieManageInstitutionTermType";
		
		model.addAttribute("tabIndex","3");
		return "ieEvaluateInstitutionForm";
	
	}
	

	@RequestMapping(params="operation=addInstitutionTermType" )
	public String addInstitutionTermType(@RequestParam("institutionMirrorId") String institutionMirrorId,
			@RequestParam(value="institutionTermTypeId", required=false) String institutionTermTypeId,
			Model model ){		
		
		if(institutionTermTypeId !=  null){
			InstitutionTermType InstitutionTermType= institutionTermTypeService.getInstitutionTermTypeByInititutionMirrorId(institutionMirrorId, institutionTermTypeId);
			model.addAttribute("institutionTermType",InstitutionTermType);
		}
		model.addAttribute("institutionMirrorId",institutionMirrorId);
		model.addAttribute("termTypeList",institutionTermTypeService.getAllTermType());
		
		return "ieAddInstitutionTermType";
	}
	
	@RequestMapping(params="operation=saveInstitutionTermType" )
	public String saveInstitutionTermType(	@RequestParam("termType.id") String termTypeId,
			@RequestParam("termTypeName") String termTypeName,
			@RequestParam("institutionMirrorId") String institutionMirrorId,
			InstitutionTermType institutionTermType, Model model ){	
		institutionTermType.getTermType().setId(termTypeId);
		institutionTermType.getTermType().setName(termTypeName);
		institutionTermTypeService.addInstitutionTermTypeToMirror(institutionMirrorId, institutionTermType);
		
		return "redirect:quality.html?operation=manageInstitutionTermType&institutionMirrorId="+institutionMirrorId;
		
	}
	
	
	@RequestMapping(params="operation=manageInstitutionTranscriptKey" )
	public String manageInstitutionTranscriptKey(@RequestParam("institutionMirrorId") String institutionMirrorId, Model model ){	
		List<InstitutionTranscriptKey> institutionTranscriptKeyList = institutionTranscriptKeyService.getInstitutionTranscriptKeyList(institutionMirrorId);
		
		putInstitution(institutionMirrorId,model);
		
		model.addAttribute( "institutionTranscriptKeyList",institutionTranscriptKeyList);
		model.addAttribute("institutionMirrorId",institutionMirrorId);
		//return "ieManageInstitutionTranscriptKey";
		
		model.addAttribute("tabIndex","4");
		return "ieEvaluateInstitutionForm";
	
	}
	

	@RequestMapping(params="operation=addInstitutionTranscriptKey" )
	public String addInstitutionTranscriptKey(@RequestParam("institutionMirrorId") String institutionMirrorId,
			@RequestParam(value="institutionTranscriptKeyId", required=false) String institutionTranscriptKeyId,
			Model model ){		
		InstitutionTranscriptKey institutionTranscriptKey= new InstitutionTranscriptKey();
		
		List<InstitutionTranscriptKeyDetails> institutionTranscriptKeyDetailsList = new ArrayList<InstitutionTranscriptKeyDetails>();
		institutionTranscriptKey.setInstitutionTranscriptKeyDetailsList(institutionTranscriptKeyDetailsList);
		if(institutionTranscriptKeyId !=  null){
			 institutionTranscriptKey= institutionTranscriptKeyService.
			 getInstitutionTranscriptKeyByInititutionMirrorId(institutionMirrorId, institutionTranscriptKeyId);
		}
		model.addAttribute("institutionTranscriptKey", institutionTranscriptKey);
		model.addAttribute("institutionMirrorId",institutionMirrorId);
		model.addAttribute("gcuCourseLevelList",institutionTranscriptKeyService.getAllGcuCourseLevel());
		
		return "ieAddInstitutionTranscriptKey";
	}
	
	@RequestMapping(params="operation=saveInstitutionTranscriptKey" )
	public String saveInstitutionTranscriptKey(@ModelAttribute("institutionTranscriptKey")InstitutionTranscriptKey institutionTranscriptKey,
			@RequestParam("institutionMirrorId") String institutionMirrorId,Model model ){
		institutionTranscriptKeyService.addInstitutionTranscriptKeyToMirror(institutionMirrorId, institutionTranscriptKey);
		return "redirect:quality.html?operation=manageInstitutionTranscriptKey&institutionMirrorId="+institutionMirrorId;
		
	}
	
	@RequestMapping(params="operation=manageArticulationAgreement" )
	public String manageArticulationAgreement(@RequestParam("institutionMirrorId") String institutionMirrorId, Model model ){	
		List<ArticulationAgreement> articulationAgreementList = articulationAgreementService.getArticulationAgreementList(institutionMirrorId);
		
		putInstitution(institutionMirrorId,model);
		
		model.addAttribute( "articulationAgreementList",articulationAgreementList);
		model.addAttribute("institutionMirrorId",institutionMirrorId);
		
		//return "ieManageArticulationAgreement";
		
		model.addAttribute("tabIndex","5");
		return "ieEvaluateInstitutionForm";
	
	}
	

	@RequestMapping(params="operation=addArticulationAgreement" )
	public String addArticulationAgreement(@RequestParam("institutionMirrorId") String institutionMirrorId,
			@RequestParam(value="articulationAgreementId", required=false) String articulationAgreementId,
			Model model ){		
		ArticulationAgreement articulationAgreement= new ArticulationAgreement();
		
		List<ArticulationAgreementDetails> articulationAgreementDetailsList = new ArrayList<ArticulationAgreementDetails>();
		articulationAgreement.setArticulationAgreementDetailsList(articulationAgreementDetailsList);
		if(articulationAgreementId !=  null){
			 articulationAgreement= articulationAgreementService.
			 getArticulationAgreementByInititutionMirrorId(institutionMirrorId, articulationAgreementId);
		}
		model.addAttribute("articulationAgreement", articulationAgreement);
		model.addAttribute("institutionMirrorId",institutionMirrorId);
		model.addAttribute("gcuCourseCategoryList",articulationAgreementService.getAllGcuCourseCategory());
		
		return "ieAddArticulationAgreement";
	}
	
	@RequestMapping(params="operation=saveArticulationAgreement" )
	public String saveArticulationAgreement(@ModelAttribute("articulationAgreement")ArticulationAgreement articulationAgreement,
			@RequestParam("institutionMirrorId") String institutionMirrorId,Model model ){
		articulationAgreementService.addArticulationAgreementToMirror(institutionMirrorId, articulationAgreement);
		return "redirect:quality.html?operation=manageArticulationAgreement&institutionMirrorId="+institutionMirrorId;
		
	}
	
	@RequestMapping(params="operation=manageCourseRelationship" )
	public String manageCourseRelationship(@RequestParam("transferCourseMirrorId") String transferCourseMirrorId, Model model ){
			//List<CourseMapping> courseMappingList = courseMgmtService.getCourseMappingList(transferCourseMirrorId);
				//List<GCUCourse>  gcuCourseList = courseMgmtService.getAllGCUCourseList();
				//For category List
				List<CourseCategoryMapping> courseCategoryMappingList = courseMgmtService.getCourseCategoryMappingList(transferCourseMirrorId);
				//putCourse(transferCourseMirrorId, model);
				TransferCourseMirror tcm = courseMgmtService.getTransferCourseMirrorById(transferCourseMirrorId);
				TransferCourse transferCourse = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(tcm.getCourseDetails());
				List<CourseMapping> courseMappingList = transferCourse.getCourseMappings()!=null && !transferCourse.getCourseMappings().isEmpty()?transferCourse.getCourseMappings():null;
				if(transferCourse != null && transferCourse.getId() !=null){
					TransferCourse transferCourseOrignal = transferCourseService.getTransferCourseById(transferCourse.getId());
					transferCourse.setEvaluationStatus(transferCourseOrignal.getEvaluationStatus());
				}else{
					transferCourse.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
				}
				Institution institution= institutionService.getInstitutionById(transferCourse.getInstitution().getId());
				model.addAttribute( "transferCourse",transferCourse);
				model.addAttribute( "courseMappingList",courseMappingList); 
				model.addAttribute( "transferCourseMirrorId",transferCourseMirrorId);
				model.addAttribute("institutionMirrorId", tcm.getInstitutionMirrorId());
				model.addAttribute("transferCourseId", tcm.getTransferCourseId());
				
				List<GCUCourseCategory> gcuCourseCategoryList = articulationAgreementService.getAllGcuCourseCategory();
				model.addAttribute( "courseCategoryMappingList",courseCategoryMappingList);
				model.addAttribute("gcuCourseCategoryList", gcuCourseCategoryList);
			//	model.addAttribute( "gcuCourseList",gcuCourseList);
				model.addAttribute("role",UserUtil.getCurrentRole().getDescription());
				model.addAttribute("tabIndex","2");
				model.addAttribute("institution",institution);
				//return "ieManageCourseRelationship";
				return "ieEvaluateCourseForm";
	}
	

	@RequestMapping(params="operation=addCourseRelationship" )
	public String addCourseRetationship(@RequestParam("transferCourseMirrorId") String transferCourseMirrorId,
			@RequestParam(value="courseMappingId", required=false) String courseMappingId,
			Model model ){		
		
		if(courseMappingId !=  null){
			CourseMapping courseMapping= courseMgmtService.getCourseMappingByCourseMirrorId(transferCourseMirrorId, courseMappingId);
			model.addAttribute("courseMapping",courseMapping);
			model.addAttribute("courseMappingId",courseMappingId);
			
		}
		model.addAttribute("transferCourseMirrorId",transferCourseMirrorId);
		
		return "ieAddCourseRelationship";
	}
	
	@RequestMapping(params="operation=saveCourseRelationship" )
	public String handleCourseRetationship(@RequestParam("transferCourseMirrorId") String transferCourseMirrorId, CourseMapping courseMapping, HttpServletRequest request, Model model ){		
		GCUCourse gcuCourse = new GCUCourse();
		gcuCourse.setId(request.getParameter("gcuCourse.id"));
		//gcuCourse.setCourseCode(request.getParameter("gcuCourse.courseCode"));
		//gcuCourse.setTitle(request.getParameter("gcuCourse.title"));
		//gcuCourse.setCredits(Float.parseFloat(request.getParameter("gcuCourse.credits")));
		//gcuCourse.setCourseLevelId((int)Float.parseFloat(request.getParameter("gcuCourse.courseLevelId")));
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	    try {
			gcuCourse.setDateAdded(df.parse(request.getParameter("gcuCourse.dateAdded")));
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Exception while adding Course relationship."+e+" RequestId:"+uniqueId, e);
			e.printStackTrace();
		}
		
		
		//courseMapping.setGcuCourse(gcuCourse);
		
		courseMgmtService.addCourseMappingToMirror(transferCourseMirrorId, courseMapping);
		
		return "redirect:/evaluation/quality.html?operation=manageCourseRelationship&transferCourseMirrorId="+transferCourseMirrorId;
		
	}
	
	@RequestMapping(params="operation=manageCourseTitles" )
	public String manageCourseTitles(@RequestParam("transferCourseMirrorId") String transferCourseMirrorId, Model model ){	
		List<TransferCourseTitle> courseTitleList = courseMgmtService.getCourseTitleList(transferCourseMirrorId);
		
		putCourse(transferCourseMirrorId, model);
		model.addAttribute( "courseTitleList",courseTitleList);
		model.addAttribute("tabIndex","4");
		//return "ieManageCourseTitles";
		return "ieEvaluateCourseForm";
	}
	

	@RequestMapping(params="operation=addCourseTitle" )
	public String addCourseTitle(@RequestParam("transferCourseMirrorId") String transferCourseMirrorId,
			@RequestParam(value="courseTitleId", required=false) String courseTitleId,
			Model model ){		
		
		if(courseTitleId !=  null){
			TransferCourseTitle courseTitle= courseMgmtService.getCourseTitleByCourseMirrorId(transferCourseMirrorId, courseTitleId);
			model.addAttribute("courseTitle",courseTitle);
			model.addAttribute("courseTitleId",courseTitleId);
			
		}
		model.addAttribute("transferCourseMirrorId",transferCourseMirrorId);
		
		return "ieAddCourseTitle";
	}
	
	@RequestMapping(params="operation=saveCourseTitles" )
	public String handleCourseTitles(@RequestParam("transferCourseMirrorId") String transferCourseMirrorId, TransferCourseTitle transferCourseTitle, Model model ){		
		courseMgmtService.addCourseTitleToMirror(transferCourseMirrorId, transferCourseTitle);
		
		return "redirect:/evaluation/quality.html?operation=manageCourseTitles&transferCourseMirrorId="+transferCourseMirrorId;
		
	}
	
	@RequestMapping(params="operation=manageCourseCtgRelationship" )
	public String manageCourseCtgRelationship(@RequestParam("transferCourseMirrorId") String transferCourseMirrorId, Model model ){	
		List<CourseCategoryMapping> courseCategoryMappingList = courseMgmtService.getCourseCategoryMappingList(transferCourseMirrorId);
		putCourse(transferCourseMirrorId, model);
		model.addAttribute( "courseCategoryMappingList",courseCategoryMappingList);
			model.addAttribute("tabIndex","3");
		//return "ieManageCourseCtgRelationship";
		return "ieEvaluateCourseForm";
	}
	
	@RequestMapping(params="operation=addCourseCtgRelationship" )
	public String addCourseCtgRelationship(@RequestParam("transferCourseMirrorId") String transferCourseMirrorId,
			@RequestParam(value="courseCategoryMappingId", required=false) String courseCategoryMappingId,
			Model model ){	
		
		if(courseCategoryMappingId !=  null){
			CourseCategoryMapping courseCategoryMapping= courseMgmtService.getCourseCategoryMappingByCourseMirrorId(transferCourseMirrorId, courseCategoryMappingId);
			model.addAttribute("courseCategoryMapping",courseCategoryMapping);
			model.addAttribute("courseCategoryMappingId",courseCategoryMappingId);
			
		}
		model.addAttribute( "transferCourseMirrorId",transferCourseMirrorId);
		model.addAttribute("gcuCourseCategoryList",articulationAgreementService.getAllGcuCourseCategory());
		return "ieAddCourseCtgRelationship";
	}
	
	@RequestMapping(params="operation=saveCourseCtgRelationship" )
	public String handleCourseCtgRetationship(@RequestParam("transferCourseMirrorId") String transferCourseMirrorId,
			@RequestParam("gcuCourseCategoryName") String gcuCourseCategoryName,
			CourseCategoryMapping courseCategoryMapping, Model model ){		
		
		courseCategoryMapping.getGcuCourseCategory().setName(gcuCourseCategoryName);
		courseMgmtService.addCourseCategoryMappingToMirror(transferCourseMirrorId, courseCategoryMapping);
		return "redirect:/evaluation/quality.html?operation=manageCourseCtgRelationship&transferCourseMirrorId="+transferCourseMirrorId;
	}
	
	@RequestMapping(params="operation=markComplete" )
	public String markComplete(@RequestParam("institutionId") String institutionId, Model model){
		String currentUserId = UserUtil.getCurrentUser().getId();
		Institution institution= institutionService.getInstitutionById(institutionId);
		
		if(institution.getCheckedBy() == null){
			institution.setCheckedBy(currentUserId);
		}
		else if(!institution.getCheckedBy().equals(currentUserId) && institution.getConfirmedBy() == null){
			institution.setConfirmedBy(currentUserId);
		}
		
		if(currentUserId.equalsIgnoreCase(institution.getCheckedBy())){
			institution.setCheckedStatus(TranscriptStatusEnum.COMPLETED.getValue());
		}else if(currentUserId.equalsIgnoreCase(institution.getConfirmedBy())){
			institution.setConfirmedStatus(TranscriptStatusEnum.COMPLETED.getValue());
		}
	
		if(institution.getCheckedStatus()!=null && institution.getConfirmedStatus()!=null &&
				institution.getCheckedStatus().equalsIgnoreCase(TranscriptStatusEnum.COMPLETED.getValue())
				&& institution.getConfirmedStatus().equalsIgnoreCase(TranscriptStatusEnum.COMPLETED.getValue())){
			institution.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
			try{
				jmsMessageSender.sendCreateOrUpdateInstitutionEvent(institution);
			}catch(Exception e){
				String uniqueId = RequestContext.getRequestIdFromContext();
				log.error("Exception Occured In JMS Message Sending."+e+" RequestId:"+uniqueId, e);
			}
		}
		institutionService.addInstitution(institution);
		return "redirect:/evaluation/quality.html?operation=ieEvaluate";
		
	}
	
	@RequestMapping(params="operation=markCompleteCourse" )
	public String markCompleteCourse(@RequestParam("transferCourseMirrorId") String transferCourseMirrorId, Model model){
		courseMgmtService.markTransferCourseMirrorAsCompleted(transferCourseMirrorId);
		return "redirect:/evaluation/quality.html?operation=ieEvaluate";
		
	}

	@RequestMapping(params="operation=sendForCollegeApproval" )
	public String sendForCollegeApproval(@RequestParam(value="transferCourseMirrorId",required=false)String transferCourseMirrorId,
			@RequestParam("transferCourseId") String transferCourseId){
		
		if(transferCourseMirrorId!=null && !transferCourseMirrorId.isEmpty()){
			TransferCourseMirror tcm = courseMgmtService.getTransferCourseMirrorById(transferCourseMirrorId);
			TransferCourse tcfromMirror = (TransferCourse) ObjectXMLConversion.decodeXMLToObject(tcm.getCourseDetails());
			courseMgmtService.addCoursesWithChilds(tcfromMirror, false);
		}
		TransferCourse transferCourse = courseMgmtService.getTransferCourseById(transferCourseId);
		transferCourse.setCollegeApprovalRequired(true);
		// mirrors to be removed as the course is sent to IEM
		courseMgmtService.removeTransferCourseMirrors(transferCourseId);
		transferCourse.setCheckedBy(null);
		transferCourse.setConfirmedBy(null);
		transferCourseService.addTransferCourse(transferCourse);
		
		return "redirect:/evaluation/quality.html?operation=ieEvaluate";
	}
	
	@RequestMapping(params="operation=skipInstitution" )
	public String skipInstitutionNCourse(@RequestParam(value="institutionId")String institutionId){
		institutionService.skipInstitutionNCourse(institutionId);
		return "redirect:/evaluation/quality.html?operation=ieEvaluate";
	}
	
	@RequestMapping(params="operation=getCourseCode")
	public ModelAndView getCourseCodeByAC(
			@RequestParam("gcuCourseCode") String gcuCourseCode,Model model){
		
		List<GCUCourse> gcuclist = courseMgmtService.getGCUCourseList(gcuCourseCode);
		Map<String, List<GCUCourse>> map = new HashMap<String, List<GCUCourse>>();
		map.put(Constants.FLEX_JSON_DATA, gcuclist);
		
		return new ModelAndView(Constants.FLEX_JSON_VIEW, map);
	}
	/*-----------------*/
	@RequestMapping(params="operation=effectiveAccreditingBody" )
	public String effectiveAccreditingBody(@RequestParam("institutionMirrorId") String institutionMirrorId, 
			@RequestParam("accreditingBodyId") String accreditingBodyId,Model model ){	
		
		accreditingBodyService.effectiveAccreditingBodyMirror(institutionMirrorId,accreditingBodyId);
		return "redirect:quality.html?operation=manageAccreditingBody&institutionMirrorId="+institutionMirrorId;
	}
	@RequestMapping(params="operation=effectiveTranscriptKey" )
	public String effectiveTranscriptKey(@RequestParam("institutionMirrorId") String institutionMirrorId,
			@RequestParam("transcriptKeyId") String transcriptKeyId,Model model ){	
		
		institutionTranscriptKeyService.effectiveTranscriptKeyMirror(institutionMirrorId, transcriptKeyId);
		return "redirect:quality.html?operation=manageInstitutionTranscriptKey&institutionMirrorId="+institutionMirrorId;
	}
	@RequestMapping(params="operation=effectiveTermType" )
	public String effectiveTermType(@RequestParam("institutionMirrorId") String institutionMirrorId,
			@RequestParam("termTypeId") String termTypeId,Model model ){	
		institutionTermTypeService.effectiveTermTypeMirror(institutionMirrorId, termTypeId);
		return "redirect:quality.html?operation=manageInstitutionTermType&institutionMirrorId="+institutionMirrorId;
	}
	@RequestMapping(params="operation=effectiveArticulationAgreement" )
	public String effectiveArticulationAgreement(@RequestParam("institutionMirrorId") String institutionMirrorId, 
			@RequestParam("articulationAgreementId") String articulationAgreementId,Model model ){	
		
		articulationAgreementService.effectiveArticulationAgreementMirror(institutionMirrorId, articulationAgreementId);
		return "redirect:quality.html?operation=manageArticulationAgreement&institutionMirrorId="+institutionMirrorId;
	}
	/*-----------------*/
	@RequestMapping(params="operation=effectiveCourseRelationship" )
	public String effectiveCourseRelationship(@RequestParam("transferCourseMirrorId") String transferCourseMirrorId,
			@RequestParam("courseMappingId") String courseMappingId,Model model ){	
		courseMgmtService.effectiveCourseRelationshipMirror(transferCourseMirrorId, courseMappingId);
		
		return "redirect:quality.html?operation=manageCourseRelationship&transferCourseMirrorId="+transferCourseMirrorId;
	}
	@RequestMapping(params="operation=effectiveCourseCtgRelationship" )
	public String effectiveCourseCtgRelationship(@RequestParam("courseCategoryMappingId") String courseCategoryMappingId,
			@RequestParam("transferCourseMirrorId") String transferCourseMirrorId, Model model ){	
		courseMgmtService.effectiveCourseCtgRelationshipMirror(transferCourseMirrorId, courseCategoryMappingId);
		
		return "redirect:quality.html?operation=manageCourseCtgRelationship&transferCourseMirrorId="+transferCourseMirrorId;
	}
	@RequestMapping(params="operation=effectiveCourseTitles" )
	public String effectiveCourseTitles(@RequestParam("transferCourseMirrorId") String transferCourseMirrorId, 
			@RequestParam("courseTitleId") String courseTitleId,Model model ){	
		courseMgmtService.effectiveCourseTitleMirror(transferCourseMirrorId, courseTitleId);
		
		return "redirect:quality.html?operation=manageCourseTitles&transferCourseMirrorId="+transferCourseMirrorId;
	}

	private void putInstitution(String institutionMirrorId,Model model){
		InstitutionMirror im=institutionService.getInstitutionMirrorById(institutionMirrorId);
		Institution  institution =(Institution) ObjectXMLConversion.decodeXMLToObject(im.getInstitutionDetails());
		model.addAttribute("institutionId", im.getInstitutionId());
		model.addAttribute("institution", institution);
	}
	private void putCourse(String transferCourseMirrorId,Model model){
		TransferCourseMirror tcm=courseMgmtService.getTransferCourseMirrorById(transferCourseMirrorId);
		TransferCourse transferCourse=(TransferCourse)ObjectXMLConversion.decodeXMLToObject(tcm.getCourseDetails());
		List<CourseMapping> courseMappingList = transferCourse.getCourseMappings()!=null && !transferCourse.getCourseMappings().isEmpty()?transferCourse.getCourseMappings():null;
		
		
		model.addAttribute( "transferCourse",transferCourse);
		model.addAttribute( "courseMappingList",courseMappingList); 
		model.addAttribute( "transferCourseMirrorId",transferCourseMirrorId);
		model.addAttribute("institutionMirrorId", tcm.getInstitutionMirrorId());
		model.addAttribute("transferCourseId", tcm.getTransferCourseId());
	
	}
	
	@RequestMapping(params="operation=markCompletePreview" )
	public String markCompletePreview(@RequestParam("institutionMirrorId") String institutionMirrorId, Model model ){	
		putInstitution(institutionMirrorId, model);
		model.addAttribute("tabIndex","6");
		model.addAttribute("institutionMirrorId",institutionMirrorId);
		return "ieEvaluateInstitutionForm";		
		
	
	}
	@RequestMapping(params="operation=markCompletePreviewCourse" )
	public String markCompletePreviewCourse(@RequestParam("transferCourseMirrorId") String transferCourseMirrorId, Model model ){		
		TransferCourseMirror tcm = courseMgmtService.getTransferCourseMirrorById(transferCourseMirrorId);
		TransferCourse transferCourse = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(tcm.getCourseDetails());
		List<CourseMapping> courseMappingList = transferCourse.getCourseMappings()!=null && !transferCourse.getCourseMappings().isEmpty()?transferCourse.getCourseMappings():null;
		
		if(transferCourse != null && transferCourse.getId() !=null){
			TransferCourse transferCourseOrignal = transferCourseService.getTransferCourseById(transferCourse.getId());
			transferCourse.setEvaluationStatus(transferCourseOrignal.getEvaluationStatus());
		}else{
			transferCourse.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
		}
		model.addAttribute( "transferCourse",transferCourse);
		model.addAttribute( "courseMappingList",courseMappingList); 
		model.addAttribute( "transferCourseMirrorId",transferCourseMirrorId);
		model.addAttribute("institutionMirrorId", tcm.getInstitutionMirrorId());
		model.addAttribute("transferCourseId", tcm.getTransferCourseId());
		
		model.addAttribute("tabIndex","5");
		
		return "ieEvaluateCourseForm";		
		
	
	}
	@RequestMapping(params="operation=selectInstitueQueueEvaluation")
	public String selectInstitueQueueEvaluation( Model model){
		User currentUser = UserUtil.getCurrentUser();
		List<Institution> institutionList = new ArrayList<Institution>();
		List<Institution> institutionNewList = new ArrayList<Institution>();
		List<String> institutationIds = new ArrayList<String>();
		List<String> institutationNewIds = new ArrayList<String>();
		List<String> institutationSITIds = new ArrayList<String>();
		LinkedHashSet<String> setOfInstitutationIds = new LinkedHashSet<String>();
		//Getting TransferCourse list which hava Not Evalutated
		List<TransferCourse> transferCourseList = courseMgmtService.getAllNotEvalutedTransferCourseForCurrentUser(currentUser.getId());
		if(transferCourseList!=null && transferCourseList.size()>0){
			for(TransferCourse tc:transferCourseList){
				institutationIds.add(tc.getInstitution().getId());
			}
		}
		// convert into set to remove duplicate institutation_Id
		setOfInstitutationIds.addAll(institutationIds);
		// convert into list again so that user view will be same overtime and also to remove duplicate institutation_Id
		institutationNewIds.addAll(setOfInstitutationIds);
		
		//get all the Institutes which does not have courses
		List<Institution> institutionNotInList = institutionService.getInstituteForEvalutationForCurrentUserNotIn(currentUser.getId(), institutationNewIds);
		
		//STEP:1 Now prepare the list of institutes which have List of TransferCourses
		if(institutationNewIds!=null && institutationNewIds.size()>0){
			for(String institutationId:institutationNewIds){
				List<TransferCourse> transferCourseForInstituteList = new ArrayList<TransferCourse>();
				Institution institution = null;
				for(TransferCourse tc2:transferCourseList){
					if(institutationId.equals(tc2.getInstitution().getId())){
						institution = tc2.getInstitution();
						transferCourseForInstituteList.add(tc2);
					}
				}
				institution.setTransferCourses(transferCourseForInstituteList);
				institutionNewList.add(institution);
			}
			
		}
		//STEP:2 Now Merge the Step1 List oh Institution with the Institutes which does not have TransferCourses insides
		if(institutionNotInList!=null && institutionNotInList.size()>0){
			for(Institution in:institutionNotInList){
				institutionNewList.add(in);
				institutationNewIds.add(in.getId());
			}
		}
		Collections.sort(institutionNewList);
		model.addAttribute("institutionList",institutionNewList);
		model.addAttribute("institutationNewIds",institutationNewIds);
		
		return "ieEvaluateInstitutionQueue";
	}

	@RequestMapping(params="operation=ieEvaluateInstituteAndCourse")
	public String ieEvaluateInstituteAndCourse(@RequestParam(value="institutionId", required=false) String institutionId, Model model){
		User currentUser = UserUtil.getCurrentUser();	

		Institution institution = institutionService.getInstitutionById(institutionId);
		InstitutionMirror institutionMirror =new InstitutionMirror();
		List<TransferCourse> transferCourseList= new ArrayList<TransferCourse>();
		
		
			institutionMirror =	institutionService.getInstitutionMirrorByInstitutionId(institution.getId());
			
			
			//from Mirror Courses
			/*transferCourseList = courseMgmtService.getTransferCoursesForEvaluation(institution.getId(), currentUser.getId());
			
			if(transferCourseList.size()>0){
				
			}else{
				//if not in mirror display from main course
				transferCourseList=courseMgmtService.getNotEvaluatedCoursesByInstitutionId(institution.getId());
				
			}*/
			transferCourseList=courseMgmtService.getNotEvaluatedCoursesByInstitutionId(institution.getId());
			model.addAttribute("transferCourseList",transferCourseList);
		
			model.addAttribute("institutionMirror",institutionMirror);
			model.addAttribute("institution",institution);
		
		
		return "ieSelectedEvalutation";
	}
	@RequestMapping(params="operation=loadAddress" )
	public String loadAddress(@RequestParam("institutionId") String institutionId,
			@RequestParam(value="addressId", required=false) String addressId,Model model ){	
		InstitutionAddress institutionAddress= new InstitutionAddress();
		if(addressId!=null && !addressId.isEmpty()){
			institutionAddress= institutionService.getInstitutionAddress(addressId);
		}
		
		model.addAttribute("institutionAddress",institutionAddress);
		model.addAttribute("countryList",institutionTermTypeService.getAllCountry());
		model.addAttribute("institutionId",institutionId);
		return "addAddress";
	}
	
	@RequestMapping(params="operation=addAddress" )
	public String addAddress(InstitutionAddress institutionAddress ,Model model ){	
		
		institutionService.addInstitutionAddress(institutionAddress);
		
		return "redirect:/evaluation/ieManager.html?operation=createInstitution&institutionId="+institutionAddress.getInstitutionId();
	}
	@RequestMapping(params="operation=releaseToQueue" )
	public String releaseToQueue(@RequestParam(value="institutionId")String institutionId,Model model){
		institutionService.resetConfirmByCheckedBy(institutionId);
		model.addAttribute("evaluationCount",institutionService.getEvaluationCount());
		model.addAttribute("institution",new Institution());
	
	
	return "ieEvaluate";
	}
	@RequestMapping(params="operation=saveTransferCourseTitle" )
	public String saveTransferCourseTitle(TransferCourse transferCourse,
			@RequestParam(value="institutionId",required=false)String institutionMirrorId,
			@RequestParam(value="transferCourseMirrorId", required =false) String transferCourseMirrorId,
			@RequestParam(value="currentlyActiveTitleIndex", required =false) int currentlyActiveTitleIndex,
			@RequestParam(value="transferCourseMirrorIdExist", required =false) String transferCourseMirrorIdExist,
			@RequestParam(value="transferCourseId", required =false) String transferCourseId,Model model ){
		List<TransferCourseTitle> titleList = new ArrayList<TransferCourseTitle>();
		int effctiveCount = 0;
		if(transferCourse.getTitleList() != null && transferCourse.getTitleList().size() >0){
			for(TransferCourseTitle transferCourseTitle:transferCourse.getTitleList()){
				if(transferCourseTitle != null && transferCourseTitle.getTitle() != null && !transferCourseTitle.getTitle().equals("")){
					transferCourseTitle.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
					transferCourseTitle.setTransferCourseId(transferCourseId);
					if(effctiveCount == currentlyActiveTitleIndex){
						transferCourseTitle.setEffective(true);	
						transferCourse.setTrCourseTitle(transferCourseTitle.getTitle());
					}else{
						transferCourseTitle.setEffective(false);
					}
					titleList.add(transferCourseTitle);
					
					
				}
				
				effctiveCount = effctiveCount + 1;
			}
			
		}
		/*List<TransferCourseTitle> courseTitleList = transferCourseService.getTransferCourseTitlesByTransferCourseId(transferCourseId);
		if(courseTitleList != null && courseTitleList.size()>0){
			transferCourseService.removeTransferCourseTitles(courseTitleList);
		}*/
		transferCourseService.addTransferCourseTitles(titleList);
		TransferCourse trCourse = transferCourseService.getTransferCourseById(transferCourseId);
		
		if(transferCourseMirrorIdExist.equals("1"))
			courseMgmtService.updateCourseTitleToMirror(transferCourseMirrorId,trCourse, transferCourse.getTitleList(),transferCourse.getTitleList().get(currentlyActiveTitleIndex));
		
		return "redirect:/evaluation/quality.html?operation=ieCourse&institutionMirrorId="+institutionMirrorId+"&transferCourseId="+transferCourseId+"&effecTiveTrCourseTitle="+trCourse.getTrCourseTitle();
		
	}
	@RequestMapping(params="operation=saveCourseCtgRelationshipList" )
	public String saveCourseCtgRelationshipList(@RequestParam("transferCourseMirrorId") String transferCourseMirrorId,
			@RequestParam(value="saveAndNext",required=false) String saveAndNext,
			TransferCourse transferCourse, Model model ){		
		
		courseMgmtService.addCourseCategoryMappingListToMirror(transferCourseMirrorId, transferCourse.getCourseCategoryMappings());
		if(saveAndNext.equals("0")){
			return "redirect:/evaluation/quality.html?operation=manageCourseRelationship&transferCourseMirrorId="+transferCourseMirrorId;
		}else {
			return "redirect:/evaluation/quality.html?operation=markCompletePreviewCourse&transferCourseMirrorId="+transferCourseMirrorId;
		}
	}
	@RequestMapping(params="operation=saveCourseRelationshipList" )
	public String saveCourseRelationshipList(@RequestParam("transferCourseMirrorId") String transferCourseMirrorId,
			@RequestParam(value="saveAndNext",required=false) String saveAndNext,
			TransferCourse transferCourse, HttpServletRequest request, Model model ){
		
			courseMgmtService.addCourseMappingListToMirror(transferCourseMirrorId, transferCourse.getCourseMappings());
		
			if(saveAndNext.equals("0")){
				return "redirect:/evaluation/quality.html?operation=manageCourseRelationship&transferCourseMirrorId="+transferCourseMirrorId;
			}else {
				return "redirect:/evaluation/quality.html?operation=markCompletePreviewCourse&transferCourseMirrorId="+transferCourseMirrorId;
			}	
		
	}
	@RequestMapping(params="operation=saveTransferCourseMilitarySubject" )
	public String saveTransferCourseMilitarySubject(TransferCourse transferCourse,
			@RequestParam(value="institutionId",required=false) String institutionMirrorId,
			@RequestParam(value="transferCourseMirrorId", required =false) String transferCourseMirrorId,
			@RequestParam(value="transferCourseMirrorIdExist", required =false) String transferCourseMirrorIdExist,
			@RequestParam(value="transferCourseId", required =false) String transferCourseId,Model model ){
		List<MilitarySubject> titleList = new ArrayList<MilitarySubject>();
		
		if(transferCourse.getMilitarySubjectList() != null && transferCourse.getMilitarySubjectList().size() >0){
			for(MilitarySubject militarySubject : transferCourse.getMilitarySubjectList()){
				if(militarySubject != null && militarySubject.getName() != null && !militarySubject.getName().equals("")){
					if(militarySubject.getCreatedBy() == null || militarySubject.getCreatedBy().equals("")){
						militarySubject.setCreatedBy(UserUtil.getCurrentUser().getId());
						militarySubject.setCreatedBy(UserUtil.getCurrentUser().getId());
					}
					if(militarySubject.getCreatedDate() == null || militarySubject.getCreatedDate().equals("")){
						militarySubject.setCreatedDate(new Date());
					}
					militarySubject.setModifiedBy(UserUtil.getCurrentUser().getId());
					militarySubject.setModifiedDate(new Date());
					militarySubject.setTransferCourseId(transferCourseId);
					titleList.add(militarySubject);
					
				}
			}
			
		}
		/*List<TransferCourseTitle> courseTitleList = transferCourseService.getTransferCourseTitlesByTransferCourseId(transferCourseId);
		if(courseTitleList != null && courseTitleList.size()>0){
			transferCourseService.removeTransferCourseTitles(courseTitleList);
		}*/
		transferCourseService.addMilitarySubject(titleList);
		/**Update the TransferCourse title with effective one
		 * */
		TransferCourse trCourse = transferCourseService.getTransferCourseById(transferCourseId);
		
		if(transferCourseMirrorIdExist.equals("1"))
			courseMgmtService.updateCourseTitleToMirror(transferCourseMirrorId,transferCourseId, transferCourse.getMilitarySubjectList());
		
		return "redirect:/evaluation/quality.html?operation=ieCourse&institutionMirrorId="+institutionMirrorId+"&transferCourseId="+transferCourseId+"&effecTiveTrCourseTitle="+trCourse.getTrCourseTitle();
		
	}
}
