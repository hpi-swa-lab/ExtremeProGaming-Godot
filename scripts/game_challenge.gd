extends Node2D

@onready var features = $Features

func update_game_stats(current_features):
	features.text = "%d" % [current_features] + " / 8"
