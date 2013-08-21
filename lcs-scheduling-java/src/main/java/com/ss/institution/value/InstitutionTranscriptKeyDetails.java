package com.ss.institution.value;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ss.common.util.EqualsUtil;
import com.ss.common.value.BaseEntity;


@Entity
@Table(name = "ss_tbl_institute_transcriptkey_details")
public class InstitutionTranscriptKeyDetails extends BaseEntity implements Serializable{

	private static final long serialVersionUID = 14574463497894423L;

	private static transient Logger log = LoggerFactory.getLogger(InstitutionTranscriptKeyDetails.class);
	
	@Id
	@GeneratedValue(generator = "customuuid")
	@GenericGenerator(name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator")
	@Column(name = "id")
	private String id;	
	
	
	@ManyToOne
	@JoinColumn(name="institution_transcripkey_id", referencedColumnName="id")
	private InstitutionTranscriptKey institutionTranscriptKey;
	
	/*@Column(name = "institution_transcripkey_id")
	private String institutionTranscripkeyId;*/
	
	/*@Column(name = "gcu_course_level_id")
	private String gcuCourseLevelId;*/
	
	@OneToOne()
	@JoinColumn(name="gcu_course_level_id", referencedColumnName="id")
	private GcuCourseLevel gcuCourseLevel=new GcuCourseLevel();
	
	
	@Column(name = "from_code")
	private String from;
	
	@Column(name = "to_code")
	private String to;
	
	
	
	
	/*public String getInstitutionTranscripkeyId() {
		return institutionTranscripkeyId;
	}

	public void setInstitutionTranscripkeyId(String institutionTranscripkeyId) {
		this.i
		nstitutionTranscripkeyId = institutionTranscripkeyId;
	}*/

	

	public InstitutionTranscriptKey getInstitutionTranscriptKey() {
		return institutionTranscriptKey;
	}

	public void setInstitutionTranscriptKey(
			InstitutionTranscriptKey institutionTranscriptKey) {
		this.institutionTranscriptKey = institutionTranscriptKey;
	}

	public GcuCourseLevel getGcuCourseLevel() {
		return gcuCourseLevel;
	}

	public void setGcuCourseLevel(GcuCourseLevel gcuCourseLevel) {
		this.gcuCourseLevel = gcuCourseLevel;
	}

	public String getFrom() {
		return from;
	}

	public void setFrom(String from) {
		this.from = from;
	}

	public String getTo() {
		return to;
	}

	public void setTo(String to) {
		this.to = to;
	}

	

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	

	

	
	 @Override public boolean equals(Object aThat) {
		    //check for self-comparison
		    if ( this == aThat ) return true;
		    
		    if ( !(aThat instanceof InstitutionTranscriptKeyDetails) ) return false;
		    //Alternative to the above line : if ( aThat == null || aThat.getClass() != this.getClass() ) return false;
		    
		    //cast to native object is now safe
		    InstitutionTranscriptKeyDetails that = (InstitutionTranscriptKeyDetails)aThat;

		    //now a proper field-by-field evaluation can be made
		    return
		      EqualsUtil.areEqual(this.from, that.from) &&
		      EqualsUtil.areEqual(this.to, that.to);
		     
		     
	}	
		
	
}
