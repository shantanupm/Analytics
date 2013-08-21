package com.ss.evaluation.util;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ss.evaluation.controller.StudentLevelEvaluatorController;
import com.ss.evaluation.dao.CourseIdCreditsMapDto;
import com.ss.evaluation.dto.TrnscrptCrseSbjctIdCrdtsTrnsfrDto;

/**
 * This class has the logic to parse the
 * creditsToTransfer,CourseMappingIds,CourseCategoryMappingId strings that are
 * passed when the transcript is evaluated by an SLE
 * 
 * @author avinash
 * 
 */
public class CreditSplitParserUtil {

	private static transient Logger log = LoggerFactory.getLogger(CreditSplitParserUtil.class);

	/**
	 * Method that takes in
	 * courseMappingIdsToMap,courseCategoryMapingIdsToMap,creditsToTransfer
	 * strings and returns a list CourseIdCreditsMapDto objects
	 * 
	 * @param courseMappingIdsToMap
	 * @param crseCategMapingIdsToMap
	 * @param creditsToTransfer
	 * @return
	 */
	public List<CourseIdCreditsMapDto> getCrsesWithCrdtsToTrnsfrInfo(String courseMappingIdsToMap, String crseCategMapingIdsToMap, String creditsToTransfer,boolean isMilitaryTranscript) {
		List<CourseIdCreditsMapDto> crseCrdsMapDtoList = new ArrayList<CourseIdCreditsMapDto>();
		log.debug("CourseCategoryMappingIds:"+crseCategMapingIdsToMap);
		log.debug("Course MappingIds:"+courseMappingIdsToMap);
		log.debug("Credits to transfer:"+creditsToTransfer);

		String[] creditsToTransferArray = creditsToTransfer.split(",");
		String[] crseMapingIdsArray = courseMappingIdsToMap.split(",");
		String[] crseCategMapingIdsArray = crseCategMapingIdsToMap.split(",");
		if(!isMilitaryTranscript) {
			Map<String, CourseIdCreditsMapDto> stdTrsnptCrseIdCrdtsMap = new HashMap<String, CourseIdCreditsMapDto>();
			if (crseMapingIdsArray != null && crseMapingIdsArray.length > 0) {
				stdTrsnptCrseIdCrdtsMap.putAll(getTrnscrptIdCrseCrdtsMap(crseMapingIdsArray, "Course"));
			}
			if (crseCategMapingIdsArray != null && crseCategMapingIdsArray.length > 0) {
				stdTrsnptCrseIdCrdtsMap.putAll(getTrnscrptIdCrseCrdtsMap(crseCategMapingIdsArray, "Category"));
			}
 			populateCreditsToTransfer(creditsToTransferArray, stdTrsnptCrseIdCrdtsMap);
 			crseCrdsMapDtoList.addAll(stdTrsnptCrseIdCrdtsMap.values());
		}else {
			crseCrdsMapDtoList.addAll(getCrseCrdsListForMilitarytranscript(crseCategMapingIdsArray));
 		}
		return crseCrdsMapDtoList;

	}

	/**
	 * Returns a list of CourseIdCreditsMapDto for a military transcript
	 * @param crseCategMapingIdsArray
	 * @return
	 */
	private List<CourseIdCreditsMapDto> getCrseCrdsListForMilitarytranscript(String[] crseCategMapingIdsArray) {
		List<CourseIdCreditsMapDto> stdTrsnptCourseIdCreditsList = new ArrayList<CourseIdCreditsMapDto>() ;
		for (String crseMapIds : crseCategMapingIdsArray) {
			String[] crseMapIdTrnscrptCrse = crseMapIds.split("<>");
			if (crseMapIdTrnscrptCrse.length == 3) {
				CourseIdCreditsMapDto crseIdCrdDto = new CourseIdCreditsMapDto();
				crseIdCrdDto.setMappingId(crseMapIdTrnscrptCrse[0]);
				crseIdCrdDto.setMappingType("Category");
 				crseIdCrdDto.setMilitarySubjectId(crseMapIdTrnscrptCrse[2]);
 				crseIdCrdDto.setStudentTranscriptCourseId(crseMapIdTrnscrptCrse[1]);
				stdTrsnptCourseIdCreditsList.add(crseIdCrdDto);
			}
		}
		return stdTrsnptCourseIdCreditsList;
	}

	/**
	 * Parses the data from CreditsToTransferArray and populates the
	 * corresponding CourseIdCreditsMapDto objects in
	 * stdTrsnptCourseIdCreditsMap
	 * 
	 * @param creditsToTransferArray
	 * @param stdTrsnptCourseIdCreditsMap
	 */
	private void populateCreditsToTransfer(String[] creditsToTransferArray, Map<String, CourseIdCreditsMapDto> stdTrsnptCourseIdCreditsMap) {
		for (String crdtsToTrnsfr : creditsToTransferArray) {
 				String[] crdtsToTrnsfrArray = crdtsToTrnsfr.split("__");
				if (crdtsToTrnsfrArray != null && crdtsToTrnsfrArray.length == 3) {
					String stdTrnsptCrseId = crdtsToTrnsfrArray[0];
					String totalCrdtsToTrnsfr = crdtsToTrnsfrArray[1];
					CourseIdCreditsMapDto crsIdCrdDtsMapDto = stdTrsnptCourseIdCreditsMap.get(stdTrnsptCrseId);
					if (crsIdCrdDtsMapDto != null) {
						crsIdCrdDtsMapDto.setTotalCreditsToTransfer(totalCrdtsToTrnsfr);
						String splitMappings = crdtsToTrnsfrArray[2];
						String[] splitMappingsArray = splitMappings.split("_");
						for (String splitMap : splitMappingsArray) {
							String[] gcuCrsCrdtToTrnsferArray = splitMap.split("<>");
							if (gcuCrsCrdtToTrnsferArray != null && gcuCrsCrdtToTrnsferArray.length == 2) {
 								crsIdCrdDtsMapDto.addSLECourseCreditSplitInfo(gcuCrsCrdtToTrnsferArray[0], gcuCrsCrdtToTrnsferArray[1]);
							}
						}
					}
 			} 
		}

	}

	/**
	 * Returns a map of StudentTranscriptCourseId and CourseIdCreditsMapDto
	 * object
	 * 
	 * @param mappingIdsArray
	 * @param mappingType
	 * @return
	 */
	private Map<String, CourseIdCreditsMapDto> getTrnscrptIdCrseCrdtsMap(String[] mappingIdsArray, String mappingType) {
		Map<String, CourseIdCreditsMapDto> stdTrsnptCourseIdCreditsMap = new HashMap<String, CourseIdCreditsMapDto>();
		for (String crseMapIds : mappingIdsArray) {
			String[] crseMapIdTrnscrptCrse = crseMapIds.split("<>");
			if (crseMapIdTrnscrptCrse.length >= 2) {
				CourseIdCreditsMapDto crseIdCrdDto = new CourseIdCreditsMapDto();
				crseIdCrdDto.setMappingId(crseMapIdTrnscrptCrse[0]);
				crseIdCrdDto.setMappingType(mappingType);
				crseIdCrdDto.setStudentTranscriptCourseId(crseMapIdTrnscrptCrse[1]);
				stdTrsnptCourseIdCreditsMap.put(crseMapIdTrnscrptCrse[1], crseIdCrdDto);
			}
		}
		return stdTrsnptCourseIdCreditsMap;
	}
	
	/**
	 * Returns a list of DTO objects that contain TranscriptCourseSubjectId and credits assosciated with it
	 * @param creditsToTransferString
	 * @return
	 */
	public List<TrnscrptCrseSbjctIdCrdtsTrnsfrDto> getCreditsToTransferMapForMilitary(String creditsToTransferString) {
		List<TrnscrptCrseSbjctIdCrdtsTrnsfrDto> tscCreditsList = new ArrayList<TrnscrptCrseSbjctIdCrdtsTrnsfrDto>();
		String[] creditsToTransferArray = creditsToTransferString.split(",");
		for(String crdsString : creditsToTransferArray) {
			String[] tcsCreditArray = crdsString.split("<>");
			if(tcsCreditArray.length==2) {
				TrnscrptCrseSbjctIdCrdtsTrnsfrDto trnscrptCrseSbjctIdCrdtsTrnsfrDto = new TrnscrptCrseSbjctIdCrdtsTrnsfrDto();
				trnscrptCrseSbjctIdCrdtsTrnsfrDto.setTranscriptCourseSubjectId(tcsCreditArray[0]);
				trnscrptCrseSbjctIdCrdtsTrnsfrDto.setCreditsToTransfer(tcsCreditArray[1]);
				tscCreditsList.add(trnscrptCrseSbjctIdCrdtsTrnsfrDto);
			}			
 		}
		return tscCreditsList;
	}

}
