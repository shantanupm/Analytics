package com.ss.evaluation.service;

import java.util.List;

import com.ss.common.util.StudentProgramInfo;
import com.ss.evaluation.value.CollegeProgram;
import com.ss.evaluation.value.Student;

public interface StudentService {

	public Student getStudentByCrmIdFromDB(String studentCrmId);
	
	public List<Student> searchStudent(Student studentSearchDTO) throws StudentServiceException;
	public List<StudentProgramInfo> getStudentProgramInformation(Student studentSearchDTO) throws StudentServiceException;
	
	/**
	 * Returns the program information that is closest to being the most Active program from the list retrieved by CRM
	 * If it does not find the student Program that has an active enrollment status, it displays the first program
	 * @param studentSearchDTO
	 * @return
	 * @throws StudentServiceException
	 */
	public StudentProgramInfo getActiveStudentProgramInformation(Student studentSearchDTO) throws StudentServiceException;

	public Student getStudentById(String studentId);
	/**
	 * Creates a new Student record in the database
	 * @param student
	 * @return
	 */
	public Student createOrUpdateStudentRecord(Student student);

	public CollegeProgram getCollegeByPV(String programVersionCode);

}
