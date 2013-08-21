package com.ss.course.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.beans.propertyeditors.StringTrimmerEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ss.common.util.Constants;
import com.ss.common.util.UserUtil;
import com.ss.course.service.CourseMgmtService;
import com.ss.course.value.CourseCategoryMapping;
import com.ss.course.value.CourseMapping;
import com.ss.course.value.TransferCourse;
import com.ss.institution.service.InstitutionService;
import com.ss.institution.service.InstitutionTranscriptKeyService;
import com.ss.user.value.User;


@Controller
@RequestMapping( "/course/manageCourse.html" )
public class CourseController {

	@Autowired
	private CourseMgmtService courseMgmtService;
	
	@Autowired 
	private InstitutionTranscriptKeyService institutionTranscriptKeyService;
	
	@Autowired
	private InstitutionService institutionService;
	
	
	@InitBinder
	public void allowEmptyDateBinding( WebDataBinder binder )
	{
	    // Allow for null values in date fields.
	    binder.registerCustomEditor( Date.class, new CustomDateEditor( Constants.COMMON_DATE_FORMAT, true ));
	    // tell spring to set empty values as null instead of empty string.
	    binder.registerCustomEditor( String.class, new StringTrimmerEditor( true ));
	}
	
	
	@RequestMapping(params="operation=initParams" )
	public String initCourse( Model model ){		
		//model.addAttribute("courseList",courseMgmtService.getAllTransferCourse());
		model.addAttribute("mode","init");
		return "manageCourse";
	}
	
	
	@RequestMapping(params="operation=viewCourse" )
	public String viewCourse(@RequestParam("courseCode") String courseCode,
			@RequestParam(value="courseTitle",defaultValue="") String courseTitle, Model model ){	
		TransferCourse transferCourse =	courseMgmtService.getTransferCourseByCodeTitle(courseCode, courseTitle);
		model.addAttribute("courseList",courseMgmtService.getAllTransferCourse());
		model.addAttribute("transferCourse",transferCourse);
		return "manageCourse";
	}
	
	@RequestMapping(params="operation=createCourse" )
	public String createCourse(@RequestHeader("Referer") String callingReferer,
			@RequestParam(value="transferCourseId", required=false) String transferCourseId,
			Model model ){		
		if(transferCourseId !=  null){
			TransferCourse transferCourse= courseMgmtService.getTransferCourseById(transferCourseId);
			model.addAttribute("transferCourse",transferCourse);
			model.addAttribute("transferCourseId",transferCourseId);
			model.addAttribute("institution",institutionService.getInstitutionByCodeTitle(transferCourse.getInstitution().getSchoolcode(), ""));
			
		}
		model.addAttribute("user",UserUtil.getCurrentUser());
		model.addAttribute("institutionList",institutionService.getAllInstitutions());
		model.addAttribute("callingReferer",callingReferer);
		model.addAttribute("gcuCourseLevelList",institutionTranscriptKeyService.getAllGcuCourseLevel());
		return "createCourse";
	}
	
	@RequestMapping(params="operation=saveCourse")
	public String handleCreateCourse(TransferCourse transferCourse,
			@RequestParam(value="callingReferer")String callingReferer, Model model ){
		
		User user=  UserUtil.getCurrentUser();
		//Add Mode
		if(transferCourse.getId()==null || transferCourse.getId().isEmpty()){
			transferCourse.setCreatedBy(user.getId());
			transferCourse.setCreatedDate(new Date());
		}//Edit Mode
		else{
			transferCourse.setModifiedBy(user.getId());
			if(null!=transferCourse.getEvaluationStatus()){
				if(!transferCourse.getEvaluationStatus().isEmpty() ){
					//Second time Confirmed By (Checker)
					if( transferCourse.getEvaluationStatus().equals("Evaluated")){
						transferCourse.setConfirmedBy(user.getId());
						transferCourse.setConfirmedDate(new Date());
					}
					//First Time  Checked by (Maker)
					else if(transferCourse.getEvaluationStatus().equals("UnConfirmed")){
						transferCourse.setCheckedBy(user.getId());
						transferCourse.setCheckedDate(new Date());
						
					}
				}
			}
		}
		courseMgmtService.createCourse(transferCourse);
		
		//return "manageCourse";
		return "redirect:"+callingReferer;
	}
	
	@RequestMapping(params="operation=manageCourseRelationship" )
	public String manageCourseRelationship(@RequestParam("transferCourseId") String transferCourseId, Model model ){	
		List<CourseMapping> courseMappingList = courseMgmtService.getCourseMappingByTransferCourseId(transferCourseId);
		
		model.addAttribute( "courseMappingList",courseMappingList);
		model.addAttribute( "transferCourseId",transferCourseId);
		return "manageCourseRelationship";
	}
	

	@RequestMapping(params="operation=addCourseRelationship" )
	public String addCourseRetationship(@RequestParam("transferCourseId") String transferCourseId,
			@RequestParam(value="courseMappingId", required=false) String courseMappingId,
			Model model ){		
		
		if(courseMappingId !=  null){
			CourseMapping courseMapping= courseMgmtService.getCourseMapping(courseMappingId);
			model.addAttribute("courseMapping",courseMapping);
			model.addAttribute("courseMappingId",courseMappingId);
			
		}
		model.addAttribute("transferCourseId",transferCourseId);
		
		return "addCourseRelationship";
	}
	
	@RequestMapping(params="operation=saveCourseRelationship" )
	public String handleCourseRetationship(CourseMapping courseMapping, Model model ){		
		courseMgmtService.addCourseRelationShip(courseMapping);
		//return "manageCourseRelationship";
		return "redirect:manageCourse.html?operation=manageCourseRelationship&transferCourseId="+courseMapping.getTrCourseId();
		
	}
	
	@RequestMapping(params="operation=manageCourseCtgRelationship" )
	public String manageCourseCtgRelationship(@RequestParam("transferCourseId") String transferCourseId, Model model ){	
		List<CourseCategoryMapping> courseCategoryMappingList = courseMgmtService.getCourseCategoryMappingByTransferCourseId(transferCourseId);
		model.addAttribute( "transferCourseId",transferCourseId);
		model.addAttribute( "courseCategoryMappingList",courseCategoryMappingList);
		return "manageCourseCtgRelationship";
	}
	
	@RequestMapping(params="operation=addCourseCtgRelationship" )
	public String addCourseCtgRelationship(@RequestParam("transferCourseId") String transferCourseId,
			@RequestParam(value="courseCategoryMappingId", required=false) String courseCategoryMappingId,
			Model model ){	
		
		if(courseCategoryMappingId !=  null){
			CourseCategoryMapping courseCategoryMapping= courseMgmtService.getCourseCategoryMapping(courseCategoryMappingId);
			model.addAttribute("courseCategoryMapping",courseCategoryMapping);
			model.addAttribute("courseCategoryMappingId",courseCategoryMappingId);
			
		}
		model.addAttribute( "transferCourseId",transferCourseId);
		return "addCourseCtgRelationship";
	}
	
	@RequestMapping(params="operation=saveCourseCtgRelationship" )
	public String handleCourseCtgRetationship(CourseCategoryMapping courseCategoryMapping, Model model ){		
		courseMgmtService.addCourseCategoryRelationShip(courseCategoryMapping);
		//return "manageCourseCtgRelationship";
		return "redirect:manageCourse.html?operation=manageCourseCtgRelationship&transferCourseId="+courseCategoryMapping.getTrCourseId();
	}
}
