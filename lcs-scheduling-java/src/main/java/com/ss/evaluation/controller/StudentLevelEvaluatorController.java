package com.ss.evaluation.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ss.common.logging.RequestContext;
import com.ss.common.util.StudentProgramInfo;
import com.ss.common.util.UserUtil;
import com.ss.course.service.CourseMgmtService;
import com.ss.course.value.CourseCategoryMapping;
import com.ss.course.value.CourseMapping;
import com.ss.course.value.MilitarySubject;
import com.ss.course.value.TransferCourse;
import com.ss.evaluation.dao.CourseIdCreditsMapDto;
import com.ss.evaluation.dto.StudentTransferCredits;
import com.ss.evaluation.dto.TranscriptTransferCreditsDTO;
import com.ss.evaluation.dto.TrnscrptCrseSbjctIdCrdtsTrnsfrDto;
import com.ss.evaluation.enums.TranscriptStatusEnum;
import com.ss.evaluation.service.EvaluationService;
import com.ss.evaluation.service.StudentService;
import com.ss.evaluation.service.TranscriptCommentService;
import com.ss.evaluation.service.TranscriptService;
import com.ss.evaluation.service.TransferCourseService;
import com.ss.evaluation.util.CreditSplitParserUtil;
import com.ss.evaluation.value.Student;
import com.ss.evaluation.value.StudentInstitutionDegree;
import com.ss.evaluation.value.StudentInstitutionTranscript;
import com.ss.evaluation.value.StudentProgramEvaluation;
import com.ss.evaluation.value.StudentTranscriptCourse;
import com.ss.evaluation.value.TranscriptCourseSubject;
import com.ss.institution.service.InstitutionService;
import com.ss.institution.service.InstitutionTermTypeService;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionTermType;
import com.ss.messaging.service.JMSMessageSenderService;

/**
 * Controller for operations for evaluating courses.
 * 
 * @author binoy.mathew
 */
@Controller
@RequestMapping("/evaluation/studentEvaluator.html")
public class StudentLevelEvaluatorController {

	private static transient Logger log = LoggerFactory.getLogger(StudentLevelEvaluatorController.class);

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
	private StudentService studentService;

	@Autowired
	private CourseMgmtService courseMgmtService;

	@Autowired
	private TranscriptCommentService transcriptCommentService;

	@Autowired
	private JMSMessageSenderService jmsSenderService;

	/**
	 * The initial screen for evaluating transcripts for a Student Level
	 * Evaluator.
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(params = "operation=initEvaluatorParams")
	public String initEvaluationForStudentLevelEvaluator(Model model) {

		// Old StudentInstitutionTranscript studentInstitutionTranscript =
		// evaluationService.getStudentInstitutionTranscriptForSLE();
		StudentInstitutionTranscript studentInstitutionTranscript = evaluationService.getStudentInstitutionTranscriptForSLE(UserUtil.getCurrentUser().getId());

		if (studentInstitutionTranscript != null) {
			List<StudentTranscriptCourse> studentTranscriptCourseList = transcriptService.getStudentTranscriptCoursesByTranscriptId(
				studentInstitutionTranscript.getId(), studentInstitutionTranscript.getInstitution().getId());
			// StudentProgramEvaluation studentProgramEvaluation =
			// studentInstitutionTranscript.getStudent();

			List<TransferCourse> courseList = evaluationService.getAllTransferCourseByInstitutionId(studentInstitutionTranscript.getInstitution().getId());

			// Set the transient field Course Title into the Student Transcript
			if (studentTranscriptCourseList != null && studentTranscriptCourseList.size() > 0) {
				TransferCourse transferCourse = null;
				for (StudentTranscriptCourse studentTranscript : studentTranscriptCourseList) {
					transferCourse = transferCourseService.getTransferCourseByCourseCodeAndInstitutionId(studentTranscript.getTrCourseId(), studentTranscript
						.getInstitution().getId());
					studentTranscript.setCourseTitle(transferCourse.getTrCourseTitle());
				}
			}

			// Build the StudentInstitutionDegree list.
			List<StudentInstitutionDegree> sidList = transcriptService
				.getStudentInstitutionDegreeListForStudentInstitutionTranscript(studentInstitutionTranscript.getId());

			// Build StudentProgramInfo
			StudentProgramInfo courseInfo = new StudentProgramInfo();
			/*
			 * courseInfo.setStudentCrmId(
			 * studentProgramEvaluation.getStudentId() );
			 * courseInfo.setProgramVersionCode(
			 * studentProgramEvaluation.getProgramVersionCode() );
			 * courseInfo.setCatalogCode(
			 * studentProgramEvaluation.getCatalogCode() );
			 * courseInfo.setStateCode( studentProgramEvaluation.getStateCode()
			 * ); courseInfo.setExpectedStartDate(
			 * studentProgramEvaluation.getExpectedStartDate() );
			 * courseInfo.setProgramDesc
			 * (studentProgramEvaluation.getProgramDescription());
			 */
			model.addAttribute("courseInfo", courseInfo);
			model.addAttribute("courseList", courseList);
			model.addAttribute("studentTranscriptCourseList", studentTranscriptCourseList);
			model.addAttribute("selectedInstitution", studentInstitutionTranscript.getInstitution());
			model.addAttribute("studentInstitutionDegreeList", sidList);
			model.addAttribute("studentInstitutionTranscript", studentInstitutionTranscript);
			// model.addAttribute( "studentProgramEvaluation",
			// studentProgramEvaluation );
			model.addAttribute("studentProgramEvaluation", "");
			model.addAttribute("transcriptDataAvailable", true);
			model.addAttribute("displayTransferCoursesBlock", true);

		} else {
			model.addAttribute("transcriptDataAvailable", false);
		}

		return "launchStudentLevelEvaluation";
	}

	@RequestMapping(params = "operation=approveSITForSLE")
	public String approveSITForSLE(Model model, @RequestParam("studentInstitutionTranscriptId") String studentInstitutionTranscriptId,
		@RequestParam(value = "courseMappingIdsToMap", required = false) String courseMappingIds,
		@RequestParam(value = "courseCategoryMappingIdsToMap", required = false) String courseCategoryMappingIdsToMap,
		@RequestParam(value = "creditTransfer", required = false) String creditTransfer) {

		StudentInstitutionTranscript sit = evaluationService.getStudentInstitutionTranscriptById(studentInstitutionTranscriptId);
		sit.setEvaluationStatus(TranscriptStatusEnum.EVALUATEDOFFICIAL.getValue());
		evaluationService.saveStudentInstitutionTranscript(sit);
		TranscriptTransferCreditsDTO transcriptTransferCreditsDTO = new TranscriptTransferCreditsDTO();
		transcriptTransferCreditsDTO.setStudentInstitutionTranscript(sit);
		CreditSplitParserUtil creditSplitParserUtil = new CreditSplitParserUtil();
		try {
			List<CourseIdCreditsMapDto> courseMappingsList = creditSplitParserUtil.getCrsesWithCrdtsToTrnsfrInfo(courseMappingIds,
				courseCategoryMappingIdsToMap, creditTransfer, isMilitaryTranscript(sit));
			if (!isMilitaryTranscript(sit)) {
				log.info(courseMappingsList.toString());
				// TODO:Need to retrieve all the studentTranscriptCourses in a single Call to the database
				for (CourseIdCreditsMapDto ccmDto : courseMappingsList) {
					StudentTransferCredits studentTransferCredits = new StudentTransferCredits();
					StudentTranscriptCourse studentTranscriptCourse = transcriptService.getTranscriptById(ccmDto.getStudentTranscriptCourseId());
					if ("Course".equalsIgnoreCase(ccmDto.getMappingType()) && studentTranscriptCourse != null) {
						if (sit.getInstitution() != null && sit.getInstitution().getInstitutionType() != null) {
							studentTranscriptCourse.setCourseMappingId(ccmDto.getMappingId());
							studentTranscriptCourse.setTransferCredit(ccmDto.getTotalCreditsToTransferInFloat());
							studentTransferCredits.setTransferCreditSplitList(ccmDto.getGcuCrseCrdsToTrnsList());
						}
					} else if ("Category".equalsIgnoreCase(ccmDto.getMappingType()) && studentTranscriptCourse != null) {
						if (sit.getInstitution() != null && sit.getInstitution().getInstitutionType() != null) {
							studentTranscriptCourse.setCourseCategoryMappingId(ccmDto.getMappingId());
							float creditsToTransfer = ccmDto.getTotalCreditsToTransferInFloat();
							studentTranscriptCourse.setTransferCredit(creditsToTransfer);
							studentTransferCredits.addSLECourseCreditSplitInfo(null, creditsToTransfer, ccmDto.getMappingId());
  						}
					}
					transcriptService.putTranscript(studentTranscriptCourse);
					studentTransferCredits.setStudentTranscriptCourse(studentTranscriptCourse);
					transcriptTransferCreditsDTO.addStudentTransfercredits(studentTransferCredits);
				}

			} else {
				List<TrnscrptCrseSbjctIdCrdtsTrnsfrDto> militaryDtoList = creditSplitParserUtil.getCreditsToTransferMapForMilitary(creditTransfer);
				List<String> uniqueStcList = getUniqueStudentTranscriptcourseIds(courseMappingsList);
				for (String stdTrnscrptCrsId : uniqueStcList) {
					float totalCreditsTransfer = 0.0f;
					StudentTranscriptCourse studentTranscriptCourse = transcriptService.getTranscriptById(stdTrnscrptCrsId);
					List<TranscriptCourseSubject> tcsList = transferCourseService.getAllTranscriptCourseSubjectByStudentTranscriptCourseId(stdTrnscrptCrsId);
					for (TranscriptCourseSubject tcs : tcsList) {
						StudentTransferCredits studentTransferCredits = new StudentTransferCredits();
						String courseCategoryMappingId = getCategoryIdForTCS(tcs, courseMappingsList);
						tcs.setCategoryId(courseCategoryMappingId);
						float creditsToTransfer = getTransferCreditForTCS(tcs, militaryDtoList);
						tcs.setTransferCredit(creditsToTransfer);
						totalCreditsTransfer = totalCreditsTransfer + creditsToTransfer;
						studentTransferCredits.setMilitaryTransacriptCredit(true);
 						studentTransferCredits.addSLECourseCreditSplitInfo(null, creditsToTransfer,courseCategoryMappingId);
						studentTransferCredits.setStudentTranscriptCourse(studentTranscriptCourse);
						transcriptTransferCreditsDTO.addStudentTransfercredits(studentTransferCredits);
 					}
					transferCourseService.updateAllTranscriptCourseSubjects(tcsList);
					studentTranscriptCourse.setTransferCredit(totalCreditsTransfer);
					transcriptService.putTranscript(studentTranscriptCourse);
				}
			}
			//Initiate the transfer Credits data to CampusVue
			jmsSenderService.sendTransferCreditsToCampusVue(transcriptTransferCreditsDTO);
		} catch (Exception e) {
			// Silently ignoring exceptions --Need to replace with an email on
			// error
			String errorMessage = String.format("Exception Occured while Approving the Transcript, Id:%s ReferenceId:%s", studentInstitutionTranscriptId,
				RequestContext.getRequestIdFromContext());
			log.error(errorMessage, e);
		}
		return "redirect:studentEvaluator.html?operation=launchTranscriptForSLEForEvaluation";
	}

	/**
	 * Returns the transfer credit for the TransferCourseSubject after
	 * traversing TrnscrptCrseSbjctIdCrdtsTrnsfrDto and when the
	 * transcriptCourseSubject matches
	 * 
	 * @param tcs
	 * @param militaryDtoList
	 * @return
	 */
	private float getTransferCreditForTCS(TranscriptCourseSubject tcs, List<TrnscrptCrseSbjctIdCrdtsTrnsfrDto> militaryDtoList) {
		String transcriptCourseSubjectId = tcs.getId();
		for (TrnscrptCrseSbjctIdCrdtsTrnsfrDto dto : militaryDtoList) {
			if (transcriptCourseSubjectId.equals(dto.getTranscriptCourseSubjectId())) {
				return dto.getCreditsToTransferInFloat();
			}
		}
		return 0;
	}

	/**
	 * Returns the CategoryId that matches the subjectId for the
	 * TranscriptCourseSubject
	 * 
	 * @param tcs
	 * @param courseMappingsList
	 * @return
	 */
	private String getCategoryIdForTCS(TranscriptCourseSubject tcs, List<CourseIdCreditsMapDto> courseMappingsList) {
		String subjectId = tcs.getSubjectId();
		String studentTranscriptCourseId = tcs.getTranscriptCourseId();
		for (CourseIdCreditsMapDto ccmDto : courseMappingsList) {
			if (subjectId.equals(ccmDto.getMilitarySubjectId()) && studentTranscriptCourseId.equals(ccmDto.getStudentTranscriptCourseId())) {
				return ccmDto.getMappingId();
			}
		}
		return null;
	}

	/**
	 * From the list of CourseIdCreditsMapDto objects returns list with unique
	 * StudentTranscriptCourseIds
	 * 
	 * @param courseMappingsList
	 * @return
	 */
	private List<String> getUniqueStudentTranscriptcourseIds(List<CourseIdCreditsMapDto> courseMappingsList) {
		Set<String> uniqueSTCids = new HashSet<String>();
		for (CourseIdCreditsMapDto ccmDto : courseMappingsList) {
			uniqueSTCids.add(ccmDto.getStudentTranscriptCourseId());
		}
		return new ArrayList<String>(uniqueSTCids);
	}

	/**
	 * Retursn true if the passed StudentInstitutionTranscript is a military
	 * Transcript
	 * 
	 * @param sit
	 * @return
	 */
	private boolean isMilitaryTranscript(StudentInstitutionTranscript sit) {
		if (sit != null && sit.getInstitution().getInstitutionType().getId().equals("5")) {
			return true;
		}
		return false;
	}

	@RequestMapping(params = "operation=disapproveSITForSLE")
	public String disapproveSITForSLE(Model model, @RequestParam("studentInstitutionTranscriptId") String studentInstitutionTranscriptId,
		@RequestParam("errorCourseIds") String errorCourseIds, @RequestParam("errorInInstitution") Boolean errorInInstitution,
		@RequestParam("comment") String comment) {
		StudentInstitutionTranscript sit = evaluationService.getStudentInstitutionTranscriptById(studentInstitutionTranscriptId);
		String[] errorCourseIdArray = null;
		if (errorCourseIds != null && !errorCourseIds.isEmpty()) {
			errorCourseIdArray = errorCourseIds.split(",");

			for (String errorCourseId : errorCourseIdArray) {
				StudentTranscriptCourse stc = transcriptService.getTranscriptById(errorCourseId);
				stc.setTranscriptStatus("REJECTED");
				transcriptService.putTranscript(stc);
			}
		}
		// case when the Institution information is also marked as error by
		// lopes
		if (errorInInstitution) {
			sit.setEvaluationStatus("REJECTED INSTITUTION");
		}
		// case when the not institution but the courses are marked as error
		else if (errorCourseIds != null) {
			sit.setEvaluationStatus("REJECTED");
		}
		sit.setLopeComment(comment);
		evaluationService.saveStudentInstitutionTranscript(sit);

		return "redirect:studentEvaluator.html?operation=initEvaluatorParams";

	}

	/**
	 * The initial screen for evaluating transcripts for a Student Level
	 * Evaluator.
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(params = { "operation=launchEvaluationHome" })
	public String launchEvaluationHomeForEvaluator(@RequestParam("programVersionCode") String programVersionCode,
		@RequestParam("studentCrmId") String studentCrmId, HttpServletRequest request, Model model) {

		StudentProgramEvaluation studentProgramEvaluation = evaluationService.getEvaluationForStudentCrmIdAndProgramCode(studentCrmId, programVersionCode);
		StudentProgramInfo courseInfo = null;
		if (studentProgramEvaluation != null) {

			courseInfo = new StudentProgramInfo();
			courseInfo.setStudentCrmId(studentProgramEvaluation.getStudentId());
			courseInfo.setProgramVersionCode(studentProgramEvaluation.getProgramVersionCode());
			courseInfo.setProgramDesc(studentProgramEvaluation.getProgramDescription());
			courseInfo.setCatalogCode(studentProgramEvaluation.getCatalogCode());
			courseInfo.setStateCode(studentProgramEvaluation.getStateCode());
			courseInfo.setExpectedStartDate(studentProgramEvaluation.getExpectedStartDate());

			List<StudentInstitutionTranscript> transcriptList = evaluationService
				.getLatestStudentInstitutionTranscriptForStudentProgramEval(studentProgramEvaluation);
			model.addAttribute("transcriptList", transcriptList);
			model.addAttribute("studentProgramEvaluation", studentProgramEvaluation);
			model.addAttribute("transcriptDataAvailable", true);
			model.addAttribute("displayTranscriptListing", true);
			model.addAttribute("courseInfo", courseInfo);
		}

		return "studentEvaluatorHome";
	}

	@RequestMapping(params = "operation=getCoursesForStudentTranscript")
	public String getCoursesForStudentTranscript(@RequestParam("studentInstitutionTranscriptId") String studentInstitutionTranscriptId,
		@RequestParam("institutionId") String institutionId, Model model, HttpServletRequest request) {

		StudentInstitutionTranscript studentInstitutionTranscript = evaluationService.getStudentInstitutionTranscriptById(studentInstitutionTranscriptId);
		List<StudentTranscriptCourse> studentTranscriptCourseList = transcriptService.getStudentTranscriptCoursesByTranscriptId(studentInstitutionTranscriptId,
			institutionId);
		// StudentProgramEvaluation studentProgramEvaluation =
		// studentInstitutionTranscript.getStudent();

		List<TransferCourse> courseList = evaluationService.getAllTransferCourseByInstitutionId(studentInstitutionTranscript.getInstitution().getId());

		// Set the transient field Course Title into the Student Transcript
		if (studentTranscriptCourseList != null && studentTranscriptCourseList.size() > 0) {
			TransferCourse transferCourse = null;
			for (StudentTranscriptCourse studentTranscript : studentTranscriptCourseList) {
				transferCourse = transferCourseService.getTransferCourseByCourseCodeAndInstitutionId(studentTranscript.getTrCourseId(), studentTranscript
					.getInstitution().getId());
				studentTranscript.setCourseTitle(transferCourse.getTrCourseTitle());
			}
		}

		// Build the StudentInstitutionDegree list.
		List<StudentInstitutionDegree> sidList = transcriptService
			.getStudentInstitutionDegreeListForStudentInstitutionTranscript(studentInstitutionTranscriptId);

		// Build StudentProgramInfo
		StudentProgramInfo courseInfo = new StudentProgramInfo();
		/*
		 * courseInfo.setStudentCrmId( studentProgramEvaluation.getStudentId()
		 * ); courseInfo.setProgramVersionCode(
		 * studentProgramEvaluation.getProgramVersionCode() );
		 * courseInfo.setCatalogCode( studentProgramEvaluation.getCatalogCode()
		 * ); courseInfo.setStateCode( studentProgramEvaluation.getStateCode()
		 * ); courseInfo.setExpectedStartDate(
		 * studentProgramEvaluation.getExpectedStartDate() );
		 * courseInfo.setProgramDesc
		 * (studentProgramEvaluation.getProgramDescription());
		 */
		// figure out institutionTerm Type : first degree in the list considered
		// for date comparison
		InstitutionTermType institutionTermType = null;
		List<InstitutionTermType> instTermTypeList = institutionTermTypeService.getAllInstitutionTermType(institutionId);
		Date degreeDate = sidList.get(0).getCompletionDate();

		for (InstitutionTermType termType : instTermTypeList) {
			if (termType.getEffectiveDate() != null && termType.getEndDate() != null) {
				if (degreeDate.after(termType.getEffectiveDate()) && degreeDate.before(termType.getEndDate())) {
					institutionTermType = termType;
				}
			}
		}

		model.addAttribute("courseInfo", courseInfo);
		model.addAttribute("courseList", courseList);
		model.addAttribute("studentTranscriptCourseList", studentTranscriptCourseList);
		model.addAttribute("selectedInstitution", studentInstitutionTranscript.getInstitution());
		model.addAttribute("studentInstitutionDegreeList", sidList);
		model.addAttribute("studentInstitutionTranscript", studentInstitutionTranscript);
		// model.addAttribute( "studentProgramEvaluation",
		// studentProgramEvaluation );
		model.addAttribute("studentProgramEvaluation", "");
		model.addAttribute("transcriptDataAvailable", true);
		model.addAttribute("displayTransferCoursesBlock", true);
		model.addAttribute("userRole", UserUtil.getCurrentRole());
		model.addAttribute("institutionTermType", institutionTermType);
		return "studentEvaluatorHome";
	}

	@RequestMapping(params = "operation=launchTranscriptForSLEForEvaluation")
	public String launchTranscriptForSLEForEvaluation(Model model) {
		// getNextTranscriptHavingCourses(null,model);
		StudentInstitutionTranscript studentInstitutionTranscript = null;
		List<StudentInstitutionTranscript> sitSummaryListForSLE = new ArrayList<StudentInstitutionTranscript>();
		List<StudentInstitutionTranscript> studentInstitutionTranscriptList = evaluationService.getStudentInstitutionTranscriptListForSLE(UserUtil
			.getCurrentUser().getId());

		if (studentInstitutionTranscriptList != null && !studentInstitutionTranscriptList.isEmpty()) {
			for (StudentInstitutionTranscript sit1 : studentInstitutionTranscriptList) {

				if (sit1 != null) {
					List<StudentInstitutionTranscript> studentInstitutionTranscriptListForSLE = evaluationService.getAllTranscriptForStudentAndInstitute(sit1
						.getStudent().getId(), sit1.getInstitution().getId(), true, TranscriptStatusEnum.AWAITINGSLE.getValue());
					for (StudentInstitutionTranscript sit : studentInstitutionTranscriptListForSLE) {
						if (evaluationService.isTranscriptEligibleForLOPESOrSLEForEvaluation(sit)) {
							// Adding only the Transcript for which the
							// institute and its all courses are marked as
							// EVALUATED
							if (sit != null && sit.getInstitutionAddress() != null && !sit.getInstitutionAddress().equals("") && sit.getInstitution() != null) {
								sit.getInstitution().setAddresses(institutionService.getInstitutionAddresses(sit.getInstitution().getId()));
							}
							sitSummaryListForSLE.add(sit);
							sit.setCreatedBy(sit.getCreatedBy());
							sit.setModifiedBy(sit.getModifiedBy());
							sit.setCreatedDate(sit.getCreatedDate());
							sit.setModifiedDate(sit.getModifiedDate());
							sit.setOccupyById(UserUtil.getCurrentUser().getId());
							evaluationService.saveStudentInstitutionTranscript(sit);

						}

					}

				}
				if (sitSummaryListForSLE != null && !sitSummaryListForSLE.isEmpty()) {
					break;
				}
			}
		}

		if (sitSummaryListForSLE != null && !sitSummaryListForSLE.isEmpty()) {
			studentInstitutionTranscript = sitSummaryListForSLE.get(0);

			// Build the StudentInstitutionDegree list.
			List<StudentInstitutionDegree> sidList = transcriptService
				.getStudentInstitutionDegreeListForStudentInstitutionTranscript(studentInstitutionTranscript.getId());

			// Build StudentProgramInfo
			Student studentFromDB = studentService.getStudentById(studentInstitutionTranscript.getStudent().getId());
			Student studentFromCRM = null;
			// we are using INQUIRY ID so we should get only 1 record back.
			StudentProgramInfo courseInfo = null;
			try {
				studentFromCRM = getStudentInfoFromCRMbyInquiryId(studentFromDB);
				// set the student DatabaseId
				studentFromCRM.setId(studentFromDB.getId());
				courseInfo = studentService.getActiveStudentProgramInformation(studentFromDB);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			for (StudentInstitutionTranscript sit : sitSummaryListForSLE) {
				if (sit.getStudentTranscriptCourse() != null && sit.getStudentTranscriptCourse().size() > 0) {
					for (StudentTranscriptCourse stc : sit.getStudentTranscriptCourse()) {
						List<CourseMapping> courseMappingList = courseMgmtService.getCourseMappingByTransferCourseId(stc.getTransferCourse().getId());
						if (courseMappingList != null && !courseMappingList.isEmpty()) {
							stc.setCourseMappingList(courseMappingList);
						} else {
							List<CourseCategoryMapping> courseCategoryMappingList = courseMgmtService.getCourseCategoryMappingByTransferCourseId(stc
								.getTransferCourse().getId());
							if (courseCategoryMappingList != null && !courseCategoryMappingList.isEmpty()) {
								stc.setCourseCategoryMappingList(courseCategoryMappingList);
							}
						}
					}
					sit.setTranscriptCommentsList(transcriptCommentService.getTranscriptComment(sit.getId()));
				}
			}

			model.addAttribute("courseInfo", courseInfo);
			model.addAttribute("student", studentFromCRM);
			model.addAttribute("selectedInstitution", studentInstitutionTranscript.getInstitution());
			model.addAttribute("studentInstitutionDegreeList", sidList);
			model.addAttribute("studentInstitutionTranscript", studentInstitutionTranscript);
			// model.addAttribute( "studentProgramEvaluation",
			// studentProgramEvaluation );
			model.addAttribute("studentProgramEvaluation", "");

			model.addAttribute("sitSummaryListForSLE", sitSummaryListForSLE);
			boolean transcriptCourseFound = false;
			for (StudentInstitutionTranscript sit : sitSummaryListForSLE) {
				if (sit.getStudentTranscriptCourse() != null && sit.getStudentTranscriptCourse().size() > 0) {
					transcriptCourseFound = true;
					break;
				}
			}
			if (!transcriptCourseFound) {
				model.addAttribute("transcriptDataAvailable", false);
			} else {
				model.addAttribute("transcriptDataAvailable", true);
			}
		} else {
			model.addAttribute("transcriptDataAvailable", false);
		}
		return "launchTranscriptForSLEAndLOPES";
	}

	@RequestMapping(params = "operation=disapproveSITForSLEAndLOPES")
	public String disapproveSITForSLEAndLOPES(Model model, @RequestParam("studentInstitutionTranscriptId") String studentInstitutionTranscriptIds,
		@RequestParam("errorCourseIds") String errorCourseIds, @RequestParam("errorInInstitution") Boolean errorInInstitution,
		@RequestParam("comment") String comment, @RequestParam(value = "errorCourseSubjectIds", required = false) String errorCourseSubjectIds) {

		boolean official = false;
		if (studentInstitutionTranscriptIds != null && !studentInstitutionTranscriptIds.isEmpty()) {
			String[] errorstudentInstitutionTranscriptIds = studentInstitutionTranscriptIds.split(",");

			for (String studentInstitutionTranscriptId : errorstudentInstitutionTranscriptIds) {
				if (studentInstitutionTranscriptId != null && !studentInstitutionTranscriptId.isEmpty()) {

					StudentInstitutionTranscript sit = evaluationService.getStudentInstitutionTranscriptById(studentInstitutionTranscriptId);
					String[] errorCourseIdArray = null;
					String[] errorCourseSubjectIdArray = null;
					if (errorCourseIds != null && !errorCourseIds.isEmpty()) {
						errorCourseIdArray = errorCourseIds.split(",");
						if (errorCourseIdArray != null && errorCourseIdArray.length != 0) {
							for (String errorCourseId : errorCourseIdArray) {
								if (errorCourseId != null && !errorCourseId.isEmpty()) {
									StudentTranscriptCourse stc = transcriptService.getTranscriptById(errorCourseId);
									stc.setTranscriptStatus("REJECTED");
									stc.setModifiedDate(new Date());
									transcriptService.putTranscript(stc);
									if (errorCourseSubjectIds != null && !errorCourseSubjectIds.isEmpty()) {
										errorCourseSubjectIdArray = errorCourseSubjectIds.split(",");
										if (errorCourseSubjectIdArray != null && errorCourseSubjectIdArray.length != 0) {
											for (String errorCourseSubjectId : errorCourseSubjectIdArray) {
												String courseSubjectIdArr[] = errorCourseSubjectId.split("<>");
												if (courseSubjectIdArr[0] != null && !courseSubjectIdArr[0].isEmpty() && courseSubjectIdArr[1] != null
													&& !courseSubjectIdArr[1].isEmpty()) {
													if (stc.getId().equals(courseSubjectIdArr[0])) {
														TranscriptCourseSubject transcriptCourseSubject = transferCourseService
															.getTranscriptCourseSubjectByTranscriptCourseIdAndSubjectId(courseSubjectIdArr[1],
																courseSubjectIdArr[0]);
														if (transcriptCourseSubject != null) {
															transcriptCourseSubject.setTranscriptStatus(TranscriptStatusEnum.REJECTED.getValue());
															transferCourseService.addOrUpdateTranscriptCourseSubject(transcriptCourseSubject);
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
					// case when the Institution information is also marked as
					// error by lopes
					if (errorInInstitution) {
						sit.setEvaluationStatus("REJECTED INSTITUTION");
					}
					// case when the not institution but the courses are marked
					// as error
					else if (errorCourseIds != null) {
						sit.setEvaluationStatus("REJECTED");
					}
					if (sit.getOfficial()) {
						official = true;
						sit.setSleComment(comment);
					} else {
						sit.setLopeComment(comment);
					}
					sit.setModifiedDate(new Date());
					evaluationService.saveStudentInstitutionTranscript(sit);
				}

			}
		}
		if (official) {
			return "redirect:studentEvaluator.html?operation=launchTranscriptForSLEForEvaluation";
		} else {
			return "redirect:/evaluation/launchEvaluation.html?operation=launchTranscriptForLOPESForEvaluation";
		}

	}

	/*
	 * public void getNextTranscriptHavingCourses(String transcriptIds,Model
	 * model){ List<StudentInstitutionTranscript> sitSummaryListForSLE = new
	 * ArrayList<StudentInstitutionTranscript>(); StudentInstitutionTranscript
	 * studentInstitutionTranscript = null ; studentInstitutionTranscript =
	 * evaluationService
	 * .getOldestStudentInstitutionTranscriptAlreadyOccupyByUser
	 * (UserUtil.getCurrentUser
	 * ().getId(),TranscriptStatusEnum.AWAITINGSLE.getValue());
	 * if(studentInstitutionTranscript != null){
	 * 
	 * }else{ studentInstitutionTranscript =
	 * evaluationService.getStudentInstitutionTranscriptForSLE(); }
	 * if(studentInstitutionTranscript!=null){
	 * checkIfCourseExistInTranscript(studentInstitutionTranscript,null,model);
	 * 
	 * }else{ model.addAttribute( "transcriptDataAvailable", false ); } }
	 * private void checkIfCourseExistInTranscript(StudentInstitutionTranscript
	 * studentInstitutionTranscript,String transcriptIds,Model model){
	 * if(studentInstitutionTranscript!=null){
	 * List<StudentInstitutionTranscript> sitSummaryListForSLE = new
	 * ArrayList<StudentInstitutionTranscript>();
	 * List<StudentInstitutionTranscript> studentInstitutionTranscriptListForSLE
	 * = evaluationService.getAllTranscriptForStudentAndInstitute(
	 * studentInstitutionTranscript
	 * .getStudent().getId(),studentInstitutionTranscript
	 * .getInstitution().getId(
	 * ),true,TranscriptStatusEnum.AWAITINGSLE.getValue());
	 * for(StudentInstitutionTranscript sit:
	 * studentInstitutionTranscriptListForSLE){ if
	 * (evaluationService.isTranscriptEligibleForLOPESOrSLEForEvaluation(sit)){
	 * //Adding only the Transcript for which the institute and its all courses
	 * are marked as EVALUATED if(sit.getStudentTranscriptCourse() != null &&
	 * sit.getStudentTranscriptCourse().size()>0){
	 * sit.setOccupyById(UserUtil.getCurrentUser().getId());
	 * sit.setCreatedDate(sit.getCreatedDate());
	 * sit.setModifiedDate(sit.getModifiedDate());
	 * sit.setCreatedBy(sit.getCreatedBy());
	 * sit.setModifiedBy(sit.getModifiedBy());
	 * sit.setLastDateForLastCourse(sit.getLastAttendenceDate());
	 * sit.setEvaluationStatus(sit.getEvaluationStatus());
	 * sit.setOfficial(sit.getOfficial());
	 * sit.setStudentInstitutionDegreeSet(sit.getStudentInstitutionDegreeSet());
	 * sit.setStudentTranscriptCourse(sit.getStudentTranscriptCourse());
	 * if(sit.getInstitutionAddress()!=null &&
	 * !sit.getInstitutionAddress().equals("")){
	 * sit.getInstitution().setInstitutionAddress(sit.getInstitutionAddress());
	 * } evaluationService.saveStudentInstitutionTranscript(sit); }
	 * sitSummaryListForSLE.add(sit); } } boolean transcriptCourseFound = false;
	 * for(StudentInstitutionTranscript sit: sitSummaryListForSLE){
	 * if(sit.getStudentTranscriptCourse()!=null &&
	 * sit.getStudentTranscriptCourse().size()>0){ transcriptCourseFound = true;
	 * break; } } if(!transcriptCourseFound){ studentInstitutionTranscript =
	 * evaluationService
	 * .getNextOldestStudentInstitutionTranscriptAlreadyOccupyByUser
	 * (studentInstitutionTranscript.getCreatedDate(),
	 * transcriptIds!=null?transcriptIds:studentInstitutionTranscript.getId());
	 * if(transcriptIds !=null && !transcriptIds.equals("")){ transcriptIds =
	 * transcriptIds + "'"+studentInstitutionTranscript.getId()+"'"; }
	 * checkIfCourseExistInTranscript
	 * (studentInstitutionTranscript,transcriptIds,model); model.addAttribute(
	 * "transcriptDataAvailable", false ); }else{ model.addAttribute(
	 * "transcriptDataAvailable", true ); } //Build the StudentInstitutionDegree
	 * list. List<StudentInstitutionDegree> sidList = transcriptService.
	 * getStudentInstitutionDegreeListForStudentInstitutionTranscript(
	 * studentInstitutionTranscript.getId() );
	 * 
	 * //Build StudentProgramInfo Student student =
	 * studentService.getStudentById
	 * (studentInstitutionTranscript.getStudent().getId()); StudentProgramInfo
	 * courseInfo =
	 * studentService.getStudentProgramInformation(student.getCrmId()).get(0);
	 * model.addAttribute( "courseInfo" , courseInfo ); model.addAttribute(
	 * "selectedInstitution", studentInstitutionTranscript.getInstitution() );
	 * model.addAttribute( "studentInstitutionDegreeList", sidList );
	 * model.addAttribute( "studentInstitutionTranscript",
	 * studentInstitutionTranscript ); //model.addAttribute(
	 * "studentProgramEvaluation", studentProgramEvaluation );
	 * model.addAttribute( "studentProgramEvaluation", "" );
	 * 
	 * model.addAttribute("sitSummaryListForSLE", sitSummaryListForSLE); }else{
	 * model.addAttribute( "transcriptDataAvailable", false ); } }
	 */
	/**
	 * Makes a search call to the student search operation by Inquiry The
	 * response will always be 1 or zero as InquiryId is a unique Id
	 * 
	 * @param student
	 * @return
	 * @throws Exception
	 */
	private Student getStudentInfoFromCRMbyInquiryId(Student student) throws Exception {
		List<Student> students = studentService.searchStudent(student);
		if (students.size() > 0) {
			return students.get(0);
		}
		return student;
	}
}
