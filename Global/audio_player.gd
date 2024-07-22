extends AudioStreamPlayer

const level_music = preload("res://Assets/Sounds (UI-Music)/City of Gamers - ChillGamingStudying Lofi Hip Hop Mix - (1 hour) FFfdyV8gnWk.mp3")
const CLICK = preload("res://Assets/Sounds (UI-Music)/Click.mp3")


func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
		
	
	stream = music
	volume_db == volume
	play()


func play_music_level():
	_play_music(level_music)
	
