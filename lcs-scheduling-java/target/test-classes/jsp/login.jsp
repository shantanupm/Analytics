<%@include file="init.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Welcome,</title>
    <link rel="shortcut icon" href="../images/favicon.ico" />
    <link href="../css/style.css" rel="stylesheet" type="text/css" />
    
    </head>

<body class="loginBody2">
	<div class="login_outrbox">
    	<div align="center" class="logo_header">
        	<img align="middle" title="" src="../images/gculogo.png" alt="" />
        </div>
        <div class="login_header_sap"></div>
    	<div class="login_mainbox">
        	<div class="loginmnboxtbl">
        	<form name='f' action='${pageContext.request.contextPath}/j_spring_security_check' method='POST'>
        		<label class="caption">User ID:</label><input type="text" name="j_username" class="textBoxField box5" style="width:166px;"> <br class="clear" />
                <label class="caption">Password:</label><input type="password" name="j_password" class="textBoxField box5" style="width:166px;">
                <div aria-live="polite" style="padding-top:8px;font-size:12px;color: red;" id="serverError"><c:if test="${param.showError == '1'}">Please enter a valid username and password.</c:if>
                </div>
                <div class="buttonRow1">
                	<input type="submit" class="button saveButton" value="&nbsp;Submit&nbsp;" name="submit">&nbsp; 
                	<input type="reset" class="button saveButton" value="&nbsp;Reset&nbsp;" name="reset">
                </div>
             </form>
            </div>
        </div>
    </div>
</body>
</html>



<!-- <h3>Login with Username and Password</h3>
<form name='f' action='${pageContext.request.contextPath}/j_spring_security_check' method='POST'>
 <table>
    <tr><td>User:</td><td><input type='text' name='j_username' value=''></td></tr>
    <tr><td>Password:</td><td><input type='password' name='j_password'/></td></tr>
    <!--tr><td></td><td>Remember me on this computer.</td></tr->
    <tr><td colspan='2'><input name="submit" value="Submit" type="submit"/></td></tr>
    <tr><td colspan='2'><input name="reset" value="Reset" type="reset"/></td></tr>
  </table>
</form>
 -->