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
  $(this).text($(playlist).text())
  spURI = $(playlist).attr('href')
  tracks = loadPlaylist(spURI)
  playRandom(tracks)

handleDragEnter = (e) ->
  #change class
  console.log 'enter'
  false

handleDragLeave = (e) ->
  #change class

handleDragOver = (e) ->
  e.preventDefault() if e.preventDefault

loadPlaylist = (spURI)->
  playlist = sp.core.getPlaylist(spURI)

playRandom = (tracks) ->
  numTracks = tracks.length
  randIndex = Math.floor(Math.random()*numTracks)
  trackURI = tracks.getTrack(randIndex).uri
  player.playTrack(trackURI)
  duration = player.track.duration - 60000
  randStart = Math.floor(Math.random()*duration)
  min = Math.floor(duration/60000)
  sec = Math.floor(((duration/60000)%min)*60)
  player.playTrack trackURI + "#" + min.toString() + ":" + sec.toString()

