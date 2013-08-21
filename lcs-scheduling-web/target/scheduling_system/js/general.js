 
  
  			jQuery.noConflict();

			

			// Document Ready Event

			jQuery(document).ready(function(){

			

				// Add dropdown class to links that have dropdowns

				jQuery('.menu > li > ul, .navMenu > li > ul').each(function(i,li) {

					jQuery(li).parent('li').addClass('dropdown');

				});

				

				// Add dropdown class to links that have dropdowns

				jQuery('.menu > li > ul, .navMenu > li > ul').each(function(i,li) {

					jQuery(li).parent('li').addClass('dropdown');

				});



				// Drop down menus - level 2

				jQuery(".menu > li,.navMenu > li").hover(

				function(){

					var menu = jQuery(this).children(':parent > ul');

					var offset = jQuery(this).offset();

					var bodywidth = jQuery('body').width();

					

					// Check to make sure the dropdown won't go off screen

					if(offset.left + 189 > bodywidth) {

						menu.css({

							left: 'auto',

							right: '0px'

						});

					}

					

					menu.css({visibility: "visible",display: "none"}).slideDown(268);

					// menu.slideDown(268);

				},

				function() {

					var menu = jQuery(this).children(':parent > ul');

					menu.css({visibility: "hidden"});

				});
				
				jQuery(".menu > li,.navMenu > li").click(
					function() {
						var menu = jQuery(this).children(':parent > ul');
						menu.css({visibility: "hidden"});
					}
				);
				

				// Drop down menus - level 3

				jQuery(".menu > li > ul > li, .navMenu > li > ul > li").hover(

				function(){

					var menu = jQuery(this).children(':parent > ul');

					var offset = jQuery(this).offset();

					var bodywidth = jQuery('body').width();

					

					// Check to make sure the dropdown won't go off screen

					if(offset.left + 378 > bodywidth) {

						menu.css({

							left: '-189px'

						});

					}

					

					// menu.slideDown(268);

					menu.css({visibility: "visible",display: "none"}).slideDown(268)

				},

				function() {

					var menu = jQuery(this).children(':parent > ul');

					menu.css({visibility: "hidden"});

				});

				

				

				// Featured Slide Thing

				

				var items = jQuery('.featured li');

				var item_width = 630;

				var max_margin = items.length * item_width - item_width;

				var animstatus = false;

				var user_click = false;

				var animation_speed = 1000;

				var auto_speed = 7500;

				

				

				jQuery('.featured .fthumbs a').each(function(i,link) {

					var index = i+1;

					jQuery(link).click(function(e) {

						e.preventDefault();

						user_click = true;

						

						moveFeature(index);

					});

				});

				

				function moveFeature(location) {

					if(animstatus == false) {

						animstatus = true;

						var feature = jQuery('.featured ul');

						var pos = parseInt(jQuery(feature).css('left'));

						

						if(location) {

							if(location=='next') {

								if(pos == -max_margin){

									left = 0;

								}

								else {

									left = pos-item_width;

								}

							}

							else if(location=='back') {

								if(pos == 0){

									left = -max_margin;

								}

								else {

									left = pos+item_width;

								}

							}							

							else {

								left = -(item_width*location)+item_width;

							}

							

							var item = Math.abs(left/item_width);

							jQuery('.featured .fthumbs a img').removeClass('active');

							jQuery('.featured .fthumbs a:eq('+item+') img').addClass('active');

							

							feature.animate({left: left},animation_speed,"swing",function() {

								animstatus = false;

							});

						}

					}

				}

				

				function feature_automove() {

					if(user_click == true) {

						user_click = false;

					}

					else {

						moveFeature('next');

					}

				}

				var feature_auto = setInterval(feature_automove, auto_speed);

				

				// cookie functions http://www.quirksmode.org/js/cookies.html

				function createCookie(name,value,days)

				{

					if (days)

					{

						var date = new Date();

						date.setTime(date.getTime()+(days*24*60*60*1000));

						var expires = "; expires="+date.toGMTString();

					}

					else var expires = "";

					document.cookie = name+"="+value+expires+"; path=/";

				}

				function readCookie(name)

				{

					var nameEQ = name + "=";

					var ca = document.cookie.split(';');

					for(var i=0;i < ca.length;i++)

					{

						var c = ca[i];

						while (c.charAt(0)==' ') c = c.substring(1,c.length);

						if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);

					}

					return null;

				}

				function eraseCookie(name)

				{

					createCookie(name,"",-1);

				}

				// /cookie functions

				

				/**

				* Styleswitch stylesheet switcher built on jQuery

				* Under an Attribution, Share Alike License

				* By Kelvin Luck ( http://www.kelvinluck.com/ )

				**/



				jQuery(document).ready(function() {

					jQuery('.styleswitch').click(function()

					{

						switchStylestyle(this.getAttribute("rel"));

						return false;

					});

					var c = readCookie('style');

					if (c) switchStylestyle(c);

				});



				function switchStylestyle(styleName)

				{

					jQuery('link[@rel*=style][title]').each(function(i)

					{

						this.disabled = true;

						if (this.getAttribute('title') == styleName) this.disabled = false;

					});

					createCookie('style', styleName, 365);

				}

				

				jQuery(".atabs .tabs a").each(function(i) {

					jQuery(this).click(function(e){

						e.preventDefault();

										

						jQuery(".atabs .tabs a").removeClass('active');

						jQuery(this).addClass('active');

						

						jQuery('#atabs_content').empty().html(jQuery(this.getAttribute("rel")).html());

					});

				});
				jQuery('.saveLink').bind("click", function() {
					var saveLinkBlock="<div class=\"saveLinkBox\" style=\"display:none\"> <input name=\"\" type=\"text\" class=\"textField big\" id=\"linkTitle\"  onblur=\"myBlur(this);\" onfocus=\"myFocus(this);\" value=\"Add title\" /> <input name=\"\" type=\"button\" class=\"button\" value=\"Save\" id=\"saveLinkId\"/> <input name=\"\" type=\"button\" value=\"Cancel\" class=\"button\" id=\"closeBtn2\" /></div>";

					if (jQuery(".saveLinkBox").length ==0)
					{
						jQuery('.tabsCont').prepend(saveLinkBlock);
						jQuery('#closeBtn2').bind("click", function() { jQuery(".saveLinkBox").hide(); });	
						jQuery('#saveLinkId').bind("click", function() {
							
							if(jQuery("#linkTitle").val()=="" || jQuery("#linkTitle").val()== "Add title"){
								return false;
							}else{
								saveLink();
							}});						
					}	
					jQuery(".saveLinkBox").show();


			});
			});

			
			function saveLink(){
				var linkTitle = jQuery("#linkTitle").val();
				var _linkUrl = encodeURIComponent(linkUrl);
				endpoint = postURL+"?operation=saveLink&linkTitle="+linkTitle+"&linkUrl="+_linkUrl+"&moduleName="+jQuery.cookie("moduleName");
				  jQuery.ajax({
					    type: "POST",
					    async: false,
					    url: endpoint,
					    success: function(data){
							//alert("Success");
							jQuery(".saveLinkBox").hide();			 
					    },
						error: function (xhr, ajaxOptions, thrownError){
							alert("ajaxOptions="+ajaxOptions);
							alert("thrownError="+thrownError);
						}
						
					  });
			}	
			

			function bookmark(url, title){

				if (window.sidebar) // firefox

					window.sidebar.addPanel(title, url, "");

				else if(window.opera && window.print){ // opera

					var elem = document.createElement('a');

					elem.setAttribute('href',url);

					elem.setAttribute('title',title);

					elem.setAttribute('rel','sidebar');

					elem.click();

				}

				else if(document.all) // ie

					window.external.AddFavorite(url, title);

				else

					alert('Your browser does not support this function.');

			}
  
  
  
  
  
  
  
  
  
  //---
 



jQuery(document).ready(function() {
            jQuery(".dropdown img.flag").addClass("flagvisibility");
 
            jQuery(".dropdown dt a").click(function() {
                jQuery(".dropdown dd ul").toggle();
            });
                        
            jQuery(".dropdown dd ul li a").click(function() {
                var text = jQuery(this).html();
                jQuery(".dropdown dt a span").html(text);
                jQuery(".dropdown dd ul").hide();
                jQuery("#result").html("Selected value is: " + getSelectedValue("status"));
            });
                        
            function getSelectedValue(id) {
                return jQuery("#" + id).find("dt a span.value").html();
            }
 
            jQuery(document).bind('click', function(e) {
                var jQueryclicked = jQuery(e.target);
                if (! jQueryclicked.parents().hasClass("dropdown"))
                    jQuery(".dropdown dd ul").hide();
            });
 
 
            jQuery("#flagSwitcher").click(function() {
                jQuery(".dropdown img.flag").toggleClass("flagvisibility");
            });
			 }); 
 
 
 
 
 
 function myFocus(element) {
     if (element.value == element.defaultValue) {
       element.value = '';
     }
   }
   function myBlur(element) {
     if (element.value == '') {
       element.value = element.defaultValue;
     }
   }


 
 
 // -------------------------------------------------------inline pop--------------------------------------------------

 
var popupStatus = 0;

function loadPopup(){
	if(popupStatus==0){
		jQuery("#popupBg").css({
			"opacity": "0.4"
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
 	jQuery(".popupLink").click(function(){
		centerPopup();
		loadPopup();
	});
	
	jQuery(".popupLink2").click(function(){
		centerPopup2();
		loadPopup2();
	});
	
	jQuery(".popupLink3").click(function(){
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
