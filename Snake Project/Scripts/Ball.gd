extends FoodScript;

class_name BallScript
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func foodEat(): # Grows snake and changes the food position
	global_position = Global.foodPosit(false);
	Global.growSnake();
