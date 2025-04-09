extends Node2D

signal turn_finished

@export var playerID : int
@export var playerName : String = "Player"
@export var maxCardsInHand : int = 5
@export var PlayerDeck : Node2D
@export var Hand : Node2D
@export var Table : Node2D
@export var flipped = false

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

func _ready() -> void:
	if flipped: #Rotate player at top of screen's cards for animation to work
		Hand.rotation_degrees = 180
	$AnimationPlayer.play("show_cards")

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

func _animateCard(card,targetPos):
	create_tween().set_trans(Tween.TRANS_CUBIC).tween_property(card, "position", targetPos, 0.12)
		

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
		var targetSlot = Table.get_node("Slot"+str(playerID))
		currentCard.reparent(targetSlot,true) #Slot corresponds to player ID
		_animateCard(currentCard,targetSlot.position)
		# automatically replenish the slot last placed from
		# (if there are still cards)
		if PlayerDeck.get_child_count() > 0:
			var newCard = PlayerDeck.get_child(0) # pull one from the top of the deck
			newCard.reparent(slot, false)
			newCard.position.y += 50
			_animateCard(newCard,Vector2(newCard.position.x,newCard.position.y - 50))
			print("Slot " + str(card) + " replenished automatically")
		
		emit_signal("turn_finished")
	else:
		print("No cards in slot!")
		
	update_player_ui()

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
