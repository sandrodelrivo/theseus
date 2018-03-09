extends KinematicBody2D

func _ready():
	print("Player Script Ready!")
	set_physics_process(true)
	#set_process_input(true)

var SPEED = 50

var velocity = Vector2()
var facing = Vector2()

# note - rotation is in radians, not degrees
func _physics_process(delta):
	
	setVelocity()
	setFacing()
		
	if (facing.x!=0 or facing.y!=0):
		setFrame(getDirection(facing))
		
	move_and_slide(velocity.normalized()*SPEED)

	
# Extra Functions

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

func setFacing():
	if (Input.is_action_pressed("face_up")):
		facing.y = -1
	elif (Input.is_action_pressed("face_down")):
		facing.y = 1
	else:
		facing.y = 0
		
	if (Input.is_action_pressed("face_right")):
		facing.x = 1
	elif (Input.is_action_pressed("face_left")):
		facing.x = -1
	else:
		facing.x = 0

func getDirection(vector):
	var raw = int(vector.angle()/(PI/4))
	if (raw<0):
		return raw+8
	return raw
	
func setFrame(direction):
	$sprite.frame = direction