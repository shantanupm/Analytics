package com.ss.user.value;

import java.io.Serializable;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.GenericGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.GrantedAuthority;

import com.ss.common.value.BaseEntity;

@Entity
@Table(name="ss_tbl_role_master")
public class Role extends BaseEntity implements GrantedAuthority,Serializable{
	private static transient Logger log = LoggerFactory.getLogger(Role.class);
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@Id
	@GeneratedValue(generator="customuuid")
	@GenericGenerator(name="customuuid",strategy="com.ss.common.util.CustomUUIDGenerator")
	@Column(name="role_id")
	private String id;
	@Column(name="title")
	private String title;
	@Column(name="description")
	private String description;
	@Column(name="is_system_defined")
	private boolean systemDefined;
	public boolean isSystemDefined() {
		return systemDefined;
	}
	public void setSystemDefined(boolean systemDefined) {
		this.systemDefined = systemDefined;
	}

	@Column(name="propagate_to_class")
	private boolean isPropogateToClass;
	@Column(name="role_status")
	private char roleStatus;
	
	@Column(name="authority_level")
	private int authorityLevel;
	@Transient
	private long userCount;
	
	@Column(name="parent_role_id")
	private String parentRoleId;
	public String getParentRoleId() {
		return parentRoleId;
	}
	public void setParentRoleId(String parentRoleId) {
		this.parentRoleId = parentRoleId;
	}

	/*@Transient
	private String userStatus;*/
	//@Transient
	/*@OneToMany(fetch=FetchType.LAZY,cascade=CascadeType.ALL)
	@JoinColumn(name="role_id")
	private List<RoleModuleOperation> roleModuleOperation;
	
	
		
	public List<RoleModuleOperation> getRoleModuleOperation() {
		return roleModuleOperation;
	}
	public void setRoleModuleOperation(List<RoleModuleOperation> roleModuleOperation) {
		this.roleModuleOperation = roleModuleOperation;
	}*/
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	/*public boolean isSystemDefined() {
		return isSystemDefined;
	}
	public void setSystemDefined(boolean isSystemDefined) {
		this.isSystemDefined = isSystemDefined;
	}*/
	
	
	
	public boolean isPropogateToClass() {
		return isPropogateToClass;
	}
	
	public void setPropogateToClass(boolean isPropogateToClass) {
		this.isPropogateToClass = isPropogateToClass;
	}
	
	public boolean getIsPropogateToClass() {
		return isPropogateToClass;
	}
	 
	public char getRoleStatus() {
		return roleStatus;
	}
	public void setRoleStatus(char roleStatus) {
		this.roleStatus = roleStatus;
	}
	public long getUserCount() {
		return userCount;
	}
	public void setUserCount(long userCount) {
		this.userCount = userCount;
	}
	//This is required for spring security since a voter is deciding the access.
	@Override
	public String getAuthority() {		
		return getTitle();
	}
	
	public int getAuthorityLevel() {
		return authorityLevel;
	}
	public void setAuthorityLevel(int authorityLevel) {
		this.authorityLevel = authorityLevel;
	}	
	/*public String getUserStatus() {
		return userStatus;
	}
	public void setUserStatus(String userStatus) {
		this.userStatus = userStatus;
	}*/
	
/*	@Transient
	private List<ModuleOperation> moduleOperation;



	public List<ModuleOperation> getModuleOperation() {
		return moduleOperation;
	}
	public void setModuleOperation(List<ModuleOperation> moduleOperation) {
		this.moduleOperation = moduleOperation;
	}*/
	
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="parent_role_id",referencedColumnName="role_id",insertable=false,updatable=false)
	private Role parent;
	public Role getParent() {
		return parent;
	}
	public void setParent(Role parent) {
		this.parent = parent;
	}
	@Override
	public String toString() {
		return String
				.format("Role [id=%s, title=%s, description=%s, systemDefined=%s, isPropogateToClass=%s, modifiedBy=%s, modifiedDate=%s, roleStatus=%s, authorityLevel=%s, userCount=%s, parentRoleId=%s, parent=%s]",
						id, title, description, systemDefined,
						isPropogateToClass, modifiedBy, modifiedDate,
						roleStatus, authorityLevel, userCount, parentRoleId,
						parent);
	}
}
