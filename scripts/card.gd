extends Node2D
class_name Card

@export var on_card_grid = false
@export var uncovered = false
@export var chosen = false
@export var storypoints = null

@onready var storypoints_reference = $Storypoints

func _ready():
	$SelectionBorder.visible = false

func flip_card():
	if $CardImage.z_index == -1:
		get_node("CardFlip").play("card_flip")
		uncovered = true
		
func choose_card():
	chosen = !chosen
	$ChooseCard.play()
	$SelectionBorder.visible = chosen
	
