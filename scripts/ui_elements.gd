extends Control

@onready var end_iteration_button = $EndIterationButton
@onready var darkened_background = $DarkenedBackground
const BUTTON_SCENE_PATH = "res://scenes/button.tscn"

func darken_background():
	darkened_background.visible = true
	darkened_background.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(darkened_background, "modulate:a", 0.8, 0.5)
	
func lighten_background():
	var tween = create_tween()
	tween.tween_property(darkened_background, "modulate:a", 0.0, 0.5)
	darkened_background.visible = false


func create_button(text: String, button_position: Vector2, button_position_z_index, button_name) -> Button:
	var button_scene = preload(BUTTON_SCENE_PATH)
	var button = button_scene.instantiate()
	button.name = button_name
	button.text = text
	button.size.x = 320
	button.size.y = 100
	button.add_theme_font_size_override("font_size", 40)
	button.z_index = button_position_z_index
	button.position = button_position
	add_child(button)
	return button

func remove_understood_event_button():
	var button_to_remove = get_node("UnderstoodEventButton")
	button_to_remove.queue_free()

func remove_start_new_iteration_button():
	var button_to_remove = get_node("StartNewIterationButton")
	button_to_remove.queue_free()
