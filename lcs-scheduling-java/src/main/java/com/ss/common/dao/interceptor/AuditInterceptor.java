package com.ss.common.dao.interceptor;


import java.io.Serializable;
import java.util.Date;
 
import org.hibernate.EmptyInterceptor;
import org.hibernate.type.Type;

import com.ss.common.util.UserUtil;
import com.ss.common.value.BaseEntity;
import com.ss.user.value.User;

public class AuditInterceptor extends EmptyInterceptor {
 
    public void onDelete(Object entity,
                         Serializable id,
                         Object[] state,
                         String[] propertyNames,
                         Type[] types) {
        // do nothing
    }

    public boolean onFlushDirty(Object entity,
                                Serializable id,
                                Object[] currentState,
                                Object[] previousState,
                                String[] propertyNames,
                                Type[] types) {
    	boolean stateChange=false;
        User userModifiedBy = getUserModifiedBy();
        if ( entity instanceof BaseEntity ) {
             for ( int i=0; i < propertyNames.length; i++ ) {
                if ( "modifiedDate".equals( propertyNames[i] ) ) {
                    currentState[i] = new Date();
                    stateChange=true;
                    return true;
                }
                if ( "modifiedBy".equals( propertyNames[i] ) ) {
                    currentState[i] = userModifiedBy.getId();
                    stateChange=true;
                }
            }
        }
        return stateChange;
    }

    /**
     * Returns the information about the current logged In user
     * @return
     */
    private User getUserModifiedBy() {
    	User user = UserUtil.getCurrentUser();
    	if(user==null){
    		user = new User();
    		user.setId("1");
    	}
    	return user;
	}

	public boolean onLoad(Object entity,
                          Serializable id,
                          Object[] state,
                          String[] propertyNames,
                          Type[] types) {
        if ( entity instanceof BaseEntity ) {
         }
        return false;
    }

    public boolean onSave(Object entity,
                          Serializable id,
                          Object[] state,
                          String[] propertyNames,
                          Type[] types) {
       boolean stateChange=false;
       User userModifiedBy = getUserModifiedBy();
        if ( entity instanceof BaseEntity ) {
             for ( int i=0; i<propertyNames.length; i++ ) {
                if ( "createdDate".equals( propertyNames[i] ) ) {
                    state[i] = new Date();
                    stateChange=true;
                }
                if ( "modifiedDate".equals( propertyNames[i] ) ) {
                    state[i] = new Date();
                    stateChange=true;
                }
                if ( "createdBy".equals( propertyNames[i] ) ) {
                    state[i] = userModifiedBy.getId();
                    stateChange=true;
                }
                if ( "modifiedBy".equals( propertyNames[i] ) ) {
                    state[i] = userModifiedBy.getId();
                    stateChange=true;
                }
            }
        }
        return stateChange;
    }
}
