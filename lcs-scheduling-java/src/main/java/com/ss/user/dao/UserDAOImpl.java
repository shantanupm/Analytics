package com.ss.user.dao;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.hibernate.criterion.Criterion;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.ss.common.logging.RequestContext;
import com.ss.common.util.UserUtil;
import com.ss.evaluation.value.College;
import com.ss.user.value.Role;
import com.ss.user.value.User;
import com.ss.user.value.UserRole;
@Repository("userDAO")
public class UserDAOImpl extends com.ss.common.dao.BaseAbstractDAO<User, Serializable> implements UserDAO {
	private static final Logger log = LoggerFactory.getLogger(UserDAOImpl.class);
	

	@Override
	public List<Role> findRolesForUserName(String userName){
		//String queryString="select distinct r.id,r.title,r.roleStatus,u.status from Role r, UserRole u "+
		//"where r.id in(select roleId from UserRole where userId in"+
		//"( select id from User where userName =?)) and r.id = u.roleId";
		String sql = " from Role role left join fetch role.parent parent where role.id in(select roleId from UserRole where userId in( select id from User where userName =?) and status='A')";
		return (List<Role>) getHibernateTemplate().find(sql,userName);		
		//return (List<Role>) getHibernateTemplate().find(queryString,userName);	 
	}

	@Override
	public User findUserByUserName(String userName) {
		List<User> user = getHibernateTemplate().find("from User u where u.userName =?", userName);
		//this.getSession().close();	//DETACH THE OBJECT
		if(user!=null && user.size()>0){
			return user.get(0);
		}
		
		return null;
	}
	
	@Override
	public List<User> findUsersByRoleId(String roleId){
		List<User> list = getHibernateTemplate().find("select u from User u, UserRole ur where u.id = ur.userId and ur.roleId = ?", roleId);
		if(list != null && list.size() > 0){
			return list;
		}
		else{
			return null;
		}
		
	}

	//TODO : Need to implement
	@Override
	public List<UserRole> getUserRoleList(String searchBy, String searchText){
		List<UserRole> userRoleList = null;
		try{
			/*DetachedCriteria criteria = DetachedCriteria.forClass(UserRole.class);
			if(null!=searchBy){
				if(  !searchBy.isEmpty() ){
					if(null!=searchText){
						if(  !searchText.isEmpty() ){
							if(searchBy.equalsIgnoreCase("1")){
								criteria.add(Restrictions.like("user.userName", "%"+searchText+"%"));
							}
							else if(searchBy.equalsIgnoreCase("2")){
								criteria.add(Restrictions.like("user.firstName", "%"+searchText+"%"));
								criteria.add(Restrictions.like("user.lastName", "%"+searchText+"%"));
							}
						}
					}
				}
			}
			
			userRoleList =  getHibernateTemplate().findByCriteria(criteria); */
			userRoleList = getHibernateTemplate().find("from UserRole");
		}
		catch (Exception e) {
			//Retrieving the unique RequestId
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No User Role found."+e+" RequestId:"+uniqueId, e);
		}
		return userRoleList;
	}
	
	@Override
	public List<User> getUserList(String searchBy, String searchText){
		List<User> userList = null;
		try{
			DetachedCriteria criteria = DetachedCriteria.forClass(User.class);
			if(null!=searchBy){
				if(  !searchBy.isEmpty() ){
					if(null!=searchText){
						if(  !searchText.isEmpty() ){
							if(searchBy.equalsIgnoreCase("1")){
								criteria.add(Restrictions.like("userName", "%"+searchText+"%"));
							}
							else if(searchBy.equalsIgnoreCase("2")){
								Criterion  c1 = Restrictions.like("firstName", "%"+searchText+"%");
								Criterion  c2 = Restrictions.like("lastName", "%"+searchText+"%");
								criteria.add(Restrictions.or(c1,c2));
							}
						}
					}
				}
			}
			
			userList =  getHibernateTemplate().findByCriteria(criteria); 
		}
		catch (Exception e){
			//log.error("No User Found "+e, e);
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No User Found."+e+" RequestId:"+uniqueId, e);
		}
		return userList;
	}
	
	@Override
	public String getRoleNameForUser(String userId){
		List<String> roleNameList = getHibernateTemplate().find("select r.title from Role r, UserRole ur where ur.roleId=r.id and ur.userId = ?", userId);
		if(roleNameList != null && roleNameList.size() != 0){
			return roleNameList.get(0);
		}
		else return null;
	}
	@Override
	public Role findRoleByRoleTitle(String roleTitle){
		try{
			return (Role)getHibernateTemplate().find("from Role where title=?",roleTitle).get(0);
		}catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Exception Occured."+e+" RequestId:"+uniqueId, e);
			return null;
		}
	}
	
	@Override
	public List<Role> findAllRoles(){
		try {
			return getHibernateTemplate().find("from Role order by title");
		} catch (Exception e) {
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("Exception Occured."+e+" RequestId:"+uniqueId, e);
			return null;
		}
	}
	
	@Override
	public void addUser(User user){
		getHibernateTemplate().saveOrUpdate(user);
	}
	
	@Override
	public void addUserRole(UserRole userRole){
		getHibernateTemplate().saveOrUpdate(userRole);
		System.out.println(userRole);
	}

	@Override
	public void updateUserRole(String userId, String roleId, String previousRoleId,String modifyingUserId){
		Date currentDate = new Date();
		getHibernateTemplate().bulkUpdate("update UserRole set modifiedBy=?, modifiedDate=?, roleId =? where userId=? and roleId=?", modifyingUserId, currentDate, roleId, userId, previousRoleId);
	}
	
	@Override
	public Role findRoleById(String roleId){
		List<Role> list = getHibernateTemplate().find("from Role where id = ?", roleId);
		if(list!=null && list.size()!=0){
			return list.get(0);
		}
		else return null;
	}
	
	@Override
	public UserRole getUserRoleByUserIdAndRoleId(String userId, String roleId){
		List<UserRole> list = getHibernateTemplate().find("from UserRole where userId = ? and roleId=?",userId, roleId);
		if(list != null && list.size()!=0){
			return list.get(0);
		}
		else return null;
	}
	@Override
	public List<User> findUserByRoleId(String roleId) {
		List<User> userList = new ArrayList<User>();
		try{											  
			userList = getHibernateTemplate().find("FROM User WHERE id IN(SELECT userId FROM UserRole WHERE roleId =?) ORDER BY firstName", new Object[]{roleId});
		}catch(Exception e){
			String uniqueId = RequestContext.getRequestIdFromContext();
			log.error("No User found."+e+" RequestId:"+uniqueId, e);
		}
	    return userList;	
	}
}