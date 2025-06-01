extends Node2D

@onready var DEBT_TEXTURES = {
	"backend":"res://assets/technicaldebt_backend.png",
	"frontend":"res://assets/technicaldebt_frontend.png",
}

@onready var debt_reference = $TechnicalDebt
@onready var frontend_debt_for_this_round = 0
@onready var backend_debt_for_this_round = 0


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
	
	if area == "frontend":
		frontend_debt_for_this_round += amount
		
	if area == "backend":
		backend_debt_for_this_round += amount
		
	print("add_debt_effect", frontend_debt_for_this_round, backend_debt_for_this_round)

		
func calculate_needed_storypoints(area):
	var needed_storypoints = get_current_debt_from_area(area)
	return needed_storypoints
		
func get_current_debt_from_area(area):
	var current_debt = 0
	for debt in debt_reference.get_children():
		if debt.area == area:
			current_debt += 1
	return current_debt

func add_debt_after_iteration():
	for debt in frontend_debt_for_this_round:
		if frontend_debt_for_this_round > 0:
			spawn_debt("frontend")
		if frontend_debt_for_this_round < 0:
			remove_debt("frontend")
			
	for debt in backend_debt_for_this_round:
		if backend_debt_for_this_round > 0:
			spawn_debt("backend")
		if backend_debt_for_this_round < 0:
			remove_debt("backend")
	
	# reset for next iteration
	frontend_debt_for_this_round = 0
	backend_debt_for_this_round = 0
	
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
	
func calculate_and_add_technical_debt_after_iteration(choosen_cards):
	var frontend = 0
	var backend = 0
	for card in choosen_cards:
		if card.area == "backend" and card.count_for_debt_calculatiom == true:
			backend += 1
		if card.area == "frontend" and card.count_for_debt_calculatiom == true:
			frontend += 1
	
	if backend > 0:
		backend_debt_for_this_round += 1
	if frontend > 0:
		frontend_debt_for_this_round += 1
		
	print("calculate_and_add_technical_debt_after_iteration", frontend, backend)
	add_debt_after_iteration()

func remove_debt(area):
	var children = debt_reference.get_children()
	children.reverse()
	for child in children:
		if child.area == area:
			child.queue_free() # remove this debt
			break

func remove_debt_effect(effect_value):
	var amount = effect_value[0]
	var area = effect_value[1]
	
	if area == "frontend" and get_current_debt_from_area(area) >= 1:
		frontend_debt_for_this_round -= amount
		
	if area == "backend" and get_current_debt_from_area(area) >= 1:
		backend_debt_for_this_round -= amount
		
	print("remove_debt_effect", frontend_debt_for_this_round, backend_debt_for_this_round)
