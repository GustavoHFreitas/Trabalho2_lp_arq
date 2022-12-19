extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Highscore.text = "Highscore: " + str(Global.read_score());


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed(): #Switches to the game screen.
	if get_tree().change_scene("res://Scenes/Game.tscn") != OK:
		print("A fatal error has occurred. Could not change to Game scene.");
