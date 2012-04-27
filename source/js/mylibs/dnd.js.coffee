$ ->
	dropzone = $('#playlistDND')
	dropzone.on('dragenter', handleDragEnter)
	dropzone.on('dragleave', handleDragLeave)
	dropzone.on('dragover', handleDragOver)
	dropzone.on('drop', handleDrop)

	models.application.observe models.EVENT.LINKSCHANGED, (e) ->
		e.stopPropagation()  if e.stopPropagation
		playlist = e.links
		tracks = loadPlaylist(playlist[0])
		$('#playlistDND span').remove()
		$('#playlistDND span').html(tracks.name)
		window.playlist = processPlaylist(tracks)
		albumArt = getAlbumArt(window.playlist)

handleDrop = (e) ->
	e.stopPropagation()  if e.stopPropagation
	playlist = e.originalEvent.dataTransfer.getData('text/html')
	$('#playlistDND span').remove()
	$('#currentPlaylist').html($(playlist).text())
	spURI = $(playlist).attr('href')
	tracks = loadPlaylist(spURI)
	window.playlist = processPlaylist(tracks)
	albumArt = getAlbumArt(window.playlist)

handleDragEnter = (e) ->
	$('#playlistDND').addClass('dragOver')
	$('#playlistDND span').html('Drop!')
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

#get album art for mosaic
getAlbumArt = (playlist) ->
	$('#playlistDND > div').each ->
		$(this).remove('div')
	albumArt = []
	console.log albumArt
	i = 0
	while albumArt.length < 9
		#check to see if we have any items left
		if playlist[i] == undefined
			break

		if albumArt.indexOf(playlist[i].album.cover) == -1 && playlist[i].album.cover != ""
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



