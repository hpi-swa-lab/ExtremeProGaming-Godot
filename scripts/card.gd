extends Node2D
class_name Card

@export var on_card_grid = false
@export var uncovered = false
@export var chosen = false
@export var storypoints = null
@export var cannot_be_unchosen = false
@export var type = null
@export var is_start_card = false
@export var area = null
@export var effects = []
@export var count_for_debt_calculation = null
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
		
func back_flip_card():
	get_node("CardFlip").play_backwards("card_flip")
	uncovered = false
	
		
func choose_card():
	chosen = !chosen
	$ChooseCard.play()
	
func use_new_texture(effect_value):
	var new_texture_path = effect_value[0]
	var new_storypoints = effect_value[1]
	
	get_node("CardImage").texture = load(new_texture_path)
	storypoints = new_storypoints
	
	
