package com.ss.evaluation.controller;

import java.util.Date;
import java.util.List;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ss.common.util.Constants;
import com.ss.course.service.CourseMgmtService;
import com.ss.course.value.CourseCategoryMapping;
import com.ss.course.value.CourseMapping;
import com.ss.course.value.TransferCourse;
import com.ss.course.value.TransferCourseTitle;
import com.ss.evaluation.service.EvaluationService;
import com.ss.evaluation.service.TransferCourseService;
import com.ss.institution.service.AccreditingBodyInstituteService;
import com.ss.institution.service.ArticulationAgreementService;
import com.ss.institution.service.InstitutionService;
import com.ss.institution.service.InstitutionTermTypeService;
import com.ss.institution.service.InstitutionTranscriptKeyService;
import com.ss.institution.value.AccreditingBodyInstitute;
import com.ss.institution.value.ArticulationAgreement;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionTermType;
import com.ss.institution.value.InstitutionTranscriptKey;
import com.ss.paging.helper.ExtendedPaginatedList;
import com.ss.paging.helper.PaginateListFactory;

@Controller
@RequestMapping( "/evaluation/admin.html" )
public class AdminController {
	
	private static transient Logger log = LoggerFactory.getLogger( AdminController.class );
	
	@Autowired EvaluationService evaluationService;
	
	@Autowired InstitutionService institutionService;
	
	@Autowired TransferCourseService transferCourseService;
	
	@Autowired InstitutionTermTypeService institutionTermTypeService;
	
	@Autowired CourseMgmtService courseMgmtService;
	
	@Autowired InstitutionTranscriptKeyService institutionTranscriptKeyService;
	
	@Autowired AccreditingBodyInstituteService accreditingBodyInstituteService;
	
	@Autowired ArticulationAgreementService articulationAgreementService;
	
	private  PaginateListFactory paginateListFactory;
	
	@InitBinder
	public void allowEmptyDateBinding( WebDataBinder binder )
	{
	    // Allow for null values in date fields.
	    binder.registerCustomEditor( Date.class, new CustomDateEditor( Constants.COMMON_DATE_FORMAT, true ));
	    // tell spring to set empty values as null instead of empty string.
	    binder.registerCustomEditor( String.class, new StringTrimmerEditor( true ));
	}
	
/*	@RequestMapping( params="operation=adminView" )
	public String initEvaluation(){
		return "adminView";
	}
*/	
	@RequestMapping( params="operation=viewInstitutions")
	public String viewInstitutions( @RequestParam(value="status", required=false) String status, 
			@RequestParam(value="searchBy", required=false) String searchBy, 
			@RequestParam(value="searchText", required=false) String searchText, Model model){
	
		if(status==null || status.isEmpty())
			status="ALL";
		model.addAttribute("institutionList", institutionService.getInstitutionsList(searchBy, searchText, status, null));
		
		if(searchBy == null || "".equals(searchBy)){
			searchBy = "2";
		}
		if(searchText == null){
			searchText = "";
		}
		
		model.addAttribute("status", status);
		model.addAttribute("searchBy",searchBy);
		model.addAttribute("searchText", searchText);
		return "viewInstitutions";
	}
	
	@RequestMapping(params="operation=viewTranscripts")
	public String viewTranscripts( @RequestParam(value="status", required=false) String status,
			@RequestParam(value="crmId", required=false) String crmId,
			Model model){
		model.addAttribute("sitList",evaluationService.getAllSITList(status, crmId));
		model.addAttribute("status",status);
		return "viewTranscripts";
	}
	@RequestMapping(params="operation=viewTranscriptsGroup")
	public String viewTranscriptsGroup(	Model model){
		model.addAttribute("sitAwaitingIEList",evaluationService.getAllSITList("AWAITING IE", null));
		model.addAttribute("sitAwaitingIEMList",evaluationService.getAllSITList("AWAITING IEM", null));
		model.addAttribute("sitDraftList",evaluationService.getAllSITList("DRAFT", null));
		model.addAttribute("sitAwaitingLOPEList",evaluationService.getAllSITList("AWAITING LOPE", null));
		model.addAttribute("sitEvaluatedLOPEList",evaluationService.getAllSITList("EVALUATED LOPE", null));
		model.addAttribute("sitAwaitingSLEList",evaluationService.getAllSITList("AWAITING SLE", null));
		model.addAttribute("sitEvaluatedOfficialList",evaluationService.getAllSITList("EVALUATED OFFICIAL", null));
	
		
		return "viewTranscriptsGroup";
	}
	
	@RequestMapping(params="operation=viewCourses")
	public String viewCourses(@RequestParam("institutionId") String institutionId,
			@RequestParam(value="status", required=false) String status,HttpServletRequest request, 
			@RequestParam(value="searchBy", required=false) String searchBy, 
			@RequestParam(value="searchText", required=false) String searchText, Model model){
		
		Institution institution = null;
		if(institutionId!=null&&!institutionId.isEmpty()){
			institution = institutionService.getInstitutionById(institutionId);
		}
		
		if(status==null || status.isEmpty())
			status="ALL";
		paginateListFactory= new PaginateListFactory();
		 ExtendedPaginatedList paginatedList = paginateListFactory.getPaginatedListFromRequest(request);
		  transferCourseService.getAllRecordsPage(TransferCourse.class, paginatedList, institutionId, status, searchBy, searchText);
		
		  model.addAttribute("courseList", paginatedList);
		  
		  if(searchBy == null || "".equals(searchBy)){
				searchBy = "2";
			}
			if(searchText == null){
				searchText = "";
			}
			
			model.addAttribute("status", status);
			model.addAttribute("searchBy",searchBy);
			model.addAttribute("searchText", searchText);
			model.addAttribute("tabIndex","6");
			model.addAttribute("role","ADMIN");
			model.addAttribute("institutionId",institutionId);
			model.addAttribute("institution", institution);
			if(institution != null){
				model.addAttribute("institutionName",institution.getName());
			}
			return "viewInstitutionDetails";
			//return "viewCourses";
	}
	
	@RequestMapping(params="operation=viewInstitutionDetails")
	public String viewInstitutionDetails(@RequestParam("institutionId") String institutionId, Model model){
		Institution institution = null;
		if(institutionId!=null&&!institutionId.isEmpty()){
			institution = institutionService.getInstitutionById(institutionId);
		}
		
		model.addAttribute("institution", institution);
		model.addAttribute("tabIndex","1");
		model.addAttribute("role","ADMIN");
		model.addAttribute("institutionId",institutionId);
		if(institution != null){
			model.addAttribute("institutionName",institution.getName());
		}
		return "viewInstitutionDetails";
	}
	
	@RequestMapping(params="operation=viewCourseDetails")
	public String viewCourseDetails(@RequestParam("courseId") String courseId, Model model){
		TransferCourse transferCourse = null;
		if(courseId!=null && !courseId.isEmpty()){
			transferCourse = courseMgmtService.getTransferCourseById(courseId);
		}
		model.addAttribute("transferCourse", transferCourse);
		model.addAttribute("gcuCourseLevelList",institutionTranscriptKeyService.getAllGcuCourseLevel());
		model.addAttribute("tabIndex","7");
		model.addAttribute("role","ADMIN");
		if(transferCourse!=null){
			model.addAttribute("institution",transferCourse.getInstitution());
			model.addAttribute("institutionId",transferCourse.getInstitution().getId());
			model.addAttribute("institutionName",transferCourse.getInstitution().getName());
			model.addAttribute("transferCourseId",courseId);
			model.addAttribute( "transferCourseName",transferCourse.getTrCourseTitle());
		}
		//return "viewCourseDetails";
		return "viewInstitutionDetails";
	}
	
	@RequestMapping(params= "operation=createNewInstitution")
	public String createNewInstitution(@RequestParam(value="institutionId", required=false) String institutionId, Model model){
		if(institutionId!=null && !institutionId.isEmpty()){
			Institution institution = institutionService.getInstitutionById(institutionId);
			model.addAttribute("institution", institution);
		}
		model.addAttribute("institutionTypeList",institutionTermTypeService.getAllInstitutionType());
		model.addAttribute("countryList",institutionTermTypeService.getAllCountry());
		return "editInstitution";
	}
	
	@RequestMapping(params= "operation=saveInstitution")
	public String saveInstitution(Institution institution, Model model){
		
		institution.setEvaluationStatus("EVALUATED");
		institutionService.addInstitution(institution);
		
		model.addAttribute("institution", institution);
		model.addAttribute("institutionTypeList",institutionTermTypeService.getAllInstitutionType());
		model.addAttribute("countryList",institutionTermTypeService.getAllCountry());
		return "editInstitution";
	}
	
	@RequestMapping(params="operation=manageAccreditingBody" )
	public String manageAccreditingBody(@RequestParam("institutionId") String institutionId, Model model ){	
		List<AccreditingBodyInstitute> accreditingBodyList = accreditingBodyInstituteService.getAllAccreditingBodyInstitute(institutionId);
		Institution institution = institutionService.getInstitutionById(institutionId);
		model.addAttribute( "accreditingBodyList",accreditingBodyList);
		model.addAttribute("institution", institution);
		model.addAttribute("institutionId",institutionId);
		model.addAttribute("institutionName", institution.getName());
		model.addAttribute("role","ADMIN");
		model.addAttribute("tabIndex","2");
		return "viewInstitutionDetails";
		//return "ieManageAccreditingBody";
	}
	
	@RequestMapping(params="operation=manageInstitutionTermType")
	public String manageInstitutionTermType(@RequestParam("institutionId") String institutionId, Model model ){	
		List<InstitutionTermType> institutionTermTypeList = institutionTermTypeService.getAllInstitutionTermType(institutionId);
		Institution institution = institutionService.getInstitutionById(institutionId);
		model.addAttribute("institution", institution);
		model.addAttribute("institutionName", institution.getName());
		model.addAttribute( "institutionTermTypeList",institutionTermTypeList);
		model.addAttribute("institutionId",institutionId);
		model.addAttribute("role","ADMIN");
		model.addAttribute("tabIndex","3");
		return "viewInstitutionDetails";
		//return "ieManageInstitutionTermType";
	}
	
	@RequestMapping(params="operation=manageInstitutionTranscriptKey" )
	public String manageInstitutionTranscriptKey(@RequestParam("institutionId") String institutionId, Model model ){	
		List<InstitutionTranscriptKey> institutionTranscriptKeyList = institutionTranscriptKeyService.getAllInstitutionTranscriptKey(institutionId);
		Institution institution = institutionService.getInstitutionById(institutionId);
		model.addAttribute("institution", institution);
		model.addAttribute("institutionName", institution.getName());
		model.addAttribute( "institutionTranscriptKeyList",institutionTranscriptKeyList);
		model.addAttribute("institutionId",institutionId);
		model.addAttribute("role","ADMIN");
		model.addAttribute("tabIndex","4");
		return "viewInstitutionDetails";
		//return "ieManageInstitutionTranscriptKey";
	}
	
	@RequestMapping(params="operation=manageArticulationAgreement" )
	public String manageArticulationAgreement(@RequestParam("institutionId") String institutionId, Model model ){	
		List<ArticulationAgreement> articulationAgreementList = articulationAgreementService.getAllArticulationAgreement(institutionId);
		Institution institution = institutionService.getInstitutionById(institutionId);
		model.addAttribute("institution", institution);
		model.addAttribute("institutionName", institution.getName());
		model.addAttribute( "articulationAgreementList",articulationAgreementList);
		model.addAttribute("institutionId",institutionId);
		model.addAttribute("role","ADMIN");
		model.addAttribute("tabIndex","5");
		return "viewInstitutionDetails";
		//return "ieManageArticulationAgreement";
	}
	
	@RequestMapping(params="operation=manageCourseRelationship" )
	public String manageCourseRelationship(@RequestParam("transferCourseId") String transferCourseId, Model model ){	
		List<CourseMapping> courseMappingList = courseMgmtService.getCourseMappingByTransferCourseId(transferCourseId);
		TransferCourse transferCourse = null;
		transferCourse = courseMgmtService.getTransferCourseById(transferCourseId);
		
		model.addAttribute( "courseMappingList",courseMappingList);
		model.addAttribute( "transferCourseId",transferCourseId);
		model.addAttribute("role","ADMIN");
		if(transferCourse != null){
			model.addAttribute("institutionId",transferCourse.getInstitution().getId());
			model.addAttribute("institutionName",transferCourse.getInstitution().getName());
			model.addAttribute( "transferCourseName",transferCourse.getTrCourseTitle());
		}
		
		model.addAttribute("tabIndex","8");
		return "viewInstitutionDetails";
		//return "ieManageCourseRelationship";
	}
	
	@RequestMapping(params="operation=manageCourseCtgRelationship" )
	public String manageCourseCtgRelationship(@RequestParam("transferCourseId") String transferCourseId, Model model ){	
		List<CourseCategoryMapping> courseCategoryMappingList = courseMgmtService.getCourseCategoryMappingByTransferCourseId(transferCourseId);
		TransferCourse transferCourse = null;
		transferCourse = courseMgmtService.getTransferCourseById(transferCourseId);
		
		model.addAttribute( "transferCourseId",transferCourseId);
		model.addAttribute( "courseCategoryMappingList",courseCategoryMappingList);
		model.addAttribute("role","ADMIN");
		if(transferCourse != null){
			model.addAttribute("institutionId",transferCourse.getInstitution().getId());
			model.addAttribute("institutionName",transferCourse.getInstitution().getName());
			model.addAttribute( "transferCourseName",transferCourse.getTrCourseTitle());
		}
		
		model.addAttribute("tabIndex","9");
		return "viewInstitutionDetails";
		//return "ieManageCourseCtgRelationship";
	}
	
	@RequestMapping(params="operation=manageCourseTitles")
	public String manageCourseTitle(@RequestParam("transferCourseId") String transferCourseId, Model model){
		List<TransferCourseTitle> courseTitleList = transferCourseService.getTransferCourseTitlesByTransferCourseId(transferCourseId);
		TransferCourse transferCourse = null;
		transferCourse = courseMgmtService.getTransferCourseById(transferCourseId);
		
		model.addAttribute("transferCourseId",transferCourseId);
		model.addAttribute("courseTitleList",courseTitleList);
		model.addAttribute("role","ADMIN");
		if(transferCourse != null){
			model.addAttribute("institutionId",transferCourse.getInstitution().getId());
			model.addAttribute("institutionName",transferCourse.getInstitution().getName());
			model.addAttribute( "transferCourseName",transferCourse.getTrCourseTitle());
		}
		
		model.addAttribute("tabIndex","10");
		return "viewInstitutionDetails";
		//return "ieManageCourseTitles";
	}
}
