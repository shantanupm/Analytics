package com.ss.evaluation.dao;

import java.io.Serializable;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.ss.common.dao.BaseAbstractDAO;
import com.ss.evaluation.value.TranscriptComments;

@Repository
public class TranscriptCommentDAOImpl extends BaseAbstractDAO<TranscriptComments, Serializable> implements TranscriptCommentDAO {

	@Override
	public List<TranscriptComments> getTranscriptComments(String transcriptId) {
		List<TranscriptComments> commentList = getHibernateTemplate().find(
				"from TranscriptComments  WHERE transcriptId = ? ORDER BY createdDate" , transcriptId );
		
		if( commentList == null || commentList.size() == 0 ) {
			return null;
		}
		return commentList;
	}
	@Override
	public void addTranscriptComment(TranscriptComments transcriptComment) {
		getHibernateTemplate().saveOrUpdate(transcriptComment);
	}
	

}
