extends Node2D
class_name Card

@export var on_card_grid = false
@export var uncovered = false
@export var chosen = false
@export var storypoints = null
@export var storypoint_or_debt = null
@export var cannot_be_unchosen = false
@export var type = null
@export var area = null
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
	get_node("CardFlip").play("card_flip")
	uncovered = true
	$SelectionBorder.visible = false
		
func back_flip_card():
	get_node("CardFlip").play_backwards("card_flip")
	uncovered = false
	
		
func choose_card():
	chosen = !chosen
	$ChooseCard.play()
	$SelectionBorder.visible = chosen
	
func use_new_texture(effect_value):
	var new_texture_path = effect_value[0]
	var new_storypoints = effect_value[1]
	
	get_node("CardImage").texture = load(new_texture_path)
	get_node("CardImage").scale = Vector2(0.3, 0.3)
	storypoints = new_storypoints
	
	
