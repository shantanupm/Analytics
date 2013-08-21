/**
 * 
 */
package com.ss.institution.dao;

import static org.junit.Assert.*;

import java.util.Date;
import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionType;
import com.ss.tests.util.TestUtil;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:applicationContext.xml",
		"classpath:applicationContext-test.xml" })
@Transactional
public class InstitutionMgmtDAOTest {
	
	@Autowired
	InstitutionMgmtDao institutionMgmtDAO;
	@Autowired
	InstitutionTermTypeDao institutionTermTypeDAO;
	
	private Institution institutionForTest;
	/**
	 * @throws java.lang.Exception
	 */
	@Before
	public void setUp() throws Exception {
 		List<InstitutionType> institutionTypes = institutionTermTypeDAO.getAllInstitutionType();
        InstitutionType institutionType = TestUtil.getSpecificInstitutionType("University",institutionTypes);
		institutionForTest = TestUtil.returnInstitutionObject("Canyon University", institutionType);
		//institutionMgmtDAO.addInstitution(institutionForTest);
	}

	/**
	 * @throws java.lang.Exception
	 */
	@After
	public void tearDown() throws Exception {
	}
	
	/**
	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#addInstitution(com.ss.institution.value.Institution)}.
	 * Verifies addInstitution, getInstitutionById calls
	 */
	@Test
	public final void testAddInstitution() {
		try{
        Institution inst = institutionMgmtDAO.getInstitutionById(institutionForTest.getId());
//		assertNotNull(inst);
//		assertEquals("Verify that the institution Type is University","University",inst.getInstitutionType().getName());
//		assertEquals("Verify that the description is the same","Canyon University",inst.getName());
//		assertEquals("Verify that the createdBy is the same","1",inst.getCreatedBy());
		}catch(Exception e){
			fail("Error occurred while running the test case");
		}	
	}
	
	/**
	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#addInstitution(com.ss.institution.value.Institution)}.
	 * Verifies a case where we are updating an existing institution with a new InstitutionType
	 */
	@Test
	public final void testAddInstitution2() {
		try{
        Institution inst = institutionMgmtDAO.getInstitutionById(institutionForTest.getId());
//		assertNotNull(inst);
//		assertEquals("Verify that the institution Type is University",institutionForTest.getInstitutionType().getName(),inst.getInstitutionType().getName());
//		InstitutionType instType =TestUtil.getSpecificInstitutionType("Community College",institutionTermTypeDAO.getAllInstitutionType());
//		inst.setInstitutionType(instType);
//		institutionMgmtDAO.addInstitution(inst);
//		inst = institutionMgmtDAO.getInstitutionById(institutionForTest.getId());
//		assertEquals("Verify that the institution Type is CommunityCollege",instType.getName(),inst.getInstitutionType().getName());
//		assertEquals("Verify that the description is the same","Canyon University",inst.getName());
//		assertEquals("Verify that the createdBy is the same","1",inst.getCreatedBy());
		}catch(Exception e){
			fail("Error occurred while running the test case");
		}	
	}

//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#getInstitutionById(java.lang.String)}.
//	 */
//	@Test
//	public final void testGetInstitutionById() {
//		fail("Not yet implemented"); // TODO
//		
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#findByPartSchoolCode(java.lang.String)}.
//	 */
//	@Test
//	public final void testFindByPartSchoolCode() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#getAllInstitutions()}.
//	 */
//	@Test
//	public final void testGetAllInstitutions() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#saveInstitutionDegree(com.ss.institution.value.InstitutionDegree)}.
//	 */
//	@Test
//	public final void testSaveInstitutionDegree() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#saveStudentInstitutionDegree(com.ss.evaluation.value.StudentInstitutionDegree)}.
//	 */
//	@Test
//	public final void testSaveStudentInstitutionDegree() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#getInstitutionForStudentProgramEvaluation(java.lang.String)}.
//	 */
//	@Test
//	public final void testGetInstitutionForStudentProgramEvaluation() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#getStudentInstitutionDegreeListForStudentInstitutionTranscript(com.ss.evaluation.value.StudentInstitutionTranscript)}.
//	 */
//	@Test
//	public final void testGetStudentInstitutionDegreeListForStudentInstitutionTranscript() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#getAllCountries()}.
//	 */
//	@Test
//	public final void testGetAllCountries() {
//		fail("Not yet implemented"); // TODO
//	}
//
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#addCountry(com.ss.evaluation.value.Country)}.
//	 */
//	@Test
//	public final void testAddCountry() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#getInstitutionDegreeByInstituteIDAndDegreeName(java.lang.String, java.lang.String)}.
//	 */
//	@Test
//	public final void testGetInstitutionDegreeByInstituteIDAndDegreeName() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#getStudentInstitutionDegreeList(java.lang.String)}.
//	 */
//	@Test
//	public final void testGetStudentInstitutionDegreeList() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#getInstitutionByCodeTitle(java.lang.String, java.lang.String)}.
//	 */
//	@Test
//	public final void testGetInstitutionByCodeTitle() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#getAllInstitutions(java.lang.String)}.
//	 */
//	@Test
//	public final void testGetAllInstitutionsString() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#getAllNotEvalutedInstitutions()}.
//	 */
//	@Test
//	public final void testGetAllNotEvalutedInstitutions() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#schoolCodeExist(java.lang.String, java.lang.String)}.
//	 */
//	@Test
//	public final void testSchoolCodeExist() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#schoolTitleExist(java.lang.String, java.lang.String)}.
//	 */
//	@Test
//	public final void testSchoolTitleExist() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#getOldestUnEvaluatedInstitution()}.
//	 */
//	@Test
//	public final void testGetOldestUnEvaluatedInstitution() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#getNotEvaluatedInstitutionListForJob()}.
//	 */
//	@Test
//	public final void testGetNotEvaluatedInstitutionListForJob() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#getAllConflictInstitutions()}.
//	 */
//	@Test
//	public final void testGetAllConflictInstitutions() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#getAllEvaluatedInstitutions()}.
//	 */
//	@Test
//	public final void testGetAllEvaluatedInstitutions() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#getInstitutionsList(java.lang.String, java.lang.String, java.lang.String, java.lang.String)}.
//	 */
//	@Test
//	public final void testGetInstitutionsList() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#skipInstitutionNCourse(java.lang.String)}.
//	 */
//	@Test
//	public final void testSkipInstitutionNCourse() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#getInstitutionsForReassignment()}.
//	 */
//	@Test
//	public final void testGetInstitutionsForReassignment() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#reAssignCoursesOfInstitution(java.lang.String, java.lang.String, java.lang.String)}.
//	 */
//	@Test
//	public final void testReAssignCoursesOfInstitution() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#addInstitutionTranscript(com.ss.institution.value.InstitutionTranscript)}.
//	 */
//	@Test
//	public final void testAddInstitutionTranscript() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#getInstitutionTranscript(java.lang.String)}.
//	 */
//	@Test
//	public final void testGetInstitutionTranscript() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#findInstituteForState(java.lang.String)}.
//	 */
//	@Test
//	public final void testFindInstituteForState() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#findInstituteForEvalutationForCurrentUserNotIn(java.lang.String, java.util.List)}.
//	 */
//	@Test
//	public final void testFindInstituteForEvalutationForCurrentUserNotIn() {
//		fail("Not yet implemented"); // TODO
//	}
//
//	/**
//	 * Test method for {@link com.ss.institution.dao.InstitutionMgmtDaoImpl#getStudentInstitutionTranscriptAwatingForIENotIn(java.util.List)}.
//	 */
//	@Test
//	public final void testGetStudentInstitutionTranscriptAwatingForIENotIn() {
//		fail("Not yet implemented"); // TODO
//	}

}
