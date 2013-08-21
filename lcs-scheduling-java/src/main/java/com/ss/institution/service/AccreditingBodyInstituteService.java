package com.ss.institution.service;

import java.util.List;

import com.ss.institution.value.AccreditingBody;
import com.ss.institution.value.AccreditingBodyInstitute;


public interface AccreditingBodyInstituteService {
	public void addAccreditingBodyInstitute(AccreditingBodyInstitute ab);
	public List<AccreditingBodyInstitute> getAllAccreditingBodyInstitute(String institutionId);
	public AccreditingBodyInstitute getAccreditingBodyInstitute(String accreditingBodyId);
	public List<AccreditingBody> getAllAccreditingBody();
	
	public List<AccreditingBodyInstitute> getAccreditingBodyInstituteList(String institutionMirrorId);
	public AccreditingBodyInstitute getAccreditingBodyInstituteByInstitutionMirrorId(String institutionMirrorId, String accreditingBodyInstituteId);
	public void addAccreditingBodyInstituteToMirror(String institutionMirrorId, AccreditingBodyInstitute abi);
	public void effectiveAccreditingBody(String institutionId, String accreditingBodyId);
	public void effectiveAccreditingBodyMirror(String institutionMirrorId,String accreditingBodyId);
	public void addAccreditingBodyInstituteList(List<AccreditingBodyInstitute> abList,String institutionId);
	
}
