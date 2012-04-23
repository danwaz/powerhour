#declare player
sp = getSpotifyApi(1)
models = sp.require("sp://import/scripts/api/models")
player = models.player

#selectors
$ ->
	console.log('hey guy')
	startBtn = $('#start')
	startBtn.on('click', startGame)

#progress vars
numLeftCount = 60
numToGoCount = 0

#timer vars
startTime = 60
count = startTime
isPlaying = player.playing
t = 0
currIndex = 0
isRandom = false
gamePlaying = false

startGame = () ->
	if gamePlaying == false
		player.playing = false
		countdown = setTimeout ->
			gamePlaying = true
			player.playing = true
			nextTrack(window.playlist, currIndex, isRandom)
		, 3000
	else
		gamePlaying = false
	console.log gamePlaying


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

player.observe models.EVENT.CHANGE, (e) ->
	console.log 'lets go!'
	if gamePlaying == true
		isPlaying = player.playing
		if isPlaying == true
			doInterval(isPlaying)
		else
			window.clearInterval t

updateProgress = ->
	numLeftCount--
	numToGoCount++
	currIndex++

nextTrack = (playlist, index, random) ->
	if random == true
		duration = Math.floor(Math.random() * (playlist[index].duration - startTime*1000))
		console.log startTime*1000
		min = Math.floor(duration/60000)
		sec = Math.floor((duration%60000)/1000)
		player.playTrack(playlist[index].uri + "#" + min + ":"+ sec)
	else
		player.playTrack(playlist[index].uri)
