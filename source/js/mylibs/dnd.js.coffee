models = sp.require("sp://import/scripts/api/models")
player = models.player

$ ->
	dropzone = $('#playlistDND')
	dropzone.on('dragenter', handleDragEnter)
	dropzone.on('dragleave', handleDragLeave)
	dropzone.on('dragover', handleDragOver)
	dropzone.on('drop', handleDrop)

handleDrop = (e) ->
	e.stopPropagation()  if e.stopPropagation
	playlist = e.originalEvent.dataTransfer.getData('text/html')
	$('#playlistDND span').remove()
	$('#currentPlaylist').html($(playlist).text())
	spURI = $(playlist).attr('href')
	tracks = loadPlaylist(spURI)
	exports.playlist = processPlaylist(tracks)
	albumArt = getAlbumArt(exports.playlist)

	#show play game controls
	#$('#countdown, #random, #start').css('display', 'block')
	#$('form').css('display', 'block')


handleDragEnter = (e) ->
	$('#playlistDND').addClass('dragOver')
	$('#playlistDND span').html('Drop her in!')
	false

handleDragLeave = (e) ->
	$('#playlistDND').removeClass('dragOver')
	$('#playlistDND span').html('Drag and drop a &nbsp;playlist here')
handleDragOver = (e) ->
	e.preventDefault() if e.preventDefault

loadPlaylist = (spURI)->
	playlist = sp.core.getPlaylist(spURI)

processPlaylist = (playlist) ->
	newPlaylist = []
	i = 0
	len =  playlist.length

	while i < len
		newPlaylist.push(playlist.getTrack(i))
		i++

	newPlaylist = fisherYates(newPlaylist)
	return newPlaylist

#random track
fisherYates = (arr) ->
	i = arr.length;
	if i == 0 then return false

	while --i
		j = Math.floor(Math.random() * (i+1))
		tempi = arr[i]
		tempj = arr[j]
		arr[i] = tempj
		arr[j] = tempi
	return arr

#sidebar drag and drop
models.application.observe models.EVENT.LINKSCHANGED, (e) ->
	e.stopPropagation()  if e.stopPropagation
	playlist = e.links
	tracks = loadPlaylist(playlist[0])
	$('#playlistDND span').html(tracks.name)
	exports.playlist = processPlaylist(tracks)
	albumArt = getAlbumArt(exports.playlist)

		#show play game controls
	$('#countdown, #random, #start').css('display', 'block')
	$('form').css('display', 'block')

#get album art for mosaic
getAlbumArt = (playlist) ->
	$('#playlistDND > div').each ->
		$(this).remove('div')
	albumArt = []
	console.log albumArt.length
	i = 0
	while albumArt.length < 9
		if albumArt.indexOf(playlist[i].album.cover) == -1
			console.log "not in the array"
			albumArt.push(playlist[i].album.cover)
		else
			console.log "totally in the array"
		i++
	timeDelay = 0;
	i = 0
	for cover in albumArt
		$('#playlistDND').append("<div id='mosaic" + i + "'><img src='" + cover + "'></div>")
		$('#mosaic' + i + ' img').delay(timeDelay).fadeIn("slow")
		timeDelay += 100
		i++



