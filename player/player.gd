extends KinematicBody2D

# ---------- variables ----------

# nodes

#  movement
var speedMax = 100 # upper limit of speedCurrent
var speedCurrent = 0 # magnitude to which velocity is set
var speedDash = 70 # how far the dash moves
var acc = 10 # acceleration interval
var dec = 15 # deceleration interval
var movement = Vector2() # vector which determines movement each physics tick

#  facing

var facing = Vector2()
var direction = 0 # for all directions, 0 - right,  1 - down, 2 - left, 3 - up
var walk_direction = 0

# attack
var angleStartRel = -PI/2 # cardinal fcing direction+angleStart
var angleStopRel = PI/4 # cardinal facing direction+angleStop
var angleStop = 0
var swingTime = 15 # number of physics ticks (1/60 seconds)


#  stats
var health = 100

# signals

# ---------- state handling ----------

enum STATE{
	idle,
	move,
	dash,
	melee
}

# runs when node is loaded
func _ready():
	print("Player Script Ready!")
	#$anim.play("player_walk_down")
	# initial state
	STATE = idle

# runs every physics tick
func _physics_process(delta):

	# mouse position vector minus player postion vector
	facing = get_global_mouse_position()-position
	# converts angle to int on interval [0,3] with 0rad=0 increasing clockwise
	direction = range(0,4)[int(round(facing.angle()/(PI/2)))]

	#$camera.position = get_owner().get_node("dash_location").position - position

	# performs state processes which need to run each physics tick
	match STATE:
		idle :

			match walk_direction:
					0:
						#print("playing idle right")
						$anim.play("player_idle_right")
					1:
						#print("playing idle down")
						$anim.play("player_idle_down")
					2:
						#print("playing idle left")
						$anim.play("player_idle_left")
					3:
						#print("playing idle up")
						$anim.play("player_idle_up")



		move:

			#print("Is Anim Playing? - ", not anim.is_playing())

			match walk_direction:
					0:
						if $anim.assigned_animation != "player_walk_right":
							#print("playing walk right")
							$anim.play("player_walk_right")
					1:
						if $anim.assigned_animation != "player_walk_down":
							#print("playing walk down")
							$anim.play("player_walk_down")
					2:
						if $anim.assigned_animation != "player_walk_left":
							#print("playing walk left")
							$anim.play("player_walk_left")
					3:
						if $anim.assigned_animation != "player_walk_up":
							#print("playing walk up")
							$anim.play("player_walk_up")

			movement = get_velocity()
			move_and_slide(movement)

		dash:
			pass
		melee:
			# areas currently touching sword
			var to_damage = $sword.get_overlapping_areas()
			if (len(to_damage)>0):
				for target in to_damage:

					if target.name != "player_hit_box":
						target.damage(10, "type_test")

			if ($sword.rotation < angleStop):
				$sword.rotate((angleStopRel-angleStartRel)/swingTime)
			else:
				set_state("idle")
			pass

# runs when an input event occurs and determines state change
func _input(event):
	var eventList = get_actions()
	match STATE:
		idle:
			speedCurrent = 0
			# determine next state (check transitions)
			if eventList["move"]:
				set_state("move")
			elif eventList["dash"]:
				set_state("dash")
			elif eventList["melee"]:
				set_state("melee")
		move:
			# determine next state (check transitions)
			if eventList["dash"]:
				set_state("dash")
			elif eventList["melee"]:
				set_state("melee")
			elif not eventList["move"]:
				set_state("idle")
		dash:	# currently, never runs, state set to idle immediately in entry process
			# determine next state (check transitions)
			if eventList["move"]:
				set_state("move")
			else:
				set_state("idle")
		melee:
			pass

# runs when state is changed, performs exit and enter processes
func set_state(new_state):
	# perform exit state processes
	match (STATE):
		idle:
			pass
		move:
			pass
		dash:
			pass
		melee:
			$sword.visible = false
			pass

	# perform enter state processes
	match (new_state):
		"idle":
			STATE = idle
			speedCurrent = 0
		"move":
		#	print("Stopping Anim!")
			$anim.stop()
			STATE = move
		"dash":
			STATE = dash
			dash()
			STATE = idle
		"melee":
			STATE = melee
			$sword.visible = true
			$sword.rotation = direction*PI/2+angleStartRel
			angleStop = direction*PI/2+angleStopRel

# looks at input and returns a dictionary of input states
func get_actions():
	var event_list = {"move":false, "dash":false, "melee":false}

	# checks if any movement keys are held --> movement
	if (Input.is_action_pressed("ui_up") or
		Input.is_action_pressed("ui_down") or
		Input.is_action_pressed("ui_right") or
		Input.is_action_pressed("ui_left")):
		event_list["move"] = true


	# checks if the right mouse has just been pressed --> dash
	if (Input.is_action_just_pressed("ui_select")):
		event_list["dash"] = true

	if (Input.is_action_just_pressed("click_left")):
		event_list["melee"] = true

	return event_list

# checks what controls are pressed and sets velocity
func get_velocity():
	# sets velocity to 0
	var velocity = Vector2(0,0)

	# adds 1 to either horizontal or vertical depending on keypress
	if (Input.is_action_pressed("ui_up")):
		velocity.y-=1
		walk_direction = 3
	if (Input.is_action_pressed("ui_down")):
		velocity.y+=1
		walk_direction = 1
	if (Input.is_action_pressed("ui_right")):
		velocity.x+=1
		walk_direction = 0
	if (Input.is_action_pressed("ui_left")):
		velocity.x-=1
		walk_direction = 2

	# increases speed by acc if it is less than speedMax
	if speedCurrent < speedMax:
			speedCurrent += acc

	# return velocity with magnitude of the current logical speed
	return velocity.normalized()*speedCurrent

# performs dash action
func dash():
	var dash = get_global_mouse_position()-position
	dash = dash.normalized()*speedDash

	move_and_slide(dash*60)
