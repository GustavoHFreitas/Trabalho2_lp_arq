extends Node

class_name GlobalScript

# Declare member variables here. Examples:
var save = File.new(); # Highscore file
var save_int = 0; # Highscore int value
var save_path = "user://savegame.save"; # Highscore file path
var save_data = {"Best": 0}; # Highscore data
var startSnek;
var mainFood;
var walls = [];
var SnakeFrozen = false; # Freezes the snake in place

var game = preload("res://Scenes/Game.tscn");
var ball = preload("res://Scenes/Ball.tscn");
var skull = preload("res://Scenes/Skull.tscn");
var snek = preload("res://Scenes/Snake.tscn");

var ambient;

# Called when the node enters the scene tree for the first time.
func _ready():
	if not save.file_exists(save_path): # Creates the save file if not already in place.
		save.open(save_path, File.WRITE);
		save.store_var(save_data);
		save.close();

func spawnSnake(): # Spawns snake and the food
	startSnek = snek.instance();
	ambient.add_child(startSnek);
	mainFood = ball.instance();
	mainFood.global_position = foodPosit(false);
	ambient.add_child(mainFood);


func spawnWall(): # Creates a new wall
	var newWall = skull.instance();
	newWall.global_position = foodPosit(true);
	yield(get_tree().create_timer(0.01), "timeout");
	ambient.add_child(newWall);
	walls.append(newWall);


# Saving functions.
func save_score(x):
	save.open(save_path, File.WRITE);
	save_data["Best"] = x;
	save.store_var(save_data);
	save.close();
	
func read_score():
	save.open(save_path, File.READ);
	save_data = save.get_var();
	save.close();
	return save_data["Best"];


# Determines valid food positions based on snake position.
# Skulls can't spawn next to other skulls to avoid soft-locking.
# Yes, there's better ways of doing this but for a game of this scope this is irrelevant.
func foodPosit(IsItSkull):
	var valid = 1 # This will be turned into 0 if an invalid foodPosition is obtained randomly
	
	randomize(); # In a 1280x720 screen since positions are a random multiple of 40 there are 32x18 possibilities.
	var x = randi() % 32; # Gets a value from 0 - 31
	x = x*40;
	randomize();
	var y = randi() % 18; # Gets a value from 0 - 17
	y = y*40;
	
	for i in range(startSnek.body.size()-1,-1,-1): # Position can't be inside a snake.
		if startSnek.body[i].global_position == Vector2(x,y):
			valid = 0;
	
	for i in range(walls.size()-1,-1,-1): # Position can't be inside a skull
		if walls[i].global_position == Vector2(x,y):
			valid = 0;

	for i in 5: # Position can't be 5 blocks in front of the snake
		if startSnek.body[0].global_position + ((40*i)*startSnek.prev_direction) == Vector2(x,y):
			valid = 0;

	for i in range(-80,120,40): # Position can't be 5x5 around the snake's head
		for j in range(-80,120,40):
			if startSnek.body[0].global_position + Vector2(i,j) == Vector2(x,y):
				valid = 0;

	if IsItSkull == true: # Skulls can't spawn next to each other (Prevents softlocks)
		for i in range(-40,80,40):
			for j in range(-40,80,40):
				for k in range(walls.size()-1,-1,-1):
					if walls[k].global_position + Vector2(i,j) == Vector2(x,y):
						valid = 0;

	if valid == 1:
		return Vector2(x,y);
	else:
		return foodPosit(IsItSkull);


# Called every time snake eats food.
func growSnake():
	startSnek.grow();
	save_int = save_int + 1;
	if save_int > read_score():
		save_score(save_int);
	if save_int % 3 == 0:
		if save_int != 150:
			spawnWall();
	Checkwin();


# Win Condition
func Checkwin():
	if save_int == 150:
		SnakeFrozen = true;
		startSnek.winSound();
		yield(get_tree().create_timer(4), "timeout");
		if get_tree().change_scene("res://Scenes/Win.tscn") != OK:
			print("A fatal error has occurred. Could not change to Win scene.");


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
