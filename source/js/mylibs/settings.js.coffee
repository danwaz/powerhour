player = sp.trackPlayer

toggleShuffle = $('#shuffle').click( ->
	toggled = player.getShuffle()
	if toggled
		player.setShuffle(false)
	else
		player.setShuffle(true)
)