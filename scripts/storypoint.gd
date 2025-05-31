extends Node2D

var original_position: Vector2 = Vector2.ZERO
var self_destroy = 10000

func _ready():
	$Area2D.input_pickable = false
	$Area2D/CollisionShape2D.disabled = true
