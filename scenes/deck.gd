extends Node2D

@export var genericCards = Resource

func _ready() -> void:
	_initCards()
	
func _initCards():
	for card in genericCards.genericDeck:
		_generateCard(card["Suit"],card["Pip"],card["Name"])

func _generateCard(suit,pip,fancyName):
	var cardScene = load("res://scenes/card.tscn")
	var cardInstance = cardScene.instantiate()
	cardInstance.setParams(suit,pip,fancyName)
	add_child(cardInstance)
