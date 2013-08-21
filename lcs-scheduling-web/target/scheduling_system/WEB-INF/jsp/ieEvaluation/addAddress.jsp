<%@include file="../init.jsp" %>


<script>
		  
jQuery(document).ready(function(){	

	
});
</script>
<div class="popCont popUpBig" style="width:700px;">
    <h1><a class="close" title="close"></a>
    <c:choose>
    <c:when test="${not empty institutionAddress.id}">Edit</c:when>
    <c:otherwise>Add</c:otherwise>
    </c:choose> Address</h1>
    
<form action='<c:url value="/evaluation/quality.html?operation=addAddress"/>' method="post" id="addAddressForm" >
      <div class="contentForm">
                
       	  <div class="borderRight widhth50 mt10"> 
                    <label class="noti-label w100">Address:<span class="strColor">*</span></label>
                    <input type="text"  name="address1"  value="${institutionAddress.address1 }" class="textField w170 required"> 
                    <br  class="clear"/>
                     <label class="noti-label w100"></label>
                    <input type="text"  name="address2"  value="${institutionAddress.address2 }"  class="textField w170"> 
                    <br  class="clear"/>
<label class="noti-label w100">City:<span class="strColor">*</span></label>
                    <input type="text"  name="city"  value="${institutionAddress.city }"  class="textField w170 required"> <br  class="clear"/>
                    
                    
<label class="noti-label w100">State:<span class="strColor">*</span></label>
                    <input name="state" id="state" value="${institutionAddress.state}" class="textField w170 required stateClass" />
 
                    <br  class="clear"/>
                  
<label class="noti-label w100">Zip Code:<span class="strColor">*</span></label>
                    <input type="text"  name="zipcode" id="zipcode"  value="${institutionAddress.zipcode }"  class="textField required w170">
                    <br  class="clear"/>
                    <label class="noti-label w100" style="padding-bottom:0px;">Country:<span class="strColor">*</span></label>
                    <span class="widhth50">
                    <select id="countryId" name="country.id" class="valid w170 required">
                    <option value="">Select the Country</option>
						<c:forEach items="${countryList}" var="country">
							<option
							<c:choose>
								<c:when test="${not empty institutionAddress.country.id }">
									<c:if test="${institutionAddress.country.id == country.id}"> selected="true" </c:if>
								</c:when>
								<c:otherwise>
									<c:if test="${country.id eq 1 }"> selected="true" </c:if>
								</c:otherwise>
							</c:choose>									
									value="${country.id}">${country.name} </option>
							</c:forEach>
				
                    </select>
                    </span><br  class="clear"/>
        </div>
                    
                    
   	    <div class="widhth50 mt10">
                  <label class="noti-label w100">Phone:<span class="strColor">*</span></label>
                    <input type="text" id="phone1"  name="phone1"  value="${institutionAddress.phone1 }"  class="textField w170 required number">
                    
                    <br  class="clear"/>
                    
                     <label class="noti-label w100">Phone:</label>
                    <input type="text" id="phone2" name="phone2"  value="${institutionAddress.phone2 }"  class="textField w170 number">
                    
                    <br  class="clear"/>
                    
                     <label class="noti-label w100">Fax:</label>
                    <input type="text"  id= "fax" name="fax"  value="${institutionAddress.fax }"  class="textField w170">
                    
                    <br  class="clear"/>
                     <label class="noti-label w100">Toll Free:</label>
                    <input type="text"  name="tollFree"  value="${institutionAddress.tollFree }"  class="textField tollFree w170">
                    
                    <br  class="clear"/>
                    
                     <label class="noti-label w100">Website:</label>
                    <input type="text"  name="website"  value="${institutionAddress.website }"  class="textField w170 url">
                    
                    <br  class="clear"/>
                    
                     <label class="noti-label w100">Email ID:</label>
                    <input type="text"  name="email1"  value="${institutionAddress.email1 }"  class="textField w170 email">
                    
                    <br  class="clear"/>
                    
   				<input type="hidden"  name="institutionId"  value="${institutionId }"  class="textField w170">
   				<c:if test="${not empty institutionAddress.id}">
					<input name="id" id="addressId"	type="hidden" value="${institutionAddress.id}" /> 
					<input name="createdBy" id="createdBy"	type="hidden"  value="${institutionAddress.createdBy}" />
					<input name="createdDate" id="createdDate"	type="hidden" value='<fmt:formatDate value="${institutionAddress.createdDate}" pattern="MM/dd/yyyy"/>'  value="${institutionAddress.createdDate}" />
			</c:if>
                    
          </div>
       	  <div class="clear"></div>
                    
      </div>			                	                    
                
   <div class="dividerPopup "></div>             

   <div class="btn-cnt">
   <div class="fr">
			<input type="submit" name="Add" value="<c:choose> <c:when test="${not empty institutionAddress.id}">Save</c:when> <c:otherwise>Add</c:otherwise> </c:choose>" id="Add" class="button">
			<input type="button" name="cancel" value="Cancel" id="Cancel"  class="button close">
		</div>
            <div class="clear"></div>
  </div> 
  </form>
</div>