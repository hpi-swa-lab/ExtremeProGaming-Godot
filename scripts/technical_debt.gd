extends Node2D
class_name TechnicalDebt

@export var area = null
@export var to_be_refactored = false
@onready var storypoints_reference = $Storypoint


func highlight(state):
	get_node("SelectionBorder").visible = state
