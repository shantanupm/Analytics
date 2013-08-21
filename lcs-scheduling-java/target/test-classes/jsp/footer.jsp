<% 
		java.util.jar.Manifest manifest = new java.util.jar.Manifest();
		manifest.read(pageContext.getServletContext().getResourceAsStream("/META-INF/MANIFEST.MF"));
		java.util.jar.Attributes attributes = manifest.getMainAttributes();
		String projectVersion = attributes.getValue("Specification-Version");
		String hudsonBuildNumber = attributes.getValue("Implementation-Version");
	%>
<div class="footer">
	 	<div class="footerMast">
			<span>© 2012 LoudCloud Systems </span>
	 		<span>version <%=projectVersion%></span>
	 	</div>
	 </div>