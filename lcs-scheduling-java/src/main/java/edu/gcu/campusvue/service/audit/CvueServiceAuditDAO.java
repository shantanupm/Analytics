package edu.gcu.campusvue.service.audit;

import java.util.Calendar;
import java.util.Date;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import edu.gcu.campusvue.service.CVueServiceActivityLog;

@Repository
public class CvueServiceAuditDAO {

	private JdbcTemplate jdbcTemplate;
	final Logger logger = LoggerFactory.getLogger(CvueServiceAuditDAO.class);

	@Autowired
	public void setDataSource(DataSource teaDataSource) {
		this.jdbcTemplate = new JdbcTemplate(teaDataSource);
	}

	public void insert(CVueServiceActivityLog activityLog) {
		int noOfRowsUpdated = 0;
		long totalTime = activityLog.getEndTimeInMillis() - activityLog.getStartTimeInMillis();
		try {
			noOfRowsUpdated = jdbcTemplate
					.update("INSERT INTO ss_tbl_cvue_activity_log (service_name,student_number, student_id, service_request, service_response, endpoint, auth_credentials_used, user_id, time_taken, is_partial_failure, status,call_date) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",
							new Object[] { activityLog.getServiceName(),
							        activityLog.getStudentNumber(),
									activityLog.getStudentId(),
									activityLog.getServiceRequest(),
									activityLog.getServiceResponse(),
									activityLog.getEndpoint(),
									activityLog.getTokenUsed(),
									activityLog.getUserInitiatingTheCall(),
									totalTime,
									(activityLog.isPartialFailure())? 1:0,
									(activityLog.isCallStatus())? 1:0,convertMillisToDate(activityLog.getStartTimeInMillis())});
		} catch (DataAccessException de) {
			logger.error("DataAccessException in LoggingDaoImpl.insert():", de);
		} catch (Exception exception) {
			logger.error("Unhandled Exception : ", exception);
		}finally {
			logger.info("No. of rows inserted into the cvue_activity_log:"+noOfRowsUpdated);
		}
	}

	/**
	 * Converts the System.currentTimeInMillis to a date
	 * @param currentTimeMillis
	 * @return
	 */
	private Date convertMillisToDate(long currentTimeMillis) {
         Calendar cal = Calendar.getInstance();
		 cal.setTimeInMillis(currentTimeMillis);
		 return cal.getTime();
	}
}
