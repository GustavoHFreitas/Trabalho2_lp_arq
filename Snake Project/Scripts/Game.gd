extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.SnakeFrozen = false; # Resets the snake state.
	Global.save_int = 0; # Resets the score
	Global.ambient = get_node(".");
	Global.walls = []
	Global.spawnSnake();


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
