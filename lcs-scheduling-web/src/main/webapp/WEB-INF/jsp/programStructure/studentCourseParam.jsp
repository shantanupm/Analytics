<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CRM Screen</title>
</head>

<body>

<form name="progStrucForm" action="programStructure.html?operation=displayStudentProgramSchedule" method="post">
<div class="tbl1"><table class="tableS1" width="100%" border="1" cellspacing="0" style="border-collapse:collapse;" cellpadding="0">  
  <tr>
    <th width="75%">Cvue Catalog Code</td>
    <th width="25%"><input type="text" name="catalogCode"></td>
  </tr>
  <tr>
    <td>Cvue Program Version Code</td>
    <td><input type="text" name="programVersionCode"></td>	
  </tr> 
  <tr>
    <td>State Code</td>
    <td><input type="text" name="stateCode"></td>
  </tr>
  <tr>
    <td>Program Start Date (YYYY-MM-DD)</td>
    <td><input name="programStartDate" value=""></td>
  </tr>
  <tr>
    <td>Student CVue Id</td>
    <td><input name="studentCVueId" value=""></td>
  </tr>  
</table></div>
  <tr>
	<td><input type="submit" value="Submit"></td>
  </tr>
</form>
</body>
</html>
