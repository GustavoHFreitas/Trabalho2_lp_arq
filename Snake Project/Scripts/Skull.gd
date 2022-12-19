extends FoodScript;

class_name SkullScript
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func foodEat(): # Stops snake movement, places skull off-screen and changes scene to Game Over
	Global.SnakeFrozen = true;
	global_position = Vector2(-100,-100);
	yield(get_tree().create_timer(1), "timeout");
	if get_tree().change_scene("res://Scenes/GameOver.tscn") != OK:
		print("A fatal error has occurred. Could not change to GameOver scene.");
