/* ------------------------------
 load javascript file
------------------------------ */
// load files
var LDJSF = [
	{'src': 'load.fancybox.js', 'charset': 'UTF-8'},
	{'src': 'swfobject/swfobject.js', 'charset': 'UTF-8'},
	{'src': 'plugin.js', 'charset': 'UTF-8'},
	{'src': 'jquery.cookie.js', 'charset': 'UTF-8'},
	{'src': 'jquery.config.js', 'charset': 'UTF-8'}
];

var scTag = document.getElementsByTagName('script');
var jsDir = '';
var len = scTag.length;
for(var i = 0; i < len; i++){
	var s = scTag[i];
	if(s.src && s.src.indexOf('common.js') != -1){
		jsDir = s.src.substring(0,s.src.indexOf('common.js'));
	}
}

len = LDJSF.length;
for(var i = 0; i < len; i++){
	document.write('<script type="text/javascript" src="' + jsDir + LDJSF[i].src + '" charset="' + LDJSF[i].charset + '"></script>');
}

// for IE6
var userAgent = window.navigator.userAgent.toLowerCase();
var appVersion = window.navigator.appVersion.toLowerCase();

if (userAgent.indexOf("msie") > -1) {
	if (appVersion.indexOf("msie 6.0") > -1) {
		document.write('<script type="text/javascript" src="' + jsDir + 'DD_belatedPNG_0.0.8a-min.js" charset="UTF-8"></script>');
		document.write('<script type="text/javascript" src="' + jsDir + 'minmax-1.0.js" charset="UTF-8"></script>');
	}
}


/**
 * rollOver on jQuery
 * rollOver tag:img,input
 * rollOver class:Over
 * rollOver FileName:*_o.*
 * Last modify:20081210
 * Licensed:MIT License
 * @author AkiraNISHIJIMA(http://nishiaki.probo.jp/)
 */


function rollOver(){
    var preLoad = new Object();
    $('img.Over,input.Over').not("[src*='_o.']").each(function(){
        var imgSrc = this.src;
        var fType = imgSrc.substring(imgSrc.lastIndexOf('.'));
        var imgName = imgSrc.substr(0, imgSrc.lastIndexOf('.'));
        var imgOver = imgName + '_o' + fType;
        preLoad[this.src] = new Image();
        preLoad[this.src].src = imgOver;
        $(this).hover(
            function (){
                this.src = imgOver;
            },
            function (){
                this.src = imgSrc;
            }
            );
    });
}


