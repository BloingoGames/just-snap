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
		else:
			var defaultCard = Sprite2D.new()
			defaultCard.texture = load("res://assets/default_cards/back.png")
			slot.add_child(defaultCard) #primitive. show the back of card texture if no card in slot

func _moveToViewer():
	for i in range(0,maxCardsInHand):
		if PlayerDeck.get_child(i):
			var currentCard = PlayerDeck.get_child(i)
			currentCard.reparent(Hand.get_node("Slot"+str(i)),false)
			
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
		
func _replenishHand():
	if PlayerDeck.get_child(0):
		var cardsInHand = _countCards()
		PlayerDeck.get_child(0).reparent(Hand.get_node("Slot"+str(cardsInHand)),false)
		print("Added card to slot"+str(cardsInHand))

func _countCards():
	var count = 0
	for slot in Hand.get_children():
		if slot.empty == false:
			count += 1
	return count

var flipFlop = 0

func _physics_process(delta):
	var action = "ui_accept"
	if playerID == 1:
		action = "ui_select"
	if Input.is_action_just_pressed(action):
		if flipFlop == 0:
			_playCard()
			flipFlop = 1
		else:
			_replenishHand()
			flipFlop = 0
