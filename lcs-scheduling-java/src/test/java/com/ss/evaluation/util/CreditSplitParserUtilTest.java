package com.ss.evaluation.util;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import com.ss.evaluation.dao.CourseIdCreditsMapDto;
import com.ss.evaluation.dto.SLETransferCreditSplit;

public class CreditSplitParserUtilTest {

	private CreditSplitParserUtil creditSplitParserUtil = null;

	@Before
	public void setUp() throws Exception {
		creditSplitParserUtil = new CreditSplitParserUtil();
	}

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public final void testGetCoursesWithApprovedCreditsToTransferInfo1() {
		List<CourseIdCreditsMapDto> courseIdCreditsMapDtoList = creditSplitParserUtil
				.getCrsesWithCrdtsToTrnsfrInfo("", "", "",false);
		assertNotNull(courseIdCreditsMapDtoList);
		assertEquals(0, courseIdCreditsMapDtoList.size());
	}

	@Test
	public final void testGetCoursesWithApprovedCreditsToTransferInfo2() {
		List<CourseIdCreditsMapDto> courseIdCreditsMapDtoList = creditSplitParserUtil
				.getCrsesWithCrdtsToTrnsfrInfo(
						"f245d71d-5f9f-435d-afe0-5a26b869ed41<>870e3511-51ab-4c10-9c5d-c467c8511c43,",
						",57a53ccb-f62a-4724-a385-624d299c09cd<>bedcbf6f-2231-444b-9a17-46da6c611419",
						"870e3511-51ab-4c10-9c5d-c467c8511c43__24__MAT-490A<>24.00_,bedcbf6f-2231-444b-9a17-46da6c611419__15__<>15.00_",false);
		assertNotNull(courseIdCreditsMapDtoList);
		assertEquals(2, courseIdCreditsMapDtoList.size());
		assertEquals(1,getMappingCount(courseIdCreditsMapDtoList,"Category"));
		assertEquals(1,getMappingCount(courseIdCreditsMapDtoList,"Course"));
	}
	
	@Test
	public final void testGetCoursesWithApprovedCreditsToTransferInfo3() {
		List<CourseIdCreditsMapDto> courseIdCreditsMapDtoList = creditSplitParserUtil
				.getCrsesWithCrdtsToTrnsfrInfo(
						",fc5ffc9e-97dd-4bc7-8899-c540165b9193<>8ec5c1bd-4ced-49aa-b66c-7bfa0fe0bb48",
						"732f7942-f362-42cd-9118-a0b94e8c2572<>7231b5d3-e0c3-4ef1-825c-cc3853962e6a,",
						"8ec5c1bd-4ced-49aa-b66c-7bfa0fe0bb48__35__MAT-490A<>14.00_MAT-130<>21_",false);
		assertNotNull(courseIdCreditsMapDtoList);
		assertEquals(2, courseIdCreditsMapDtoList.size());
		assertEquals(1,getMappingCount(courseIdCreditsMapDtoList,"Category"));
		assertEquals(1,getMappingCount(courseIdCreditsMapDtoList,"Course"));
		for(CourseIdCreditsMapDto crdDto:courseIdCreditsMapDtoList) {
			 if(crdDto.getMappingType().equalsIgnoreCase("Course")) {
				 List<SLETransferCreditSplit> splitList = crdDto.getGcuCrseCrdsToTrnsList();
				 assertNotNull(splitList);
				 assertEquals(2,splitList.size());
                 assertEquals("35",crdDto.getTotalCreditsToTransfer());

				 for(SLETransferCreditSplit split:splitList) {
					 String courseCode = split.getCourseCode();
					 String creditsToTransfer = split.getCreditsToTransfer();
					 if(courseCode.equalsIgnoreCase("MAT-490A")) {
						 assertEquals("14.00",creditsToTransfer);
					 }
					 if(courseCode.equalsIgnoreCase("MAT-130")) {
						 assertEquals("21",creditsToTransfer);
					 }
				 }
 			 }
		}
	}

	/**
	 * Returns count of a specific mapping type
	 * @param courseIdCreditsMapDtoList
	 * @return
	 */
	private int getMappingCount(
			List<CourseIdCreditsMapDto> courseIdCreditsMapDtoList,String countType) {
		 int count=0;
		 for(CourseIdCreditsMapDto ccm:courseIdCreditsMapDtoList) {
			 if(ccm.getMappingType().equalsIgnoreCase(countType)) {
				 count++;
			 }
		 }
		 return count++;
	}

	 
}
