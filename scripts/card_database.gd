const ALL_FEATURE_CARDS_META = { # storypoints, area, counts for debt calc, is start card, effect
	"Card0": [1,"backend", false, false, "unknown"],
	"Card1": [1,"backend", true, false, "unknown"],
	"Card2": [1,"backend", true, false, "unknown"],
	"Card3": [1,"frontend", true, false, "unknown"],
	"Card4": [1,"frontend", true, false, "unknown"],
	"Card5": [1,"frontend", true, false, "unknown"],
	"Card6": [1,"frontend", true, false, "negative"],
	"Card7": [1,"frontend", true, false, "negative"],
	"Card8": [1,"backend", false, false, "positive"],
	"Card9": [1,"frontend", true, false, "positive"],
	"Card10": [2,"backend", true, false, "unknown"],
	"Card11": [2,"frontend", true, true, "unknown"],
	"Card12": [2,"frontend", true, false, "unknown"],
	"Card13": [2,"backend", true, false, "negative"],
	"Card14": [2,"backend", true, false, "positive"],
	"Card15": [2,"backend", false, false, "positive"],
	"Card16": [2,"backend", false, false, "positive"],
	"Card17": [2,"frontend", true, false, "positive"],
	"Card18": [2,"frontend", true, false, "positive"],
	"Card19": [2,"frontend", true, false, "unknown"],
	"Card20": [3,"backend", true, true, "negative"],
	"Card21": [3,"backend", true, false, "negative"],
	"Card22": [3,"backend", true, true, "negative"],
	"Card23": [3,"frontend", true, false, "negative"],
	"Card24": [3,"frontend", true, false, "positive"],
	"Card25": [1,"frontend", true, false, "negative"],
	"Card26": [2,"backend", true, false, "unknown"]
}

const ALL_FEATURE_CARDS_TEXT = {
  "Card0": ["Fuzzy search über alle Berichte erlauben", "Das Feature hat ein veraltetes Feature ersetzt. Der Code ist dadurch deutlich schlanker geworden.", "Ein Technical Debt wird aus dem Backent entfernt. Diese Karte zählt nicht in die Berechnung des Techical Debts."],
  "Card1": ["Editieren eines Berichts soll den Autor anpassen", "Beim Implementieren dieses Features kamen dir neue Ideen.", "Dem Backlog wird 1 Feature hinzugefügt."],
  "Card2": ["E-Mails nur in einer Sprache schicken", "Das war eine kleine Aufgabe für dich, die jemand anders aber viel bedeutet. Aus diesem Wissen schöpft ihr Kraft.", "Ihr habt nur in der nächsten Iteration 1 Storypoint mehr zur Verfügung."],
  "Card3": ["Anpassbare Templates für Berichte hinzufügen", "Das Feature ist abgeschlossen, aber leider sind dir Fehler unterlaufen.", "Dem Backlog werden 2 Bugs hizugefügt."],
  "Card4": ["Automatisches Wechseln des Farbschemas", "Das Feature entpuppt sich als kompliziert, sodass ihr es mit in die nächste Iteration nehmt.", "Diese Karte kommt mit neuen Werten zurück in den Backlog und muss für die nächste Iteration gewählt werden."],
  "Card5": ["Statistiken in die Übersicht integrieren", "Heute bist du etwas unkonzentriert.", "1 Techinical Debt wird im Frontend hinzugefügt."],
  "Card6": ["Balkendiagramm für Ein- und Ausgaben je Kategorie", "Harald freut sich über das neue Feature und möchte es direkt weiterentwickelt sehen.", "Dem Backlog wird ein Feature hinzugefügt. Das neue Feature muss in der nächsten Iteration gewählt werden."],
  "Card7": ["Anpassungen an das Corporate Design", "Gerade als du hiermit fertig wurdest, meldet sich Mathilde mit Feedback.", "Dem Backlog wird 1 Bug hinzugefügt."],
  "Card8": ["Automatische Erinnerungen per E-Mail", "Gute Arbeit.", "Diese Karte zählt nicht in die Berechnung des Technical Debts."],
  "Card9": ["Alle Texte freundlicher machen", "Das war ein Feature was du schon lange bauen wolltest. Du freust dich sehr, es nun angegangen zu sein. Das ist echt gut für die Motivation.", "Ihr habt dauerhaft ein Storypoint mehr zur Verfügung."],
  "Card10": ["Anbindung an die Buchhaltungssoftware", "Sehr gut, ein weiteres Feature ist fertig. Da könnt ihr stolz drauf sein.", "Kein Effekt."],
  "Card11": ["Hinzufügen von Keyboard-Shortcuts", "Ihr hattet nach diesem Feature noch etwas Zeit und habt euch ans Refactoring gesetzt. Dabei wart ihr unkonzentriert, sodass Teile davon neu gemacht werden müssen.", "Ihr habt nur in der nächsten Iteration 1 Storypoint weniger. 1 Technical Debt wird aus dem Frontend entfernt."],
  "Card12": ["Icons für die wichtigsten Buttons hinzufügen", "Beim Abarbeiten dieses Features sind dir Fehler aufgefallen.", "1 Bug wird dem Backlog hinzugefügt."],
  "Card13": ["Verbessern der Performance des Import-parsers", "Beim Implementieren dieses Features hast du im Legacy-Code ein Problem gefunden.", "1 Bug wird dem Backlog hinzugefügt."],
  "Card14": ["Serverseitige Nutzungsstatistiken erfassen", "Während ihr dieses Feature implementiert habt kam Harald auf euch zu und hat euch neue IT-Ausstattung übergeben. Das macht euch in Zukunft die Arbeit leichter.", "Ihr habt dauerhaft 2 Storypoints mehr zur Verfügung."],
  "Card15": ["Model für Annotationen zu Berichten hinzufügen", "Dieses Feature integriert sich sehr gut in die existierende Codebasis.", "Diese Karte zählt nicht in die Berechnung des Techical Debts."],
  "Card16": ["pdf-Export von Berichten", "Dieses Feature war einfacher zu implementieren als erwartet. Die freie Zeit hast du genutzt, um ein wenig zu refactorn.", "1 Technical Debt wird aus dem Backend entfernt. Diese Karte zählt nicht in die Berechnung des Techical Debts."],
  "Card17": ["Nahtloser Wechsel zwischen Visualisierungen", "Beim Implementieren dieses Features ist euch Code aufgefallen, der nie genutzt wird. Nach Rücksprache mit dem Team hast du ihn entfernt.", "1 Technical Debt wird aus dem Frontend entfernt"],
  "Card18": ["Übersicht im Side-panel hinzufügen", "Dieses Feature zu bearbeiten ging schneller als erwartet. Entsprechend hast du die Zeit genutzt, weiterzuarbeiten.", "Ein Feature mit Kosten von 1 gilt als Implementiert. Es zählt aber in die Berechnung des Technical Debts."],
  "Card19": ["Neues Design der Suchfilter implementieren", "Während der Bearbeitung bemerkt ihr, dass ihr noch ein neues Design für eine Komponente braucht. Das UX-Team setzt sich dran.", "Diese Karte kommt zurück mit neuen Werten in den Backlog. Sie darf nächste Iteration nicht ausgewählt werden."],
  "Card20": ["Login-Schlüssel hashen", "Alle Teammitglieder haben einzeln an diesem Feature gearbeitet, ohne es zu kommunizieren. Entsprechend ist das Gesamtsystem Kraut und Rüben.", "1 Technical Debt wird im Backend hinzugefügt."],
  "Card21": ["Implementieren des Lebenszyklus von Berichten", "Als du gerade fertig warst, stürzt der Rechner ab und die Arbeit von heute ist vernichtet.", "Diese Karte wird mit neuen Werten zurück ins Backend gelegt."],
  "Card22": ["Migration der Datenbank auf das neue Schema", "Das Ticket war groß. Aber immerhin ist jetzt die Basisarbeit geleistet und ihr könnt coole neue Features oben drauf setzen. Der Kreativität sind keine Grenzen gesetzt.", "Dem Backlog wird 1 Feature hinzugefügt."],
  "Card23": ["Statistikanfragen für das Controlling ermöglichen", "Die Sicherheitsabteilung hat in diesem Feature ein Problem gefunden.", "Dem Backlog wird 1 Bug hinzugefügt."],
  "Card24": ["Onboarding-Tour für neue Nutzer:innen", "Das Feature war ein ganz schöner Brocken. Die Fertigstellung hat euch aber als Team zusammengeschweißt, sodass ihr besser arbeitet.", "Ihr habt dauerhaft 1 Storypoint mehr zur Verfügung."],
  "Card25": ["Einpflegen von Basisdaten", "Die Implementierung dieses Features hatte viel schnelles Tippen bedeutet, sodass jemand von euch mit einer Sehnenscheidenentzündung erst einmal ausfällt.", "Ihr habt dauerhaft 2 Storypoint weniger zur Verfügung."],
  "Card26": ["LDAP-Integration", "Für dieses Feature musstet ihr Shotgun Surgery betreiben: viele kleine Änderungen an vielen Stellen. Vielleicht wird es Zeit zu refactorn.", "1 Technical Debt im Frontend und Backend wird hinzugefügt."]
}

const ALL_FEATURE_CARDS_BACK_META = { 
	"Card0": [["remove_technical_debt",[1, "backend"]]],
	"Card1": [["features", 1]],
	"Card2": [["add_storypoints",[1, 1]]],
	"Card3": [["bugs",2]],
	"Card4": [["new_texture",["res://assets/cards/features/feature7_front_new.PNG", 3]],["must_choose", 0]], #####
	"Card5": [["add_technical_debt",[1, "frontend"]]],
	"Card6": [["features", 1], ["must_choose", 0]],
	"Card7": [["bugs",1]],
	"Card8": [],
	"Card9": [["add_storypoints",[1, 10000]]],
	"Card10": [],
	"Card11": [["remove_storypoints",[1, 1]], ["remove_technical_debt",[1, "frontend"]]],
	"Card12": [["bugs",1]],
	"Card13": [["bugs",1]],
	"Card14": [["add_storypoints",[1, 10000]]],
	"Card15": [],
	"Card16": [["remove_technical_debt",[1, "backend"]]],
	"Card17": [["remove_technical_debt",[1, "frontend"]]],
	"Card18": [], #####
	"Card19": [["new_texture",["res://assets/cards/features/feature7_front_new.PNG", 3]]], #####
	"Card20": [["add_technical_debt",[1, "backend"]]],
	"Card21": [["new_texture",["res://assets/cards/features/feature7_front_new.PNG", 3]]], #####
	"Card22": [["features", 1]],
	"Card23": [["bugs",1]],
	"Card24": [["add_storypoints",[1, 10000]]],
	"Card25": [["remove_storypoints",[2, 10000]]],
	"Card26": [["add_technical_debt",[1, "backend"]], ["add_technical_debt",[1, "frontend"]]],
}

const ALL_FEATURE_CARDS = { #front, back
	"frontend": ["res://assets/cards/features/feat_frontend_front.png","res://assets/cards/features/back_front.png"],
	"backend": ["res://assets/cards/features/feat_backend_front.png","res://assets/cards/features/back_back.png"],
	"positive":["res://assets/positive_effect.png"],
	"negative":["res://assets/negative_effect.png"],
	"unknown":["res://assets/unknown_effect.png"],
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
	"Event8": [["features",2], ["bugs",1]],
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
	"negative":["res://assets/negative_effect.png"],
	"unknown":["res://assets/unknown_effect.png"],
	}
	
const ALL_BUG_CARDS_TEXT = {
	"Bug0": ["Falscher Nutzername wird im Profil angezeigt", "Dieses Problem ist behoben, dafür bricht es an einer neuen Stelle auseinander.", "Dem Backlog wird 1 Bug hinzugefügt"],
	"Bug1": ["Export der Berichte zu Word funktioniert", "Ein Bug weniger. Herzlichen Glückwunsch.", "Kein Effekt."],
	"Bug2": ["Klartext-Passwort im Login-Form", "Dir kommt es vor als hättest du diesen Bug schon einmal repariert.", "Ist der Technical Debt in Frontend Technical Debt größer oder gleich zwei, lege diese Karte umgedreht zurück ins Backlog."],
	"Bug3": ["Passwortfehler bei erfolgreichem Login", "Endlich ist dieser Bug zu. Also auf zum nächsten Ticket. Manchmal fragst du dich, ob du überhaupt noch ein Mensch bist oder nur noch für anstehende Tickets existierst.", "Kein Effekt."],
	"Bug4": ["Löschen-Button löscht falschen Eintrag", "Diesen Bug hast du wie auf Autopilot repariert. Die Frage ist jetzt: weil er so einfach war oder weil du nicht ganz bei der Sache warst?", "Kein Effekt."],
	"Bug5": ["Icons skalieren nicht richtig", "Und ein weiteres Ticket abgeschlossen. Wunderbar!", "Kein Effekt."],
	"Bug6": ["Falsches Format in der Datenbank", "Irgendwie seid ihr gerade ganz schön fertig und braucht eine Pause", "Ihr habt nur in der nächsten Iteration 1 Storypoint weniger zur Verfügung."],
	"Bug7": ["Build schlägt wegen falschem Typen fehl", "Der Bug hat sich als schwerwiegender herausgestellt als erwartet.", "1 Techical Debt wird im Backend hinzugefügt und diese Karte kommt mit neuen werten zurück in den Backlog"],
	"Bug8": ["Alter Eintrag im 'new'-Formular", "It's not a bug, it's a feature. Ihr habt die ganze Arbeit umsonst gemacht. Hättet ihr das Feature mal dokumentiert. Dann wäre das nicht passiert.", "1 Techical Debt wird im Frontend hinzugefügt."],
	"Bug9": ["Verschwundene Daten wiederfinden", "Endlich ist dieser Bug gefixt. Das hat euch aber ganz schön geschlaucht, sodass ihr Urlaub braucht.", "Ihr habt nur in der nächsten Iteration 2 Storypoints weniger zur Verfügung."],
	"Bug10": ["Verwendung eines falschen Parsers", "Die Reparatur dieses Bugs hat zu neuer Motivation für schöne Architektur geführt.", "1 Technical Debt wird aus dem Backend entfernt."],
	"Bug11": ["Sensitive Informationen sind für alle sichtbar", "Den Bug zu finden war einfacher als angenommen. Das gibt dir neue Zuversicht in deine Fähigkeiten.", "Ihr habt nur in der nächsten Iteration 1 Storypoint mehr zur Verfügung."]
}
	
const ALL_BUG_CARDS_BACK_META = {
	"Bug0": [["bugs",1]],
	"Bug1": [],
	"Bug2": [],   ####
	"Bug3": [],
	"Bug4": [],
	"Bug5": [],
	"Bug6": [["remove_storypoints",[1, 1]]],
	"Bug7": [["new_texture",["res://assets/cards/features/feature7_front_new.PNG", 3]]], ####
	"Bug8": [["add_technical_debt",[1, "frontend"]]],
	"Bug9": [["remove_storypoints",[2, 1]]],
	"Bug10": [["remove_technical_debt",[1, "backend"]]],
	"Bug11": [["add_storypoints",[1, 1]]]
	}

const ALL_BUG_CARDS_META = { 	# storypoints, area, counts_for_debt, is_start_card, effect_tip
	"Bug0": [2, "frontend", false, true, "unknown"],
	"Bug1": [1, "backend", false, false, "unknown"],
	"Bug2": [1, "frontend", false, false, "unknown"],
	"Bug3": [1, "frontend", false, false, "unknown"],
	"Bug4": [1, "frontend", false, false, "unknown"],
	"Bug5": [2, "frontend", false, false, "unknown"],
	"Bug6": [3, "backend", false, false, "unknown"],
	"Bug7": [1, "backend", false, false, "negative"],
	"Bug8": [3, "frontend", false, false, "negative"],
	"Bug9": [3, "backend", false, false, "negative"],
	"Bug10": [1, "backend", false, false, "positive"],
	"Bug11": [3, "frontend", false, false, "positive"]
}
