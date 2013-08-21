package com.ss.common.dao;

import java.io.Serializable;
import java.lang.reflect.ParameterizedType;

import org.hibernate.SessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

public class BaseAbstractDAO<T, ID extends Serializable> extends HibernateDaoSupport implements BaseDAO<T, ID> {
	//private static final Logger log=LoggerFactory.getLogger(BaseAbstractDAO.class);

	private Class<T> persistentClass;

	@SuppressWarnings("unchecked")
	public BaseAbstractDAO() {
		this.persistentClass = (Class<T>) ((ParameterizedType) getClass()
				.getGenericSuperclass()).getActualTypeArguments()[0];
	}
	
	@Autowired
	public void init(SessionFactory sessionFactory) {
		super.setSessionFactory(sessionFactory);
	}
 
	@Override
	public void persist(T entity) {
		getHibernateTemplate().saveOrUpdate(entity);
	}

    public Class<T> getPersistentClass() {
        return persistentClass;
    }

    @Override
	public T findById(ID id) {
		T entity;
		entity = (T) getHibernateTemplate().get(getPersistentClass(), id);
		return entity;
	}

	@Override
	public void delete(T entity) {
		// TODO Auto-generated method stub
		getHibernateTemplate().delete(entity);
		
	}
}