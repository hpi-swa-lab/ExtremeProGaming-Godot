extends Node2D

@onready var DEBT_TEXTURES = {
	"frontend":"res://assets/technicaldebt_frontend.png",
	"backend":"res://assets/techincaldebt_backend.png",
}

@onready var debt_reference = $TechnicalDebt

func spawn_debt(type):
	var last_pos = get_valid_in_line_position()
	var debt_scene = preload("res://scenes/technical_debt.tscn")  
	var new_debt = debt_scene.instantiate()
	debt_reference.add_child(new_debt)
	new_debt.get_node("Sprite2D").texture = load(DEBT_TEXTURES[type]) 
	#new_debt.get_node("Sprite2D").scale = Vector2(0.01, 0.009)
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
