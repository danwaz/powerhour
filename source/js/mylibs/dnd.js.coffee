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
  exports.playlist = processPlaylist(tracks)

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

processPlaylist = (playlist) ->
  newPlaylist = []
  i = 0
  len =  playlist.length

  while i < len
    newPlaylist.push(playlist.getTrack(i))
    i++
  return newPlaylist