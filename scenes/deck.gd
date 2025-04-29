extends Node2D

const CARD_COUNT = 9
const CARD_SCENE_PATH = "res://scenes/card.tscn"
var CARDS_IN_DECK = []

@onready var card_grid_reference = $"../CardGrid"
@onready var card_database_reference = preload("res://scripts/card_database.gd")


func _ready() -> void:
	var card_names = card_database_reference.ALL_CARDS.keys()
	card_names.shuffle()
	var selected_names = card_names.slice(0, CARD_COUNT)

	for name in selected_names:
		var card_scene = preload(CARD_SCENE_PATH)
		var new_card = card_scene.instantiate()
		
		new_card.name = name
		var new_card_image_path = card_database_reference.ALL_CARDS[name]
		new_card.get_node("CardImage").texture = load(new_card_image_path)
		new_card.get_node("CardImage").scale = Vector2(0.3, 0.28)
		new_card.position = get_node("Area2D").position 
		self.add_child(new_card)
		CARDS_IN_DECK.append(new_card)
	
func _input(event):
	if event is InputEventMouseButton:
		var card = raycast_check_for_card()
		if card and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and not card.uncovered:
				if card.on_card_grid:
					card.flip_card()
				else:
					draw_card()
				

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	else:
		return null
	
func draw_card():
	print("draw card")
	
	var card_drawn = CARDS_IN_DECK[0]
	CARDS_IN_DECK.erase(card_drawn)
	
	if CARDS_IN_DECK.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		
	# get card to card_slot
	var deck = get_parent()
	var next_free_card_slot = card_grid_reference.get_next_free_card_slot()
	if next_free_card_slot:
		print(typeof(card_drawn),typeof(next_free_card_slot) )
		card_drawn.global_position = next_free_card_slot.position
		next_free_card_slot.card_in_slot = true
		card_drawn.on_card_grid = true
	else:
		pass
		
