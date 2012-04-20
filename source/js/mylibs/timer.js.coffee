#declare player
sp = getSpotifyApi(1)
models = sp.require("sp://import/scripts/api/models")
player = models.player

#selectors
timer2 = $('#timer2 h2')
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
			nextTrack(window.playlist, currIndex, isRandom)
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
		$('#random').html('Random On')
	else
		isRandom = false
		$('#random').html('Random Off')


doInterval = (playing)->
	window.clearInterval t
	t = window.setInterval ->
		if count > 1
			count--
			$(timer2).html(count)
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

#imported timer
# drawTimer = (percent) ->
# 	$("div.timer").html "<div class=\"percent\"></div><div id=\"slice\"" + (if percent > 50 then " class=\"gt50\"" else "") + "><div class=\"pie\"></div>" + (if percent > 50 then "<div class=\"pie fill\"></div>" else "") + "</div>"
# 	deg = 360 / 100 * percent
# 	$("#slice .pie").css
# 	"-moz-transform": "rotate(" + deg + "deg)"
# 	"-webkit-transform": "rotate(" + deg + "deg)"
# 	"-o-transform": "rotate(" + deg + "deg)"
# 	transform: "rotate(" + deg + "deg)"

# 	$(".percent").html Math.round(percent) + "%"

# stopWatch = ->
# 	seconds = (timerFinish - (new Date().getTime())) / 1000
# 	if seconds <= 0
# 		drawTimer 100
# 		window.clearInterval timer
# 		$("input[type=button]#watch").val "Start"
# 		alert "Finished counting down from " + timerSeconds
# 	else
# 		percent = 100 - ((seconds / timerSeconds) * 100)
# 		drawTimer percent

# timer = undefined
# timerCurrent = undefined
# timerFinish = undefined
# timerSeconds = undefined

# startCounterThing = () ->
# 	$("input[type=button]#percent").click (e) ->
# 		e.preventDefault()
# 		drawTimer $("input[type=text]#percent").val()

# 	$("input[type=button]#size").click (e) ->
# 		e.preventDefault()
# 		$(".timer").css "font-size", $("input[type=text]#size").val() + "px"

# 	$("input[type=button]#watch").click (e) ->
# 		e.preventDefault()
# 		if $("input[type=button]#watch").val() is "Start"
# 			$("input[type=button]#watch").val "Stop"
# 			timerSeconds = $("input[type=text]#watch").val()
# 			timerCurrent = 0
# 			timerFinish = new Date().getTime() + (timerSeconds * 1000)
# 			timer = window.setInterval ->
# 				stopWatch()
# 			, 50
# 		else
# 			$("input[type=button]#watch").val "Start"
# 			window.clearInterval timer

# 	$("input[type=button]#watch").click()
