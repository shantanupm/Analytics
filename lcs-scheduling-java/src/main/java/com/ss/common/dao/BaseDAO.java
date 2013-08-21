package com.ss.common.dao;

import java.io.Serializable;

public interface BaseDAO<T, ID extends Serializable> {

	public void persist(T entity);

	public T findById(ID id);

	public void delete(T entity);
	
}