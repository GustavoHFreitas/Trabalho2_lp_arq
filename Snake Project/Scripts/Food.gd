extends Node2D

class_name FoodScript

# Declare member variables here. Examples:


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FoodArea_area_entered(area):
	if area.name == "SnakeArea": # If snake hitbox enters food hitbox
		$SFX.play(); # Play respective sound effect
		foodEat(); # Execute it's eating function

func foodEat():
	pass;
