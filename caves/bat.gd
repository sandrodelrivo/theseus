extends KinematicBody2D

var speed = 20
var velocity = Vector2()
var angle = 0
func _ready():
	angle = (randf() * ((2*PI)-0)) + 0
	

func _process(delta):
	
	
	velocity.x = speed * cos(angle)
	velocity.y = speed * sin(angle)
	
	var motion = velocity * delta
	motion = move_and_collide(motion)

	if motion != null:
		angle = motion.remainder.bounce(motion.normal).angle()
