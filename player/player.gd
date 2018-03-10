extends KinematicBody2D

# Runs when player node is loaded
func _ready():
	print("Player Script Ready!")
	set_physics_process(true)
	#set_process_input(true)

# Constants
var SPEED = 50

# Member Variables
var velocity = Vector2()
var facing = Vector2()

# Runs every physics tick
func _physics_process(delta):
	
	setFacing()
	$sprite.frame = getDirection(facing)
	
	setVelocity()
	move_and_slide(velocity)


# Extra Functions

# Checks what controls are pressed and sets velocity
func setVelocity():
	if (Input.is_action_pressed("ui_up")):
		velocity.y = -1
	elif (Input.is_action_pressed("ui_down")):
		velocity.y = 1
	else:
		velocity.y = 0
	
	if (Input.is_action_pressed("ui_right")):
		velocity.x = 1
	elif (Input.is_action_pressed("ui_left")):
		velocity.x = -1
	else:
		velocity.x = 0
	
	#Sets magnitude of velocity to constant SPEED
	velocity = velocity.normalized()*SPEED

# Finds the vector between the screen positon of the player to
# 	the screen postion of the mouse 
func setFacing():
	var pos_player = get_global_transform_with_canvas()[2]
	var pos_mouse = get_viewport().get_mouse_position()
	
	facing = pos_mouse - pos_player

func getDirection(vector):
	var raw = int(round(vector.angle()/(PI/4)))
	if (raw<0):
		raw += 8
	
	return raw