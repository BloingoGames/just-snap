extends Node2D

signal turn_finished

@export var playerID : int
@export var playerName : String = "Player"
@export var maxCardsInHand : int = 5
@export var PlayerDeck : Node2D
@export var Hand : Node2D
@export var Table : Node2D

@onready var playerUI = $PlayerUI # Player scene's UI container reference

var playerControls = { #Keys are player ID. Dict within player ID is that player's control scheme
	0: {
		49: "Card 0",
		50: "Card 1",
		51: "Card 2",
		52: "Card 3",
		53: "Card 4",
	},
	1:{
		54: "Card 0",
		55: "Card 1",
		56: "Card 2",
		57: "Card 3",
		48: "Card 4",
	}
}

var score : int = 0

var is_active_turn = false

func update_player_ui():
	var nameLabel = playerUI.get_node("NameLabel")
	var scoreLabel = playerUI.get_node("ScoreLabel")

	nameLabel.text = playerName + " " + str(playerID)
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

func _playCard(card : int):
	# only active player allowed
	if not is_active_turn:
		print("No, not your turn, player " + str(playerID) + "! Play properly or we're going home!")
		return
		
	var slot = Hand.get_child(card)
	
	var currentCard = null
	if slot.get_child_count() > 0:
		if slot.getCard().is_in_group("Cards"):
			currentCard = slot.getCard()
	
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
	
func _input(event) -> void:
	if is_active_turn:
		if event is InputEventKey and event.pressed: #if detected input is a keypress and *pressed* not *released*.
			var pressedKey = event["keycode"]
			if pressedKey in playerControls[playerID]: #check if it's in the player's controls.
				_processControls(playerControls[playerID][pressedKey])
					
	
func _processControls(action : String):
	if action.begins_with("Card"):
		_playCard(int(action.substr(4)))
	
func _physics_process(delta):
	pass
	#
	#var playButton = "ui_accept"
	#var replenButton = "ui_left"
	#if playerID == 1:
		#playButton = "ui_select"
		#replenButton = "ui_right" #these are all for testing only.
	#if Input.is_action_just_pressed(playButton):
		#_playCard()
	#if Input.is_action_just_pressed(replenButton):
		#_replenishHand()
