var handleDragEnter, handleDragLeave, handleDragOver, handleDrop, powerhour;

powerhour = this;

$(function() {
  var dropzone;
  return dropzone = $('#playlistDND, #playlistDND span');
});

dropzone.on('dragenter', handleDragEnter);

dropzone.on('dragleave', handleDragLeave);

dropzone.on('dragover', handleDragOver);

dropzone.on('drop', handleDrop);

models.application.observe(models.EVENT.LINKSCHANGED, function(e) {
  var albumArt, playlist, tracks;
  if (e.stopPropagation) {
    e.stopPropagation();
  }
  playlist = e.links;
  tracks = powerhour.loadPlaylist(playlist[0]);
  $('#playlistDND').empty().css('line-height', 0);
  $('#playlistDND').html(tracks.name);
  window.playlist = powerhour.processPlaylist(tracks);
  return albumArt = powerhour.getAlbumArt(window.playlist);
});

handleDrop = function(e) {
  var albumArt, playlist, spURI, tracks;
  if (e.stopPropagation) {
    e.stopPropagation();
  }
  playlist = e.originalEvent.dataTransfer.getData('text/html');
  $('#playlistDND').empty().css('line-height', 0);
  $('#currentPlaylist').html($(playlist).text());
  $('#start').removeClass('inactive');
  spURI = $(playlist).attr('href');
  tracks = powerhour.loadPlaylist(spURI);
  window.playlist = powerhour.processPlaylist(tracks);
  return albumArt = powerhour.getAlbumArt(window.playlist);
};

handleDragEnter = function(e) {
  if (!document.getElementById('mosaic0')) {
    $('#playlistDND').addClass('dragOver');
    $('#playlistDND').html('Drop!');
    return false;
  }
};

handleDragLeave = function(e) {
  if (!document.getElementById('mosaic0')) {
    $('#playlistDND').removeClass('dragOver');
    return $('#playlistDND').html('Drag and drop a playlist here');
  }
};

handleDragOver = function(e) {
  if (e.preventDefault) {
    return e.preventDefault();
  }
};
