package edu.gcu.tevaluation.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.stereotype.Repository;

import com.ss.course.value.GCUCourse;
@Repository
public class CampusVueDAO {
	
	private JdbcTemplate jdbcTemplate;
	private static Map<String,Integer> courseLevelToIdMap = new HashMap<String,Integer>();
	static{
		courseLevelToIdMap.put("ALL",1);
		courseLevelToIdMap.put("CONT-ED",7);
		courseLevelToIdMap.put("DOCTORATE",4);
		courseLevelToIdMap.put("GRADUATE",6);
		courseLevelToIdMap.put("REMEDIAL",5);
		courseLevelToIdMap.put("UNDERGRAD",2);  
	}
	
	private static final String GCUCOURSESQUERY = "select c.AdCourseID gcuCourseId, c.Code gcuCourseCode,c.Descrip gcuCourseTitle,"
        +"c.Credits courseCredits,c.AdCourseLevelID gcuCourseLevelId,cl.Code gcuCourseLevel,c.DateAdded dateAdded,c.DateLstMod "
	    +"from adcourse c inner join AdCourseLevel cl on c.AdCourseLevelID = cl.AdCourseLevelID";

    @Autowired
    public void setCvueDataSource(DataSource cvueDataSource) {
        this.jdbcTemplate = new JdbcTemplate(cvueDataSource);
    }
    
    public List<GCUCourse> getAllGCUCoursesFromCampusVue(){
    	final List<GCUCourse> gcuCoursesFromCampusVue = new ArrayList<GCUCourse>();
    	
    	jdbcTemplate.query(GCUCOURSESQUERY, new RowCallbackHandler(){
			@Override
			public void processRow(ResultSet rs) throws SQLException {
 				GCUCourse gcuCourse = new GCUCourse();
 			//	gcuCourse.setId(rs.getString("gcuCourseId"));
 				gcuCourse.setCourseCode(rs.getString("gcuCourseCode")); 
 				String gcuCourseLevel = rs.getString("gcuCourseLevel");
 				if(gcuCourseLevel!=null){
 					gcuCourseLevel=gcuCourseLevel.trim();
 				}
 				Integer courseLevelId = courseLevelToIdMap.get(gcuCourseLevel);
 				if(courseLevelId==null){
 					courseLevelId=1;
 				}
 				gcuCourse.setCourseLevelId(courseLevelId);
 				gcuCourse.setCredits(rs.getInt("courseCredits"));
 				gcuCourse.setDateAdded(rs.getDate("dateAdded"));
 				gcuCourse.setTitle(rs.getString("gcuCourseTitle"));
 				gcuCoursesFromCampusVue.add(gcuCourse);
			}	 
    	});   	   	 
    	return gcuCoursesFromCampusVue;
    }
 

}
