extends Node2D



# onready's


# variables
#  player
onready var player = $player
#  enemies
onready var enemy_spawners = $enemies.get_children()
var enemy_instances = {}

# temp
var pos_player
var pos_spawner
var pos_instance

func _ready():
	print("Main Script Ready!")
	
func _physics_process(delta):
	for spawner in enemy_spawners:
		var player_to_spawner = spawner.position.distance_to(player.position)
		
		if (spawner.visible and 50<player_to_spawner and player_to_spawner<100):
			spawn(spawner)
		elif ((not spawner.visible) and 100<enemy_instances[spawner].position.distance_to(player.position)):
			despawn(spawner)
			
	
func _input(event):
	if Input.is_action_just_pressed("face_up"):
		spawn(enemy_spawners[0])


func spawn(spawner):
	# create new dictionary entry with key of spawner and key value of an instance of the enemy scene
	enemy_instances[spawner] = spawner.to_spawn.instance()
	# adds the instance to the enemy container
	$enemies.add_child(enemy_instances[spawner])
	# sset position of instance to that of the spawner
	enemy_instances[spawner].position = spawner.position
	# hide the spawner
	spawner.visible = false
	
func despawn(spawner):
	# despawn instance of enemy
	enemy_instances[spawner].queue_free()
	# remove dictionary entry
	enemy_instances.erase(spawner)
	# shows the spawner
	spawner.visible = true


