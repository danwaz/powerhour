#= require libs/jquery-1.7.1
#= require libs/bootstrap
#= require mylibs/sp
#= require mylibs/playlist
#= require mylibs/dnd
#= require mylibs/timer

$ ->
	console.log('app loaded')
	#scripts

	#dropdown buttons
	$('.dropdown-toggle').on 'click', ->
		parent = $(this).parent()
		$(parent).toggleClass('dropToggle')
		if $(parent).hasClass('dropToggle')
			$(parent).find('ul').slideDown('fast')
		else
			$(parent).find('ul').slideUp('fast')

	#close menu
	$('.dropdown-toggle').parent().find('a').on 'click', ->
		$(this).parents('ul').slideUp('fast')
		$('.btn-group').removeClass('dropToggle')


