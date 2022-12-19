extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Text.text = "Score: " + str(Global.save_int) + "\n\n\n\n"; # Prints out the score for the current play session


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed(): #Switches to the game screen.
	if get_tree().change_scene("res://Scenes/Game.tscn") != OK:
		print("A fatal error has occurred. Could not change to Game scene.");
