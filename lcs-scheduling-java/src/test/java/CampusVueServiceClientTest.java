import static org.junit.Assert.*;

import java.math.BigDecimal;
import java.util.Date;

import org.datacontract.schemas._2004._07.cmc_integration_wcf_messages_common.InstitutionType;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.ss.course.value.TransferCourse;
import com.ss.institution.value.Institution;

import edu.gcu.campusvue.service.client.CampusVueServiceClient;


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:applicationContext.xml",
		"classpath:applicationContext-test.xml" })
public class CampusVueServiceClientTest {
	
	@Autowired
	private CampusVueServiceClient client;
	private Institution institution;

	/**
	 * @throws java.lang.Exception
	 */
	@Before
	public void setUp() throws Exception {
		 institution = new Institution();
		 institution.setInstitutionID("400777");
		 institution.setName("TEAAPP State University");
		// institution.setInstitutionType(InstitutionType.COLLEGE);
	}

	/**
	 * @throws java.lang.Exception
	 */
	@After
	public void tearDown() throws Exception {
	}

//	@Test
//	public final void test() {
//		TransferCourse trnsCourse = new TransferCourse();
//		trnsCourse.setTrCourseCode("TEATEST11111dd");
//		trnsCourse.setTranscriptCredits("10");
//		trnsCourse.setTrCourseTitle("This is automatically created");
//		trnsCourse.setMinimumGrade("A");
//		
// 		trnsCourse.setInstitution(institution);
// 		trnsCourse.setEffectiveDate(new Date());
//		client.createTransferCourse(trnsCourse, 111);
//	}
	
//	@Test
//	public final void testAbilityToCampusVueAuthToken() {
//		try {
//		String token = client.getCampusVueAuthenticationToken();
//		assertNotNull(token);
//		}catch(Exception e) {
//			fail();
//		}
//	}
	
	@Test
	public final void testCreateInstitution() {
		Institution inst = new Institution();
		inst.setInstitutionID("400777");
		inst.setName("Transcript1 Eval University");
		//client.createNewInstitution(inst);
	}

}
