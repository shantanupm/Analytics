 <%@include file="../init.jsp" %>

 <script>

 function findInstitutionDetails(text){
	 
	 
		//alert('in here ctr='+ctr);
		if( jQuery.trim(text) == '' ) {
			return;
		}
		
		jQuery.getJSON("<c:url value="/institution/manageInstitution.html?operation=getInstitutionDetails"/>&institutionId="+text,function (JsonData){
			//alert(JsonData.id);				
				if(JsonData.id === undefined){	
					//alert('in else');
					jQuery('#schoolCode').val('');
					jQuery('#address1').val('');	
					jQuery('#address2').val('');
					
				}
				else {
					//alert('in if');	
					jQuery('#schoolCode').val(JsonData.schoolcode);
					jQuery('#address1').val(JsonData.address1);	
					jQuery('#address2').val(JsonData.address2);				
						
				}		
		});
	};
	 
 </script>
 <div style="width:500px;" class="popCont">
        <h1><a href="#" class="close"></a>Select Parent Institution</h1>

       <br /> <label class="caption caption5">Institution Code:</label>
        <input id="schoolCode" name="" type="text" class="textField small " /><br class="clear" />

        <label class="caption caption5">Institution Name:</label>
        <select style="width:352px" id="selInstitution" onchange="findInstitutionDetails(this.value)">
			<option id="" value="">Select the Institution</option>
			<c:forEach items="${institutionList}" var="institution">
				<option id="${institution.schoolcode}" value="${institution.id}">${institution.name}</option>
			</c:forEach>			    
		</select> 
		<br class="clear" />

        <label class="caption caption5">Institution Address1:</label>
        <input id="address1"  name="" type="text" class="textField big " readonly="readonly" /><br class="clear" />

        <label class="caption caption5">Institution Address2:</label>
        <input id="address2" name="" type="text" class="textField big " readonly="readonly" /><br class="clear" />
        
        <label class="caption caption5">Accrediting Body:</label>
        <input id="accreditingBody" name="" type="text" class="textField big "  readonly="readonly" /><br class="clear" />
        
        <div class="fr mr10">
            <input type="button" id="selectInstitutionBtn" class="close" onclick="selectInstitute()" value="Select Institution" name="Select Institution" />
        </div><br class="clear" />
        <br class="clear" />
        <hr />
        <br class="clear" />
         <label class="">If the Parent Institution is not available in the list, add the Parent Institution to re-use database.</label>
         <br class="clear" />
         <br class="clear" />
    </div>