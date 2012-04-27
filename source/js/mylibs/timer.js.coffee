#progress vars
totalSongs = 60
numLeftCount = totalSongs
numToGoCount = 0

#timer vars
startTime = 60
count = startTime
t = 0
currIndex = 0
isRandom = true
gamePlaying = false


$ ->
	console.log('hey guy')
	startBtn = $('#start')
	startBtn.on('click', startGame)
	$('#random > li > a').on('click', selectRandom)
	$('#numSongs > li > a').on('click', selectSongs)
	$('#interval > li > a').on('click', selectInterval)

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


selectRandom = () ->
	val = $(this).text()
	$(this).parents('.btn-group').find('.btn-text').text(val)

	if val == "On"
		isRandom = true
	else
		isRandom = false

selectSongs = () ->
	val = $(this).text()
	val = parseInt(val)
	$(this).parents('.btn-group').find('.btn-text').text(val)

	totalSongs = val
	numLeftCount = totalSongs



selectInterval = () ->
	val = $(this).text()
	val = parseInt(val)
	$(this).parents('.btn-group').find('.btn-text').text(val + 's')

	startTime = val
	count = startTime

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
