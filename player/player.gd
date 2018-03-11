extends KinematicBody2D

# variables
var speed = 50
var velocity = Vector2()
var facing = Vector2()

# runs when node is loaded
func _ready():
	print("Player Script Ready!")
	#set_physics_process(false)
	#set_process_input(true)

# runs every physics tick
func _physics_process(delta):
	
	# mouse position vector minus player postion vector
	facing = get_global_mouse_position()-position
	# converts angle to int on interval [0,7] with 0rad=0 increasing clockwise
	$sprite.frame = range(8)[int(round(facing.angle()/(PI/4)))]
	
	# sets velocity based on what keys are currently pressed and moves
	setVelocity()
	move_and_slide(velocity)


# extra functions

# checks what controls are pressed and sets velocity
func setVelocity():
	# sets to 0
	velocity = Vector2(0,0)
	
	# adds 1 to either horizonta or vertical depending on keypress
	if (Input.is_action_pressed("ui_up")):
		velocity.y-=1
	if (Input.is_action_pressed("ui_down")):
		velocity.y+=1
	if (Input.is_action_pressed("ui_right")):
		velocity.x+=1
	if (Input.is_action_pressed("ui_left")):
		velocity.x-=1
	
	# sets magnitude of velocity to speed
	velocity = velocity.normalized()*speed
	
func _input(event):
	if event.is_action_pressed("click_left") and event.is_pressed():
		# sets tele_test position ot mouse position
		var check = get_parent().get_node("tele_test")
		check.position = get_global_mouse_position()
		if ():
			position = check
		