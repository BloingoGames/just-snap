extends Node2D


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
	for slot in get_children():
		for card in slot.get_children():
			card.queue_free()

func snap():
	if not checkEmpty():
		if $Slot0.getCard().Suit == $Slot1.getCard().Suit or $Slot0.getCard().Pip == $Slot1.getCard().Pip:
			var points = $Slot0.get_child_count() + $Slot1.get_child_count()
			print("snap! "+str(points)+" points.")
			
			clearTable()
			
			return points
	else:
		return 0
	
