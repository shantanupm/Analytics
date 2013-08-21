package com.ss.user.value;

import java.io.Serializable;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.GenericGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.memory.UserMap;

import com.ss.common.value.BaseEntity;

/*import com.lcs.classmgmt.value.ClassInfo;
import com.lcs.course.value.Course;*/

@Entity
@Table(name="ss_tbl_user")
public class User extends BaseEntity implements UserDetails , Serializable {
	private static transient Logger log = LoggerFactory.getLogger(User.class);
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@Id
	@GeneratedValue(generator="customuuid")
	@GenericGenerator(name="customuuid",strategy="com.ss.common.util.CustomUUIDGenerator")
	@Column(name="user_id")
	private String id;
	@Column(name="username")
	private String userName;
	@Column(name="firstname")
	private String firstName;
	@Column(name="lastname")
	private String lastName;
	@Column(name="password")
	private String password;
	@Column(name="account_non_expired")
	private boolean isAccountNonExpired;
	@Column(name="account_non_locked")
	private boolean isAccountNonLocked;
	@Column(name="credentials_non_expired")
	private boolean isCredentialsNonExpired;
	@Column(name="enabled")
	private boolean isEnabled;
	@Column(name="last_login")
	private Date lastLogin;
	@Column(name="email_address")
	private String emailAddress;
	@Column(name="display_name")
	private String displayName;
 	@Column(name="last_login_role")
	private String lastLoginRole;
	@Column(name="is_online")
	private boolean isOnline;
	@Column(name="ref_id")
	private String refId;
 	
	@Transient
	Collection<GrantedAuthority> authorities;	
	@Transient
	String currentRole;
	
	@Transient
	private HashMap<String, Object> userSessionMap = new HashMap<String, Object>();
	
	@Transient
	private String assignedToCollegeCode;
	
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public boolean isAccountNonExpired() {
		return isAccountNonExpired;
	}
	public void setAccountNonExpired(boolean isAccountNonExpired) {
		this.isAccountNonExpired = isAccountNonExpired;
	}
	public boolean isAccountNonLocked() {
		return isAccountNonLocked;
	}
	public void setAccountNonLocked(boolean isAccountNonLocked) {
		this.isAccountNonLocked = isAccountNonLocked;
	}
	public boolean isCredentialsNonExpired() {
		return isCredentialsNonExpired;
	}
	public void setCredentialsNonExpired(boolean isCredentialsNonExpired) {
		this.isCredentialsNonExpired = isCredentialsNonExpired;
	}
	public boolean isEnabled() {
		return isEnabled;
	}
	public void setEnabled(boolean isEnabled) {
		this.isEnabled = isEnabled;
	}
	public Date getLastLogin() {
		return lastLogin;
	}
	public void setLastLogin(Date lastLogin) {
		this.lastLogin = lastLogin;
	}
	public String getEmailAddress() {
		return emailAddress;
	}
	public void setEmailAddress(String emailAddress) {
		this.emailAddress = emailAddress;
	}
	public String getDisplayName() {
		return displayName;
	}
	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}
 	public String getLastLoginRole() {
		return lastLoginRole;
	}

	public void setLastLoginRole(String lastLoginRole) {
		this.lastLoginRole = lastLoginRole;
	}

	@Override
	public Collection<GrantedAuthority> getAuthorities() {	
		return this.authorities;
	}

	public void setAuthorities(Collection<GrantedAuthority> authorities) {
		this.authorities = authorities;
	}

	public String getCurrentRole() {
		return currentRole;
	}

	public void setCurrentRole(String currentRole) {
		this.currentRole = currentRole;
	}

	public boolean isOnline() {
		return isOnline;
	}

	public void setOnline(boolean isOnline) {
		this.isOnline = isOnline;
	}

	@Override
	public String getUsername() {		
		return this.userName;
	}

	public HashMap<String, Object> getUserSessionMap() {
		return userSessionMap;
	}

	public void setUserSessionMap(HashMap<String, Object> userSessionMap) {
		this.userSessionMap = userSessionMap;
	}
	
	public String getFullName(){
		return this.firstName + " " + this.lastName;
	}

	public String getRefId() {
		return refId;
	}

	public void setRefId(String refId) {
		this.refId = refId;
	}

	@Override
	public String toString() {
		return String
				.format("User [id=%s, userName=%s, firstName=%s, lastName=%s, password=%s, isAccountNonExpired=%s, isAccountNonLocked=%s, isCredentialsNonExpired=%s, isEnabled=%s, lastLogin=%s, emailAddress=%s, displayName=%s, modifiedBy=%s, modifiedDate=%s, lastLoginRole=%s, isOnline=%s, refId=%s, createdDate=%s, authorities=%s, currentRole=%s, userSessionMap=%s]",
						id, userName, firstName, lastName, password,
						isAccountNonExpired, isAccountNonLocked,
						isCredentialsNonExpired, isEnabled, lastLogin,
						emailAddress, displayName, modifiedBy, modifiedDate,
						lastLoginRole, isOnline, refId, createdDate,
						authorities, currentRole, userSessionMap);
	}

	public String getAssignedToCollegeCode() {
		return assignedToCollegeCode;
	}

	public void setAssignedToCollegeCode(String assignedToCollegeCode) {
		this.assignedToCollegeCode = assignedToCollegeCode;
	}

	
}
