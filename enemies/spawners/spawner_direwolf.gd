extends Node2D

var Enemy = load("res://enemies/enemy.gd")
var form = null

onready var to_spawn = preload("res://enemies/direwolf.tscn")
onready var player = get_node("../../player")

# behavior variables
var spawn_range = 250
var agg_range = 250
var lunge_range = 100

var relation = null

var WAIT_FRAMES = 60
var waited_frames = 0
var LUNGE_CONSTANT = 1500

# movement variables
var velocity = Vector2()
var angle = 0


# --- enums ---

enum C_STATE {
	tracking,
	warmup,
	lunge
}


# --- core functions ---

func _ready():
	print("Direwolf Spawner Script Ready!")
	visible = true

func _physics_process(delta):
	check_spawn()

	if form != null:
		form._physics_process(delta)

func set_stats():
	form._health = 30
	form._speed = 30
	form._aggRange = agg_range

func _on_despawn():
	pass

func check_spawn():

			# creates float for distance form player to spawner
			var player_to_spawner = position.distance_to(player.position)
			# spawns the enemy if it not spawned and is within a range of the player
			#print ("Player to Spawn: ", player_to_spawner, " visible: ", visible, "Spawn Range: ", spawn_range)
			if (visible and player_to_spawner<spawn_range):
				if form == null:
					print("DIREWOLF INSTANCED")
					form = Enemy.new(self)
					set_stats()
				if form != null and form._alive:
					form._spawn()
			# despawns enemy if spawned outside a certain range of player
			elif (not visible):
				if form != null and form._alive:
					if spawn_range<form._instance.position.distance_to(player.position):
						print("Despawning Direwolf!")
						form._despawn()



# --- behaviors ---

func _void(isRepeat):
	#print("[STATE] - void")

	return "void"

func _spawn(isRepeat):
	#print("[STATE] - spawn")
	return "idle"

func _idle(isRepeat):
	#print("[STATE] - idle")

	if not isRepeat:

		match form._direction:
			0:
				pass
			1:
				pass

	# next state

	if form._get_distance() <= form._aggRange:
		C_STATE = tracking
		return "combat";
	else:
		return "idle"

func _combat(isRepeat):

	#print("[STATE] - combat")


	match C_STATE:
		tracking:

			relation = player.position - form._instance.position
			angle = relation.angle()


			velocity.x = form._speed * cos(angle)
			velocity.y = form._speed * sin(angle)

			var motion = velocity
			motion = form._instance.move_and_collide(motion/60)

			if (form._get_distance() < lunge_range):
				relation = player.position - form._instance.position
				#print("		[COMBAT STATE] - Warmup")
				C_STATE = warmup
			else:
				#print("		[COMBAT STATE] - Tracking")
				C_STATE = tracking

		warmup:

			waited_frames += 1

			if (waited_frames >= WAIT_FRAMES):
				waited_frames = 0
				#print("		[COMBAT STATE] - Lunge")
				C_STATE = lunge
			else:
				#print("		[COMBAT STATE] - Warmup")
				C_STATE = warmup

		lunge:


			angle = relation.angle()


			velocity.x = (form._speed*LUNGE_CONSTANT) * cos(angle)
			velocity.y = (form._speed*LUNGE_CONSTANT) * sin(angle)

			var motion = velocity
			motion = form._instance.move_and_collide(motion/60)

			#print("		[COMBAT STATE] - Tracking")
			C_STATE = tracking

	# next state

	if form._get_distance()  <= form._aggRange:
		return "combat"
	else:
		return "idle"

func _despawn(isRepeat):
	#print("[STATE] - despawn")
	return "void"
