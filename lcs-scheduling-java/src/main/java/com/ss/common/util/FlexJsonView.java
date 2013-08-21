package com.ss.common.util;

import java.io.OutputStream;
import java.io.Writer;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.view.AbstractView;


import flexjson.JSONSerializer;

@Component("flexJsonView")
public class FlexJsonView extends AbstractView{
	private static final Logger log = LoggerFactory.getLogger(FlexJsonView.class);


	protected void renderMergedOutputModel(Map model,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		String output = "";
		JSONSerializer serializer = new JSONSerializer();
		serializer.exclude("*.class");
		FlexJsonConfig config = null;
		if(model.get(Constants.FLEX_JSON_CONFIG)!=null){
			config = (FlexJsonConfig) model.get(Constants.FLEX_JSON_CONFIG);
			if(config.getIncludeList().size()>0){
				for(String property:config.getIncludeList()){
					serializer.include(property);
				}
			}
			if(config.getExcludeList().size()>0){
				for(String property:config.getExcludeList()){
					serializer.exclude(property);
				}
			}
		}else{
			config = new FlexJsonConfig();
			
		}
		if(model.get(Constants.FLEX_JSON_DATA)!=null){
			if(config!=null){
				serializer.prettyPrint(config.isPrettyPrint());
				if(config.isDeepSerialize()){
					output = serializer.deepSerialize(model.get(Constants.FLEX_JSON_DATA));
				}else{
						output = serializer.serialize(model.get(Constants.FLEX_JSON_DATA));
				}
			}else{
				serializer.prettyPrint(config.isPrettyPrint());
				output = serializer.serialize(model.get(Constants.FLEX_JSON_DATA));
			}
		}else{
			output="{\"result\": \"noresult\"}";
		}
		response.setContentType( "text/plain;charset=UTF-8" );
		OutputStream out =response.getOutputStream();
		out.write(output.getBytes());
		out.flush();
		out.close();
	}
}
