#declare player
models = sp.require("sp://import/scripts/api/models")
player = models.player

#selectors
timer = $('#timer h1')
numLeft = $('#numLeft h1')
numToGo = $('#numToGo h1')

#progress vars
numLeftCount = 60
numToGoCount = 0
$(numLeft).html(numLeftCount)
$(numToGo).html(numToGoCount)

#timer vars
startTime = 60
count = startTime
isPlaying = player.playing
t = 0

doInterval = (playing)->
	window.clearInterval t
	t = window.setInterval ->
		if count > 1
			count--
			$(timer).html(count)
		else
			count = startTime
			#player.next()
			#seek = window.setInterval ->
			#, 100
			updateProgress()
	, 1000

player.observe models.EVENT.CHANGE, (e) ->
	isPlaying = player.playing
	if isPlaying == true
		doInterval(isPlaying)
	else
		window.clearInterval t

updateProgress = ->
	numLeftCount--
	numToGoCount++
	$(numLeft).html(numLeftCount)
	$(numToGo).html(numToGoCount)

