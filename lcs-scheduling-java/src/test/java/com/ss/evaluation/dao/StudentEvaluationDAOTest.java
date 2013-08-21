package com.ss.evaluation.dao;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.ss.evaluation.value.StudentInstitutionTranscript;
import com.ss.institution.dao.InstitutionMgmtDao;
import com.ss.institution.dao.InstitutionTermTypeDao;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionType;
import com.ss.tests.util.TestUtil;

public class StudentEvaluationDAOTest {
	
	@Autowired
	StudentEvaluationDao studentEvaluationDAO;
	@Autowired
	InstitutionMgmtDao institutionMgmtDAO;
	@Autowired
	InstitutionTermTypeDao institutionTermTypeDAO;

	@Before
	public void setUp() throws Exception {
	}

	@After
	public void tearDown() throws Exception {
	}
	
	@Test
	public final void testSaveStudentInstitutionTranscript() {
//		List<InstitutionType> institutionTypes = institutionTermTypeDAO.getAllInstitutionType();
//        InstitutionType institutionType = TestUtil.getSpecificInstitutionType("University",institutionTypes);
//		Institution institution = TestUtil.returnInstitutionObject("Canyon University", "1", "1", institutionType);
//		institutionMgmtDAO.addInstitution(institution);
// 		StudentInstitutionTranscript sit = new StudentInstitutionTranscript();
//		sit.setInstitution(institution);
//	//	sit.setInstitutionAddress(institutionAddress)
////		sit.setLastDateForLastCourse(new Date());
////		sit.setStudent(student)
//		
	//	fail("Not yet implemented"); // TODO
	}


//	@Test
//	public final void testSaveStudentProgramEvaluation() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	@Test
//	public final void testGetEvaluationForStudentCrmIdAndProgramCode() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	@Test
//	public final void testGetEvaluationForStudentByCrmId() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	@Test
//	public final void testGetStudentInstitutionTranscriptForStudentProgramEval() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	@Test
//	public final void testGetStudentInstitutionTranscriptForStudentAndInstitution() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	@Test
//	public final void testGetStudentInstitutionTranscriptListForStudentAndInstitution() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	@Test
//	public final void testGetStudentInstitutionTranscriptById() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	@Test
//	public final void testRemoveStudentInstitutionTranscript() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	@Test
//	public final void testGetUnofficialStudentInstitutionTranscriptList() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	@Test
//	public final void testGetOfficialStudentInstitutionTranscriptList() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	@Test
//	public final void testGetAwaitingIEorIEMSITList() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	@Test
//	public final void testGetOldestSITForLOPES() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	@Test
//	public final void testGetOldestSITForSLE() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	@Test
//	public final void testGetAllSITListOrderByStatus() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	@Test
//	public final void testGetOldestREJECTEDSIT() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	@Test
//	public final void testGetAllSITList() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	@Test
//	public final void testGetTotalTranscripts() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	@Test
//	public final void testGetLastMonthTranscripts() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	@Test
//	public final void testGetLast7DaysTranscripts() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	@Test
//	public final void testGetTodaysTranscripts() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	@Test
//	public final void testGetChartValues() {
//		fail("Not yet implemented"); // TODO
//	}

}
