extends Node2D

func set_auto_sized_text(rich_text_label: RichTextLabel, text: String):
	var translation_key = text
	var translated_text = tr(translation_key)
		
	rich_text_label.text = translated_text
	rich_text_label.fit_content = false
	rich_text_label.scroll_active = false
	
	var text_length = translated_text.length()
	print(text_length)
	var font_size = 70
	if text_length > 90:
		font_size = 55
	
	rich_text_label.add_theme_font_size_override("normal_font_size", font_size)
