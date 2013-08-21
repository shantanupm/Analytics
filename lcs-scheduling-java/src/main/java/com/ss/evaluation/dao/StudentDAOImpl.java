package com.ss.evaluation.dao;

import java.io.Serializable;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.ss.common.dao.BaseAbstractDAO;
import com.ss.common.logging.RequestContext;
import com.ss.evaluation.value.CollegeProgram;
import com.ss.evaluation.value.Student;
@Repository("studentDAO")
public class StudentDAOImpl extends BaseAbstractDAO<Student, Serializable> implements
		StudentDAO {
	private static transient Logger log = LoggerFactory.getLogger( StudentDAOImpl.class );

	@Override
	public Student findStudentByCrmId(String studentCrmId) {
		try{
			List<Student>  student = getHibernateTemplate().find("FROM Student WHERE crmId=?",new Object[]{studentCrmId});
			if(student!=null && student.size()>0){
				return student.get(0);
			}else{
				return null;
			}
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No Student found."+e+" RequestId:"+uniqueId, e);
			return null;
		}
	}
	
	@Override
	public CollegeProgram getCollegeByPV(String programVersionCode){
		CollegeProgram collegeProgram= new CollegeProgram();
		try{
			List<CollegeProgram>  collegePrograms = getHibernateTemplate().find("FROM CollegeProgram WHERE programCode=?",new Object[]{programVersionCode});
			if(collegePrograms!=null && collegePrograms.size()>0){
				return collegePrograms.get(0);
			}else{
				collegeProgram.setCollegeCode("COLDEFAULT");
				collegeProgram.setId("9");
				collegeProgram.setDescription("Default College");
				return collegeProgram;
			}
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No College Program Found"+e+" RequestId:"+uniqueId, e);
			return null;
		}
	}
	@Override
	public Student addStudent(Student student) {
		getHibernateTemplate().saveOrUpdate(student);
		return student;
	}
}
