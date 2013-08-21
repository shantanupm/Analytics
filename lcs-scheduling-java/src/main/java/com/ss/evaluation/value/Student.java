package com.ss.evaluation.value;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.GenericGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ss.common.util.StudentProgramInfo;
import com.ss.common.value.BaseEntity;
import com.ss.evaluation.dto.Address;
import com.ss.evaluation.dto.Demographics;
import com.ss.institution.value.GcuCourseLevel;

@Entity
@Table(name = "ss_tbl_student")
public class Student extends BaseEntity implements Serializable{

	private static final long serialVersionUID = 14574463497894423L;

	private static transient Logger log = LoggerFactory.getLogger(GcuCourseLevel.class);	
	
	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")
	@Column(name = "id")
	private String id;	
	
	@Column(name = "campusvue_id")
	private String campusvueId;
	
	@Column(name = "crm_id")
	private String crmId;
	
	@Transient
	private Demographics demographics = new Demographics();
   
	@Transient
	private List<StudentProgramInfo> studentProgramInfoList = new ArrayList<StudentProgramInfo>();

	
	public Student(){};
	
	public Student(String studentCrmId, String campusVueId, String firstName,
			String lastName, String maidenName, String dob, String city,
			String state,String SSN) {
		this.crmId=studentCrmId;
		this.campusvueId=campusVueId;
        this.demographics.setFirstName(firstName);
        this.demographics.setLastName(lastName);
        this.demographics.setDateOfBirth(dob);
        this.demographics.setMaidenName(maidenName);
        this.demographics.setSSN(SSN);
        Address addr = new Address(null,null, null,city, state,null, null);
        this.demographics.getAddressList().add(addr);
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getCampusvueId() {
		return campusvueId;
	}

	public void setCampusvueId(String campusvueId) {
		this.campusvueId = campusvueId;
	}

	public String getCrmId() {
		return crmId;
	}

	public void setCrmId(String crmId) {
		this.crmId = crmId;
	}

	public List<StudentProgramInfo> getStudentProgramInfoList() {
		return studentProgramInfoList;
	}

	public void setStudentProgramInfoList(
			List<StudentProgramInfo> studentProgramInfoList) {
		this.studentProgramInfoList = studentProgramInfoList;
	}

	public Demographics getDemographics() {
		return demographics;
	}

	public void setDemographics(Demographics demographics) {
		this.demographics = demographics;
	}
	
	/**
	 * TODO:Need to better handler State , City and Country
	 * @return
	 */
	public String getState(){
		List<Address> addrList =  demographics.getAddressList();
		if(addrList.size()>0){
			return addrList.get(0).getState();
		}
		return null;
	}
	
	public String getCity(){
		List<Address> addrList =  demographics.getAddressList();
		if(addrList.size()>0){
			return addrList.get(0).getCity();
		}
		return null;
	}
	
	public String getCountry(){
		List<Address> addrList =  demographics.getAddressList();
		if(addrList.size()>0){
			return addrList.get(0).getCountry();
		}
		return null;
	}


	@Override
	public String toString() {
		return String
				.format("Student [id=%s, campusvueId=%s, crmId=%s, demographics=%s, studentProgramInfoList=%s]",
						id, campusvueId, crmId, demographics,
						studentProgramInfoList);
	}

	

	

			
}
