extends Node2D

var STORYPOINTS = 6
const STORYPOINTS_SCENE_PATH = "res://scenes/storypoint.tscn"
const MIN_DISTANCE = 50
const STORYPOINT_TEXTURES = {
	"turquoise":"res://assets/gummy_blue.png",
	"red":"res://assets/gummy_red.png"
}

@onready var storypoints_reference = $Storypoints

func _ready() -> void:
	spawn_storypoints_in_line(STORYPOINTS, "turquoise", 10000)

		
func change_storypoints(effect_value):
	var amount = effect_value[0]
	var self_destroy = effect_value[1]
	STORYPOINTS += amount
	if self_destroy > 1:
		spawn_storypoints_in_line(amount, "turquoise", self_destroy)
	else:
		spawn_storypoints_in_line(amount, "red", self_destroy)
		
func spawn_storypoints_in_line(amount, color, self_destroy):
	# get point where to start generation
	var position = get_valid_in_line_position()
	
	# generate storypoints
	var current_x = position.x + 55
	var fixed_y = position.y
	for i in amount:
		var storypoint_scene = preload(STORYPOINTS_SCENE_PATH)  
		var new_storypoint = storypoint_scene.instantiate()
		storypoints_reference.add_child(new_storypoint)
		new_storypoint.get_node("StorypointImage").texture = load(STORYPOINT_TEXTURES[color]) 
		new_storypoint.get_node("StorypointImage").scale = Vector2(0.01, 0.009)
		new_storypoint.global_position = Vector2(current_x, fixed_y)
		new_storypoint.original_position = new_storypoint.global_position
		new_storypoint.z_index = 2
		new_storypoint.self_destroy = self_destroy
		current_x += 55
		print(new_storypoint.global_position)
		
func get_valid_in_line_position() -> Vector2:
	var position : Vector2
	var existing_storypoints = storypoints_reference.get_children().filter(
	func(sp): return !sp.is_queued_for_deletion()
	)
	
	if existing_storypoints.size() == 0:
		position = storypoints_reference.global_position
	else:
		existing_storypoints.sort_custom(func(a, b):
			if a.position.y != b.position.y:
				return a.position.y < b.position.y
			return a.position.x < b.position.x
		)
		position = existing_storypoints[-1].global_position
	
	return position

func available_storypoints():
	var storypoints_in_supply = storypoints_reference.get_children()
	return storypoints_in_supply.size()
