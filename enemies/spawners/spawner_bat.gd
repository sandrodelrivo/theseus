extends Node2D

var Enemy = load("res://enemies/enemy.gd")
var form = Enemy.new(self)

onready var to_spawn = preload("res://enemies/bat.tscn")
onready var player = get_node("../../player")

var spawn_range = 250
# movement
var velocity = Vector2()
var angle = 0

func _ready():
	form._health = 30
	form._speed = 30
	pass

func _physics_process(delta):

	form._state_process()

	if (form._alive):
		check_spawn()

		if (form._spawned):
			movement()

func _on_spawn():
	angle = (randf() * ((2*PI)-0)) + 0

func _on_despawn():
	pass

func movement():
	velocity.x = form._speed * cos(angle)
	velocity.y = form._speed * sin(angle)

	var motion = velocity
	motion = form._instance.move_and_collide(motion/60)

	if motion != null:
		angle = motion.remainder.bounce(motion.normal).angle()

func check_spawn():
	# creates float for distance form player to spawner
	var player_to_spawner = position.distance_to(player.position)
	# spawns the enemy if it not spawned and is within a range of the player
	if (visible and (spawn_range/2)<player_to_spawner and player_to_spawner<spawn_range):
		form._spawn()
	# despawns enemy if spawned outside a certain range of player
	elif ((not visible) and spawn_range<form._instance.position.distance_to(player.position)):
		form._despawn()
