powerhour = this

$ ->
	dropzone = $('#playlistDND, #playlistDND span')
	dropzone.on('dragenter', handleDragEnter)
	dropzone.on('dragleave', handleDragLeave)
	dropzone.on('dragover', handleDragOver)
	dropzone.on('drop', handleDrop)

	models.application.observe models.EVENT.LINKSCHANGED, (e) ->
		e.stopPropagation()  if e.stopPropagation
		playlist = e.links
		tracks = powerhour.loadPlaylist(playlist[0])
		$('#playlistDND').empty().css('line-height', 0)
		$('#playlistDND').html(tracks.name)
		window.playlist = powerhour.processPlaylist(tracks)
		albumArt = powerhour.getAlbumArt(window.playlist)

handleDrop = (e) ->
	e.stopPropagation()  if e.stopPropagation
	playlist = e.originalEvent.dataTransfer.getData('text/html')
	$('#playlistDND').empty().css('line-height', 0)
	$('#currentPlaylist').html($(playlist).text())
	$('#start').removeClass('inactive')
	spURI = $(playlist).attr('href')
	tracks = powerhour.loadPlaylist(spURI)
	window.playlist = powerhour.processPlaylist(tracks)
	albumArt = powerhour.getAlbumArt(window.playlist)

handleDragEnter = (e) ->
	unless document.getElementById('mosaic0')
		$('#playlistDND').addClass('dragOver')
		$('#playlistDND').html('Drop!')
		false

handleDragLeave = (e) ->
	unless document.getElementById('mosaic0')
		$('#playlistDND').removeClass('dragOver')
		$('#playlistDND').html('Drag and drop a playlist here')
handleDragOver = (e) ->
	e.preventDefault() if e.preventDefault
