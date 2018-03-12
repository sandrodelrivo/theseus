extends KinematicBody2D

# variables
var speed_max = 100
var isMoving = false
var speed = 0
var dashSpeed = 4000 # how far the dash moves
var acc = 10 # acceleration interval
var dec = 20 # deceleration interval
var accelearation
var velocity = Vector2()
var facing = Vector2()
var direction = 0
onready var input

enum STATE{
	idle,
	move,
	dash	
}

enum COMBAT_STATE{
	
}

# runs when node is loaded
func _ready():
	print("Player Script Ready!")
	STATE = idle
	#set_physics_process(false)
	#set_process_input(true)

# runs every physics tick
func _physics_process(delta):
	
	# mouse position vector minus player postion vector
	facing = get_global_mouse_position()-position
	# converts angle to int on interval [0,7] with 0rad=0 increasing clockwise
	$sprite.frame = range(8)[int(round(facing.angle()/(PI/4)))]
	
	# sets velocity based on what keys are currently pressed and moves

	print(STATE)
	match STATE:
		idle:
			# determine next state (check transitions)
			if checkMovement():
				STATE = move
			elif checkDash():
				STATE = dash
			else:
				# deccelerate the player		
				if speed > 0:
					speed -= dec
			
		move:
			setVelocity()
			move_and_slide(velocity)
			
			# determine next state (check transitions)
			if not checkMovement():
				STATE = idle
			elif checkDash():
				STATE = dash
					
		dash:
			dash()
			
			# determine next state (check transitions)
			if checkMovement():
				STATE = move
			else: 
				STATE = idle


# extra functions

func checkMovement():
	var movement = false
	if (Input.is_action_pressed("ui_up")):
		movement = true
	if (Input.is_action_pressed("ui_down")):
		movement = true
	if (Input.is_action_pressed("ui_right")):
		movement = true
	if (Input.is_action_pressed("ui_left")):
		movement = true
		
	return movement
	
func checkDash():
	if (Input.is_action_just_pressed("click_right")):
		return true
	else:
		return false
	

# checks what controls are pressed and sets velocity
func setVelocity():
	# sets to 0
	velocity = Vector2(0,0)
	
	# adds 1 to either horizontal or vertical depending on keypress
	
	if (Input.is_action_pressed("ui_up")):
		velocity.y-=1
		if speed < speed_max:
			speed += acc
	if (Input.is_action_pressed("ui_down")):
		velocity.y+=1
		if speed < speed_max:
			speed += acc
	if (Input.is_action_pressed("ui_right")):
		velocity.x+=1
		if speed < speed_max:
			speed += acc
	if (Input.is_action_pressed("ui_left")):
		velocity.x-=1
		if speed < speed_max:
			speed += acc

		
	# sets magnitude of velocity to speed
	velocity = velocity.normalized()*speed

	
func dash():
	
	velocity.x = dashSpeed * cos(facing.angle())
	velocity.y = dashSpeed * sin(facing.angle())	
	
	var motion = velocity
	motion = move_and_slide(motion)	
	
	STATE = idle
	

		
		