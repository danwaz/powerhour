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
timer = null

$ ->
	console.log('hey guy')
	startBtn = $('#start')
	startBtn.on('click', startGame)
	$('#random > li > a').on('click', selectRandom)
	$('#numSongs > li > a').on('click', selectSongs)
	$('#interval > li > a').on('click', selectInterval)

	models.player.observe models.EVENT.CHANGE, (e) ->
		updatePageWithTrackDetails() if e.data.curtrack is true

updatePageWithTrackDetails = () ->
	playerTrackInfo = models.player.track
	track = playerTrackInfo.data
	$("#albumArt img").attr("src", models.player.track.album.data.cover)
	$('#track').html track.name
	$('#artist').html("by " + track.album.artist.name)

startGame = () ->
	if !$('#start').hasClass('inactive')
		models.player.playing = false
		$('#playlistDND, #playlist, #currentPlaylist, #settings').fadeOut(300)
		$('#trackInfo, #timer').delay(500).fadeIn(500)
		countdown = setTimeout ->
			gamePlaying = true
			models.player.playing = true
			nextTrack(window.playlist, currIndex, isRandom)
			createCanvas()
		, 1000
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

createCanvas = () ->
	canvas = $('#timer-canvas')
	if canvas[0].getContext
		ctx = canvas[0].getContext('2d')
		start = (3 * Math.PI) / 2
		center = 200
		radius = 117
		degrees = 359
		seconds = count
		total = 359
		countdown = count
		timestamp = new Date().getTime()
		$('#minLeft').html(numLeftCount + " songs left")

		timer = window.setInterval ->
			if degrees >= 0
				draw(ctx, start, center, radius, degrees, total)
				degrees -= (360/seconds)/24
				total -= (360/(seconds*totalSongs))/24
				countdown =  Math.ceil(count - Math.abs((timestamp/1000) - (new Date().getTime()/1000)))
				if countdown < 10
					$('#countdown').html('<span>0</span>' + countdown)
				else
					$('#countdown').html(countdown)
			else
				degrees = 359;
				countdown = count
				timestamp = new Date().getTime()
				updateProgress()
				$('#minLeft').html(numLeftCount + " songs left")
				nextTrack(window.playlist, currIndex, isRandom)
		,40


draw = (ctx, start, center, radius, degrees, total) ->
	#pie circle
	ctx.clearRect(0,0,400, 400)

	ctx.strokeStyle = "#54fffe"
	ctx.fillStyle = "#3d6868"
	ctx.beginPath()
	ctx.arc(center,center, radius, 0, 360, false)
	ctx.closePath()
	ctx.fill()

	ctx.fillStyle = "#479d9c"
	ctx.beginPath()
	ctx.arc(center, center, radius, start, start - (Math.PI/180) * degrees, false)
	ctx.lineTo(center, center)
	ctx.closePath()
	ctx.fill()

	ctx.beginPath()
	ctx.lineWidth = 40
	ctx.arc(center, center, radius+35, start, start - (Math.PI/180) * total, false)
	ctx.stroke()
