package com.ss.evaluation.service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ss.common.util.StudentProgramInfo;
import com.ss.evaluation.dao.StudentDAO;
import com.ss.evaluation.service.client.StudentSearchClient;
import com.ss.evaluation.service.model.ProgramOfStudy;
import com.ss.evaluation.service.model.ProgramOfStudyResponse;
import com.ss.evaluation.service.model.StudentSearchResponse;
import com.ss.evaluation.service.model.StudentSearchResult;
import com.ss.evaluation.value.CollegeProgram;
import com.ss.evaluation.value.Student;

@Service("studentService")
public class StudentServiceImpl implements StudentService {

	private static transient Logger log = LoggerFactory
			.getLogger(StudentServiceImpl.class);

	@Autowired
	private StudentDAO studentDAO;
	
	@Autowired
	private StudentSearchClient studentSearchClient;
	
	
	@Override
	public Student getStudentByCrmIdFromDB(String studentCrmId) {
 		return studentDAO.findStudentByCrmId(studentCrmId);
	}

	@Override
	public List<Student> searchStudent(Student studentSearchDTO) throws StudentServiceException {	
        StudentSearchResponse srchResponse = studentSearchClient.searchBy(studentSearchDTO);   
		return getStudentList(srchResponse);
	}

	/**
	 * Returns a list of students objects from the search results
	 * 
	 * @param srchResponse
	 * @return
	 */
	private List<Student> getStudentList(StudentSearchResponse srchResponse) {
		List<Student> studentList = new ArrayList<Student>();
		if (srchResponse != null && srchResponse.size() > 0) {
			for (StudentSearchResult srchRes : srchResponse) {
				Student std = new Student(srchRes.getInquiryId(),
						srchRes.getStudentNumber(), srchRes.getFirstName(),
						srchRes.getLastName(), srchRes.getMaidenName(),
						srchRes.getDateOfBirth(), srchRes.getCity(),
						srchRes.getStateProvince(), srchRes.getSSN());
				studentList.add(std);
			}
		}
		return studentList;
	}
    
	/**
	 * Retrieves the studentProgramnformation details from the CRM System
	 * @throws Exception 
	 */
	@Override
	public List<StudentProgramInfo> getStudentProgramInformation(
			Student studentSearchDTO) throws StudentServiceException {			
		   ProgramOfStudyResponse programOfStudyResponse =studentSearchClient.getProgramsOfStudy(studentSearchDTO);
         return getStudentProgramInfoList(programOfStudyResponse,studentSearchDTO);
 
	}

	/**
	 * Converts the ProgramOfStudentResponse to studentProgramInfo list and returns it
	 * @param programOfStudyResponse
	 * @return
	 */
	private List<StudentProgramInfo> getStudentProgramInfoList(
			ProgramOfStudyResponse programOfStudyResponse,Student student) {
		List<StudentProgramInfo> studentProgramList = new ArrayList<StudentProgramInfo>();
		SimpleDateFormat dateFormat =new SimpleDateFormat("MM/dd/yyyy");
		if(programOfStudyResponse!=null && programOfStudyResponse.size()>0){
			for(ProgramOfStudy pos:programOfStudyResponse){
				StudentProgramInfo stdProgramInfo = new StudentProgramInfo();
				stdProgramInfo.setProgramOfStudyId(pos.getProgramOfStudyId());
				stdProgramInfo.setEnrollmentStatus(pos.getEnrollmentStatus());
				stdProgramInfo.setProgramCode(pos.getProgramCode());
				stdProgramInfo.setProgramVersionCode(pos.getProgramVersionCode());
				//Using ProgramVersion from the service for the programName
				stdProgramInfo.setProgramName(pos.getProgramVersion());
				stdProgramInfo.setStudentCrmId(student.getCrmId());
				stdProgramInfo.setProgramOfStudyStatus(pos.getProgramOfStudyStatus());
 			   if(pos.getExpectedStartDate()!=null){			
					try {
						stdProgramInfo.setExpectedStartDate(dateFormat.parse(pos.getExpectedStartDate()));
					} catch (ParseException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
				//
				//need to see how to get catalogcode and state code
				studentProgramList.add(stdProgramInfo);
			}
		}else{
			/*TODO: ADDING THIS BECAUSE THERE ARE PLACES WE ARE JUST ASSUMING PROGRAM IS AVAILABLE. FIX ME */
			StudentProgramInfo stdProgramInfo= new StudentProgramInfo();
			 
			stdProgramInfo.setProgramOfStudyId("N/A");
			stdProgramInfo.setEnrollmentStatus("N/A");
			stdProgramInfo.setProgramCode("N/A");
			stdProgramInfo.setProgramVersionCode("N/A");
			//Using ProgramVersion from the service for the programName
			stdProgramInfo.setProgramName("N/A");
			//stdProgramInfo.setStudentCrmId(student.getCrmId());
			//stdProgramInfo.setProgramOfStudyStatus(pos.getProgramOfStudyStatus());
			//stdProgramInfo.setExpectedStartDate(pos.getExpectedStartDate());
			//need to see how to get catalogcode and state code
			studentProgramList.add(stdProgramInfo);

		}
 		return studentProgramList;
	}

	@Override
	public Student getStudentById(String studentId) {
 		return studentDAO.findById(studentId);
	}

	/**
	 * Creates a new Student Record in the database
	 */
	@Override
	public Student createOrUpdateStudentRecord(Student student) {
			studentDAO.addStudent(student);
		return student;
	}

	@Override
	public CollegeProgram getCollegeByPV(String programVersionCode) {
		CollegeProgram collegeProgram=studentDAO.getCollegeByPV(programVersionCode);
		return collegeProgram;
	}

	/**
	 * Returns the program information that is closest to being the most Active program from the list retrieved by CRM
	 * If it does not find the student Program that has an active enrollment status, it displays the first program
	 * @param studentSearchDTO
	 * @return
	 * @throws StudentServiceException
	 */
	@Override
	public StudentProgramInfo getActiveStudentProgramInformation(Student studentSearchDTO) throws StudentServiceException {
		List<StudentProgramInfo> studentProgramInfoList = getStudentProgramInformation(studentSearchDTO);
		StudentProgramInfo stdProgramInfo= new StudentProgramInfo();
		if(studentProgramInfoList.size()>0){
			for(StudentProgramInfo stdProgInfo : studentProgramInfoList) {
				String enrollmentStatus = stdProgInfo.getEnrollmentStatus();
				if(enrollmentStatus!=null && (enrollmentStatus.equalsIgnoreCase("Active") ||enrollmentStatus.equalsIgnoreCase("Conditionally Accepted") )) {
					return stdProgInfo;
				}
			}
 			return studentProgramInfoList.get(0);
		}
		stdProgramInfo.setProgramOfStudyId("N/A");
		stdProgramInfo.setEnrollmentStatus("N/A");
		stdProgramInfo.setProgramCode("N/A");
		stdProgramInfo.setProgramVersionCode("N/A");
		//Using ProgramVersion from the service for the programName
		stdProgramInfo.setProgramName("N/A");
		stdProgramInfo.setStateCode("N/A");
		stdProgramInfo.setCatalogCode("N/A");
		
		//stdProgramInfo.setStudentCrmId(student.getCrmId());
		//stdProgramInfo.setProgramOfStudyStatus(pos.getProgramOfStudyStatus());
		//stdProgramInfo.setExpectedStartDate(pos.getExpectedStartDate());
		//need to see how to get catalogcode and state code
 		return stdProgramInfo;
	}
	
 }
