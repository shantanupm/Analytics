package com.ss.evaluation.util;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.StatefulJob;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.ss.common.logging.RequestContext;
import com.ss.common.util.ObjectXMLConversion;
import com.ss.common.util.UserUtil;
import com.ss.course.service.CourseMgmtService;
import com.ss.course.value.CourseCategoryMapping;
import com.ss.course.value.CourseMapping;
import com.ss.course.value.TransferCourse;
import com.ss.course.value.TransferCourseMirror;
import com.ss.course.value.TransferCourseTitle;
import com.ss.evaluation.dao.TranscriptMgmtDAO;
import com.ss.evaluation.enums.TranscriptStatusEnum;
import com.ss.evaluation.service.EvaluationJobService;
import com.ss.evaluation.service.EvaluationService;
import com.ss.evaluation.service.TranscriptService;
import com.ss.evaluation.service.TransferCourseService;
import com.ss.evaluation.value.StudentInstitutionTranscript;
import com.ss.evaluation.value.StudentTranscriptCourse;
import com.ss.institution.service.InstitutionService;
import com.ss.institution.value.AccreditingBodyInstitute;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionMirror;
import com.ss.institution.value.InstitutionTermType;
import com.ss.institution.value.InstitutionTranscriptKey;
import com.ss.institution.value.InstitutionTranscriptKeyDetails;
import com.ss.institution.value.TransferCourseInstitutionTranscriptKeyGradeAssoc;
import com.ss.messaging.service.JMSMessageSenderService;


public class EvalutationJob implements StatefulJob{
	private static transient Logger log = LoggerFactory.getLogger( EvalutationJob.class);
	@Autowired
	private EvaluationJobService evaluationJobService;
	@Autowired
	private TransferCourseService transferCourseService;
	@Autowired
	private InstitutionService institutionService;
	@Autowired
	private EvaluationService evaluationService;
	@Autowired
	private CourseMgmtService courseMgmtService;
	
	@Autowired
	private TranscriptService transcriptService;
	
	@Autowired
	private TranscriptMgmtDAO transcriptMgmtDAO;
	
	@Autowired
	private JMSMessageSenderService jmsMessageSender;
	
	@Override
	public void execute( JobExecutionContext executionContext ) throws JobExecutionException {
		/*10.	The JOB will pick up the oldest course with status as Not Evaluated and both 
		 * the fields (checked_by and confirmed_by populated) then take the corresponding institute of 
		 * that course and check if it is evaluated, if not evaluated then see if there are 2 entries in 
		 * the INST mirror table marked as complete, and compare the BLOBs if identical then change the 
		 * status to evaluated in the master institution. else the status will be CONFLICT state. 
		 * If there is no conflict then only the JOB will go ahead and check for conflicts in the
		 *  courses for that institute.
		11.	 check in course mirror, if there are 2 entries with status as complete and check the 
		checked_by and confirmed_by ids with created_by id in mirror table, 
		System will them compare the BLOBS and if they are identical then will change 
		the status to EVALUATED in course master table. Else  Status will be Awaiting IE MGR(conflict).


		 * */
		System.out.println("JOB========= CA=LL=ED");
		
		//verifyInstitutions();
		//verifyCourses();
		verifyCoursesRelationship();
		markTheSITsForSLEorLOPESorIEM();
		
	}
	
	private void verifyInstitutions(){
		boolean isConflict=false;
		//List of Not Evaluated Institution with checked_by AND confirmed_by both not NULL 
		List<Institution> institutions= evaluationJobService.getNotEvaluatedInstitutionsForJob();
		for(Institution institution:institutions){
			
			if(institution.getEvaluationStatus().equalsIgnoreCase("Not Evaluated")){
				//GET all records for this institutionId in Institution Mirror table with evalutaionStatus COMPLETE
				List<InstitutionMirror> institutionMirrors = evaluationJobService.getCompletedInstitutionMirrors(institution.getId());
				System.out.println(" Inst = "+institution.getName()+" mirror Size ="+institutionMirrors.size());
				if(institutionMirrors.size()==2){
					System.out.println();
					InstitutionMirror institutionMirror1= institutionMirrors.get(0);
					InstitutionMirror institutionMirror2= institutionMirrors.get(1);
					Institution institution1=(Institution)ObjectXMLConversion.decodeXMLToObject(institutionMirror1.getInstitutionDetails());
					Institution institution2=(Institution)ObjectXMLConversion.decodeXMLToObject(institutionMirror2.getInstitutionDetails());
					
					
					if(!institution1.equals(institution2)){
						isConflict=true;
					}else if(institution1.getAccreditingBodyInstitutes().size()!=institution2.getAccreditingBodyInstitutes().size()){
						isConflict=true;
					}else if(institution1.getAccreditingBodyInstitutes().size()==institution2.getAccreditingBodyInstitutes().size() && institution2.getAccreditingBodyInstitutes().size()>0){
						List<AccreditingBodyInstitute> ab1=institution1.getAccreditingBodyInstitutes();
						List<AccreditingBodyInstitute> ab2=institution2.getAccreditingBodyInstitutes();
						Collections.sort(ab1, new AccreditingBodyInstituteComparator());
						Collections.sort(ab2, new AccreditingBodyInstituteComparator());
						for(int i=0;i<ab1.size();i++){
							if(!ab1.get(i).equals(ab2.get(i))){
								isConflict=true;
								
							};
						}
					}else if(institution1.getInstitutionTermTypes().size()!=institution2.getInstitutionTermTypes().size()){
						isConflict=true;
					}else if(institution1.getInstitutionTermTypes().size()==institution2.getInstitutionTermTypes().size()&& institution2.getInstitutionTermTypes().size()>0){
						List<InstitutionTermType> itt1=institution1.getInstitutionTermTypes();
						List<InstitutionTermType> itt2=institution2.getInstitutionTermTypes();
						Collections.sort(itt1, new InstitutionTermTypeComparator());
						Collections.sort(itt2, new InstitutionTermTypeComparator());
						for(int i=0;i<itt1.size();i++){
							if(!itt1.get(i).equals(itt2.get(i))){
								isConflict=true;
								
							};
						}
					
					}
					else if(institution1.getInstitutionTranscriptKeys().size()!=institution2.getInstitutionTranscriptKeys().size()){
						isConflict=true;
				
					}else if(institution1.getInstitutionTranscriptKeys().size()==institution2.getInstitutionTranscriptKeys().size()&& institution2.getInstitutionTranscriptKeys().size()>0){
						List<InstitutionTranscriptKey> itk1=institution1.getInstitutionTranscriptKeys();
						List<InstitutionTranscriptKey> itk2=institution2.getInstitutionTranscriptKeys();
						for(int i=0;i<itk1.size();i++){
							if(itk1.get(i).getInstitutionTranscriptKeyDetailsList().size()!=
								itk2.get(i).getInstitutionTranscriptKeyDetailsList().size()){
								isConflict=true;
							}else if(itk1.get(i).getInstitutionTranscriptKeyDetailsList().size()==
								itk2.get(i).getInstitutionTranscriptKeyDetailsList().size()){
								Collections.sort(itk1.get(i).getInstitutionTranscriptKeyDetailsList(), new InstitutionTranscriptKeyDetailsComparator());
								Collections.sort(itk2.get(i).getInstitutionTranscriptKeyDetailsList(), new InstitutionTranscriptKeyDetailsComparator());
								for(int k=0;k<itk1.get(i).getInstitutionTranscriptKeyDetailsList().size();k++){
									if(!itk1.get(i).getInstitutionTranscriptKeyDetailsList().get(k).
											equals(itk2.get(i).getInstitutionTranscriptKeyDetailsList().get(k))){
										isConflict=true;
										
									};
								}
							}
							
						}
					}
					
					//Comparison
					if(isConflict){
						institution.setEvaluationStatus(TranscriptStatusEnum.CONFLICT.getValue());
					}else{
						institution.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
					}
					//NOW Update institution object
					institutionService.addInstitution(institution);
				}
			}
		}
	}
	
	private void verifyCourses(){
		//GET all records for this institutionId in TransferCourse table with evalutaionStatus NOT EVALUATED with checked_by AND confirmed_by both not NULL 
		try{
			boolean isConflict=false;
			List<TransferCourse> listtransferCourse= evaluationJobService.getNotEvaluatedTransferCourses();
			for(TransferCourse tc:listtransferCourse){
				//GET all records for this transferCourseId in TransferCourse Mirror table with evalutaionStatus COMPLETE
				
				
				//if institution is not Evaluated then there is no need to evaluate/check for course
				
				if(institutionService.isInstitutionEvaluated(tc.getInstitution().getId())){
					List<TransferCourseMirror> transferCourseMirrors= evaluationJobService.getCompletedTransferCourseMirrors(tc.getId());
					
					if(transferCourseMirrors.size()==2){
						TransferCourseMirror transferCourseMirror1 = transferCourseMirrors.get(0);
						TransferCourseMirror transferCourseMirror2 = transferCourseMirrors.get(1);
						TransferCourse transferCourse1=(TransferCourse)ObjectXMLConversion.decodeXMLToObject(transferCourseMirror1.getCourseDetails());
						TransferCourse transferCourse2=(TransferCourse)ObjectXMLConversion.decodeXMLToObject(transferCourseMirror2.getCourseDetails());
				
						if(!transferCourse1.equals(transferCourse2)){
							isConflict=true;
						}else{
							if((transferCourse1.getCourseMappings().size()!=transferCourse2.getCourseMappings().size())){
								isConflict=true;
							}else if(transferCourse1.getCourseMappings().size()>0){
								List<CourseMapping> courseMappings1=transferCourse1.getCourseMappings();
								List<CourseMapping> courseMappings2=transferCourse2.getCourseMappings();
								Collections.sort(courseMappings1, new CustomComparator());
								Collections.sort(courseMappings2, new CustomComparator());
								for(int i=0;i<transferCourse1.getCourseMappings().size();i++){
									if(!courseMappings1.get(i).equals(courseMappings2.get(i))){
										isConflict=true;
										
									};
								}
							}
							
							if((transferCourse1.getCourseCategoryMappings().size()!=transferCourse2.getCourseCategoryMappings().size())){
								isConflict=true;
							}else if(transferCourse1.getCourseCategoryMappings().size()>0){
								List<CourseCategoryMapping> courseCategoryMappings1=transferCourse1.getCourseCategoryMappings();
								List<CourseCategoryMapping> courseCategoryMappings2=transferCourse2.getCourseCategoryMappings();
								Collections.sort(courseCategoryMappings1, new CourseCategoryMappingComparator());
								Collections.sort(courseCategoryMappings2, new CourseCategoryMappingComparator());
								for(int i=0;i<transferCourse1.getCourseMappings().size();i++){
									if(!courseCategoryMappings1.get(i).equals(courseCategoryMappings2.get(i))){
										isConflict=true;
										
									};
								}
							}
							
							if((transferCourse1.getTitleList().size()!=transferCourse2.getTitleList().size())){
								isConflict=true;
							}else if(transferCourse1.getTitleList().size()>0){
								List<TransferCourseTitle> transferCourseTitles1 = transferCourse1.getTitleList();
								List<TransferCourseTitle> transferCourseTitles2=transferCourse2.getTitleList();
								Collections.sort(transferCourseTitles1, new TransferCourseTitleComparator());
								Collections.sort(transferCourseTitles2, new TransferCourseTitleComparator());
								for(int i=0;i<transferCourse1.getCourseMappings().size();i++){
									if(!transferCourseTitles1.get(i).equals(transferCourseTitles2.get(i))){
										isConflict=true;
										
									};
								}
							}
						}
						
					}
					else continue;
						
						//Comparison
						if(isConflict){
							tc.setEvaluationStatus(TranscriptStatusEnum.CONFLICT.getValue());
						}else{
							tc.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
							// the mirrors are removed when the status is changed to evaluated
							courseMgmtService.removeTransferCourseMirrors(tc.getId());
							tc.setCheckedBy(null);
							tc.setConfirmedBy(null);
							for(TransferCourseTitle tct : tc.getTitleList()){
								tct.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
								transferCourseService.addTransferCourseTitle(tct);
							}
						}
						//NOW Update transferCourse object
						transferCourseService.addTransferCourse(tc);
				}
			}
		
		
		}catch (Exception e) {
			//log.error("-Exception in Evaluation Job---------"+e,e);
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Exception in Evaluation Job---------."+e+" RequestId:"+uniqueId, e);
		}
		
	}
	
	private void markTheSITsForSLEorLOPESorIEM(){
		List<StudentInstitutionTranscript> sitList = evaluationJobService.getAwaitingIEorIEMSITList();
		for(StudentInstitutionTranscript sit : sitList){
			if(evaluationService.isTranscriptEligibleForLOPESOrSLE(sit)){
				if(sit.getOfficial()){
					sit.setEvaluationStatus(TranscriptStatusEnum.AWAITINGSLE.getValue());
				}
				else{
					sit.setEvaluationStatus(TranscriptStatusEnum.AWAITINGLOPE.getValue());
				}
				
			}
			else{
				if(sit.getEvaluationStatus().equalsIgnoreCase(TranscriptStatusEnum.AWAITINGIEM.getValue())){
					continue;
				}
				else if(evaluationService.isTranscriptForIEM(sit)){
					sit.setEvaluationStatus(TranscriptStatusEnum.AWAITINGIEM.getValue());
				}
			}
			evaluationService.saveStudentInstitutionTranscript(sit);
		}
	}
	
	private void verifyCoursesRelationship(){
		//GET all records for this institutionId in TransferCourse table with evalutaionStatus NOT EVALUATED with checked_by AND confirmed_by both not NULL 
		try{
			boolean isConflict=false;
			List<TransferCourse> listtransferCourse= evaluationJobService.getNotEvaluatedTransferCourses();
			for(TransferCourse tc:listtransferCourse){
				//GET all records for this transferCourseId in TransferCourse Mirror table with evalutaionStatus COMPLETE
				
				
				//if institution is not Evaluated then there is no need to evaluate/check for course
				
				if(institutionService.isInstitutionEvaluated(tc.getInstitution().getId())){
					List<TransferCourseMirror> transferCourseMirrors= evaluationJobService.getCompletedTransferCourseMirrors(tc.getId());
					TransferCourse transferCourse1 = null;
					TransferCourse transferCourse2 = null;
					if(transferCourseMirrors.size()==2){
						TransferCourseMirror transferCourseMirror1 = transferCourseMirrors.get(0);
						TransferCourseMirror transferCourseMirror2 = transferCourseMirrors.get(1);
						transferCourse1 = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(transferCourseMirror1.getCourseDetails());
						transferCourse2 = (TransferCourse)ObjectXMLConversion.decodeXMLToObject(transferCourseMirror2.getCourseDetails());
				
						/*if(!transferCourse1.equals(transferCourse2)){
							isConflict=true;
						}else{*/
							if(!transferCourse1.getTransferStatus().equalsIgnoreCase(transferCourse2.getTransferStatus())){
								isConflict=true;
							}else if(transferCourse1.getCourseMappings().size() != transferCourse2.getCourseMappings().size()){
								isConflict=true;
							}else if(transferCourse1.getCourseMappings().size()>0){
								List<CourseMapping> courseMappings1=transferCourse1.getCourseMappings();
								List<CourseMapping> courseMappings2=transferCourse2.getCourseMappings();
								Collections.sort(courseMappings1, new CustomComparator());
								Collections.sort(courseMappings2, new CustomComparator());
								for(int i=0;i<transferCourse1.getCourseMappings().size();i++){
									if(!courseMappings1.get(i).equals(courseMappings2.get(i))){
										if(!courseMappings1.get(i).getCourseMappingDetails().get(0).getGcuCourse().getTitle().equals(
												courseMappings2.get(i).getCourseMappingDetails().get(0).getGcuCourse().getTitle()) && 
												!courseMappings1.get(i).getCourseMappingDetails().get(0).getGcuCourse().getCourseCode().equals(
														courseMappings2.get(i).getCourseMappingDetails().get(0).getGcuCourse().getCourseCode())){
											isConflict=true;
											break;
										}
									};
								}
							}
							
							if((transferCourse1.getCourseCategoryMappings().size() != transferCourse2.getCourseCategoryMappings().size())){
								isConflict=true;
							}else if(transferCourse1.getCourseCategoryMappings().size()>0){
								List<CourseCategoryMapping> courseCategoryMappings1 = transferCourse1.getCourseCategoryMappings();
								List<CourseCategoryMapping> courseCategoryMappings2 = transferCourse2.getCourseCategoryMappings();
								Collections.sort(courseCategoryMappings1, new CourseCategoryMappingComparator());
								Collections.sort(courseCategoryMappings2, new CourseCategoryMappingComparator());
								for(int i=0;i<transferCourse1.getCourseMappings().size();i++){
									if(!courseCategoryMappings1.get(i).equals(courseCategoryMappings2.get(i))){
										if(!courseCategoryMappings1.get(i).getGcuCourseCategory().getName().equals(courseCategoryMappings2.get(i).getGcuCourseCategory().getName())){
											isConflict=true;
											break;
										}
									};
								}
							}
						/*}*/
						
					}
					else continue;
						
						//Comparison
						if(isConflict){
							tc.setEvaluationStatus(TranscriptStatusEnum.CONFLICT.getValue());
						}else{
							/**If no Conflict than consider second IE changes. 
							 * */
							tc.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
							
							tc.setCheckedBy((transferCourse2 != null && transferCourse2.getId() != null && !transferCourse2.getId().isEmpty())?transferCourse2.getCheckedBy():(transferCourse1 != null && transferCourse1.getId() != null && !transferCourse1.getId().isEmpty())?transferCourse1.getCheckedBy():null);
							tc.setConfirmedBy((transferCourse2 != null && transferCourse2.getId() != null && !transferCourse2.getId().isEmpty())?transferCourse2.getConfirmedBy():(transferCourse1 != null && transferCourse1.getId() != null && !transferCourse1.getId().isEmpty())?transferCourse1.getConfirmedBy():null);
							try{
								jmsMessageSender.sendTransferCourseMessage(tc);
							}catch (Exception e) {
								String uniqueId = RequestContext.getRequestIdFromContext();
								log.error("Error get while sending TransferCourseMessage jmsMessageSender."+e+" RequestId:"+uniqueId, e);
							}
							
							/*for(TransferCourseTitle tct : tc.getTitleList()){
								tct.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
								transferCourseService.addTransferCourseTitle(tct);
							}*/
						}
						//NOW Update transferCourse object
						if(transferCourse2 != null && transferCourse2.getId() != null){
							tc.setCourseMappings(transferCourse2.getCourseMappings());
							tc.setCourseCategoryMappings(transferCourse2.getCourseCategoryMappings());
							if(transferCourse2.getTransferCourseInstitutionTranscriptKeyGradeAssocList() != null && !transferCourse2.getTransferCourseInstitutionTranscriptKeyGradeAssocList().isEmpty()){
								tc.setTransferCourseInstitutionTranscriptKeyGradeAssocList(transferCourse2.getTransferCourseInstitutionTranscriptKeyGradeAssocList());
							}
						}else if(transferCourse1 != null && transferCourse1.getId() != null){
							tc.setCourseMappings(transferCourse1.getCourseMappings());
							tc.setCourseCategoryMappings(transferCourse1.getCourseCategoryMappings());
							if(transferCourse1.getTransferCourseInstitutionTranscriptKeyGradeAssocList() != null && !transferCourse1.getTransferCourseInstitutionTranscriptKeyGradeAssocList().isEmpty()){
								tc.setTransferCourseInstitutionTranscriptKeyGradeAssocList(transferCourse1.getTransferCourseInstitutionTranscriptKeyGradeAssocList());
							}
						}
						
						if(tc.getEvaluationStatus().equalsIgnoreCase(TranscriptStatusEnum.EVALUATED.getValue())){
							addTrCoursesWithChildsToResolveConflict(tc, true);
						
							// the mirrors are removed when the status is changed to evaluated
							courseMgmtService.removeTransferCourseMirrors(tc.getId());
						}else if(tc.getEvaluationStatus().equalsIgnoreCase(TranscriptStatusEnum.CONFLICT.getValue())){
							courseMgmtService.addTransferCourse(tc);
						}
				}
			}
		
		
		}catch (Exception e) {
			//log.error("-Exception in Evaluation Job---------"+e,e);
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Exception in Evaluation Job---------."+e+" RequestId:"+uniqueId, e);
		}
		
	}
	private void addTrCoursesWithChildsToResolveConflict(TransferCourse transferCourse, boolean isEvalutated){
		if(isEvalutated){
			transferCourse.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
		}else{
			transferCourse.setEvaluationStatus(TranscriptStatusEnum.NOTEVALUATED.getValue());
		}
		//transferCourse.setModifiedDate(new Date());
		//transferCourse.setModifiedBy(UserUtil.getCurrentUser().getId());
		
		courseMgmtService.addTransferCourse(transferCourse);
		
		if(isEvalutated && transferCourse.getInstitution() != null && !transferCourse.getInstitution().getId().isEmpty()){
			List<StudentTranscriptCourse> studentTranscriptCourseList = transcriptService.getAllStudentTranscriptCourseByTransferCourseIdAndInstitutionId(transferCourse.getId() ,transferCourse.getInstitution().getId());
			if(studentTranscriptCourseList != null && !studentTranscriptCourseList.isEmpty()){
				for(StudentTranscriptCourse studentTranscriptCourse :studentTranscriptCourseList){
					studentTranscriptCourse.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
					studentTranscriptCourse.setTranscriptStatus(transferCourse.getTransferStatus());
				}
				transcriptMgmtDAO.saveTranscriptList( studentTranscriptCourseList );
			}
		}
		if(transferCourse.getCourseMappings() != null && transferCourse.getCourseMappings().size()>0){
			int cmCount = 0;
			for(CourseMapping cm:transferCourse.getCourseMappings()){
				//for Addition set Id null
				if(cm.getCourseMappingDetails().get(0).getEffectiveDate()!=null){
					
					cm.setId(null);
					/*if(cmCount == 0){
						cm.setEffective(true);
					}*/
					courseMgmtService.addCourseRelationShip(cm);
					cmCount = cmCount + 1;
				}
			}
			
		}
		
		if(transferCourse.getCourseCategoryMappings() != null && transferCourse.getCourseCategoryMappings().size()>0){
			int ccmCount = 0;
			for(CourseCategoryMapping ccm:transferCourse.getCourseCategoryMappings()){
				ccm.setId(null);
				if(ccmCount == 0){
					ccm.setEffective(true);
				}
				courseMgmtService.addCourseCategoryRelationShip(ccm);
				ccmCount = ccmCount + 1;
			}
			
		}
		for(TransferCourseTitle tct : transferCourse.getTitleList()){
			tct.setEvaluationStatus(TranscriptStatusEnum.EVALUATED.getValue());
			tct.setTransferCourseId(transferCourse.getId());
			transferCourseService.addTransferCourseTitle(tct);
		}
		List<TransferCourseInstitutionTranscriptKeyGradeAssoc>  transferCourseInstitutionTranscriptKeyGradeAssocNewList= new ArrayList<TransferCourseInstitutionTranscriptKeyGradeAssoc>();
		List<TransferCourseInstitutionTranscriptKeyGradeAssoc>  transferCourseInstitutionTranscriptKeyGradeAssocList= transferCourse.getTransferCourseInstitutionTranscriptKeyGradeAssocList();
		if(transferCourseInstitutionTranscriptKeyGradeAssocList != null && transferCourseInstitutionTranscriptKeyGradeAssocList.size()>0){
			
			for(TransferCourseInstitutionTranscriptKeyGradeAssoc  transferCourseInstitutionTranscriptKeyGradeAssoc : transferCourseInstitutionTranscriptKeyGradeAssocList){
				if(transferCourseInstitutionTranscriptKeyGradeAssoc.getInstitutionTranscriptKeyGradeId() != null && !transferCourseInstitutionTranscriptKeyGradeAssoc.getInstitutionTranscriptKeyGradeId().isEmpty()){
					transferCourseInstitutionTranscriptKeyGradeAssocNewList.add(transferCourseInstitutionTranscriptKeyGradeAssoc);
				}
			}
			List<TransferCourseInstitutionTranscriptKeyGradeAssoc>  transferCourseInstitutionTranscriptKeyGradeAssocReadList= courseMgmtService.loadAllTransferCourseInstitutionTranscriptKeyGradeAssocByTransferCourseId(transferCourse.getId());
			if(transferCourseInstitutionTranscriptKeyGradeAssocReadList != null && !transferCourseInstitutionTranscriptKeyGradeAssocReadList.isEmpty()){
				courseMgmtService.deleteAllGradeAssoc(transferCourseInstitutionTranscriptKeyGradeAssocReadList);
			}
			courseMgmtService.addTransferCourseInstitutionTranscriptKeyGradeAssocList(transferCourseInstitutionTranscriptKeyGradeAssocNewList);
		}
	}
}


class CustomComparator implements Comparator<CourseMapping> {
    @Override
    public int compare(CourseMapping o1, CourseMapping o2) {
        return o1.getCourseMappingDetails().get(0).getGcuCourse().getId().compareTo(o2.getCourseMappingDetails().get(0).getGcuCourse().getId());
    }
}

class CourseCategoryMappingComparator implements Comparator<CourseCategoryMapping> {
    @Override
    public int compare(CourseCategoryMapping o1, CourseCategoryMapping o2) {
        return o1.getGcuCourseCategory().getName().compareTo(o2.getGcuCourseCategory().getName());
    }
}

class AccreditingBodyInstituteComparator implements Comparator<AccreditingBodyInstitute> {
    @Override
    public int compare(AccreditingBodyInstitute o1, AccreditingBodyInstitute o2) {
        return o1.getAccreditingBody().getName().compareTo(o2.getAccreditingBody().getName());
    }
}

class InstitutionTermTypeComparator implements Comparator<InstitutionTermType> {
    @Override
    public int compare(InstitutionTermType o1, InstitutionTermType o2) {
        return o1.getTermType().getName().compareTo(o2.getTermType().getName());
    }
}

class InstitutionTranscriptKeyDetailsComparator implements Comparator<InstitutionTranscriptKeyDetails> {
    @Override
    public int compare(InstitutionTranscriptKeyDetails o1, InstitutionTranscriptKeyDetails o2) {
        return o1.getFrom().compareTo(o2.getFrom());
    }
}

class TransferCourseTitleComparator implements Comparator<TransferCourseTitle>{
	@Override
	public int compare(TransferCourseTitle o1, TransferCourseTitle o2){
		return o1.getTitle().compareTo(o2.getTitle());
	}
}