package com.ss.evaluation.dao;

import java.io.Serializable;
import java.util.List;

import com.ss.common.dao.BaseDAO;
import com.ss.evaluation.value.TranscriptComments;

public interface TranscriptCommentDAO extends BaseDAO<TranscriptComments,Serializable>{

	public List<TranscriptComments> getTranscriptComments(String transcriptId);

	public void addTranscriptComment(TranscriptComments transcriptComment);
}
