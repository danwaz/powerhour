var fisherYates, powerhour, setAlbumArt;

powerhour = this;

powerhour.loadPlaylist = function(spURI) {
  var playlist;
  return playlist = sp.core.getPlaylist(spURI);
};

powerhour.processPlaylist = function(playlist) {
  var i, len, newPlaylist;
  newPlaylist = [];
  i = 0;
  len = playlist.length;
  while (i < len) {
    newPlaylist.push(playlist.getTrack(i));
    i++;
  }
  newPlaylist = fisherYates(newPlaylist);
  return newPlaylist;
};

fisherYates = function(arr) {
  var i, j, tempi, tempj;
  i = arr.length;
  if (i === 0) {
    return false;
  }
  while (--i) {
    j = Math.floor(Math.random() * (i + 1));
    tempi = arr[i];
    tempj = arr[j];
    arr[i] = tempj;
    arr[j] = tempi;
  }
  return arr;
};

powerhour.getAlbumArt = function(playlist) {
  var albumArt, i;
  $('#playlistDND > div').each(function() {
    return $(this).remove('div');
  });
  albumArt = [];
  i = 0;
  while (albumArt.length < 9) {
    if (playlist[i] === void 0) {
      break;
    }
    if (albumArt.indexOf(playlist[i].album.cover) === -1 && playlist[i].album.cover !== "") {
      albumArt.push(playlist[i].album.cover);
    } else {
      i++;
    }
  }
  return setAlbumArt(albumArt);
};

setAlbumArt = function(albumArt) {
  var cover, i, timeDelay, _i, _len, _results;
  timeDelay = 0;
  i = 0;
  _results = [];
  for (_i = 0, _len = albumArt.length; _i < _len; _i++) {
    cover = albumArt[_i];
    $('#playlistDND').append("<div id='mosaic" + i + "'><img src='" + cover + "'></div>");
    $('#mosaic' + i + ' img').delay(timeDelay).fadeIn("slow");
    timeDelay += 100;
    _results.push(i++);
  }
  return _results;
};
