extends Node2D

@onready var iteration = $Iteration
@onready var sp = $Storypoints
@onready var featuresfrontend = $FeaturesFrontend
@onready var featuresbackend = $FeaturesBackend
@onready var bugsfrontend = $BugsFrontend
@onready var bugsbackend = $BugsBackend
@onready var challenge = $Challenge

func _ready() -> void:
	challenge.visible = false

func update_game_stats(current_iteration, current_sp, current_featuresfrontend, current_featuresbackend, current_bugsfrontend, current_bugsbackend):
	iteration.text = "%d" % [current_iteration]
	sp.text = "%d" % [current_sp]
	featuresfrontend.text = "%d" % [current_featuresfrontend]
	featuresbackend.text = "%d" % [current_featuresbackend]
	bugsbackend.text = "%d" % [current_bugsfrontend]
	bugsfrontend.text = "%d" % [current_bugsbackend]
	challenge.update_game_stats(current_featuresfrontend + current_featuresbackend)

func show_challenge() -> void:
	challenge.visible = true
