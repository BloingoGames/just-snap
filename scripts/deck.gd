extends Node2D

@export var genericCards = Resource

func _ready() -> void:
	_initCards()
	
func _initCards():
	for card in genericCards.genericDeck: #genericCards is a .res resource just containing a dict with suit, pip and names for a full deck of 52 cards
		_generateCard(card["Suit"],card["Pip"],card["Name"])

func _generateCard(suit,pip,fancyName): #instantiate a generic card with the suit, pip and name given. This will be the standard deck
	var cardScene = load("res://scenes/card.tscn")
	var cardInstance = cardScene.instantiate()
	cardInstance.setParams(suit,pip,fancyName,Global.BloigoEffect1)
	add_child(cardInstance,true) #True forces a readable name in the Remote scene tree (e.g card1,card2)

func shuffle():
	print("shuffled")
	var noOfCards = get_child_count()
	for card in get_children():
		move_child(card,randi_range(0,noOfCards)) #Shuffle cards in scene tree
