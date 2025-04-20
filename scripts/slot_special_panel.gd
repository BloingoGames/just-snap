extends TextureRect
var i = 0
var warbling = false
var warble_amount = 0.009
@export var SpecialSlot : Node2D
@export var PlayerSignals : Node2D

func _ready() -> void:
	material.set_shader_parameter("strength", 0)

func _physics_process(delta: float) -> void:
	if warbling:
		i += 1
		material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)
		if i >= 100:
			i = 0

func _on_slot_special_child_entered_tree(node: Node) -> void:
	await PlayerSignals.card_animation_finished
	material.set_shader_parameter("strength", warble_amount)
	warbling = true
