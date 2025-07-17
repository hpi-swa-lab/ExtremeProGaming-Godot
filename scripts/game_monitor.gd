extends Node2D

@onready var label = $GameNotifications

func generate_iteration_rules():
	label.text = ("GAME_HINT")

func generate_draw_event_rule():
	if not is_node_ready():
		await ready
	label.text = ("DRAW_EVENT_DESC")

func generate_refactor_rule():
	label.text = ("REFACTOR_HINT_CARD")

func generate_draw_feature_rule():
	label.text = ("DRAW_FEATURE_RULE")


func generate_effects_list(effects):
	var text = tr("EFFECT_DISPLAY_HEADER") + "\n"
	for effect in effects:
		await get_tree().create_timer(0.2).timeout
		var effect_name = effect[0]
		match effect_name:
			"if_frontend_debt_too_big":
				text += "• " + tr("FRONTEND_DEBT_BIG") + "\n"
			"back_to_backlog":
				text += "• " + tr("BACK_TO_BACKLOG") + "\n"
			"add_storypoints":
				text += "• " + tr("ADD_STORYPOINTS") + "\n"
			"remove_storypoints":
				text += "• " + tr("REMOVE_STORYPOINTS") + "\n"
			"half_storypoints":
				text += "• " + tr("HALF_STORYPOINTS") + "\n"
			"add_technical_debt":
				text += "• " + tr("ADD_TECHNICAL_DEBT") + "\n"
			"remove_technical_debt":
				text += "• " + tr("REMOVE_TECHNICAL_DEBT") + "\n"
			"remove_cheapest_feature":
				text += "• " + tr("REMOVE_CHEAPEST_FEATURE") + "\n"
			"cheap_feature_is_implemented":
				text += "• " + tr("IMPLEMENT_CHEAP_FEATURE") + "\n"
			"cannot_be_choosen":
				text += "• " + tr("CANNOT_BE_CHOSEN") + "\n"
			"goal":
				text += "• " + tr("REACH_GOAL") + "\n"
			"bugs":
				text += "• " + tr("DRAW_BUG") + "\n"
			"features":
				text += "• " + tr("DRAW_FEATURE") + "\n"
			"must_choose":
				text += "• " + tr("MUST_CHOOSE") + "\n"
			"new_values":
				text += "• " + tr("NEW_VALUES") + "\n"
			"prohibit_refactoring":
				text += "• " + tr("NO_REFACTOR") + "\n"
			_:
				push_warning("Unknown Effect: %s" % effect_name)
	label.text = text
