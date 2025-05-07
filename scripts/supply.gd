extends Node2D

var STORYPOINTS = 6
const STORYPOINTS_SCENE_PATH = "res://scenes/storypoint.tscn"
const MIN_DISTANCE = 50

@onready var storypoints_reference = $Storypoints

func _ready() -> void:
	var positions := []

	for i in range(STORYPOINTS):
		var new_pos := get_valid_random_position(positions, MIN_DISTANCE)
		positions.append(new_pos)

		var storypoint_scene = preload(STORYPOINTS_SCENE_PATH)
		var new_storypoint = storypoint_scene.instantiate()
		new_storypoint.get_node("StorypointImage").scale = Vector2(0.01, 0.009)
		new_storypoint.position = new_pos
		new_storypoint.original_position = new_storypoint.global_position
		new_storypoint.z_index = 2
		storypoints_reference.add_child(new_storypoint)
		


func get_valid_random_position(existing_positions: Array, min_distance: float) -> Vector2:
	var area_node: Node = find_child("Area2D", false) 
	var shape = area_node.get_node("CollisionShape2D").shape
	var area_size = shape.extents * 2 # change if shape changes
	var margin = min_distance  # distance from edges

	# Shrink placement area by margin
	var usable_area_size = area_size - Vector2(margin * 2, margin * 2)
	var area_origin = area_node.position - area_size / 2 + Vector2(margin, margin)

	var max_attempts = 50
	for i in range(max_attempts):
		var random_pos = area_origin + Vector2(
			randf_range(0, usable_area_size.x),
			randf_range(0, usable_area_size.y)
		)

		var too_close := false
		for pos in existing_positions:
			if pos.distance_to(random_pos) < min_distance:
				too_close = true
				break

		if not too_close:
			return random_pos

	# Fallback (may overlap)
	return area_origin + Vector2(
		randf_range(0, usable_area_size.x),
		randf_range(0, usable_area_size.y)
	)
