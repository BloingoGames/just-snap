extends Node2D
var empty = true

func _ready() -> void:
	self.child_entered_tree.connect(_on_child_entered)
	self.child_exiting_tree.connect(_on_child_exited)

func _on_child_entered(child):
	empty = false

func _on_child_exited(child):
	empty = true
