var albumCrossfade, count, createCanvas, currIndex, draw, gamePlaying, isPaused, isRandom, nextTrack, numLeftCount, numToGoCount, paused, selectInterval, selectRandom, selectSongs, setAlbumArt, startGame, startTime, t, timer, totalSongs, updatePageWithTrackDetails, updatePlayQueue, updateProgress;

totalSongs = 60;

numLeftCount = totalSongs;

numToGoCount = 0;

startTime = 60;

count = startTime;

t = 0;

currIndex = 0;

isRandom = true;

gamePlaying = false;

timer = null;

paused = null;

isPaused = false;

$(function() {
  var startBtn;
  return startBtn = $('#start');
});

startBtn.on('click', startGame);

$('#random > li > a').on('click', selectRandom);

$('#numSongs > li > a').on('click', selectSongs);

$('#interval > li > a').on('click', selectInterval);

models.player.observe(models.EVENT.CHANGE, function(e) {
  if (e.data.curtrack === true) {
    updatePageWithTrackDetails();
  }
  if (models.player.playing === false) {
    return isPaused = true;
  } else {
    return isPaused = false;
  }
});

updatePageWithTrackDetails = function() {
  var playerTrackInfo, track;
  albumCrossfade();
  playerTrackInfo = models.player.track;
  track = playerTrackInfo.data;
  $('#track').html(track.name);
  $('#artist').html("by " + track.album.artist.name);
  return updatePlayQueue();
};

setAlbumArt = function() {
  var album, ids, index, playlist, _i, _len, _results;
  playlist = window.playlist;
  index = currIndex;
  ids = $('.albumArt');
  _results = [];
  for (_i = 0, _len = ids.length; _i < _len; _i++) {
    album = ids[_i];
    if ($(album).hasClass('playing')) {
      _results.push($(album).find('img').attr('src', playlist[index].album.cover));
    } else {
      _results.push($(album).find('img').attr('src', playlist[index - 1].album.cover));
    }
  }
  return _results;
};

albumCrossfade = function() {
  var album, ids, _i, _len;
  ids = $('.albumArt');
  for (_i = 0, _len = ids.length; _i < _len; _i++) {
    album = ids[_i];
    if ($(album).hasClass('playing')) {
      $(album).fadeOut('slow');
      $(album).removeClass('playing');
    } else {
      $(album).fadeIn('slow');
      $(album).addClass('playing');
    }
  }
  return setAlbumArt();
};

updatePlayQueue = function() {
  var artist, i, index, playlist, trackName, trackNum, _results;
  playlist = window.playlist;
  index = currIndex;
  i = 1;
  $('.nextQueue').remove();
  _results = [];
  while (i <= 10) {
    trackNum = "<div class='nextNum'>" + i + ":&nbsp;</div>";
    trackName = "<div class='nextTrack'>" + playlist[index + i].name + "</div>";
    artist = "<div class='nextArtist'>&nbsp;by&nbsp;" + playlist[index + i].artists[0].name + "</div>";
    $('#queue').append("<div class='nextQueue'>" + trackNum + trackName + artist + "</div>");
    _results.push(i++);
  }
  return _results;
};

startGame = function() {
  var countdown;
  if (!$('#start').hasClass('inactive')) {
    models.player.playing = false;
    $('#playlistDND, #playlist, #currentPlaylist, #settings').fadeOut(300);
    $('#trackInfo, #timer-container').delay(500).fadeIn(500);
    $('#queue').slideDown(500);
    return countdown = setTimeout(function() {
      gamePlaying = true;
      models.player.playing = true;
      nextTrack(window.playlist, currIndex, isRandom);
      return createCanvas();
    }, 1000);
  } else {
    return gamePlaying = false;
  }
};

selectRandom = function() {
  var val;
  val = $(this).text();
  $(this).parents('.btn-group').find('.btn-text').text(val);
  if (val === "On") {
    return isRandom = true;
  } else {
    return isRandom = false;
  }
};

selectSongs = function() {
  var val;
  val = $(this).text();
  val = parseInt(val);
  $(this).parents('.btn-group').find('.btn-text').text(val);
  totalSongs = val;
  return numLeftCount = totalSongs;
};

selectInterval = function() {
  var val;
  val = $(this).text();
  val = parseInt(val);
  $(this).parents('.btn-group').find('.btn-text').text(val + 's');
  startTime = val;
  return count = startTime;
};

updateProgress = function() {
  numLeftCount--;
  numToGoCount++;
  return currIndex++;
};

nextTrack = function(playlist, index, random) {
  var duration, min, sec;
  if (random === true) {
    duration = Math.floor(Math.random() * (playlist[index].duration - startTime * 1000));
    min = Math.floor(duration / 60000);
    sec = Math.floor((duration % 60000) / 1000);
    return models.player.playTrack(playlist[index].uri + "#" + min + ":" + sec);
  } else {
    return models.player.playTrack(playlist[index].uri);
  }
};

createCanvas = function() {
  var canvas, cdOffset, center, countdown, ctx, degrees, radius, seconds, start, timestamp, total;
  canvas = $('#timer-canvas');
  if (canvas[0].getContext) {
    ctx = canvas[0].getContext('2d');
    start = (3 * Math.PI) / 2;
    center = 175;
    radius = 117;
    degrees = 359;
    seconds = count;
    total = 359;
    countdown = count;
    timestamp = new Date().getTime();
    $('#minLeft').html(numLeftCount + " songs left");
    cdOffset = 0;
    return timer = window.setInterval(function() {
      if (degrees >= 0) {
        if (countdown < 10) {
          $('#countdown').html('<span>0</span>' + countdown);
        } else {
          $('#countdown').html(countdown);
        }
        if (isPaused === true) {
          return paused = window.setInterval(function() {
            if (isPaused === true) {
              return console.log("we are paused");
            } else {
              window.clearInterval(paused);
              return cdOffset = Math.abs((timestamp / 1000) - (new Date().getTime() / 1000));
            }
          }, 40);
        } else {
          draw(ctx, start, center, radius, degrees, total);
          degrees -= (360 / seconds) / 24;
          total -= (360 / (seconds * totalSongs)) / 24;
          return countdown = Math.ceil(count - Math.abs((timestamp / 1000) - (new Date().getTime() / 1000))) + cdOffset;
        }
      } else {
        degrees = 359;
        countdown = count;
        timestamp = new Date().getTime();
        updateProgress();
        $('#minLeft').html(numLeftCount + " songs left");
        return nextTrack(window.playlist, currIndex, isRandom);
      }
    }, 40);
  }
};

draw = function(ctx, start, center, radius, degrees, total) {
  ctx.clearRect(0, 0, 400, 400);
  ctx.strokeStyle = "#54fffe";
  ctx.fillStyle = "#3d6868";
  ctx.beginPath();
  ctx.arc(center, center, radius, 0, 360, false);
  ctx.closePath();
  ctx.fill();
  ctx.fillStyle = "#479d9c";
  ctx.beginPath();
  ctx.arc(center, center, radius, start, start - (Math.PI / 180) * degrees, false);
  ctx.lineTo(center, center);
  ctx.closePath();
  ctx.fill();
  ctx.beginPath();
  ctx.lineWidth = 37;
  ctx.arc(center, center, radius + 30, start, start - (Math.PI / 180) * total, false);
  return ctx.stroke();
};
