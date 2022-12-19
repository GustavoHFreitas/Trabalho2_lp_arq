extends Node2D;

class_name SnakeScript

# Declare variables here.
var cur_direction = Vector2(0,0); # Snake next direction.
var prev_direction = Vector2(0,0); # Previous direction the snake moved.
var queued_direction = Vector2(0,0); # Queued direction for the snake. (For turning, when two directions are pressed at once)
var queue = 0; # Is there a queued direction? / 0: No. / 1: Yes, in the back. / 2: Yes, on the front. /
var body = []; # Contains all of the snake body parts.

# Loads Snek parts.
var skeleton = preload("res://Scenes/Skeleton.tscn");
var head = preload("res://Scenes/Head.tscn");


# Called when the node enters the scene tree for the first time.
func _ready():
# Creates a head instance and adds it to the snake.
	var startHead = head.instance();
	add_child(startHead);
	body.append(startHead);
	body[0].global_position = Vector2(640,360); # Positions snake on-screen.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Detects what buttons were pressed and changes directions accordingly.
	if Input.is_action_just_pressed("ui_up"):
		if cur_direction != prev_direction: # This will be true if a second direction is pressed before the previous one updates.
			queued_direction = Vector2(0,-1); # In this case, save the second direction.
			queue = 1; # Indicate that it's pending.
		else: # Otherwise,
			if prev_direction != Vector2(0,1): # If the direction isn't the opposite one (Prevents snake from going into itself).
				cur_direction = Vector2(0,-1); # Change the next direction.

	# These are the same thing but for different directions.
	if Input.is_action_just_pressed("ui_down"):
		if cur_direction != prev_direction:
			queued_direction = Vector2(0,1);
			queue = 1;
		else:
			if prev_direction != Vector2(0,-1):
				cur_direction = Vector2(0,1);
	if Input.is_action_just_pressed("ui_left"):
		if cur_direction != prev_direction:
			queued_direction = Vector2(-1,0);
			queue = 1;
		else:
			if prev_direction != Vector2(1,0):
				cur_direction = Vector2(-1,0);
	if Input.is_action_just_pressed("ui_right"):
		if cur_direction != prev_direction:
			queued_direction = Vector2(1,0);
			queue = 1;
		else:
			if prev_direction != Vector2(-1,0):
				cur_direction = Vector2(1,0);


# Every in-game "Tick":
func _on_Timer_timeout():
	# OB Check
	if Global.SnakeFrozen == false:
		if body[0].global_position.x < 0 || body[0].global_position.x >= 1280:
			kill();
		if body[0].global_position.y < 0 || body[0].global_position.y >= 720:
			kill();
	# Movement Code & Body Collision Check
	if Global.SnakeFrozen == false:
		for x in range(body.size()-1,-1,-1):
			if x == 0 && Global.SnakeFrozen == false: # Head case:
				if queue == 2: # Pending direction waiting to be executed.
					body[x].global_position += queued_direction * 40; # Moves the head 40 pixels according to queued_direction.
					queue = 0; # No more queued directions.
					prev_direction = queued_direction; # Changes prev_direction and cur_direction accordingly.
					cur_direction = queued_direction;
				else:
					body[x].global_position += cur_direction * 40; # Moves the head 40 pixels according to cur_direction.
					if queue == 1: # If there is a second direction pending,
						queue = 2; # Execute it next time.
					prev_direction = cur_direction; # Updates prev_direction.
			else: # Skeleton case:
				if body[x].global_position == body[0].global_position: # Checks if skeleton and head have collided.
					kill(); # Kills snake.
				else: # If not,
					if Global.SnakeFrozen == false:
						body[x].global_position = body[x-1].global_position; # Moves the body parts based on the next one.


# Grows the snake.
func grow():
	# Creates a skeleton instance and adds it to the snake.
	var skeleton_instance = skeleton.instance();
	skeleton_instance.global_position = Vector2(-100,-100); # Spawns it off-screen so it doesn't flash in the scene
	yield(get_tree().create_timer(0.01), "timeout");
	add_child(skeleton_instance);
	body.append(skeleton_instance); # Places into the end of the snake


# Kills the snake.
func kill():
	$SFX.play();
	Global.SnakeFrozen = true;
	yield(get_tree().create_timer(1), "timeout");
	if get_tree().change_scene("res://Scenes/GameOver.tscn") != OK:
		print("A fatal error has occurred. Could not change to GameOver scene.");


# Winning "song".
func winSound():
	$WinSFX.play();
