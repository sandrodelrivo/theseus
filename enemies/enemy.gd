# Class enemy.gd
# creates an enemy

# stats
var _health = 0
var _armor = 0
var _strength = 0
var _speed = 0
var _aggRange = 0

var _direction = 0 # 0 - right, 1 - left

var _distance = 0
var _spawned = false
var _alive = true

var damage_timer = 0
var _spawn_range = 100

# spawning
var _spawner
var _instance



enum STATE {
	void,
	spawn,
	idle,
	combat,
	despawn
}

var next_state = "void"
var isRepeat = false

# initializers
func _init(spawner):
	self._spawner = spawner
	STATE = void

# processing

func _physics_process(delta):

	_state_process()


func _state_process():
	if (damage_timer>0):
		damage_timer-=1

	# state management


	match STATE:
		void:
			next_state = _spawner._void(isRepeat)
		spawn:
			next_state =  _spawner._spawn(isRepeat)
		idle:
			next_state =  _spawner._idle(isRepeat)
		combat:
			next_state = _spawner._combat(isRepeat)
		despawn:
			next_state = _spawner._despawn(isRepeat)

	if str(STATE) == next_state:
		isRepeat = true

	match next_state:
		"void":
			STATE = void
		"idle":
			STATE = idle
		"combat":
			STATE = combat
		"spawn":
			STATE = spawn
		"despawn":
			STATE = despawn

func _spawn():
	print("[Enemy Class]: SPAWNED")
	_instance = _spawner.to_spawn.instance()
	_spawner.get_parent().add_child(_instance)
	_instance.position = _spawner.position

	_spawner.visible = false
	_spawned = true

	_instance.get_node("hit_box").spawner = _spawner
	STATE = spawn

func _despawn():
	_instance.queue_free()

	_spawner.visible = true
	_spawned = false
	_spawner._on_despawn()
	STATE = void

# --- util functions ---

# returns the distance between the player and the form instance
func _get_distance():
	var distance = _instance.position.distance_to(_spawner.player.position)
	return distance

func _damage(value, type):
	if (damage_timer == 0):
		damage_timer = 30
		if (value>_armor):
			_health -= value+_armor

		if (_health<=0):
			_kill()

		print(_health, type)

func _kill():
	_alive = false
	STATE = void
	_instance.queue_free()
