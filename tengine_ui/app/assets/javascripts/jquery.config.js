// jQuery Config
$(window).load(function(){
	rollOver();

	// add class
	$('li:first-child').addClass('First');
	$('li:last-child').addClass('Last');
	
	//$('.Section img:last-child').addClass('Last');
	$('#main h2:first-child').addClass('First');
	$('#main h3:first-child').addClass('First');
	$('#main').find('blockquote').wrapInner("<div></div>");
	
	var YamlID = '';
	$('#main').find('td').find('.YamlView').each(function(){
		$(this).find('.YamlScript').append('<a class="Close">close</a>');
		$(this).find('.IconYaml').click(function(){
			if( YamlID !='' && YamlID != $(this).parent().attr('ID') ){
				//表示中のYAMLを非表示
				$('#'+YamlID).find('.YamlScript').hide();
			}
			YamlID = $(this).parent().attr('ID'); //表示YAMLをメモ
			var elm = $(this).parent().find('.YamlScript');
			elm.toggle();
		});
		$(this).find('.YamlScript').find('.Close').click(function(){
			$(this).parent().toggle();
		});
	});
});


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
