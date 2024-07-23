extends Control

func _ready():
	AudioPlayer.play_music_level()

#BOUTON AMC
@onready var click_sound = $Interface/Panel/AMC/Click_sound

func _on_amc_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu mode de jeux AMC.tscn")

	



#BOUTON OPTIONS
func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")



