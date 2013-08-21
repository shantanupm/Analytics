package com.ss.evaluation.service;

import java.util.List;

import com.ss.evaluation.value.TranscriptComments;


public interface TranscriptCommentService {
	

	public List<TranscriptComments> getTranscriptComment(String transcriptId);
	
	
	public void addTranscriptComment(TranscriptComments speComment);
	public void removeTranscriptComment(String commentId) ;
}
