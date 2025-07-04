const ALL_BUG_CARDS = { #front, back
	"frontend": ["res://assets/cards/bug_frontend_front.png", "res://assets/cards/back_front.png"],
	"backend": ["res://assets/cards/bug_backend_front.png", "res://assets/cards/back_back.png"],
	"positive":["res://assets/cards/positive_effect.png"],
	"negative":["res://assets/cards/negative_effect.png"],
	"unknown":["res://assets/cards/unknown_effect.png"],
	}

const ALL_BUG_CARDS_TEXT = {
	"Bug0": ["BUG0_FRONT", "BUG0_BACK", "BUG0_EFFECT"],
	"Bug1": ["BUG1_FRONT", "BUG1_BACK", "BUG1_EFFECT"],
	"Bug2": ["BUG2_FRONT", "BUG2_BACK", "BUG2_EFFECT"],
	"Bug3": ["BUG3_FRONT", "BUG3_BACK", "BUG3_EFFECT"],
	"Bug4": ["BUG4_FRONT", "BUG4_BACK", "BUG4_EFFECT"],
	"Bug5": ["BUG5_FRONT", "BUG5_BACK", "BUG5_EFFECT"],
	"Bug6": ["BUG6_FRONT", "BUG6_BACK", "BUG6_EFFECT"],
	"Bug7": ["BUG7_FRONT", "BUG7_BACK", "BUG7_EFFECT"],
	"Bug8": ["BUG8_FRONT", "BUG8_BACK", "BUG8_EFFECT"],
	"Bug9": ["BUG9_FRONT", "BUG9_BACK", "BUG9_EFFECT"],
	"Bug10": ["BUG10_FRONT", "BUG10_BACK", "BUG10_EFFECT"],
	"Bug11": ["BUG11_FRONT", "BUG11_BACK", "BUG11_EFFECT"]
}
	
const ALL_BUG_CARDS_BACK_META = {
	"Bug0": [["bugs",1]],
	"Bug1": [],
	"Bug2": [["if_frontend_debt_too_big", 2]],
	"Bug3": [],
	"Bug4": [],
	"Bug5": [],
	"Bug6": [["remove_storypoints",[1, 1]]],
	"Bug7": [["add_technical_debt",[1, "backend"]],["new_values",3], ["back_to_backlog", 0]],
	"Bug8": [["add_technical_debt",[1, "frontend"]]],
	"Bug9": [["remove_storypoints",[2, 1]]],
	"Bug10": [["remove_technical_debt",[1, "backend"]]],
	"Bug11": [["add_storypoints",[1, 1]]]
	}

const ALL_BUG_CARDS_META = { 	# storypoints, area, counts_for_debt, is_start_card, effect_tip
	"Bug0": [2, "frontend", true, true, "unknown"],
	"Bug1": [1, "backend", true, false, "unknown"],
	"Bug2": [1, "frontend", true, false, "unknown"],
	"Bug3": [1, "frontend", true, false, "unknown"],
	"Bug4": [1, "frontend", true, false, "unknown"],
	"Bug5": [2, "frontend", true, false, "unknown"],
	"Bug6": [3, "backend", true, false, "unknown"],
	"Bug7": [1, "backend", true, false, "negative"],
	"Bug8": [3, "frontend", true, false, "negative"],
	"Bug9": [3, "backend", true, false, "negative"],
	"Bug10": [1, "backend", false, false, "positive"],
	"Bug11": [3, "frontend", true, false, "positive"]
}
