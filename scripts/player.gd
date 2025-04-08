extends Node2D

signal turn_finished

@export var playerID : int
@export var playerName : String = "Player"
@export var maxCardsInHand : int = 5
@export var PlayerDeck : Node2D
@export var Hand : Node2D
@export var Table : Node2D

@onready var playerUI = $PlayerUI # Player scene's UI container reference

var score : int = 0

var is_active_turn = false

func update_player_ui():
	var nameLabel = playerUI.get_node("NameLabel")
	var scoreLabel = playerUI.get_node("ScoreLabel")

	nameLabel.text = playerName
	scoreLabel.text = "Score: " + str(score)

	# highlight player's UI on their turn
	if is_active_turn:
		playerUI.modulate = Color(1, 1, 0)
	else:
		playerUI.modulate = Color(1, 1, 1)

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

func _playCard():
	# only active player allowed
	if not is_active_turn:
		print("No, not your turn, player " + str(playerID) + "! Play properly or we're going home!")
		return
		
	var foundCard = false
	var currentCard = null
	for slot in Hand.get_children():
		if slot.get_child_count() > 0:
			if slot.getCard().is_in_group("Cards"):
				foundCard = true
				currentCard = slot.getCard()
				break
	
	if currentCard != null:
		print("Player "+str(playerID)+" plays "+ currentCard.Name)
		currentCard.reparent(Table.get_node(("Slot"+str(playerID))),false) #Slot corresponds to player ID
		emit_signal("turn_finished")
	else:
		print("No cards in hand!")
		
	update_player_ui()
		
func _replenishHand():
	if PlayerDeck.get_child_count() > 0: #If deck has cards
		# find first empty slot (iterating all) and replenish one card
		for slot in Hand.get_children():
			if slot.get_child_count() == 0:
				PlayerDeck.get_child(0).reparent(slot,false) #Move card on top of deck to hand
				print("Added card to slot "+str(slot.name))
				return # just the one please
		
		print("No free slots found")

func _countCards():
	var count = 0
	for slot in Hand.get_children():
		if slot.get_child_count() > 0:
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
