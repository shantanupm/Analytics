package com.ss.evaluation.value;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.GenericGenerator;

import com.ss.common.value.BaseEntity;
import com.ss.user.value.User;

@Entity
@Table( name="ss_tbl_transcript_comment" )
public class TranscriptComments extends BaseEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue( generator = "customuuid" )
	@GenericGenerator( name = "customuuid", strategy = "com.ss.common.util.CustomUUIDGenerator" )
	@Column(name = "id")
	private String id;
	
	@Column( name="transcript_id" )
	private String transcriptId;

	@Column( name="comment" )
	private String comment;
	
	@Transient
	private User user;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getTranscriptId() {
		return transcriptId;
	}

	public void setTranscriptId(String transcriptId) {
		this.transcriptId = transcriptId;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
	
}
