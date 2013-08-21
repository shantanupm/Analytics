package com.ss.institution.service;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import com.ss.institution.dao.InstitutionMgmtDao;
import com.ss.institution.dao.InstitutionTermTypeDao;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionAddress;
import com.ss.institution.value.InstitutionType;
import com.ss.tests.util.TestUtil;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:applicationContext.xml",
		"classpath:applicationContext-test.xml" })
@Transactional
public class InstitutionServiceTest {
	
	@Autowired
	InstitutionMgmtDao institutionMgmtDAO;
	
	@Autowired
	InstitutionTermTypeDao institutionTermTypeDAO;
	
	@Autowired
	InstitutionService institutionService;
	
	Institution inst;

	@Before
	public void setUp() throws Exception {
		
	}

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public final void testGetProcessedInstitutionCode1() {
		List<InstitutionType> institutionTypes = institutionTermTypeDAO.getAllInstitutionType();
        InstitutionType institutionType = TestUtil.getSpecificInstitutionType("University",institutionTypes);
        inst = TestUtil.returnInstitutionObject("Canyon University", institutionType);
        InstitutionAddress instAddress = new InstitutionAddress();
        instAddress.setState("AZ ARIZONA");
        inst.setInstitutionAddress(instAddress); 
        String instCode = institutionService.getProcessedInstitutionCode(inst);
		assertEquals("CUAZ0001",instCode);
  	}
	
	@Test
	public final void testGetProcessedInstitutionCode2() {
		 String instCode ="";
		List<InstitutionType> institutionTypes = institutionTermTypeDAO.getAllInstitutionType();
        InstitutionType institutionType = TestUtil.getSpecificInstitutionType("University",institutionTypes);
        InstitutionAddress instAddress = new InstitutionAddress();
        instAddress.setState("AZ ARIZONA");
		for(int i =0;i<3;i++) {
			inst=TestUtil.returnInstitutionObject("Arizona"+i+" State University", institutionType);
	        inst.setInstitutionAddress(instAddress);
	        instCode = institutionService.getProcessedInstitutionCode(inst);
	 		inst.setInstitutionID(instCode);
			institutionMgmtDAO.addInstitution(inst);
		}
		 instCode = institutionService.getProcessedInstitutionCode(inst);
		 assertEquals("ASUAZ004",instCode);

  	}

	@Test
	public final void testGetProcessedInstitutionCode3() {
		 String instCode ="";
		List<InstitutionType> institutionTypes = institutionTermTypeDAO.getAllInstitutionType();
        InstitutionType institutionType = TestUtil.getSpecificInstitutionType("University",institutionTypes);
        InstitutionAddress instAddress = new InstitutionAddress();
        instAddress.setState("AZ ARIZONA");
		for(int i =0;i<2;i++) {
			inst=TestUtil.returnInstitutionObject("Arizona"+i+"", institutionType);
	        inst.setInstitutionAddress(instAddress);
	        instCode = institutionService.getProcessedInstitutionCode(inst);
	 		inst.setInstitutionID(instCode);
			institutionMgmtDAO.addInstitution(inst);
		}
		 Institution inst2 = TestUtil.returnInstitutionObject("Arizonass", institutionType);
		 inst2.setInstitutionAddress(instAddress);
		 instCode = institutionService.getProcessedInstitutionCode(inst2);
		 assertEquals("AAZ00003",instCode);
  	}
	
	@Test
	public final void testGetProcessedInstitutionCode4() {
		 String instCode ="";
		List<InstitutionType> institutionTypes = institutionTermTypeDAO.getAllInstitutionType();
        InstitutionType institutionType = TestUtil.getSpecificInstitutionType("University",institutionTypes);
        InstitutionAddress instAddress = new InstitutionAddress();
        instAddress.setState("AZ ARIZONA");
		for(int i =0;i<4;i++) {
			inst=TestUtil.returnInstitutionObject("Sanjose"+i+" State University", institutionType);
	        inst.setInstitutionAddress(instAddress);
	        instCode = institutionService.getProcessedInstitutionCode(inst);
	 		inst.setInstitutionID(instCode);
			institutionMgmtDAO.addInstitution(inst);
		}
		Institution inst2 = TestUtil.returnInstitutionObject("Sanjoseb State University", institutionType);
		 inst2.setInstitutionAddress(instAddress);
		 instCode = institutionService.getProcessedInstitutionCode(inst2);
 		 assertEquals("SSUAZ005",instCode);
  	}
}
