extends Node2D

@onready var DEBT_TEXTURES = {
	"backend":"res://assets/technicaldebt_backend.png",
	"frontend":"res://assets/technicaldebt_frontend.png",
}

@onready var debt_reference = $TechnicalDebt


func spawn_debt(area):
	var debt_scene = preload("res://scenes/technical_debt.tscn")  
	var new_debt = debt_scene.instantiate()
	debt_reference.add_child(new_debt)
	new_debt.area = area
	new_debt.get_node("Sprite2D").texture = load(DEBT_TEXTURES[area]) 
	new_debt.get_node("Sprite2D").scale = Vector2(0.095, 0.095)
	new_debt.global_position = get_valid_in_line_position()

func get_valid_in_line_position() -> Vector2:
	var existing_debt = debt_reference.get_children()
	
	if existing_debt.size() == 0:
		return debt_reference.global_position
	
	existing_debt.sort_custom(func(a, b):
		if a.position.y != b.position.y:
			return a.position.y < b.position.y
		return a.position.x < b.position.x
	)
	
	# Check for gaps between existing debt
	for i in range(existing_debt.size() - 1):
		var current_pos = existing_debt[i].global_position
		var next_pos = existing_debt[i + 1].global_position
		var expected_next_x = current_pos.x + 100
		
		# if gap found
		if next_pos.x > expected_next_x:
			return Vector2(expected_next_x, current_pos.y)
	
	# No gaps found
	var last_position = existing_debt[-1].global_position
	return Vector2(last_position.x + 100, last_position.y)
	
func add_debt_effect(effect_value):
	var amount = effect_value[0]
	var area = effect_value[1]
	for i in range(0,amount):
		spawn_debt(area)
		
func calculate_needed_storypoints(area):
	var needed_storypoints = 0
	if debt_reference.get_children() == null:
		return needed_storypoints
	for debt in debt_reference.get_children():
		if debt.area == area:
			needed_storypoints += 1
			
	return needed_storypoints
		
	
		
func add_debt_after_round(needed_debt):
	var frontend = needed_debt["frontend"]
	var backend = needed_debt["backend"]
	if backend > 0:
		spawn_debt("backend")
	if frontend > 0:
		spawn_debt("frontend")
	
func remove_refactored_debt():
	var debt_to_be_removed = get_all_debt_selected_for_refactoring()
	for debt in debt_to_be_removed:
		debt.queue_free()
		
func no_debt_selected():
	var selected_debt = get_all_debt_selected_for_refactoring()
	return selected_debt.size() 
		
func get_all_debt_selected_for_refactoring():
	var refactored_debt = []

	for child in debt_reference.get_children():
		if child.to_be_refectored:
			refactored_debt.append(child)

	return refactored_debt
	
func get_currently_refactored_debt_for_area(area):
	var refactored_debt = []

	for child in debt_reference.get_children():
		if child.to_be_refectored and child.area == area:
			refactored_debt.append(child)

	return refactored_debt.size()

func remove_debt_effect(effect_value):
	var amount = effect_value[0]
	var area = effect_value[1]
	# search for first debt with that area
	var children = debt_reference.get_children()
	children.reverse()
	for child in children:
		if child.area == area:
			child.queue_free() # remove this debt
			break
