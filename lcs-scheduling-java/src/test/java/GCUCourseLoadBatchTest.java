import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import edu.gcu.batch.gcucourse.GCUCourseLoadBatch;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:applicationContext.xml",
		"classpath:applicationContext-test.xml" })
//@Transactional
public class GCUCourseLoadBatchTest {
     
	@Autowired
	private GCUCourseLoadBatch gcuCourseLoad;
	
	@Before
	public void setUp() throws Exception {
	}

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public final void test() {
 	 //	gcuCourseLoad.execute();
		System.out.println("DO NOTHING");
	}

}
