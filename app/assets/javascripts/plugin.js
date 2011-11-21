/* ------------------------------
 use load DD_belatedPNG_0.0.8a-min
------------------------------ */
new function(){
	var userAgent = window.navigator.userAgent.toLowerCase();
	var appVersion = window.navigator.appVersion.toLowerCase();
	
	if (userAgent.indexOf("msie") > -1) {
		if (appVersion.indexOf("msie 6.0") > -1) {
			$(window).load(function() {
				DD_belatedPNG.fix("img, .png_bg");
			});
		}
	}
}


/* ------------------------------
 fancybox
------------------------------ */

$(document).ready(function() {
	$("#gallery a").fancybox({
		'hideOnContentClick': true
	});
})


