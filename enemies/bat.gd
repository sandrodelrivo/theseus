extends KinematicBody2D

# variables
var speed = 20
var velocity = Vector2()
var angle = 0

# Runs when node is loaded
func _ready():
	angle = (randf() * ((2*PI)-0)) + 0

# 
func _physics_process(delta):	
	velocity.x = speed * cos(angle)
	velocity.y = speed * sin(angle)
	
	var motion = velocity
	motion = move_and_collide(motion/60)

	if motion != null:
		angle = motion.remainder.bounce(motion.normal).angle()
