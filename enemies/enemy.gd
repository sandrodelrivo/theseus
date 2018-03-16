# Class enemy.gd
# creates an enemy

# stats
var _health
var _armor
var _strength
var _speed

# private variables, do not access outside class
var damage_timer = 0
var _alive = true

# spawning
var spawner
var instance


# initializers
func _init(health, armor, strength, speed):
	self._health = health
	self._armor = armor
	self._strength = strength
	self._speed = speed


func _state_process():
	if (damage_timer>0):
		damage_timer-=1


func spawn(spawner):
	# create new dictionary entry with key of spawner and key value of an instance of the enemy scene
	instance = spawner.to_spawn.instance()
	# adds the instance to the enemy container
	spawner.get_parent().add_child(instance)
	# sset position of instance to that of the spawner
	instance.position = spawner.position
	# hide the spawner
	spawner.visible = false
"""
func despawn(spawner):
	# despawn instance of enemy
	enemy_instances[spawner].queue_free()
	# remove dictionary entry
	enemy_instances.erase(spawner)
	# shows the spawner
	spawner.visible = true"""

func _damage(value, type, instance):
	if (damage_timer == 0):
		damage_timer = 30
		if (value>_armor):
			_health -= value+_armor
		
		if (_health<=0):
			_kill(instance)
		
		print(_health, type)

func _kill(instance):
	instance.queue_free()
