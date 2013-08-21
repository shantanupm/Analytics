package com.ss.institution.dao;

import java.io.Serializable;
import java.util.List;

import com.ss.common.dao.BaseDAO;
import com.ss.institution.value.AccreditingBody;
import com.ss.institution.value.AccreditingBodyInstitute;

public interface AccreditingBodyInstituteDao extends BaseDAO<AccreditingBodyInstitute, Serializable> {

	public void addAccreditingBodyInstitute(AccreditingBodyInstitute ab);
	public List<AccreditingBodyInstitute> getAllAccreditingBodyInstitute(String institutionId);
	public List<AccreditingBody> getAllAccreditingBody();
	public void effectiveAccreditingBody(String institutionId,String accreditingBodyId);
	public void addAccreditingBodyInstituteList(List<AccreditingBodyInstitute> abList,String institutionId) ;
}
