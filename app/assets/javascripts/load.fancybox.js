var scTag = document.getElementsByTagName('script');
var jsDir = '';
var len = scTag.length;
for(var i = 0; i < len; i++){
	var s = scTag[i];
	if(s.src && s.src.indexOf('load.fancybox.js') != -1){
		jsDir = s.src.substring(0,s.src.indexOf('load.fancybox.js'));
		document.write('<!-- load fancybox -->');
		document.write('<script type="text/javascript" src="' + jsDir + 'fancybox/jquery.easing-1.3.pack.js" charset="UTF-8"></script>');
		document.write('<script type="text/javascript" src="' + jsDir + 'fancybox/jquery.mousewheel-3.0.4.pack.js" charset="UTF-8"></script>');
		document.write('<script type="text/javascript" src="' + jsDir + 'fancybox/jquery.fancybox-1.3.4.pack.js" charset="UTF-8"></script>');
		document.write('<link rel="stylesheet" type="text/css" href="' + jsDir + 'fancybox/jquery.fancybox-1.3.4.css" media="screen" />');
	}
}
