extends Node2D
@export var playerID : int
@export var maxCardsInHand : int = 5
@export var PlayerDeck : Node2D
@export var Hand : Node2D
@export var Table : Node2D

func showHand():
	_moveToViewer()
	
	for slot in Hand.get_children():
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
		if PlayerDeck.get_child(i):
			PlayerDeck.get_child(i).reparent(Hand.get_node("Slot"+str(i)),false)
	#Currently doesn't check if there are already cards showing. Need to make this work properly

func _playCard():
	var foundCard = false
	var currentCard = null
	for slot in Hand.get_children():
		if slot.empty == false:
			if slot.get_child(0).is_in_group("Cards"):
				foundCard = true
				currentCard = slot.get_child(0)
		else:
			print("No card in slot!")
	
	if currentCard != null:
		print("Player "+str(playerID)+" plays "+ currentCard.Name)
		currentCard.reparent(Table.get_node(("Slot"+str(playerID))),false) #Slot corresponds to player ID
	else:
		print("No cards in hand!")

func _physics_process(delta):
	var action = "ui_accept"
	if playerID == 1:
		action = "ui_select"
	if Input.is_action_just_pressed(action):
		_playCard()
