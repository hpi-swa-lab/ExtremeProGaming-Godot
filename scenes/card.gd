extends Node2D

@export var on_card_grid = false
@export var uncovered = false


func flip_card():
	if $CardImage.z_index == -1:
		get_node("CardFlip").play("card_flip")
		uncovered = true
	
