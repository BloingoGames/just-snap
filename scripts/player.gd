extends Node2D
@export var playerID : int
@export var maxCardsInHand : int = 5
@export var Hand : Node2D
@export var CardViewer : Node2D

func showHand():
	_moveToViewer()
	
	for card in CardViewer.get_children():
		card.visible = true
		card.position = Vector2i(0,0)

func _moveToViewer():
	for i in range(0,maxCardsInHand):
		if Hand.get_child(i):
			Hand.get_child(i).reparent(CardViewer,false)
