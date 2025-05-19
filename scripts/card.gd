extends Node2D
class_name Card

@export var on_card_grid = false
@export var uncovered = false
@export var chosen = false
@export var storypoints = null
@export var storypoint_or_debt = null
@export var type = null
@export var effects = []

@onready var storypoints_reference = $Storypoints


enum CardType {
	FEATURE,
	EVENT,
	BUG
}

func _ready():
	$SelectionBorder.visible = false
	
func is_card():
	return true

func flip_card():
	if $CardImage.z_index == 1:
		get_node("CardFlip").play("card_flip")
		uncovered = true
		$SelectionBorder.visible = false
		
func choose_card():
	chosen = !chosen
	$ChooseCard.play()
	$SelectionBorder.visible = chosen
	
