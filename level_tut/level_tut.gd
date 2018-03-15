extends Node2D

# onready's


# variables
#  player
onready var player = $player
#  enemies
onready var enemy_spawners = $enemies.get_children()
var enemy_instances = []

func _ready():
	print("Main Script Ready!")
	
	spawn_enemies()
	

func spawn_enemies():
	for i in enemy_spawners:
		var e = i.to_spawn.instance()
		$enemies.add_child(e)
		e.position = i.position
		i.visible = false
		enemy_instances.append(e)
		