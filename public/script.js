$(document).ready(function(){
	$("#fulton_souls").bind("load", function(){ $(this).fadeTo( 2400, 0.3, function(){})});

	$('a').on('mouseenter', function(){
		$(this).css('text-decoration', 'underline')
		.css('color', 'red')
	})

	.on('mouseleave', function(){
		$(this).css('text-decoration', 'none')
		.css('color', 'white');
		}
	);


});