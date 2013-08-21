package edu.gcu.batch.gcucourse;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
 
import com.ss.course.dao.CourseMgmtDAO;
import com.ss.course.value.GCUCourse;

import edu.gcu.tevaluation.dao.CampusVueDAO;

@Component
public class GCUCourseLoadBatch {
    
	@Autowired
	private CourseMgmtDAO courseMgmtDao;
	@Autowired
	private CampusVueDAO campusVueDao;
	
	
	 
	
	public static void main(String aa[]){
		GCUCourseLoadBatch gcuCourseLoad = new GCUCourseLoadBatch();
		gcuCourseLoad.execute();
	}

	public void execute() {
		List<GCUCourse> gcuCourseList =loadGCUCoursesFromCampusVue();
		//for(GCUCourse gcuCourse:gcuCourseList){
			try{
			courseMgmtDao.createGCUCourseList(gcuCourseList);
			}catch(Exception e){
				e.printStackTrace();
			}
		//}
		
	}

	private List<GCUCourse> loadGCUCoursesFromCampusVue() {
		return campusVueDao.getAllGCUCoursesFromCampusVue();
 	}

}
