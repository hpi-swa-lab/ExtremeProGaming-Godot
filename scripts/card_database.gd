const ALL_FEATURE_CARDS_META = { # storypoints, area, counts for debt calc, is start card, effect
	"Card0": [2,"frontend", true, true, "positive"],
	"Card1": [1,"backend", false, false, "positive"],
	"Card2": [2,"frontend", true, true, "positive"],
	"Card3": [1,"backend", true, false, "positive"],
	"Card4": [1,"frontend", true, false, "positive"],
	"Card5": [1,"backend", false, false, "positive"],
	"Card6": [1,"frontend", true, false, "positive"],
	"Card7": [3,"backend", true, false, "positive"],
	"Card8": [3,"backend", true, false, "positive"]
}

const ALL_FEATURE_CARDS_TEXT = { #front, back, effect
	"Card0": ["Anbindung an die Buchhaltungssoftware", "This is the back", "This is the effect"],
	"Card1":["This is card 1", "This is the back", "test"],
	"Card2": ["This is card 2", "This is the back", "test"],
	"Card3": ["This is card 3", "This is the back", "test"],
	"Card4": ["This is card 4", "This is the back", "test"],
	"Card5":["This is card 5", "This is the back", "test"],
	"Card6": ["This is card 6", "This is the back", "test"],
	"Card7": ["This is card 7", "This is the back", "test"],
	"Card8": ["This is card 8", "This is the back", "test"]
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

const ALL_FEATURE_CARDS = { #front, back
	"frontend": ["res://assets/cards/features/feat_frontend_front.png","res://assets/cards/features/back_front.png"],
	"backend": ["res://assets/cards/features/feat_backend_front.png","res://assets/cards/features/back_back.png"],
	"positive":["res://assets/positive_effect.png"],
	"negative":["res://assets/positive_effect.png"],
	"unknown":["res://assets/positive_effect.png"],
	}
	
const ALL_EVENT_CARDS = { #front, back
	"front": ["res://assets/cards/events/event_front.png"],
	"back": ["res://assets/cards/events/event_back.png"],
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
	"Event8": [["features",1], ["bugs",1]],
	}

const ALL_EVENT_CARDS_TEXT = { # front, back, effect
	"Event0": ["Startschwierigkeiten", "Die IT-Abteilung hat es noch nicht geschafft, den GitLab-Zugriff für euch alle freizuschalten. Das wird aber bald passieren.", "Ihr habt nur in dieser Iteration 2 Storypoints weniger zur Verfügung."],
	"Event1": ["Die Herausforderung", "Harald möchte wissen aus welchem Holz ihr geschnitzt seid.", "Schafft ihr es bis zum Beginn von Iteration 5 insgesamt 8 Features bearbeitet zu haben, erhaltet ihr dauerhaft 2 Storypoints."],
	"Event2": ["Das Kundengespräch", "Sabine hat wieder mit Mark gesprochen. Unter Zeitdruck konnte sie leider nicht nein sagen.", "Dem Backlog werden 2 Features hinzugefügt."],
	"Event3": ["Ein frischer Wind", "Die Firma hat ein Sommerfest veranstaltet, was euch neue Energie gibt.", "Ihr habt dauerhaft 2 Storypoints mehr zur Verfügung."],
	"Event4": ["Die Verschnaufspause", "Nach einer kurzen Pause am Kicker geht ihr mit vollem Elan zurück an die Arbeit.", "Ihr habt nur in dieser Iteration 2 Storypoints mehr zur Verfügung."],
	"Event5": ["Unerwartete Probleme", "Aufgrund von Budgetkürzungen müssen Mitarbeiter:innen entlassen werden.", "Ihr habt dauerhaft nur noch die Hälfte (aufgerundet) der aktuellen Storypoints zur Verfügung."],
	"Event6": ["Unmut im Team", "Harald hat heute einen sehr schlechten Tag, sodass er in Sachen Planning nicht mit sich reden lässt.", "Ihr dürft diese Iteration nicht refactorn."],
	"Event7": ["Mark im Glück", "Mark ist sehr zufrieden mit euch und hat seine Prioritäten überdacht.", "Das Feature mit den geringsten Kosten wird aus dem Backlog entfernt. Das weggelegte Feature zählt nicht für die Berechnung des Technical Debt."],
	"Event8": ["Fast geschafft ...", "Ihr seid kurz vor dem Release. Da wird wohl leider ein Crunch nötig.", "Dem Backlog werden 1 Bug und 2 Features hinzugefügt."]
}
	
const ALL_BUG_CARDS = { #front, back
	"frontend": ["res://assets/cards/bugs/bug_frontend_front.png", "res://assets/cards/features/back_front.png"],
	"backend": ["res://assets/cards/bugs/bug_backend_front.png", "res://assets/cards/features/back_back.png"],
	"positive":["res://assets/positive_effect.png"],
	"negative":["res://assets/positive_effect.png"],
	"unknown":["res://assets/positive_effect.png"],
	}
	
const ALL_BUG_CARDS_TEXT = { #front, back, effect
	"Bug0": ["Anbindung an die Buchhaltungssoftware", "This is the back", "This is the effect"],
	"Bug1":["This is card 1", "This is the back", "test"],
	"Bug2": ["This is card 2", "This is the back", "test"],
	"Bug3": ["This is card 3", "This is the back", "test"],
	"Bug4": ["This is card 4", "This is the back", "test"],
	"Bug5":["This is card 5", "This is the back", "test"],
	"Bug6": ["This is card 6", "This is the back", "test"],
	"Bug7": ["This is card 7", "This is the back", "test"],
	"Bug8": ["This is card 8", "This is the back", "test"]
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
	"Bug0": [2,"frontend", true, true, "positive"],
	"Bug1": [1,"backend", true, false, "positive"],
	"Bug2": [2,"frontend", true, false, "positive"],
	"Bug3": [1,"backend", true, false, "positive"],
	"Bug4": [2,"frontend", true, false, "positive"],
	"Bug5": [1,"backend", true, false, "positive"],
	"Bug6": [2,"frontend", true, false, "positive"],
	"Bug7": [1,"backend", true, false, "positive"],
	"Bug8": [2,"frontend", true, false, "positive"]
}
	
	# back_to_backlog, technical debt, storypoints
