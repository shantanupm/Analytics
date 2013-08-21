package com.ss.evaluation.dao;

import java.io.Serializable;

import com.ss.common.dao.BaseDAO;
import com.ss.evaluation.value.CollegeProgram;
import com.ss.evaluation.value.Student;

public interface StudentDAO extends BaseDAO<Student, Serializable>{

	public Student findStudentByCrmId(String studentCrmId);
	
	public CollegeProgram getCollegeByPV(String programVersionCode);

	public Student addStudent(Student student);

}
