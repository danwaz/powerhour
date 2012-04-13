#declare player
models = sp.require("sp://import/scripts/api/models")
player = models.player

#selectors
timer = $('#timer h2')
numLeft = $('#numLeft h2')
numToGo = $('#numToGo h2')
startBtn = $('#start')
randBtn = $('#random')

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
currIndex = 0
isRandom = false
gamePlaying = false

startGame = () ->
	if gamePlaying == false
		player.playing = false
		countDown()
		updateStartTime()
		countdown = setTimeout ->
			gamePlaying = true
			player.playing = true
			nextTrack(exports.playlist, currIndex, isRandom)
		, 3000
	else
		gamePlaying = false
	console.log gamePlaying

updateStartTime = () ->
	startTime = count = $('#duration').attr('value')

countDown = () ->
	cdTime = 3
	$('#countdown').html(cdTime)
	cd = window.setInterval ->
		if cdTime > 1
			cdTime--
			$('#countdown').html(cdTime)
		else
			$('#countdown').html('Drink!')
			window.clearInterval(cd)
	, 1000

toggleRandom = () ->
	if isRandom == false
		isRandom = true
	else
		isRandom = false
	console.log isRandom


doInterval = (playing)->
	window.clearInterval t
	t = window.setInterval ->
		if count > 1
			count--
			$(timer).html(count)
		else
			count = startTime
			updateProgress()
			nextTrack(exports.playlist, currIndex, isRandom)
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
	$(numLeft).html(numLeftCount)
	$(numToGo).html(numToGoCount)

nextTrack = (playlist, index, random) ->
	if random == true
		duration = Math.floor(Math.random() * (playlist[index].duration - startTime*1000))
		console.log startTime*1000
		min = Math.floor(duration/60000)
		sec = Math.floor((duration%60000)/1000)
		player.playTrack(playlist[index].uri + "#" + min + ":"+ sec)
	else
		player.playTrack(playlist[index].uri)

startBtn.on('click', startGame)
randBtn.on('click', toggleRandom)
