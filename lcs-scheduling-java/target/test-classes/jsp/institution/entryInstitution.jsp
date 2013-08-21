<%@include file="../init.jsp" %>

 <form  id="frmEntryInstitution" method="post" action="/scheduling_system/institution/manageInstitution.html?operation=saveEntryInstitution">
 <div class="popCont">
        <h1><a href="#" class="close"></a> New Instituion</h1>

        <label class="caption">School Code</label>
        <input name="schoolcode" value="${institution.schoolcode}" type="text" class="textField small required" />
        <br class="clear" />
        
        <label class="caption">Institution Name</label>
        <input name="name" type="text" value="${institution.name}" class="textField big required"  />
		 <input name="programVersionCode" id="entryProgramVersionCode" type="hidden" value="" class="textField"  />
		 <input name="studentCrmId" id="entryStudentCrmId" type="hidden" value="" class="textField"  />
		
		 <input name="catalogCode" id="entryCatalogCode" type="hidden" value="" class="textField"  />
		 <input name="stateCode" id="entryStateCode" type="hidden" value="" class="textField"  />
         <input name="expectedStartDate" id="entryExpectedStartDate" type="hidden" value="" class="textField"  />
		
        
        <br class="clear" />
         <div class="buttonRow">
			<input name="" type="submit" value="Save" />
            <input name="" type="button"  class="close"  value="Cancel" /></div>
 </div>
  
  </form>