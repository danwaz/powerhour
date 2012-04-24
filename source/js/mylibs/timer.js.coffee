#progress vars
numLeftCount = 60
numToGoCount = 0

#timer vars
startTime = 2
count = startTime
t = 0
currIndex = 0
isRandom = true
gamePlaying = false


$ ->
	console.log('hey guy')
	startBtn = $('#start')
	startBtn.on('click', startGame)

	models.player.observe models.EVENT.CHANGE, (e) ->
		console.log 'lets go!'
		if gamePlaying == true
			isPlaying = models.player.playing
			if isPlaying == true
				doInterval(isPlaying)
			else
				window.clearInterval t

startGame = () ->
	console.log gamePlaying
	if gamePlaying == false
		models.player.playing = false
		countdown = setTimeout ->
			gamePlaying = true
			models.player.playing = true
			nextTrack(window.playlist, currIndex, isRandom)
		, 3000
	else
		gamePlaying = false


toggleRandom = () ->
	if isRandom == false
		isRandom = true
		$('#random').html('Random On')
	else
		isRandom = false
		$('#random').html('Random Off')

doInterval = (playing)->
	window.clearInterval t
	t = window.setInterval ->
		if count > 1
			count--
		else
			count = startTime
			updateProgress()
			nextTrack(window.playlist, currIndex, isRandom)
	, 1000

updateProgress = ->
	numLeftCount--
	numToGoCount++
	currIndex++

nextTrack = (playlist, index, random) ->
	if random == true
		duration = Math.floor(Math.random() * (playlist[index].duration - startTime*1000))
		min = Math.floor(duration/60000)
		sec = Math.floor((duration%60000)/1000)
		models.player.playTrack(playlist[index].uri + "#" + min + ":"+ sec)
	else
		models.player.playTrack(playlist[index].uri)
