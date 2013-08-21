package com.ss.common.util;

import org.quartz.SchedulerContext;
import org.quartz.spi.TriggerFiredBundle;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.MutablePropertyValues;
import org.springframework.beans.PropertyAccessorFactory;
import org.springframework.scheduling.quartz.SpringBeanJobFactory;
import org.springframework.web.context.support.XmlWebApplicationContext;
	 
	/**
	 * @author sseaman - mostly a cut/paste from the source class
	 *
	 */
	public class CustomSpringBeanJobFactory extends SpringBeanJobFactory
	{
	 
	    private String[] ignoredUnknownProperties;
	 
	    private SchedulerContext schedulerContext;
	 
	    @Override
	    public void setIgnoredUnknownProperties(String[] ignoredUnknownProperties) {
	        super.setIgnoredUnknownProperties(ignoredUnknownProperties);
	        this.ignoredUnknownProperties = ignoredUnknownProperties;
	    }
	 
	    @Override
	    public void setSchedulerContext(SchedulerContext schedulerContext) {
	        super.setSchedulerContext(schedulerContext);
	        this.schedulerContext = schedulerContext;
	    }
	 
	    /**
	     * An implementation of SpringBeanJobFactory that retrieves the bean from
	     * the Spring context so that autowiring and transactions work
	     *
	     * This method is overriden.
	     * @see org.springframework.scheduling.quartz.SpringBeanJobFactory#createJobInstance(org.quartz.spi.TriggerFiredBundle)
	     */
	    @Override
	    protected Object createJobInstance(TriggerFiredBundle bundle) throws Exception {
	        XmlWebApplicationContext ctx = ((XmlWebApplicationContext)schedulerContext.get("applicationContext"));
	        Object job = ctx.getBean(bundle.getJobDetail().getName());
	        BeanWrapper bw = PropertyAccessorFactory.forBeanPropertyAccess(job);
	        if (isEligibleForPropertyPopulation(bw.getWrappedInstance())) {
	            MutablePropertyValues pvs = new MutablePropertyValues();
	            if (this.schedulerContext != null) {
	                pvs.addPropertyValues(this.schedulerContext);
	            }
	            pvs.addPropertyValues(bundle.getJobDetail().getJobDataMap());
	            pvs.addPropertyValues(bundle.getTrigger().getJobDataMap());
	            if (this.ignoredUnknownProperties != null) {
	                for (String propName : this.ignoredUnknownProperties) {
	                    if (pvs.contains(propName) && !bw.isWritableProperty(propName)) {
	                        pvs.removePropertyValue(propName);
	                    }
	                }
	                bw.setPropertyValues(pvs);
	            }
	            else {
	                bw.setPropertyValues(pvs, true);
	            }
	        }
	        return job;
	    }
	 
	}