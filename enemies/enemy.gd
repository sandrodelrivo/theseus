# Class enemy.gd
# creates an enemy

# stats
var _health = 0
var _armor = 0
var _strength = 0
var _speed = 0

var _spawned = false
var _alive = true

var damage_timer = 0

# spawning
var _spawner
var _instance


# initializers
func _init(spawner):
	self._spawner = spawner


func _state_process():
	if (damage_timer>0):
		damage_timer-=1


func _spawn():
	_instance = _spawner.to_spawn.instance()
	_spawner.get_parent().add_child(_instance)
	_instance.position = _spawner.position
	
	_spawner.visible = false
	_spawned = true
	
	_instance.get_node("hit_box").spawner = _spawner
	_spawner._on_spawn()

func _despawn():
	_instance.queue_free()
	
	_spawner.visible = true
	_spawned = false
	_spawner._on_despawn()

func _damage(value, type):
	if (damage_timer == 0):
		damage_timer = 30
		if (value>_armor):
			_health -= value+_armor
		
		if (_health<=0):
			_kill()
		
		print(_health, type)

func _kill():
	_instance.queue_free()
	_alive = false
