extends Node2D


func _on_slot_0_child_entered_tree(node: Node) -> void:
	print(node)
	node.position = Vector2i(0,0) #Move node to 0 (relative to this slot)


func _on_slot_1_child_entered_tree(node: Node) -> void:
	pass # Replace with function body.
