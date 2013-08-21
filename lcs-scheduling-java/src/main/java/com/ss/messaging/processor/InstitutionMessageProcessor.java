package com.ss.messaging.processor;

import javax.jms.Message;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import com.ss.institution.dao.InstitutionMgmtDao;
import com.ss.institution.value.Institution;

import edu.gcu.InsertInstitutionResponse;
import edu.gcu.campusvue.service.client.CampusVueServiceClient;

@Component
public class InstitutionMessageProcessor implements MessageProcessor{
	
	@Autowired
	 private CampusVueServiceClient campusVueServiceClient;
	@Autowired
	 private InstitutionMgmtDao institutionDAO;
	
	private static transient Logger log = LoggerFactory.getLogger(InstitutionMessageProcessor.class );


	@Override
	public void process(Message message) throws Exception {
    	String institutionId = message.getStringProperty("institutionId");
    	Institution institution = institutionDAO.getInstitutionById(institutionId);
    	institution.setAddresses(institutionDAO.getInstitutionAddresses(institutionId));
    	if(StringUtils.hasText(institution.getCampusVueInstitutionId())) {
    		log.info("Silently ignoring the Institution event as the Institution"+institutionId+" already has a campusVueInstitutionId:"+institution.getCampusVueInstitutionId());
    		return;
    	}
    	InsertInstitutionResponse response = campusVueServiceClient.createNewInstitution(institution);
        String campusVueInstitutionId = response.getCampusVueInstitutionId();
        institution.setCampusVueInstitutionId(campusVueInstitutionId);
        institutionDAO.addInstitution(institution);
		
	}

}
