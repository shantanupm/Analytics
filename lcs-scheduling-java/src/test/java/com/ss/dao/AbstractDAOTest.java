package com.ss.dao;

import java.sql.SQLException;

import javax.persistence.Query;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;

import com.ss.user.value.User;

 
public class AbstractDAOTest {
	
	@Autowired
	private SessionFactory sessionFactory;
	
	 
	 
	public AbstractDAOTest(){
		SecurityContext securityContext = SecurityContextHolder.getContext();
	//	  Authentication authentication = 
		 
	}
	 
	 public void truncateTable(final String tableToTruncate){	
		 Session session = sessionFactory.getCurrentSession(); 
		 
		 
		 
		 String hql = String.format("delete from %s",tableToTruncate);
         Integer count = session.createQuery(hql).executeUpdate();
//			Account a = (Account) query.uniqueResult();
		 
			//Assert.assertEquals(a.getCashBalance(), 500.0, 0.01);
// 		 hibernateTemplate.execute(new HibernateCallback<Integer>(){
//			@Override
//			public Integer doInHibernate(Session session)
//					throws HibernateException, SQLException {
//				 
//				 Integer count = session.createQuery(hql).executeUpdate();
// 				return count;
//			}
//			 
//		 });
	 }

}
