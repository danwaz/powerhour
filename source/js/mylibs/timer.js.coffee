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
startTime = 10
count = startTime
isPlaying = player.playing
t = 0
currIndex = 0

doInterval = (playing)->
	window.clearInterval t
	t = window.setInterval ->
		if count > 1
			count--
			$(timer).html(count)
		else
			count = startTime
			updateProgress()
			nextTrack(exports.playlist, currIndex)
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
	currIndex++
	$(numLeft).html(numLeftCount)
	$(numToGo).html(numToGoCount)

nextTrack = (playlist, index) ->
	duration = Math.floor(Math.random() * (playlist[index].duration - 60000))
	min = Math.floor(duration/60000)
	sec = Math.floor((duration%60000)/1000)
	console.log "min: " + min
	console.log "sec: " + sec

	player.playTrack(playlist[index].uri + "#" + min + ":"+ sec)
