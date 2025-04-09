extends Node2D
var empty = true
@export var Player : Node2D

func _ready() -> void:
	self.child_entered_tree.connect(_on_child_entered)
	self.child_exiting_tree.connect(_on_child_exited)
	

func _on_child_entered(child):
	empty = false
	child.position = Vector2(0,0)
	child.visible = true

func _on_child_exited(child):
	empty = true
	
func getCard():
	if not empty:
		return get_child(get_child_count()-1) #Return card on top of the pile
