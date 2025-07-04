extends Control
@onready var language_selector = $LanguageSelector

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/story.tscn")

var languages = {
	"Deutsch": "de",
	"English": "en"
}

func _ready():
	for lang_name in languages.keys():
		language_selector.add_item(lang_name)
	
	# Set current language as selected
	var current_locale = TranslationServer.get_locale()
	var index = languages.values().find(current_locale)
	if index != -1:
		language_selector.select(index)

	language_selector.connect("item_selected", _on_language_selected)

func _on_language_selected(index):
	var lang_code = languages.values()[index]
	TranslationServer.set_locale(lang_code)
	get_tree().reload_current_scene()
