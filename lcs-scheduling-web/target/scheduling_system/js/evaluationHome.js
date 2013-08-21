
/*
 * Invoked when a value in the textfield in the table changes.
 * Sets the hasUnsavedValues value to "1" to indicate that the data in the current row has changed and needs to be saved. 
 */
function valuesChanged(textBox) {
	var currentRow = jQuery(textBox).closest("tr").prevAll("tr").length;
	currentRow = currentRow - 1;
	jQuery("#hasUnsavedValues_"+currentRow).val("1");
}


/*
 * When the trCourseId field gains focus OR credits loses focus OR remove link is clicked, data needs to be saved. 
 * This method checks whether the any data has been changed based on the 'hasUnsavedValues' field for each row.
 * If even one 'hasUnsavedValues' is 1, then the entire table is posted for saving.
 */
function initEventHandlerForSave() {
	jQuery(".completionDate").live('focus', function(event) {
		saveUnsavedData();
	});
	
	jQuery(".courseCredits").live('blur', function(event) {
		saveUnsavedData();
	});
	
	jQuery(".removeRow").live('click', function(event) {
		//set the hasValuesChanged field to 1 for the previous row since the current row is going to be deleted.
		var idArray = jQuery(this).attr("id").split('_');
		var prevRow = idArray[idArray.length - 1] - 1;
		if( prevRow < 0 ) {
			prevRow = 0;
		}
		jQuery("#hasUnsavedValues_"+prevRow).val("1");
		
		//remove the current row
		jQuery(this).parent().parent().remove();

		//set the remove link for the previous row in the table unless it is the first row.
		var noOfRows = jQuery("#transferCourseTbl").attr('rows').length;
		rowIndex = noOfRows - 2;
		if( rowIndex == -1 ) {
			rowIndex = 0;
		}
		if( rowIndex > 0 ) {
			jQuery("#removeRowTd_"+(rowIndex)).html( "<a href='javaScript:void(0);'id='removeRow__"+rowIndex+"' class='removeIcon fr removeRow'></a>" );	
		}
		/*if(rowIndex == 0){
			jQuery("#removeRowTd_"+(rowIndex)).html("<a href='javascript:void(0)' name='addRow_"+rowIndex+"' class='addRow' onclick='addCourseRow1();'><img width='15' height='14' alt='add' src='../images/addCourse.png'> Add New</a>");
		}*/
		
		
		//Post the changed data
		//saveUnsavedData();//Enable if we want to remove course at the click of the remove icon
	});
}

/*
 * Saves the draft courses.
 */
function saveUnsavedData() {
	
	//If a save operation is already in progress, return from here.
	if( jQuery("#isSaveDraftInProgress").val() == "1" ) {
		return;
	}
	
	var noOfRows = jQuery("#transferCourseTbl").attr('rows').length;
	lastRowIndex = noOfRows - 2;
	if( lastRowIndex < 0 ) {
		lastRowIndex = 0;
	}
	isValueChanged = false;
	for( var ctr=0; ctr<=lastRowIndex; ctr++ ) {
		if( jQuery("#hasUnsavedValues_"+ctr).val() == "1" ) {
			isValueChanged = true;
			break;
		}
	}
	
	if( isValueChanged == true ) {
		var formObj = document.forms["transferCourseForm"];
		
		document.transferCourseForm.coursesAdded.value=jQuery("#transferCourseTbl").attr('rows').length-1;
		var params = jQuery(formObj).serialize();
		//jQuery.post( "<c:url value='/evaluation/launchEvaluation.html?operation=saveDraftCourses'></c:url>", params, function(data) {
		jQuery("#isSaveDraftInProgress").val( "1" );
		jQuery.post( "/scheduling_system/evaluation/launchEvaluation.html?operation=saveDraftCourses", params, function(data) {
			response =  eval("(" + data + ")");
			if( response.success == "true" ) {
				for( var ctr=0; ctr<=lastRowIndex; ctr++ ) {
					jQuery("#hasUnsavedValues_"+ctr).val( "0" );
				}
			}
			jQuery("#isSaveDraftInProgress").val( "0" );
		});
	}
}


//Function to update the status of a Transcript (Official / Un official) with ajax call.
function updateEvalStatus( radioName, transcriptId ) {
	
	var value = jQuery( 'input:radio[name='+radioName+']:checked' ).val();
	var params = "&transcriptId="+transcriptId+"&official="+value;
	
	jQuery.post( "/scheduling_system/evaluation/launchEvaluation.html?operation=updateTranscriptStatus", params, function(data) {
	});
}



/*
 * Generic method to add Rows to a table dynamically.
 * Parameters - 
 * 	elementCssClass - the css class applied on the UI controls which need to generate the next row.
 *  eventName - the event which will trigger the new row to be created. eg. 'blur'.
 *  htmlTableName - the id of the table of which a new row needs to be added.
 *  removeLinkTdName - if there is a 'Remove' link in the table which needs to be removed, specify it here.
 *  appendText - the html of the row to be created with the dynamic row index replaced by a placeholder value.
 *  placeholder - the placeholder string which will be replaced by the row index while generating the new row.
 * 
 */
function addDynamicRows( elementCssClass, eventName, htmlTableName, removeLinkTdName, appendText, placeholder ) {
	
	var cssClass = "." + elementCssClass;
	var tableName = "#" + htmlTableName;
	jQuery( cssClass ).live( eventName, function(event) {
		var noOfRows = jQuery( tableName ).attr('rows').length;
		index = noOfRows - 1;
		if( index == -1 ) {
			index = 0;
		}
		
		//If the current field is not in the last row, don't append additional row
		var currentIndex = jQuery(this).parent().parent().parent().children().index( jQuery(this).parent().parent() );
		if( currentIndex < index ) {
			return;
		}
	
		//If the value in the current field is blank, don't append additional row
		if( jQuery.trim(jQuery(this).val()) == '' ) {
			return;
		}
		
		if( removeLinkTdName ) {
			jQuery("#" + removeLinkTdName +(index-1)).html( "" );
		}		
		
		var appendTextCopy = appendText;
		appendTextCopy = appendTextCopy.replace( new RegExp( placeholder, "gi" ), index );
		appendTextCopy = appendTextCopy.replace( new RegExp( "@srNoHolder@", "gi" ), index+1 );
	    jQuery( tableName + " tr:last" ).after(appendTextCopy);
	   
	    settingMaskInput();
	} );
}

//function called when the selectInstitution popup loads.
function loadSelectInstitutionPopup() {
	jQuery( "#insDegree" ).width( jQuery( "#selInstitution" ).width() );
	
	jQuery( "#selInstitution" ).change( function() {
		var str = "";
    	str = jQuery("#selInstitution option:selected").attr('id');
    	jQuery("#schoolCode").val(str);
    	jQuery("#selinstitutionId").val(jQuery("#selInstitution").val());
    	
	});	


	jQuery( ".selDegreeClass" ).live( "change", function(event) {
		var strDeg = jQuery(this).val();
		var idArray = jQuery(this).attr("id").split('_');
		var currentRowIndex = idArray[idArray.length - 1];
		if( strDeg != "NA" ) {
    		jQuery( "#major_" + currentRowIndex ).attr('disabled', false);
    	}
    	else {
    		jQuery( "#major_" + currentRowIndex ).val( "" );
    		jQuery( "#major_" + currentRowIndex ).attr('disabled', true );
    	}
	} );

	
	var placeholder = "@placeholder@";
	var srNoHolder = "@srNoHolder@";
	
	var appendInsText = 
		"<tr><td align='left'><label>"+srNoHolder+"</label></td><td align='left'><select id='insDegree_"+placeholder+"' name='insDegree_"+placeholder+"' class='frm-stxbx selDegreeClass eventCaptureField'><option value='NA'>N/A</option><option value='Associates'>Associates</option><option value='Bachelors'>Bachelors</option><option value='Masters'>Masters</option><option value='Doctoral'>Doctoral</option></select></td>"
		+
	    "<td align='left'><input id='major_"+placeholder+"' name='major_"+placeholder+"' type='text' class='txbx degreeMajorClass' disabled='disabled'/></td>"
	    +
	    "<td align='left'><input name='degreeDate_"+placeholder+"' id='degreeDate_"+placeholder+"' type='text' class='txbx maskDate' /></td>"
	    +
	    "<td align='left'><input type='text' name='GPA_"+placeholder+"' id='GPA_"+placeholder+"' style='width:40px;' class='txbx w40' /></td>"
	    +
	    "<td align='left'><input type='text' name='lastAttendenceDate_"+placeholder+"' id='lastAttendenceDate_"+placeholder+"' class='txbx maskDate' /></td>"
	    +
	    "<td id='removeRowTd_"+placeholder+"'><a href='#' id='removeRow_"+placeholder+"' name='removeRow_"+placeholder+"' class='removeInstitutionRow'><img src='../images/removeIcon.png' width='15' height='15' alt='Delete' /> Remove</a></td></tr>";
	
	addRowsAtFly( 'eventCaptureField', 'blur', 'addInstitutionTbl', 'removeRowTd_', appendInsText, placeholder );	

	//Remove rows when Remove link is clicked.
	jQuery(".removeInstitutionRow").live('click', function(event) {
		//remove the current row
		jQuery(this).parent().parent().remove();

		//set the remove link for the previous row in the table unless it is the first row.
		var noOfRows = jQuery("#addInstitutionTbl").attr('rows').length;
		rowIndex = noOfRows - 2;
		alert("rowIndex="+rowIndex);
		if( rowIndex == -1 ) {
			rowIndex = 0;
		}
		if( rowIndex > 0 ) {
			jQuery("#removeRowTd_"+(rowIndex)).html( "<a href='#' id='removeRow_"+rowIndex+"' name='removeRow_"+rowIndex+"' class='removeInstitutionRow'><img src='../images/removeIcon.png' width='15' height='15' alt='Delete' /> Remove</a>" );
		}
	} );
	
}



function addRowsAtFly( elementCssClass, eventName, htmlTableName, removeLinkTdName, appendText, placeholder ) {
	
	var cssClass = "." + elementCssClass;
	var tableName = "#" + htmlTableName;
	//jQuery( cssClass ).live( eventName, function(event) {
		var noOfRows = jQuery( tableName ).attr('rows').length;
		//alert("noOfRows="+noOfRows);
		index = noOfRows - 1;
		if( index == -1 ) {
			index = 0;
		}
		
		/*//If the current field is not in the last row, don't append additional row
		var currentIndex = jQuery(this).parent().parent().parent().children().index( jQuery(this).parent().parent() );
		if( currentIndex < index ) {
			return;
		}
		alert("currentIndex="+currentIndex);
		//If the value in the current field is blank, don't append additional row
		if( jQuery.trim(jQuery(this).val()) == '' ) {
			return;
		}*/
		
		if( removeLinkTdName ) {
			jQuery("#" + removeLinkTdName +(index-1)).html( "" );
		}		
		//alert("index="+index);
		var appendTextCopy = appendText;
		//appendTextCopy = appendTextCopy.replace( new RegExp( placeholder, "gi" ), index );
		//appendTextCopy = appendTextCopy.replace( new RegExp( "@srNoHolder@", "gi" ), index+1 );
		//alert("appendTextCopy="+appendTextCopy);
		//alert("tableName="+tableName);
	    jQuery( tableName + " tr:last" ).after(appendTextCopy);
	   
	    settingMaskInput();
	//} );
}


