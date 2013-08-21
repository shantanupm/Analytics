package com.ss.user.value;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.ManyToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ss.common.value.BaseEntity;

@Entity
@Table(name = "ss_tbl_user_role_assoc")
@IdClass(UserRolePK.class)
public class UserRole extends BaseEntity implements Serializable {
	private static transient Logger log = LoggerFactory.getLogger(UserRole.class);
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "user_id")
	private String userId;
	@Id
	@Column(name = "role_id")
	private String roleId;
	@Column(name = "status")
	private String status;
	
	@Column(name="hasSpecialPermission")
	private boolean specialPermission;
/*
	@ManyToOne
	@PrimaryKeyJoinColumn(name = "userid", referencedColumnName = "user_id")
	private User user;
	@ManyToOne
	@PrimaryKeyJoinColumn(name = "roleid", referencedColumnName = "role_id")
	private Role role;
*/
	public boolean isSpecialPermission() {
		return specialPermission;
	}

	public void setSpecialPermission(boolean specialPermission) {
		this.specialPermission = specialPermission;
	}

	public UserRole(String userId2, String roleId2) {
		this.userId = userId2;
		this.roleId = roleId2;
	}

	public UserRole() {

	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getRoleId() {
		return roleId;
	}

	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

}
