extends Node

const ALL_EVENT_CARDS = { #front, back
	"front": ["res://assets/cards/event_front.png"],
	"back": ["res://assets/cards/event_back.png"],
	}
	
const ALL_EVENT_CARDS_BACK_META = {
	"Event0": [["remove_storypoints",[2, 1]]],
	"Event1": [["goal",1]],
	"Event2": [["features",2]],
	"Event3": [["add_storypoints",[2, 10000]]],
	"Event4": [["add_storypoints",[2, 1]]],
	"Event5": [["half_storypoints", 10000]],
	"Event6": [["prohibit_refactoring", 1]],
	"Event7": [["remove_cheapest_feature", 1]],
	"Event8": [["features",2], ["bugs",1]],
	}

const ALL_EVENT_CARDS_TEXT = {
	"Event0": ["EVENT0_FRONT", "EVENT0_BACK", "EVENT0_EFFECT"],
	"Event1": ["EVENT1_FRONT", "EVENT1_BACK", "EVENT1_EFFECT"],
	"Event2": ["EVENT2_FRONT", "EVENT2_BACK", "EVENT2_EFFECT"],
	"Event3": ["EVENT3_FRONT", "EVENT3_BACK", "EVENT3_EFFECT"],
	"Event4": ["EVENT4_FRONT", "EVENT4_BACK", "EVENT4_EFFECT"],
	"Event5": ["EVENT5_FRONT", "EVENT5_BACK", "EVENT5_EFFECT"],
	"Event6": ["EVENT6_FRONT", "EVENT6_BACK", "EVENT6_EFFECT"],
	"Event7": ["EVENT7_FRONT", "EVENT7_BACK", "EVENT7_EFFECT"],
	"Event8": ["EVENT8_FRONT", "EVENT8_BACK", "EVENT8_EFFECT"]
}
