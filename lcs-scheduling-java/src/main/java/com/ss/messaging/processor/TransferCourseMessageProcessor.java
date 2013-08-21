package com.ss.messaging.processor;

import javax.jms.Message;

import org.datacontract.schemas._2004._07.cmc_campuslink_wcf_messages.MessageStatusType;
import org.datacontract.schemas._2004._07.cmc_integration_wcf_messages.AddTransferCourseOutMsg;
import org.datacontract.schemas._2004._07.cmc_integration_wcf_messages.AddTransferCourseResponse;
import org.datacontract.schemas._2004._07.cmc_integration_wcf_messages.ArrayOfAddTransferCourseOutMsg;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import com.campusmgmt.soa.foundation.messagedefinition.AddTransferCoursesResponse;
import com.ss.course.value.TransferCourse;
import com.ss.evaluation.dao.TransferCourseMgmtDAO;

import edu.gcu.campusvue.service.client.CampusVueServiceClient;

@Component
public class TransferCourseMessageProcessor implements MessageProcessor {

	@Autowired
	private CampusVueServiceClient campusVueServiceClient;

	@Autowired
	private TransferCourseMgmtDAO transferCourseMgmtDAO;

	private static transient Logger log = LoggerFactory
			.getLogger(TransferCourseMessageProcessor.class);

	@Override
	public void process(Message message) throws Exception {
		String transferCourseId = message.getStringProperty("transferCourseId");
		TransferCourse transferCourse = transferCourseMgmtDAO
				.findById(transferCourseId);
		if (StringUtils.hasText(transferCourse.getCampusVueTransferCourseId())) {
			log.info("Silently ignoring the TransferCourse event as the TranferCourse with Id:"
					+ transferCourseId
					+ " already has a campusVueTransferCourseId:"
					+ transferCourse.getCampusVueTransferCourseId());
			return;
		}
		AddTransferCoursesResponse response = campusVueServiceClient
				.createTransferCourse(transferCourse, 1234);
		AddTransferCourseResponse transferCourseResponse = response
				.getAddTransferCoursesResult();
		ArrayOfAddTransferCourseOutMsg arrayOfAddTransferCourseOutMsg = transferCourseResponse
				.getAddTransferCourseOutMsgs();
		AddTransferCourseOutMsg addTransferCourseResponse = arrayOfAddTransferCourseOutMsg
				.getAddTransferCourseOutMsgs().get(0);
		MessageStatusType messageStatus = addTransferCourseResponse
				.getMessageStatus();
		if (messageStatus.equals(MessageStatusType.OK)) {
			transferCourse.setCampusVueTransferCourseId(""
					+ addTransferCourseResponse.getTransferCourseId());
			transferCourseMgmtDAO.addTransferCourse(transferCourse);
		}else {
			throw new RuntimeException();
		}

	}

}
