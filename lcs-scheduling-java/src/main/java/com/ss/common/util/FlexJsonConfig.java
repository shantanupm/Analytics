package com.ss.common.util;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FlexJsonConfig {
	private static final Logger log = LoggerFactory.getLogger(FlexJsonConfig.class);

	private List<String> includeList;
	private  List<String> excludeList;
	private boolean prettyPrint = false;
	private boolean deepSerialize = false;
	public FlexJsonConfig(){
		includeList=new ArrayList<String>();
		excludeList=new ArrayList<String>();
		
	}
	public List<String> getIncludeList() {
		return includeList;
	}
	public List<String> getExcludeList() {
		return excludeList;
	}
	public boolean isPrettyPrint() {
		return prettyPrint;
	}
	public void setPrettyPrint(boolean prettyPrint) {
		this.prettyPrint = prettyPrint;
	}
	public boolean isDeepSerialize() {
		return deepSerialize;
	}
	public void setDeepSerialize(boolean deepSerialize) {
		this.deepSerialize = deepSerialize;
	}
	public void include(String property){
		includeList.add(property);
	}
	public void exclude(String property){
		excludeList.add(property);
	}
}
