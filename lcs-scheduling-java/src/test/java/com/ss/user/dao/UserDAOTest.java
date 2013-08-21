/**
 * 
 */
package com.ss.user.dao;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.fail;

import java.util.List;
import java.util.UUID;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import com.ss.dao.AbstractDAOTest;
import com.ss.user.value.Role;
import com.ss.user.value.User;
import com.ss.user.value.UserRole;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:applicationContext.xml",
		"classpath:applicationContext-test.xml" })
@Transactional
public class UserDAOTest extends AbstractDAOTest {

	private static final Logger log = LoggerFactory
			.getLogger(UserDAOTest.class);

	@Autowired
	UserDAO userDAO;

	/**
	 * @throws java.lang.Exception
	 */
	@Before
	public void setUp() throws Exception {
		// truncateUser Table
		// truncateTable("User"); 
		/* Create a user with username: user1 */
		User user = new User();
		user.setFirstName("firstname");
		user.setLastName("DEO");
		user.setUserName("user1");
		user.setEmailAddress("email@gcu.edu");
		user.setOnline(true);
		userDAO.addUser(user);
	}

	/**
	 * @throws java.lang.Exception
	 */
	@After
	public void tearDown() throws Exception {
	}

	/**
	 * Test method for findUserByUserName operation
	 */
	@Test
	public final void testFindUserByUserName() {
		try {
			User user = userDAO
					.findUserByUserName(UUID.randomUUID().toString());
			assertNull(user);
			user = userDAO.findUserByUserName("user1");
			assertNotNull(user);
			assertEquals("Verifying that the Firstname is correct",
					"firstname", user.getFirstName());
			assertEquals("Verifying that the Lastname is correct", "DEO",
					user.getLastName());
			assertNotNull(user.getCreatedDate());
			assertNotNull(user.getModifiedDate());
		} catch (Exception e) {
			fail("Error occured while running the test case" + e.getMessage());
		}
	}

	/**
	 * Test method for findUserByUserName operation -- userName Case-sensitivity
	 */
	@Test
	public final void testFindUserByUserNameCaseSensitive() {
		try {
			User user = userDAO.findUserByUserName("user1");
			assertNotNull(user);
			user = userDAO.findUserByUserName("USER1");
			assertNotNull(user);
		} catch (Exception e) {
			fail("Error occured while running the test case" + e.getMessage());
		}
	}

	/**
	 * Test method for addUser operation
	 */
	@Test
	public final void testAddUser() {
		try {
			User user = new User();
			user.setFirstName("firstname");
			user.setLastName("ADDUSER");
			user.setUserName("addUser");
			user.setOnline(true);
 			userDAO.addUser(user);
			user = userDAO.findUserByUserName("addUser");
			assertNotNull("Asserting that the user is present in the database",
					user);
			assertNotNull("Asserting that the user returned has a USerID",
					user.getId());
		} catch (Exception e) {
			fail("Error occured while running the test case" + e.getMessage());
		}
	}

	/**
	 * Test method for updateUser operation Also verify the getUserbyId case
	 */
	@Test
	public final void testUpdateUser() {
		try {
			// retrieve the user added as apart of the setup
			User user = userDAO.findUserByUserName("user1");
			String userId = user.getId();
			assertNotNull("Asserting that the user is present in the database",
					user);
			user.setEmailAddress("email2@gcu.edu");
			user.setUserName("user2");
			// verify the save or update Usecase
			userDAO.addUser(user);
			user = userDAO.findUserByUserName("user2");
			assertNotNull("Asserting that the user is present in the database",
					user);
			assertEquals("Assert firstname is same", "firstname",
					user.getFirstName());
			assertEquals("Assert lastname is same", "DEO", user.getLastName());
			assertEquals("Assert Email is updated", "email2@gcu.edu",
					user.getEmailAddress());
			assertNotNull("Asserting that the user returned has a USerID",
					user.getId());
			assertEquals("Assert userId is same", userId, user.getId());
			user = userDAO.findById(userId);
			assertNotNull("Asserting that the user is present in the database",
					user);
			assertEquals("Assert firstname is same", "firstname",
					user.getFirstName());
			assertEquals("Assert lastname is same", "DEO", user.getLastName());
			assertEquals("Assert Email is updated", "email2@gcu.edu",
					user.getEmailAddress());
			assertNotNull("Asserting that the user returned has a USerID",
					user.getId());
			assertEquals("Assert userId is same", userId, user.getId());
		} catch (Exception e) {
			fail("Error occured while running the test case" + e.getMessage());
		}
	}

	/**
	 * Test method for findAllRoles.
	 */
	@Test
	public final void testFindAllRoles() {
		List<Role> rolesList = userDAO.findAllRoles();
		verifyStandardRolesArePresent(rolesList);
	}

	/**
	 * Asserts the list contains the standard roles
	 * 
	 * @param rolesList
	 */
	private void verifyStandardRolesArePresent(List<Role> rolesList) {
		int count = 0;
		for (Role role : rolesList) {
			if (role.getTitle().equalsIgnoreCase("DEO")) {
				count++;
			}
			if (role.getTitle().equalsIgnoreCase("IE")) {
				count++;
			}
			if (role.getTitle().equalsIgnoreCase("LOPES")) {
				count++;
			}
			if (role.getTitle().equalsIgnoreCase("Administrator")) {
				count++;
			}
			if (role.getTitle().equalsIgnoreCase("SLE")) {
				count++;
			}
		}
		if (count < 4) {
			fail("All the standard roles are not present in the database");
		}
	}

	/**
	 * Test case to test AddUserRole method and able to retrieve roles by
	 * username
	 * {@link com.ss.user.dao.UserDAOImpl#addUserRole(com.ss.user.value.UserRole)}
	 * .
	 */
	@Test
	public final void testAddUserRoleAndFindRolesByUsername() {
		try {
			User user = userDAO.findUserByUserName("user1");
			Role deoRole = userDAO.findRoleByRoleTitle("DEO");
			assertNotNull(deoRole);
			List<Role> roles = userDAO.findRolesForUserName(user.getUsername());
			assertEquals("Verifies there is No role for the username ", 0,
					roles.size());
			UserRole userRole = new UserRole();
			userRole.setRoleId(deoRole.getId());
			userRole.setUserId(user.getId());
			userRole.setStatus("A");
			userRole.setModifiedBy("1");
 			userDAO.addUserRole(userRole);
			roles = userDAO.findRolesForUserName(user.getUsername());
			assertNotNull(roles);
			assertEquals("Verifies there is only one role for the username ",
					1, roles.size());
		} catch (Exception e) {
			fail("Error occurred while running the test case");
		}

	}

	/**
	 * Test method for
	 * {@link com.ss.user.dao.UserDAOImpl#getUserRoleList(java.lang.String, java.lang.String)}
	 * .
	 */
	@Test
	public final void testGetUserRoleList() {
		// TODO: Method and test cases need to be implemented
	}

	/**
	 * Test method for
	 * {@link com.ss.user.dao.UserDAOImpl#getRoleNameForUser(java.lang.String)}.
	 */
	@Test
	public final void testGetRoleNameForUser() {
		try {
			User user = userDAO.findUserByUserName("user1");
			Role deoRole = userDAO.findRoleByRoleTitle("DEO");
			assertNotNull(deoRole);
			List<Role> roles = userDAO.findRolesForUserName(user.getUsername());
			assertEquals("Verifies there is No role for the username ", 0,
					roles.size());
			String roleName = userDAO.getRoleNameForUser(user.getId());
			assertNull(roleName);
			UserRole userRole = new UserRole();
			userRole.setRoleId(deoRole.getId());
			userRole.setUserId(user.getId());
			userRole.setStatus("A");
			userRole.setModifiedBy("1");
 			userDAO.addUserRole(userRole);
			roleName = userDAO.getRoleNameForUser(user.getId());
			assertNotNull(roleName);
			assertEquals("Verify the role name", "DEO", roleName);
		} catch (Exception e) {
			fail("Error occurred while running the test case");
		}
	}

	/**
	 * Test method for
	 * {@link com.ss.user.dao.UserDAOImpl#findRoleByRoleTitle(java.lang.String)}
	 * .
	 */
	@Test
	public final void testFindRoleByRoleTitle() {
		Role role = userDAO.findRoleByRoleTitle("DEO");
		assertEquals("Verify that the correct title is returned", "DEO",
				role.getTitle());
	}

	/**
	 * Test method for
	 * {@link com.ss.user.dao.UserDAOImpl#updateUserRole(java.lang.String, java.lang.String, java.lang.String)}
	 * .
	 */
	@Test
	public final void testUpdateUserRole() {
		User user = userDAO.findUserByUserName("user1");
		Role deoRole = userDAO.findRoleByRoleTitle("DEO");
		Role ieRole = userDAO.findRoleByRoleTitle("IE");
		assertNotNull(deoRole);
		List<Role> roles = userDAO.findRolesForUserName(user.getUsername());
		assertEquals("Verifies there is No role for the username ", 0,
				roles.size());
		UserRole userRole = new UserRole();
		userRole.setRoleId(deoRole.getId());
		userRole.setUserId(user.getId());
		userRole.setStatus("A");
		userRole.setModifiedBy("1");
 		userDAO.addUserRole(userRole);
		roles = userDAO.findRolesForUserName(user.getUsername());
		assertNotNull(roles);
		assertEquals("Verifies there is only one role for the username ", 1,
				roles.size());
		userDAO.updateUserRole(user.getId(), ieRole.getId(), deoRole.getId(),
				"1");
		UserRole dbUserRole = userDAO.getUserRoleByUserIdAndRoleId(
				user.getId(), deoRole.getId());
		assertNull("Verify that the DEO role does not exist for the user",
				dbUserRole);
		dbUserRole = userDAO.getUserRoleByUserIdAndRoleId(user.getId(),
				ieRole.getId());
		assertEquals("Verify that the new RoleId is IEROle", ieRole.getId(),
				dbUserRole.getRoleId());
		assertEquals("Verify the userId", user.getId(), dbUserRole.getUserId());
	}
}
