package com.ss.institution.service;


import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;

import org.junit.Assert;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.ss.common.logging.RequestContext;
import com.ss.common.util.ObjectXMLConversion;
import com.ss.common.util.UserUtil;
import com.ss.course.dao.CourseMirrorMgmtDAO;
import com.ss.course.service.CourseMgmtService;
import com.ss.course.value.CourseTranscript;
import com.ss.course.value.TransferCourse;
import com.ss.course.value.TransferCourseMirror;
import com.ss.evaluation.service.TransferCourseService;
import com.ss.evaluation.value.College;
import com.ss.evaluation.value.StudentInstitutionDegree;
import com.ss.evaluation.value.StudentInstitutionTranscript;
import com.ss.institution.dao.InstitutionMgmtDao;
import com.ss.institution.dao.InstitutionMirrorMgmtDao;
import com.ss.institution.value.AccreditingBodyInstitute;
import com.ss.institution.value.ArticulationAgreement;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionAddress;
import com.ss.institution.value.InstitutionDegree;
import com.ss.institution.value.InstitutionMirror;
import com.ss.institution.value.InstitutionTermType;
import com.ss.institution.value.InstitutionTranscript;
import com.ss.institution.value.InstitutionTranscriptKey;
import com.ss.institution.value.InstitutionTranscriptKeyDetails;
import com.ss.user.dao.UserDAO;
import com.ss.user.service.UserService;
import com.ss.user.value.User;

/**
 * Service implementation for @link {@link InstitutionService}.
 * @author binoy.mathew
 */
@Service
public class InstitutionServiceImpl implements InstitutionService {

	private static transient Logger log = LoggerFactory.getLogger( InstitutionServiceImpl.class);
	@Autowired
	private InstitutionMgmtDao institutionDao;
	
	@Autowired
	private InstitutionMirrorMgmtDao institutionMirrorDao;
	
	@Autowired
	private CourseMgmtService courseMgmtService;
	
	@Autowired
	private CourseMirrorMgmtDAO courseMirrorMgmtDAO;
	
	@Autowired
	private AccreditingBodyInstituteService  accreditingBodyInstituteService;
	
	@Autowired
	private ArticulationAgreementService articulationAgreementService;
	
	@Autowired
	private InstitutionTermTypeService institutionTermTypeService;
	
	@Autowired
	private InstitutionTranscriptKeyService institutionTranscriptKeyService;
	
	@Autowired
	private UserDAO userDao;
	
	@Autowired
	private UserService userService;
	
	
	@Override
	public Institution getInstitutionById(String institutionId) {
		Institution institution=institutionDao.getInstitutionById( institutionId );
		institution.setAccreditingBodyInstitutes(accreditingBodyInstituteService.getAllAccreditingBodyInstitute(institutionId));
		institution.setInstitutionTermTypes(institutionTermTypeService.getAllInstitutionTermType(institutionId));
		institution.setArticulationAgreements(articulationAgreementService.getAllArticulationAgreement(institutionId));
		institution.setInstitutionTranscriptKeys(institutionTranscriptKeyService.getAllInstitutionTranscriptKey(institutionId));
		institution.setAddresses(getInstitutionAddresses(institutionId));
		institution.setLastStudent(institutionDao.getLastStudentbyInstitutionId(institutionId));
	
		return institution;
	}

	@Override
	public List<Institution> getAllInstitutions() {
		return institutionDao.getAllInstitutions();
	}
	public InstitutionDegree getInstitutionDegreeByInstituteIDAndDegreeName(
			String institutionId, String degreeName){
		return institutionDao.getInstitutionDegreeByInstituteIDAndDegreeName(institutionId,degreeName);
	}

	@Override
	public Institution getInstitutionForStudentProgramEvaluation( String studentProgramEvalId ) {
		return institutionDao.getInstitutionForStudentProgramEvaluation( studentProgramEvalId );
	}
	
	@Override
	public List<StudentInstitutionDegree> getStudentInstitutionDegreeListForStudentInstitutionTranscript( StudentInstitutionTranscript studentInstitutionTranscript ) {
		return institutionDao.getStudentInstitutionDegreeListForStudentInstitutionTranscript( studentInstitutionTranscript );
	}

	@Override
	public Institution getInstitutionByCodeTitle(String schoolCode,
			String instituteTitle) {
		return institutionDao.getInstitutionByCodeTitle(schoolCode, instituteTitle);
	}

	@Override
	public void addInstitution(Institution institution) {
		institutionDao.addInstitution(institution);
		
	}

	@Override
	public List<Institution> getAllInstitutions(String institutionId) {
		return institutionDao.getAllInstitutions(institutionId);
	}

	@Override
	public List<Institution> getAllNotEvalutedInstitutions() {
		return institutionDao.getAllNotEvalutedInstitutions();
	}
	@Override
	public List<Institution> getAllEvaluatedInstitutions(){
		return institutionDao.getAllEvaluatedInstitutions();
	} 
	@Override
	public List<Institution> getAllConflictInstitutions(){
		return institutionDao.getAllConflictInstitutions();
	}
	@Override
	public boolean schoolCodeExist(String schoolCode, String institutionId) {
		return institutionDao.schoolCodeExist(schoolCode, institutionId);
	}

	@Override
	public boolean schoolTitleExist(String schoolTitle, String institutionId) {
		return institutionDao.schoolTitleExist(schoolTitle, institutionId);
	}


	@Override
	public InstitutionMirror addInstitutionMirror(Institution institution,String evaluatorId) {
		InstitutionMirror im = new InstitutionMirror();
		try{
			im.setInstitutionId(institution.getId());
			im.setEvaluatorId(evaluatorId);
			im.setCreatedTime(new Date());
			im.setEvaluationStatus("TEMP");
			im.setInstitutionDetails(ObjectXMLConversion.encodeObjectToXML(institution));
			List<InstitutionMirror> institutionMirrors=institutionMirrorDao.getCompletedInstitutionMirrorList(institution.getId());
			if(institutionMirrors.size()<2){
				institutionMirrorDao.addInstitutionMirror(im); 
			}
			if(institution.getCheckedBy() == null){
				institution.setCheckedBy(evaluatorId);
			}
			else if(institution.getConfirmedBy() == null){
				institution.setConfirmedBy(evaluatorId);
			}
			institutionDao.addInstitution(institution);
		}catch (Exception e) {
			//log.error("----"+e,e);
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Exception Occured."+e+" RequestId:"+uniqueId, e);
		}
		return im;
	}
	@Override
	public InstitutionMirror getInstitutionMirrorByInstitutionId(String institutionId) {
		InstitutionMirror im;
		User currentUser = UserUtil.getCurrentUser();
		//im = institutionMirrorDao.getNotCompletedInstitutionMirrorByEvaluatorIdAndInstitutionId(currentUser.getId(), institutionId);
		im = institutionMirrorDao.getInstitutionMirrorByEvaluatorIdAndInstitutionId(currentUser.getId(), institutionId);
		return im;
	}

	@Override
	public boolean isInstitutionEvaluated(String institutionId) {
		Institution institution = institutionDao.findById(institutionId);
		return institution.getEvaluationStatus().equalsIgnoreCase("EVALUATED");
	}

	/*@Override
	public Institution getInstitutionForEvaluation() {
		Institution institution = null;
		boolean entry4ThisEvaluatorCompleteExist=false;
		try{
			User currentUser = UserUtil.getCurrentUser();
			// getInstitutionMirrorList with status!='COMPLETE'
			List<InstitutionMirror> institutionMirrors = institutionMirrorDao.getInstitutionMirrorList(institution.getId());
			for(InstitutionMirror instMirror:institutionMirrors){
				if(instMirror.getEvaluatorId().equalsIgnoreCase(currentUser.getId()));
				{
					entry4ThisEvaluatorCompleteExist=true;
					break;
				}
			}
			//if 2 entries of mirror are already there with status='COMPLETE' then take a fresh course for evaluation
			if(institutionMirrors.size()==1 && !entry4ThisEvaluatorCompleteExist){
				InstitutionMirror im = institutionMirrorDao.getAssignedInstituteMirrorForEvaluator(currentUser.getId());
				if(im != null){
					//institution= institutionDao.findById(im.getInstitutionId());
					institution = (Institution)ObjectXMLConversion.decodeXMLToObject(im.getInstitutionDetails());
				}
			}
			else{
				
				TransferCourse oldestCourse = courseMgmtService.getOldestNotEvalauatedCourse();
				if(oldestCourse == null){
					institution= institutionDao.getOldestUnEvaluatedInstitution();
				}
				else{
					institution= oldestCourse.getInstitution();
				}
			}
		}
		catch (Exception e) {
			log.error("Exception while fetching the Institution for evaluations ---- "+e,e);
		}
			return institution;
	}
	*/
	@Override
	public void markInstitutionMirrorAsCompleted(String institutionMirrorId){
		InstitutionMirror im = institutionMirrorDao.findById(institutionMirrorId);
		im.setEvaluationStatus("COMPLETED");
		institutionMirrorDao.saveInstitutionMirror(im);
		// Mark Course Complete will be individual not with the institution.
		/*List<TransferCourseMirror> tcmList = courseMirrorMgmtDAO.getTransferCourseMirrorsByInstMirrorId(institutionMirrorId);
		for(TransferCourseMirror tcm : tcmList){
			tcm.setEvaluationStatus("COMPLETED");
			courseMirrorMgmtDAO.saveInstitutionMirror(tcm);
		}*/
	}
	@Override	
	public void updateInstitutionMirror(Institution institution, String institutionMirrorId){
		InstitutionMirror institutionMirror= new InstitutionMirror();
		InstitutionMirror imOld = institutionMirrorDao.findById(institutionMirrorId);
		User currentUser = UserUtil.getCurrentUser();
		Institution instOld = (Institution)ObjectXMLConversion.decodeXMLToObject(imOld.getInstitutionDetails());
		
		institution.setAccreditingBodyInstitutes(instOld.getAccreditingBodyInstitutes());
		institution.setArticulationAgreements(instOld.getArticulationAgreements());
		institution.setInstitutionTermTypes(instOld.getInstitutionTermTypes());
		institution.setInstitutionTranscriptKeys(instOld.getInstitutionTranscriptKeys());
		
		institutionMirror.setInstitutionId(institution.getId());
		institutionMirror.setId(institutionMirrorId);
		institutionMirror.setEvaluatorId(currentUser.getId());
		institutionMirror.setEvaluationStatus("TEMP");
		institutionMirror.setInstitutionDetails(ObjectXMLConversion.encodeObjectToXML(institution));
		//List<InstitutionMirror> institutionMirrorList=  institutionMirrorDao.getInstitutionMirrorList(institution.getId());
		institutionMirrorDao.addInstitutionMirror(institutionMirror);
		
	}
	@Override
	public boolean isInstituteMirrorPresent(String institutionId){

		InstitutionMirror institutionMirror= institutionMirrorDao.getNotCompletedInstitutionMirrorByEvaluatorIdAndInstitutionId(UserUtil.getCurrentUser().getId(), institutionId);
		if(institutionMirror==null)
			return false;
		else
			return true;
		
	}

	@Override
	public InstitutionMirror getInstitutionMirrorById(String id) {
		return institutionMirrorDao.findById(id);
	}
	
	@Override
	public Institution getInstitutionForEvaluation() {
		Institution institution = null;
		String currentUserId= UserUtil.getCurrentUser().getId();
		//1. Check in CourseMirror any entries for current Evaluator if yes then display respective institution

		List<TransferCourseMirror> listMirrorTransferCourse=	courseMirrorMgmtDAO.getTEMPCourseMirrorsByEvaluatorId(currentUserId);
		Institution institutionAssigned=institutionDao.getAssignedInstitution();
		
		List<TransferCourse> listTransferCourse=	courseMgmtService.getAllNotEvalutedTransferCourseForCurrentUser(currentUserId);
		if(listMirrorTransferCourse.size()>0){
			TransferCourseMirror cm =listMirrorTransferCourse.get(0);
			TransferCourse tc= courseMgmtService.getTransferCourseById(cm.getTransferCourseId());
			
			institution=tc.getInstitution();
			
		}
		else if(listTransferCourse!=null && listTransferCourse.size()>0){
			institution=listTransferCourse.get(0).getInstitution();
		}
		// case where No courses are there but institution is not evaluated and Institution mirror is not marked complete
		else if(institutionAssigned != null){
			institution = institutionAssigned;
		}
		else{
			//2.If not then find oldest NOT Evalutated course from original TransferCourse
			TransferCourse oldestCourse = courseMgmtService.getOldestNotEvaluatedCourse();
			
			if(oldestCourse.getId()== null || oldestCourse.getId().isEmpty()){
				institution= institutionDao.getOldestUnEvaluatedInstitution();
			}
			else{
				institution= oldestCourse.getInstitution();
			}
		}
		
		
		return institution;
		
	}
	
	@Override
	public List<Institution> getConflictInstitutionsWithConflictCourses(String searchBy, String searchText) {
		HashMap<String,Institution> instHashMap= new HashMap<String, Institution>();
		
		List<Institution> institutionConflicList= institutionDao.getAllConflictInstitutions();
		
		
		List<TransferCourse> transferCourseList;
		transferCourseList=courseMgmtService.getConflictCourses();
		Institution institution;
		//First take All Institution from conflictCourses take care not to repeat Institution
		for(TransferCourse course:transferCourseList){
			institution= course.getInstitution();
			if(!instHashMap.containsKey(institution.getId())){
				instHashMap.put(institution.getId(),institution);
				//fill institutions with conflict courses.
				setCoursesInInstitution(institution);
			}
			
		}
		//Next Take all Institution from conflictInstitution skip instituions which are already present.
		for(Institution inst:institutionConflicList){
			if(!instHashMap.containsKey(inst.getId())){
				instHashMap.put(inst.getId(),inst);
				setCoursesInInstitution(inst);
			}
		}
		
		//Filter implementation by schoolcode and institution name
		List<Institution> institutionList=new ArrayList<Institution>();
		if(null!=searchBy && null !=searchText){
		for (Institution inst:instHashMap.values()){
			
				if(searchBy.equals("1")&& inst.getSchoolcode().toLowerCase().contains(searchText.toLowerCase())){
					institutionList.add(inst);
				}else if(searchBy.equals("2")&& inst.getName().toLowerCase().contains(searchText.toLowerCase())){
					institutionList.add(inst);
				}
			}
		}else{
			institutionList.addAll(instHashMap.values());
		}
		
		//filling of Evaluators
		for(Institution inst:institutionList){
			if(inst.getCheckedBy()!=null){
				inst.setEvaluator1(userDao.findById(inst.getCheckedBy()));
			}
			if(inst.getConfirmedBy()!=null){
				inst.setEvaluator2(userDao.findById(inst.getConfirmedBy()));
			}
		}
		//List<Institution> institutionList=new ArrayList<Institution>(instHashMap.values());
		
		
		return  institutionList;
	}
	
	private void setCoursesInInstitution(Institution institution){
		List<TransferCourse> transferCourseList=courseMgmtService.getConflictCoursesByInstitutionId(institution.getId());
		//filling of Evaluators
		for(TransferCourse course:transferCourseList){
			if(course.getCheckedBy()!=null){
				course.setEvaluator1(userDao.findById(course.getCheckedBy()));
			}
			if(course.getConfirmedBy()!=null){
				course.setEvaluator2(userDao.findById(course.getConfirmedBy()));
			}
		}
		institution.setTransferCourses(transferCourseList);
	}
	@Override
	public HashMap<String, Institution> getConflictInstitutionListFromMirrors(String institutionId){
		HashMap<String, Institution> institutionsMap= new HashMap<String, Institution>();
		//List<Institution> institutions=new ArrayList<Institution>();
		List<InstitutionMirror> institutionMirrors=institutionMirrorDao.getCompletedInstitutionMirrorList(institutionId);
		Institution institution;
		for (InstitutionMirror iMirror:institutionMirrors){
			institution= new Institution();
			institution = (Institution)ObjectXMLConversion.decodeXMLToObject(iMirror.getInstitutionDetails());
			institution.setEvaluator1(userService.getUserByUserId(iMirror.getEvaluatorId()));
			//institutions.add(institution);
			if(institution.getParentInstitutionId()!=null && !"".equals(institution.getParentInstitutionId())){
				Institution parentInstitution = getInstitutionById(institution.getParentInstitutionId());
				institution.setParentInstitutionName(parentInstitution.getName());
			}
			institutionsMap.put(iMirror.getId(), institution);
		}
		
		return institutionsMap;
	}
	
	@Override
	@Transactional( propagation=Propagation.REQUIRED, readOnly=false, rollbackForClassName={"java.lang.Exception"} )
	public void addInstitutionWithChilds(Institution institution){
		institution.setEvaluationStatus("EVALUATED");
		institution.setModifiedBy(UserUtil.getCurrentUser().getId());
		institutionDao.addInstitution(institution);
	
		if(institution.getAccreditingBodyInstitutes().size()>0){
			int accrBodyCount = 0;
			for(AccreditingBodyInstitute abi:institution.getAccreditingBodyInstitutes()){
				//for Addition set Id null
				abi.setId(null);
				if(accrBodyCount == 0){
					abi.setEffective(true);
				}
				accreditingBodyInstituteService.addAccreditingBodyInstitute( abi);	
				accrBodyCount = accrBodyCount + 1;
			}
			
		}
		if(institution.getArticulationAgreements().size()>0){
			int arAgrCount = 0;
			for(ArticulationAgreement aa:institution.getArticulationAgreements()){
				aa.setId(null);
				if(arAgrCount == 0){
					aa.setEffective(true);
				}
				articulationAgreementService.addArticulationAgreement(aa);
				arAgrCount = arAgrCount + 1;
			}
			
		}
		if(institution.getInstitutionTermTypes().size()>0){
			int iTTCount = 0;
			for(InstitutionTermType itt:institution.getInstitutionTermTypes()){
				itt.setId(null);
				if(iTTCount == 0){
					itt.setEffective(true);
				}
				institutionTermTypeService.addInstitutionTermType(itt);
				iTTCount = iTTCount + 1;
			}
		}
		if(institution.getInstitutionTranscriptKeys().size()>0){
			int iTrKeyCount = 0;
			for(InstitutionTranscriptKey itk:institution.getInstitutionTranscriptKeys()){
				itk.setId(null);
				if(iTrKeyCount == 0){
					itk.setEffective(true);
				}
				institutionTranscriptKeyService.addInstitutionTranscriptKey(itk);
				iTrKeyCount = iTrKeyCount + 1;
			}
		}
	}
	
	@Override
	public List<Institution> getInstitutionsList(String searchBy, String searchText,String status, String byState){
		
		List<Institution> list = institutionDao.getInstitutionsList(searchBy, searchText, status, byState);
		return list;
	}

	@Override
	public int getConflictCount(){
		int conflictCount=0;
		try{
			List<Institution> institutionConflicList= institutionDao.getAllConflictInstitutions();
			List<TransferCourse> transferCourseList=courseMgmtService.getConflictCourses();
			conflictCount=institutionConflicList.size()+transferCourseList.size();
		}catch (Exception e) {
			log.error("Error=="+e,e);
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Error=="+e+" RequestId:"+uniqueId, e);
		}
		return conflictCount;
	}
	@Override
	public void skipInstitutionNCourse(String institutionId){
		institutionDao.skipInstitutionNCourse(institutionId);
	}
	
	@Override
	public List<Institution> getInstitutionsForReassignment(){
		List<Institution> reAssignInstitutionList = institutionDao.getInstitutionsForReassignment();
		if(reAssignInstitutionList != null){
			for(Institution inst : reAssignInstitutionList){
				if(inst.getCheckedBy() != null){
					inst.setEvaluator1(userDao.findById(inst.getCheckedBy()));
				}
				if(inst.getConfirmedBy() != null){
					inst.setEvaluator2(userDao.findById(inst.getConfirmedBy()));
				}
			}
		}
		return reAssignInstitutionList;
	}
	
	@Override
	public Institution setInstitutionWithTempMirrorEvaluators(String institutionId){
		Institution i = institutionDao.findById(institutionId);
		/*InstitutionMirror im1 = institutionMirrorDao.getNotCompletedInstitutionMirrorByEvaluatorIdAndInstitutionId(i.getCheckedBy(), institutionId);
		InstitutionMirror im2 = institutionMirrorDao.getNotCompletedInstitutionMirrorByEvaluatorIdAndInstitutionId(i.getConfirmedBy(), institutionId);
		if(im1 != null){
			i.setEvaluator1(userDao.findById(i.getCheckedBy()));
		}
		if(im2 != null){
			i.setEvaluator2(userDao.findById(i.getConfirmedBy()));
		}*/
		if (i.getCheckedBy()!=null &&! i.getCheckedBy().isEmpty()){
			i.setEvaluator1(userDao.findById(i.getCheckedBy()));
		}
		if (i.getConfirmedBy()!=null &&! i.getConfirmedBy().isEmpty()){
			i.setEvaluator2(userDao.findById(i.getConfirmedBy()));
		}
		return i;
	}
	
	@Override
	public List<User> getAssignableEvaluatorsForInstitution(Institution i){
		List<User> assignableEvaluatorlist = userDao.findUsersByRoleId("4");
		List<User> newAssignableEvaluatorList = new ArrayList<User>();
		for(User user : assignableEvaluatorlist){
			if(i.getCheckedBy() != null){
				if(user.getId().equals(i.getCheckedBy())){
					continue;
				}
			}
			if(i.getConfirmedBy() != null){
				if(user.getId().equals(i.getConfirmedBy())){
					continue;
				}
			}
			newAssignableEvaluatorList.add(user);
			
		}
		return newAssignableEvaluatorList;
	}
	
	@Override
	@Transactional( propagation=Propagation.REQUIRED, readOnly=false, rollbackForClassName={"java.lang.Exception"} )
	public void reAssignInstitution(String institutionId, String fromId, String toId){
		//InstitutionMirror im = institutionMirrorDao.getInstitutionMirrorByEvaluatorIdAndInstitutionId(fromId, institutionId);
		Institution i = institutionDao.findById(institutionId);
		if(fromId.equals(i.getCheckedBy())){
			i.setCheckedBy(toId);
		}
		else if(fromId.equals(i.getConfirmedBy())){
			i.setConfirmedBy(toId);
		}
		//im.setEvaluatorId(toId);
		
		institutionDao.reAssignCoursesOfInstitution(institutionId, toId, fromId);
		institutionDao.addInstitution(i);
		//institutionMirrorDao.addInstitutionMirror(im);
		
	}
	
	@Override
	public void removeInstitutionMirrors(String institutionId){
		institutionMirrorDao.removeInstitutionMirrors(institutionId);
	}
	
	@Override
	public void addInstitutionTranscript(InstitutionTranscript it) {
		institutionDao.addInstitutionTranscript(it);
	}
	@Override
	public InstitutionTranscript getInstitutionTranscript(String institutionId){
		return institutionDao.getInstitutionTranscript(institutionId);
		
	}

	@Override
	public List<Institution> getInstituteForState(String state) {
		
		return institutionDao.findInstituteForState(state);
	}

	@Override
	public List<Institution> getAllInstituteForEvaluation() {
		
		List<Institution> institutionList = new ArrayList<Institution>();
		String currentUserId= UserUtil.getCurrentUser().getId();
		//1. Check in CourseMirror any entries for current Evaluator if yes then display respective institution

		List<TransferCourseMirror> listTransferCourse=	courseMirrorMgmtDAO.getTEMPCourseMirrorsByEvaluatorId(currentUserId);
		InstitutionMirror iMirror = institutionMirrorDao.getAssignedInstituteMirrorForEvaluator(currentUserId);
		if(listTransferCourse.size()>0){
			for(TransferCourseMirror cm:listTransferCourse){
				Institution institution = null;
				TransferCourse tc= courseMgmtService.getTransferCourseById(cm.getTransferCourseId());
				InstitutionMirror im=institutionMirrorDao.getNotCompletedInstitutionMirrorByEvaluatorIdAndInstitutionId(currentUserId,tc.getInstitution().getId());
				//a. if already entry in mirror of institution then show the institution from mirror institutionDetails XML
				if(im != null){
					institution = (Institution)ObjectXMLConversion.decodeXMLToObject(im.getInstitutionDetails());
				}else{
					institution =getInstitutionById(tc.getInstitution().getId());
				}
				institutionList.add(institution);
			}
		}
		// case where No courses are there but institution is not evaluated and Institution mirror is not marked complete
		else if(iMirror != null){
			Institution institution = (Institution)ObjectXMLConversion.decodeXMLToObject(iMirror.getInstitutionDetails());
			institutionList.add(institution);
		}
		else{
			//2.If not then find oldest NOT Evalutated course from original TransferCourse
			Institution institution = null;
			TransferCourse oldestCourse = courseMgmtService.getOldestNotEvaluatedCourse();
			if(oldestCourse == null){
				institution= institutionDao.getOldestUnEvaluatedInstitution();
			}
			else{
				institution= oldestCourse.getInstitution();
			}
			institutionList.add(institution);
		}
		
		return institutionList;
	}

	@Override
	public List<Institution> getInstituteForEvalutationForCurrentUserNotIn(
			String currenUserId, List<String> institutionIds) {
		// TODO Auto-generated method stub
		return institutionDao.findInstituteForEvalutationForCurrentUserNotIn(currenUserId, institutionIds);
	}

	@Override
	public List<StudentInstitutionTranscript> getStudentInstitutionTranscriptAwatingForIENotIn(
			List<String> institutionIds) {
		// TODO Auto-generated method stub
		return institutionDao.getStudentInstitutionTranscriptAwatingForIENotIn(institutionIds);
	}

	@Override
	public List<Institution> getInstitutionByState(String stateCode,String title){
		return institutionDao.getInstitutionByState(stateCode,title);
	}
	
	@Override
	public List<InstitutionAddress> getInstitutionAddresses(String institutionId){
		return institutionDao.getInstitutionAddresses(institutionId);
	}
	
	@Override
	public InstitutionAddress getInstitutionAddress(String addressId){
		return institutionDao.getInstitutionAddress(addressId);
	}
	
	@Override
	public void addInstitutionAddress(InstitutionAddress institutionAddress) {
		institutionDao.addInstitutionAddress(institutionAddress);
		
	}
	
	@Override
	public boolean institutionInTranscriptExist(String studentId, String institutionId){
		return institutionDao.institutionInTranscriptExist(studentId,institutionId);
	}
	
	@Override
	public Institution getInstitutionByTitle(String instituteTitle){
		return institutionDao.getInstitutionByTitle(instituteTitle);
	}
	
	@Override
	public int getEvaluationCount(){
		int conflictCount=0;
		try{
			List<Institution> institutionConflicList= institutionDao.getAllNotEvalutedInstitutions();
			List<TransferCourse> transferCourseList=courseMgmtService.getAllNotEvalutedTransferCourse();
			conflictCount=institutionConflicList.size()+transferCourseList.size();
		}catch (Exception e) {
			log.error("Error=="+e,e);
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Error=="+e+" RequestId:"+uniqueId, e);
		}
		return conflictCount;
	}

	
	@Override
	public void resetConfirmByCheckedBy(String institutionId){
		institutionDao.resetConfirmByCheckedBy(institutionId);
	}

	@Override
	public int getTotalEvaluated(String userId) {
		int count=0;
		try{
			count= institutionDao.getTotalEvaluated(userId);
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Error=="+e+" RequestId:"+uniqueId, e);
		}
		return count;
	}

	@Override
	public int getLast6MonthEvaluated(String userId) {
		int count=0;
		try{
			count= institutionDao.getLast6MonthEvaluated(userId);
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Error=="+e+" RequestId:"+uniqueId, e);
		}
		return count;
	}

	@Override
	public int getLast7DaysEvaluated(String userId) {
		int count=0;
		try{
			count= institutionDao.getLast7DaysEvaluated(userId);
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Error=="+e+" RequestId:"+uniqueId, e);
		}
		return count;
	}

	@Override
	public int getLast3MonthEvaluated(String userId) {
		int count=0;
		try{
			count= institutionDao.getLast3MonthEvaluated(userId);
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Error=="+e+" RequestId:"+uniqueId, e);
		}
		return count;
	}

	@Override
	public int getTodaysEvaluated(String userId) {
		int count=0;
		try{
			count= institutionDao.getTodaysEvaluated(userId);
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Error=="+e+" RequestId:"+uniqueId, e);
		}
		return count;
	}
	
	@Override
	public boolean  institutionCodeExist(String  institutionCode, String institutionId) {
		return institutionDao.institutionCodeExist( institutionCode, institutionId);
	}
    
	/**
	 * Returns the InstitutionCode for the Institution that is passed.The institution Object that is passed to this method needs 
	 * to have the address populated. 
	 * InstitutionCode Standard - Arizona State University ==>ASUAZ001
	 *                            Arkansas State University ==>ASUAZ002
	 */
	@Override
	public String getProcessedInstitutionCode(Institution institution) {
			StringBuffer institutionCode = new StringBuffer();
 			String institutionName = institution.getName();
			if (StringUtils.hasText(institutionName)) {
				String[] stringsSplitBySpace = institutionName.split("\\s+");
				for (String str : stringsSplitBySpace) {
					if(institutionCode.length()<3) {  //use only 3 characters from the name
						institutionCode.append(str.charAt(0));
					}
				}
				institutionCode.append(getStateCode(institution));			
			}
			return  getInstitutionCode(institutionCode,institution.getId(),1);
		}

	/**
	 * Returns the stateCode from the Institution Address
	 * TODO: FIX THE WAY WE ARE STORING THE STATE CODE  -- AZ ARIZONA,CA CALIFORNIA, should be just the CODE AZ,CA
	 * @param institution
	 */
	private String getStateCode(Institution institution) {
		InstitutionAddress instAddress= institution.getInstitutionAddress();
		if(instAddress!=null) {
			String state = instAddress.getState();
			if(StringUtils.hasText(state)) {
				String[] stringsSplitBySpace = state.split("\\s+");
 					return stringsSplitBySpace[0];
			}
			
		}
		return "";
	}
	
	/**
	 * This method gets recursively called untill we get a unique InsitutionCode
	 * @param institutionCode
	 * @param institutionId
	 * @return
	 */
	private String getInstitutionCode(StringBuffer institutionCode,String institutionId,int incrementor){	 	
		String paddedInstCode = getPaddedInstCode(institutionCode.toString(),incrementor);
		if(institutionCodeExist(paddedInstCode,institutionId)){
 			return getInstitutionCode(institutionCode,institutionId,incrementor+1);
		}
		return paddedInstCode.toString().toUpperCase();
	}

	/**
	 * @param instCode
	 */
	private String getPaddedInstCode(String instCode,int incrementor) {	
		StringBuffer instituteCode = new StringBuffer(instCode);
		String increment =String.valueOf(incrementor);
		int paddingRequired = 8 - (instCode.length()+increment.length());
		for (int count = 0; count < paddingRequired; count++) {
			instituteCode.append("0");
		}
		instituteCode.append(incrementor);
		return instituteCode.toString();
	}
	
	@Override
	public List<College> getAllCollege() {	    
	   return institutionDao.findAllCollege();
	}
	@Override
	public void saveInstitution(Institution institution) {
		institutionDao.saveInstitution(institution);
		
	}
	@Override
	public void updateInstitution(Institution institution) {
		institutionDao.updateInstitution(institution);
	}

	
}
