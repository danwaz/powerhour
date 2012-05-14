powerhour = this

powerhour.loadPlaylist = (spURI)->
	playlist = sp.core.getPlaylist(spURI)

powerhour.processPlaylist = (playlist) ->
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
powerhour.getAlbumArt = (playlist) ->
	$('#playlistDND > div').each ->
		$(this).remove('div')
	albumArt = []
	i = 0
	while albumArt.length < 9
		#check to see if we have any items left
		if playlist[i] == undefined
			break

		if albumArt.indexOf(playlist[i].album.cover) == -1 && playlist[i].album.cover != ""
			albumArt.push(playlist[i].album.cover)
		else
			i++
	setAlbumArt(albumArt)

setAlbumArt = (albumArt) ->
	timeDelay = 0;
	i = 0
	for cover in albumArt
		$('#playlistDND').append("<div id='mosaic" + i + "'><img src='" + cover + "'></div>")
		$('#mosaic' + i + ' img').delay(timeDelay).fadeIn("slow")
		timeDelay += 100
		i++