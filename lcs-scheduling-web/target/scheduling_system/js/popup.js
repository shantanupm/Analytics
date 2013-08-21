 
var popupStatus = 0;

function loadPopup(){
	if(popupStatus==0){
		jQuery("#popupBg").css({
			"opacity": "0.5"
		});
		jQuery("#popupBg").fadeIn("slow");
		jQuery("#popup").fadeIn("fast");
		popupStatus = 1;
	}
}

function loadPopup2(){
	if(popupStatus==0){
		jQuery("#popupBg2").css({
			"opacity": "0.5"
		});
		jQuery("#popupBg2").fadeIn("slow");
		jQuery("#popup2").fadeIn("fast");
		popupStatus = 1;
	}
}


function loadPopup3(){
	if(popupStatus==0){
		jQuery("#popupBg3").css({
			"opacity": "0.5"
		});
		jQuery("#popupBg3").fadeIn("slow");
		jQuery("#popup3").fadeIn("fast");
		popupStatus = 1;
	}
}

function disablePopup(){
	if(popupStatus==1){
		jQuery("#popupBg").fadeOut("slow");
		jQuery("#popup").fadeOut("fast");
		popupStatus = 0;
	}
}

function disablePopupCal(){
	if(popupStatus==1){
		jQuery("#popupBg").fadeOut("slow");
		jQuery("#popup").fadeOut("fast");
		popupStatus = 0;
		jQuery(".error").html("");
		jQuery(".required").removeClass("error");
		jQuery("#endDates").html("");
	}
}



function disablePopup2(){
	if(popupStatus==1){
		jQuery("#popupBg2").fadeOut("slow");
		jQuery("#popup2").fadeOut("fast");
		popupStatus = 0;
	}
}

function disablePopup3(){
	if(popupStatus==1){
		jQuery("#popupBg3").fadeOut("slow");
		jQuery("#popup3").fadeOut("fast");
		popupStatus = 0;
	}
}

function centerPopup(){
	var windowWidth = document.documentElement.clientWidth;
	var windowHeight = document.documentElement.clientHeight;
	var popupHeight = jQuery("#popup").height();
	var popupWidth = jQuery("#popup").width();
	jQuery("#popup").css({
		"position": "absolute",
		"top": 50,
		"left": windowWidth/2-popupWidth/2
	});
	jQuery("#popupBg").css({
		"height": windowHeight
	});
}

function centerPopup2(){
	var windowWidth = document.documentElement.clientWidth;
	var windowHeight = document.documentElement.clientHeight;
	var popupHeight = jQuery("#popup2").height();
	var popupWidth = jQuery("#popup2").width();
	jQuery("#popup2").css({
		"position": "absolute",
		"top": 50,
		"left": windowWidth/2-popupWidth/2
	});
	jQuery("#popupBg2").css({
		"height": windowHeight
	});
}

function centerPopup3(){
	var windowWidth = document.documentElement.clientWidth;
	var windowHeight = document.documentElement.clientHeight;
	var popupHeight = jQuery("#popup3").height();
	var popupWidth = jQuery("#popup3").width();
	jQuery("#popup3").css({
		"position": "absolute",
		"top": 50,
		"left": windowWidth/2-popupWidth/2
	});
	jQuery("#popupBg3").css({
		"height": windowHeight
	});
}

jQuery(document).ready(function(){
 	jQuery(".popupLink111").click(function(){
		centerPopup();
		loadPopup();
	});
	
	jQuery(".popupLink2111").click(function(){
		centerPopup2();
		loadPopup2();
	});
	
	jQuery(".popupLink3111").click(function(){
		centerPopup3();
		loadPopup3();
	});
				
	jQuery("#popupClose").click(function(){
		disablePopup();
	});
	jQuery("#popupClose2").click(function(){
		disablePopup2();
	});
	jQuery("#popupClose3").click(function(){
		disablePopup3();
	});


});