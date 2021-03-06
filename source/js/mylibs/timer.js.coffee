

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
paused = null
isPaused = false

$ ->
	startBtn = $('#start')
	startBtn.on('click', startGame)
	$('#random > li > a').on('click', selectRandom)
	$('#numSongs > li > a').on('click', selectSongs)
	$('#interval > li > a').on('click', selectInterval)

	models.player.observe models.EVENT.CHANGE, (e) ->
		updatePageWithTrackDetails() if e.data.curtrack is true
		if models.player.playing == false
			isPaused = true
		else
			isPaused = false

updatePageWithTrackDetails = () ->
	albumCrossfade()
	playerTrackInfo = models.player.track
	track = playerTrackInfo.data
	$('#track').html track.name
	$('#artist').html("by " + track.album.artist.name)
	updatePlayQueue()

setAlbumArt = () ->
	playlist = window.playlist
	index = currIndex
	ids = $('.albumArt')
	for album in ids
		if $(album).hasClass('playing')
			$(album).find('img').attr('src', playlist[index].album.cover)
		else
			$(album).find('img').attr('src', playlist[index-1].album.cover)

albumCrossfade = () ->
	ids = $('.albumArt')
	for album in ids
		if $(album).hasClass('playing')
			$(album).fadeOut('slow')
			$(album).removeClass('playing')
		else
			$(album).fadeIn('slow')
			$(album).addClass('playing')
	setAlbumArt()





updatePlayQueue = () ->
	playlist = window.playlist
	index = currIndex
	i = 1
	$('.nextQueue').remove()
	while (i <= 10)
		trackNum = "<div class='nextNum'>" + i + ":&nbsp;</div>"
		trackName =  "<div class='nextTrack'>" + playlist[index+i].name + "</div>"
		artist = "<div class='nextArtist'>&nbsp;by&nbsp;" + playlist[index+i].artists[0].name + "</div>"
		$('#queue').append("<div class='nextQueue'>" + trackNum + trackName + artist + "</div>")
		i++


startGame = () ->
	if !$('#start').hasClass('inactive')
		models.player.playing = false
		$('#playlistDND, #playlist, #currentPlaylist, #settings').fadeOut(300)
		$('#trackInfo, #timer-container').delay(500).fadeIn(500)
		$('#queue').slideDown(500)
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

updateProgress = () ->
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
		center = 175
		radius = 117
		degrees = 359
		seconds = count
		total = 359
		countdown = count
		timestamp = new Date().getTime()
		$('#minLeft').html(numLeftCount + " songs left")
		cdOffset = 0;

		timer = window.setInterval ->
			if degrees >= 0
				if countdown < 10
					$('#countdown').html('<span>0</span>' + countdown)
				else
					$('#countdown').html(countdown)
				if isPaused == true
					paused = window.setInterval ->
						if isPaused == true
							console.log "we are paused"
						else
							window.clearInterval(paused)
							cdOffset = Math.abs((timestamp/1000) - (new Date().getTime()/1000))
					, 40
				else
					draw(ctx, start, center, radius, degrees, total)
					degrees -= (360/seconds)/24
					total -= (360/(seconds*totalSongs))/24
					countdown =  Math.ceil(count - Math.abs((timestamp/1000) - (new Date().getTime()/1000))) + cdOffset
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
	ctx.lineWidth = 37
	ctx.arc(center, center, radius+30, start, start - (Math.PI/180) * total, false)
	ctx.stroke()
