package com.ss.evaluation.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ss.evaluation.dao.TranscriptCommentDAO;
import com.ss.evaluation.value.TranscriptComments;
import com.ss.user.dao.UserDAO;
@Service
public class TranscriptCommentServiceImpl implements TranscriptCommentService {

	@Autowired
	private TranscriptCommentDAO transcriptCommentDAO;
	@Autowired
	private UserDAO userDao;
	

	@Override
	public List<TranscriptComments> getTranscriptComment(String transcriptId) {
		
		 List<TranscriptComments> transcriptCommentList=transcriptCommentDAO.getTranscriptComments(transcriptId);
		 if(transcriptCommentList!=null && transcriptCommentList.size()>0){
			 for (TranscriptComments transcriptComment:transcriptCommentList){
				 transcriptComment.setUser(userDao.findById(transcriptComment.getCreatedBy()));
			 }
		}
		return transcriptCommentList;
		
	}

	@Override
	public void addTranscriptComment(TranscriptComments transcriptComment) {
		transcriptCommentDAO.addTranscriptComment(transcriptComment);

	}
	
	@Override
	public void removeTranscriptComment(String commentId) {
		TranscriptComments transcriptComment= new TranscriptComments();
		transcriptComment=transcriptCommentDAO.findById(commentId);
		transcriptCommentDAO.delete(transcriptComment);

	}

}
