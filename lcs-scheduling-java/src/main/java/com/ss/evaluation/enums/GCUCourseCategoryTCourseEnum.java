package com.ss.evaluation.enums;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

//TODO:Move this to database
public enum GCUCourseCategoryTCourseEnum {
	  
	  EFFECTIVECOMMLD("1","ecld", "General Education - Effective Communication LD","ELEC-2",50),
	  CRITICALTHINKINGLD("10", "ctld","General Education - Critical Thinking LD","CT-2",20),
	  CRITICALTHINKINGUD("11","ctud", "General Education - Critical Thinking UD","CT-4",20),
	  GLOBALAWARELD("12","gald", "General Education - Global Awareness LD","GA-2",20),
	  GLOBALAWAREUD("13","gaud", "General Education - Global Awareness UD","GA-2",20),
	  ELECTIVELD("14", "elld","General Education - Elective LD","ELEC-2",50),
	  ELECTIVEUD("15","elud", "General Education - Elective UD","ELEC-2",25),
 	  ELECTIVECOMMUD("2","ecud","General Education - Effective Communication UD","ELEC-4",25);
	  
	    private final String dbId;
	    private final String code;
	    private final String description;
	    private final String tcoursePrefix;
	    private final int maxCount;

	    GCUCourseCategoryTCourseEnum(String dbId, String code,String description,String tcoursePrefix,int maxCount) {
	        this.dbId = dbId;
	        this.code = code;
	        this.description = description;
	        this.tcoursePrefix = tcoursePrefix;
	        this.maxCount = maxCount;
	    }
 
	    public static final Map<String, GCUCourseCategoryTCourseEnum> CODE_MAP;
	    static {
	        Map<String, GCUCourseCategoryTCourseEnum> tmpMap = new HashMap<String, GCUCourseCategoryTCourseEnum>();
	        for(GCUCourseCategoryTCourseEnum tCourse : GCUCourseCategoryTCourseEnum.values()) {
	            tmpMap.put(tCourse.dbId, tCourse);
	        }
	        CODE_MAP = Collections.unmodifiableMap(tmpMap);
	    }
		/**
		 * @return the dbId
		 */
		public String getDbId() {
			return dbId;
		}


	    public String getDescription() {
	        return description;
	    }

		/**
		 * @return the tcoursePrefix
		 */
		public String getTcoursePrefix() {
			return tcoursePrefix;
		}


		/**
		 * @return the maxCount
		 */
		public int getMaxCount() {
			return maxCount;
		}


		/**
		 * @return the code
		 */
		public String getCode() {
			return code;
		}
		
	}
