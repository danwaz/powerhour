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
startTime = 5
count = startTime
isPlaying = player.playing
t = 0

doInterval = (playing)->
	window.clearTimeout t
	$(timer).html(count)
	playing = player.playing
	t = window.setTimeout ->
		if playing == true
			if count > 1
				count--
				doInterval(playing)
			else
				count = startTime
				player.next()
				player.playing = false
				seek = window.setTimeout ->
					player.playing = true
					console.log player.track.duration
					player.position = 10000
				, 100
				updateProgress()
		else
			window.clearTimeout t
	, 1000

player.observe models.EVENT.CHANGE, (e) ->
	isPlaying = player.playing
	console.log "change"
	if isPlaying == true
		doInterval(isPlaying)
	else
		window.clearTimeout t

updateProgress = ->
	numLeftCount--
	numToGoCount++
	$(numLeft).html(numLeftCount)
	$(numToGo).html(numToGoCount)

