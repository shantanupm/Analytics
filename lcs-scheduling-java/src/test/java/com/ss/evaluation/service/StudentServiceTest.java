package com.ss.evaluation.service;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import com.ss.evaluation.value.Student;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:applicationContext.xml",
		"classpath:applicationContext-test.xml" })
@Transactional
public class StudentServiceTest {
	
	@Autowired
	private StudentService studentService;

	@Before
	public void setUp() throws Exception {
	}

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public final void testGetStudentByCrmId() {
 	}

	@Test
	public final void testSearchStudent() {
//		Student student = new Student();
//		studentService.searchStudent(student);
		
	}

	@Test
	public final void testGetStudentProgramInformation() {
 	}

	@Test
	public final void testGetStudentById() {
 	}

	@Test
	public final void testCreateStudentRecord() {
 	}

}
