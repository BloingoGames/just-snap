extends Node2D

signal snap_occurred(points)

@export var PlayerSignals : Node2D

func _on_slot_0_child_entered_tree(node: Node) -> void:
	snap()

func _on_slot_1_child_entered_tree(node: Node) -> void:
	snap()

func checkEmpty():
	if $Slot0.get_child_count() > 0 and $Slot1.get_child_count() > 0:
		return false
	else:
		return true
	
func clearTable():
	var anim
	var cardsToClear = []
	for slot in get_children():
		for card in slot.get_children():
			cardsToClear.append(card)
			anim = snap_animation(card)
	
	await anim.finished
	for card in cardsToClear:
		if card:
			card.queue_free()


func snap_animation(node):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT) \
	.tween_property(node, "scale", Vector2(1.2, 1.2), 0.3)
	
	return tween

func snap():
	if not checkEmpty():
		if $Slot0.getCard().Suit == $Slot1.getCard().Suit or $Slot0.getCard().Pip == $Slot1.getCard().Pip:
			var points = $Slot0.get_child_count() + $Slot1.get_child_count()
			print("snap! "+str(points)+" points.")
			
			emit_signal("snap_occurred", points)
			
			await PlayerSignals.card_animation_finished
			clearTable()
			
			return points
	else:
		return 0
