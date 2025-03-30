extends Node2D
@export var playerID : int
@export var maxCardsInHand : int = 5
@export var Hand : Node2D
@export var CardViewer : Node2D

func showHand():
	_moveToViewer()
	
	for slot in CardViewer.get_children():
		if slot.get_child(0).is_in_group("Cards"):
			var card = slot.get_child(0)
			card.visible = true
			card.position = Vector2i(0,0)
		else:
			var defaultCard = Sprite2D.new()
			defaultCard.texture = load("res://assets/default_cards/back.png")
			slot.add_child(defaultCard) #primitive. show the back of card texture if no card in slot

func _moveToViewer():
	for i in range(0,maxCardsInHand):
		if Hand.get_child(i):
			Hand.get_child(i).reparent(CardViewer.get_node("Slot"+str(i)),false)
	#Currently doesn't check if there are already cards showing. Need to make this work properly
