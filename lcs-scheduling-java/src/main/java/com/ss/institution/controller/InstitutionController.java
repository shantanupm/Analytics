package com.ss.institution.controller;

import java.text.DateFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ss.common.logging.RequestContext;
import com.ss.common.util.Constants;
import com.ss.common.util.UserUtil;
import com.ss.institution.service.AccreditingBodyInstituteService;
import com.ss.institution.service.ArticulationAgreementService;
import com.ss.institution.service.InstitutionService;
import com.ss.institution.service.InstitutionTermTypeService;
import com.ss.institution.service.InstitutionTranscriptKeyService;
import com.ss.institution.value.AccreditingBody;
import com.ss.institution.value.AccreditingBodyInstitute;
import com.ss.institution.value.ArticulationAgreement;
import com.ss.institution.value.ArticulationAgreementDetails;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionTermType;
import com.ss.institution.value.InstitutionTranscriptKey;
import com.ss.institution.value.InstitutionTranscriptKeyDetails;
import com.ss.institution.value.InstitutionType;
import com.ss.institution.value.TermType;
import com.ss.user.value.User;


@Controller
@RequestMapping( "/institution/manageInstitution.html" )
public class InstitutionController {
	
	private static transient Logger log = LoggerFactory.getLogger(InstitutionController.class );
	
	@Autowired
	private InstitutionService institutionService;
	
	@Autowired
	private AccreditingBodyInstituteService accreditingBodyService;
	
	@Autowired 
	private InstitutionTermTypeService institutionTermTypeService;
	
	@Autowired 
	private InstitutionTranscriptKeyService institutionTranscriptKeyService;
	
	@Autowired 
	private ArticulationAgreementService articulationAgreementService;
	
	
	@InitBinder
	public void allowEmptyDateBinding( WebDataBinder binder )
	{
	    // Allow for null values in date fields.
	    binder.registerCustomEditor( Date.class, new CustomDateEditor( Constants.COMMON_DATE_FORMAT, true ));
	    // tell spring to set empty values as null instead of empty string.
	    binder.registerCustomEditor( String.class, new StringTrimmerEditor( true ));
	}
	
	@RequestMapping(params="operation=initParams" )
	public String initInstitution( Model model ){	
		model.addAttribute("institutionList",institutionService.getAllInstitutions());
		model.addAttribute("mode","init");
		return "manageInstitution";
	}
	
	@RequestMapping(params="operation=viewInstitution" )
	public String viewInstitution(@RequestParam("institutionCode") String schoolCode,
			@RequestParam("instituteTitle") String instituteTitle, Model model ){	
		Institution institution =	institutionService.getInstitutionByCodeTitle(schoolCode, instituteTitle);
		model.addAttribute("institution",institution);
		model.addAttribute("institutionList",institutionService.getAllInstitutions());
		return "manageInstitution";
	}
	
	@RequestMapping(params="operation=createInstitution" )
	public String createInstitution(@RequestHeader("Referer") String callingReferer,
			@RequestParam(value="institutionId", required=false) String institutionId,
			Model model ){		
		if(institutionId !=  null){
			Institution institution= institutionService.getInstitutionById(institutionId);
			model.addAttribute("institution",institution);
		//	model.addAttribute("institutionId",institutionId);
			
		}else{
			model.addAttribute("accreditingBodyList",accreditingBodyService.getAllAccreditingBody());
			model.addAttribute("termTypeList",institutionTermTypeService.getAllTermType());
			model.addAttribute("accreditingBodyInstitute",new AccreditingBodyInstitute());
			
		}
		
		model.addAttribute("user",UserUtil.getCurrentUser());
		model.addAttribute("callingReferer",callingReferer);
		model.addAttribute("institutionTypeList",institutionTermTypeService.getAllInstitutionType());
		
		model.addAttribute("countryList",institutionTermTypeService.getAllCountry());
		
		return "createInstitution";
	}
	@RequestMapping(params="operation=validateSchoolCode" )
	@ResponseBody
	public String validateSchoolCode(@RequestParam(value="schoolCode") String schoolCode,
			@RequestParam(value="institutionId")String institutionId,
			Model model ){

		boolean schoolCodeExist=false;
		schoolCodeExist=institutionService.schoolCodeExist(schoolCode, institutionId);
		return String.valueOf(schoolCodeExist);
	}
	
	@RequestMapping(params="operation=validateSchoolTitle" )
	@ResponseBody
	public String validateSchoolTitle(@RequestParam(value="schoolTitle") String schoolTitle,
			@RequestParam(value="institutionId")String institutionId,
			Model model ){
		
		return String.valueOf(institutionService.schoolTitleExist(schoolTitle, institutionId));
	}
	
	
	@RequestMapping(params="operation=saveInstitution")
	public String handleCreateInstitution(Institution institution,AccreditingBodyInstitute accreditingBodyInstitute,
			HttpServletRequest request,@RequestParam(value="callingReferer")String callingReferer,  Model model ){
		boolean addMode=false; 
		
		try {
			if(institution.getId()==null || institution.getId().isEmpty()){
				addMode=true;
			}
			InstitutionType  institutionType=new InstitutionType();
			institutionType.setId((request.getParameter("institutionTypeId")));
			institution.setInstitutionType(institutionType);
			
			//TODO:Avinash: Fix this once the database restructure change is done.
//			Country  country=new Country();
//			country.setId((request.getParameter("countryId")));
//			institution.setCountry(country);
			//end of comment for TODO
			
			//institution.setEvaluationStatus("Not Evaluated");
			User user=  UserUtil.getCurrentUser();
			institution.setCreatedBy(user.getId());
			if(addMode){
				institution.setCreatedBy(user.getId());
				institution.setCreatedDate(new Date());
				institution.setEvaluationStatus("EVALUATED");
			}else{
				institution.setModifiedBy(user.getId());
				if(null!=institution.getEvaluationStatus()){
					if(!institution.getEvaluationStatus().isEmpty() ){
						//Second time Confirmed By (Checker)
						if( institution.getEvaluationStatus().equals("EVALUATED")){
							institution.setConfirmedBy(user.getId());
							institution.setConfirmedDate(new Date());
						}
						//First Time  Checked by (Maker)
						else if(institution.getEvaluationStatus().equals("UnConfirmed")){
							institution.setCheckedBy(user.getId());
							institution.setCheckedDate(new Date());
							
						}
					}
				}
				
			}
			institutionService.addInstitution(institution);
			
			if(addMode){
				DateFormat formatter = Constants.COMMON_DATE_FORMAT;
				String abInstituteId="",termTypeId="",abEffectiveDate="",abEndDate="",ttEffectiveDate="",ttEndDate="";
				abInstituteId=request.getParameter("accreditingBodyInstitute.id");
				termTypeId=request.getParameter("termType.id");
				
				abEffectiveDate=request.getParameter("accreditingBodyInstitute.effectiveDate");
				abEndDate=request.getParameter("accreditingBodyInstitute.endDate");
				ttEffectiveDate=request.getParameter("termType.effectiveDate");
				ttEndDate=request.getParameter("termType.endDate");
				
				if(!abInstituteId.isEmpty()){
					AccreditingBody accreditingBody= new AccreditingBody();
					accreditingBody.setId(abInstituteId);
					AccreditingBodyInstitute ab= new AccreditingBodyInstitute();
					ab.setAccreditingBody(accreditingBody);
					ab.setInstituteId(institution.getId());
					if(!abEffectiveDate.isEmpty())
						//ab.setEffectiveDate(formatter.parse(abEffectiveDate));
						ab.setEffectiveDate(abEffectiveDate);
					if(!abEndDate.isEmpty())
						//ab.setEndDate(formatter.parse(abEndDate));
						ab.setEndDate(abEndDate);
					accreditingBodyService.addAccreditingBodyInstitute(ab);
				}
				
				if(!termTypeId.isEmpty()){
					TermType termType= new TermType();
					termType.setId(termTypeId);
					InstitutionTermType institutionTermType= new InstitutionTermType(); 
					institutionTermType.setTermType(termType);
					institutionTermType.setInstituteId(institution.getId());
					if(!ttEffectiveDate.isEmpty())
						institutionTermType.setEffectiveDate(formatter.parse(ttEffectiveDate));
					if(!ttEndDate.isEmpty())
						institutionTermType.setEndDate(formatter.parse(ttEndDate));
					institutionTermTypeService.addInstitutionTermType(institutionTermType);
				}
			}
		} catch (ParseException e) {
			//log.error( "Exception while parsing  date --- " + e, e );
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Exception while parsing  date --- ."+e+" RequestId:"+uniqueId, e);
			throw new RuntimeException( e );
		}catch(Exception e){
			//log.error( "Exception Adding Institution--- " + e, e );
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Exception Adding Institution---."+e+" RequestId:"+uniqueId, e);
		}
		//Newly filled Institution
		Institution newInstitution= institutionService.getInstitutionById(institution.getId());
		model.addAttribute("institution",newInstitution);
		model.addAttribute("institutionList",institutionService.getAllInstitutions());
		//return "manageInstitution";
		return "redirect:"+callingReferer;
	}
	
	
	@RequestMapping(params="operation=entryInstitution")
	public String entryInstitution( Model model ){
		return "entryInstitution";
	}
	
	@RequestMapping(params="operation=saveEntryInstitution")
	public String editInstitution(Institution institution,@RequestParam("programVersionCode")String programVersionCode,
			@RequestParam("studentCrmId")String studentCrmId, 
			@RequestParam("catalogCode")String catalogCode,@RequestParam("stateCode")String stateCode,
			@RequestParam("expectedStartDate")String expectedStartDate,Model model ){
		
		
		//institution.setEvaluationStatus("Not Evaluated");
		institutionService.addInstitution(institution);
		
		return "redirect:/evaluation/launchEvaluation.html?operation=launchEvaluationHome&programVersionCode="+programVersionCode+
		"&studentCrmId="+studentCrmId+"&catalogCode="+catalogCode+"&stateCode="+stateCode+"&expectedStartDate="+expectedStartDate;
	}

	
	@RequestMapping(params="operation=selectParentInstitution" )
	public String selectParentInstitution(@RequestParam(value="institutionId", required=false, defaultValue="") String institutionId, Model model ){		
		List<Institution> institutionList = institutionService.getAllInstitutions(institutionId); 
		model.addAttribute( "institutionList", institutionList );
		return "selectParentInstitution";
		
		
	}
	
	@RequestMapping(params="operation=getInstitutionDetails")
	public ModelAndView getPostJsonTree(@RequestParam("institutionId") String institutionId,Model model1){
		Institution institution = institutionService.getInstitutionById(institutionId);
		
		Map<String, Institution> map = new HashMap<String, Institution>();
		map.put(Constants.FLEX_JSON_DATA, institution);
		
		return new ModelAndView(Constants.FLEX_JSON_VIEW, map);
	}
	
	
	
	@RequestMapping(params="operation=manageAccreditingBody" )
	public String manageAccreditingBody(@RequestParam("institutionId") String institutionId, Model model ){	
		List<AccreditingBodyInstitute> accreditingBodyList = accreditingBodyService.getAllAccreditingBodyInstitute(institutionId);
		
		model.addAttribute( "accreditingBodyList",accreditingBodyList);
		model.addAttribute("institutionId",institutionId);
		return "manageAccreditingBody";
	}
	

	@RequestMapping(params="operation=addAccreditingBody" )
	public String addAccreditingBody(@RequestParam("institutionId") String institutionId,
			@RequestParam(value="accreditingBodyInstId", required=false) String accreditingBodyInstId,
			Model model ){		
		
		if(accreditingBodyInstId !=  null){
			AccreditingBodyInstitute accreditingBodyInstitute= accreditingBodyService.getAccreditingBodyInstitute(accreditingBodyInstId);
			model.addAttribute("accreditingBodyInstitute",accreditingBodyInstitute);
		}
		
		
		
		model.addAttribute("institutionId",institutionId);
		model.addAttribute("accreditingBodyList",accreditingBodyService.getAllAccreditingBody());
		
		return "addAccreditingBody";
	}
	
	@RequestMapping(params="operation=saveAccreditingBody" )
	public String saveAccreditingBody(
			@RequestParam("accreditingBody.id") String accreditingBodyId,
			AccreditingBodyInstitute ab, Model model ){	
		ab.getAccreditingBody().setId(accreditingBodyId);
		accreditingBodyService.addAccreditingBodyInstitute(ab);
		//return "manageAccreditingBody";
		return "redirect:manageInstitution.html?operation=manageAccreditingBody&institutionId="+ab.getInstituteId();
		
	}
	
	
	@RequestMapping(params="operation=manageInstitutionTermType" )
	public String manageInstitutionTermType(@RequestParam("institutionId") String institutionId, Model model ){	
		List<InstitutionTermType> institutionTermTypeList = institutionTermTypeService.getAllInstitutionTermType(institutionId);
		
		model.addAttribute( "institutionTermTypeList",institutionTermTypeList);
		model.addAttribute("institutionId",institutionId);
		return "manageInstitutionTermType";
	}
	

	@RequestMapping(params="operation=addInstitutionTermType" )
	public String addInstitutionTermType(@RequestParam("institutionId") String institutionId,
			@RequestParam(value="institutionTermTypeId", required=false) String institutionTermTypeId,
			Model model ){		
		
		if(institutionTermTypeId !=  null){
			InstitutionTermType InstitutionTermType= institutionTermTypeService.getInstitutionTermType(institutionTermTypeId);
			model.addAttribute("institutionTermType",InstitutionTermType);
		}
		
		
		
		model.addAttribute("institutionId",institutionId);
		model.addAttribute("termTypeList",institutionTermTypeService.getAllTermType());
		
		return "addInstitutionTermType";
	}
	
	@RequestMapping(params="operation=saveInstitutionTermType" )
	public String saveInstitutionTermType(	@RequestParam("termType.id") String termTypeId,
			InstitutionTermType institutionTermType, Model model ){	
		institutionTermType.getTermType().setId(termTypeId);
		institutionTermTypeService.addInstitutionTermType(institutionTermType);
		
		return "redirect:manageInstitution.html?operation=manageInstitutionTermType&institutionId="+institutionTermType.getInstituteId();
		
	}
	
	
	@RequestMapping(params="operation=manageInstitutionTranscriptKey" )
	public String manageInstitutionTranscriptKey(@RequestParam("institutionId") String institutionId, Model model ){	
		List<InstitutionTranscriptKey> institutionTranscriptKeyList = institutionTranscriptKeyService.getAllInstitutionTranscriptKey(institutionId);
		
		model.addAttribute( "institutionTranscriptKeyList",institutionTranscriptKeyList);
		model.addAttribute("institutionId",institutionId);
		return "manageInstitutionTranscriptKey";
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
		model.addAttribute("institutionTranscriptKey", institutionTranscriptKey);
		model.addAttribute("institutionId",institutionId);
		model.addAttribute("gcuCourseLevelList",institutionTranscriptKeyService.getAllGcuCourseLevel());
		
		return "addInstitutionTranscriptKey";
	}
	
	@RequestMapping(params="operation=saveInstitutionTranscriptKey" )
	public String saveInstitutionTranscriptKey(@ModelAttribute("institutionTranscriptKey")InstitutionTranscriptKey institutionTranscriptKey, Model model ){
		institutionTranscriptKeyService.addInstitutionTranscriptKey(institutionTranscriptKey);
		return "redirect:manageInstitution.html?operation=manageInstitutionTranscriptKey&institutionId="+institutionTranscriptKey.getInstitutionId();
		
	}
	
	@RequestMapping(params="operation=manageArticulationAgreement" )
	public String manageArticulationAgreement(@RequestParam("institutionId") String institutionId, Model model ){	
		List<ArticulationAgreement> articulationAgreementList = articulationAgreementService.getAllArticulationAgreement(institutionId);
		
		model.addAttribute( "articulationAgreementList",articulationAgreementList);
		model.addAttribute("institutionId",institutionId);
		return "manageArticulationAgreement";
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
		model.addAttribute("articulationAgreement", articulationAgreement);
		model.addAttribute("institutionId",institutionId);
		model.addAttribute("gcuCourseCategoryList",articulationAgreementService.getAllGcuCourseCategory());
		
		return "addArticulationAgreement";
	}
	
	@RequestMapping(params="operation=saveArticulationAgreement" )
	public String saveArticulationAgreement(@ModelAttribute("articulationAgreement")ArticulationAgreement articulationAgreement, Model model ){
		articulationAgreementService.addArticulationAgreement(articulationAgreement);
		return "redirect:manageInstitution.html?operation=manageArticulationAgreement&institutionId="+articulationAgreement.getInstituteId();
		
	}
	
}
