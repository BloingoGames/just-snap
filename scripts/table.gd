extends Node2D

signal snap_occurred(points)

var snapping = false

@export var PlayerSignals : Node2D
@export var SnapSlots : Node2D
@export var SnapAnimator : AnimationPlayer

func _on_slot_0_child_entered_tree(node: Node) -> void:
	await PlayerSignals.card_animation_finished
	checkForSnap()

func _on_slot_1_child_entered_tree(node: Node) -> void:
	await PlayerSignals.card_animation_finished
	checkForSnap()

func checkEmpty():
	if SnapSlots.get_node("Slot0").get_child_count() > 0 and SnapSlots.get_node("Slot1").get_child_count() > 0:
		return false
	else:
		return true
		
func clearCards():
	var cardsToClear = []
	for slot in SnapSlots.get_children():
		for card in slot.get_children():
			if not card.blocking:
				cardsToClear.append(card) #Grab all cards and append to array
	
	SnapAnimator.play("snap")
	await SnapAnimator.animation_finished #wait for AnimationPlayer to finish
	SnapAnimator.play("RESET")
	
	for card in cardsToClear:
		card.queue_free()
		card = null

func checkForSnap():
	if not checkEmpty():
		var Slot0 = SnapSlots.get_node("Slot0")
		var Slot1 = SnapSlots.get_node("Slot1")
		var snappedCards = []
		if Slot0.getCard().Suit == Slot1.getCard().Suit or Slot0.getCard().Pip == Slot1.getCard().Pip:
			snappedCards.append(Slot0.getCard())
			snappedCards.append(Slot1.getCard()) #Add snapped cards to array for future references/animations
			
			snapping = true #whilst we wait for animations etc., snapping state = true
			await clearCards()
			snapping = false
