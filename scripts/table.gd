extends Node2D

signal snap_occurred(points)

@export var PlayerSignals : Node2D

@export var SnapSlots : Node2D

func _on_slot_0_child_entered_tree(node: Node) -> void:
	snap()

func _on_slot_1_child_entered_tree(node: Node) -> void:
	snap()

func checkEmpty():
	if SnapSlots.get_node("Slot0").get_child_count() > 0 and SnapSlots.get_node("Slot1").get_child_count() > 0:
		return false
	else:
		return true
	
func clearTable():
	var anim
	var cardsToClear = []
	
	for slot in SnapSlots.get_children():
		for card in slot.get_children():
			if not card.blocking:
				cardsToClear.append(card)
	
	await PlayerSignals.card_animation_finished
	await snap_animation(SnapSlots)
	
	for card in cardsToClear:
		if card != null:
			card.queue_free()
			card = null


func snap_animation(node):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT) \
	.tween_property(node, "scale", Vector2(1.2, 1.2), 0.3)
	await tween.finished
	node.scale = Vector2(1,1)

func snap():
	if not checkEmpty():
		if SnapSlots.get_node("Slot0").getCard().Suit == SnapSlots.get_node("Slot1").getCard().Suit or SnapSlots.get_node("Slot0").getCard().Pip == SnapSlots.get_node("Slot1").getCard().Pip:
			var points = SnapSlots.get_node("Slot0").get_child_count() + SnapSlots.get_node("Slot1").get_child_count()
			print("snap! "+str(points)+" points.")
			
			emit_signal("snap_occurred", points)
			clearTable()
			
			return points
	else:
		return 0
