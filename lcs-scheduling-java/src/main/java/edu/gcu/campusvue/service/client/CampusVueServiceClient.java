package edu.gcu.campusvue.service.client;

import java.math.BigDecimal;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.XMLGregorianCalendar;

import org.datacontract.schemas._2004._07.cmc_integration_wcf_messages.AddTransferCourseInMsg;
import org.datacontract.schemas._2004._07.cmc_integration_wcf_messages.AddTransferCourseRequest;
import org.datacontract.schemas._2004._07.cmc_integration_wcf_messages.AddTransferCreditsInMsg;
import org.datacontract.schemas._2004._07.cmc_integration_wcf_messages.AddTransferCreditsRequest;
import org.datacontract.schemas._2004._07.cmc_integration_wcf_messages.ArrayOfAddTransferCourseInMsg;
import org.datacontract.schemas._2004._07.cmc_integration_wcf_messages.ArrayOfAddTransferCreditsInMsg;
import org.datacontract.schemas._2004._07.cmc_integration_wcf_messages_common.ConvertCredits;
import org.datacontract.schemas._2004._07.cmc_integration_wcf_messages_common.InstitutionType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.ws.client.core.WebServiceTemplate;
import org.springframework.ws.soap.client.core.SoapActionCallback;

import com.campusmgmt.soa.foundation.GetAuthorizationToken;
import com.campusmgmt.soa.foundation.GetAuthorizationTokenResponse;
import com.campusmgmt.soa.foundation.messagedefinition.AddTransferCourses;
import com.campusmgmt.soa.foundation.messagedefinition.AddTransferCoursesResponse;
import com.campusmgmt.soa.foundation.messagedefinition.AddTransferCredits;
import com.campusmgmt.soa.foundation.messagedefinition.AddTransferCreditsResponse;
import com.campusmgmt.soa.foundation.messagedefinition.TokenRequest;
import com.campusmgmt.soa.foundation.messagedefinition.TrxStatus;
import com.ss.common.logging.CvueServiceContext;
import com.ss.course.value.TransferCourse;
import com.ss.institution.value.Institution;
import com.ss.institution.value.InstitutionAddress;

import edu.gcu.AddressType;
import edu.gcu.InsertInstitutionRequest;
import edu.gcu.InsertInstitutionResponse;
import edu.gcu.campusvue.service.CVueServiceActivityLog;
import edu.gcu.campusvue.service.CampusVueServiceException;
import edu.gcu.campusvue.service.ErrorType;
import edu.gcu.campusvue.service.dto.TransferCreditsServiceDTO;

@Component
public class CampusVueServiceClient {
	
	//TODO: Need to use aspects for logging....doing it clumsy way for now
	//TODO: extract the hard coded URLs

	private String postTransferCourseEndpoint = "http://qcvumtvp2001.gcu.edu:8090/Cmc.Integration.WebServices.Wcf/PostTransferCourseService.svc";
	private String postTransferCreditEndpoint = "http://qcvumtvp2002.gcu.edu:8090/Cmc.Integration.WebServices.Wcf/PostTransferCreditsService.svc";
	private String authorizatonServiceEndpoint ="http://qcvumtvp2001.gcu.edu:8090/cmc.campuslink.webservices.security/Authentication.asmx";
	private String insertInstitutionEndpoint = "http://enterprisedataservices.qa.gcu.edu/TranscriptEvaluation/InstitutionService.svc";
    private String authToken = null;
	
	@Autowired
	private WebServiceTemplate webServiceTemplate;

	/**
	 * Creates a new TransferCourse in CampusVue Institution Information will be
	 * used from the TransferCourse
	 * 
	 * @param transferCourse
	 * @return 
	 */
	public AddTransferCoursesResponse createTransferCourse(TransferCourse transferCourse,int correlationId) {
		logServiceMetaData("AddTransferCourse",postTransferCourseEndpoint);
		AddTransferCourseInMsg inmsg = new AddTransferCourseInMsg();
		inmsg.setCorrelationId(correlationId);
		inmsg.setClockHours(new BigDecimal(transferCourse.getClockHours()));
		//all the transferCourses will be created with ConvertCredits flag set to DONOTCONVERT
		inmsg.setConvertCredits(ConvertCredits.DO_NOT_CONVERT);
		inmsg.setCourseCode(transferCourse.getTrCourseCode());
		if(transferCourse.getTranscriptCredits()!=null) {
			inmsg.setCourseCredits(new BigDecimal(transferCourse.getTranscriptCredits()));
		}
		inmsg.setCourseDescrip(getCourseTitleToUser(transferCourse));
		//inmsg.setMinimunGradeRequired(transferCourse.getMinimumGrade());  Always setting the minimum grade to C
		inmsg.setMinimunGradeRequired("C");
		inmsg.setInstitutionCode(transferCourse.getInstitution().getSchoolcode());
		inmsg.setStartDate(getXMLDateFromUtilDate(transferCourse.getEffectiveDate()));
		//currently we only support College
		inmsg.setIntitutionType(InstitutionType.COLLEGE);
		inmsg.setInstitutionCode(transferCourse.getInstitution().getInstitutionID());
 		ArrayOfAddTransferCourseInMsg array = new ArrayOfAddTransferCourseInMsg();
		array.getAddTransferCourseInMsgs().add(inmsg);
		AddTransferCourseRequest addtransferCourseRequest = new AddTransferCourseRequest();
		addtransferCourseRequest.setTokenId(getCampusVueAuthenticationToken());
		addtransferCourseRequest.setAddTransferCourseInMsgs(array);
		AddTransferCourses addTransferCourses = new AddTransferCourses();
		addTransferCourses.setRequest(addtransferCourseRequest);
		AddTransferCoursesResponse addTransferCoursesResponse = (AddTransferCoursesResponse) webServiceTemplate
				.marshalSendAndReceive(
						postTransferCourseEndpoint,
						addTransferCourses,
						new SoapActionCallback(
								"http://www.campusmgmt.com/Soa/Foundation/MessageDefinition.xsd/IPostTransferCourseService/AddTransferCourses") {
						});
		return addTransferCoursesResponse;
	}

	/**
	 * Logs the serviceName,ServiceEndpoint to the courseActivityLog
	 * @param string
	 * @param postTransferCourseEndpoint2
	 */
	private void logServiceMetaData(String serviceName,
			String endpoint) {
		CVueServiceActivityLog activityLog = CvueServiceContext
				.getCampusVueServiceActivityLog();
		activityLog.setEndpoint(endpoint);
		activityLog.setServiceName(serviceName);
	}

	/**
	 * @param java.util.date
	 * @return
	 * @throws DatatypeConfigurationException
	 */
	private XMLGregorianCalendar getXMLDateFromUtilDate(
			Date date) {
		GregorianCalendar c = new GregorianCalendar();
		c.setTime(date);
		XMLGregorianCalendar transferCourseStartDate = null;
		try {
			transferCourseStartDate = DatatypeFactory.newInstance().newXMLGregorianCalendar(c);
		} catch (DatatypeConfigurationException e) {
			throw  new CampusVueServiceException(e.getMessage(),null,"", ErrorType.CLIENT);
		}
		return transferCourseStartDate;
	}

	/**
	 * Makes a call to CampusVue Authorization service to get a token. The token
	 * is set to never expire.Caches the token for the subsequent calls
	 * 
	 * @return
	 */
	public String getCampusVueAuthenticationToken() {
        if(authToken!=null) {
        	return authToken;
        }
        logServiceMetaData("AuthenticationService",authorizatonServiceEndpoint);
		TokenRequest tokenRequest = new TokenRequest();
		tokenRequest.setUserName("svc_scheduleapp@canyon.com");
		tokenRequest.setPassword("C@nyon3300");
		tokenRequest.setTokenNeverExpires(true);
		GetAuthorizationToken getAuthToken = new GetAuthorizationToken();
		getAuthToken.setTokenRequest(tokenRequest);
		try {
			GetAuthorizationTokenResponse getAuthTokenResponse = (GetAuthorizationTokenResponse) webServiceTemplate
					.marshalSendAndReceive(
							authorizatonServiceEndpoint,
							getAuthToken,
							new SoapActionCallback(
									"http://www.campusmgmt.com/Soa/Foundation/GetAuthorizationToken") {
							});
			TrxStatus transactionStatus = getAuthTokenResponse
					.getTokenResponse().getStatus();
			if (TrxStatus.ERROR_SECURITY.equals(transactionStatus)) {
				throw new CampusVueServiceException(getAuthTokenResponse
						.getTokenResponse().getTrxResult(), null,
						TrxStatus.ERROR_SECURITY.value(), ErrorType.CLIENT);
			}
			authToken = getAuthTokenResponse.getTokenResponse().getTokenId();
		} catch (Exception exception) {
			String message = "Error occurred while getting the authorization token.";
			throw new CampusVueServiceException(message+exception.getMessage(), null,
					"", ErrorType.SERVER);
		}
		return authToken;
	}

	/**
	 * Returns a courseTitle to use
	 * If the course contains multiple titles then we will pass "MULTIPLE TITLES"
	 * @param transferCourse
	 * @return
	 */
	private String getCourseTitleToUser(TransferCourse transferCourse) {
		String courseTitle = "MULTIPLE TITLES";
        if(transferCourse.getTitleList().size()>1) {
        	return courseTitle;
        }
        return transferCourse.getTrCourseTitle();
	}

	/**
	 * Creates a new Institution in campusVue. Throws a runtime exception
	 * CampusVueServiceException, when the call fails
	 * 
	 * @param inst
	 * @return
	 */
	public InsertInstitutionResponse createNewInstitution(Institution inst) {
        logServiceMetaData("InsertInstitution",insertInstitutionEndpoint);

		InsertInstitutionRequest insertInstRequest = new InsertInstitutionRequest();
		edu.gcu.InstitutionType instType = new edu.gcu.InstitutionType();
		instType.setInstitutionCode(inst.getInstitutionID());
		instType.setInstitutionName(inst.getName());
		insertInstRequest.setInstitution(instType);
		List<InstitutionAddress> addressList = inst.getAddresses();
		populateAddressData(instType, addressList);
 			
 		InsertInstitutionResponse insertInstitutionResponse = null;
		try {
			insertInstitutionResponse = (InsertInstitutionResponse) webServiceTemplate
					.marshalSendAndReceive(
							insertInstitutionEndpoint,
							insertInstRequest,
							new SoapActionCallback(
									"http://gcu.edu/ITranscriptEvaluationService/InsertInstitution") {
							});
		} catch (Exception exception) {
			exception.printStackTrace();
			String message = "Error occurred while inserting a new Institution.";
			throw new CampusVueServiceException(message
					+ exception.getMessage(), null, "", ErrorType.SERVER);
		}
		return insertInstitutionResponse;
	}

	/**
	 * Takes a list of Addresses and populates the InstitutionType Object with address that needs to be send to CampusVue
	 * Currently we are sending the same address as Official and Transcript
	 * @param instType
	 * @param addressList
	 */
	private void populateAddressData(edu.gcu.InstitutionType instType,
			List<InstitutionAddress> addressList) {
		/* If there are multiple addresses we will be sending only one address*/
		if(addressList.size()>0) {
			InstitutionAddress address = addressList.get(0);
			instType.getInstitutionAddresses().add(returnAddressTypeObject(address,"Official"));
			instType.getInstitutionAddresses().add(returnAddressTypeObject(address,"Transcript"));
		}
	}

	/**
	 * Takes a InstitutionAddress object ands returns a AddressType object with the passed typeOfAddress
	 * @param address
	 * @return
	 */
	private AddressType returnAddressTypeObject(InstitutionAddress address,String typeOfAddress) {
		AddressType instAddress = new AddressType();
		instAddress.setTypeOfAddress(typeOfAddress);
		instAddress.setLine1(address.getAddress1());
		instAddress.setLine2(address.getAddress2());
		instAddress.setCity(address.getCity());
		//instAddress.setState(address.getState());
		instAddress.setZipcode(address.getZipcode());
		instAddress.setCountry(address.getCountry().getCode());
		instAddress.setPhone(address.getPhone1());
		instAddress.setTollFreePhone(address.getTollFree());
		instAddress.setFax(address.getFax());
		instAddress.setWebsite(address.getWebsite());
		return instAddress;
	}
	
	/**
	 * Post Transfer credits for a student into CampusVue
	 * @return
	 */
	public AddTransferCreditsResponse postTransferCredits(List<TransferCreditsServiceDTO> transferCreditsList) {
        logServiceMetaData("AddTransferCredit",postTransferCreditEndpoint);
 
		AddTransferCredits addTransferCredits = new AddTransferCredits();
		ArrayOfAddTransferCreditsInMsg arrayOfAddTransferCreditsInMsg = new ArrayOfAddTransferCreditsInMsg();
		
		List<AddTransferCreditsInMsg> addTransferCreditsInMsgList = arrayOfAddTransferCreditsInMsg.getAddTransferCreditsInMsgs();
		AddTransferCreditsRequest addTransferCreditsRequest = new AddTransferCreditsRequest();
		addTransferCreditsRequest.setTokenId(getCampusVueAuthenticationToken());
		addTransferCreditsRequest.setAddTransferCreditsInMsgs(arrayOfAddTransferCreditsInMsg);
		addTransferCredits.setRequest(addTransferCreditsRequest);
  		for(TransferCreditsServiceDTO transferCreditsDto :transferCreditsList) {
			AddTransferCreditsInMsg addTransferCreditsInMsg = new AddTransferCreditsInMsg();
			addTransferCreditsInMsg.setCorrelationId(transferCreditsDto.getCorrelationId());
			addTransferCreditsInMsg.setAutoUnregisterCourse(true);
			addTransferCreditsInMsg.setComments("Posting Transfer Credits from Transcript Evaluation App");
			addTransferCreditsInMsg.setCreditsToTransfer(new BigDecimal(transferCreditsDto.getCreditsToTransfer()));
			addTransferCreditsInMsg.setDateCompleted(getXMLDateFromUtilDate(transferCreditsDto.getDateCompleted()));
			//addTransferCreditsInMsg.setDateStarted(getXMLDateFromUtilDate(transferCreditsDto.getDateStarted()));
			addTransferCreditsInMsg.setFromTransferCourseCode(transferCreditsDto.getFromTransferCourseCode());
			addTransferCreditsInMsg.setGrade("TR");
			addTransferCreditsInMsg.setGradeReceived(transferCreditsDto.getGradeReceived());
			addTransferCreditsInMsg.setInstitutionCode(transferCreditsDto.getInstitutionCode());
			addTransferCreditsInMsg.setInstitutionType(InstitutionType.COLLEGE);
			addTransferCreditsInMsg.setStatus(transferCreditsDto.getStatus());
			addTransferCreditsInMsg.setStudentNumber(transferCreditsDto.getStudentNumber());
 			addTransferCreditsInMsg.setTermCode("*TRANSFER");
			addTransferCreditsInMsg.setToCampusCourseCode(transferCreditsDto.getToCampusCourseCode());
			addTransferCreditsInMsgList.add(addTransferCreditsInMsg);
		}
		
		AddTransferCreditsResponse addTransferCreditsResponse = (AddTransferCreditsResponse) webServiceTemplate
				.marshalSendAndReceive(
						postTransferCreditEndpoint,
						addTransferCredits,
						new SoapActionCallback(
								"http://www.campusmgmt.com/Soa/Foundation/MessageDefinition.xsd/IPostTransferCreditsService/AddTransferCredits") {
						});
		return addTransferCreditsResponse;
	}

}