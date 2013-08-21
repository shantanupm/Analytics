package com.ss.user.value;

import java.io.Serializable;

import javax.persistence.Embeddable;
import javax.persistence.Id;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Embeddable
public class UserRolePK implements Serializable {
	private static transient Logger log = LoggerFactory.getLogger(UserRolePK.class);
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String userId;
	
	private String roleId;
		
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
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((roleId == null) ? 0 : roleId.hashCode());
		result = prime * result + ((userId == null) ? 0 : userId.hashCode());
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		UserRolePK other = (UserRolePK) obj;
		if (roleId == null) {
			if (other.roleId != null)
				return false;
		} else if (!roleId.equals(other.roleId))
			return false;
		if (userId == null) {
			if (other.userId != null)
				return false;
		} else if (!userId.equals(other.userId))
			return false;
		return true;
	}
		
}
