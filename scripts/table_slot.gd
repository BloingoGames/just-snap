extends Node2D
var empty = true
@export var specialSlot = false

func _ready() -> void:
	self.child_entered_tree.connect(_on_child_entered)

func _on_child_entered(child):
	child.position = Vector2(0,0)
	child.visible = true
	if specialSlot:
		print(child.bloingoEffect)
		child.bloingoEffect.call()
	
func getCard():
	return get_child(get_child_count()-1) #Return card on top of the pile
