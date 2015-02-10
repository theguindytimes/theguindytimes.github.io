// define('init', ['jquery','waypoint','fitText','pjax','typeahead'],function ($) {

/*-----------------------------------------------------------------------------------
/*
/* Init JS
/*
-----------------------------------------------------------------------------------*/
function getUrlVar(key){
	var result = new RegExp(key + "=([^&]*)", "i").exec(window.location.search);
	return result && unescape(result[1]) || "";
}

a = getUrlVar('article');

if (a != ''){
	var id = a;
	var url='/articles/'+id;
	$.get(url).done(function(data,status){
			$('#article_ajax').html(data);
			return true;  
			});
	window.location.href = "#article_ajax";
}

function tagged(){
	a = getUrlVar('tag');
	if(a!='' || window.location.href.indexOf('tags')!=-1){
		window.location.href="#filteredArticles"
	}

	$('#articletrend').on('click', '.img_load a', function(event) {
			//alert('hey');
			var id = this;
			var url='/articles/'+id;
			$.get(url).done(function(data,status){
				$('#article_ajax').html(data);
				return true;  
				});
			window.location.href = "#article_ajax";
			});
}

$(document).on("page:load",tagged());

jQuery(document).ready(function($) {

		tagged(); 

		window.fbAsyncInit = function() {
		FB.init({
appId      : '1446095362314014',
xfbml      : true,
version    : 'v2.0'
});
		};

		(function(d, s, id){
		 var js, fjs = d.getElementsByTagName(s)[0];
		 if (d.getElementById(id)) {return;}
		 js = d.createElement(s); js.id = id;
		 js.src = "//connect.facebook.net/en_US/sdk.js";
		 fjs.parentNode.insertBefore(js, fjs);
		 }(document, 'script', 'facebook-jssdk'));

		$(document).on('pjax:success', function() {
			// alert(data);
			});

$('#article_search').typeahead({
name: "article",
remote: "/autocomplete?query=%QUERY"
});

$("#search_article").submit(function(e)
		{
		var postData = $(this).serializeArray();
		var url = $(this).attr("action")+'/?name='+$('#article_search').val();
		$.get(url).done(function(data,status){
			// alert(data);
			$('#articles .hs').html(data);
			});
		e.preventDefault(); //STOP default action
		// e.unbind(); //unbind. to stop multiple form submit.
		});

$('#article_ajax').on('click', '.comment-approve', function(event) {
		// alert(this);
		var url=this;
		$.get(url).done(function(data,status){
			// alert(data);
			$('#article_ajax .comment-info').html(data);
			});
		return false;
		});

$('#article_ajax').on('click', 'h2 span a', function(event) {
		// alert(this);
		var url=this;
		$.get(url).done(function(data,status){
			// alert(data);
			$('#articles .hs').html(data);
			});
		window.location.href = "#close";
		window.location.href = "#articles";
		return false;
		});

$('#article_ajax').on('click', '.comment-disapprove', function(event) {
		// alert(this);
		var url=this;
		$.get(url).done(function(data,status){
			// alert(data);
			$('#article_ajax .comment-info').html(data);
			});
		return false;
		});

// $('#article_ajax').on('click', '.comment-approve', function(event) {
//   alert(this);
//   return false;
// });

$('#calendar').on('click', '.events a', function(event) {
		var parse=String(this).split('/');
		var id=parse[parse.length-1];
		url=this;
		$.get(url).done(function(data,status){
			$('.event-description').html('');
			$('#event-'+id).html(data);
			});
		return false;
		});

$(document).on('click', '#comment-form input', function(event) {
		form = $(this).closest("form");
		var url = form.attr('action');
		var data = form.serialize();
		$.ajax({
type: "POST",
url: url,
data: data,
success: function(data){
$('#article_ajax .comments').html(data);
}
});
		return false;
		});

$(document).on('click', 'a[data-pjax]', function(event) {
		if ($.support.pjax) {
		var container = $(this).attr('data-pjax');
		// alert(container);
		// $(document).scrollTo('#articles');
		//$('header #nav').find("a[href='#articles']").click();
		$.pjax.click(event, {container: container});
		}
		else{
		url=this;
		$.get(url).done(function(data,status){
			// alert(data);
			$('#articles .hs').html(data);
			});
		}
		tagged();
		});

// $('#articletrend').on('click','.new a',function(){
//   alert(this);
//   url=this;
//   $.get(url).done(function(data,status){
//     // alert(data);
//     $('#articles .hs').html(data);
//   });
//   return false;
// });

$.pjax.defaults.scrollTo = false;

page_change = $('#articles').on('click', '.pagination a', function(event) {
		if ($.support.pjax) {
		var container = $('#articles .hs');
		// alert(container);
		$.pjax.click(event, {container: container});
		$(document).scrollTo('#articles');
		}
		else{
		url=this;
		$.get(url).done(function(data,status){
			// alert(data);
			$('#articles .hs').html(data);
			});
		}
		});

/*----------------------------------------------------*/
/* FitText Settings
   ------------------------------------------------------ */

setTimeout(function() {
		$('h1.responsive-headline').fitText(1, { minFontSize: '40px', maxFontSize: '90px' });
		}, 100);


/*----------------------------------------------------*/
/* Smooth Scrolling
   ------------------------------------------------------ */

$('.smoothscroll').on('click',function (e) {
		e.preventDefault();

		var target = this.hash,
		$target = $(target);

		$('html, body').stop().animate({
			'scrollTop': $target.offset().top
			}, 800, 'swing', function () {
			window.location.hash = target;
			});
		});


/*----------------------------------------------------*/
/* Highlight the current section in the navigation bar
   ------------------------------------------------------*/

var sections = $("section");
var navigation_links = $("#nav-wrap a");

sections.waypoint({

handler: function(event, direction) {

var active_section;

active_section = $(this);
if (direction === "up") active_section = active_section.prev();

var active_link = $('#nav-wrap a[href="#' + active_section.attr("id") + '"]');

navigation_links.parent().removeClass("current");
active_link.parent().addClass("current");

},
offset: '35%'

});


/*----------------------------------------------------*/
/*	Make sure that #header-background-image height is
/* equal to the browser height.
------------------------------------------------------ */

$('header').css({ 'height': $(window).height() });
$(window).on('resize', function() {

		$('header').css({ 'height': $(window).height() });
		$('body').css({ 'width': $(window).width() })
		});


/*----------------------------------------------------*/
/*	Fade In/Out Primary Navigation
	------------------------------------------------------*/

$(window).on('scroll', function() {

		var h = $('header').height();
		var y = $(window).scrollTop();
		var nav = $('#nav-wrap');

		if ( (y > h*.20) && (y < h) && ($(window).outerWidth() > 768 ) ) {
		nav.fadeOut('fast');
		}
		else {
		if (y < h*.20) {
		nav.removeClass('opaque').fadeIn('fast');
		}
		else {
		nav.addClass('opaque').fadeIn('fast');
		}
		}

		});


/*----------------------------------------------------*/
/*	Modal Popup
	------------------------------------------------------*/

$('.item-wrap a').magnificPopup({

type:'inline',
fixedContentPos: false,
removalDelay: 200,
showCloseBtn: false,
mainClass: 'mfp-fade'

});

$(document).on('click', '.popup-modal-dismiss', function (e) {
		e.preventDefault();
		$.magnificPopup.close();
		});


/*----------------------------------------------------*/
/*	Flexslider
/*----------------------------------------------------*/
$('.flexslider').flexslider({
namespace: "flex-",
controlsContainer: ".flex-container",
animation: 'slide',
controlNav: true,
directionNav: false,
smoothHeight: true,
slideshowSpeed: 7000,
animationSpeed: 600,
randomize: false,
});

/*----------------------------------------------------*/
/*	contact form
	------------------------------------------------------*/

$('form#contactForm button.submit').click(function() {

		$('#image-loader').fadeIn();

		var contactName = $('#contactForm #contactName').val();
		var contactEmail = $('#contactForm #contactEmail').val();
		var contactSubject = $('#contactForm #contactSubject').val();
		var contactMessage = $('#contactForm #contactMessage').val();

		var data = 'contactName=' + contactName + '&contactEmail=' + contactEmail +
		'&contactSubject=' + contactSubject + '&contactMessage=' + contactMessage;

		$.ajax({

type: "POST",
url: "inc/sendEmail.php",
data: data,
success: function(msg) {

// Message was sent
if (msg == 'OK') {
$('#image-loader').fadeOut();
$('#message-warning').hide();
$('#contactForm').fadeOut();
$('#message-success').fadeIn();   
}
// There was an error
else {
$('#image-loader').fadeOut();
$('#message-warning').html(msg);
$('#message-warning').fadeIn();
}

}

});
return false;
});


});


// });





