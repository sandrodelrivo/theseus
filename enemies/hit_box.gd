extends Area2D

var spawner

func _ready():
	pass

func damage(value, type):
	spawner.form._damage(value, type)