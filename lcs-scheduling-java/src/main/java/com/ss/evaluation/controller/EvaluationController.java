package com.ss.evaluation.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ss.common.logging.RequestContext;
import com.ss.common.util.Constants;
import com.ss.common.util.FlexJsonConfig;
import com.ss.common.util.StudentProgramInfo;
import com.ss.common.util.UserUtil;
import com.ss.course.service.CourseMgmtService;
import com.ss.course.value.CourseCategoryMapping;
import com.ss.course.value.CourseMapping;
import com.ss.course.value.CourseTranscript;
import com.ss.course.value.GCUDegree;
import com.ss.course.value.MilitarySubject;
import com.ss.course.value.TransferCourse;
import com.ss.course.value.TransferCourseTitle;
import com.ss.evaluation.dto.StudentInstitutionTranscriptSummary;
import com.ss.evaluation.enums.TranscriptStatusEnum;
import com.ss.evaluation.service.EvaluationService;
import com.ss.evaluation.service.TranscriptCommentService;
import com.ss.evaluation.service.StudentService;
import com.ss.evaluation.service.StudentServiceException;
import com.ss.evaluation.service.TranscriptService;
import com.ss.evaluation.service.TransferCourseService;
import com.ss.evaluation.util.ServiceExceptionUtils;
import com.ss.evaluation.value.CollegeProgram;
import com.ss.evaluation.value.Student;
import com.ss.evaluation.value.StudentInstitutionDegree;
import com.ss.evaluation.value.StudentInstitutionTranscript;
import com.ss.evaluation.value.StudentProgramEvaluation;
import com.ss.evaluation.value.TranscriptComments;
import com.ss.evaluation.value.StudentTranscriptCourse;
import com.ss.evaluation.value.TranscriptCourseSubject;
import com.ss.institution.service.InstitutionService;
import com.ss.institution.service.InstitutionTermTypeService;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionAddress;
import com.ss.institution.value.InstitutionDegree;
import com.ss.institution.value.InstitutionTermType;
import com.ss.institution.value.InstitutionTranscript;
import com.ss.messaging.service.JMSMessageSenderService;
import com.ss.user.service.UserService;
import com.ss.user.value.User;
/**
 * Controller for operations for evaluating courses.
 * @author binoy.mathew
 */
@Controller
@RequestMapping( "/evaluation/launchEvaluation.html" )
public class EvaluationController {

	private static transient Logger log = LoggerFactory.getLogger( EvaluationController.class );
	
	@Autowired
	private EvaluationService evaluationService;
	
	@Autowired
	private InstitutionService institutionService;
	
	@Autowired
	TransferCourseService transferCourseService;
	
	@Autowired
	TranscriptService transcriptService;
	
	@Autowired
	InstitutionTermTypeService institutionTermTypeService;
	
	@Autowired
	private TranscriptCommentService transcriptCommentService; 
	
	@Autowired
	private StudentService studentService;
	
	@Autowired
	private JMSMessageSenderService jmsSenderService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private CourseMgmtService courseMgmtService;
		
	@InitBinder
	public void allowEmptyDateBinding( WebDataBinder binder )
	{
	    // Allow for null values in date fields.
	    binder.registerCustomEditor( Date.class, new CustomDateEditor(  Constants.COMMON_DATE_FORMAT, true ));
	    // tell spring to set empty values as null instead of empty string.
	    binder.registerCustomEditor( String.class, new StringTrimmerEditor( true ));
	}
	
	
	
	/**
	 * The initial screen for evaluating transcripts for a Data Entry operator.
	 * @param model
	 * @return
	 */
	@RequestMapping( params="operation=initParams" )
	public String initEvaluation( Model model,HttpServletRequest request ){
		if(request.getAttribute("studentCrmId")!=null && !request.getAttribute("studentCrmId").toString().isEmpty()){
			return "redirect:launchEvaluation.html?operation=launchEvaluationHome&studentCrmId="+request.getAttribute("studentCrmId")
			+"&programVersionCode="+request.getAttribute("studentCrmId")+"&catalogCode="+request.getAttribute("catalogCode")
			+"&stateCode="+request.getAttribute("stateCode")+"&expectedStartDate="+request.getAttribute("expectedStartDate");
		}
		User user=UserUtil.getCurrentUser();
		List<StudentInstitutionTranscript> rejectedSitList =  evaluationService.getAllRejectedSITByUser(user);
		List<StudentInstitutionTranscript> rejectedDistinctSitList =  evaluationService.getDistinctRejectedSITByUser(user);
		if(rejectedDistinctSitList != null && !rejectedDistinctSitList.isEmpty()){
			for(StudentInstitutionTranscript sit : rejectedDistinctSitList){
				Student  studentFromDB  = studentService.getStudentById(sit.getStudent().getId());
		 	    Student studentFromCRM = null;
		 	    //we are using INQUIRY ID so we should get only 1 record back.
				try {
					studentFromCRM = getStudentInfoFromCRMbyInquiryId(studentFromDB);
			        //set the student DatabaseId
					studentFromCRM.setId(studentFromDB.getId());
					sit.setStudent(studentFromCRM);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		String userId=user.getId();
		model.addAttribute( "totalTranscript", evaluationService.getTotalTranscripts(userId) );
		model.addAttribute( "lastMonthTranscript", evaluationService.getLastMonthTranscripts(userId));
		model.addAttribute( "last7DaysTranscript", evaluationService.getLast7DaysTranscripts(userId));
		model.addAttribute( "todaysTranscript", evaluationService.getTodaysTranscripts(userId));
		model.addAttribute( "chartValues", evaluationService.getChartValues(userId));
		model.addAttribute("rejectedTranscriptList",rejectedDistinctSitList);
		model.addAttribute("rejectedSitListCount", rejectedSitList!=null?rejectedSitList.size():0);
		return "launchTranscriptEvaluation";
	}
	
	/**
	 * Pop up screen to select some other student while one student is already selected 
	 */
	@RequestMapping(params="operation=newStudent")
	public String newStudent(Model model){
		return "selectAnotherStudent";
	}
	
	/**
	 * The initial screen for evaluating transcripts for a Data Entry operator.
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(params = { "operation=launchEvaluationHome" })
	public String launchEvaluationHome(
			@RequestParam(value = "programVersionCode", required = false) String programVersionCode,
			@RequestParam(value = "deoComment", required = false) String deoComment,
			HttpServletRequest request, Model model) {
		String studentCrmId = request.getParameter("studentCrmId");
		String studentNumber = request.getParameter("studentNumber");
		StudentProgramInfo studentProgramInfo = null;
		String errorMessage ="";
		Student student = new Student();
		student.setCrmId(studentCrmId);
		student.setCampusvueId(studentNumber);
		Boolean hasError = false;
		try {
			Student studentFromCRM = getStudentInfoFromCRMbyInquiryId(student);
			// retrieve the student record for the passed studentCRMId (InquiryId)
			Student studentFromDB = studentService.getStudentByCrmIdFromDB(studentCrmId);
			if (studentFromDB != null) {
				//student record is already in the database so we will update the student record
				//verify if the campusVueId needs to be updated
				String campusVueIdFromCRM =  studentFromCRM.getCampusvueId();
				if(!StringUtils.equalsIgnoreCase(studentFromDB.getCampusvueId(), campusVueIdFromCRM)){
					studentFromDB.setCampusvueId(campusVueIdFromCRM);
					studentFromDB = studentService.createOrUpdateStudentRecord(studentFromDB);
				}
			}else{
				studentFromDB = studentService.createOrUpdateStudentRecord(studentFromCRM);
			}
			studentFromDB.setDemographics(studentFromCRM.getDemographics());
			// retrieve the student program information from the CRM system
 			studentProgramInfo = studentService.getActiveStudentProgramInformation(studentFromDB);
			// get the studentTranscriptInstitutionSummary for a student
			List<StudentInstitutionTranscriptSummary> studentInstTrnstSummaryList = evaluationService.getStudentTranscriptSummary(studentFromDB);
			model.addAttribute("institutionDataAvailable",!studentInstTrnstSummaryList.isEmpty());
			model.addAttribute("transcriptSummaryList",studentInstTrnstSummaryList);
			model.addAttribute("studentProgramInfo", studentProgramInfo);
			/** Added to get list of All countries */
			model.addAttribute("countryList",
					institutionTermTypeService.getAllCountry());
			model.addAttribute("student", studentFromDB);
		} catch (Exception e) {
			errorMessage ="Exception Occured while launchingEvaluation for studentCRMId:" + studentCrmId + " RequestId:" + RequestContext.getRequestIdFromContext();
			log.error(errorMessage,e);
			hasError = true;
			model.addAttribute("student", student);
		}
		model.addAttribute("deoComment", deoComment);
		model.addAttribute("currentUserId", UserUtil.getCurrentUser().getId());
		model.addAttribute("errorMessage",errorMessage);
		model.addAttribute("hasError",hasError);
		return "transcriptList";
	}

	@RequestMapping( params = "operation=getInstitutionDetails" )
	public String getInstitutionDetail( @RequestParam("expectedStartDateString") String expectedStartDateString, 
			@RequestParam( "programVersionCode" ) String programVersionCode,
			@RequestParam( value="transcriptId", required=false ) String studentInstitutionTranscriptId, 
			@RequestParam("redirectValue") String redirectValue,
			StudentProgramInfo courseInfo, HttpServletRequest request, Model model ) {
		
		List<Institution> institutionList = institutionService.getAllInstitutions(); 
		
		//set the expected start date into the object.
		Date expectedStartDate = null;
		try {
			expectedStartDate = new SimpleDateFormat( "MM/dd/yyyy" ).parse( expectedStartDateString );
		} 
		catch( ParseException e ) {
			//log.error( "Exception while parsing expected Start date --- " + e, e );
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Exception while parsing expected Start date ---."+e+" RequestId:"+uniqueId, e);
			throw new RuntimeException( e );
		}		
		courseInfo.setExpectedStartDate( expectedStartDate );

		courseInfo.setStudentCrmId( request.getParameter( "studentCrmId" ) );
		courseInfo.setProgramVersionCode( programVersionCode );
		courseInfo.setCatalogCode( request.getParameter( "catalogCode" ) );
		courseInfo.setStateCode( request.getParameter( "stateCode" ) );
		model.addAttribute( "courseInfo" , courseInfo );
		model.addAttribute( "institutionList", institutionList );
		model.addAttribute("redirectValue",redirectValue);
		
		if( studentInstitutionTranscriptId != null && !"0".equals( studentInstitutionTranscriptId ) ) {
			StudentInstitutionTranscript sit = evaluationService.getStudentInstitutionTranscriptById( studentInstitutionTranscriptId );
			if( sit == null ) {
				throw new RuntimeException( "Transcript does not exist" );
			}
			
			//Build the StudentInstitutionDegree list.
			List<StudentInstitutionDegree> sidList = transcriptService.getStudentInstitutionDegreeListForStudentInstitutionTranscript( studentInstitutionTranscriptId );
			
			model.addAttribute( "studentInstitutionTranscript", sit );
			model.addAttribute( "studentInsDegreeList", sidList );
		}
		/**Added to get list of All countries*/
		model.addAttribute("countryList",institutionTermTypeService.getAllCountry());
		
		return "selectInstitution";
	}
	
	//TODO:Avinash:Are we using this method??
	@RequestMapping( params = "operation=selectInstitution" )
	public String selectInstitution( @RequestParam("expectedStartDateString") String expectedStartDateString,
			@RequestParam("institutionId") String institutionId, StudentProgramEvaluation studentProgramEvaluation, 
			StudentProgramInfo courseInfo,@RequestParam("institutionBoolean") boolean institutionAddBoolean, HttpServletRequest request, Model model ) {
		
		//Check if there is a StudentProgramEvaluation already created for this Student and ProgramVersionCode.
		String studentCrmId = request.getParameter( "studentCrmId" );
		String programVersionCode = request.getParameter( "programVersionCode" );
		StudentProgramEvaluation studentProgramEvaluationEntity = evaluationService.getEvaluationForStudentCrmIdAndProgramCode( studentCrmId, programVersionCode );
		
		if( studentProgramEvaluationEntity != null ) {
			studentProgramEvaluation = studentProgramEvaluationEntity;
			
			 
		}else if(programVersionCode.startsWith("LCS")){
			studentProgramEvaluation.setProgramDescription( "LCS TEST Desc" );
		}
		else {
			//StudentProgramInfo courseInfo2 = evaluationService.getProgramInfoByProgramVersionCode( courseInfo.getProgramVersionCode() );
			//studentProgramEvaluation.setProgramDescription( courseInfo2.getProgramDesc() );
		}
		
		//Build the Institution Degree and Student Institution Degree list.
		List<StudentInstitutionDegree> sids = new ArrayList<StudentInstitutionDegree>();
		
		Institution institution;
		if(institutionAddBoolean){
			institution= new Institution();
			institution.setSchoolcode(request.getParameter("institution.schoolCode"));
			institution.setName(request.getParameter("institution.name"));
			institution.setEvaluationStatus("Not Evaluated");
			institution.setInstitutionType(null);
			institution.setCreatedDate(new Date());
			//TODO:Avinash: Fix this once the database restructure change is done.Institution_Address change
			
//			institution.setCountry(null);
//			
//			institution.setAddress1(request.getParameter("institution.address1"));
//			institution.setAddress2(request.getParameter("institution.address2"));
//			institution.setCity(request.getParameter("institution.city"));
//			institution.setZipcode(request.getParameter("institution.zipcode"));
//			institution.setState(request.getParameter("institution.state"));
//			institution.setPhone(request.getParameter("institution.phone"));
//			if(request.getParameter("institution.country.id")!=null && !"".equals(request.getParameter("institution.country.id")))
//				institution.setCountry(institutionTermTypeService.getCountryById(request.getParameter("institution.country.id")));
			
			//End of the TODO Comment
		}
		else{
			institution = institutionService.getInstitutionById( institutionId );
		}
		//last date of last course for this transcript
		Date ldlc = null;
		
		int count = Integer.parseInt(request.getParameter("noOfRows"));
		for( int i=0; i<count; i++ ) {
			
			//If the degree or GPA or completion date is blank, ignore and continue
			String degree = request.getParameter("insDegree_"+i);
			String degreeDateString = request.getParameter( "degreeDate_" + i );
			String gpaScore = request.getParameter( "GPA_" + i );
			String lastAttendenceDate = request.getParameter("lastAttendenceDate_"+i);
			if( degree == null || "".equals( degree.trim() ) || gpaScore == null || "".equals( gpaScore.trim() ) ) {
				continue;
			}
			
			Date degreeDate = null;
			if( degreeDateString != null && !"".equals( degreeDateString.trim() ) ) {
				//Compare dates to get the Last Date of the last Course
				try {
					degreeDate = new SimpleDateFormat( "MM/dd/yyyy" ).parse( degreeDateString );
				} 
				catch( ParseException e ) {
					//log.error( "Exception while parsing degree date --- " + e, e );
					String uniqueId = RequestContext.getRequestIdFromContext();
					log.error("Exception while parsing degree date ---."+e+" RequestId:"+uniqueId, e);
					throw new RuntimeException( e );
				}
				
				if( ldlc == null ) {
					ldlc = degreeDate;
				}
				else {
					if( degreeDate.after( ldlc ) ) {
						ldlc = degreeDate;
					}
				}
			}
			Date attendenceDate = null;
			if(lastAttendenceDate != null && !"".equals(lastAttendenceDate.trim())){
				try {
					attendenceDate = new SimpleDateFormat( "MM/dd/yyyy" ).parse( lastAttendenceDate );
				} 
				catch( ParseException e ) {
					//log.error( "Exception while parsing degree date --- " + e, e );
					String uniqueId = RequestContext.getRequestIdFromContext();
					log.error("Exception while parsing degree date ---."+e+" RequestId:"+uniqueId, e);
					throw new RuntimeException( e );
				}
			}
			StudentInstitutionDegree sid = new StudentInstitutionDegree();			
			InstitutionDegree inid = institutionService.getInstitutionDegreeByInstituteIDAndDegreeName( institutionId, degree );
			if( inid == null ) {
				inid = new InstitutionDegree();
				inid.setDegree( degree );
				inid.setInstitution( institution );
			}
			sid.setInstitutionDegree( inid );
			sid.setMajor( request.getParameter("major_"+i) );
			sid.setCompletionDate( degreeDate );
			sid.setLastAttendenceDate(attendenceDate);
			
			if( gpaScore != null && !"".equals( gpaScore.trim() ) ) {
				sid.setGpa( Float.parseFloat( gpaScore ) );
			}
			else {
				sid.setGpa( new Float( 0.0 ) );
			}
			
			sids.add( sid );
		}
		
		Date expectedStartDate = null;
		try {
			expectedStartDate = new SimpleDateFormat( "MM/dd/yyyy" ).parse( expectedStartDateString );
		} 
		catch( ParseException e ) {
			//log.error( "Exception while parsing expected Start date --- " + e, e );
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Exception while parsing expected Start date ---."+e+" RequestId:"+uniqueId, e);
			throw new RuntimeException( e );
		}
		courseInfo.setExpectedStartDate( expectedStartDate );
		
		Boolean isTranscriptOfficial = request.getParameter( "transcriptType" ) == null ? 
											null : "1".equals( request.getParameter( "transcriptType" ) ) ? true : false ;
		//Create new SIT.
				StudentInstitutionTranscript sit = new StudentInstitutionTranscript(); 
		evaluationService.createEvaluationForStudent( studentProgramEvaluation, sids, institution, expectedStartDate, ldlc, isTranscriptOfficial, sit );
		
		if(institutionAddBoolean){
			InstitutionTranscript it= new InstitutionTranscript();
			it.setStudentInstitutionTranscriptId(sit.getId());
			it.setInstitutionId(sit.getInstitution().getId());
			institutionService.addInstitutionTranscript(it);
		}
		/*
		courseInfo.setStudentCrmId( request.getParameter( "studentCrmId" ) );
		courseInfo.setProgramVersionCode( request.getParameter( "programVersionCode") );
		courseInfo.setCatalogCode( request.getParameter( "catalogCode" ) );
		courseInfo.setStateCode( request.getParameter( "stateCode" ) );
		
		List<TransferCourse> courseList = evaluationService.getAllTransferCourseBySchoolCode( institution.getSchoolcode() );
		model.addAttribute( "courseList",courseList);
		model.addAttribute( "courseInfo" , courseInfo );		
		model.addAttribute( "selectedInstitution", institution);
		model.addAttribute("studentInstitutionDegreeList",sids);
		
		List<StudentInstitutionTranscript> transcriptList = evaluationService.getStudentInstitutionTranscriptForStudentProgramEval( studentProgramEvaluation );
		model.addAttribute( "transcriptList", transcriptList );
		model.addAttribute( "studentProgramEvaluation", studentProgramEvaluation );
		model.addAttribute( "institutionDataAvailable", true );
		
		return "evaluationHome";
		*/
		
		
		if(request.getParameter("redirectValue").equalsIgnoreCase("0")){
			return "redirect:launchEvaluation.html?operation=getCoursesForStudentTranscript&studentInstitutionTranscriptId="+sit.getId()+"&institutionId="+sit.getInstitution().getId()+"&redirectValue="+request.getParameter("redirectValue");
		}
		else{
			return "redirect:launchEvaluation.html?operation=launchEvaluationHome&programVersionCode="+programVersionCode+"&studentCrmId="+studentCrmId;
		}
	}
	
	
	@RequestMapping(params="operation=getCourseDetails")
	public ModelAndView getPostJsonTree(@RequestParam("trCourseId") String trCourseId,@RequestParam("institutionId") String institutionId,Model model1){
		Map<String,Object> map = new HashMap<String, Object>();
		Map model = new HashMap();
		
		TransferCourse trCourse = transferCourseService.getTransferCourseByCourseCodeAndInstitutionId(trCourseId, institutionId);
		List<MilitarySubject> militarySubjectList = null;
		if(trCourse != null){
			map.put("titleList", transferCourseService.getTransferCourseTitlesByTransferCourseId(trCourse.getId()));
			militarySubjectList = new ArrayList<MilitarySubject>();
			militarySubjectList=transferCourseService.getMilitarySubjectByTransferCourseId(trCourse.getId());
		}
		else{
			map.put("titleList", null);
		}
		map.put("trCourse", trCourse);
		map.put("militarySubjectList", militarySubjectList);
		
		FlexJsonConfig config = new FlexJsonConfig();
		config.setDeepSerialize(true);
		
		model.put(Constants.FLEX_JSON_DATA,map);
		model.put(Constants.FLEX_JSON_CONFIG, config);
		
		return new ModelAndView(Constants.FLEX_JSON_VIEW, model);
		/*TransferCourse trCourse = transferCourseService.getTransferCourseByCourseCodeAndInstitutionId(trCourseId, institutionId);
		
		Map map = new HashMap();
		map.put(Constants.FLEX_JSON_DATA, trCourse);
		
		return new ModelAndView(Constants.FLEX_JSON_VIEW, map); */
	}
	
	
	@RequestMapping( params="operation=getCoursesForStudentTranscript" )
	public String getCoursesForStudentTranscript( @RequestParam("studentInstitutionTranscriptId") String studentInstitutionTranscriptId,
			@RequestParam("institutionId") String institutionId,
			@RequestParam(value="redirectValue",required=false) String redirectValue1,
			Model model, HttpServletRequest request ) {
		
		StudentInstitutionTranscript studentInstitutionTranscript = evaluationService.getStudentInstitutionTranscriptById( studentInstitutionTranscriptId );
		List<StudentTranscriptCourse> studentTranscriptCourseList = transcriptService.getStudentTranscriptCoursesByTranscriptId( studentInstitutionTranscriptId, institutionId );
		Student student = studentInstitutionTranscript.getStudent();
		
		//List<TransferCourse> courseList = evaluationService.getAllTransferCourseByInstitutionId( studentInstitutionTranscript.getInstitution().getId() );
		
		//Set the transient field Course Title into the Student Transcript
		if( studentTranscriptCourseList != null && studentTranscriptCourseList.size() > 0 ) {
			TransferCourseTitle transferCourseTitle = null;
			for( StudentTranscriptCourse studentTranscript : studentTranscriptCourseList ) {
				transferCourseTitle = transferCourseService.getTransferCourseTitleById(studentTranscript.getTransferCourseTitleId());
				if(transferCourseTitle!=null){
					studentTranscript.setTransferCourseTitle(transferCourseTitle);
					studentTranscript.setCourseTitle( transferCourseTitle.getTitle() );
				}
				
			}
		}
		
		//Build the StudentInstitutionDegree list.
		List<StudentInstitutionDegree> sidList = transcriptService.getStudentInstitutionDegreeListForStudentInstitutionTranscript( studentInstitutionTranscriptId );
		
		//Build StudentProgramInfo
		StudentProgramInfo courseInfo =null;
		try {
			courseInfo = studentService.getActiveStudentProgramInformation(studentInstitutionTranscript.getStudent());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		/*courseInfo.setStudentCrmId( studentProgramEvaluation.getStudentId() );
		courseInfo.setProgramVersionCode( studentProgramEvaluation.getProgramVersionCode() );
		courseInfo.setProgramDesc(studentProgramEvaluation.getProgramDescription());
		courseInfo.setCatalogCode( studentProgramEvaluation.getCatalogCode() );
		courseInfo.setStateCode( studentProgramEvaluation.getStateCode() );
		courseInfo.setExpectedStartDate( studentProgramEvaluation.getExpectedStartDate() );
		*/
		//figure out institutionTerm Type : first degree in the list considered for date comparison
		InstitutionTermType institutionTermType = null;
		List<InstitutionTermType> instTermTypeList = institutionTermTypeService.getAllInstitutionTermType(institutionId);
		Date degreeDate = sidList!=null?sidList.get(0).getCompletionDate():null;
		
		for(InstitutionTermType termType : instTermTypeList){
			/*if(termType.getEffectiveDate()!=null && termType.getEndDate()!=null && degreeDate!=null){
			if(degreeDate.after(termType.getEffectiveDate())&&degreeDate.before(termType.getEndDate())){*//**Match the term type which effective date lie between degree completion date *//*
			institutionTermType = termType;
			}
			}*/
			/**Now considering only the currently effective Term Type*/
			if(termType.getEffectiveDate()!=null){
				if(termType.isEffective()){
					institutionTermType = termType;
				}
			}
		}
		
		
		
		model.addAttribute( "courseInfo" , courseInfo );
		//model.addAttribute( "courseList", courseList );
		model.addAttribute( "studentTranscriptCourseList", studentTranscriptCourseList );
		model.addAttribute( "selectedInstitution", studentInstitutionTranscript.getInstitution() );
		model.addAttribute( "studentInstitutionDegreeList", sidList );
		model.addAttribute( "studentInstitutionTranscript", studentInstitutionTranscript );
		//model.addAttribute( "studentProgramEvaluation", studentProgramEvaluation );
		model.addAttribute( "studentProgramEvaluation", "" );
		model.addAttribute("displayTransferCoursesBlock", true);
		
		model.addAttribute("currentUserId", UserUtil.getCurrentUser().getId());
		model.addAttribute("redirectValue1", redirectValue1);
		model.addAttribute("institutionTermType", institutionTermType);
		
		return "evaluationHome";
	}
	
	@RequestMapping( params="operation=saveDraftCourses" )
	@ResponseBody
	public String saveDraftCourses( Model model,HttpServletRequest request ){
		String success = "true";
		
		//Get the Student Institution Transcript
		StudentInstitutionTranscript studentInsTrans = evaluationService.getStudentInstitutionTranscriptById( request.getParameter( "studentInstitutionTranscriptId" ) );
		if( studentInsTrans == null ) {
			throw new RuntimeException( "StudentInstitutionTranscript cound not be found for Id - " +  request.getParameter( "studentInstitutionTranscriptId" ) );
		}
		
		int i = Integer.parseInt(request.getParameter("coursesAdded"));
		log.debug("i = "+i);
		List<StudentTranscriptCourse> studentTranscriptList = new ArrayList<StudentTranscriptCourse>();
		if(i>0){
			//Institution inst = institutionService.getInstitutionForStudentProgramEvaluation(request.getParameter("studentProgramEvaluationId"));
			Institution inst = institutionService.getInstitutionById(request.getParameter("institutionId"));
			String studentProgramEvaluationId = request.getParameter("studentProgramEvaluationId");
			//String studentCrmId = request.getParameter( "studentCrmId" );
			//StudentInstitutionTranscript studentInsTrans = evaluationService.getStudentInstitutionTranscriptForStudentAndInstitution( studentCrmId, inst.getId() );
			for (int j = 0; j < i; j++) {				
				String trCourseId =  request.getParameter("trCourseId_"+j);
				
				Date completionDate = null;
				try {
					completionDate = new SimpleDateFormat( "MM/dd/yyyy" ).parse( request.getParameter( "trCourseCompletionDate_"+j ) );
				} 
				catch( ParseException e ) {
					//log.error( "Exception while parsing completion Date " + e, e );
					String uniqueId = RequestContext.getRequestIdFromContext();
					log.error("Exception while parsing completion Date."+e+" RequestId:"+uniqueId, e);
				}
				
				if(trCourseId!=null && !trCourseId.equals("")){			
					//find the trCourseId in ss_tbl_transfer_course table
					//if not found add new entry with evaluation_status set to 0
					TransferCourse tc = transferCourseService.getTransferCourseByCourseCodeAndInstitutionId(trCourseId, inst.getId());
					TransferCourseTitle tct = new TransferCourseTitle();
					CourseTranscript ct= new CourseTranscript();
					ct.setStudentInstitutionTranscriptId(studentInsTrans.getId());
					if(tc == null){
						tc = new TransferCourse();
						tc.setTrCourseCode(trCourseId);
						tc.setEvaluationStatus("NOT EVALUATED");
						tct.setEvaluationStatus("NOT EVALUATED");
						tc.setInstitution(inst);
						//tc.getInstitution().setSchoolcode(inst.getSchoolcode());
						tct.setTitle(request.getParameter("trCourseTitle_"+j));
						tct.setEffective(true);//setting it to true for defaultly active
						//TODO::setting this to blank in order to use it later.
						tc.setInstitutionDegreeId("");	
						tc.setCreatedDate(new Date());
						tc.setTranscriptCredits(request.getParameter("trCourseCredits_"+j));
						tc.setSemesterCredits(request.getParameter("trSemCredits_"+j));
						transferCourseService.addTransferCourse(tc);	
						
						tct.setTransferCourseId(tc.getId());
						transferCourseService.addTransferCourseTitle(tct);
						
						
						ct.setTrCourseId(tc.getId());
						transferCourseService.addCourseTranscript(ct);
						
					}
					else {
						/**If User changed in any value of TransferCourse Then it must update the same so that the user not get 
						 * confused by difference in value for the same course as when we login with IE we are reading the value
						 *  from StudentTranscriptCourse*/
						//transferCourseService.addTransferCourse(tc);
						tct = transferCourseService.getTransferCourseTitleByDate(completionDate, tc.getId());
						ct.setTrCourseId(tc.getId());
						if(tct==null){
							tct = transferCourseService.getNotEvaluatedTransferCourseTitleByCourseIdAndTitle(tc.getId(), request.getParameter("trCourseTitle_"+j));
						}
						if(tct == null){
							tct = new TransferCourseTitle();
							tct.setEvaluationStatus("Not Evaluated");
							tc.setEvaluationStatus("Not Evaluated");
							tct.setTitle(request.getParameter( "trCourseTitle_"+j ));
							tct.setEffective(true);//setting it to true for defaultly active
							tct.setTransferCourseId(tc.getId());
							transferCourseService.addTransferCourseTitle(tct);
							transferCourseService.addCourseTranscript(ct);
						}
						else{
							if(tct.getEvaluationStatus().equalsIgnoreCase("Not Evaluated")){
								tct.setTitle(request.getParameter( "trCourseTitle_"+j ));
								tct.setEffective(true);//setting it to true for defaultly active
								transferCourseService.addTransferCourseTitle(tct);
								tc.setEvaluationStatus("Not Evaluated");
								transferCourseService.addCourseTranscript(ct);
							}
						}
						
					}
					
					StudentTranscriptCourse st = new StudentTranscriptCourse();
					st.setTrCourseId(trCourseId);
					st.setTransferCourse( tc );
					st.setTransferCourseTitle(tct);
					st.setTransferCourseTitleId(tct.getId());
					String transcriptStatus=request.getParameter( "transcriptStatus_"+j );
					if(transcriptStatus!=null && !transcriptStatus.isEmpty()){
						st.setTranscriptStatus(transcriptStatus);
					}else{
						st.setTranscriptStatus(TranscriptStatusEnum.DRAFT.getValue());
						
					}
					st.setInstitution( inst );
					st.setCourseSequence( j );
					st.setStudentInstitutionTranscript( studentInsTrans );
					
					st.setCompletionDate(completionDate);
					st.setGrade(request.getParameter( "trCourseGrade_"+j ));
					st.setEvaluationStatus("NOT EVALUATED");
					
					float credit=0;
					if(	request.getParameter( "trCourseCredits_"+j)!=null && !request.getParameter( "trCourseCredits_"+j).equals("")){
						credit= Float.parseFloat(request.getParameter( "trCourseCredits_"+j));
					}
					
					float clockHours = 0.0f;
					if(	request.getParameter( "courseHours_"+j ) != null && !request.getParameter( "courseHours_"+j ).equals( "" ) ) {
						clockHours = Float.parseFloat( request.getParameter( "courseHours_" + j ) );
					}					
					//st.setCreditsTransferred(credit);
					//st.setClockHours( clockHours );
					
					st.setCreatedDate(new Date());
					studentTranscriptList.add(st);
				}				
			}
			transcriptService.saveNewDraftTranscriptsForStudentInstitutionTranscript( studentInsTrans, studentTranscriptList );
		}
		
		return "{success:'" + success + "'}";
	}

	
	/**
	 * Updates the Evaluation status of the Transcript (Official / Un-official).
	 * @return
	 */
	@RequestMapping( params="operation=updateTranscriptStatus" )
	@ResponseBody
	public String updateTranscriptEvaluationStatus( @RequestParam( "transcriptId" ) String studentInstitutionTranscriptId, @RequestParam( "official" ) Boolean official ) {
		String success = "true";
		
		StudentInstitutionTranscript studentInstitutionTranscript = evaluationService.getStudentInstitutionTranscriptById(studentInstitutionTranscriptId );
		if( studentInstitutionTranscript == null ) {
			throw new RuntimeException( "The Transcript could not be found for Id " + studentInstitutionTranscriptId );
		}
		
		studentInstitutionTranscript.setOfficial( official );
		evaluationService.saveStudentInstitutionTranscript( studentInstitutionTranscript );
		
		return "{success:'" + success + "'}";
	}
	
	
	@RequestMapping( params="operation=markTranscriptComplete" )
	public String markTranscriptComplete( @RequestParam("studentInstitutionTranscriptId") String studentInstitutionTranscriptId, Model model, HttpServletRequest request ) {

		
		//Get the Student Institution Transcript
		StudentInstitutionTranscript studentInsTrans = evaluationService.getStudentInstitutionTranscriptById( studentInstitutionTranscriptId );
		
		
		if( studentInsTrans == null ) {
			throw new RuntimeException( "StudentInstitutionTranscript cound not be found for Id - " + studentInstitutionTranscriptId );
		}
				
		int coursesAdded = Integer.parseInt( request.getParameter("coursesAdded") );
		List<StudentTranscriptCourse> studentTranscriptList = new ArrayList<StudentTranscriptCourse>();
		
			if( coursesAdded > 0 ) {
				//Institution inst = institutionService.getInstitutionForStudentProgramEvaluation( request.getParameter("studentProgramEvaluationId") );
				Institution inst = institutionService.getInstitutionById(request.getParameter("institutionId"));
				String studentProgramEvaluationId = request.getParameter( "studentProgramEvaluationId" );
				
				
				
				
				for( int ctr = 0; ctr < coursesAdded; ctr++ ) {
					String trCourseId = request.getParameter( "trCourseId_" + ctr ).trim();
					String courseCompletionDateString = request.getParameter( "trCourseCompletionDate_"+ctr ).trim();
					String courseGrade = request.getParameter( "trCourseGrade_" + ctr ).trim();
					String courseCreditString = request.getParameter( "trCourseCredits_" + ctr ).trim();
					String courseHoursString = "";
					
					Date completionDate = null;
					try {
						completionDate = new SimpleDateFormat( "MM/dd/yyyy" ).parse( request.getParameter( "trCourseCompletionDate_"+ctr ) );
					} 
					catch( ParseException e ) {
						//log.error( "Exception while parsing completion Date " + e, e );
						String uniqueId = RequestContext.getRequestIdFromContext();
						log.error("Exception while parsing completion Date."+e+" RequestId:"+uniqueId, e);
					}
					
					if( ctr == (coursesAdded - 1) && ( "".equals( trCourseId ) && "".equals( courseCompletionDateString ) && "".equals( courseGrade ) 
							&& "".equals( courseCreditString ) && "".equals( courseHoursString ) ) ) {
						continue;
					}
					
					if( "".equals( trCourseId ) ) {
						throw new RuntimeException( "CourseId cannot be left blank" );
					}
					
					/*
					 * find the trCourseId in ss_tbl_transfer_course table
					 * If not found add new entry with evaluation_status set to 0
					 */ 
					TransferCourse tc = transferCourseService.getTransferCourseByCourseCodeAndInstitutionId(trCourseId, inst.getId());
					if( tc == null ) {
						tc = new TransferCourse();
						tc.setTrCourseCode( trCourseId );
						tc.setEvaluationStatus( "NOT EVALUATED" );						
						//tc.setSchoolCode( inst.getSchoolcode() );
						tc.setInstitution(inst);
						tc.setTrCourseTitle( request.getParameter( "trCourseTitle_" + ctr ) );
						//TODO::setting this to blank in order to use it later.
						tc.setInstitutionDegreeId("");						
						transferCourseService.addTransferCourse( tc );
					}
					else {
						if( tc.getEvaluationStatus().equalsIgnoreCase("NOT EVALUATED")){
							tc.setTrCourseTitle( request.getParameter( "trCourseTitle_" + ctr ) );
							transferCourseService.saveTransferCourse( tc );
						}
						
						
					}
					
					StudentTranscriptCourse st = new StudentTranscriptCourse();
					st.setTrCourseId( trCourseId );
					st.setTransferCourse( tc );
					
					TransferCourseTitle tct = transferCourseService.getTransferCourseTitleByDate(completionDate, tc.getId());
					if(tct==null){
						tct = transferCourseService.getNotEvaluatedTransferCourseTitleByCourseIdAndTitle(tc.getId(), request.getParameter("trCourseTitle_"+ctr));
					}
					if(tct==null){
						tct= new TransferCourseTitle();
						tct.setEvaluationStatus("NOT EVALUATED");
						tc.setEvaluationStatus("NOT EVALUATED");
						tct.setTitle(request.getParameter( "trCourseTitle_"+ctr ));
						tct.setTransferCourseId(tc.getId());
					}
					transferCourseService.addTransferCourseTitle(tct);
					st.setTransferCourseTitleId(tct.getId());
					//TODO:Not decided yet
					st.setTranscriptStatus( TranscriptStatusEnum.COMPLETED.getValue() );
					
					st.setInstitution( inst );
					st.setCourseSequence( ctr );
					st.setStudentInstitutionTranscript( studentInsTrans );
					
					st.setCompletionDate( completionDate );
					
					
					if( courseGrade == null || "".equals( courseGrade.trim() ) ) {
						log.error( "Course Grade cannot be null." );
						throw new RuntimeException( "Course Grade cannot be null." ); 
					}
					st.setGrade( courseGrade.trim() );
					
					float credit = 0.0f;
					if(	courseCreditString != null && !courseCreditString.equals( "" ) ) {
						credit = Float.parseFloat( courseCreditString );
					}
					
					float clockHours = 0.0f;
					if(	courseHoursString != null && !courseHoursString.equals( "" ) ) {
						clockHours = Float.parseFloat( courseHoursString );
					}
					
					if( credit == 0.0 ) {
						log.error( "credits cannot be 0 or NULL value." );
						throw new RuntimeException( "credits cannot be a null value or zero" );
					}
					
					if(tc.getEvaluationStatus().equalsIgnoreCase("Evaluated")){
						st.setEvaluationStatus("EVALUATED");
					}else{
						st.setEvaluationStatus("NOT EVALUATED");
					}
					
					
					//st.setCreditsTransferred( credit );
					//st.setClockHours( clockHours );
					
					st.setCreatedDate( new Date() );
					studentTranscriptList.add( st );
				}
				
				transcriptService.saveTranscriptsForStudentInstitutionTranscript( studentInsTrans.getId(), studentTranscriptList );
				
			}
		
		//String programVersionCode = studentInsTrans.getStudent().getProgramVersionCode();
		//String studentCrmId = studentInsTrans.getStudent().getStudentId();
		
			String programVersionCode = "";
			String studentCrmId = "";
		
		//StudentInstitutionTranscript rejectedSit = evaluationService.getOldestREJECTEDSIT();
		if(request.getParameter("redirectValue1").equals("0")){
			return "redirect:launchEvaluation.html?operation=initParams";
		}
		return "redirect:launchEvaluation.html?operation=launchEvaluationHome&programVersionCode="+programVersionCode+"&studentCrmId="+studentCrmId;
	}
	
	
	/**
	 * The initial screen for evaluating transcripts for a LOPES operator.
	 * @param model
	 * @return
	 */
	@RequestMapping( params="operation=initLopesParams" )
	public String initLopesEvaluation( Model model ){
		//Old StudentInstitutionTranscript studentInstitutionTranscript = evaluationService.getStudentInstitutionTranscriptForLOPES();
		StudentInstitutionTranscript studentInstitutionTranscript = evaluationService.getStudentInstitutionTranscriptForLOPES(UserUtil.getCurrentUser().getId());
		
		if(studentInstitutionTranscript!=null){
			List<StudentTranscriptCourse> studentTranscriptCourseList = transcriptService.getStudentTranscriptCoursesByTranscriptId( studentInstitutionTranscript.getId(), studentInstitutionTranscript.getInstitution().getId());
		//	StudentProgramEvaluation studentProgramEvaluation = studentInstitutionTranscript.getStudent();

			//List<TransferCourse> courseList = evaluationService.getAllTransferCourseByInstitutionId( studentInstitutionTranscript.getInstitution().getId() );
			
			//Set the transient field Course Title into the Student Transcript
			if( studentTranscriptCourseList != null && studentTranscriptCourseList.size() > 0 ) {
				TransferCourse transferCourse = null;
				for( StudentTranscriptCourse studentTranscript : studentTranscriptCourseList ) {
					transferCourse = transferCourseService.getTransferCourseByCourseCodeAndInstitutionId(studentTranscript.getTrCourseId(), studentTranscript.getInstitution().getId());
					if(transferCourse!=null)
						studentTranscript.setCourseTitle( transferCourse.getTrCourseTitle() );
				}
			}
			
			//Build the StudentInstitutionDegree list.
			List<StudentInstitutionDegree> sidList = transcriptService.getStudentInstitutionDegreeListForStudentInstitutionTranscript( studentInstitutionTranscript.getId() );
			
			//Build StudentProgramInfo
			StudentProgramInfo courseInfo = new StudentProgramInfo();
			/*courseInfo.setStudentCrmId( studentProgramEvaluation.getStudentId() );
			courseInfo.setProgramVersionCode( studentProgramEvaluation.getProgramVersionCode() );
			courseInfo.setCatalogCode( studentProgramEvaluation.getCatalogCode() );
			courseInfo.setStateCode( studentProgramEvaluation.getStateCode() );
			courseInfo.setExpectedStartDate( studentProgramEvaluation.getExpectedStartDate() );
			courseInfo.setProgramDesc(studentProgramEvaluation.getProgramDescription());
			*/
			//figure out institutionTerm Type : first degree in the list considered for date comparison
			InstitutionTermType institutionTermType = null;
			List<InstitutionTermType> instTermTypeList = institutionTermTypeService.getAllInstitutionTermType(studentInstitutionTranscript.getInstitution().getId());
			Date degreeDate = sidList.get(0).getCompletionDate();
			
			for(InstitutionTermType termType : instTermTypeList){
				if(termType.getEffectiveDate()!=null && termType.getEndDate()!=null){
					if(degreeDate.after(termType.getEffectiveDate())&&degreeDate.before(termType.getEndDate())){
						institutionTermType = termType;
					}
				}
			}
			
			model.addAttribute( "courseInfo" , courseInfo );
		//	model.addAttribute( "courseList", courseList );
			model.addAttribute( "studentTranscriptCourseList", studentTranscriptCourseList );
			model.addAttribute( "selectedInstitution", studentInstitutionTranscript.getInstitution() );
			model.addAttribute( "studentInstitutionDegreeList", sidList );
			model.addAttribute( "studentInstitutionTranscript", studentInstitutionTranscript );
			//model.addAttribute( "studentProgramEvaluation", studentProgramEvaluation );
			model.addAttribute( "studentProgramEvaluation", "" );
			model.addAttribute( "transcriptDataAvailable", true );
			model.addAttribute( "displayTransferCoursesBlock", true );
			model.addAttribute("institutionTermType", institutionTermType);

		}else{
			model.addAttribute( "transcriptDataAvailable", false );
		}
				
		return "launchLopesEvaluation";
	}
	
	@RequestMapping( params="operation=approveSITForLOPE" )
	public String approveSITForLOPE(Model model, @RequestParam("studentInstitutionTranscriptId") String studentInstitutionTranscriptId,@RequestParam(value="courseMappingIdsToMap",required=false) String courseMappingIds, @RequestParam(value="courseCategoryMappingIdsToMap",required=false) String courseCategoryMappingIdsToMap){
		StudentInstitutionTranscript sit = evaluationService.getStudentInstitutionTranscriptById(studentInstitutionTranscriptId);
		sit.setEvaluationStatus(TranscriptStatusEnum.EVALUATEDLOPE.getValue());
		evaluationService.saveStudentInstitutionTranscript(sit);
		
		if(courseMappingIds != null && !courseMappingIds.isEmpty()){
			List<StudentTranscriptCourse> stcList = new ArrayList<StudentTranscriptCourse>();
			String stcWithCourseRelationShip[] = courseMappingIds.split(",");
			for(int index=0;index<stcWithCourseRelationShip.length;index++){
				String relationArray[] = stcWithCourseRelationShip[index].split("<>");
				
				if(relationArray[0] != null && !relationArray[0].isEmpty()){
					StudentTranscriptCourse studentTranscriptCourse = transcriptService.getTranscriptById(relationArray[1]);
					if(studentTranscriptCourse !=null && studentTranscriptCourse.getId() != null && !studentTranscriptCourse.getId().isEmpty()){
						studentTranscriptCourse.setCourseMappingId(relationArray[0]);
						stcList.add(studentTranscriptCourse);
					}
				}
			}
			if(stcList != null && !stcList.isEmpty()){
				transcriptService.saveStudentTranscripts(stcList);
			}
		}
		if(courseCategoryMappingIdsToMap != null && !courseCategoryMappingIdsToMap.isEmpty()){
			List<StudentTranscriptCourse> stcList = new ArrayList<StudentTranscriptCourse>();
			String stcWithCourseRelationShip[] = courseCategoryMappingIdsToMap.split(",");
			for(int index=0;index<stcWithCourseRelationShip.length;index++){
				String relationArray[] = stcWithCourseRelationShip[index].split("<>");
				
				if(relationArray[0] != null && !relationArray[0].isEmpty()){
					StudentTranscriptCourse studentTranscriptCourse = transcriptService.getTranscriptById(relationArray[1]);
					if(studentTranscriptCourse !=null && studentTranscriptCourse.getId() != null && !studentTranscriptCourse.getId().isEmpty()){
						studentTranscriptCourse.setCourseCategoryMappingId(relationArray[0]);
						stcList.add(studentTranscriptCourse);		
					}
				}
			}
			if(stcList != null && !stcList.isEmpty()){
				transcriptService.saveStudentTranscripts(stcList);
			}
		}
		return "redirect:launchEvaluation.html?operation=launchTranscriptForLOPESForEvaluation";
	}
	
	@RequestMapping( params="operation=disapproveSITForLOPE")
	public String disapproveSITFORLOPE(Model model, @RequestParam("studentInstitutionTranscriptId") String studentInstitutionTranscriptId , @RequestParam("errorCourseIds") String errorCourseIds, @RequestParam("errorInInstitution") Boolean errorInInstitution, @RequestParam("comment") String comment){
		StudentInstitutionTranscript sit = evaluationService.getStudentInstitutionTranscriptById(studentInstitutionTranscriptId);
		String[] errorCourseIdArray=null;
		if(errorCourseIds!=null&&!errorCourseIds.isEmpty()){
			errorCourseIdArray = errorCourseIds.split(",");
		
			for(String errorCourseId : errorCourseIdArray){
				StudentTranscriptCourse stc = transcriptService.getTranscriptById(errorCourseId);
				stc.setTranscriptStatus("REJECTED");
				transcriptService.putTranscript(stc);
			}
		}
		//case when the Institution information is also marked as error by lopes
		if(errorInInstitution){
			sit.setEvaluationStatus(TranscriptStatusEnum.REJECTEDINSTITUTION.getValue());
		}
		//case when the not institution but the courses are marked as error
		else if(errorCourseIds!=null){
			sit.setEvaluationStatus(TranscriptStatusEnum.REJECTED.getValue());
		}
		sit.setLopeComment(comment);
		evaluationService.saveStudentInstitutionTranscript(sit);
		
		return "redirect:launchEvaluation.html?operation=initLopesParams";
		
	}
	
	@ResponseBody
	@RequestMapping( params="operation=archiveTranscript")
	public String archiveTranscript(@RequestParam("studentId") String studentId, @RequestParam("institutionId") String institutionId){
		evaluationService.archiveTranscript(studentId,institutionId);
		return "";
	}


	@RequestMapping( params="operation=removeRejectedTranscript" )
	public String removeRejectedTranscript( @RequestParam("studentInstitutionTranscriptId") String studentInstitutionTranscriptId,
			@RequestParam("institutionId") String institutionId,
			Model model, HttpServletRequest request ) {
		
		List<StudentTranscriptCourse> studentTranscriptCourseList = transcriptService.getStudentTranscriptCoursesByTranscriptId( studentInstitutionTranscriptId, institutionId );
		List<StudentTranscriptCourse> newStudentTranscriptCourseList= new ArrayList<StudentTranscriptCourse>();
		for(StudentTranscriptCourse stc:studentTranscriptCourseList){
			if(stc.getTranscriptStatus().equalsIgnoreCase(TranscriptStatusEnum.REJECTED.getValue())){
				newStudentTranscriptCourseList.add(stc);
			}
		}
		
		transcriptService.removeStudentTranscriptCourses(newStudentTranscriptCourseList);
		return "redirect:launchEvaluation.html?operation=getCoursesForStudentTranscript&" +
				"studentInstitutionTranscriptId="+studentInstitutionTranscriptId+"&institutionId="+institutionId+"&redirectValue=0";
		
	}

	@RequestMapping(params="operation=getTransferCourseByInstitutionIdAndString")
	public ModelAndView getTransferCourseByInstitutionIdAndString(@RequestParam("institutionId") String institutionId,
			@RequestParam("courseCode") String courseCode,Model model){
		List<TransferCourse> trCourseList = evaluationService.getTransferCourseByInstitutionIdAndString(institutionId, courseCode);
		
		Map<String, List<TransferCourse>> map = new HashMap<String, List<TransferCourse>>();
		map.put(Constants.FLEX_JSON_DATA, trCourseList);
		
		return new ModelAndView(Constants.FLEX_JSON_VIEW, map);
	}

	/*@RequestMapping( params = "operation=deoComments" )
	public String deoComments(@RequestParam("studentProgramEvaluationId") String studentProgramEvaluationId,
			@RequestParam("programVersionCode") String programVersionCode,
			@RequestParam("studentCrmId") String studentCrmId,Model model ) {
		
		List<StudentProgramEvaluationComment> speCommentList=speCommentService.getSPEComment(studentProgramEvaluationId);
	
		model.addAttribute( "speCommentList" , speCommentList );
		model.addAttribute( "studentProgramEvaluationId" , studentProgramEvaluationId );
		model.addAttribute( "programVersionCode" , programVersionCode );
		model.addAttribute( "studentCrmId" , studentCrmId );
		return "deoComments";
		
	}
	 @RequestMapping( params = "operation=saveDeoComments" )
	public String saveDeoComments(StudentProgramEvaluationComment speComment,
			@RequestParam("programVersionCode") String programVersionCode,
			@RequestParam("studentCrmId") String studentCrmId,  Model model ) {
		speComment.setUserId(UserUtil.getCurrentUser().getId());
		speCommentService.addSPEComment(speComment);
		
		return "redirect:launchEvaluation.html?operation=launchEvaluationHome&programVersionCode="+programVersionCode+"&studentCrmId="+studentCrmId;
		
	}*/
	@RequestMapping( params = "operation=getInstituteName" )
	public String getInstituteName(@RequestParam("state") String state,  Model model ) {
		List<Institution>  institutionsList = institutionService.getInstituteForState(state);
		model.addAttribute("institutionsList",institutionsList);
		return "showInstitueForState";
		
	}
	@RequestMapping( params = "operation=loadDStudentInstitutionDegree" )
	public String loadDStudentInstitutionDegree(@RequestParam("institutionId") String institutionId,@RequestParam("studentId") String studentId,  Model model ) {
		StudentProgramEvaluation studentProgramEvaluation = evaluationService.getEvaluationForStudentByCrmId(studentId);
		
		StudentInstitutionTranscript  studentInstitutionTranscript = evaluationService.getStudentInstitutionTranscriptForStudentAndInstitution(studentId, institutionId);
		
		model.addAttribute("studentInstitutionTranscript",studentInstitutionTranscript);
		return "showInstitueForState";
		
	}
	public Date setTimeToMidnight(Date date) {
	    Calendar calendar = Calendar.getInstance();

	    calendar.setTime( date );
	    calendar.set(Calendar.HOUR_OF_DAY, 0);
	    calendar.set(Calendar.MINUTE, 0);
	    calendar.set(Calendar.SECOND, 0);
	    calendar.set(Calendar.MILLISECOND, 0);

	    return calendar.getTime();
	}
	
	@RequestMapping(params="operation=getInstitutionByTitleAndState")
	public ModelAndView getInstitutionByCodeAndTitle(
			@RequestParam("title") String title,
			@RequestParam("state") String state,Model model){
		List<Institution> institutionList = institutionService.getInstitutionByState(state,title);
		
		Map<String, List<Institution>> map = new HashMap<String, List<Institution>>();
		map.put(Constants.FLEX_JSON_DATA, institutionList);
		
		return new ModelAndView(Constants.FLEX_JSON_VIEW, map);
	}
	@RequestMapping(params="operation=getInstitutionByTitle")
	public ModelAndView getInstitutionByTitle(
			@RequestParam("title") String title,
			Model model){
		Institution institution = institutionService.getInstitutionByTitle(title);
		
		Map<String, Institution> map = new HashMap<String,Institution>();
		map.put(Constants.FLEX_JSON_DATA, institution);
		
		return new ModelAndView(Constants.FLEX_JSON_VIEW, map);
	}
	@RequestMapping( params = "operation=saveDegreesWithCourses" )
	public String saveDegreesWithCourses(@RequestParam("institutionId") String institutionId,@RequestParam("studentId") String studentId,  Model model ) {
		StudentProgramEvaluation studentProgramEvaluation = evaluationService.getEvaluationForStudentByCrmId(studentId);
		
		StudentInstitutionTranscript  studentInstitutionTranscript = evaluationService.getStudentInstitutionTranscriptForStudentAndInstitution(studentId, institutionId);
		
		model.addAttribute("studentInstitutionTranscript",studentInstitutionTranscript);
		return "showInstitueForState";
		
	}
	@RequestMapping( params = "operation=saveTranscriptIntoDraftMode" )
	public String saveTranscriptIntoDraftMode(StudentInstitutionTranscript studentInstitutionTranscript,  @RequestParam(value="expectedStartDateString",required=false) String expectedStartDateString,
			@RequestParam(value="institutionId",required=false) String institutionId, @RequestParam(value="institutionAddressId",required=false) String institutionAddressId, HttpServletRequest request, Model model ) {
		System.out.println("studentInstitutionTranscript="+studentInstitutionTranscript);
		//Check if there is a StudentProgramEvaluation already created for this Student and ProgramVersionCode.
		StudentInstitutionTranscript sitFirst = evaluationService.getStudentInstitutionTranscriptById(studentInstitutionTranscript.getId());
		String studentCrmId = request.getParameter( "studentCrmId" );
		String programVersionCode = request.getParameter( "programVersionCode" );
		Student student = studentService.getStudentByCrmIdFromDB(studentCrmId);
		studentInstitutionTranscript.setStudent(student);
		if(institutionAddressId!=null && !institutionAddressId.equals("")){
			InstitutionAddress  institutionAddress = institutionService.getInstitutionAddress(institutionAddressId);
			studentInstitutionTranscript.setInstitutionAddress(institutionAddress!=null ? institutionAddress : null);
		}
		studentInstitutionTranscript.setCreatedDate(sitFirst.getCreatedDate());
		/*if(programVersionCode.startsWith("LCS")){
			student.setProgramDescription( "LCS TEST Desc" );
		}else {
			//StudentProgramInfo courseInfo2 = evaluationService.getProgramInfoByProgramVersionCode( programVersionCode );// TODO we need to check why we should make it
			student.setProgramDescription( programVersionCode );
		}*/
		
		//Build the Institution Degree and Student Institution Degree list.
		Institution institution = institutionService.getInstitutionById( institutionId );
		
		List<StudentInstitutionDegree> sids = new ArrayList<StudentInstitutionDegree>();
		
		List<StudentInstitutionDegree> studentInstitutionDegreeList = studentInstitutionTranscript.getStudentInstitutionDegreeSet();
		
		
		if(studentInstitutionDegreeList!=null && studentInstitutionDegreeList.size()>0){
			
			for(StudentInstitutionDegree studentInstitutionDegree : studentInstitutionDegreeList){
				
					//If the degree or GPA or completion date is blank, ignore and continue
					
					StudentInstitutionDegree sid = new StudentInstitutionDegree();
					if(studentInstitutionDegree.getInstitutionDegree() !=null){
						InstitutionDegree inid = institutionService.getInstitutionDegreeByInstituteIDAndDegreeName( institutionId, studentInstitutionDegree.getInstitutionDegree().getDegree() );
						if( inid == null ) {
							inid = new InstitutionDegree();
							inid.setDegree( studentInstitutionDegree.getInstitutionDegree().getDegree() );
							inid.setInstitution( institution );
						}
						sid.setInstitutionDegree( inid );
						sid.setMajor( studentInstitutionDegree.getMajor() );
						sid.setCompletionDate( studentInstitutionDegree.getCompletionDate() );
						sid.setGpa( studentInstitutionDegree.getGpa());
						sids.add( sid );			
					
					}
			}
			
		}
		//last date of last course for this transcript
		Date ldlc = null;
		
		Date expectedStartDate = null;
		try {
			if(expectedStartDateString != null && !expectedStartDateString.isEmpty()){
				expectedStartDate = new SimpleDateFormat( "MM/dd/yyyy" ).parse( expectedStartDateString );
			}
		} 
		catch( ParseException e ) {
			//log.error( "Exception while parsing expected Start date --- " + e, e );
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Exception while parsing expected Start date ---."+e+" RequestId:"+uniqueId, e);
			throw new RuntimeException( e );
		}
		
		Boolean isTranscriptOfficial = request.getParameter( "transcriptType" ) == null ? 
											null : "1".equals( request.getParameter( "transcriptType" ) ) ? true : false ;
		/**START LCSCHED-362-FOR PHASE-1 only
		 * */
		studentInstitutionTranscript.setOfficial(false);
		/**END LCSCHED-362
		 * */
		//Create new SIT.
		//StudentInstitutionTranscript sit = new StudentInstitutionTranscript(); 
		//evaluationService.createEvaluationForStudent( studentProgramEvaluation, sids, institution, expectedStartDate, ldlc, isTranscriptOfficial, studentInstitutionTranscript );
		StudentInstitutionTranscript sit =	evaluationService.createTranscriptForStudent( student, sids, institution, expectedStartDate, ldlc, isTranscriptOfficial, studentInstitutionTranscript );
		List<StudentTranscriptCourse> studentTranscriptCourseList = saveCoursesInDraftMode(studentInstitutionTranscript.getStudentTranscriptCourse(), sit);
		
		
		model.addAttribute( "selectedInstitution", institution);
		model.addAttribute("studentInstitutionDegreeList",sids);
		
		List<StudentInstitutionTranscript> transcriptList = evaluationService.getStudentInstitutionTranscriptForStudent( student);
		model.addAttribute( "transcriptList", transcriptList );
		model.addAttribute( "studentProgramEvaluation", student );
		model.addAttribute( "institutionDataAvailable", true );
		
		return "redirect:launchEvaluation.html?operation=getAllCoursesAndDegreesForStudentAndInstitute&studentId="+student.getId()+"&institutionId="+sit.getInstitution().getId()+"&institutionAddressId="+institutionAddressId;
		
		//return "";
	}
	public List<StudentTranscriptCourse> saveCoursesInDraftMode(List<StudentTranscriptCourse> studentTranscriptCourseList,StudentInstitutionTranscript studentInsTrans){
		//Get the Student Institution Transcript
				//StudentInstitutionTranscript studentInsTrans = evaluationService.getStudentInstitutionTranscriptById(sit.getId() );
				if( studentInsTrans == null ) {
					throw new RuntimeException( "StudentInstitutionTranscript cound not be found for Id - " +  studentInsTrans.getId() );
				}
				log.debug("StudentInstitutionTranscript id = "+studentInsTrans.getId());
				List<StudentTranscriptCourse> studentTranscriptList = new ArrayList<StudentTranscriptCourse>();
					Institution inst = institutionService.getInstitutionById(studentInsTrans.getInstitution().getId());
				int j = 0;
				if(studentTranscriptCourseList!=null && studentTranscriptCourseList.size()>0){
					for (StudentTranscriptCourse studentTranscriptCourse : studentTranscriptCourseList) {				
						
						
						if(studentTranscriptCourse.getTrCourseId()!=null  &&  !studentTranscriptCourse.getTrCourseId().equals("") && (!studentTranscriptCourse.isMarkCompleted() ||(studentTranscriptCourse.isMarkCompleted() && studentTranscriptCourse.getEvaluationStatus().equalsIgnoreCase(TranscriptStatusEnum.EVALUATED.getValue())))){			
							//find the trCourseId in ss_tbl_transfer_course table
							//if not found add new entry with evaluation_status set to 0
							TransferCourse tc = transferCourseService.getTransferCourseByCourseCodeAndInstitutionId(studentTranscriptCourse.getTrCourseId(), inst.getId());
							TransferCourseTitle tct = new TransferCourseTitle();
							CourseTranscript ct= new CourseTranscript();
							ct.setStudentInstitutionTranscriptId(studentInsTrans.getId());
							if(tc == null){
								tc = new TransferCourse();
								tc.setTrCourseCode(studentTranscriptCourse.getTrCourseId());
								tc.setTrCourseTitle(studentTranscriptCourse.getTransferCourseTitle().getTitle());
								tc.setCreatedBy(UserUtil.getCurrentUser().getId());
								tc.setModifiedBy(UserUtil.getCurrentUser().getId());
								tc.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
								tct.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
								tc.setInstitution(inst);
								//tc.getInstitution().setSchoolcode(inst.getSchoolcode());
								tct.setTitle(studentTranscriptCourse.getTransferCourseTitle().getTitle());
								tct.setEffective(true);//setting it to true for defaultly active
								//TODO::setting this to blank in order to use it later.
								tc.setInstitutionDegreeId("");	
								tc.setCreatedDate(new Date());
								tc.setModifiedDate(new Date());
								tc.setTranscriptCredits(studentTranscriptCourse.getTransferCourse().getTranscriptCredits());
								tc.setSemesterCredits(studentTranscriptCourse.getTransferCourse().getSemesterCredits());
								tc.setClockHours(studentTranscriptCourse.getTransferCourse().getClockHours());
								//transferCourseService.addTransferCourse(tc);	
								TransferCourse tcCheckAgain = courseMgmtService.getTransferCourseByCodeAndInstitution(tc.getTrCourseCode(), tc.getInstitution().getId());
								if(tcCheckAgain == null){
									courseMgmtService.saveTransferCourse(tc);
								}else{
									courseMgmtService.updateTransferCourse(tc);
								}
								
								tct.setTransferCourseId(tc.getId());
								transferCourseService.addTransferCourseTitle(tct);
								
								
								ct.setTrCourseId(tc.getId());
								ct.setModifiedDate(new Date());
								transferCourseService.addCourseTranscript(ct);
								
							}
							else {
								/**If User changed in any value of TransferCourse Then it must update the same so that the user not get confused by difference in value for the same course as when we login with IE we are reading the value from StudentTranscriptCourse*/
								//transferCourseService.addTransferCourse(tc);
								//tct = transferCourseService.getTransferCourseTitleByDate(studentTranscriptCourse.getCompletionDate(), tc.getId());
								ct.setTrCourseId(tc.getId());
								ct.setModifiedDate(new Date());
								//if(tct == null && studentTranscriptCourse.getTransferCourseTitle()!=null && studentTranscriptCourse.getTransferCourseTitle().getTitle()!=null && !studentTranscriptCourse.getTransferCourseTitle().getTitle().equals("")){
								if(studentTranscriptCourse.getTransferCourseTitle().getTitle()!=null && !studentTranscriptCourse.getTransferCourseTitle().getTitle().equals("")){
									/** Just find-out the TransferCourseTitle ir-rsepctive of their evaluation status rather then NOTEVALUATED
									 *  
									tct = transferCourseService.getNotEvaluatedTransferCourseTitleByCourseIdAndTitle(tc.getId(), studentTranscriptCourse.getTransferCourseTitle().getTitle());*/
									tct = transferCourseService.getTransferCourseTitleByCourseIdAndTitle(tc.getId(), studentTranscriptCourse.getTransferCourseTitle().getTitle());
								}
								if(tct == null){
									tct = new TransferCourseTitle();
									tct.setEvaluationStatus(tc.getEvaluationStatus());
									tc.setEvaluationStatus(tc.getEvaluationStatus());
									if(tc.getCreatedBy() != null && !tc.getCreatedBy().isEmpty()){
										tc.setCreatedBy(tc.getCreatedBy());
									}else{
										tc.setCreatedBy(UserUtil.getCurrentUser().getId());
									}
									tc.setModifiedBy(UserUtil.getCurrentUser().getId());
									tct.setTitle(studentTranscriptCourse.getTransferCourseTitle().getTitle());
									List<TransferCourseTitle> tctList = transferCourseService.getTransferCourseTitlesByTransferCourseId(tc.getId());
									if(tctList != null && !tctList.isEmpty()){
										tct.setEffective(false);
									}else{
										tct.setEffective(true);//setting it to true for default active
									}
									tct.setTransferCourseId(tc.getId());
									transferCourseService.addTransferCourseTitle(tct);
									transferCourseService.addCourseTranscript(ct);
								}
								else{
										tct.setTitle(studentTranscriptCourse.getTransferCourseTitle().getTitle());
										transferCourseService.addTransferCourseTitle(tct);
										tc.setEvaluationStatus(tc.getEvaluationStatus());
										transferCourseService.addCourseTranscript(ct);
								}
								
							}
							
							StudentTranscriptCourse st = new StudentTranscriptCourse();
							st.setTrCourseId(studentTranscriptCourse.getTrCourseId());
							
							st.setTransferCourseTitle(tct);
							st.setTransferCourseTitleId(tct.getId());
							String transcriptStatus = studentTranscriptCourse.getTranscriptStatus();
							if(transcriptStatus!=null && !transcriptStatus.isEmpty()){
								st.setTranscriptStatus(transcriptStatus);
							}else{
								st.setTranscriptStatus(TranscriptStatusEnum.PENDINGEVAL.getValue());
								
							}
							j = j + 1;
							st.setInstitution( inst );
							st.setCourseSequence( j );
							//It is the point where we are Pointing Courses to the pre-existing StudentInstitutionTranscript
							st.setStudentInstitutionTranscript( studentInsTrans );
							
							st.setCompletionDate(studentTranscriptCourse.getCompletionDate());
							st.setGrade(studentTranscriptCourse.getGrade());
							/**If suppose we are coming after rectifing the courses and if we changes in course title only then if course title does not exist then we have to mark the course as either  IN-PROGRESS or  
							 * AWAITING-OFFICIAL
							 * */
							if(studentTranscriptCourse.getEvaluationStatus()!=null && !studentTranscriptCourse.getEvaluationStatus().equals("") && !tc.getEvaluationStatus().equalsIgnoreCase(TranscriptStatusEnum.NOTEVALUATED.getValue())){
								st.setEvaluationStatus(studentTranscriptCourse.getEvaluationStatus());
							}else if(studentInsTrans.getOfficial()){
								st.setEvaluationStatus(TranscriptStatusEnum.INPROGRESS.getValue());
							}else{
								if(tc.getEvaluationStatus().equalsIgnoreCase(TranscriptStatusEnum.CONFLICT.getValue())){
									st.setEvaluationStatus(TranscriptStatusEnum.INPROGRESS.getValue());
								}else{
									st.setEvaluationStatus(TranscriptStatusEnum.AWAITINGOFFICIAL.getValue());
								}
							}
							st.setCreatedBy(UserUtil.getCurrentUser().getId());
							st.setModifiedBy(UserUtil.getCurrentUser().getId());
							float credit=0;
							/*if(	studentTranscriptCourse.getTransferCourse().getTranscriptCredits()!=null && !studentTranscriptCourse.getTransferCourse().getTranscriptCredits().equals("")){
								credit= Float.parseFloat(studentTranscriptCourse.getTransferCourse().getTranscriptCredits());
							}*/
							
							
							if(	studentTranscriptCourse.getTransferCourse().getTranscriptCredits()!=null && !studentTranscriptCourse.getTransferCourse().getTranscriptCredits().equals("")){				
								st.setCreditsTransferred(Integer.parseInt(studentTranscriptCourse.getTransferCourse().getTranscriptCredits().trim()));
							}
							//tc.setTranscriptCredits(String.valueOf(credit));
							//tc.setClockHours((int)studentTranscriptCourse.getTransferCourse().getClockHours());
							st.setGrade(studentTranscriptCourse.getGrade());
							st.setClockHours(studentTranscriptCourse.getTransferCourse().getClockHours() );
							
							st.setCreatedDate(new Date());
							st.setTransferCourse( tc );
							courseMgmtService.updateTransferCourse(tc);
							studentTranscriptList.add(st);
						}				
					}
		}	
			transcriptService.saveNewDraftTranscriptsForStudentInstitutionTranscript( studentInsTrans, studentTranscriptList );
			return studentTranscriptList;	
	}
	@RequestMapping( params="operation=markTranscriptToComplete" )
	public String markTranscriptToComplete( StudentInstitutionTranscript studentInstitutionTranscript,
			@RequestParam(value="institutionId",required=false) String institutionId,@RequestParam(value="studentId",required=false) String studentId,@RequestParam(value="markCompleted",required=false) boolean markCompleted, 
			@RequestParam(value="institutionAddressId",required=false) String institutionAddressId,
			@RequestParam(value="transcriptId") String oldStudentInstitutionTranscriptId,
			@RequestParam(value="programVersionCode") String programVersionCode,HttpServletRequest request, Model model  ) {
		
		
			
		
			Student  student  = studentService.getStudentById(studentId);
			studentInstitutionTranscript.setStudent(student);
			studentInstitutionTranscript.setMarkCompleted(markCompleted);
			
			List<StudentTranscriptCourse> studentTranscriptList = new ArrayList<StudentTranscriptCourse>();
			
				Institution inst = institutionService.getInstitutionById(institutionId);
				if(institutionAddressId!=null && !institutionAddressId.equals("")){
					InstitutionAddress  institutionAddress = institutionService.getInstitutionAddress(institutionAddressId);
					studentInstitutionTranscript.setInstitutionAddress(institutionAddress!=null ? institutionAddress : null);
				}
				
				studentInstitutionTranscript.setInstitution(inst);
				
				List<StudentTranscriptCourse> studentTranscriptCourseList = studentInstitutionTranscript.getStudentTranscriptCourse();
				
				
				int j = 0;
				if(studentTranscriptCourseList!=null && studentTranscriptCourseList.size()>0){
					for (StudentTranscriptCourse studentTranscriptCourse : studentTranscriptCourseList) {		
						if(studentTranscriptCourse.getTrCourseId()!=null  &&  !studentTranscriptCourse.getTrCourseId().equals("")){						
						/*
						 * find the trCourseId in ss_tbl_transfer_course table
						 * If not found add new entry with evaluation_status set to 0
						 */ 
						TransferCourse tc = transferCourseService.getTransferCourseByCourseCodeAndInstitutionId(studentTranscriptCourse.getTrCourseId(), inst.getId());
						if( tc == null ) {
							tc = new TransferCourse();
							tc.setTrCourseCode( studentTranscriptCourse.getTrCourseId() );
							tc.setTrCourseTitle(studentTranscriptCourse.getTransferCourseTitle().getTitle());
							tc.setTranscriptCredits(studentTranscriptCourse.getTransferCourse().getTranscriptCredits());
							tc.setSemesterCredits(studentTranscriptCourse.getTransferCourse().getSemesterCredits());
							tc.setEvaluationStatus( TranscriptStatusEnum.NOTEVALUATED.getValue());						
							//tc.setSchoolCode( inst.getSchoolcode() );
							tc.setInstitution(inst);
							tc.setTrCourseTitle( studentTranscriptCourse.getTransferCourseTitle().getTitle() );
							//TODO::setting this to blank in order to use it later.
							tc.setInstitutionDegreeId("");	
							tc.setClockHours((int)studentTranscriptCourse.getTransferCourse().getClockHours());
							//transferCourseService.addTransferCourse( tc );
							TransferCourse tcCheckAgain = courseMgmtService.getTransferCourseByCodeAndInstitution(tc.getTrCourseCode(), tc.getInstitution().getId());
							if(tcCheckAgain == null){
								courseMgmtService.saveTransferCourse(tc);
							}else{
								courseMgmtService.updateTransferCourse(tc);
							}
						}/*
						else {
							if( tc.getEvaluationStatus().equalsIgnoreCase("NOT EVALUATED")){
								tc.setTrCourseTitle( studentTranscriptCourse.getTransferCourseTitle().getTitle() );
								transferCourseService.saveTransferCourse( tc );
							}						
						}*/
						
						//StudentTranscriptCourse st = new StudentTranscriptCourse();
						studentTranscriptCourse.setTrCourseId( studentTranscriptCourse.getTrCourseId()   );
						
						
						TransferCourseTitle tct = transferCourseService.getTransferCourseTitleByDate(studentTranscriptCourse.getCompletionDate(), tc.getId());
						if(tct==null){
							/** Just find-out the TransferCourseTitle ir-rsepctive of their evaluation status rather then NOTEVALUATED
							 *  
							tct = transferCourseService.getNotEvaluatedTransferCourseTitleByCourseIdAndTitle(tc.getId(), studentTranscriptCourse.getTransferCourseTitle().getTitle());*/
							tct = transferCourseService.getTransferCourseTitleByCourseIdAndTitle(tc.getId(), studentTranscriptCourse.getTransferCourseTitle().getTitle());
						}
						if(tct==null){
							tct= new TransferCourseTitle();
							tct.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
							tct.setTitle(studentTranscriptCourse.getTransferCourseTitle().getTitle());
							tct.setTransferCourseId(tc.getId());
							List<TransferCourseTitle> tctList = transferCourseService.getTransferCourseTitlesByTransferCourseId(tc.getId());
							if(tctList != null && !tctList.isEmpty()){
								tct.setEffective(false);
							}else{
								tct.setEffective(true);//setting it to true for default active
							}
							tct.setTransferCourseId(tc.getId());
							transferCourseService.addTransferCourseTitle(tct,tctList!= null && !tctList.isEmpty()?tctList.size():0);
						}
						
						j = j + 1;
						studentTranscriptCourse.setTransferCourseTitleId(tct.getId());
						//TODO:Not decided yet
						String transcriptStatus = studentTranscriptCourse.getTranscriptStatus();
						if(transcriptStatus!=null && !transcriptStatus.isEmpty()){
							studentTranscriptCourse.setTranscriptStatus(transcriptStatus);
						}else{
							studentTranscriptCourse.setTranscriptStatus(TranscriptStatusEnum.PENDINGEVAL.getValue());
							
						}
						studentTranscriptCourse.setInstitution( inst );
						studentTranscriptCourse.setCourseSequence( j );
						studentTranscriptCourse.setStudentInstitutionTranscript( studentInstitutionTranscript );
						
						studentTranscriptCourse.setCompletionDate( studentTranscriptCourse.getCompletionDate() );
						
						
						studentTranscriptCourse.setGrade( studentTranscriptCourse.getGrade());
						
						
						if(tc.getEvaluationStatus().equalsIgnoreCase(TranscriptStatusEnum.EVALUATED.getValue())){
							studentTranscriptCourse.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
						}else{
							//studentTranscriptCourse.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
							if(studentInstitutionTranscript.getOfficial()){
								studentTranscriptCourse.setEvaluationStatus(TranscriptStatusEnum.INPROGRESS.getValue());
							}else{
								studentTranscriptCourse.setEvaluationStatus(TranscriptStatusEnum.AWAITINGOFFICIAL.getValue());
							}
						}
						if(	studentTranscriptCourse.getTransferCourse().getTranscriptCredits()!=null && !studentTranscriptCourse.getTransferCourse().getTranscriptCredits().equals("")){				
							studentTranscriptCourse.setCreditsTransferred(Integer.parseInt(studentTranscriptCourse.getTransferCourse().getTranscriptCredits().trim()));
						}
						studentTranscriptCourse.setClockHours(studentTranscriptCourse.getTransferCourse().getClockHours() );
						//st.setClockHours( clockHours );
						
						studentTranscriptCourse.setCreatedDate(new Date() );
						studentTranscriptCourse.setTransferCourseTitleId(tct.getId());
						studentTranscriptCourse.setTransferCourse( tc );
						studentTranscriptList.add( studentTranscriptCourse );
					}
					}
				}
				List<StudentInstitutionDegree> studentInstitutionDegreeList = studentInstitutionTranscript.getStudentInstitutionDegreeSet();
				if(studentInstitutionDegreeList!=null && studentInstitutionDegreeList.size()>0){
					
					for(StudentInstitutionDegree studentInstitutionDegree : studentInstitutionDegreeList){
						
							//If the degree or GPA or completion date is blank, ignore and continue
							
							StudentInstitutionDegree sid = new StudentInstitutionDegree();
							if(studentInstitutionDegree.getInstitutionDegree() !=null){
								InstitutionDegree inid = institutionService.getInstitutionDegreeByInstituteIDAndDegreeName( institutionId, studentInstitutionDegree.getInstitutionDegree().getDegree() );
								if( inid == null ) {
									inid = new InstitutionDegree();
									inid.setDegree( studentInstitutionDegree.getInstitutionDegree().getDegree() );
									inid.setInstitution( studentInstitutionTranscript.getInstitution() );
								}
								studentInstitutionDegree.setInstitutionDegree( inid );
								studentInstitutionDegree.setMajor( studentInstitutionDegree.getMajor() );
								studentInstitutionDegree.setCompletionDate( studentInstitutionDegree.getCompletionDate() );
								studentInstitutionDegree.setGpa( studentInstitutionDegree.getGpa());
							
							}
					}
					
				}
				CollegeProgram collegeProgram= studentService.getCollegeByPV(programVersionCode);
				if(collegeProgram!=null){
					studentInstitutionTranscript.setCollegeCode(collegeProgram.getCollegeCode());
				}
				transcriptService.saveTranscriptsForStudentInstitutionTranscriptasMarkComplete( studentInstitutionTranscript, studentTranscriptList ,oldStudentInstitutionTranscriptId);
		return "redirect:launchEvaluation.html?operation=getAllCoursesAndDegreesForStudentAndInstitute&studentId="+studentId+"&institutionId="+institutionId+"&institutionAddressId="+institutionAddressId;
	}
	
	@RequestMapping(params="operation=getInstitutionAddresses")
	public String getInstitutionAddresses(@RequestParam("institutionId") String institutionId,
			Model model){
		List<InstitutionAddress> addressList = institutionService.getInstitutionAddresses(institutionId);
		
		Map<String, List<InstitutionAddress>> map = new HashMap<String, List<InstitutionAddress>>();
		map.put(Constants.FLEX_JSON_DATA, addressList);
		
		model.addAttribute("addressList",addressList);
		return "addressList" ;
	}
	@RequestMapping( params="operation=getAllCoursesAndDegreesForStudentAndInstitute" )
	public String getAllCoursesAndDegreesForStudentAndInstitute(@RequestParam("studentId") String studentId,
			@RequestParam("institutionId") String institutionId,@RequestParam(value="institutionAddressId",required=false) String institutionAddressId,
			@RequestParam(value="redirectValue",required=false) String redirectValue1,
			Model model, HttpServletRequest request ) {
		
		Institution institution = institutionService.getInstitutionById(institutionId);
		
		/*if(institution.getInstitutionType()!=null && institution.getInstitutionType().getId().equalsIgnoreCase("5")){//Military Transcripts
			return "redirect:launchEvaluation.html?operation=getAllCoursesAndDegreesForMilitary&studentId="+studentId+
					"&institutionId="+institutionId+"&institutionAddressId="+institutionAddressId;
		}*/
		InstitutionAddress institutionAddress = null;
		List<InstitutionAddress> institutionAddressList = new ArrayList<InstitutionAddress>();		
		
		StudentInstitutionTranscript OldestStudentInstitutionTranscript =  evaluationService.getOldestStudentInstitutionTranscriptForStudentAndInstitute(studentId, institutionId,false);
		if(institutionAddressId!=null && !institutionAddressId.equals("")){
			institutionAddress = institutionService.getInstitutionAddress(institutionAddressId);
			institutionAddressList.add(institutionAddress);
			institution.setAddresses(institutionAddressList);		
		}else{
			institutionAddress = OldestStudentInstitutionTranscript.getInstitutionAddress();
			institutionAddressList.add(institutionAddress);
			institution.setAddresses(institutionAddressList);
		}
		List<StudentTranscriptCourse> draftStudentTranscriptCourseList = transcriptService.getStudentTranscriptCoursesByTranscriptId( OldestStudentInstitutionTranscript.getId(), institutionId );
		
		List<StudentInstitutionTranscript> studentInstitutionTranscriptList =  evaluationService.getStudentInstitutionTranscriptForStudentAndInstitute(studentId, institutionId);
		Collections.sort(studentInstitutionTranscriptList);
		List<InstitutionTermType> instTermTypeList = institutionTermTypeService.getAllInstitutionTermType(institutionId);
		List<StudentTranscriptCourse> rawStudentTranscriptCourseList = new ArrayList<StudentTranscriptCourse>();
		List<StudentTranscriptCourse> actualStudentTranscriptCourseList = new ArrayList<StudentTranscriptCourse>();
		List<StudentTranscriptCourse> tempStudentTranscriptCourseList = new ArrayList<StudentTranscriptCourse>();
		List<StudentInstitutionTranscriptSummary> studentInstitutionTranscriptSummaryList = new ArrayList<StudentInstitutionTranscriptSummary>();
		
		for(StudentInstitutionTranscript studentInstitutionTranscript : studentInstitutionTranscriptList){
			List<StudentTranscriptCourse> completedTranscriptCourseList = new ArrayList<StudentTranscriptCourse>();
			List<StudentTranscriptCourse> studentTranscriptCourseList = transcriptService.getStudentTranscriptCoursesByTranscriptId( studentInstitutionTranscript.getId(), institutionId );
			
			//Comparator<StudentTranscriptCourse> studentTranscriptCourseComparator = null;
			
			
			if(studentTranscriptCourseList!=null){
				Collections.sort(studentTranscriptCourseList,new StudentTranscriptCourse());
				
				for(StudentTranscriptCourse studentTranscriptCourse : studentTranscriptCourseList){
					TransferCourseTitle transferCourseTitle = transferCourseService.getTransferCourseTitleById(studentTranscriptCourse.getTransferCourseTitleId());
					if(studentTranscriptCourse.getTransferCourse() != null && studentTranscriptCourse.getTransferCourse().getId() != null){
						List<TransferCourseTitle>  transferCourseTitleList = transferCourseService.getTransferCourseTitlesByTransferCourseId(studentTranscriptCourse.getTransferCourse().getId());
						studentTranscriptCourse.setTransferCourseTitleList(transferCourseTitleList != null && !transferCourseTitleList.isEmpty()?transferCourseTitleList:null);
					}	
					if(transferCourseTitle!=null){
						studentTranscriptCourse.setTransferCourseTitle(transferCourseTitle);
						studentTranscriptCourse.setCourseTitle(transferCourseTitle.getTitle());
						
					}else{
						studentTranscriptCourse.setCourseTitle(studentTranscriptCourse.getTransferCourseTitleList() != null && !studentTranscriptCourse.getTransferCourseTitleList().isEmpty() ? studentTranscriptCourse.getTransferCourseTitleList().get(0).getTitle() : null);
					}
					InstitutionTermType institutionTermType = null;
					/**START 1-Fill the InstitutionTermType according to the studentTranscriptCourse completion date.
					    LCSCHED-239 Semester Credit calculation on student transcript needs to consider date course was completed*/
					if(instTermTypeList != null && !instTermTypeList.isEmpty()){
						for(InstitutionTermType institutionTermTypes : instTermTypeList){
							if(institutionTermTypes.getEffectiveDate().compareTo(studentTranscriptCourse.getCompletionDate())<0 && ((institutionTermTypes.getEndDate()!=null && institutionTermTypes.getEndDate().compareTo(studentTranscriptCourse.getCompletionDate())>0) || institutionTermTypes.getEndDate()==null)){
								institutionTermType = institutionTermTypes;
							}
						}
					}
					studentTranscriptCourse.setInstitutionTermType(institutionTermType);
					/**START FOR MILITARY TRANSCRIPT*/
					if(institution.getInstitutionType() != null && institution.getInstitutionType().getId().equals("5")){
						List<TranscriptCourseSubject> transcriptCourseSubjectList = transferCourseService.getAllTranscriptCourseSubjectByStudentTranscriptCourseId(studentTranscriptCourse.getId());
						
						if(transcriptCourseSubjectList != null && !transcriptCourseSubjectList.isEmpty()){
							
							for(TranscriptCourseSubject transcriptCourseSubject : transcriptCourseSubjectList){
								 List<MilitarySubject> militarySubjectList = transferCourseService.getMilitarySubjectByTransferCourseId(studentTranscriptCourse.getTransferCourse().getId());
								 if(militarySubjectList != null && !militarySubjectList.isEmpty()){
									 
									 for(MilitarySubject militarySubject : militarySubjectList){
										 if(militarySubject.getId().equals(transcriptCourseSubject.getSubjectId())){
											 transcriptCourseSubject.setMilitarySubject(militarySubject);
										 }
									 }
									 studentTranscriptCourse.setMilitarySubjectList(militarySubjectList);
								 }
							}
							
							studentTranscriptCourse.setTranscriptCourseSubjectList(transcriptCourseSubjectList);
						}
					}
					/**END*/
					if(!studentTranscriptCourse.getTranscriptStatus().equalsIgnoreCase(TranscriptStatusEnum.REJECTED.getValue())){
						rawStudentTranscriptCourseList.add(studentTranscriptCourse);
					}
					studentInstitutionTranscript.setInstitutionAddress(institutionAddress);
					if(studentTranscriptCourse.isMarkCompleted()){
						completedTranscriptCourseList.add(studentTranscriptCourse);
					}
				}
				if(studentInstitutionTranscript.isMarkCompleted()){
					studentInstitutionTranscript.setStudentTranscriptCourse(completedTranscriptCourseList);
				}
			}
			if(studentInstitutionTranscript.isMarkCompleted()){
				StudentInstitutionTranscriptSummary studentInstitutionTranscriptSummary = new StudentInstitutionTranscriptSummary();
				List<StudentInstitutionDegree> sidListOfStudentInstitutionTranscript = transcriptService.getStudentInstitutionDegreeListForStudentTranscriptAndInstitute(studentInstitutionTranscript.getId(), institutionId);
				studentInstitutionTranscript.setStudentInstitutionDegreeSet(sidListOfStudentInstitutionTranscript);
				studentInstitutionTranscript.setUser(userService.getUserByUserId(studentInstitutionTranscript.getCreatedBy()));
				studentInstitutionTranscript.setTranscriptCommentsList(transcriptCommentService.getTranscriptComment(studentInstitutionTranscript.getId()));
				studentInstitutionTranscriptSummary.setStudentInstitutionTranscript(studentInstitutionTranscript);
				studentInstitutionTranscriptSummaryList.add(studentInstitutionTranscriptSummary);
			}
		}
	if(draftStudentTranscriptCourseList != null && !draftStudentTranscriptCourseList.isEmpty()){
		/**START Logic to Display all the Draft Courses i.e. the all Courses to which DEO say Save rather than Mark Complete*/
		actualStudentTranscriptCourseList.addAll(draftStudentTranscriptCourseList);
		
		for(StudentTranscriptCourse studentTranscriptCourse : actualStudentTranscriptCourseList){
			
			TransferCourseTitle transferCourseTitle = transferCourseService.getTransferCourseTitleById(studentTranscriptCourse.getTransferCourseTitleId());
			if(studentTranscriptCourse.getTransferCourse() != null && studentTranscriptCourse.getTransferCourse().getId() != null){
				List<TransferCourseTitle>  transferCourseTitleList = transferCourseService.getTransferCourseTitlesByTransferCourseId(studentTranscriptCourse.getTransferCourse().getId());
				studentTranscriptCourse.setTransferCourseTitleList(transferCourseTitleList != null && !transferCourseTitleList.isEmpty()?transferCourseTitleList:null);
			}	
			if(transferCourseTitle!=null){
				studentTranscriptCourse.setTransferCourseTitle(transferCourseTitle);
				studentTranscriptCourse.setCourseTitle(transferCourseTitle.getTitle());
				
			}else{
				studentTranscriptCourse.setCourseTitle(studentTranscriptCourse.getTransferCourseTitleList() != null && !studentTranscriptCourse.getTransferCourseTitleList().isEmpty() ? studentTranscriptCourse.getTransferCourseTitleList().get(0).getTitle() : null);
			}
			
			InstitutionTermType institutionTermType = null;
			/**START 1-Fill the InstitutionTermType according to the studentTranscriptCourse completion date.
			    LCSCHED-239 Semester Credit calculation on student transcript needs to consider date course was completed*/
			if(instTermTypeList != null && !instTermTypeList.isEmpty()){
				for(InstitutionTermType institutionTermTypes : instTermTypeList){
					if(institutionTermTypes.getEffectiveDate().compareTo(studentTranscriptCourse.getCompletionDate())<0 && ((institutionTermTypes.getEndDate()!=null && institutionTermTypes.getEndDate().compareTo(studentTranscriptCourse.getCompletionDate())>0) || institutionTermTypes.getEndDate()==null)){
						institutionTermType = institutionTermTypes;
					}
				}
			}
			studentTranscriptCourse.setInstitutionTermType(institutionTermType);
		}
		/**END*/
	}else{
		/**START Logic to Display all the Courses to which DEO  Say Mark Complete rather than Save*/
		if(rawStudentTranscriptCourseList!=null && rawStudentTranscriptCourseList.size()>0){
			for(StudentTranscriptCourse studentTranscriptCourse : rawStudentTranscriptCourseList){
				if(studentTranscriptCourse.isMarkCompleted()){
					tempStudentTranscriptCourseList.add(studentTranscriptCourse);
				}
			}
			for(int i=0;i<rawStudentTranscriptCourseList.size(); i++){
				boolean found =false;
				StudentTranscriptCourse studentTranscriptCourse1 = rawStudentTranscriptCourseList.get(i);
				if(tempStudentTranscriptCourseList!=null && tempStudentTranscriptCourseList.size()>0){
					for(int j=0;j<tempStudentTranscriptCourseList.size(); j++){
						
						StudentTranscriptCourse studentTranscriptCourse2 = tempStudentTranscriptCourseList.get(j);
						
						if(studentTranscriptCourse1.getTransferCourse().getTrCourseCode().equals(studentTranscriptCourse2.getTransferCourse().getTrCourseCode()) && 
								studentTranscriptCourse1.getTransferCourse().getId().equals(studentTranscriptCourse2.getTransferCourse().getId()) &&
								studentTranscriptCourse1.getTransferCourseTitleId().equals(studentTranscriptCourse2.getTransferCourseTitleId()) && studentTranscriptCourse1.getCompletionDate().compareTo(studentTranscriptCourse2.getCompletionDate())==0){
							found = true;
							break;
							//actualStudentTranscriptCourseList.add(studentTranscriptCourse1);
						}
						
					}
			 
					 if(!found){
							actualStudentTranscriptCourseList.add(studentTranscriptCourse1);
					 }
				}
			}
			if(tempStudentTranscriptCourseList!=null && tempStudentTranscriptCourseList.size()>0){
				actualStudentTranscriptCourseList.addAll(tempStudentTranscriptCourseList);
			}else{
				actualStudentTranscriptCourseList.addAll(rawStudentTranscriptCourseList);
			}
	 }
		/**END*/
	}	
	//Processing the list of Courses to display only one Course if we have two or more courses with the same CourseCodde  and same completionDate etc...
		List<StudentTranscriptCourse> stdInstTrnstSummaryList = new ArrayList<StudentTranscriptCourse>();
		
		Map<String, List<StudentTranscriptCourse>> institutionStdTranscriptMap = new HashMap<String, List<StudentTranscriptCourse>>();
		if (actualStudentTranscriptCourseList != null && !actualStudentTranscriptCourseList.isEmpty()) {
			
			for (StudentTranscriptCourse stc : actualStudentTranscriptCourseList) {
				/**START FOR MILITARY TRANSCRIPT*/
				if(institution.getInstitutionType() != null && institution.getInstitutionType().getId().equals("5")){
					List<TranscriptCourseSubject> transcriptCourseSubjectList = transferCourseService.getAllTranscriptCourseSubjectByStudentTranscriptCourseId(stc.getId());
					
					if(transcriptCourseSubjectList != null && !transcriptCourseSubjectList.isEmpty()){
						
						for(TranscriptCourseSubject transcriptCourseSubject : transcriptCourseSubjectList){
							 List<MilitarySubject> militarySubjectList = transferCourseService.getMilitarySubjectByTransferCourseId(stc.getTransferCourse().getId());
							 if(militarySubjectList != null && !militarySubjectList.isEmpty()){
								 
								 for(MilitarySubject militarySubject : militarySubjectList){
									 if(militarySubject.getId().equals(transcriptCourseSubject.getSubjectId())){
										 transcriptCourseSubject.setMilitarySubject(militarySubject);
									 }
								 }
								 stc.setMilitarySubjectList(militarySubjectList);
							 }
						}
						stc.setTranscriptCourseSubjectList(transcriptCourseSubjectList);
					}
				}
				/**END*/
				List<StudentTranscriptCourse> stdInstTrnstList = institutionStdTranscriptMap.get(stc.getTrCourseId()+stc.getCompletionDate()+stc.getGrade());
				
				if (stdInstTrnstList == null) {
					stdInstTrnstList = new ArrayList<StudentTranscriptCourse>();
					institutionStdTranscriptMap.put(stc.getTrCourseId()+stc.getCompletionDate()+stc.getGrade(), stdInstTrnstList);
				}
				
				stdInstTrnstList.add(stc);
			}
		}
		for (String courseCodeCompletionDate : institutionStdTranscriptMap.keySet()) {
			stdInstTrnstSummaryList.add(institutionStdTranscriptMap.get(courseCodeCompletionDate).get(0));
		}
		if(stdInstTrnstSummaryList != null && !stdInstTrnstSummaryList.isEmpty() && stdInstTrnstSummaryList.size()>0){
			Collections.sort(stdInstTrnstSummaryList, new StudentTranscriptCourse());
		}
		List<StudentInstitutionDegree> sidList = transcriptService.getStudentInstitutionDegreeListForTranscriptAndInstitute(studentId, institutionId);
		
		//List<TransferCourse> courseList = evaluationService.getAllTransferCourseByInstitutionId( studentInstitutionTranscript.getInstitution().getId() );
		
		//Set the transient field Course Title into the Student Transcript
		/*if( studentTranscriptCourseList != null && studentTranscriptCourseList.size() > 0 ) {
			TransferCourseTitle transferCourseTitle = null;
			for( StudentTranscriptCourse studentTranscript : studentTranscriptCourseList ) {
				transferCourseTitle = transferCourseService.getTransferCourseTitleById(studentTranscript.getTransferCourseTitleId());
				if(transferCourseTitle!=null){
					studentTranscript.setTransferCourseTitle(transferCourseTitle);
					studentTranscript.setCourseTitle( transferCourseTitle.getTitle() );
				}
				
			}
		}*/
		
		//Build the StudentInstitutionDegree list.
		//List<StudentInstitutionDegree> sidList = transcriptService.getStudentInstitutionDegreeListForStudentInstitutionTranscript( studentInstitutionTranscriptId );
		
		//Build StudentProgramInfo
 	    Student  studentFromDB  = studentService.getStudentById(studentId);
 	    Student studentFromCRM = null;
 	    //we are using INQUIRY ID so we should get only 1 record back.
 		StudentProgramInfo courseInfo =null;
		try {
			studentFromCRM = getStudentInfoFromCRMbyInquiryId(studentFromDB);
	        //set the student DatabaseId
			studentFromCRM.setId(studentFromDB.getId());
			courseInfo = studentService.getActiveStudentProgramInformation(studentFromDB);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 
		//figure out institutionTerm Type : first degree in the list considered for date comparison
		/*InstitutionTermType institutionTermType = null;
		List<InstitutionTermType> instTermTypeList = institutionTermTypeService.getAllInstitutionTermType(institutionId);
		//Date degreeDate = sidList!=null?sidList.get(0).getCompletionDate():null;
		
		for(InstitutionTermType termType : instTermTypeList){
			if(termType.getEffectiveDate()!=null && termType.getEndDate()!=null && degreeDate!=null){
			if(degreeDate.after(termType.getEffectiveDate())&&degreeDate.before(termType.getEndDate())){*//**Match the term type which effective date lie between degree completion date *//*
			institutionTermType = termType;
			}
			}
			*//**Now considering only the currently effective Term Type*//*
			if(termType.getEffectiveDate()!=null){
				if(termType.isEffective()){
					institutionTermType = termType;
				}
			}
		}*/
		
		List<GCUDegree> gCUDegreeList = evaluationService.getGCUInsitutionDegree();
		OldestStudentInstitutionTranscript.setTranscriptCommentsList(transcriptCommentService.getTranscriptComment(OldestStudentInstitutionTranscript.getId()));
		
		model.addAttribute( "courseInfo" , courseInfo );
		model.addAttribute( "student", studentFromCRM );
		model.addAttribute( "studentInstitutionTranscript", OldestStudentInstitutionTranscript);		
		model.addAttribute( "studentTranscriptCourseList", stdInstTrnstSummaryList );
		model.addAttribute( "selectedInstitution", institution );
		model.addAttribute( "studentInstitutionDegreeList", sidList );
		model.addAttribute( "studentInstitutionTranscriptSummaryList", studentInstitutionTranscriptSummaryList );
		//model.addAttribute( "studentProgramEvaluation", studentProgramEvaluation );
		model.addAttribute( "studentProgramEvaluation", "" );
		model.addAttribute("displayTransferCoursesBlock", true);
		
		model.addAttribute("currentUserId", UserUtil.getCurrentUser().getId());
		model.addAttribute("redirectValue1", redirectValue1);
		//model.addAttribute("institutionTermType", institutionTermType);
		model.addAttribute("gCUDegreeList", gCUDegreeList);
		if(institution.getInstitutionType()!=null && institution.getInstitutionType().getId().equalsIgnoreCase("5")){//Military Transcripts
			return "evaluationMilitary";
		}else{
			return "evaluationHome";
		}
	}
	
	/**
	 * Makes a search call to the student search operation by Inquiry
	 * The response will always be 1 or zero as InquiryId is a unique Id
	 * @param student
	 * @return
	 * @throws Exception 
	 */
	private Student getStudentInfoFromCRMbyInquiryId(Student student) throws Exception {
		 List<Student> students = studentService.searchStudent(student);
		 if(students.size() >0){
			 return students.get(0);
		 }
 		return student;
	}



	@RequestMapping( params={"operation=saveNewInstitution"} )
	public String saveNewInstitution(InstitutionAddress institutionAddress,
			@RequestParam( "institutionName" ) String institutionName,
			@RequestParam( "studentCrmId" ) String studentCrmId,
			 Model model ) {
		StudentInstitutionTranscript sit=new StudentInstitutionTranscript();
		Institution institution= new Institution();
	
		institution.setName(institutionName);
		//TODO
		institution.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
		institution.setInstitutionType(null);
		institution.setInstitutionAddress(institutionAddress);
		institution.setInstitutionID(institutionService.getProcessedInstitutionCode(institution));
		Institution institutionExit = institutionService.getInstitutionByTitle(institutionName);
		if(institutionExit == null){
			institutionService.saveInstitution(institution);
		}else{
			institutionService.updateInstitution(institution);
		}
		institutionAddress.setInstitutionId(institution.getId());
		institutionService.addInstitutionAddress(institutionAddress);
		
		sit.setInstitution(institution);
		sit.setInstitutionAddress(institutionAddress);
		sit.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
		sit.setStudent(studentService.getStudentByCrmIdFromDB(studentCrmId));
		sit.setOfficial(false);
		evaluationService.saveStudentInstitutionTranscript(sit);
		return "redirect:launchEvaluation.html?operation=launchEvaluationHome&studentCrmId="+studentCrmId;
	}
	@RequestMapping( params={"operation=saveExistingInstitution"} )
	public String saveExistingInstitution(InstitutionAddress institutionAddress,
			@RequestParam( "institutionId" ) String institutionId,
			@RequestParam( "studentCrmId" ) String studentCrmId,
			 Model model ) {
		StudentInstitutionTranscript sit=new StudentInstitutionTranscript();
		if(institutionAddress.getId() ==null||institutionAddress.getId().isEmpty()){
			institutionService.addInstitutionAddress(institutionAddress);
		}
		Institution institution = institutionService.getInstitutionById(institutionId);
		//TODO
		institution.setEvaluationStatus(institution.getEvaluationStatus());
		sit.setInstitution(institution);
		sit.setInstitutionAddress(institutionService.getInstitutionAddress(institutionAddress.getId()));
		sit.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
		sit.setStudent(studentService.getStudentByCrmIdFromDB(studentCrmId));
		sit.setOfficial(false);
		evaluationService.saveStudentInstitutionTranscript(sit);
		return "redirect:launchEvaluation.html?operation=launchEvaluationHome&studentCrmId="+studentCrmId;
	}
	
	/**
	 * Returns response view for student search operation.
	 * @param studentCrmId
	 * @param campusVueId
	 * @param firstName
	 * @param model
	 * @param lastName
	 * @param maidenName
	 * @param dob
	 * @param snn
	 * @param city
	 * @param state
	 * @param request
	 * @return
	 */
	@RequestMapping(params = { "operation=searchStudent" })
	public String searchStudent(@RequestParam("crmId") String studentCrmId,
			@RequestParam(required=false,value="campusVueId") String campusVueId,
			@RequestParam(required=false,value="firstName") String firstName, Model model,
			@RequestParam(required=false,value="lastName") String lastName,
			@RequestParam(required=false,value="maidenName") String maidenName,
			@RequestParam(required=false,value="dob") String dob, @RequestParam(required=false,value="ssn") String snn,
			@RequestParam(required=false,value="city") String city,
			@RequestParam(required=false,value="state") String state, HttpServletRequest request) {
		
		 List<Student> searchResults = new ArrayList<Student>();
         String errorMessage ="An Error has occurred";
         Boolean hasError = false;
		 Student studentSearchDTO = new Student(studentCrmId,campusVueId,firstName,lastName,maidenName,dob,city,state,snn);	 
		try {
			searchResults = studentService.searchStudent(studentSearchDTO);
		} catch (StudentServiceException studentServiceException) {
			errorMessage = ServiceExceptionUtils.translateStudentServiceException(studentServiceException);
			hasError=true;
			log.error("Exception Occurred while searching a student."+errorMessage+"Request ReferenceId:"+RequestContext.getRequestIdFromContext(),studentServiceException);
 		}
		 model.addAttribute("searchCriteria",studentSearchDTO);
		 model.addAttribute("searchResults", searchResults);
		 model.addAttribute("resultsTotal",searchResults.size());
		 model.addAttribute("hasError",hasError);
		 model.addAttribute("errorMessage",errorMessage);
		return "searchResult";
	}
	
	/**
	 * Returns a view that displays all the programs for the studentCrmId that
	 * is passed.
	 * 
	 * @param model
	 * @param studentCrmId
	 * @param request
	 * @return
	 */
	@RequestMapping(params = { "operation=showAllPrograms" })
	public String showAllPrograms(
			Model model,
			@RequestParam(required = false, value = "inquiryId") String studentCrmId,
			HttpServletRequest request) {
		List<StudentProgramInfo> programList = new ArrayList<StudentProgramInfo>();
	    String errorMessage ="An Error has occurred";
	    Boolean hasError = false;
		try {
			Student student = new Student();
			student.setCrmId(studentCrmId);
			programList = studentService
					.getStudentProgramInformation(student);

		} catch (StudentServiceException ex) {
			errorMessage = ServiceExceptionUtils.translateStudentServiceException(ex);
			hasError=true;
			log.error(errorMessage,ex);
		}
		model.addAttribute("studentCrmId", studentCrmId);
		model.addAttribute("programList", programList);
		model.addAttribute("programListSize", programList.size());
		model.addAttribute("hasError",hasError);
		model.addAttribute("errorMessage", errorMessage);
		return "showAllPrograms";
	}
	
	
	
	@RequestMapping(params="operation=institutionInTranscriptExist" )
	@ResponseBody
	public String institutionInTranscriptExist(@RequestParam(value="studentId") String studentId,
			@RequestParam(value="institutionId")String institutionId,
			Model model ){
		
		return String.valueOf(institutionService.institutionInTranscriptExist(studentId, institutionId));
	}
	@RequestMapping( params="operation=launchTranscriptForLOPESForEvaluation" )
	public String launchTranscriptForLOPESForEvaluation( Model model ){		
		List<StudentInstitutionTranscript> sitSummaryListForLopes = new ArrayList<StudentInstitutionTranscript>();
		StudentInstitutionTranscript studentInstitutionTranscript = evaluationService.getStudentInstitutionTranscriptForLOPES(UserUtil.getCurrentUser().getId());
		
		if(studentInstitutionTranscript!=null){
			if(studentInstitutionTranscript.getInstitutionAddress()!=null && !studentInstitutionTranscript.getInstitutionAddress().equals("") && studentInstitutionTranscript.getInstitution() !=null){
				studentInstitutionTranscript.getInstitution().setAddresses(institutionService.getInstitutionAddresses(studentInstitutionTranscript.getInstitution().getId()));
			}
			
			List<StudentInstitutionTranscript> studentInstitutionTranscriptListForLopes = evaluationService.getAllTranscriptForStudentAndInstitute(studentInstitutionTranscript.getStudent().getId(),studentInstitutionTranscript.getInstitution().getId(),false,TranscriptStatusEnum.AWAITINGLOPE.getValue());
			for(StudentInstitutionTranscript sit: studentInstitutionTranscriptListForLopes){
				if (evaluationService.isTranscriptEligibleForLOPESOrSLEForEvaluation(sit)){
					sit.setTranscriptCommentsList(transcriptCommentService.getTranscriptComment(sit.getId()));
					//Adding only the Transcript for which the institute and its all courses are marked as EVALUATED 
					sitSummaryListForLopes.add(sit);
				}
			}
			 //Build the StudentInstitutionDegree list.
			 List<StudentInstitutionDegree> sidList = transcriptService.getStudentInstitutionDegreeListForStudentInstitutionTranscript( studentInstitutionTranscript.getId() );
			
			//Build StudentProgramInfo
			 Student  studentFromDB  = studentService.getStudentById(studentInstitutionTranscript.getStudent().getId());
		 	 Student studentFromCRM = null;
		 	 //we are using INQUIRY ID so we should get only 1 record back.
		 	 StudentProgramInfo courseInfo =null;
			 try {
					studentFromCRM = getStudentInfoFromCRMbyInquiryId(studentFromDB);
			        //set the student DatabaseId
					studentFromCRM.setId(studentFromDB.getId());
					courseInfo = studentService.getActiveStudentProgramInformation(studentFromDB);
			} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
			}			
			 for(StudentInstitutionTranscript sit: sitSummaryListForLopes){
				 if(sit.getStudentTranscriptCourse()!=null && sit.getStudentTranscriptCourse().size()>0){
					 for(StudentTranscriptCourse stc: sit.getStudentTranscriptCourse()){
						 List<CourseMapping> courseMappingList = courseMgmtService.getCourseMappingByTransferCourseId(stc.getTransferCourse().getId());
						 if(courseMappingList != null && !courseMappingList.isEmpty()){
							 stc.setCourseMappingList(courseMappingList);
						 }else{
							 List<CourseCategoryMapping> courseCategoryMappingList = courseMgmtService.getCourseCategoryMappingByTransferCourseId(stc.getTransferCourse().getId());
							 if(courseCategoryMappingList != null && !courseCategoryMappingList.isEmpty()){
								 stc.setCourseCategoryMappingList(courseCategoryMappingList);
							 }
						 }
					 }
					 
				 }
			 }	 
			studentInstitutionTranscript.setTranscriptCommentsList(transcriptCommentService.getTranscriptComment(studentInstitutionTranscript.getId()));
			
			 model.addAttribute( "courseInfo" , courseInfo );
			 model.addAttribute( "student", studentFromCRM );
			 model.addAttribute( "selectedInstitution", studentInstitutionTranscript.getInstitution() );
			 model.addAttribute( "studentInstitutionDegreeList", sidList );
			 model.addAttribute( "studentInstitutionTranscript", studentInstitutionTranscript );
			 //model.addAttribute( "studentProgramEvaluation", studentProgramEvaluation );
			 model.addAttribute( "studentProgramEvaluation", "" );
			 model.addAttribute( "displayTransferCoursesBlock", true );
			 model.addAttribute("sitSummaryListForSLE", sitSummaryListForLopes);
			 boolean transcriptCourseFound = false;
			 for(StudentInstitutionTranscript sit: sitSummaryListForLopes){
				 if(sit.getStudentTranscriptCourse()!=null && sit.getStudentTranscriptCourse().size()>0){
					 transcriptCourseFound = true;
					 break;
				 }
			 }
			 if(!transcriptCourseFound){
				 model.addAttribute( "transcriptDataAvailable", false );
			 }else{
				 model.addAttribute( "transcriptDataAvailable", true );
			 }		
		}else{
			model.addAttribute( "transcriptDataAvailable", false );
		}
		return "launchTranscriptForSLEAndLOPES";
	}
	
	@RequestMapping( params="operation=loadRejectedTranscript" )
	public String loadRejectedTranscript(String studentId,String instituteId,Model model ){
		InstitutionAddress institutionAddress = null;
		List<StudentInstitutionTranscript> sitRejectedList = evaluationService.getAllRejectedSITByUserForStudentAndInstitute(studentId,instituteId,UserUtil.getCurrentUser());
		if(sitRejectedList!=null && sitRejectedList.size()>0){
			for(StudentInstitutionTranscript studentInstitutionTranscript : sitRejectedList){
				List<StudentTranscriptCourse> studentTranscriptCourseList = transcriptService.getStudentTranscriptCoursesByTranscriptId( studentInstitutionTranscript.getId(), instituteId );
				
				if(studentTranscriptCourseList!=null){
					for(StudentTranscriptCourse studentTranscriptCourse : studentTranscriptCourseList){
						TransferCourseTitle transferCourseTitle = transferCourseService.getTransferCourseTitleById(studentTranscriptCourse.getTransferCourseTitleId());
						if(transferCourseTitle!=null){
							studentTranscriptCourse.setTransferCourseTitle(transferCourseTitle);
							studentTranscriptCourse.setCourseTitle( transferCourseTitle.getTitle() );
						}
					}
				}
				studentInstitutionTranscript.setStudentTranscriptCourse(studentTranscriptCourseList);
				institutionAddress = studentInstitutionTranscript.getInstitutionAddress();
			}
			
		}
		Institution institution = institutionService.getInstitutionById(instituteId);
		institution.setInstitutionAddress(institutionAddress);
		List<StudentInstitutionDegree> sidList = transcriptService.getStudentInstitutionDegreeListForTranscriptAndInstitute(studentId, instituteId);
		Student  student  = studentService.getStudentById(studentId);

		StudentProgramInfo courseInfo = studentService.getActiveStudentProgramInformation(student);
		//figure out institutionTerm Type : first degree in the list considered for date comparison
		InstitutionTermType institutionTermType = null;
		List<InstitutionTermType> instTermTypeList = institutionTermTypeService.getAllInstitutionTermType(instituteId);
		for(InstitutionTermType termType : instTermTypeList){
			/**Now considering only the currently effective Term Type*/
			if(termType.getEffectiveDate()!=null){
				if(termType.isEffective()){
					institutionTermType = termType;
				}
			}
		}
		
		model.addAttribute( "courseInfo" , courseInfo );
		model.addAttribute( "selectedInstitution", institution );
		model.addAttribute( "studentInstitutionDegreeList", sidList );
		model.addAttribute( "sitRejectedList", sitRejectedList );
		model.addAttribute( "studentId", studentId );
		model.addAttribute( "studentProgramEvaluation", "" );
		model.addAttribute("displayTransferCoursesBlock", true);
		
		model.addAttribute("currentUserId", UserUtil.getCurrentUser().getId());
		model.addAttribute("institutionTermType", institutionTermType);
		return "rejectedTrascriptForEvaluation";
	}
	
	@RequestMapping( params="operation=markRectifyCourseToComplete" )
	public String markRectifyCourseToComplete( StudentInstitutionTranscript studentInstitutionTranscript,
			@RequestParam(value="institutionId",required=false) String institutionId,@RequestParam(value="studentId",required=false) String studentId,
			@RequestParam(value="markCompleted",required=false) boolean markCompleted, 
			@RequestParam(value="institutionAddressId",required=false) String institutionAddressId,
			@RequestParam(value="programVersionCode") String programVersionCode,HttpServletRequest request, Model model  ) {
		
			StudentInstitutionTranscript sit = evaluationService.getStudentInstitutionTranscriptById(studentInstitutionTranscript.getId()); 
			
			Student  student  = studentService.getStudentById(studentId);
			//TODO:ALhaz
			studentInstitutionTranscript.setStudent(student);
			studentInstitutionTranscript.setMarkCompleted(markCompleted);
			studentInstitutionTranscript.setCreatedDate(sit.getCreatedDate());
			studentInstitutionTranscript.setDateReceived(sit.getDateReceived());
			studentInstitutionTranscript.setLastAttendenceDate(sit.getLastAttendenceDate());
			List<StudentTranscriptCourse> studentTranscriptList = new ArrayList<StudentTranscriptCourse>();
			
				Institution inst = institutionService.getInstitutionById(institutionId);
				if(institutionAddressId!=null && !institutionAddressId.equals("")){
					InstitutionAddress  institutionAddress = institutionService.getInstitutionAddress(institutionAddressId);
					studentInstitutionTranscript.setInstitutionAddress(institutionAddress!=null ? institutionAddress : null);
				}
				
				studentInstitutionTranscript.setInstitution(inst);
				
				List<StudentTranscriptCourse> studentTranscriptCourseList = studentInstitutionTranscript.getStudentTranscriptCourse();
				/**SART : Logic to get all courses which are deleted by User and not rectified  
				 * */
				List<StudentTranscriptCourse> stcRejectedListForDeletion = new ArrayList<StudentTranscriptCourse>();
				List<StudentTranscriptCourse> stcRejectedList = evaluationService.getAllRejectedSTCByUserForStudentAndInstitute(studentInstitutionTranscript.getId(),studentId,institutionId,UserUtil.getCurrentUser());
				for(StudentTranscriptCourse stcRejected : stcRejectedList){				
					boolean courseIdFound = false;
					for(StudentTranscriptCourse stc : studentTranscriptCourseList){			
						if(stc.getId() != null && !stc.getId().equals("")){
							if(stcRejected.getId().equals(stc.getId())){
								courseIdFound = true;
								break;								
							}
						}						
					}
					if(courseIdFound){
						continue;
					}else{
						stcRejectedListForDeletion.add(stcRejected);
					}
				}
				if(stcRejectedListForDeletion != null && stcRejectedListForDeletion.size()>0){
					transcriptService.removeRejectedStudentTranscriptCourseMarkForDelection(stcRejectedListForDeletion);
				}
				/**END : Logic to get all courses which are deleted by User and not rectified  
				 * */
				
				int j = 0;
				if(studentTranscriptCourseList!=null && studentTranscriptCourseList.size()>0){
					for (StudentTranscriptCourse studentTranscriptCourse : studentTranscriptCourseList) {		
						if(studentTranscriptCourse.getTrCourseId()!=null  &&  !studentTranscriptCourse.getTrCourseId().equals("")){						
						/*
						 * find the trCourseId in ss_tbl_transfer_course table
						 * If not found add new entry with evaluation_status set to 0
						 */ 
						TransferCourse tc = transferCourseService.getTransferCourseByCourseCodeAndInstitutionId(studentTranscriptCourse.getTrCourseId(), inst.getId());
						if( tc == null ) {
							tc = new TransferCourse();
							tc.setTrCourseCode( studentTranscriptCourse.getTrCourseId() );
							tc.setTrCourseTitle(studentTranscriptCourse.getTransferCourseTitle().getTitle());
							tc.setTranscriptCredits(studentTranscriptCourse.getTransferCourse().getTranscriptCredits());
							tc.setSemesterCredits(studentTranscriptCourse.getTransferCourse().getSemesterCredits());
							tc.setEvaluationStatus( TranscriptStatusEnum.NOTEVALUATED.getValue());						
							//tc.setSchoolCode( inst.getSchoolcode() );
							tc.setInstitution(inst);
							tc.setTrCourseTitle( studentTranscriptCourse.getTransferCourseTitle().getTitle() );
							//TODO::setting this to blank in order to use it later.
							tc.setInstitutionDegreeId("");
							//transferCourseService.addTransferCourse( tc );
							TransferCourse tcCheckAgain = courseMgmtService.getTransferCourseByCodeAndInstitution(tc.getTrCourseCode(), tc.getInstitution().getId());
							if(tcCheckAgain == null){
								courseMgmtService.saveTransferCourse(tc);
							}else{
								courseMgmtService.updateTransferCourse(tc);
							}
						}
						else {/**If i rectify only the course_title not CourseCode then it must get updated into TransferCourse
								 irrespective of it's evaluation_status
						 		*/
							//if( tc.getEvaluationStatus().equalsIgnoreCase("NOT EVALUATED")){
								tc.setTrCourseTitle( studentTranscriptCourse.getTransferCourseTitle().getTitle() );
								transferCourseService.saveTransferCourse( tc );
							//}						
						}
						
						//StudentTranscriptCourse st = new StudentTranscriptCourse();
						studentTranscriptCourse.setTrCourseId( studentTranscriptCourse.getTrCourseId()   );
						
						
						TransferCourseTitle tct = transferCourseService.getTransferCourseTitleByDate(studentTranscriptCourse.getCompletionDate(), tc.getId());
						if(tct==null){
							/** Just find-out the TransferCourseTitle irrespective of their evaluation status rather then NOTEVALUATED
							 *  
							tct = transferCourseService.getNotEvaluatedTransferCourseTitleByCourseIdAndTitle(tc.getId(), studentTranscriptCourse.getTransferCourseTitle().getTitle());*/
							tct = transferCourseService.getTransferCourseTitleByCourseIdAndTitle(tc.getId(), studentTranscriptCourse.getTransferCourseTitle().getTitle());
						}
						if(tct==null){
							tct= new TransferCourseTitle();
							tct.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
							tct.setTitle(studentTranscriptCourse.getTransferCourseTitle().getTitle());
							tct.setTransferCourseId(tc.getId());
							List<TransferCourseTitle> tctList = transferCourseService.getTransferCourseTitlesByTransferCourseId(tc.getId());
							if(tctList != null && !tctList.isEmpty()){
								tct.setEffective(false);
							}else{
								tct.setEffective(true);//setting it to true for default active
							}
							tct.setTransferCourseId(tc.getId());
							transferCourseService.addTransferCourseTitle(tct,tctList!= null && !tctList.isEmpty()?tctList.size():0);
						}
						
						j = j + 1;
						studentTranscriptCourse.setTransferCourseTitleId(tct.getId());
						//TODO:Not decided yet
						if(studentTranscriptCourse.getTranscriptStatus()!=null && !studentTranscriptCourse.getTranscriptStatus().equals("") && studentTranscriptCourse.getTranscriptStatus().equalsIgnoreCase(TranscriptStatusEnum.REJECTED.getValue())){
							studentTranscriptCourse.setId(studentTranscriptCourse.getId());
							studentTranscriptCourse.setCreatedBy(studentTranscriptCourse.getCreatedBy());
							
						}else{
							studentTranscriptCourse.setCreatedDate(new Date() );
							studentTranscriptCourse.setCreatedBy(UserUtil.getCurrentUser().getId());
						}
						String transcriptStatus = studentTranscriptCourse.getTranscriptStatus();
						if(transcriptStatus!=null && !transcriptStatus.isEmpty()){
							if(transcriptStatus.equalsIgnoreCase(TranscriptStatusEnum.REJECTED.getValue())){
								studentTranscriptCourse.setTranscriptStatus(tc.getTransferStatus());
							}else{
								studentTranscriptCourse.setTranscriptStatus(transcriptStatus);
							}
							
						}else{
							studentTranscriptCourse.setTranscriptStatus(TranscriptStatusEnum.PENDINGEVAL.getValue());
							
						}
						studentTranscriptCourse.setInstitution( inst );
						//studentTranscriptCourse.setCourseSequence( j );
						studentTranscriptCourse.setStudentInstitutionTranscript( studentInstitutionTranscript );
						
						studentTranscriptCourse.setCompletionDate( studentTranscriptCourse.getCompletionDate() );
						 
						
						
						studentTranscriptCourse.setGrade( studentTranscriptCourse.getGrade());
						
						
						if(tc.getEvaluationStatus().equalsIgnoreCase("Evaluated") && !studentTranscriptCourse.getTranscriptStatus().equalsIgnoreCase(TranscriptStatusEnum.REJECTED.getValue())){
							studentTranscriptCourse.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
						}else{
							//studentTranscriptCourse.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
							if(studentInstitutionTranscript.getOfficial()){
								studentTranscriptCourse.setEvaluationStatus(TranscriptStatusEnum.INPROGRESS.getValue());
							}else{
								studentTranscriptCourse.setEvaluationStatus(TranscriptStatusEnum.AWAITINGOFFICIAL.getValue());
							}
						}
						
						if(	studentTranscriptCourse.getTransferCourse().getTranscriptCredits()!=null && !studentTranscriptCourse.getTransferCourse().getTranscriptCredits().equals("")){				
							studentTranscriptCourse.setCreditsTransferred(Integer.parseInt(studentTranscriptCourse.getTransferCourse().getTranscriptCredits().trim()));
						}
						studentTranscriptCourse.setClockHours(studentTranscriptCourse.getTransferCourse().getClockHours() );
						//st.setClockHours( clockHours );
						studentTranscriptCourse.setModifiedBy(UserUtil.getCurrentUser().getId());
						studentTranscriptCourse.setTransferCourseTitleId(tct.getId());
						studentTranscriptCourse.setTransferCourse( tc );
						studentTranscriptList.add( studentTranscriptCourse );
					}
					}
				}
				List<StudentInstitutionDegree> sids = new ArrayList<StudentInstitutionDegree>();	
				List<StudentInstitutionDegree> studentInstitutionDegreeList = studentInstitutionTranscript.getStudentInstitutionDegreeSet();				
				
				if(studentInstitutionDegreeList!=null && studentInstitutionDegreeList.size()>0){
					
					for(StudentInstitutionDegree studentInstitutionDegree : studentInstitutionDegreeList){
						
							//If the degree or GPA or completion date is blank, ignore and continue
							
							StudentInstitutionDegree sid = new StudentInstitutionDegree();
							if(studentInstitutionDegree.getInstitutionDegree() !=null){
								InstitutionDegree inid = institutionService.getInstitutionDegreeByInstituteIDAndDegreeName( institutionId, studentInstitutionDegree.getInstitutionDegree().getDegree() );
								if( inid == null ) {
									inid = new InstitutionDegree();
									inid.setDegree( studentInstitutionDegree.getInstitutionDegree().getDegree() );
									inid.setInstitution( inst );
								}
								sid.setInstitutionDegree( inid );
								sid.setMajor( studentInstitutionDegree.getMajor() );
								sid.setCompletionDate( studentInstitutionDegree.getCompletionDate() );
								sid.setGpa( studentInstitutionDegree.getGpa());
								sid.setStudentInstitutionTranscript(studentInstitutionTranscript);
								sids.add( sid );			
							
							}
					}
					
				}
				CollegeProgram collegeProgram= studentService.getCollegeByPV(programVersionCode);
				if(collegeProgram!=null){
					studentInstitutionTranscript.setCollegeCode(collegeProgram.getCollegeCode());
				}
				transcriptService.saveRejectedTranscriptsForStudentInstitutionTranscriptasMarkComplete( studentInstitutionTranscript, studentTranscriptList,sids );
		return "redirect:launchEvaluation.html?operation=getAllCoursesAndDegreesForStudentAndInstitute&studentId="+studentId+"&institutionId="+institutionId+"&institutionAddressId="+institutionAddressId;
	}
	@RequestMapping(params="operation=getInstitutionTermTypeForCourse")
	public ModelAndView getInstitutionTermTypeForCourse(@RequestParam("completionDate") Date completionDate ,@RequestParam("institutionId") String institutionId,Model model){
		
		InstitutionTermType institutionTermType = null;
		/**START JIRA LCSCHED-239
			Semester Credit calculation on student transcript needs to consider date course was completed*/
		institutionTermType = institutionTermTypeService.getCurrentlyEffectiveInstitutionTermType(completionDate,institutionId);
		/**END JIRA LCSCHED-239*/
		Map<String, InstitutionTermType> map = new HashMap<String,InstitutionTermType>();
		map.put(Constants.FLEX_JSON_DATA, institutionTermType);
		
		return new ModelAndView(Constants.FLEX_JSON_VIEW, map);
	}

	@RequestMapping(params="operation=addTranscriptComment")
	public String addTranscriptComment(TranscriptComments transcriptComments,@RequestParam("divindex") String divindex,
			Model model){
		
		transcriptCommentService.addTranscriptComment(transcriptComments);
		List<TranscriptComments> transcriptCommentsList =transcriptCommentService.getTranscriptComment(transcriptComments.getTranscriptId());
		model.addAttribute("transcriptCommentsList",transcriptCommentsList);
		model.addAttribute("userID",UserUtil.getCurrentUser().getId());
		model.addAttribute("divindex",divindex);
		return "transcriptCommentsList" ;
	}
	@RequestMapping(params="operation=removeTranscriptComment")
	public String removeTranscriptComment(@RequestParam("commentId") String commentId,
			@RequestParam("transcriptId") String transcriptId ,@RequestParam("divindex") String divindex,
			Model model){
		
		transcriptCommentService.removeTranscriptComment(commentId);
		List<TranscriptComments> transcriptCommentsList =transcriptCommentService.getTranscriptComment(transcriptId);
		model.addAttribute("transcriptCommentsList",transcriptCommentsList);
		model.addAttribute("userID",UserUtil.getCurrentUser().getId());
		model.addAttribute("divindex",divindex);
		return "transcriptCommentsList" ;
	}
	@RequestMapping(params="operation=getCourseType")
	public ModelAndView getCourseType(@RequestParam("institutionId") String institutionId,@RequestParam("courseCode") String courseCode,Model model){
		TransferCourse transferCourse = null;
		
		transferCourse = transferCourseService.getTransferCourseByCourseCodeAndInstitutionId(courseCode, institutionId);
		Map<String, TransferCourse> map = new HashMap<String,TransferCourse>();
		map.put(Constants.FLEX_JSON_DATA, transferCourse);
		
		return new ModelAndView(Constants.FLEX_JSON_VIEW, map);
	}
	
	@RequestMapping( params="operation=getAllCoursesAndDegreesForMilitary" )
	public String getAllCoursesAndDegreesForMilitary(@RequestParam("studentId") String studentId,
			@RequestParam("institutionId") String institutionId,
			@RequestParam(value="institutionAddressId",required=false) String institutionAddressId,
			Model model, HttpServletRequest request ) {
		
		List<StudentInstitutionTranscriptSummary> studentInstitutionTranscriptSummaryList = new ArrayList<StudentInstitutionTranscriptSummary>();
		StudentInstitutionTranscript OldestStudentInstitutionTranscript =  evaluationService.getOldestStudentInstitutionTranscriptForStudentAndInstitute(studentId, institutionId,false);
		List<StudentInstitutionTranscript> studentInstitutionTranscriptList =  evaluationService.getStudentInstitutionTranscriptForStudentAndInstitute(studentId, institutionId);
		Collections.sort(studentInstitutionTranscriptList);
		
		for(StudentInstitutionTranscript studentInstitutionTranscript : studentInstitutionTranscriptList){
			if(studentInstitutionTranscript.isMarkCompleted()){
				StudentInstitutionTranscriptSummary studentInstitutionTranscriptSummary = new StudentInstitutionTranscriptSummary();
				List<StudentInstitutionDegree> sidListOfStudentInstitutionTranscript = transcriptService.getStudentInstitutionDegreeListForStudentTranscriptAndInstitute(studentInstitutionTranscript.getId(), institutionId);
				studentInstitutionTranscript.setStudentInstitutionDegreeSet(sidListOfStudentInstitutionTranscript);
				studentInstitutionTranscript.setUser(userService.getUserByUserId(studentInstitutionTranscript.getCreatedBy()));
				studentInstitutionTranscript.setTranscriptCommentsList(transcriptCommentService.getTranscriptComment(studentInstitutionTranscript.getId()));
				studentInstitutionTranscriptSummary.setStudentInstitutionTranscript(studentInstitutionTranscript);
				studentInstitutionTranscriptSummaryList.add(studentInstitutionTranscriptSummary);
			}
		}
		Institution institution = institutionService.getInstitutionById(institutionId);
		InstitutionAddress institutionAddress = null;
		List<InstitutionAddress> institutionAddressList = new ArrayList<InstitutionAddress>();		
		
		if(institutionAddressId!=null && !institutionAddressId.equals("")){
			institutionAddress = institutionService.getInstitutionAddress(institutionAddressId);
			institutionAddressList.add(institutionAddress);
			institution.setAddresses(institutionAddressList);		
		}else{
			institutionAddress = OldestStudentInstitutionTranscript.getInstitutionAddress();
			institutionAddressList.add(institutionAddress);
			institution.setAddresses(institutionAddressList);
		}
		
		Student  studentFromDB  = studentService.getStudentById(studentId);
 	    Student studentFromCRM = null;
 	    //we are using INQUIRY ID so we should get only 1 record back.
 		StudentProgramInfo courseInfo =null;
		try {
			studentFromCRM = getStudentInfoFromCRMbyInquiryId(studentFromDB);
	        //set the student DatabaseId
			studentFromCRM.setId(studentFromDB.getId());
			courseInfo = studentService.getActiveStudentProgramInformation(studentFromDB);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		model.addAttribute( "courseInfo" , courseInfo );
		model.addAttribute( "student", studentFromCRM );
		model.addAttribute( "selectedInstitution", institution );
		model.addAttribute( "studentInstitutionTranscript", OldestStudentInstitutionTranscript);	
		model.addAttribute( "studentInstitutionTranscriptSummaryList", studentInstitutionTranscriptSummaryList );
		return "evaluationMilitary";
	}
	
	@RequestMapping(params="operation=saveMilitaryTranscriptIntoDraftMode" )
	public String saveMilitary‎TranscriptIntoDraftMode(StudentInstitutionTranscript studentInstitutionTranscript,  
					@RequestParam(value="expectedStartDateString",required=false) String expectedStartDateString,
					@RequestParam(value="institutionId",required=false) String institutionId, 
					@RequestParam(value="institutionAddressId",required=false) String institutionAddressId, HttpServletRequest request, Model model ) {
				System.out.println("studentInstitutionTranscript="+studentInstitutionTranscript);
				//Check if there is a StudentProgramEvaluation already created for this Student and ProgramVersionCode.
				StudentInstitutionTranscript sitFirst = evaluationService.getStudentInstitutionTranscriptById(studentInstitutionTranscript.getId());
				String studentCrmId = request.getParameter( "studentCrmId" );
				String programVersionCode = request.getParameter( "programVersionCode" );
				Student student = studentService.getStudentByCrmIdFromDB(studentCrmId);
				studentInstitutionTranscript.setStudent(student);
				if(institutionAddressId!=null && !institutionAddressId.equals("")){
					InstitutionAddress  institutionAddress = institutionService.getInstitutionAddress(institutionAddressId);
					studentInstitutionTranscript.setInstitutionAddress(institutionAddress!=null ? institutionAddress : null);
				}
				studentInstitutionTranscript.setCreatedDate(sitFirst.getCreatedDate());
				/*if(programVersionCode.startsWith("LCS")){
					student.setProgramDescription( "LCS TEST Desc" );
				}else {
					//StudentProgramInfo courseInfo2 = evaluationService.getProgramInfoByProgramVersionCode( programVersionCode );// TODO we need to check why we should make it
					student.setProgramDescription( programVersionCode );
				}*/
				
				//Build the Institution Degree and Student Institution Degree list.
				Institution institution = institutionService.getInstitutionById( institutionId );
				
				
				//last date of last course for this transcript
				Date ldlc = null;
				
				Date expectedStartDate = null;
				try {
					if(expectedStartDateString != null && !expectedStartDateString.isEmpty()){
						expectedStartDate = new SimpleDateFormat( "MM/dd/yyyy" ).parse( expectedStartDateString );
					}
				} 
				catch( ParseException e ) {
					//log.error( "Exception while parsing expected Start date --- " + e, e );
					String uniqueId = RequestContext.getRequestIdFromContext();
					log.error("Exception while parsing expected Start date ---."+e+" RequestId:"+uniqueId, e);
					throw new RuntimeException( e );
				}
				
				Boolean isTranscriptOfficial = request.getParameter( "transcriptType" ) == null ? 
													null : "1".equals( request.getParameter( "transcriptType" ) ) ? true : false ;
				/**START LCSCHED-362-FOR PHASE-1 only
				 * */
				studentInstitutionTranscript.setOfficial(false);
				/**END LCSCHED-362
				 * */
				//Create new SIT.
				//StudentInstitutionTranscript sit = new StudentInstitutionTranscript(); 
				//evaluationService.createEvaluationForStudent( studentProgramEvaluation, sids, institution, expectedStartDate, ldlc, isTranscriptOfficial, studentInstitutionTranscript );
				StudentInstitutionTranscript sit =	evaluationService.createMilitaryTranscriptForStudent( student, institution, expectedStartDate, isTranscriptOfficial, studentInstitutionTranscript );
				List<StudentTranscriptCourse> studentTranscriptCourseList = saveMilitaryTrascriptCoursesInDraftMode(studentInstitutionTranscript.getStudentTranscriptCourse(), sit);
				
				
				model.addAttribute( "selectedInstitution", institution);
				
				List<StudentInstitutionTranscript> transcriptList = evaluationService.getStudentInstitutionTranscriptForStudent( student);
				model.addAttribute( "transcriptList", transcriptList );
				model.addAttribute( "studentProgramEvaluation", student );
				model.addAttribute( "institutionDataAvailable", true );
				
				return "redirect:launchEvaluation.html?operation=getAllCoursesAndDegreesForStudentAndInstitute&studentId="+student.getId()+"&institutionId="+sit.getInstitution().getId()+"&institutionAddressId="+institutionAddressId;
				
	}
	
	public List<StudentTranscriptCourse> saveMilitaryTrascriptCoursesInDraftMode(List<StudentTranscriptCourse> studentTranscriptCourseList,StudentInstitutionTranscript studentInsTrans){
		//Get the Student Institution Transcript
				//StudentInstitutionTranscript studentInsTrans = evaluationService.getStudentInstitutionTranscriptById(sit.getId() );
				if( studentInsTrans == null ) {
					throw new RuntimeException( "StudentInstitutionTranscript cound not be found for Id - " +  studentInsTrans.getId() );
				}
				log.debug("StudentInstitutionTranscript id = "+studentInsTrans.getId());
				List<StudentTranscriptCourse> studentTranscriptList = new ArrayList<StudentTranscriptCourse>();
					Institution inst = institutionService.getInstitutionById(studentInsTrans.getInstitution().getId());
				int j = 0;
				if(studentTranscriptCourseList!=null && studentTranscriptCourseList.size()>0){
					for (StudentTranscriptCourse studentTranscriptCourse : studentTranscriptCourseList) {				
						
						
						if(studentTranscriptCourse.getTrCourseId()!=null  &&  !studentTranscriptCourse.getTrCourseId().equals("") && (!studentTranscriptCourse.isMarkCompleted() ||(studentTranscriptCourse.isMarkCompleted() && studentTranscriptCourse.getEvaluationStatus().equalsIgnoreCase(TranscriptStatusEnum.EVALUATED.getValue())))){			
							//find the trCourseId in ss_tbl_transfer_course table
							//if not found add new entry with evaluation_status set to 0
							TransferCourse tc = transferCourseService.getTransferCourseByCourseCodeAndInstitutionId(studentTranscriptCourse.getTrCourseId(), inst.getId());
							TransferCourseTitle tct = new TransferCourseTitle();
							CourseTranscript ct= new CourseTranscript();
							ct.setStudentInstitutionTranscriptId(studentInsTrans.getId());
							if(tc == null){
								tc = new TransferCourse();
								tc.setTrCourseCode(studentTranscriptCourse.getTrCourseId());
								tc.setAceExhibitNo(studentTranscriptCourse.getTransferCourse().getAceExhibitNo());
								tc.setTrCourseTitle(studentTranscriptCourse.getTransferCourseTitle().getTitle());
								tc.setCreatedBy(UserUtil.getCurrentUser().getId());
								tc.setModifiedBy(UserUtil.getCurrentUser().getId());
								tc.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
								tct.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
								tc.setInstitution(inst);
								//tc.getInstitution().setSchoolcode(inst.getSchoolcode());
								tct.setTitle(studentTranscriptCourse.getTransferCourseTitle().getTitle());
								tct.setEffective(true);//setting it to true for defaultly active
								//TODO::setting this to blank in order to use it later.
								tc.setInstitutionDegreeId("");	
								tc.setCreatedDate(new Date());
								tc.setModifiedDate(new Date());
								//tc.setTranscriptCredits(studentTranscriptCourse.getTransferCourse().getTranscriptCredits());
								//tc.setSemesterCredits(studentTranscriptCourse.getTransferCourse().getSemesterCredits());
								//tc.setClockHours(studentTranscriptCourse.getTransferCourse().getClockHours());
								//transferCourseService.addTransferCourse(tc);	
								TransferCourse tcCheckAgain = courseMgmtService.getTransferCourseByCodeAndInstitution(tc.getTrCourseCode(), tc.getInstitution().getId());
								if(tcCheckAgain == null){
									courseMgmtService.saveTransferCourse(tc);
								}else{
									courseMgmtService.updateTransferCourse(tc);
								}
								tct.setTransferCourseId(tc.getId());
								transferCourseService.addTransferCourseTitle(tct);
								
								
								ct.setTrCourseId(tc.getId());
								ct.setModifiedDate(new Date());
								transferCourseService.addCourseTranscript(ct);
								
							}
							else {
								/**If User changed in any value of TransferCourse Then it must update the same so that the user not get confused by difference in value for the same course as when we login with IE we are reading the value from StudentTranscriptCourse*/
								//transferCourseService.addTransferCourse(tc);
								//tct = transferCourseService.getTransferCourseTitleByDate(studentTranscriptCourse.getCompletionDate(), tc.getId());
								ct.setTrCourseId(tc.getId());
								ct.setModifiedDate(new Date());
								//if(tct == null && studentTranscriptCourse.getTransferCourseTitle()!=null && studentTranscriptCourse.getTransferCourseTitle().getTitle()!=null && !studentTranscriptCourse.getTransferCourseTitle().getTitle().equals("")){
								if(studentTranscriptCourse.getTransferCourseTitle().getTitle()!=null && !studentTranscriptCourse.getTransferCourseTitle().getTitle().equals("")){
									/** Just find-out the TransferCourseTitle ir-rsepctive of their evaluation status rather then NOTEVALUATED
									 *  
									tct = transferCourseService.getNotEvaluatedTransferCourseTitleByCourseIdAndTitle(tc.getId(), studentTranscriptCourse.getTransferCourseTitle().getTitle());*/
									tct = transferCourseService.getTransferCourseTitleByCourseIdAndTitle(tc.getId(), studentTranscriptCourse.getTransferCourseTitle().getTitle());
								}
								if(tct == null){
									tct = new TransferCourseTitle();
									tct.setEvaluationStatus(tc.getEvaluationStatus());
									tc.setEvaluationStatus(tc.getEvaluationStatus());
									tc.setCreatedBy(UserUtil.getCurrentUser().getId());
									tc.setModifiedBy(UserUtil.getCurrentUser().getId());
									tct.setTitle(studentTranscriptCourse.getTransferCourseTitle().getTitle());
									List<TransferCourseTitle> tctList = transferCourseService.getTransferCourseTitlesByTransferCourseId(tc.getId());
									if(tctList != null && !tctList.isEmpty()){
										tct.setEffective(false);
									}else{
										tct.setEffective(true);//setting it to true for default active
									}
									tct.setTransferCourseId(tc.getId());
									transferCourseService.addTransferCourseTitle(tct);
									transferCourseService.addCourseTranscript(ct);
								}
								else{
										tct.setTitle(studentTranscriptCourse.getTransferCourseTitle().getTitle());
										transferCourseService.addTransferCourseTitle(tct);
										tc.setEvaluationStatus(tc.getEvaluationStatus());
										transferCourseService.addCourseTranscript(ct);
								}
								
							}
							
							StudentTranscriptCourse st = new StudentTranscriptCourse();
							st.setTrCourseId(studentTranscriptCourse.getTrCourseId());
							
							st.setTransferCourseTitle(tct);
							st.setTransferCourseTitleId(tct.getId());
							String transcriptStatus = studentTranscriptCourse.getTranscriptStatus();
							if(transcriptStatus!=null && !transcriptStatus.isEmpty()){
								st.setTranscriptStatus(transcriptStatus);
							}else{
								st.setTranscriptStatus(TranscriptStatusEnum.PENDINGEVAL.getValue());
								
							}
							j = j + 1;
							st.setInstitution( inst );
							st.setCourseSequence( j );
							//It is the point where we are Pointing Courses to the pre-existing StudentInstitutionTranscript
							st.setStudentInstitutionTranscript( studentInsTrans );
							
							st.setCompletionDate(studentTranscriptCourse.getCompletionDate());
							st.setGrade(studentTranscriptCourse.getGrade());
							/**If suppose we are coming after rectifing the courses and if we changes in course title only then if course title does not exist then we have to mark the course as either  IN-PROGRESS or  
							 * AWAITING-OFFICIAL
							 * */
							if(studentTranscriptCourse.getEvaluationStatus()!=null && !studentTranscriptCourse.getEvaluationStatus().equals("") && !tc.getEvaluationStatus().equalsIgnoreCase(TranscriptStatusEnum.NOTEVALUATED.getValue())){
								st.setEvaluationStatus(studentTranscriptCourse.getEvaluationStatus());
							}else if(studentInsTrans.getOfficial()){
								st.setEvaluationStatus(TranscriptStatusEnum.INPROGRESS.getValue());
							}else{
								if(tc.getEvaluationStatus().equalsIgnoreCase(TranscriptStatusEnum.CONFLICT.getValue())){
									st.setEvaluationStatus(TranscriptStatusEnum.INPROGRESS.getValue());
								}else{
									st.setEvaluationStatus(TranscriptStatusEnum.AWAITINGOFFICIAL.getValue());
								}
							}
							st.setCreatedBy(UserUtil.getCurrentUser().getId());
							st.setModifiedBy(UserUtil.getCurrentUser().getId());
							float credit=0;
							/*if(	studentTranscriptCourse.getTransferCourse().getTranscriptCredits()!=null && !studentTranscriptCourse.getTransferCourse().getTranscriptCredits().equals("")){
								credit= Float.parseFloat(studentTranscriptCourse.getTransferCourse().getTranscriptCredits());
							}*/
							
							
							/*if(	studentTranscriptCourse.getTransferCourse().getTranscriptCredits()!=null && !studentTranscriptCourse.getTransferCourse().getTranscriptCredits().equals("")){				
								st.setCreditsTransferred(Integer.parseInt(studentTranscriptCourse.getTransferCourse().getTranscriptCredits().trim()));
							}*/
							//tc.setTranscriptCredits(String.valueOf(credit));
							//tc.setClockHours((int)studentTranscriptCourse.getTransferCourse().getClockHours());
							//st.setGrade(studentTranscriptCourse.getGrade());
							//st.setClockHours(studentTranscriptCourse.getTransferCourse().getClockHours() );
							
							st.setCreatedDate(new Date());
							st.setTransferCourse( tc );
							st.setTranscriptCourseSubjectList(studentTranscriptCourse.getTranscriptCourseSubjectList());
							if(studentTranscriptCourse.getTransferCourse() != null && studentTranscriptCourse.getTransferCourse().getAceExhibitNo() != null && !studentTranscriptCourse.getTransferCourse().getAceExhibitNo().isEmpty()){
								tc.setAceExhibitNo(studentTranscriptCourse.getTransferCourse().getAceExhibitNo());
								courseMgmtService.updateTransferCourse(tc);
							}else{
								//DO nothing...
							}
							studentTranscriptList.add(st);
						}				
					}
		}	
			transcriptService.saveNewDraftMilitaryTranscriptsForStudentInstitutionTranscript( studentInsTrans, studentTranscriptList );
			return studentTranscriptList;	
	}
	@RequestMapping( params="operation=markMilitaryTranscriptToComplete" )
	public String markMilitaryTranscriptToComplete( StudentInstitutionTranscript studentInstitutionTranscript,
			@RequestParam(value="institutionId",required=false) String institutionId,@RequestParam(value="studentId",required=false) String studentId,@RequestParam(value="markCompleted",required=false) boolean markCompleted, 
			@RequestParam(value="institutionAddressId",required=false) String institutionAddressId,
			@RequestParam(value="transcriptId") String oldStudentInstitutionTranscriptId,
			@RequestParam(value="programVersionCode") String programVersionCode,HttpServletRequest request, Model model  ) {
		
		
			Student  student  = studentService.getStudentById(studentId);
			studentInstitutionTranscript.setStudent(student);
			studentInstitutionTranscript.setMarkCompleted(markCompleted);
			
			List<StudentTranscriptCourse> studentTranscriptList = new ArrayList<StudentTranscriptCourse>();
			
				Institution inst = institutionService.getInstitutionById(institutionId);
				if(institutionAddressId!=null && !institutionAddressId.equals("")){
					InstitutionAddress  institutionAddress = institutionService.getInstitutionAddress(institutionAddressId);
					studentInstitutionTranscript.setInstitutionAddress(institutionAddress!=null ? institutionAddress : null);
				}
				
				studentInstitutionTranscript.setInstitution(inst);
				
				List<StudentTranscriptCourse> studentTranscriptCourseList = studentInstitutionTranscript.getStudentTranscriptCourse();
				
				
				int j = 0;
				if(studentTranscriptCourseList!=null && studentTranscriptCourseList.size()>0){
					for (StudentTranscriptCourse studentTranscriptCourse : studentTranscriptCourseList) {		
						if(studentTranscriptCourse.getTrCourseId()!=null  &&  !studentTranscriptCourse.getTrCourseId().equals("")){						
						/*
						 * find the trCourseId in ss_tbl_transfer_course table
						 * If not found add new entry with evaluation_status set to 0
						 */ 
						TransferCourse tc = transferCourseService.getTransferCourseByCourseCodeAndInstitutionId(studentTranscriptCourse.getTrCourseId(), inst.getId());
						if( tc == null ) {
							tc = new TransferCourse();
							tc.setTrCourseCode( studentTranscriptCourse.getTrCourseId() );
							tc.setAceExhibitNo(studentTranscriptCourse.getTransferCourse().getAceExhibitNo());
							tc.setTrCourseTitle(studentTranscriptCourse.getTransferCourseTitle().getTitle());
							//tc.setTranscriptCredits(studentTranscriptCourse.getTransferCourse().getTranscriptCredits());
							//tc.setSemesterCredits(studentTranscriptCourse.getTransferCourse().getSemesterCredits());
							tc.setEvaluationStatus( TranscriptStatusEnum.NOTEVALUATED.getValue());						
							//tc.setSchoolCode( inst.getSchoolcode() );
							tc.setInstitution(inst);
							tc.setTrCourseTitle( studentTranscriptCourse.getTransferCourseTitle().getTitle() );
							//TODO::setting this to blank in order to use it later.
							tc.setInstitutionDegreeId("");	
							//tc.setClockHours((int)studentTranscriptCourse.getTransferCourse().getClockHours());
							//transferCourseService.addTransferCourse( tc );
							TransferCourse tcCheckAgain = courseMgmtService.getTransferCourseByCodeAndInstitution(tc.getTrCourseCode(), tc.getInstitution().getId());
							if(tcCheckAgain == null){
								courseMgmtService.saveTransferCourse(tc);
							}else{
								courseMgmtService.updateTransferCourse(tc);
							}
						}/*
						else {
							if( tc.getEvaluationStatus().equalsIgnoreCase("NOT EVALUATED")){
								tc.setTrCourseTitle( studentTranscriptCourse.getTransferCourseTitle().getTitle() );
								transferCourseService.saveTransferCourse( tc );
							}						
						}*/
						
						//StudentTranscriptCourse st = new StudentTranscriptCourse();
						studentTranscriptCourse.setTrCourseId( studentTranscriptCourse.getTrCourseId()   );
						
						
						TransferCourseTitle tct = transferCourseService.getTransferCourseTitleByDate(studentTranscriptCourse.getCompletionDate(), tc.getId());
						if(tct==null){
							/** Just find-out the TransferCourseTitle ir-rsepctive of their evaluation status rather then NOTEVALUATED
							 *  
							tct = transferCourseService.getNotEvaluatedTransferCourseTitleByCourseIdAndTitle(tc.getId(), studentTranscriptCourse.getTransferCourseTitle().getTitle());*/
							tct = transferCourseService.getTransferCourseTitleByCourseIdAndTitle(tc.getId(), studentTranscriptCourse.getTransferCourseTitle().getTitle());
						}
						if(tct==null){
							tct= new TransferCourseTitle();
							tct.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
							tct.setTitle(studentTranscriptCourse.getTransferCourseTitle().getTitle());
							tct.setTransferCourseId(tc.getId());
							List<TransferCourseTitle> tctList = transferCourseService.getTransferCourseTitlesByTransferCourseId(tc.getId());
							if(tctList != null && !tctList.isEmpty()){
								tct.setEffective(false);
							}else{
								tct.setEffective(true);//setting it to true for default active
							}
							tct.setTransferCourseId(tc.getId());
							transferCourseService.addTransferCourseTitle(tct,tctList!= null && !tctList.isEmpty()?tctList.size():0);
						}
						
						j = j + 1;
						studentTranscriptCourse.setTransferCourseTitleId(tct.getId());
						//TODO:Not decided yet
						String transcriptStatus = studentTranscriptCourse.getTranscriptStatus();
						if(transcriptStatus!=null && !transcriptStatus.isEmpty()){
							studentTranscriptCourse.setTranscriptStatus(transcriptStatus);
						}else{
							studentTranscriptCourse.setTranscriptStatus(TranscriptStatusEnum.PENDINGEVAL.getValue());
							
						}
						studentTranscriptCourse.setInstitution( inst );
						studentTranscriptCourse.setCourseSequence( j );
						studentTranscriptCourse.setStudentInstitutionTranscript( studentInstitutionTranscript );
						
						studentTranscriptCourse.setCompletionDate( studentTranscriptCourse.getCompletionDate() );
						
						
						//studentTranscriptCourse.setGrade( studentTranscriptCourse.getGrade());
						
						
						if(tc.getEvaluationStatus().equalsIgnoreCase(TranscriptStatusEnum.EVALUATED.getValue())){
							studentTranscriptCourse.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
						}else{
							//studentTranscriptCourse.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
							if(studentInstitutionTranscript.getOfficial()){
								studentTranscriptCourse.setEvaluationStatus(TranscriptStatusEnum.INPROGRESS.getValue());
							}else{
								studentTranscriptCourse.setEvaluationStatus(TranscriptStatusEnum.AWAITINGOFFICIAL.getValue());
							}
						}
						studentTranscriptCourse.setCreatedDate(new Date() );
						studentTranscriptCourse.setTransferCourseTitleId(tct.getId());
						studentTranscriptCourse.setTransferCourse( tc );
						studentTranscriptCourse.setTranscriptCourseSubjectList(studentTranscriptCourse.getTranscriptCourseSubjectList());
						if(studentTranscriptCourse.getTransferCourse() != null && studentTranscriptCourse.getTransferCourse().getAceExhibitNo() != null && !studentTranscriptCourse.getTransferCourse().getAceExhibitNo().isEmpty()){
							tc.setAceExhibitNo(studentTranscriptCourse.getTransferCourse().getAceExhibitNo());
							//transferCourseService.addTransferCourse( tc );
							courseMgmtService.updateTransferCourse(tc);
						}else{
							//Do nothing Just added for sake of NULLPointer Exception...
						}	
						studentTranscriptList.add( studentTranscriptCourse );
					}
					}
				}
				CollegeProgram collegeProgram= studentService.getCollegeByPV(programVersionCode);
				if(collegeProgram!=null){
					studentInstitutionTranscript.setCollegeCode(collegeProgram.getCollegeCode());
				}
				transcriptService.saveMilitaryTranscriptsForStudentInstitutionTranscriptAsMarkComplete( studentInstitutionTranscript, studentTranscriptList ,oldStudentInstitutionTranscriptId);
		return "redirect:launchEvaluation.html?operation=getAllCoursesAndDegreesForStudentAndInstitute&studentId="+studentId+"&institutionId="+institutionId+"&institutionAddressId="+institutionAddressId;
	}
	@RequestMapping( params="operation=markRectifyMilitaryCourseToComplete" )
	public String markRectifyMilitaryCourseToComplete( StudentInstitutionTranscript studentInstitutionTranscript,
			@RequestParam(value="institutionId",required=false) String institutionId,@RequestParam(value="studentId",required=false) String studentId,@RequestParam(value="markCompleted",required=false) boolean markCompleted, 
			@RequestParam(value="institutionAddressId",required=false) String institutionAddressId,
			@RequestParam(value="programVersionCode") String programVersionCode,HttpServletRequest request, Model model  ) {
		
			StudentInstitutionTranscript sit = evaluationService.getStudentInstitutionTranscriptById(studentInstitutionTranscript.getId()); 
			
			Student  student  = studentService.getStudentById(studentId);
			//TODO:ALhaz
			studentInstitutionTranscript.setStudent(student);
			studentInstitutionTranscript.setMarkCompleted(markCompleted);
			studentInstitutionTranscript.setCreatedDate(sit.getCreatedDate());
			studentInstitutionTranscript.setDateReceived(sit.getDateReceived());
			studentInstitutionTranscript.setLastAttendenceDate(sit.getLastAttendenceDate());
			List<StudentTranscriptCourse> studentTranscriptList = new ArrayList<StudentTranscriptCourse>();
			
				Institution inst = institutionService.getInstitutionById(institutionId);
				if(institutionAddressId!=null && !institutionAddressId.equals("")){
					InstitutionAddress  institutionAddress = institutionService.getInstitutionAddress(institutionAddressId);
					studentInstitutionTranscript.setInstitutionAddress(institutionAddress!=null ? institutionAddress : null);
				}
				
				studentInstitutionTranscript.setInstitution(inst);
				
				List<StudentTranscriptCourse> studentTranscriptCourseList = studentInstitutionTranscript.getStudentTranscriptCourse();
				/**SART : Logic to get all Military course's Subject which are deleted by User and not rectified  
				 * */
				List<TranscriptCourseSubject> tcsubjectRejectedListForDeletion = new ArrayList<TranscriptCourseSubject>();
				
				if(studentTranscriptCourseList != null && !studentTranscriptCourseList.isEmpty()){
					for(StudentTranscriptCourse stc : studentTranscriptCourseList){
						List<TranscriptCourseSubject> trCourseSubjectList = stc.getTranscriptCourseSubjectList();
						List<TranscriptCourseSubject> transcriptCourseSubjectDbList =  transferCourseService.getAllTranscriptCourseSubjectByStudentTranscriptCourseId(stc.getId());
						if(transcriptCourseSubjectDbList != null && !transcriptCourseSubjectDbList.isEmpty()){
							for(TranscriptCourseSubject trDbCourseSubject : transcriptCourseSubjectDbList){
								boolean subjectIdFound = false;
								if(trCourseSubjectList != null && !trCourseSubjectList.isEmpty()){
									for(TranscriptCourseSubject transcriptCourseSubject : trCourseSubjectList){
										if(transcriptCourseSubject.getId() != null && !transcriptCourseSubject.getId().isEmpty()){
											if(transcriptCourseSubject.getId().equals(transcriptCourseSubject)){
												subjectIdFound = true;
												break;
											}
										}else{
											//TODO
										}
										
									}
								}
								if(subjectIdFound){
									continue;
								}else{
									tcsubjectRejectedListForDeletion.add(trDbCourseSubject);
								}
							}
						}						
					}
				}
				if(tcsubjectRejectedListForDeletion != null && tcsubjectRejectedListForDeletion.size()>0){
					transferCourseService.removeRejectedStudentTranscriptCourseSubjectMarkForDelection(tcsubjectRejectedListForDeletion);
				}
				/**END*/
				
				/**SART : Logic to get all courses which are deleted by User and not rectified  
				 * */
				List<StudentTranscriptCourse> stcRejectedListForDeletion = new ArrayList<StudentTranscriptCourse>();
				List<StudentTranscriptCourse> stcRejectedList = evaluationService.getAllRejectedSTCByUserForStudentAndInstitute(studentInstitutionTranscript.getId(),studentId,institutionId,UserUtil.getCurrentUser());
				if(stcRejectedList != null && !stcRejectedList.isEmpty()){
					for(StudentTranscriptCourse stcRejected : stcRejectedList){				
						boolean courseIdFound = false;
						if(studentTranscriptCourseList != null && !studentTranscriptCourseList.isEmpty()){
							for(StudentTranscriptCourse stc : studentTranscriptCourseList){			
								if(stc.getId() != null && !stc.getId().equals("")){
									if(stcRejected.getId().equals(stc.getId())){
										courseIdFound = true;
										break;								
									}
								}						
							}
						}
						if(courseIdFound){
							continue;
						}else{
							stcRejectedListForDeletion.add(stcRejected);
						}
					}
				}
				if(stcRejectedListForDeletion != null && stcRejectedListForDeletion.size()>0){
					transcriptService.removeRejectedStudentTranscriptCourseMarkForDelection(stcRejectedListForDeletion);
				}
				/**END : Logic to get all courses which are deleted by User and not rectified  
				 * */
				
				int j = 0;
				if(studentTranscriptCourseList!=null && studentTranscriptCourseList.size()>0){
					for (StudentTranscriptCourse studentTranscriptCourse : studentTranscriptCourseList) {		
						if(studentTranscriptCourse.getTrCourseId()!=null  &&  !studentTranscriptCourse.getTrCourseId().equals("")){						
						/*
						 * find the trCourseId in ss_tbl_transfer_course table
						 * If not found add new entry with evaluation_status set to 0
						 */ 
						TransferCourse tc = transferCourseService.getTransferCourseByCourseCodeAndInstitutionId(studentTranscriptCourse.getTrCourseId(), inst.getId());
						if( tc == null ) {
							tc = new TransferCourse();
							tc.setTrCourseCode( studentTranscriptCourse.getTrCourseId() );
							tc.setTrCourseTitle(studentTranscriptCourse.getTransferCourseTitle().getTitle());
							tc.setAceExhibitNo(studentTranscriptCourse.getTransferCourse().getAceExhibitNo());
							//tc.setTranscriptCredits(studentTranscriptCourse.getTransferCourse().getTranscriptCredits());
							//tc.setSemesterCredits(studentTranscriptCourse.getTransferCourse().getSemesterCredits());
							tc.setEvaluationStatus( TranscriptStatusEnum.NOTEVALUATED.getValue());						
							//tc.setSchoolCode( inst.getSchoolcode() );
							tc.setInstitution(inst);
							tc.setTrCourseTitle( studentTranscriptCourse.getTransferCourseTitle().getTitle() );
							//TODO::setting this to blank in order to use it later.
							tc.setInstitutionDegreeId("");						
							//transferCourseService.addTransferCourse( tc );
							TransferCourse tcCheckAgain = courseMgmtService.getTransferCourseByCodeAndInstitution(tc.getTrCourseCode(), tc.getInstitution().getId());
							if(tcCheckAgain == null){
								courseMgmtService.saveTransferCourse(tc);
							}else{
								courseMgmtService.updateTransferCourse(tc);
							}
						}
						else {/**If i rectify only the course_title not CourseCode then it must get updated into TransferCourse
								 irrespective of it's evaluation_status
						 		*/
							//if( tc.getEvaluationStatus().equalsIgnoreCase("NOT EVALUATED")){
								tc.setTrCourseTitle( studentTranscriptCourse.getTransferCourseTitle().getTitle() );
								if(studentTranscriptCourse.getTransferCourse() != null && studentTranscriptCourse.getTransferCourse().getAceExhibitNo() != null && !studentTranscriptCourse.getTransferCourse().getAceExhibitNo().isEmpty()){
									tc.setAceExhibitNo(studentTranscriptCourse.getTransferCourse().getAceExhibitNo());
								}else{
									//Do nothing Just added for sake of NULLPonter Exception...
								}
								
								//transferCourseService.saveTransferCourse( tc );
								courseMgmtService.updateTransferCourse(tc);
							//}						
						}
						
						//StudentTranscriptCourse st = new StudentTranscriptCourse();
						studentTranscriptCourse.setTrCourseId( studentTranscriptCourse.getTrCourseId()   );
						
						
						TransferCourseTitle tct = transferCourseService.getTransferCourseTitleByDate(studentTranscriptCourse.getCompletionDate(), tc.getId());
						if(tct==null){
							/** Just find-out the TransferCourseTitle irrespective of their evaluation status rather then NOTEVALUATED
							 *  
							tct = transferCourseService.getNotEvaluatedTransferCourseTitleByCourseIdAndTitle(tc.getId(), studentTranscriptCourse.getTransferCourseTitle().getTitle());*/
							tct = transferCourseService.getTransferCourseTitleByCourseIdAndTitle(tc.getId(), studentTranscriptCourse.getTransferCourseTitle().getTitle());
						}
						if(tct==null){
							tct= new TransferCourseTitle();
							tct.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
							tct.setTitle(studentTranscriptCourse.getTransferCourseTitle().getTitle());
							tct.setTransferCourseId(tc.getId());
							List<TransferCourseTitle> tctList = transferCourseService.getTransferCourseTitlesByTransferCourseId(tc.getId());
							if(tctList != null && !tctList.isEmpty()){
								tct.setEffective(false);
							}else{
								tct.setEffective(true);//setting it to true for default active
							}
							tct.setTransferCourseId(tc.getId());
							transferCourseService.addTransferCourseTitle(tct,tctList!= null && !tctList.isEmpty()?tctList.size():0);
						}
						
						j = j + 1;
						studentTranscriptCourse.setTransferCourseTitleId(tct.getId());
						//TODO:Not decided yet
						if(studentTranscriptCourse.getTranscriptStatus()!=null && !studentTranscriptCourse.getTranscriptStatus().equals("") && studentTranscriptCourse.getTranscriptStatus().equalsIgnoreCase(TranscriptStatusEnum.REJECTED.getValue())){
							studentTranscriptCourse.setId(studentTranscriptCourse.getId());
							studentTranscriptCourse.setCreatedBy(studentTranscriptCourse.getCreatedBy());
							
						}else{
							studentTranscriptCourse.setCreatedDate(new Date() );
							studentTranscriptCourse.setCreatedBy(UserUtil.getCurrentUser().getId());
						}
						String transcriptStatus = studentTranscriptCourse.getTranscriptStatus();
						if(transcriptStatus!=null && !transcriptStatus.isEmpty()){
							if(transcriptStatus.equalsIgnoreCase(TranscriptStatusEnum.REJECTED.getValue())){
								studentTranscriptCourse.setTranscriptStatus(tc.getTransferStatus());
							}else{
								studentTranscriptCourse.setTranscriptStatus(transcriptStatus);
							}
							
						}else{
							studentTranscriptCourse.setTranscriptStatus(TranscriptStatusEnum.PENDINGEVAL.getValue());
							
						}
						
						studentTranscriptCourse.setInstitution( inst );
						//studentTranscriptCourse.setCourseSequence( j );
						studentTranscriptCourse.setStudentInstitutionTranscript( studentInstitutionTranscript );
						
						studentTranscriptCourse.setCompletionDate( studentTranscriptCourse.getCompletionDate() );
						 
						
						
						studentTranscriptCourse.setGrade( studentTranscriptCourse.getGrade());
						
						
						if(tc.getEvaluationStatus().equalsIgnoreCase(TranscriptStatusEnum.EVALUATED.getValue()) && !studentTranscriptCourse.getTranscriptStatus().equalsIgnoreCase(TranscriptStatusEnum.REJECTED.getValue())){
							studentTranscriptCourse.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
						}else{
							//studentTranscriptCourse.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
							if(studentInstitutionTranscript.getOfficial()){
								studentTranscriptCourse.setEvaluationStatus(TranscriptStatusEnum.INPROGRESS.getValue());
							}else{
								studentTranscriptCourse.setEvaluationStatus(TranscriptStatusEnum.AWAITINGOFFICIAL.getValue());
							}
						}
						studentTranscriptCourse.setModifiedBy(UserUtil.getCurrentUser().getId());
						studentTranscriptCourse.setTransferCourseTitleId(tct.getId());
						
						studentTranscriptCourse.setTransferCourse( tc );
						studentTranscriptList.add( studentTranscriptCourse );
					}
					}
				}
				List<StudentInstitutionDegree> sids = new ArrayList<StudentInstitutionDegree>();	
				List<StudentInstitutionDegree> studentInstitutionDegreeList = studentInstitutionTranscript.getStudentInstitutionDegreeSet();				
				
				if(studentInstitutionDegreeList!=null && studentInstitutionDegreeList.size()>0){
					
					for(StudentInstitutionDegree studentInstitutionDegree : studentInstitutionDegreeList){
						
							//If the degree or GPA or completion date is blank, ignore and continue
							
							StudentInstitutionDegree sid = new StudentInstitutionDegree();
							if(studentInstitutionDegree.getInstitutionDegree() !=null){
								InstitutionDegree inid = institutionService.getInstitutionDegreeByInstituteIDAndDegreeName( institutionId, studentInstitutionDegree.getInstitutionDegree().getDegree() );
								if( inid == null ) {
									inid = new InstitutionDegree();
									inid.setDegree( studentInstitutionDegree.getInstitutionDegree().getDegree() );
									inid.setInstitution( inst );
								}
								sid.setInstitutionDegree( inid );
								sid.setMajor( studentInstitutionDegree.getMajor() );
								sid.setCompletionDate( studentInstitutionDegree.getCompletionDate() );
								sid.setGpa( studentInstitutionDegree.getGpa());
								sid.setStudentInstitutionTranscript(studentInstitutionTranscript);
								sids.add( sid );			
							
							}
					}
					
				}
				CollegeProgram collegeProgram= studentService.getCollegeByPV(programVersionCode);
				if(collegeProgram!=null){
					studentInstitutionTranscript.setCollegeCode(collegeProgram.getCollegeCode());
				}
				transcriptService.saveRejectedMilitaryTranscriptsForStudentInstitutionTranscriptAsMarkComplete( studentInstitutionTranscript, studentTranscriptList,sids );
		return "redirect:launchEvaluation.html?operation=getAllCoursesAndDegreesForStudentAndInstitute&studentId="+studentId+"&institutionId="+institutionId+"&institutionAddressId="+institutionAddressId;
	}
}

	

