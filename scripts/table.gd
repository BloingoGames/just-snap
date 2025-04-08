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
	

func snap():
	var points = 0
	if not checkEmpty():
		print("SNAPPING")
