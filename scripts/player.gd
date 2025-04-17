extends Node2D

signal turn_finished
signal card_animation_finished
signal try_snap

@export var playerID : int
@export var playerName : String = "Player"
@export var maxCardsInHand : int = 5
@export var PlayerDeck : Node2D
@export var Hand : Node2D
@export var Table : Node2D
@export var flipped = false

var initAnimationComplete = false

@export var fmod_node : FmodEventEmitter2D

@onready var playerUI = $PlayerUI # Player scene's UI container reference

var hitWindow = [80,150,200] #Great, Good, OK

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
	$AccuracyDisplay.visible = false
	if flipped: #Rotate player at top of screen's cards for animation to work
		$AnimationPlayer.play("show_cards_flipped")
		$AccuracyDisplay.position.y = -$AccuracyDisplay.position.y
	else:
		$AnimationPlayer.play("show_cards")
	await $AnimationPlayer.animation_finished
	initAnimationComplete = true

func is_out() -> bool:
	# check player's deck and hand for empty - if so, their turn is skipped
	var deckEmpty = (PlayerDeck.get_child_count() == 0)
	var handEmpty = true
	
	for slot in Hand.get_children():
		if (slot.get_child_count() > 0) and slot.getCard().is_in_group("Cards"):
			handEmpty = false
			break
		
	if (deckEmpty and handEmpty):
		print("player " + str(playerID) + " is dead, their turn is skipped")
		return true
	else:
		return false
		
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
			card.flipped = flipped
		else:
			var defaultCard = Sprite2D.new()
			defaultCard.texture = load("res://assets/default_cards/back.png")
			slot.add_child(defaultCard) #primitive. show the back of card texture if unknown card in slot

		
func _moveToViewer():
	for i in range(0,maxCardsInHand):
		if PlayerDeck.get_child(i):
			var currentCard = PlayerDeck.get_child(i)
			currentCard.reparent(Hand.get_node("Slot"+str(i)),false)

func _animateCard(card,targetPos,sig):
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).tween_property(card, "position", targetPos, 0.12)
	if sig:
		await tween.finished
		emit_signal("card_animation_finished")
		

func beatAccuracy():
	# get accuracy of player move
	if fmod_node:
		var timeToNext = fmod_node.timeToNextBeat()
		var interval = fmod_node.beatInterval
		var timeSinceLast = interval - timeToNext
		var diff = min(timeToNext, timeSinceLast)
		var timeToNearest = diff
		var nearestBeat = fmod_node.getNearestBeat()
		
		var sign: String
		if timeToNext < timeSinceLast:
			diff = timeToNext
			sign = "-"
			
		else:
			diff = timeSinceLast
			sign = "+"
		
		timeToNearest = diff
			
		print(sign + str(diff) + " from nearest beat")
		print("Nearest beat is ", nearestBeat)
		
		if timeToNearest > hitWindow.max():
			print("Missed")
			$AnimationPlayer.play("Miss")
			return false
		elif timeToNearest > hitWindow[1]:
			print("OK")
			$AnimationPlayer.play("OK")
		elif timeToNearest > hitWindow[0]:
			print("Good")
			$AnimationPlayer.play("Good")
		else:
			print("Perfect")
			$AnimationPlayer.play("Perfect")
	return true

func _playCard(card : int, is_special : bool = false):
	
	if not initAnimationComplete:
		return
	
	# only active player allowed
	if not is_active_turn:
		print("No, not your turn, player " + str(playerID) + "! Play properly or we're going home!")
		return
	
	# block input during snap animation
	if Table.snapping:
		print("Table still snapping previous cards.")
		return
	
	var slot = Hand.get_child(card)
	
	var currentCard = null
	if slot.get_child_count() > 0:
		if slot.getCard().is_in_group("Cards"):
			currentCard = slot.getCard()
	
	if currentCard != null:
		
		if not beatAccuracy():
			return
		
		currentCard.hideIndicator() #hide the little rhythm indicator above the card when thrown
		# 'targetSlot' target depends on whether card placed as special
		var targetSlot = Table.get_node("SnapSlots/Slot"+str(playerID))
		if is_special:
			print("Player "+str(playerID)+" plays "+ currentCard.Name + " as Bloingo!")
			targetSlot = Table.get_node("SlotSpecial")
		else:
			print("Player "+str(playerID)+" plays "+ currentCard.Name)
		
		currentCard.reparent(targetSlot,true) #Slot corresponds to player ID
		_animateCard(currentCard,targetSlot.position,true)
		emit_signal("try_snap",playerID)
		
		# automatically replenish the slot last placed from
		# (if there are still cards)
		if PlayerDeck.get_child_count() > 0:
			var newCard = PlayerDeck.get_child(0) # pull one from the top of the deck
			newCard.flipped = flipped
			newCard.reparent(slot, false)
			newCard.position.y += 50
			_animateCard(newCard,Vector2(newCard.position.x,newCard.position.y - 50),false)
			#print("Slot " + str(card) + " replenished automatically")
		
		emit_signal("turn_finished")
		
	else:
		print("Player "+str(playerID)+": No cards in that slot!")
		
	update_player_ui()
	
func _playCardSpecial(card : int):
	print("shift modifier active on: " + str(card))

	
func _countCards():
	var count = 0
	for slot in Hand.get_children():
		if slot.get_child_count() > 0:
			for child in slot.get_children():
				if child.is_in_group("Cards"):
					count += 1 #Count each non-empty slot
	return count
	
func _input(event) -> void:
	if is_active_turn:
		if event is InputEventKey and event.pressed: #if detected input is a keypress and *pressed* not *released*.
			var pressedKey = event["keycode"]
			if pressedKey in playerControls[playerID]: #check if it's in the player's controls.			
				var baseAction = playerControls[playerID][pressedKey]
				var action = baseAction
				# check shift key held
				if Input.is_key_pressed(KEY_SHIFT):
					action = "Shift_" + baseAction
				_processControls(action)
				
				
func _processControls(action : String):
	if action.begins_with("Card"):
		_playCard(int(action.substr(4)), false)
	if action.begins_with("Shift_Card"):
		_playCard(int(action.substr(11)), true)
	
func _physics_process(delta):
	pass
