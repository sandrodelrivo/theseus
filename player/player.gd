extends KinematicBody2D


# variables
#  movement
var speedMax = 100 # upper limit of speedCurrent
var speedCurrent = 0 # magnitude to which velocity is set
var speedDash = 100 # how far the dash moves
var acc = 10 # acceleration interval
var dec = 20 # deceleration interval
var movement = Vector2() # vector which determines movement each physics tick
#  facing
var facing = Vector2()
var direction = 0

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
	
	# performs state processes which need to run each physics tick
	match STATE:
		idle:
			pass
		move:
			movement = get_velocity()
			move_and_slide(movement)
		dash:
			pass

# runs when an input event occurs and determines state change
func _input(event):
	var event_list = getActions()
	match STATE:
		idle:
			speedCurrent = 0
			# determine next state (check transitions)
			if event_list["move"]:
				STATE = move
			if event_list["dash"]:
				dash()
		move:
			# determine next state (check transitions)
			if event_list["dash"]:
				dash()
			elif not event_list["move"]:
				setState("idle")
		dash:
			# determine next state (check transitions)
			if event_list["move"]:
				setState("move")
			else: 
				setState("idle")
	#rint(event, STATE)

# runs when state is changed, performs exit and enter processes
func setState(new_state):
	# perform exit state processes
	match (STATE):
		"idle":
			pass
		"move":
			pass
		"dash":
			pass
	
	# perform enter state processes
	match (new_state):
		"idle": 
			STATE = idle
			speedCurrent = 0
		"move":
			STATE = move
		"dash":
			STATE = dash

# looks at input and returns a dictionary of input states
func getActions():
	var event_list = {"move":false, "dash":false}
	
	# checks if any movement keys are held --> movement
	if (Input.is_action_pressed("ui_up") or 
		Input.is_action_pressed("ui_down") or 
		Input.is_action_pressed("ui_right") or 
		Input.is_action_pressed("ui_left")):
		event_list["move"] = true
	
	# checks if the right mouse has just been pressed --> dash
	if (Input.is_action_just_pressed("click_right")):
		event_list["dash"] = true
		
	return event_list
	

# checks what controls are pressed and sets velocity
func get_velocity():
	# sets velocity to 0
	var velocity = Vector2(0,0)
	
	# adds 1 to either horizontal or vertical depending on keypress
	if (Input.is_action_pressed("ui_up")):
		velocity.y-=1
	if (Input.is_action_pressed("ui_down")):
		velocity.y+=1
	if (Input.is_action_pressed("ui_right")):
		velocity.x+=1
	if (Input.is_action_pressed("ui_left")):
		velocity.x-=1
	
	# increases speed by acc if it is less than speedMax
	if speedCurrent < speedMax:
			speedCurrent += acc
	
	# return velocity with magnitude of the current logical speed
	return velocity.normalized()*speedCurrent
	
func dash():
	var dash = get_global_mouse_position()-position
	if (dash.length()>speedDash):
		dash = dash.normalized()*speedDash
	
	move_and_slide(dash*60)