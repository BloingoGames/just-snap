extends Node2D
@export var playerID : int
@export var maxCardsInHand : int = 5
@export var PlayerDeck : Node2D
@export var Hand : Node2D
@export var Table : Node2D

func showHand():
	_moveToViewer()
	
	for slot in Hand.get_children():
		if slot.getCard().is_in_group("Cards"):
			var card = slot.getCard()
		else:
			var defaultCard = Sprite2D.new()
			defaultCard.texture = load("res://assets/default_cards/back.png")
			slot.add_child(defaultCard) #primitive. show the back of card texture if unknown card in slot

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
			if slot.getCard().is_in_group("Cards"):
				foundCard = true
				currentCard = slot.getCard()
	
	if currentCard != null:
		print("Player "+str(playerID)+" plays "+ currentCard.Name)
		currentCard.reparent(Table.get_node(("Slot"+str(playerID))),false) #Slot corresponds to player ID
	else:
		print("No cards in hand!")
		
func _replenishHand():
	if PlayerDeck.get_child_count() > 0: #If deck has cards
		var cardsInHand = _countCards()
		if cardsInHand < maxCardsInHand: #if cards not maxed out
			var slot = Hand.get_node("Slot"+str(cardsInHand))
			if slot.empty:
				PlayerDeck.get_child(0).reparent(slot,false) #Move card on top of deck to hand
				print("Added card to slot "+str(cardsInHand))
			else:
				print("Tried to add card to slot "+str(cardsInHand)+", but full!")

func _countCards():
	var count = 0
	for slot in Hand.get_children():
		if slot.empty == false:
			count += 1 #Count each non-empty slot
	return count

func _physics_process(delta):
	var playButton = "ui_accept"
	var replenButton = "ui_left"
	if playerID == 1:
		playButton = "ui_select"
		replenButton = "ui_right" #these are all for testing only.
	if Input.is_action_just_pressed(playButton):
		_playCard()
	if Input.is_action_just_pressed(replenButton):
		_replenishHand()
