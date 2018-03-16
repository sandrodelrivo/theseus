extends KinematicBody2D

var Enemy = load("res://enemies/enemy.gd")
var form = Enemy.new(20, 0, 5, 20)


# variables
var velocity = Vector2()
var angle = 0

# Runs when node is loaded
func _ready():
	
	angle = (randf() * ((2*PI)-0)) + 0

# 
func _physics_process(delta):
	form._state_process()
	
	velocity.x = form._speed * cos(angle)
	velocity.y = form._speed * sin(angle)
	
	var motion = velocity
	motion = move_and_collide(motion/60)

	if motion != null:
		angle = motion.remainder.bounce(motion.normal).angle()

func damage(value, type):
	form._damage(value, type, self)