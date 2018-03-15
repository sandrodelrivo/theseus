extends Control

# variables
onready var player = get_node("../../player")

# fps
var buffer = 0
var count = 0

func _ready():
	pass

func _process(delta):

	fps(delta)
	state()
	speed()
	health()


func fps(delta):
	buffer+=delta
	count+=1
	if (buffer>=1):
		$fps.text = str(count)+"fps"
		buffer = 0
		count = 0

func state():
	$state.text = "state: "+str(player.STATE)

func speed():
	$speed.text = "speed: "+str(player.speedCurrent)
	
func health():
	$health.text = "health: "+str(player.health)