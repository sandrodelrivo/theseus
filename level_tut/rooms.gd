extends Area2D

func _on_rooms_body_entered(body):
	if (body.get_name() == "player"):
		$camera.make_current()


func _ready():
	#print("Room Script Ready!")
	set_physics_process(true)