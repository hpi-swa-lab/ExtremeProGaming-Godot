const ALL_FEATURE_CARDS_META = { # storypoints, area, counts for debt calc, is start card
	"Card0": [2,"frontend", true, true],
	"Card1": [1,"backend", false, false],
	"Card2": [2,"frontend", true, true],
	"Card3": [1,"backend", true, false],
	"Card4": [1,"frontend", true, false],
	"Card5": [1,"backend", false, false],
	"Card6": [1,"frontend", true, false],
	"Card7": [3,"backend", true, false],
	"Card8": [3,"backend", true, false]
}

const ALL_FEATURE_TEXT = {
	"Card0": ["This is card 0", "This is the back"],
	"Card1":["This is card 1", "This is the back"],
	"Card2": ["This is card 2", "This is the back"],
	"Card3": ["This is card 3", "This is the back"],
	"Card4": ["This is card 4", "This is the back"],
	"Card5":["This is card 5", "This is the back"],
	"Card6": ["This is card 6", "This is the back"],
	"Card7": ["This is card 7", "This is the back"],
	"Card8": ["This is card 8", "This is the back"]
}

const ALL_FEATURE_CARDS_BACK_META = {
	"Card0": [["bugs",1]],
	"Card1": [["remove_technical_debt",[1, "backend"]]],
	"Card2": [["bugs",1]],
	"Card3": [["add_storypoints",[1, 1]]],
	"Card4": [["new_texture",["res://assets/cards/features/feature7_front_new.PNG", 3]],["must_choose", 0]],
	"Card5": [["remove_technical_debt",[1, "backend"]]],
	"Card6": [["add_storypoints",[1, 10000]]],
	"Card7": [["add_technical_debt",[1, "backend"]]],
	"Card8": [["features", 1]]}

const ALL_FEATURE_CARDS = {
	"Card0": ["res://assets/cards/features/feature1_front.PNG","res://assets/cards/features/feature1_back.PNG"],
	"Card1": ["res://assets/cards/features/feature8_front.PNG","res://assets/cards/features/feature8_back.PNG"],
	"Card2": ["res://assets/cards/features/feature1_front.PNG","res://assets/cards/features/feature1_back.PNG"],
	"Card3": ["res://assets/cards/features/feature2_front.PNG","res://assets/cards/features/feature2_back.PNG"],
	"Card4": ["res://assets/cards/features/feature7_front.PNG","res://assets/cards/features/feature7_back.PNG"],
	"Card5": ["res://assets/cards/features/feature6_front.PNG","res://assets/cards/features/feature6_back.PNG"],
	"Card6": ["res://assets/cards/features/feature3_front.PNG","res://assets/cards/features/feature3_back.PNG"],
	"Card7": ["res://assets/cards/features/feature5_front.PNG","res://assets/cards/features/feature5_back.PNG"],
	"Card8": ["res://assets/cards/features/feature4_front.PNG","res://assets/cards/features/feature4_back.PNG"]
	}
	
const ALL_EVENT_CARDS = {
	"Event0": ["res://assets/cards/events/event1.PNG","res://assets/cards/events/event1_back.PNG"],
	"Event1": ["res://assets/cards/events/event2.PNG","res://assets/cards/events/event2_back.PNG"],
	"Event2": ["res://assets/cards/events/event3.PNG","res://assets/cards/events/event3_back.PNG"],
	"Event3": ["res://assets/cards/events/event1.PNG","res://assets/cards/events/event1_back.PNG"],
	"Event4": ["res://assets/cards/events/event2.PNG","res://assets/cards/events/event2_back.PNG"],
	"Event5": ["res://assets/cards/events/event3.PNG","res://assets/cards/events/event3_back.PNG"],
	"Event6": ["res://assets/cards/events/event1.PNG","res://assets/cards/events/event1_back.PNG"],
	"Event7": ["res://assets/cards/events/event2.PNG","res://assets/cards/events/event2_back.PNG"],
	"Event8": ["res://assets/cards/events/event3.PNG","res://assets/cards/events/event3_back.PNG"]
	}
	
const ALL_EVENT_CARDS_BACK_META = {
	"Event0": [["features",2]],
	"Event1": [["goal",1]],
	"Event2": [["remove_storypoints",[2, 1]]],
	"Event3": [["half_storypoints", 10000]],
	"Event4": [["add_storypoints",[2, 1]]],
	"Event5": [["add_storypoints",[2, 10000]]],
	"Event6": [["features",1], ["bugs",1]],
	"Event7": [["remove_cheapest_feature", 1]],
	"Event8": [["prohibit_refactoring", 1]]
	}
	
const ALL_BUG_CARDS = {
	"Bug0": ["res://assets/cards/bugs/bug1_front.PNG","res://assets/cards/bugs/bug1_back.PNG"],
	"Bug1": ["res://assets/cards/bugs/bug2_front.PNG","res://assets/cards/bugs/bug2_back.PNG"],
	"Bug2": ["res://assets/cards/bugs/bug1_front.PNG","res://assets/cards/bugs/bug1_back.PNG"],
	"Bug3": ["res://assets/cards/bugs/bug2_front.PNG","res://assets/cards/bugs/bug2_back.PNG"],
	"Bug4": ["res://assets/cards/bugs/bug1_front.PNG","res://assets/cards/bugs/bug1_back.PNG"],
	"Bug5": ["res://assets/cards/bugs/bug2_front.PNG","res://assets/cards/bugs/bug2_back.PNG"],
	"Bug6": ["res://assets/cards/bugs/bug1_front.PNG","res://assets/cards/bugs/bug1_back.PNG"],
	"Bug7": ["res://assets/cards/bugs/bug2_front.PNG","res://assets/cards/bugs/bug2_back.PNG"],
	"Bug8": ["res://assets/cards/bugs/bug1_front.PNG","res://assets/cards/bugs/bug1_back.PNG"]
	}
	
const ALL_BUG_CARDS_BACK_META = {
	"Bug0": [["bugs",1]],
	"Bug1": [],
	"Bug2": [["bugs",1]],
	"Bug3": [],
	"Bug4": [["bugs",1]],
	"Bug5": [],
	"Bug6": [["bugs",1]],
	"Bug7": [],
	"Bug8": [["bugs",1]]
	}

const ALL_BUG_CARDS_META = {
	"Bug0": [2,"frontend", true, true], #[Storypoints]
	"Bug1": [1,"backend", true, false],
	"Bug2": [2,"frontend", true, false],
	"Bug3": [1,"backend", true, false],
	"Bug4": [2,"frontend", true, false],
	"Bug5": [1,"backend", true, false],
	"Bug6": [2,"frontend", true, false],
	"Bug7": [1,"backend", true, false],
	"Bug8": [2,"frontend", true, false]
}
	
	# back_to_backlog, technical debt, storypoints
