package com.ss.evaluation.controller;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
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
import com.ss.common.util.ObjectXMLConversion;
import com.ss.common.util.UserUtil;
import com.ss.course.service.CourseMgmtService;
import com.ss.course.value.CourseCategoryMapping;
import com.ss.course.value.CourseMapping;
import com.ss.course.value.CourseMappingDetail;
import com.ss.course.value.GCUCourseCategory;
import com.ss.course.value.MilitarySubject;
import com.ss.course.value.TransferCourse;
import com.ss.course.value.TransferCourseMirror;
import com.ss.course.value.TransferCourseTitle;
import com.ss.evaluation.dao.TranscriptMgmtDAO;
import com.ss.evaluation.dao.TransferCourseMgmtDAOImpl;
import com.ss.evaluation.enums.TranscriptStatusEnum;
import com.ss.evaluation.service.EvaluationService;
import com.ss.evaluation.service.TranscriptService;
import com.ss.evaluation.service.TransferCourseService;
import com.ss.evaluation.value.College;
import com.ss.evaluation.value.Country;
import com.ss.evaluation.value.SleCollege;
import com.ss.evaluation.value.StudentTranscriptCourse;
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
import com.ss.institution.value.InstitutionType;
import com.ss.institution.value.TransferCourseInstitutionTranscriptKeyGradeAssoc;
import com.ss.messaging.service.JMSMessageSenderService;
import com.ss.paging.helper.ExtendedPaginatedList;
import com.ss.paging.helper.PaginateListFactory;
import com.ss.user.service.UserService;
import com.ss.user.value.User;

@Controller
@RequestMapping( "/evaluation/ieManager.html" )
public class IeManagerController {
	private static Logger log = LoggerFactory.getLogger(IeManagerController.class);
	
	
	
	@Autowired
	private InstitutionService institutionService;
	
	@Autowired
	private CourseMgmtService courseMgmtService;
	
	@Autowired
	private AccreditingBodyInstituteService accreditingBodyService;
	
	@Autowired 
	private InstitutionTermTypeService institutionTermTypeService;
	
	@Autowired 
	private InstitutionTranscriptKeyService institutionTranscriptKeyService;
	
	@Autowired 
	private ArticulationAgreementService articulationAgreementService;
	
	@Autowired 
	private TransferCourseService transferCourseService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private TranscriptService transcriptService;
	
	@Autowired
	private TranscriptMgmtDAO transcriptMgmtDAO;
	
	private  PaginateListFactory paginateListFactory;
	
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
	
	@RequestMapping(params="operation=managerEvaluationView" )
	public String managerEvaluationView(@RequestParam(value="searchBy", required=false) String searchBy, 
			@RequestParam(value="searchText", required=false) String searchText, Model model){
		List<Institution> institutionList= institutionService.getConflictInstitutionsWithConflictCourses(searchBy, searchText);
		
		countAdd(model);
		model.addAttribute("institutionList",institutionList);
		model.addAttribute("searchBy",searchBy);
		model.addAttribute("searchText", searchText);
		return "managerEvaluationView";
		
	}
	
	//function to add conflict count and approval count in model for display
	private void countAdd(Model model){
		model.addAttribute("conflictCount",institutionService.getConflictCount());
		model.addAttribute("requiredApprovalCount",transferCourseService.getRequiredApprovalCount());
	}
	private String getInstitutionName(String institutionId){
		String institutionName=	institutionService.getInstitutionById(institutionId).getName();
		return institutionName;
	}
	
	@RequestMapping(params="operation=conflictInstitution" )
	public String conflictInstitution(@RequestParam("institutionId") String institutionId,
			Model model){
		
		
		//List<Institution> institutionList;//= institutionService.getConflictInstitutionList(institutionId);
		List<Institution> institutionList=new ArrayList<Institution>();
		List<String> mirrorIdArray=new ArrayList<String>();
		HashMap<String, Institution> institutionsMap=institutionService.getConflictInstitutionListFromMirrors(institutionId);
		if(institutionsMap.size()==2){
			for(String mirrorId:institutionsMap.keySet()){
				mirrorIdArray.add(mirrorId);
				institutionList.add(institutionsMap.get(mirrorId));
			}
		}
		
		Institution institution = institutionService.getInstitutionById(institutionId);
		institution.setEvaluator1(userService.getUserByUserId(institution.getCheckedBy()));
		institution.setEvaluator2(userService.getUserByUserId(institution.getConfirmedBy()));
		countAdd(model);
		model.addAttribute("termTypeList",institutionTermTypeService.getAllTermType());
		model.addAttribute("accreditingBodyList",accreditingBodyService.getAllAccreditingBody());
		model.addAttribute("gcuCourseLevelList", institutionTranscriptKeyService.getAllGcuCourseLevel());
		model.addAttribute("countryList",institutionTermTypeService.getAllCountry());
		model.addAttribute("institutionTypeList",institutionTermTypeService.getAllInstitutionType());
		model.addAttribute("gcuCourseCategoryList", articulationAgreementService.getAllGcuCourseCategory());
		model.addAttribute("institution1",institutionList.get(0));
		model.addAttribute("institution2",institutionList.get(1));
		model.addAttribute("institution", institution);
		model.addAttribute("mirrorId1",mirrorIdArray.get(0));
		model.addAttribute("mirrorId2",mirrorIdArray.get(1));
		return "conflictInstitution";
		
	}
	
	@RequestMapping(params="operation=conflictCourse" )
	public String conflictCourse(@RequestParam("transferCourseId") String transferCourseId,
			Model model){
		
		//TransferCourse transferCourse1=null,transferCourse2=null;
		List<String> mirrorIdArray=new ArrayList<String>();
		List<TransferCourse> transferCourseList=new ArrayList<TransferCourse>();
		//List<TransferCourse> transferCourseList= courseMgmtService.getConflictTransferCourseList(transferCourseId);
		LinkedHashMap<String, TransferCourse> transferCourseMap=courseMgmtService.getConflictTransferCourseList(transferCourseId);
		if(transferCourseMap.size()==2){
			for(String mirrorId:transferCourseMap.keySet()){
				mirrorIdArray.add(mirrorId);
				transferCourseList.add(transferCourseMap.get(mirrorId));
			}
		}
		
		TransferCourse transferCourse = courseMgmtService.getTransferCourseById(transferCourseId);
		if(transferCourse.getCheckedBy()!=null && !"".equals(transferCourse.getCheckedBy()))
			transferCourse.setEvaluator1(userService.getUserByUserId(transferCourse.getCheckedBy()));
		if(transferCourse.getConfirmedBy()!=null && !"".equals(transferCourse.getConfirmedBy()))
			transferCourse.setEvaluator2(userService.getUserByUserId(transferCourse.getConfirmedBy()));
		if(transferCourseList.get(0)!=null && transferCourseList.size()>0){
			for(CourseCategoryMapping ccm : transferCourseList.get(0).getCourseCategoryMappings()){
				ccm.getGcuCourseCategory().setName(articulationAgreementService.getgGcuCourseCategoryById(ccm.getGcuCourseCategory().getId()).getName());
			}
		}
		if(transferCourseList.get(1)!=null && transferCourseList.size()>0){
			for(CourseCategoryMapping ccm : transferCourseList.get(1).getCourseCategoryMappings()){
				ccm.getGcuCourseCategory().setName(articulationAgreementService.getgGcuCourseCategoryById(ccm.getGcuCourseCategory().getId()).getName());
			}
		}
		
		model.addAttribute("transferCourse1",transferCourseList.get(0)!=null?transferCourseList.get(0):null);
		model.addAttribute("transferCourse2",transferCourseList.get(1)!=null?transferCourseList.get(1):null);
		model.addAttribute("mirrorId1",transferCourseList.get(0)!=null ? mirrorIdArray.get(0) : transferCourseList.get(1)!=null ?mirrorIdArray.get(1):mirrorIdArray.get(0));
		model.addAttribute("mirrorId2",transferCourseList.get(1)!=null ? mirrorIdArray.get(1) : transferCourseList.get(0)!=null ?mirrorIdArray.get(0):mirrorIdArray.get(1));
		model.addAttribute("transferCourse", transferCourse);
		model.addAttribute("institutionDetails", institutionService.getInstitutionAddresses(transferCourse.getInstitution().getId()));
		model.addAttribute("gcuCourseCategoryList", articulationAgreementService.getAllGcuCourseCategory());
		
		countAdd(model);
		//return "conflictCourse";
		return "iemCourseConflict";
	}
	
	@RequestMapping(params="operation=resolveAndSubmitCourse")
	public String resolveAndSubmitCourse(TransferCourse transferCourse, @RequestParam("transferCourseId") String transferCourseId,  
			@RequestParam("institutionId") String institutionId, 
			@RequestParam(value="courseMirrorId", required=false) String courseMirrorId,
			Model model){
		//transferCourse.setId(transferCourseId);
		TransferCourseMirror courseMirror = courseMgmtService.getTransferCourseMirrorById(courseMirrorId);
		TransferCourse tc =(TransferCourse) ObjectXMLConversion.decodeXMLToObject(courseMirror.getCourseDetails());
		
		transferCourse.setInstitution(institutionService.getInstitutionById(institutionId));
		//:TODO after course Mapping 
		/*for(CourseMapping cm : transferCourse.getCourseMappings()){
			if (cm.getEffectiveDate() == null){
				cm.setGcuCourse(null);	
			}else{
				cm.setTrCourseId(transferCourseId);
			}
		}*/
		for(CourseCategoryMapping ccm : transferCourse.getCourseCategoryMappings()){
			if(ccm.getGcuCourseCategory() != null && ccm.getGcuCourseCategory().getId() != null){
				ccm.setTrCourseId(transferCourseId);
			}
		}
		List<TransferCourseTitle> transferCourseTitleList = new ArrayList<TransferCourseTitle>();
		for(TransferCourseTitle tct : transferCourse.getTitleList()){
			//set all titles as evaluated as IEM is resolving the course
			//set only those titles which does not have TransferCourseTitle value as null			
			if(tct!=null && tct.getTitle()!=null){
				tct.setTransferCourseId(transferCourseId);
				transferCourseTitleList.add(tct);
			}
		}
		transferCourse.setCourseLevelId(tc.getCourseLevelId());
		if(transferCourse.getInstitution() != null && transferCourse.getInstitution().getInstitutionTermTypes() != null && transferCourse.getInstitution().getInstitutionType().getId().equals("5")){
			transferCourse.setAceExhibitNo(tc.getAceExhibitNo());
		}else{
			transferCourse.setTranscriptCredits(tc.getTranscriptCredits());			
			transferCourse.setClockHours(tc.getClockHours());
		}
		transferCourse.setEffectiveDate(tc.getEffectiveDate());
		transferCourse.setEndDate(tc.getEndDate());
		transferCourse.setTransferStatus(tc.getTransferStatus());
		
		transferCourse.setCourseType(tc.getCourseType());
		transferCourse.setClockHoursChk(tc.isClockHoursChk());
		transferCourse.setCatalogCourseDescription(tc.getCatalogCourseDescription());
		transferCourse.setTrCourseTitle(tc.getTrCourseTitle());
		transferCourse.setTrCourseCode(tc.getTrCourseCode());
		transferCourse.setCreatedBy(tc.getCreatedBy());
		transferCourse.setCreatedDate(tc.getCreatedDate());
		transferCourse.setCheckedBy(tc.getCheckedBy());
		transferCourse.setConfirmedBy(tc.getConfirmedBy());
		transferCourse.setModifiedBy(UserUtil.getCurrentUser().getId());
		transferCourse.setTransferCourseInstitutionTranscriptKeyGradeAssocList(tc.getTransferCourseInstitutionTranscriptKeyGradeAssocList());
		
		InstitutionTermType  institutionTermType = institutionTermTypeService.getEffectiveInstitutionTermTypeByInititutionId(institutionId);
		if(tc.getTranscriptCredits() != null && !tc.getTranscriptCredits().isEmpty()){
			if(institutionTermType != null && institutionTermType.getTermType() != null && institutionTermType.getTermType().getName().equalsIgnoreCase("Semester")){
				double formattedNumber = Double.parseDouble(new DecimalFormat("#.##").format(Double.valueOf(tc.getTranscriptCredits())));
				transferCourse.setSemesterCredits(String.valueOf(formattedNumber));
			}else if(institutionTermType != null && institutionTermType.getTermType() != null && institutionTermType.getTermType().getName().equalsIgnoreCase("Quarter")){
				double formattedNumber = Double.parseDouble(new DecimalFormat("#.##").format(Double.valueOf(tc.getTranscriptCredits())*2/3));
				transferCourse.setSemesterCredits(String.valueOf(formattedNumber));
			}else if(institutionTermType != null && institutionTermType.getTermType() != null && institutionTermType.getTermType().getName().equalsIgnoreCase("4-1-4")){
				double formattedNumber = Double.parseDouble(new DecimalFormat("#.##").format(Double.valueOf(tc.getTranscriptCredits())*4));
				transferCourse.setSemesterCredits(String.valueOf(formattedNumber));
			}else{
				transferCourse.setSemesterCredits("---");
			}
		}else{
			transferCourse.setSemesterCredits("---");
		}
		transferCourse.setTitleList(tc.getTitleList());
		if(tc.getTransferCourseInstitutionTranscriptKeyGradeAssocList() != null && !tc.getTransferCourseInstitutionTranscriptKeyGradeAssocList().isEmpty()){
			transferCourse.setTransferCourseInstitutionTranscriptKeyGradeAssocList(tc.getTransferCourseInstitutionTranscriptKeyGradeAssocList());
		}
		courseMgmtService.addTrCoursesWithChilds(transferCourse, true,false);
		try{
			jmsMessageSender.sendTransferCourseMessage(transferCourse);
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Error get while sending TransferCourseMessage jmsMessageSender."+e+" RequestId:"+uniqueId, e);
		}
		
		
		courseMgmtService.removeTransferCourseMirrors(transferCourseId);
		//return "redirect:ieManager.html?operation=createCourse&institutionId="+institutionId+"&transferCourseId="+transferCourseId;
		return "redirect:ieManager.html?operation=getCoursesForInstitution&status=Conflict";
	}
	
	@RequestMapping(params="operation=resolveAndSubmitInstitution")
	public String resolveAndSubmitInstitution(Institution institution, @RequestParam("institutionId") String institutionId, Model model){
		Institution oldInstitution=institutionService.getInstitutionById(institutionId);
		institution.setEvaluator1(oldInstitution.getEvaluator1());
		institution.setEvaluator2(oldInstitution.getEvaluator2());
		institution.setCreatedDate(oldInstitution.getCreatedDate());
		institution.setCheckedBy(oldInstitution.getCheckedBy());
		institution.setConfirmedBy(oldInstitution.getConfirmedBy());
		institution.setInstitutionID(oldInstitution.getInstitutionID());
		institution.setId(institutionId);
		List<AccreditingBodyInstitute> accreditingBodyInstituteList = new ArrayList<AccreditingBodyInstitute>();
		for(AccreditingBodyInstitute accBodyInstitute : institution.getAccreditingBodyInstitutes() ){
			if(accBodyInstitute.getAccreditingBody()!=null && accBodyInstitute.getAccreditingBody().getId()!=null){
				accBodyInstitute.setInstituteId(institutionId);
				accreditingBodyInstituteList.add(accBodyInstitute);
			}
			
		}
		institution.getAccreditingBodyInstitutes().removeAll(institution.getAccreditingBodyInstitutes());
		institution.setAccreditingBodyInstitutes(accreditingBodyInstituteList);
		
		List<InstitutionTermType> institutionTermTypeList = new ArrayList<InstitutionTermType>();
		for(InstitutionTermType itt : institution.getInstitutionTermTypes()){
			if(itt.getTermType()!=null && itt.getTermType().getId()!=null){
				itt.setInstituteId(institutionId);
				institutionTermTypeList.add(itt);
			}
		}
		institution.getInstitutionTermTypes().removeAll(institution.getInstitutionTermTypes());
		institution.setInstitutionTermTypes(institutionTermTypeList);
		
		List<InstitutionTranscriptKey> institutionTranscriptKeyList = new ArrayList<InstitutionTranscriptKey>();
		for(InstitutionTranscriptKey itk : institution.getInstitutionTranscriptKeys()){
			if(itk!=null && itk.getEffectiveDate()!=null){
				itk.setInstitutionId(institutionId);
				institutionTranscriptKeyList.add(itk);
			}
		}

		institution.getInstitutionTranscriptKeys().removeAll(institution.getInstitutionTranscriptKeys());
		institution.setInstitutionTranscriptKeys(institutionTranscriptKeyList);
		
		List<ArticulationAgreement> articulationAgreementList = new ArrayList<ArticulationAgreement>();
		for(ArticulationAgreement aa : institution.getArticulationAgreements()){
			if(aa!=null && aa.getEffectiveDate()!=null){
				aa.setInstituteId(institutionId);
				articulationAgreementList.add(aa);
			}
		}
		institution.getArticulationAgreements().removeAll(institution.getArticulationAgreements());
		institution.setArticulationAgreements(articulationAgreementList);
		
		institutionService.addInstitutionWithChilds(institution);
		return "redirect:ieManager.html?operation=createInstitution&institutionId="+institutionId;
	}
	
	@RequestMapping(params="operation=submitInstitution" )
	public String submitInstitution(@RequestParam("selectedInstitution") String institutionMirrorId,
			Model model){
		
		InstitutionMirror institutionMirror = institutionService.getInstitutionMirrorById(institutionMirrorId);
		Institution institution =(Institution) ObjectXMLConversion.decodeXMLToObject(institutionMirror.getInstitutionDetails());
		// remove mirrors of the evaluated Institution and set checked by confirmed by null
		institution.setCheckedBy(null);
		institution.setConfirmedBy(null);
		institutionService.removeInstitutionMirrors(institution.getId());
		institutionService.addInstitutionWithChilds(institution);
		return "redirect:/evaluation/ieManager.html?operation=managerEvaluationView";
		
	}
	@RequestMapping(params="operation=submitCourse" )
	public String submitCourse(@RequestParam("selectedCourse") String courseMirrorId,
			Model model){
		
		TransferCourseMirror courseMirror = courseMgmtService.getTransferCourseMirrorById(courseMirrorId);
		TransferCourse transferCourse =(TransferCourse) ObjectXMLConversion.decodeXMLToObject(courseMirror.getCourseDetails());
		// remove mirrors of the evaluated course
		transferCourse.setCheckedBy(null);
		transferCourse.setConfirmedBy(null);
		courseMgmtService.removeTransferCourseMirrors(transferCourse.getId());
		courseMgmtService.addCoursesWithChilds(transferCourse, true);
		
		return "redirect:/evaluation/ieManager.html?operation=managerEvaluationView";
		
	}
	
	@RequestMapping(params="operation=editInstitution" )
	public String editInstitution(@RequestParam("selectedInstitution") String institutionMirrorId,
			Model model){
		
		InstitutionMirror institutionMirror = institutionService.getInstitutionMirrorById(institutionMirrorId);
		Institution institution =(Institution) ObjectXMLConversion.decodeXMLToObject(institutionMirror.getInstitutionDetails());
		institutionService.addInstitutionWithChilds(institution);
		model.addAttribute("institution",institution);
		model.addAttribute("institutionTypeList",institutionTermTypeService.getAllInstitutionType());
		model.addAttribute("countryList",institutionTermTypeService.getAllCountry());
		model.addAttribute("role","MANAGER");
		return "ieInstitution";
		
	}
	@RequestMapping(params="operation=ieSaveInstitution")
	public String ieSaveInstitution(Institution institution,InstitutionAddress institutionAddress,
			HttpServletRequest request, Model model){
		
		//TODO:Revist all the if loops in here...we should be able to do it better
		String actionSubmit=request.getParameter("saveInstitution");
		institution.setInstitutionAddress(institutionAddress);
		User user=  UserUtil.getCurrentUser();
		boolean newInstituiton=false;
		boolean isInstEvaluated = false;
		if(user.getCurrentRole().equalsIgnoreCase("IEM")){
			institution.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
			isInstEvaluated = true;
			institution.setCheckedBy(user.getId());
		}else{
			institution.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
			if(institution.getCheckedBy() == null){
				institution.setCheckedBy(user.getId());
			}
			else if(!institution.getCheckedBy().equals(user.getId()) && institution.getConfirmedBy() == null){
				institution.setConfirmedBy(user.getId());
			}
		}
		if( institution.getId()==null||institution.getId().isEmpty() ) {
			newInstituiton=true;
			institution.setInstitutionID(institutionService.getProcessedInstitutionCode(institution));
		}
		
		//institutionService.addInstitution(institution);
		Institution institutionExit = institutionService.getInstitutionByTitle(institution.getName());
		if(institutionExit == null){
			institutionService.saveInstitution(institution);
		}else{
			institutionService.updateInstitution(institution);
		}
		if(isInstEvaluated) {			
			try{
				jmsMessageSender.sendCreateOrUpdateInstitutionEvent(institution);
			}catch (Exception e) {
				String uniqueId = RequestContext.getRequestIdFromContext();
				log.error("Error get while sending InstitutionEvent jmsMessageSender."+e+" RequestId:"+uniqueId, e);
			}
		}
		if(newInstituiton){
			institutionAddress.setInstitutionId(institution.getId());
			institutionService.addInstitutionAddress(institutionAddress);
		}
		institution =institutionService.getInstitutionById(institution.getId());
		if(institution.getParentInstitutionId()!=null && !"".equals(institution.getParentInstitutionId())){
			Institution parentInstitution =institutionService.getInstitutionById(institution.getParentInstitutionId());
			institution.setParentInstitutionName(parentInstitution.getName());
		}
		model.addAttribute("institution",institution);
		model.addAttribute("institutionTypeList",institutionTermTypeService.getAllInstitutionType());
		model.addAttribute("countryList",institutionTermTypeService.getAllCountry());
		model.addAttribute("role","MANAGER");
		
		
		model.addAttribute("institutionId",institution.getId());
		model.addAttribute("institutionName",institution.getName());
		countAdd(model);
		if(actionSubmit!=null && actionSubmit.equalsIgnoreCase("Save & Next")){

			return "redirect:/evaluation/ieManager.html?operation=manageAccreditingBody";
		}else{
			model.addAttribute("tabIndex","1");
			return "ieInstitution";
		}
		
	}
	@RequestMapping(params="operation=ieInstitution" )
	public String ieInstitution(@RequestParam("institutionId") String institutionId,
			 Model model ){	
		Institution institution =	institutionService.getInstitutionById(institutionId);
		model.addAttribute("institution",institution);
		model.addAttribute("institutionTypeList",institutionTermTypeService.getAllInstitutionType());
		model.addAttribute("countryList",institutionTermTypeService.getAllCountry());
		model.addAttribute("role","MANAGER");
		countAdd(model);
		return "ieInstitution";
	}
	
	@RequestMapping(params= "operation=createInstitution")
	public String createInstitution(@RequestParam(value="institutionId", required=false) String institutionId, Model model){
		Institution institution = null;
		if(institutionId!=null && !institutionId.isEmpty()){
			institution = institutionService.getInstitutionById(institutionId);
		
			if(institution.getParentInstitutionId()!=null && !"".equals(institution.getParentInstitutionId())){
				Institution parentInstitution =institutionService.getInstitutionById(institution.getParentInstitutionId());
				institution.setParentInstitutionName(parentInstitution.getName());
			}
		}
		model.addAttribute("institution",institution);
		model.addAttribute("institutionTypeList", institutionTermTypeService.getAllInstitutionType());
		model.addAttribute("countryList",institutionTermTypeService.getAllCountry());
		model.addAttribute("role","MANAGER");
		model.addAttribute("tabIndex","1");
		model.addAttribute("institutionId",institutionId);
		if(institution != null){
			model.addAttribute("institutionName",institution.getName());
		}
		
		
		countAdd(model);
		return "ieInstitution";
	}
	
	/*@RequestMapping(params="operation=editCourse" )
	public String editCourse(@RequestParam("selectedCourse") String courseMirrorId,
			Model model){
		
		TransferCourseMirror courseMirror = courseMgmtService.getTransferCourseMirrorById(courseMirrorId);
		TransferCourse transferCourse =(TransferCourse) ObjectXMLConversion.decodeXMLToObject(courseMirror.getCourseDetails());
		// remove mirrors of the evaluated course
		transferCourse.setCheckedBy(null);
		transferCourse.setConfirmedBy(null);
		courseMgmtService.removeTransferCourseMirrors(transferCourse.getId());
		
		courseMgmtService.addCoursesWithChilds(transferCourse, true);
		
		List<InstitutionTermType> instTermTypeList = institutionTermTypeService.getAllInstitutionTermType(transferCourse.getInstitution().getId());
		InstitutionTermType institutionTermType = null;
		if(instTermTypeList != null && instTermTypeList.size() > 0){
			institutionTermType = instTermTypeList.get(0);
		}
		
		model.addAttribute("transferCourse" ,transferCourse);
		model.addAttribute("gcuCourseLevelList",institutionTranscriptKeyService.getAllGcuCourseLevel());
		model.addAttribute("institution",institutionService.getInstitutionById(transferCourse.getInstitution().getId()));
		model.addAttribute("institutionTermType",institutionTermType);
		model.addAttribute("role","MANAGER");
		return "ieCourse";
		
	}*/
	/*@RequestMapping(params="operation=ieSaveCourse")
	public String saveCourse(@RequestParam("institutionId") String institutionId,TransferCourse transferCourse,
			 Model model ){
		
		User user=  UserUtil.getCurrentUser();
		TransferCourseTitle tct = new TransferCourseTitle();
		//creatingCourse variable will be false if already created course is getting edited
		boolean creatingCourse;
		if(transferCourse.getId()==null){
			creatingCourse = true;
		}
		else creatingCourse = false;
		
		Institution institution=institutionService.getInstitutionById(institutionId);
		transferCourse.setInstitution(institution);
		
		
	//	if(transferCourse.getId()!=null && !transferCourse.getId().isEmpty()){
			transferCourse.setModifiedBy(user.getId());
			transferCourse.setEvaluationStatus("EVALUATED");
			transferCourse.setCheckedBy(null);
			transferCourse.setConfirmedBy(null);
			transferCourseService.addTransferCourse(transferCourse);
			courseMgmtService.removeTransferCourseMirrors(transferCourse.getId());
			
			jmsMessageSender.sendTransferCourseMessage(transferCourse);
			
			// all the titles should be evaluated when the course is evaluated
			for(TransferCourseTitle title : transferCourse.getTitleList()){
				title.setEvaluationStatus("EVALUATED");
				transferCourseService.addTransferCourseTitle(title);
			}
						
			if(transferCourse.getTitleList() == null && transferCourse.getTitleList().isEmpty() ){
				tct.setTransferCourseId(transferCourse.getId());
				tct.setEvaluationStatus("EVALUATED");
				tct.setTitle(transferCourse.getTrCourseTitle());
				tct.setEffectiveDate(transferCourse.getEffectiveDate());
				tct.setEndDate(transferCourse.getEndDate());
				transferCourseService.addTransferCourseTitle(tct);
			}
			
			courseMgmtService.createCourse(transferCourse);
			
			
		List<InstitutionTermType> instTermTypeList = institutionTermTypeService.getAllInstitutionTermType(institutionId);
		InstitutionTermType institutionTermType = null;
		if(instTermTypeList != null && instTermTypeList.size() > 0){
			institutionTermType = instTermTypeList.get(0);
		}	
		
		model.addAttribute("transferCourse" ,transferCourse);
		model.addAttribute("gcuCourseLevelList",institutionTranscriptKeyService.getAllGcuCourseLevel());
		model.addAttribute("institution",institution);
		model.addAttribute("institutionTermType",institutionTermType);
		model.addAttribute("role","MANAGER");
		model.addAttribute("institutionId",institutionId);
		model.addAttribute("transferCourseId",transferCourse.getId());
		model.addAttribute("tabIndex","7");
		
		//return "ieCourse";
		countAdd(model);
		
		return "ieInstitution";
	}*/
	@RequestMapping(params="operation=ieCourse" )
	public String ieCourse(@RequestParam("transferCourseId") String transferCourseId,@RequestParam(value="institutionId", required=false) String institutionId,
			 Model model ){	
		TransferCourse transferCourse =	courseMgmtService.getTransferCourseWithChilds(transferCourseId);
		
		List<InstitutionTermType> instTermTypeList = institutionTermTypeService.getAllInstitutionTermType(transferCourse.getInstitution().getId());
		InstitutionTermType institutionTermType = null;
		if(instTermTypeList != null && instTermTypeList.size() > 0){
			institutionTermType = instTermTypeList.get(0);
		}
		List<InstitutionTranscriptKeyGrade>  institutionTranscriptKeyGradeList = institutionTranscriptKeyService.getInstitutionTranscriptKeyGradeListByInstitutionId(institutionId);
		List<TransferCourseInstitutionTranscriptKeyGradeAssoc>  transferCourseInstitutionTranscriptKeyGradeAssocList = institutionTranscriptKeyService.getTransferCourseInstitutionTranscriptKeyGradeList(transferCourseId,institutionId);
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
		if(transferCourse.getModifiedBy()!=null  && !transferCourse.getModifiedBy().equals("(NULL)") && !transferCourse.getModifiedBy().isEmpty()){
			transferCourse.setEvaluator1(userService.getUserByUserId(transferCourse.getModifiedBy()));
		}
		model.addAttribute("transferCourse" ,transferCourse);
		if(transferCourse != null && transferCourse.getId() !=null)
			model.addAttribute("currentUserHaveEntryInMainDb", "1");
		else
			model.addAttribute("currentUserHaveEntryInMainDb", "0");
		
		model.addAttribute("gcuCourseLevelList",institutionTranscriptKeyService.getAllGcuCourseLevel());
		//model.addAttribute("institution",institutionService.getInstitutionById(transferCourse.getInstitution().getId()));
		model.addAttribute("institutionTermType",institutionTermType);
		model.addAttribute("role","MANAGER");
		model.addAttribute( "transferCourseId",transferCourseId);
		model.addAttribute("institutionTranscriptKeyGradeList", institutionTranscriptKeyGradeList);
		model.addAttribute("tabIndex","1");
		
		return "ieEvaluateCourseForm";
		
	}
	
	@RequestMapping(params="operation=manageAccreditingBody" )
	public String manageAccreditingBody(@RequestParam("institutionId") String institutionId, Model model ){	
		
		List<AccreditingBodyInstitute> accreditingBodyList = accreditingBodyService.getAllAccreditingBodyInstitute(institutionId);
		Institution institution = institutionService.getInstitutionById(institutionId);
		model.addAttribute( "accreditingBodyInstituteList",accreditingBodyList);
		model.addAttribute("accreditingBodyList",accreditingBodyService.getAllAccreditingBody());
		model.addAttribute("institutionId",institutionId);
		model.addAttribute("role","MANAGER");
		
		
		model.addAttribute("institutionName",institution.getName());
		model.addAttribute("institution",institution);
		countAdd(model);
		
		
		//return "ieManageAccreditingBody";
		model.addAttribute("tabIndex","2");
		return "ieInstitution";
		
		
	}
	

	@RequestMapping(params="operation=addAccreditingBody" )
	public String addAccreditingBody(@RequestParam("institutionId") String institutionId,
			@RequestParam(value="accreditingBodyInstId", required=false) String accreditingBodyInstId,
			Model model ){		
		
		if(accreditingBodyInstId !=  null){
			AccreditingBodyInstitute accreditingBodyInstitute= accreditingBodyService.getAccreditingBodyInstitute(accreditingBodyInstId);
			model.addAttribute("accreditingBodyInstitute",accreditingBodyInstitute);
		}
		
		List<AccreditingBodyInstitute> accreditingBodyList = accreditingBodyService.getAllAccreditingBodyInstitute(institutionId);
		if(accreditingBodyList!=null && accreditingBodyList.size()>0){
			model.addAttribute("currentlyActiveAccreditingBody",false);
		}else{
			model.addAttribute("currentlyActiveAccreditingBody",true);
		}
		model.addAttribute("institutionId",institutionId);
		model.addAttribute("accreditingBodyList",accreditingBodyService.getAllAccreditingBody());
		model.addAttribute("role","MANAGER");
		return "ieAddAccreditingBody";
	}
	
	@RequestMapping(params="operation=saveAccreditingBody" )
	public String saveAccreditingBody(Institution institution,HttpServletRequest request, Model model ){	
		
	//	ab.getAccreditingBody().setId(accreditingBodyId);
		String actionSubmit=request.getParameter("saveAccreditingBody");
		List<AccreditingBodyInstitute> accreditingBodyInstitutes= institution.getAccreditingBodyInstitutes();
		accreditingBodyService.addAccreditingBodyInstituteList(accreditingBodyInstitutes, institution.getId());
		
		if(actionSubmit!=null && actionSubmit.equalsIgnoreCase("Save & Next")){
			return "redirect:/evaluation/ieManager.html?operation=manageInstitutionTermType&institutionId="+institution.getId();
		}else{
			return "redirect:ieManager.html?operation=manageAccreditingBody&institutionId="+institution.getId();
			
		}
		
		
	}
	
	
	@RequestMapping(params="operation=manageInstitutionTermType")
	public String manageInstitutionTermType(@RequestParam("institutionId") String institutionId, Model model ){	
		List<InstitutionTermType> institutionTermTypeList = institutionTermTypeService.getAllInstitutionTermType(institutionId);
		Institution institution = institutionService.getInstitutionById(institutionId);
		model.addAttribute( "institutionTermTypeList",institutionTermTypeList);
		model.addAttribute("termTypeList",institutionTermTypeService.getAllTermType());
		model.addAttribute("institutionId",institutionId);
		model.addAttribute("institution",institution);
		model.addAttribute("role","MANAGER");
		model.addAttribute("tabIndex","3");
		model.addAttribute("institutionName",institutionService.getInstitutionById(institutionId).getName());
		//countAdd(model);
		model.addAttribute("tabIndex","3");
		return "ieInstitution";
			
		
		//return "ieManageInstitutionTermType";
	}
	

	@RequestMapping(params="operation=addInstitutionTermType" )
	public String addInstitutionTermType(@RequestParam("institutionId") String institutionId,
			@RequestParam(value="institutionTermTypeId", required=false) String institutionTermTypeId,
			Model model ){		
		
		if(institutionTermTypeId !=  null){
			InstitutionTermType InstitutionTermType= institutionTermTypeService.getInstitutionTermType(institutionTermTypeId);
			model.addAttribute("institutionTermType",InstitutionTermType);
		}
		
		List<InstitutionTermType> institutionTermTypeList = institutionTermTypeService.getAllInstitutionTermType(institutionId);
		if(institutionTermTypeList!=null && institutionTermTypeList.size()>0){
			model.addAttribute("currentlyActiveTermType",false);
		}else{
			model.addAttribute("currentlyActiveTermType",true);
		}
		model.addAttribute("institutionId",institutionId);
		model.addAttribute("termTypeList",institutionTermTypeService.getAllTermType());
		model.addAttribute("role","MANAGER");
		return "ieAddInstitutionTermType";
	}
	
	@RequestMapping(params="operation=saveInstitutionTermType" )
	public String saveInstitutionTermType(	Institution institution,HttpServletRequest request, Model model ){	
		
		String actionSubmit=request.getParameter("saveInstitution");
		List<InstitutionTermType> institutionTermTypes= institution.getInstitutionTermTypes();
		
		institutionTermTypeService.addInstitutionTermTypeList(institutionTermTypes, institution.getId());
		
		
		if(actionSubmit!=null && actionSubmit.equalsIgnoreCase("Save & Next")){
			return "redirect:/evaluation/ieManager.html?operation=manageInstitutionTranscriptKey&institutionId="+institution.getId();
		}else{
			return "redirect:ieManager.html?operation=manageInstitutionTermType&institutionId="+institution.getId();
			
		}
	}
	
	
	@RequestMapping(params="operation=manageInstitutionTranscriptKey" )
	public String manageInstitutionTranscriptKey(@RequestParam("institutionId") String institutionId, Model model ){	
		List<InstitutionTranscriptKey> institutionTranscriptKeyList = institutionTranscriptKeyService.getAllInstitutionTranscriptKey(institutionId);
		Institution institution = institutionService.getInstitutionById(institutionId);
		InstitutionTranscriptKey institutionTranscriptKey= new InstitutionTranscriptKey();
		if(institutionTranscriptKeyList!=null && institutionTranscriptKeyList.size()>0){
		 institutionTranscriptKey=institutionTranscriptKeyList.get(0);
		}
		model.addAttribute( "institutionTranscriptKey",institutionTranscriptKey);
		model.addAttribute("institutionId",institutionId);
		model.addAttribute("role","MANAGER");
		//model.addAttribute("tabIndex","4");
		model.addAttribute("institutionName",institution.getName());
		model.addAttribute("institution",institution);
		model.addAttribute("gcuCourseLevelList",institutionTranscriptKeyService.getAllGcuCourseLevel());
	//	model.addAttribute("institutionTranscriptKeyGradeAlphaList",institutionTranscriptKeyService.getInstitutionTranscriptKeyGradeList(institutionTranscriptKey.getId(), false));
		//model.addAttribute("institutionTranscriptKeyGradeNumberList",institutionTranscriptKeyService.getInstitutionTranscriptKeyGradeList(institutionTranscriptKey.getId(), true));
		countAdd(model);
		model.addAttribute("tabIndex","4");
		return "ieInstitution";
			
		
		
		//return "ieManageInstitutionTranscriptKey";
		
	}
	

	@RequestMapping(params="operation=addInstitutionTranscriptKey" )
	public String addInstitutionTranscriptKey(@RequestParam("institutionId") String institutionId,
			@RequestParam(value="institutionTranscriptKeyId", required=false) String institutionTranscriptKeyId,
			Model model ){		
		InstitutionTranscriptKey institutionTranscriptKey= new InstitutionTranscriptKey();
		
		List<InstitutionTranscriptKeyDetails> institutionTranscriptKeyDetailsList = new ArrayList<InstitutionTranscriptKeyDetails>();
		institutionTranscriptKey.setInstitutionTranscriptKeyDetailsList(institutionTranscriptKeyDetailsList);
		if(institutionTranscriptKeyId !=  null){
			 institutionTranscriptKey= institutionTranscriptKeyService.getInstitutionTranscriptKey(institutionTranscriptKeyId);
		}
		List<InstitutionTranscriptKey> institutionTranscriptKeyList = institutionTranscriptKeyService.getAllInstitutionTranscriptKey(institutionId);
		if(institutionTranscriptKeyList!=null && institutionTranscriptKeyList.size()>0){
			model.addAttribute("currentlyActiveTranscriptKey",false);
		}else{
			model.addAttribute("currentlyActiveTranscriptKey",true);
		}
		model.addAttribute("institutionTranscriptKey", institutionTranscriptKey);
		model.addAttribute("institutionId",institutionId);
		model.addAttribute("gcuCourseLevelList",institutionTranscriptKeyService.getAllGcuCourseLevel());
		model.addAttribute("role","MANAGER");
		return "ieAddInstitutionTranscriptKey";
	}
	
	@RequestMapping(params="operation=saveInstitutionTranscriptKey" )
	public String saveInstitutionTranscriptKey(@ModelAttribute("institutionTranscriptKey")InstitutionTranscriptKey institutionTranscriptKey,
			HttpServletRequest request,Model model ){
		String actionSubmit=request.getParameter("saveInstitution");
		institutionTranscriptKeyService.addInstitutionTranscriptKey(institutionTranscriptKey);
		
		if(actionSubmit!=null && actionSubmit.equalsIgnoreCase("Save & Next")){
			return "redirect:/evaluation/ieManager.html?operation=summaryInstitution&institutionId="+institutionTranscriptKey.getInstitutionId();
		}else{
			return "redirect:ieManager.html?operation=manageInstitutionTranscriptKey&institutionId="+institutionTranscriptKey.getInstitutionId();
			
		}
		
	}
	
	@RequestMapping(params="operation=manageArticulationAgreement" )
	public String manageArticulationAgreement(@RequestParam("institutionId") String institutionId, Model model ){	
		List<ArticulationAgreement> articulationAgreementList = articulationAgreementService.getAllArticulationAgreement(institutionId);		
		Institution institution = institutionService.getInstitutionById(institutionId);		
		model.addAttribute( "articulationAgreementList",articulationAgreementList);
		model.addAttribute("institutionId",institutionId);
		model.addAttribute("role","MANAGER");
		model.addAttribute("tabIndex","5");
		model.addAttribute("institutionName",institution.getName());
		model.addAttribute("institution",institution);
		
		
		countAdd(model);
		return "ieInstitution";
		//return "ieManageArticulationAgreement";
	}
	

	@RequestMapping(params="operation=addArticulationAgreement" )
	public String addArticulationAgreement(@RequestParam("institutionId") String institutionId,
			@RequestParam(value="articulationAgreementId", required=false) String articulationAgreementId,
			Model model ){		
		ArticulationAgreement articulationAgreement= new ArticulationAgreement();
		
		List<ArticulationAgreementDetails> articulationAgreementDetailsList = new ArrayList<ArticulationAgreementDetails>();
		articulationAgreement.setArticulationAgreementDetailsList(articulationAgreementDetailsList);
		if(articulationAgreementId !=  null){
			 articulationAgreement= articulationAgreementService.getArticulationAgreement(articulationAgreementId);
		}
		List<ArticulationAgreement> articulationAgreementList = articulationAgreementService.getAllArticulationAgreement(institutionId);
		if(articulationAgreementList!=null && articulationAgreementList.size()>0){
			model.addAttribute("currentlyActiveArticulationAgreement",false);
		}else{
			model.addAttribute("currentlyActiveArticulationAgreement",true);
		}
		model.addAttribute("articulationAgreement", articulationAgreement);
		model.addAttribute("institutionId",institutionId);
		model.addAttribute("gcuCourseCategoryList",articulationAgreementService.getAllGcuCourseCategory());
		model.addAttribute("role","MANAGER");
		return "ieAddArticulationAgreement";
	}
	
	@RequestMapping(params="operation=saveArticulationAgreement" )
	public String saveArticulationAgreement(@ModelAttribute("articulationAgreement") ArticulationAgreement articulationAgreement, Model model ){
		articulationAgreementService.addArticulationAgreement(articulationAgreement);
		return "redirect:ieManager.html?operation=manageArticulationAgreement&institutionId="+articulationAgreement.getInstituteId();
		
	}

	@RequestMapping(params="operation=manageCourseRelationship" )
	public String manageCourseRelationship(@RequestParam("transferCourseId") String transferCourseId,
			@RequestParam(value="institutionId", required =false) String institutionId,Model model ){	
		
		TransferCourse transferCourse=courseMgmtService.getTransferCourseWithChilds(transferCourseId);
		Institution institution= institutionService.getInstitutionById(transferCourse.getInstitution().getId());
		List<CourseCategoryMapping> courseCategoryMappingList = transferCourse.getCourseCategoryMappings();
		List<CourseMapping> courseMappingList = transferCourse.getCourseMappings();
		
		
		List<GCUCourseCategory> gcuCourseCategoryList = articulationAgreementService.getAllGcuCourseCategory();
		model.addAttribute("gcuCourseCategoryList", gcuCourseCategoryList);
		
		model.addAttribute( "courseMappingList",courseMappingList);
		model.addAttribute( "courseCategoryMappingList",courseCategoryMappingList);
		model.addAttribute( "transferCourseId",transferCourseId);
		model.addAttribute("role","MANAGER");
		model.addAttribute("institution",institution);
		model.addAttribute("institutionId",institution.getId());
		model.addAttribute("tabIndex","8");
		model.addAttribute("institutionName",institution.getName());
		model.addAttribute( "transferCourseName",transferCourse.getTrCourseTitle());
		model.addAttribute( "transferCourse",transferCourse);
		
		countAdd(model);
		return "ieInstitution";
		//return "ieManageCourseRelationship";
	}
	

	@RequestMapping(params="operation=addCourseRelationship" )
	public String addCourseRetationship(@RequestParam("transferCourseId") String transferCourseId,
			@RequestParam(value="courseMappingId", required=false) String courseMappingId,
			@RequestParam(value="institutionId", required =false) String institutionId,
			Model model ){		
		
		if(courseMappingId !=  null){
			CourseMapping courseMapping= courseMgmtService.getCourseMapping(courseMappingId);
			model.addAttribute("courseMapping",courseMapping);
			model.addAttribute("courseMappingId",courseMappingId);
			
			
		}
		List<CourseMapping> courseMappingList = courseMgmtService.getCourseMappingByTransferCourseId(transferCourseId);
		if(courseMappingList!=null && courseMappingList.size()>0){
			model.addAttribute( "currentlyActive",false);
		}else{
			model.addAttribute( "currentlyActive",true);
		}
		model.addAttribute("institutionId",institutionId);
		model.addAttribute("transferCourseId",transferCourseId);
		model.addAttribute("role","MANAGER");
		return "ieAddCourseRelationship";
	}
	
	@RequestMapping(params="operation=saveCourseRelationship" )
	public String handleCourseRetationship(CourseMapping courseMapping,
			@RequestParam(value="institutionId", required =false) String institutionId,
			@RequestParam(value="currentlyActive", required =false) boolean currentlyActive,Model model ){		
		/*if(currentlyActive){
			courseMapping.setEffective(true);
		}
		
		if(courseMapping.isEffective()){
			courseMgmtService.effectiveCourseRelationship(courseMapping.getTrCourseId(), courseMapping.getId());
			
		}*/
		courseMgmtService.addCourseRelationShip(courseMapping);
		return "redirect:ieManager.html?operation=manageCourseRelationship&institutionId="+institutionId+"&transferCourseId="+courseMapping.getTrCourseId();
		
	}
	
	@RequestMapping(params="operation=manageCourseCtgRelationship" )
	public String manageCourseCtgRelationship(@RequestParam("transferCourseId") String transferCourseId,
			@RequestParam(value="institutionId", required =false) String institutionId,Model model ){	
		List<CourseCategoryMapping> courseCategoryMappingList = courseMgmtService.getCourseCategoryMappingByTransferCourseId(transferCourseId);
		TransferCourse transferCourse=courseMgmtService.getTransferCourseWithChilds(transferCourseId);
		Institution institution= transferCourse.getInstitution();
		model.addAttribute( "transferCourseId",transferCourseId);
		model.addAttribute( "courseCategoryMappingList",courseCategoryMappingList);
		model.addAttribute("role","MANAGER");
		model.addAttribute("institutionId",institution.getId());
		model.addAttribute("institutionName",institution.getName());
		model.addAttribute( "transferCourseName",transferCourse.getTrCourseTitle());
		model.addAttribute( "transferCourse",transferCourse);
		model.addAttribute("tabIndex","9");
		
		countAdd(model);
		return "ieInstitution";
		//return "ieManageCourseCtgRelationship";
	}
	
	@RequestMapping(params="operation=addCourseCtgRelationship" )
	public String addCourseCtgRelationship(@RequestParam("transferCourseId") String transferCourseId,
			@RequestParam(value="courseCategoryMappingId", required=false) String courseCategoryMappingId,
			@RequestParam(value="institutionId", required =false) String institutionId,
			Model model ){	
		
		if(courseCategoryMappingId !=  null){
			CourseCategoryMapping courseCategoryMapping= courseMgmtService.getCourseCategoryMapping(courseCategoryMappingId);
			model.addAttribute("courseCategoryMapping",courseCategoryMapping);
			model.addAttribute("courseCategoryMappingId",courseCategoryMappingId);
			
		}
		List<CourseCategoryMapping> courseCategoryMappingList = courseMgmtService.getCourseCategoryMappingByTransferCourseId(transferCourseId);
		if(courseCategoryMappingList!=null && courseCategoryMappingList.size()>0){
			model.addAttribute( "currentlyActiveCategory",false);
		}else{
			model.addAttribute( "currentlyActiveCategory",true);
		}
		model.addAttribute("institutionId",institutionId);
		model.addAttribute( "transferCourseId",transferCourseId);
		model.addAttribute("gcuCourseCategoryList",articulationAgreementService.getAllGcuCourseCategory());
		model.addAttribute("role","MANAGER");
		return "ieAddCourseCtgRelationship";
	}
	
	@RequestMapping(params="operation=saveCourseCtgRelationship" )
	public String handleCourseCtgRetationship(CourseCategoryMapping courseCategoryMapping,
			@RequestParam(value="institutionId", required =false) String institutionId,@RequestParam(value="currentlyActiveCategory", required =false) boolean currentlyActiveCategory,Model model ){
		
		if(currentlyActiveCategory){
			courseCategoryMapping.setEffective(currentlyActiveCategory);
		}
		if(courseCategoryMapping.isEffective()){
			courseMgmtService.effectiveCourseCtgRelationship(courseCategoryMapping.getTrCourseId(), courseCategoryMapping.getId());
			
		}
		courseMgmtService.addCourseCategoryRelationShip(courseCategoryMapping);
		return "redirect:ieManager.html?operation=manageCourseCtgRelationship&institutionId="+institutionId+"&transferCourseId="+courseCategoryMapping.getTrCourseId();
	}
	
	@RequestMapping( params="operation=getInstitutionList")
	public String viewInstitutions( @RequestParam(value="status", required=false) String status,
			@RequestParam(value="searchBy", required=false) String searchBy, 
			@RequestParam(value="searchText", required=false) String searchText, Model model ){	
		
		
		if(status==null || status.isEmpty() ||status.equals("undefined"))
			status="ALL";
		List<Institution> institutionList = institutionService.getInstitutionsList(searchBy, searchText, status, null);
		List<Institution> institutionListForReassignment = institutionService.getInstitutionsForReassignment();
	if(institutionList!=null && institutionList.size()>0){	
		for(Institution institution:institutionList){
			if(institutionListForReassignment!=null && institutionListForReassignment.size()>0){
				for(Institution institutionReAssignment:institutionListForReassignment){
					
					if(institution.getId().equals(institutionReAssignment.getId())){
						institution.setReassignable(true);
					}
				}
		    }
			if(institution.getCheckedBy()!=null  && !institution.getCheckedBy().isEmpty()){
				institution.setEvaluator1(userService.getUserByUserId(institution.getCheckedBy()));
			}
			if(institution.getConfirmedBy()!=null && !institution.getConfirmedBy().isEmpty()){
				institution.setEvaluator2(userService.getUserByUserId(institution.getConfirmedBy()));
			}
		}
	}
	if (institutionList!=null && institutionList.size()>0){
		Collections.sort(institutionList);
	}

		model.addAttribute("institutionList", institutionList);
		
		if(searchBy == null || "".equals(searchBy)){
			searchBy = "2";
		}
		if(searchText == null){
			searchText = "";
		}
		model.addAttribute("status", status);	
		model.addAttribute("searchBy",searchBy);
		model.addAttribute("searchText", searchText);
		model.addAttribute("role","MANAGER");
		List<Institution> institutionConflictCount = institutionService.getAllConflictInstitutions();
		model.addAttribute("conflictCount",institutionConflictCount!=null?institutionConflictCount.size():0);
		model.addAttribute("reassignableCount",institutionListForReassignment!=null?institutionListForReassignment.size():0);
		model.addAttribute("requiredApprovalCount",transferCourseService.getRequiredApprovalCount());
		
		return "institutionList";
	}
	
	@RequestMapping(params="operation=getCoursesForInstitution")
	public String viewCourses(@RequestParam(value="institutionId", required=false) String institutionId,
			@RequestParam(value="status", required=false) String status,HttpServletRequest request,
			@RequestParam(value="searchBy", required=false) String searchBy, 
			@RequestParam(value="searchText", required=false) String searchText,Model model){
		
		
		List<TransferCourse> tcForReassignment=courseMgmtService.getCoursesForReAssignment();
		if(status==null || status.isEmpty())
			status="ALL";
		paginateListFactory= new PaginateListFactory();
		 ExtendedPaginatedList paginatedList = paginateListFactory.getPaginatedListFromRequest(request);
		  transferCourseService.getAllRecordsPage(TransferCourse.class, paginatedList, institutionId, status, searchBy, searchText);
		  for(TransferCourse tc: (List<TransferCourse>)paginatedList.getList()){
				if(tcForReassignment!=null && tcForReassignment.size()>0){
					for(TransferCourse institutionReAssignment:tcForReassignment){
						if(tc.getId().equals(institutionReAssignment.getId())){
							tc.setReassignable(true);
						}
					}
			    }
				if(tc.getCheckedBy()!=null  && !tc.getCheckedBy().equals("(NULL)") && !tc.getCheckedBy().isEmpty()){
					tc.setEvaluator1(userService.getUserByUserId(tc.getCheckedBy()));
				}
				if(tc.getConfirmedBy()!=null && !tc.getConfirmedBy().equals("(NULL)")&& !tc.getConfirmedBy().isEmpty()){
					tc.setEvaluator2(userService.getUserByUserId(tc.getConfirmedBy()));
				}
				
		  }
		  
		  model.addAttribute("courseList", paginatedList);
		  if(searchBy == null || "".equals(searchBy)){
				searchBy = "2";
		  }
		  if(searchText == null){
				searchText = "";
		  }
		  if(institutionId!=null && !institutionId.isEmpty()){
			  model.addAttribute("institutionId",institutionId);
			  Institution institution=institutionService.getInstitutionById(institutionId);
			  model.addAttribute("institution", institution);
			  model.addAttribute("institutionName",institution.getName());
		  }
		model.addAttribute("status", status);
		model.addAttribute("searchBy",searchBy);
		model.addAttribute("searchText", searchText);
		model.addAttribute("tabIndex","6");
		
	
		model.addAttribute("role","MANAGER");
		model.addAttribute("userActualRole",UserUtil.getCurrentRole().getDescription());
		model.addAttribute("conflictCount",courseMgmtService.getConflictCourses().size());
		model.addAttribute("approvalCount",transferCourseService.getRequiredApprovalCount());
		if(tcForReassignment!=null && tcForReassignment.size()>0){
			model.addAttribute("reassignableCount",tcForReassignment.size());
		}
		
		return "ieInstitution";
		//return "courseList";
	}
	
	//without any mirror course
	@RequestMapping(params="operation=createCourse" )
	public String createCourse(@RequestParam(value="institutionId", required=false) String institutionId,
			@RequestParam(value="transferCourseId", required=false) String transferCourseId,@RequestParam(value="directLink", required=false) String directLink, 
			Model model ){	
		TransferCourse transferCourse=new TransferCourse();
		if((institutionId != null && !institutionId.isEmpty()) ||(transferCourseId !=  null && !transferCourseId.isEmpty())){
			if(transferCourseId !=  null && !transferCourseId.isEmpty()){
				 transferCourse= courseMgmtService.getTransferCourseWithChilds(transferCourseId);
				TransferCourseTitle transferCourseTitle = courseMgmtService.getEffectiveCourseTitleForCourseId(transferCourseId);
				transferCourse.setTrCourseTitle(transferCourseTitle!=null && transferCourseTitle.getTitle()!=null && !transferCourseTitle.getTitle().equals("")?transferCourseTitle.getTitle():transferCourse.getTrCourseTitle());
				 institutionId=transferCourse.getInstitution().getId();
				 
				if(institutionId!=null){
					model.addAttribute("institutionId",institutionId);
				}
			//	model.addAttribute("institutionName",transferCourse.getInstitution().getName());
				
			}/*else{
				Institution institution = institutionService.getInstitutionById(institutionId);
				transferCourse.setInstitution(institution);
			}*/
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
			model.addAttribute("institutionTermType",institutionTermType);
			List<InstitutionTranscriptKeyGrade>  institutionTranscriptKeyGradeList = institutionTranscriptKeyService.getInstitutionTranscriptKeyGradeListByInstitutionId(institutionId);
			List<TransferCourseInstitutionTranscriptKeyGradeAssoc>  transferCourseInstitutionTranscriptKeyGradeAssocList = institutionTranscriptKeyService.getTransferCourseInstitutionTranscriptKeyGradeList(transferCourseId,institutionId);
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
			if(transferCourse.getModifiedBy()!=null  && !transferCourse.getModifiedBy().equals("(NULL)") && !transferCourse.getModifiedBy().isEmpty()){
				transferCourse.setEvaluator1(userService.getUserByUserId(transferCourse.getModifiedBy()));
			}
			model.addAttribute("institutionTranscriptKeyGradeList", institutionTranscriptKeyGradeList);
			model.addAttribute("institutionTranscriptKeyGradeId", institutionTranscriptKeyGradeList!=null && !institutionTranscriptKeyGradeList.isEmpty()?institutionTranscriptKeyGradeList.get(0).getInstitutionTranscriptKey().getId():null);
			
		}	
		model.addAttribute("transferCourse",transferCourse);
		model.addAttribute("gcuCourseLevelList",institutionTranscriptKeyService.getAllGcuCourseLevel());
		model.addAttribute("role","MANAGER");
		model.addAttribute("transferCourseId",transferCourseId);
		model.addAttribute( "transferCourseName",transferCourse.getTrCourseTitle());
		model.addAttribute("tabIndex","7");
		model.addAttribute("comingFromIECycle","0");
		model.addAttribute("currentUserHaveEntryInMainDb", transferCourse != null && transferCourse.getId() != null ?"1":"0");
		model.addAttribute("directLink",directLink);
		countAdd(model);
		return "ieInstitution";
		
		//return "ieCourse";
	}


	@RequestMapping(params="operation=getCoursesForApproval")
	public String getCoursesForApproval(Model model){
		
		model.addAttribute("courses", transferCourseService.getAllCoursesForApproval());
		
		model.addAttribute("role","MANAGER");
		countAdd(model);
		return "coursesForApproval";
	}
	
	@RequestMapping(params="operation=editCourseForApproval" )
	public String editCourseForApproval(@RequestParam("transferCourseId") String transferCourseId,
			Model model){
		
		TransferCourse transferCourse = courseMgmtService.getTransferCourseById(transferCourseId);
		
		List<InstitutionTermType> instTermTypeList = institutionTermTypeService.getAllInstitutionTermType(transferCourse.getInstitution().getId());
		InstitutionTermType institutionTermType = null;
		if(instTermTypeList != null && instTermTypeList.size() > 0){
			institutionTermType = instTermTypeList.get(0);
		}
		
		model.addAttribute("transferCourse" ,transferCourse);
		model.addAttribute("gcuCourseLevelList",institutionTranscriptKeyService.getAllGcuCourseLevel());
		model.addAttribute("institution",institutionService.getInstitutionById(transferCourse.getInstitution().getId()));
		model.addAttribute("institutionTermType",institutionTermType);
		model.addAttribute("role","MANAGER");
		model.addAttribute("institutionId",transferCourse.getInstitution().getId());
		model.addAttribute("institutionName",transferCourse.getInstitution().getName());
		model.addAttribute("transferCourseId",transferCourse.getId());
		model.addAttribute( "transferCourseName",transferCourse.getTrCourseTitle());
		model.addAttribute("courseForApproval", true);
		model.addAttribute("tabIndex","7");
		
		
		countAdd(model);
		
		return "ieInstitution";
		
		//return "ieCourse";
		
	}
	
	@RequestMapping(params="operation=manageCourseTitles" )
	public String manageCourseTitles(@RequestParam("transferCourseId") String transferCourseId,
			@RequestParam(value="institutionId", required =false) String institutionId,
			Model model ){	
		List<TransferCourseTitle> courseTitleList = transferCourseService.getTransferCourseTitlesByTransferCourseId(transferCourseId);
		TransferCourse transferCourse=courseMgmtService.getTransferCourseWithChilds(transferCourseId);
		Institution institution= transferCourse.getInstitution();
		
		model.addAttribute( "courseTitleList",courseTitleList);
		model.addAttribute( "transferCourseId",transferCourseId);
		model.addAttribute("role","MANAGER");
		model.addAttribute("institutionId",institution.getId());
		model.addAttribute("institutionName",institution.getName());
		model.addAttribute( "transferCourseName",transferCourse.getTrCourseTitle());
		model.addAttribute("tabIndex","10");
		model.addAttribute( "transferCourse",transferCourse);
		
		countAdd(model);
		return "ieInstitution";
		//return "ieManageCourseTitles";
	}
	

	@RequestMapping(params="operation=addCourseTitle" )
	public String addCourseTitle(@RequestParam("transferCourseId") String transferCourseId,
			@RequestParam(value="courseTitleId", required=false) String courseTitleId,
			@RequestParam(value="institutionId", required =false) String institutionId,
			Model model ){		
		
		if(courseTitleId !=  null){
			TransferCourseTitle courseTitle = transferCourseService.getTransferCourseTitleById(courseTitleId);
			model.addAttribute("courseTitle",courseTitle);
			model.addAttribute("courseTitleId",courseTitleId);
			
		}
		List<TransferCourseTitle> courseTitleList = transferCourseService.getTransferCourseTitlesByTransferCourseId(transferCourseId);
		if(courseTitleList!=null && courseTitleList.size()>0){
			model.addAttribute( "currentlyActiveTitle",false);
		}else{
			model.addAttribute( "currentlyActiveTitle",true);
		}
		model.addAttribute("institutionId",institutionId);
		model.addAttribute("transferCourseId",transferCourseId);
		model.addAttribute("role","MANAGER");
		return "ieAddCourseTitle";
	}
	
	@RequestMapping(params="operation=saveCourseTitles" )
	public String handleCourseTitles(TransferCourseTitle courseTitle,
			@RequestParam(value="institutionId", required =false) String institutionId,@RequestParam(value="currentlyActiveTitle", required =false) boolean currentlyActiveTitle,Model model ){
		
		if(currentlyActiveTitle){
			courseTitle.setEffective(currentlyActiveTitle);
		}
		if(courseTitle.isEffective()){
			courseMgmtService.effectiveCourseTitle(courseTitle.getTransferCourseId(), courseTitle.getId());
		}
		courseTitle.setEvaluationStatus("EVALUATED");
		transferCourseService.addTransferCourseTitle(courseTitle);
		
		return "redirect:ieManager.html?operation=manageCourseTitles&institutionId="+institutionId+"&transferCourseId="+courseTitle.getTransferCourseId();
		
	}
	
	@RequestMapping(params="operation=getCoursesForReAssignment")
	public String getCoursesForReAssignment(Model model){
		List<TransferCourse> courseReAssignList = courseMgmtService.getCoursesForReAssignment();
		model.addAttribute("courseReAssignList", courseReAssignList);
		countAdd(model);
		return "courseReAssignList";
	}
	
	@RequestMapping(params="operation=getCourseAssignDetails")
	public String getCourseAssignDetails(@RequestParam("transferCourseId") String transferCourseId, Model model){
		
		TransferCourse tc = courseMgmtService.setTransferCourseWithTempMirrorEvaluators(transferCourseId);
		List<User> assignableEvaluators = courseMgmtService.getAssignableEvaluatorsForTransferCourse(tc);
		model.addAttribute("transferCourse", tc);
		model.addAttribute("assignableEvaluators", assignableEvaluators);
		return "reAssignCourse";
	}
	
	@RequestMapping(params="operation=reAssignCourse")
	public String reAssignCourse(@RequestParam("transferCourseId") String transferCourseId,
			@RequestParam("fromId") String fromId,
			@RequestParam("toId") String toId, Model model){
		
		courseMgmtService.reAssignCourse(transferCourseId, fromId, toId);
		return "redirect:ieManager.html?operation=getCoursesForInstitution";
		//return "redirect:ieManager.html?operation=getCoursesForReAssignment";

	}
	
	@RequestMapping(params="operation=getInstitutionsForReassignment")
	public String getInstitutionsForReassignment(Model model){
		List<Institution> institutionReAssignList = institutionService.getInstitutionsForReassignment();
		model.addAttribute("institutionReAssignList", institutionReAssignList);
		countAdd(model);
		return "institutionReAssignList";
	}
	
	@RequestMapping(params="operation=getInstitutionAssignDetails")
	public String getInstitutionAssignDetails(@RequestParam("institutionId") String institutionId, Model model){
		
		Institution i = institutionService.setInstitutionWithTempMirrorEvaluators(institutionId);
		List<User> assignableEvaluators = institutionService.getAssignableEvaluatorsForInstitution(i);
		model.addAttribute("institution", i);
		model.addAttribute("assignableEvaluators", assignableEvaluators);
		return "reAssignInstitution";
	}
	
	@RequestMapping(params="operation=reAssignInstitution")
	public String reAssignInstitution(@RequestParam("institutionId") String institutionId,
			@RequestParam("fromId") String fromId,
			@RequestParam("toId") String toId, Model model){
		
		institutionService.reAssignInstitution(institutionId, fromId, toId);
		//return "redirect:ieManager.html?operation=getInstitutionsForReassignment";
		return "redirect:ieManager.html?operation=getInstitutionList";

	}
	
	@RequestMapping(params="operation=effectiveAccreditingBody" )
	public String effectiveAccreditingBody(@RequestParam("institutionId") String institutionId, 
			@RequestParam("accreditingBodyId") String accreditingBodyId,Model model ){	
		
		accreditingBodyService.effectiveAccreditingBody(institutionId,accreditingBodyId);
		return "redirect:ieManager.html?operation=manageAccreditingBody&institutionId="+institutionId;
	}
	
	@RequestMapping(params="operation=effectiveTranscriptKey" )
	public String effectiveTranscriptKey(@RequestParam("institutionId") String institutionId, 
			@RequestParam("transcriptKeyId") String transcriptKeyId,Model model ){	
		
		institutionTranscriptKeyService.effectiveTranscriptKey(institutionId, transcriptKeyId);
		return "redirect:ieManager.html?operation=manageInstitutionTranscriptKey&institutionId="+institutionId;
	}
	@RequestMapping(params="operation=effectiveTermType" )
	public String effectiveTermType(@RequestParam("institutionId") String institutionId, 
			@RequestParam("termTypeId") String termTypeId,Model model ){	
		institutionTermTypeService.effectiveTermType(institutionId, termTypeId);
		return "redirect:ieManager.html?operation=manageInstitutionTermType&institutionId="+institutionId;
	}
	@RequestMapping(params="operation=effectiveArticulationAgreement" )
	public String effectiveArticulationAgreement(@RequestParam("institutionId") String institutionId, 
			@RequestParam("articulationAgreementId") String articulationAgreementId,Model model ){	
		
		articulationAgreementService.effectiveArticulationAgreement(institutionId, articulationAgreementId);
		return "redirect:ieManager.html?operation=manageArticulationAgreement&institutionId="+institutionId;
	}
	/*-----------------*/
	@RequestMapping(params="operation=effectiveCourseRelationship" )
	public String effectiveCourseRelationship(@RequestParam("institutionId") String institutionId, 
			@RequestParam("courseMappingId") String courseMappingId,
			@RequestParam("transferCourseId") String transferCourseId,Model model ){	
		courseMgmtService.effectiveCourseRelationship(transferCourseId, courseMappingId);
		
		return "redirect:ieManager.html?operation=manageCourseRelationship&institutionId="+institutionId+"&transferCourseId="+transferCourseId;
	}
	@RequestMapping(params="operation=effectiveCourseCtgRelationship" )
	public String effectiveCourseCtgRelationship(@RequestParam("institutionId") String institutionId, 
			@RequestParam("courseCategoryMappingId") String courseCategoryMappingId,
			@RequestParam("transferCourseId") String transferCourseId,Model model ){	
		courseMgmtService.effectiveCourseCtgRelationship(transferCourseId, courseCategoryMappingId);
		
		return "redirect:ieManager.html?operation=manageCourseCtgRelationship&institutionId="+institutionId+"&transferCourseId="+transferCourseId;
	}
	@RequestMapping(params="operation=effectiveCourseTitles" )
	public String effectiveCourseTitles(@RequestParam("institutionId") String institutionId, 
			@RequestParam("courseTitleId") String courseTitleId,
			@RequestParam("transferCourseId") String transferCourseId,Model model ){	
		courseMgmtService.effectiveCourseTitle(transferCourseId, courseTitleId);
		
		return "redirect:ieManager.html?operation=manageCourseTitles&institutionId="+institutionId+"&transferCourseId="+transferCourseId;
	}
	
	@RequestMapping(params="operation=getTransferCourseByInstitutionIdAndString")
	public ModelAndView getTransferCourseByInstitutionIdAndString(@RequestParam("institutionId") String institutionId,
			@RequestParam("searchBy") String searchBy,
			@RequestParam("searchText") String searchText,Model model){
		List<TransferCourse> trCourseList = transferCourseService.getCourseByInstitutionIdAndString
		(institutionId, searchBy, searchText);
		
		Map<String, List<TransferCourse>> map = new HashMap<String, List<TransferCourse>>();
		map.put(Constants.FLEX_JSON_DATA, trCourseList);
		
		return new ModelAndView(Constants.FLEX_JSON_VIEW, map);
	}
	
	@RequestMapping(params="operation=getInstitutionByCodeAndTitle")
	public ModelAndView getInstitutionByCodeAndTitle(
			@RequestParam("searchBy") String searchBy,
			@RequestParam("searchText") String searchText,Model model){
		List<Institution> institutionList = institutionService.getInstitutionsList(searchBy, searchText, "ALL", null);
		
		Map<String, List<Institution>> map = new HashMap<String, List<Institution>>();
		map.put(Constants.FLEX_JSON_DATA, institutionList);
		
		return new ModelAndView(Constants.FLEX_JSON_VIEW, map);
	}
	
	@RequestMapping(params="operation=summaryInstitution" )
	public String summaryInstitution(@RequestParam("institutionId") String institutionId, Model model ){	
		
		Institution institution=institutionService.getInstitutionById(institutionId);
		if (institution.getParentInstitutionId()!=null && !institution.getParentInstitutionId().isEmpty()){
			Institution parentInstitution=institutionService.getInstitutionById(institution.getParentInstitutionId());
			institution.setParentInstitutionName(parentInstitution.getName());
		}
		model.addAttribute("institution",institution );
		model.addAttribute("tabIndex","6");
		model.addAttribute("role","MANAGER");
		model.addAttribute("institutionId",institutionId);
		return "ieEvaluateInstitutionForm";		
		
	
	}
	@RequestMapping(params="operation=summaryCourse" )
	public String summaryCourse(@RequestParam("transferCourseId") String transferCourseId, Model model ){	
		
		
		model.addAttribute("tabIndex","5");
		model.addAttribute("role","MANAGER");
		model.addAttribute( "transferCourse",courseMgmtService.getTransferCourseWithChilds(transferCourseId));
		model.addAttribute("transferCourseId",transferCourseId);
		return "ieEvaluateCourseForm";		
		
	
	}
	@RequestMapping(params="operation=loadCourseTitles" )
	public String loadCourseTitles(@RequestParam("transferCourseId") String transferCourseId,
			@RequestParam(value="institutionId", required =false) String institutionId,@RequestParam(value="comingFromIECycle", required =false) String comingFromIECycle,
			@RequestParam(value="transferCourseMirrorId", required =false) String transferCourseMirrorId,@RequestParam(value="subjectPopup", required =false) String subjectPopup,
			Model model ){
		String layoutToRender = null;
		TransferCourse transferCourse = courseMgmtService.getTransferCourseById(transferCourseId);
		Institution institution= transferCourse.getInstitution();
		if(subjectPopup.equalsIgnoreCase("0")){
			List<TransferCourseTitle> courseTitleList = transferCourseService.getTransferCourseTitlesByTransferCourseId(transferCourseId);
			model.addAttribute( "courseTitleList",courseTitleList);
			layoutToRender = "ieCourseTitlePopup";
		}else{
			List<MilitarySubject> militarySubjectList =  transferCourseService.getMilitarySubjectByTransferCourseId(transferCourseId);
			model.addAttribute( "militarySubjectList",militarySubjectList);
			layoutToRender = "ieMilitarySubjectPopup";
		}
		model.addAttribute( "transferCourseId",transferCourseId);
		if(comingFromIECycle!=null && !comingFromIECycle.isEmpty() && comingFromIECycle.equals("0")){
			model.addAttribute("role","MANAGER");
		}else{
			model.addAttribute("role",UserUtil.getCurrentRole().getDescription());
			model.addAttribute("transferCourseMirrorId", transferCourseMirrorId);
		}
		model.addAttribute("institutionId",institution.getId());
		model.addAttribute("institutionName",institution.getName());
		model.addAttribute( "transferCourseName",transferCourse.getTrCourseTitle());
		model.addAttribute("tabIndex","10");
		model.addAttribute( "transferCourse",transferCourse);
		
		countAdd(model);
		return layoutToRender;

		//return "ieManageCourseTitles";
		
	}
	@RequestMapping(params="operation=ieSaveTransferCourse")
	public String saveTransferCourse(@RequestParam("institutionId") String institutionId,
			@RequestParam(value="saveAndNext",required=false) String saveAndNext,@RequestParam(value="directLink", required=false) String directLink,
			TransferCourse transferCourse,
			 Model model ){
		
		User user=  UserUtil.getCurrentUser();
		TransferCourseTitle tct = new TransferCourseTitle();
		//creatingCourse variable will be false if already created course is getting edited
		boolean creatingCourse;
		if(transferCourse.getId()==null){
			creatingCourse = true;
		}
		else creatingCourse = false;
		
		Institution institution=institutionService.getInstitutionById(institutionId);
		transferCourse.setInstitution(institution);
		InstitutionTermType institutionTermType = institutionTermTypeService.getEffectiveInstitutionTermTypeByInititutionId(institutionId);
		List<InstitutionTranscriptKeyGrade>  institutionTranscriptKeyGradeList = institutionTranscriptKeyService.getInstitutionTranscriptKeyGradeListByInstitutionId(institutionId);
		TransferCourse checkTransferCourse = null;
		
		if(directLink != null && !directLink.isEmpty() && directLink.equals("0")){/**Check If Coming from CreateCourse link directly then look for Duplicate*/
			checkTransferCourse = courseMgmtService.getTransferCourseByCodeAndInstitution(transferCourse.getTrCourseCode(), institutionId);
		}else{
			//Not require to check for duplicate
		}
		
	if(checkTransferCourse == null){
			transferCourse.setModifiedBy(user.getId());
			transferCourse.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
			transferCourse.setCheckedBy(null);
			transferCourse.setConfirmedBy(null);
			transferCourse.setTrCourseTitle(transferCourse.getTitleList().get(0).getTitle());
			TransferCourse tc = courseMgmtService.getTransferCourseByCodeAndInstitution(transferCourse.getTrCourseCode(), institutionId);
			if(tc == null){
				TransferCourse tcCheckAgain = courseMgmtService.getTransferCourseByCodeAndInstitution(transferCourse.getTrCourseCode(), institutionId);
				if(tcCheckAgain == null){
					courseMgmtService.saveTransferCourse(transferCourse);
				}else{
					courseMgmtService.updateTransferCourse(transferCourse);
				}
			}else{
				courseMgmtService.updateTransferCourse(transferCourse);
			}
			try{
				jmsMessageSender.sendTransferCourseMessage(transferCourse);
			}catch (Exception e) {
				String uniqueId = RequestContext.getRequestIdFromContext();
				log.error("Error get while sending TransferCourseMessage jmsMessageSender."+e+" RequestId:"+uniqueId, e);
			}
			List<TransferCourseInstitutionTranscriptKeyGradeAssoc> transferCourseInstitutionTranscriptKeyGradeAssocNewList = new ArrayList<TransferCourseInstitutionTranscriptKeyGradeAssoc>();
			List<TransferCourseInstitutionTranscriptKeyGradeAssoc> transferCourseInstitutionTranscriptKeyGradeAssocList = transferCourse.getTransferCourseInstitutionTranscriptKeyGradeAssocList();
			
			courseMgmtService.removeTransferCourseMirrors(transferCourse.getId());
			List<TransferCourseTitle> titleNewList = new ArrayList<TransferCourseTitle>();
			List<TransferCourseTitle> tctList = transferCourseService.getTransferCourseTitlesByTransferCourseId(transferCourse.getId());
			// all the titles should be evaluated when the course is evaluated
			if(tctList != null && !tctList.isEmpty()){
				for(TransferCourseTitle title : tctList){
					title.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
					if(transferCourse.getTrCourseTitle().equalsIgnoreCase(title.getTitle())){
						title.setEffective(true);
					}else{
						title.setEffective(false);
					}
					//title.setEffectiveDate(transferCourse.getEffectiveDate());
					//title.setEndDate(transferCourse.getEndDate());
					title.setTransferCourseId(transferCourse.getId());
					transferCourseService.addTransferCourseTitle(title);
				}
			} 
			courseMgmtService.updateTransferCourse(transferCourse);
			
			if (tctList==null){
				tctList= new ArrayList<TransferCourseTitle>();
				tct.setTransferCourseId(transferCourse.getId());
				tct.setEffectiveDate(transferCourse.getEffectiveDate());
				tct.setEndDate(transferCourse.getEndDate());
				tct.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
				tct.setEffective(true);
				tct.setTitle(transferCourse.getTitleList().get(0).getTitle());
				
				titleNewList.add(tct);
				transferCourseService.addTransferCourseTitles(titleNewList);
			}
			if(transferCourseInstitutionTranscriptKeyGradeAssocList != null && !transferCourseInstitutionTranscriptKeyGradeAssocList.isEmpty()){
				for(TransferCourseInstitutionTranscriptKeyGradeAssoc transferCourseInstitutionTranscriptKeyGradeAssoc : transferCourseInstitutionTranscriptKeyGradeAssocList){
					
					if(transferCourseInstitutionTranscriptKeyGradeAssoc.getInstitutionTranscriptKeyGradeId() != null && !transferCourseInstitutionTranscriptKeyGradeAssoc.getInstitutionTranscriptKeyGradeId().isEmpty()){
						transferCourseInstitutionTranscriptKeyGradeAssoc.setTransferCourse(transferCourse);
						transferCourseInstitutionTranscriptKeyGradeAssocNewList.add(transferCourseInstitutionTranscriptKeyGradeAssoc);
					}
				}
			}
			
			List<TransferCourseInstitutionTranscriptKeyGradeAssoc>  transferCourseInstitutionTranscriptKeyGradeAssocReadList= courseMgmtService.loadAllTransferCourseInstitutionTranscriptKeyGradeAssocByTransferCourseId(transferCourse.getId());
			
			if(transferCourseInstitutionTranscriptKeyGradeAssocReadList != null && !transferCourseInstitutionTranscriptKeyGradeAssocReadList.isEmpty()){
				courseMgmtService.deleteAllGradeAssoc(transferCourseInstitutionTranscriptKeyGradeAssocReadList);
			}
			courseMgmtService.addTransferCourseInstitutionTranscriptKeyGradeAssocList(transferCourseInstitutionTranscriptKeyGradeAssocNewList);
			
			
		
		
		if(transferCourseInstitutionTranscriptKeyGradeAssocNewList != null && !transferCourseInstitutionTranscriptKeyGradeAssocNewList.isEmpty() && institutionTranscriptKeyGradeList != null && !institutionTranscriptKeyGradeList.isEmpty()){
			for(InstitutionTranscriptKeyGrade institutionTranscriptKeyGrade :institutionTranscriptKeyGradeList){
				boolean found = false;
				for(TransferCourseInstitutionTranscriptKeyGradeAssoc transferCourseInstitutionTranscriptKeyGradeAssoc :transferCourseInstitutionTranscriptKeyGradeAssocNewList){
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
		if(transferCourse.getEvaluationStatus().equalsIgnoreCase(TranscriptStatusEnum.EVALUATED.getValue()) && transferCourse.getInstitution() != null && !transferCourse.getInstitution().getId().isEmpty()){
			List<StudentTranscriptCourse> studentTranscriptCourseList = transcriptService.getAllStudentTranscriptCourseByTransferCourseIdAndInstitutionId(transferCourse.getId() ,transferCourse.getInstitution().getId());
			if(studentTranscriptCourseList != null && !studentTranscriptCourseList.isEmpty()){
				for(StudentTranscriptCourse studentTranscriptCourse :studentTranscriptCourseList){
					studentTranscriptCourse.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
					studentTranscriptCourse.setTranscriptStatus(transferCourse.getTransferStatus());
				}
				transcriptMgmtDAO.saveTranscriptList( studentTranscriptCourseList );
				
			}
		}
		List<CourseMapping> courseMappingList = courseMgmtService.getCourseMappingByTransferCourseId(transferCourse.getId());
		
		List<CourseCategoryMapping> courseCategoryMappingList = courseMgmtService.getCourseCategoryMappingByTransferCourseId(transferCourse.getId());
		transferCourse.setCourseMappings(courseMappingList);
		transferCourse.setCourseCategoryMappings(courseCategoryMappingList);
		
		if(transferCourse.getModifiedBy()!=null  && !transferCourse.getModifiedBy().equals("(NULL)") && !transferCourse.getModifiedBy().isEmpty()){
			transferCourse.setEvaluator1(userService.getUserByUserId(transferCourse.getModifiedBy()));
		}
	}else{
		model.addAttribute("validationMSG" ,"The Course "+transferCourse.getTrCourseCode()+" is already exist for Institution.");
	}
		model.addAttribute("transferCourse" ,transferCourse);
		model.addAttribute("gcuCourseLevelList",institutionTranscriptKeyService.getAllGcuCourseLevel());
		model.addAttribute("institution",institution);
		model.addAttribute("institutionTermType",institutionTermType);
		model.addAttribute("role","MANAGER");
		model.addAttribute("institutionId",institutionId);
		model.addAttribute("transferCourseId",transferCourse.getId());
		model.addAttribute("comingFromIECycle","0");		
		model.addAttribute("currentUserHaveEntryInMainDb", transferCourse != null && transferCourse.getId() != null ?"1":"0");
		model.addAttribute("institutionTranscriptKeyGradeList", institutionTranscriptKeyGradeList);
		
		//return "ieCourse";
		countAdd(model);
		if(saveAndNext.equals("0")){
			model.addAttribute("tabIndex","7");
			return "ieInstitution";
		}else{
			if(checkTransferCourse == null && transferCourse.getTransferStatus().equalsIgnoreCase(TranscriptStatusEnum.NOTELIGIBLE.getValue())){
				return "redirect:ieManager.html?operation=summaryCourse";
			}else if(checkTransferCourse == null && transferCourse.getTransferStatus().equalsIgnoreCase(TranscriptStatusEnum.ELIGIBLE.getValue())){
				return "redirect:ieManager.html?operation=manageCourseRelationship";
			}else{
				model.addAttribute("tabIndex","7");
				return "ieInstitution";
			}
		}	
		
	}
	@RequestMapping(params="operation=saveTransferCourseTitle" )
	public String saveTransferCourseTitle(TransferCourse transferCourse,
			@RequestParam(value="institutionId", required =false) String institutionId,@RequestParam(value="currentlyActiveTitleIndex", required =false) int currentlyActiveTitleIndex,
			@RequestParam(value="transferCourseId", required =false) String transferCourseId, Model model ){
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
			
		}/*
		if(currentlyActiveTitle){
			courseTitle.setEffective(currentlyActiveTitle);
		}
		if(courseTitle.isEffective()){
			courseMgmtService.effectiveCourseTitle(courseTitle.getTransferCourseId(), courseTitle.getId());
		}*/
		/*List<TransferCourseTitle> courseTitleList=transferCourseService.getTransferCourseTitlesByTransferCourseId(transferCourse.getId());
		if(courseTitleList != null && courseTitleList.size()>0){
			transferCourseService.removeTransferCourseTitles(courseTitleList);
		}*/
		transferCourseService.addTransferCourseTitles(titleList);
		return "redirect:ieManager.html?operation=createCourse&institutionId="+institutionId+"&transferCourseId="+transferCourseId;
		
	}
	@RequestMapping(params="operation=saveCourseRelationshipList" )
	public String saveCourseRelationshipList(TransferCourse transferCourse,
			@RequestParam(value="institutionId", required =false) String institutionId,
			@RequestParam(value="transferCourseId", required =false) String transferCourseId,
			@RequestParam(value="saveAndNext",required=false) String saveAndNext,Model model ){	
		
		//List<CourseMapping> courseMappingProcessedList = new ArrayList<CourseMapping>();
		List<CourseMapping> courseMappingList = courseMgmtService.getCourseMappingByTransferCourseId(transferCourseId);
		if(courseMappingList !=null && !courseMappingList.isEmpty()){
			courseMgmtService.removeCourseMappingList(courseMappingList);
		}
		
		List<CourseMapping> courseMappingNewList = transferCourse.getCourseMappings();
		if(courseMappingNewList != null && !courseMappingNewList.isEmpty()){
			for(CourseMapping courseMapping : courseMappingNewList){
				if(courseMapping.getCourseMappingDetails() != null && !courseMapping.getCourseMappingDetails().isEmpty()){
					courseMapping.setTrCourseId(transferCourseId);
					//courseMappingProcessedList.add(courseMapping);
					courseMgmtService.addCourseRelationShip(courseMapping);
					for(CourseMappingDetail cmd:courseMapping.getCourseMappingDetails()){
						if(cmd.getGcuCourse()!=null && cmd.getGcuCourse().getCourseCode()!=null && !cmd.getGcuCourse().getCourseCode().isEmpty()){
							cmd.setCourseMappingId(courseMapping.getId());
							courseMgmtService.addCourseRelationShipDetail(cmd);
						}
					}
					
				}
			}
			
		}
		//First delete the older CourseCategoryMapping
		List<CourseCategoryMapping> courseCategoryMappingList = courseMgmtService.getCourseCategoryMappingByTransferCourseId(transferCourseId);
		
		if(courseCategoryMappingList !=null && !courseCategoryMappingList.isEmpty()){
			courseMgmtService.removeCourseCategoryMappingList(courseCategoryMappingList);
		}
		/*if(courseMappingProcessedList != null && !courseMappingProcessedList.isEmpty()){
			
			courseMgmtService.addCourseMappings(courseMappingProcessedList);
		}*/
		if(saveAndNext.equals("0")){
			return "redirect:ieManager.html?operation=manageCourseRelationship&institutionId="+institutionId+"&transferCourseId="+transferCourseId;
		}else{
			return "redirect:ieManager.html?operation=summaryCourse&transferCourseId="+transferCourseId;
		}
		
		
	}
	@RequestMapping(params="operation=saveCourseCtgRelationshipList" )
	public String saveCourseCtgRelationshipList(TransferCourse transferCourse,
			@RequestParam(value="institutionId", required =false) String institutionId,
			@RequestParam(value="transferCourseId", required =false) String transferCourseId,
			@RequestParam(value="saveAndNext",required=false) String saveAndNext,Model model){
		
		List<CourseCategoryMapping> courseCategoryMappingProcessedList = new ArrayList<CourseCategoryMapping>();
		
		List<CourseCategoryMapping> courseCategoryMappingList = courseMgmtService.getCourseCategoryMappingByTransferCourseId(transferCourseId);
		
		if(courseCategoryMappingList !=null && !courseCategoryMappingList.isEmpty()){
			courseMgmtService.removeCourseCategoryMappingList(courseCategoryMappingList);
		}
		List<CourseCategoryMapping> courseCategoryMappingNewList = transferCourse.getCourseCategoryMappings();
		if(courseCategoryMappingNewList != null && !courseCategoryMappingNewList.isEmpty()){
			for(CourseCategoryMapping courseCategoryMapping : courseCategoryMappingNewList){
				if(courseCategoryMapping.getGcuCourseCategory() != null  && courseCategoryMapping.getGcuCourseCategory().getId() != null && !courseCategoryMapping.getGcuCourseCategory().getId().isEmpty()){
					courseCategoryMapping.setTrCourseId(transferCourseId);
					courseCategoryMappingProcessedList.add(courseCategoryMapping);
				}
			}
			
		}
		//First delete the older CourseMapping
		List<CourseMapping> courseMappingList = courseMgmtService.getCourseMappingByTransferCourseId(transferCourseId);
		if(courseMappingList !=null && !courseMappingList.isEmpty()){
			courseMgmtService.removeCourseMappingList(courseMappingList);
		}
		
		if(courseCategoryMappingProcessedList !=null && !courseCategoryMappingProcessedList.isEmpty()){
			courseMgmtService.addCourseCategoryMappingListRelationShip(courseCategoryMappingProcessedList);
		}
		if(saveAndNext.equals("0")){
			return "redirect:ieManager.html?operation=manageCourseRelationship&institutionId="+institutionId+"&transferCourseId="+transferCourseId;
		}else{
			return "redirect:ieManager.html?operation=summaryCourse&transferCourseId="+transferCourseId;
		}
		
	}
	
	@RequestMapping(params="operation=loadInstitutionTranscriptKeyGrade" )
	public String loadInstitutionTranscriptKeyGrade(@RequestParam(value="institutionId", required =false) String institutionId,
			@RequestParam(value="transferCourseId", required =false) String transferCourseId,Model model){
		
			Institution institution = institutionService.getInstitutionById(institutionId);
			List<InstitutionTranscriptKeyGrade>  institutionTranscriptKeyGradeList = institutionTranscriptKeyService.getInstitutionTranscriptKeyGradeListByInstitutionId(institutionId);
			if(transferCourseId != null && institutionId !=null){
					List<TransferCourseInstitutionTranscriptKeyGradeAssoc>  transferCourseInstitutionTranscriptKeyGradeAssocList = institutionTranscriptKeyService.getTransferCourseInstitutionTranscriptKeyGradeList(transferCourseId,institutionId);
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
			}
			List<InstitutionTermType> instTermTypeList = institutionTermTypeService.getAllInstitutionTermType(institutionId);
			InstitutionTermType institutionTermType = null;
			if(instTermTypeList != null && instTermTypeList.size() > 0){
				institutionTermType = instTermTypeList.get(0);
			}
			model.addAttribute("institutionTermType",institutionTermType);
			model.addAttribute("institution",institution);			
			model.addAttribute("institutionTranscriptKeyGradeList", institutionTranscriptKeyGradeList);
		
		return "acceptedTransferGrade";
	}
	@RequestMapping(params="operation=loadInstitutionCourseLevel" )
	public String loadInstitutionCourseLevel(@RequestParam(value="idOfInstitute", required =false) String institutionId,Model model){
		List<InstitutionTranscriptKey> institutionTranscriptKeyList = institutionTranscriptKeyService.getAllInstitutionTranscriptKey(institutionId);
		InstitutionTranscriptKey institutionTranscriptKey= new InstitutionTranscriptKey();
		if(institutionTranscriptKeyList!=null && institutionTranscriptKeyList.size()>0){
		 institutionTranscriptKey=institutionTranscriptKeyList.get(0);
		}
		model.addAttribute( "institutionTranscriptKey",institutionTranscriptKey);
		model.addAttribute("gcuCourseLevelList",institutionTranscriptKeyService.getAllGcuCourseLevel());
		return "instituteCourseLevel";
	}
	@RequestMapping(params="operation=saveTransferCourseMilitarySubject" )
	public String saveTransferCourseMilitarySubject(TransferCourse transferCourse,
			@RequestParam(value="institutionId", required =false) String institutionId,
			@RequestParam(value="transferCourseId", required =false) String transferCourseId, Model model ){
		
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
			
		}/*
		if(currentlyActiveTitle){
			courseTitle.setEffective(currentlyActiveTitle);
		}
		if(courseTitle.isEffective()){
			courseMgmtService.effectiveCourseTitle(courseTitle.getTransferCourseId(), courseTitle.getId());
		}*/
		/*List<TransferCourseTitle> courseTitleList=transferCourseService.getTransferCourseTitlesByTransferCourseId(transferCourse.getId());
		if(courseTitleList != null && courseTitleList.size()>0){
			transferCourseService.removeTransferCourseTitles(courseTitleList);
		}*/
		transferCourseService.addMilitarySubject(titleList);
		return "redirect:ieManager.html?operation=createCourse&institutionId="+institutionId+"&transferCourseId="+transferCourseId;
		
	}
	@RequestMapping(params="operation=getTransferCourseByCodeAndInstitution")
	public ModelAndView getTransferCourseByCodeAndInstitution(
			@RequestParam("courseCode") String courseCode,@RequestParam("institutionId") String institutionId,Model model){
		TransferCourse transferCourse = courseMgmtService.getTransferCourseByCodeAndInstitution(courseCode, institutionId);
		
		Map<String, TransferCourse> map = new HashMap<String, TransferCourse>();
		map.put(Constants.FLEX_JSON_DATA, transferCourse);
		
		return new ModelAndView(Constants.FLEX_JSON_VIEW, map);
	}
	@RequestMapping(params="operation=iemHomePage" )
	public String getIemHomePage(@RequestParam(value="idOfInstitute", required =false) String institutionId,HttpServletRequest request,Model model){
		List<College> collegeList = institutionService.getAllCollege();
		String roleId = "3";//SLE 
		List<User> userList = userService.getUserByRoleId(roleId);
		List<TransferCourse> tcForReassignment=courseMgmtService.getCoursesForReAssignment();		
		String status="ALL";
		paginateListFactory= new PaginateListFactory();
		 ExtendedPaginatedList paginatedList = paginateListFactory.getPaginatedListFromRequest(request);
		  transferCourseService.getAllRecordsPage(TransferCourse.class, paginatedList, institutionId, status, "", "");
		  for(TransferCourse tc: (List<TransferCourse>)paginatedList.getList()){
				if(tcForReassignment!=null && tcForReassignment.size()>0){
					for(TransferCourse institutionReAssignment:tcForReassignment){
						if(tc.getId().equals(institutionReAssignment.getId())){
							tc.setReassignable(true);
						}
					}
			    }
				if(tc.getCheckedBy()!=null  && !tc.getCheckedBy().equals("(NULL)") && !tc.getCheckedBy().isEmpty()){
					tc.setEvaluator1(userService.getUserByUserId(tc.getCheckedBy()));
				}
				if(tc.getConfirmedBy()!=null && !tc.getConfirmedBy().equals("(NULL)")&& !tc.getConfirmedBy().isEmpty()){
					tc.setEvaluator2(userService.getUserByUserId(tc.getConfirmedBy()));
				}
				
		  }
		model.addAttribute("collegeList", collegeList);
		
		model.addAttribute("userList", userList);
		model.addAttribute("conflictCount",courseMgmtService.getConflictCourses().size());
		model.addAttribute("approvalCount",transferCourseService.getRequiredApprovalCount());
		if(tcForReassignment!=null && tcForReassignment.size()>0){
			model.addAttribute("reassignableCount",tcForReassignment.size());
		}
		return "iemHomePage";
	}
	@RequestMapping(params="operation=loadAllSLEForCollegeCode" )
	public ModelAndView loadAllSLE(@RequestParam(value="collegeCode", required =false) String collegeCode,HttpServletRequest request,Model model){
		//List<College> collegeList = institutionService.getAllCollege();
		String roleId = "3";//SLE 
		List<User> userList = userService.getUserByRoleId(roleId);
		List<SleCollege> sleCollegeList = transcriptService.getAllSLEForCollegeCode(collegeCode);
		if(userList != null && !userList.isEmpty()){
			for(User user : userList){
				if(sleCollegeList != null && !sleCollegeList.isEmpty()){
					boolean sleFoundWithSameCollegeCode = false;
					for(SleCollege sleCollege : sleCollegeList){
						if(sleCollege.getUserId().equalsIgnoreCase(user.getId())){
							sleFoundWithSameCollegeCode = true;
							break;
						}
					}
					if(sleFoundWithSameCollegeCode){
						user.setAssignedToCollegeCode("checked");
					}else{
						user.setAssignedToCollegeCode("");
					}
				}
			}
		}
		Map<String, List<User>> map = new HashMap<String, List<User>>();
		map.put(Constants.FLEX_JSON_DATA, userList);
		
		return new ModelAndView(Constants.FLEX_JSON_VIEW, map);
	}
	@RequestMapping(params="operation=wireSLEToCollgedCode" )
	public String wireSLEToCollgedCode(@RequestParam(value="userIdToWire", required =false) String userIdsToWire,@RequestParam(value="collegeCode" , required= false) String collegeCode,HttpServletRequest request,Model model){
		List<SleCollege> sleCollegeList = new ArrayList<SleCollege>();
		if(collegeCode != null && !collegeCode.isEmpty()){
			if(userIdsToWire != null && !userIdsToWire.isEmpty()){
				String []userIds = userIdsToWire.split(",");
				if(userIds.length>0){
					for(int index = 0; index<userIds.length; index++){
						if(userIds[index] != null && !userIds[index].isEmpty()){
							SleCollege sleCollege = new SleCollege();
							sleCollege.setCollegeId(collegeCode);
							sleCollege.setUserId(userIds[index]);
							sleCollege.setCreatedBy(UserUtil.getCurrentUser().getId());
							sleCollege.setModifiedBy(UserUtil.getCurrentUser().getId());
							sleCollege.setCreatedDate(new Date());
							sleCollege.setModifiedDate(new Date());
							sleCollegeList.add(sleCollege);
						}
					}
				}
			}
		}
		//TODO
		transcriptService.resetStudentInstitutionTranscriptForCollegeCode(collegeCode,sleCollegeList);
		return "redirect:ieManager.html?operation=iemHomePage";
	}
}
