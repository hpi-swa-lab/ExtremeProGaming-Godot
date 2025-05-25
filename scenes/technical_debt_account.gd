extends Node2D

@onready var DEBT_TEXTURES = {
	"backend":"res://assets/technicaldebt_backend.png",
	"frontend":"res://assets/techincaldebt_frontend.png",
}

@onready var debt_reference = $TechnicalDebt

func spawn_debt(area):
	var last_pos = get_valid_in_line_position()
	var debt_scene = preload("res://scenes/technical_debt.tscn")  
	var new_debt = debt_scene.instantiate()
	debt_reference.add_child(new_debt)
	new_debt.area = area
	new_debt.get_node("Sprite2D").texture = load(DEBT_TEXTURES[area]) 
	new_debt.get_node("Sprite2D").scale = Vector2(0.095, 0.095)
	new_debt.global_position = Vector2(last_pos.x + 100, last_pos.y)

func get_valid_in_line_position() -> Vector2:
	var position : Vector2
	var existing_debt = debt_reference.get_children()
	
	if existing_debt.size() == 0:
		position = debt_reference.global_position
	else:
		existing_debt.sort_custom(func(a, b):
			if a.position.y != b.position.y:
				return a.position.y < b.position.y
			return a.position.x < b.position.x
		)
		position = existing_debt[-1].global_position
	
	print(position)
	return position
	
func add_debt(effect_value):
	var amount = effect_value[0]
	var area = effect_value[1]
	for i in range(0,amount):
		spawn_debt(area)

func remove_debt(effect_value):
	var amount = effect_value[0]
	var area = effect_value[1]
	# search for first debt with that area
	var children = debt_reference.get_children()
	children.reverse()
	for child in children:
		if child.area == area:
			child.queue_free() # remove this debt
			break
			
func remove_technical_debt(card):
	if card.storypoint_or_debt == "debt":
		var children = debt_reference.get_children()
		children[-1].queue_free()
	card.storypoint_or_debt = null
