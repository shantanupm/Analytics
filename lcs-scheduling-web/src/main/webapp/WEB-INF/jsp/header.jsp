<%@include file="init.jsp" %>
<%@page import="com.ss.common.util.UserUtil"%>
<%@page import="com.ss.user.value.User"%>
<%@page import="java.util.Collection"%>
<%@page import="com.ss.user.value.Role"%>
<%@page import="org.springframework.security.core.GrantedAuthority"%>


<% User currentUser = UserUtil.getCurrentUser();
    request.setAttribute("userRoleName", UserUtil.getCurrentRole().getDescription()); 
    request.setAttribute("userName", currentUser.getFirstName() +" "+currentUser.getLastName());
    request.setAttribute("userID", currentUser.getId() ); 
	
    String strRole="",strRoleId="" ;
    Collection<GrantedAuthority> authorities = currentUser.getAuthorities();
	if (authorities != null && authorities.size() > 0) {
		for(int i=0;i<authorities.size();i++){
		 strRole = strRole+((Role) (authorities.toArray()[i])).getDescription();
		 strRoleId = strRoleId+((Role) (authorities.toArray()[i])).getId();
		 if(i!=authorities.size()-1){
			 strRole=strRole+",";
			 strRoleId=strRoleId+",";
		 }
		}
	}
	request.setAttribute("userRoleNames", strRole); 
    request.setAttribute("userRoleIds", strRoleId);
%>
<!-- Header -->
<div class="headerpt">
	<a class="logo floatLeft" href="javascript:void(0)" onclick="Boxy.load(&quot;popup/view_bu_details.html&quot;,{afterShow: boxyAfterShowCall});">
    <img src="../images/gculogo.png" title="" alt="" />
    </a>
    <div class="usernotArea">
    	<div class="userareabox"> 
    	
    	</a> <span class="name">${userName}</span> 
        <br>
        <span class="usertypr"><em>${userRoleNames}</em></span>
        <br>
        <span class="userloginDate">
        <jsp:useBean id="now" class="java.util.Date"  />
		<fmt:formatDate value="${now}" pattern="MMM dd, yyyy" /> </span> </div>
    </div>
    <div class="floatRight">
    	<div class="">
        	<a href="/scheduling_system/j_spring_security_logout">Logoff</a>
        </div>
    </div>
    <div class="clear"></div>
</div>
<!-- Header End -->

<!-- <div style="float:right;"><a class="signout" href='/scheduling_system/j_spring_security_logout'></a></div> -->