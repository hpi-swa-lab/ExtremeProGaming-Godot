# ExtremeProGaming-Godot

## Helpful Tutorials
- [General Godot Tutorial](https://www.youtube.com/watch?v=LOhfqjmasi0)
- [Godot Tutorial on Card Games](https://www.youtube.com/watch?v=2jMcuKdRh2w&list=PLNWIwxsLZ-LMYzxHlVb7v5Xo5KaUV7Tq1)

## Hosted Game
The Game can be tested [here](https://hpi-swa-lab.github.io/ExtremeProGaming-Godot/).

## Original
Game mechanics and game layout are based on the original [Extreme Pro-Gaming](https://github.com/LucPrestin/Extreme-Pro-gaming) by [Luc Prestin](https://github.com/LucPrestin).

## Architecture
```mermaid
---
title: ExtremeProGaming Architecture
---
classDiagram
	class Card{
	+String Type
	+flip()
	}
	class Feature
	class Event  
	class Bug
	Feature --|> Card
	Event --|> Card
	Bug --|> Card
	class Deck{
	+Int card_count
	+draw_card()
	}
	class FeatureDeck
	class EventDeck
	class BugDeck
	Deck <|-- FeatureDeck
	Deck <|-- EventDeck
	Deck <|-- BugDeck
	Deck "1" --> "n" Card : creates
	Deck --> "1" FeatureDatabase : loads
	Deck --> "1" EventDatabase : loads
	Deck --> "1" BugDatabase : loads
	class Supply{
	+List storypoints
	+available_storypoints()
	}
	class Storypoint{
	+Vector2 original_position
	}
	Supply "1" --> "n" Storypoint : contains
	class TechnicalDebtAccount{
	+List debt
	+spawn_debt(area)
	}
	class TechnicalDebt{
	+String area
	}
	TechnicalDebtAccount "1" --> "n" TechnicalDebt : contains
	class Slot{
	+List cards
	}
	CardSlot --|> Slot
	DiscardPile --|> Slot
	class GameStats{
	+Int iteration
	+Int features_frontend
	}
	class GameMonitor{
	+Int features_frontend
	}
	class Backlog{
	+List slots
	+get_next_free_slot()
	}
	Backlog "1" --> "9" CardSlot : contains
	class FeatureDatabase {
		<<database>>
		+Dict ALL_FEATURE_CARDS_TEXT
		+Dict ALL_FEATURE_CARDS_META
	}
	class EventDatabase {
		<<database>>
		+Dict ALL_EVENT_CARDS_TEXT
		+Dict ALL_EVENT_CARDS_BACK_META
	}
	class BugDatabase {
		<<database>>
		+Dict ALL_BUG_CARDS_TEXT
		+Dict ALL_BUG_CARDS_META
	}
	class GameRules
	GameRules "1" --> "1" GameStats : contains
	GameRules "1" --> "1" GameMonitor : contains
	GameRules "1" --> "1" Backlog : contains
	GameRules "1" --> "1" Supply : contains
	GameRules "1" --> "3" Deck : contains
	GameRules "1" --> "1" TechnicalDebtAccount : contains
	GameRules "1" --> "2" DiscardPile : contains

```
