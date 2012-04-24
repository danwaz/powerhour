$ ->
	sp = getSpotifyApi(1)
	models = sp.require("sp://import/scripts/api/models")

	window.sp = sp
	window.models = models
