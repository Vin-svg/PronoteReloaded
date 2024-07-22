extends Control
	
func _on_backto_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")


func _on_qcm_pressed():
	get_tree().change_scene_to_file("res://Scenes/QCM.tscn")


const CLICK = preload("res://Assets/Sounds (UI-Music)/Click.mp3")


