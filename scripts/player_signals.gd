extends Node2D
signal card_animation_finished
signal try_snap
#wacky but it works. allows for waiting for either Player 1 *or* Player 2's signal

func _on_player_1_card_animation_finished() -> void:
	emit_signal("card_animation_finished")


func _on_player_2_card_animation_finished() -> void:
	emit_signal("card_animation_finished")


func _on_player_1_try_snap(player) -> void:
	await card_animation_finished
	emit_signal("try_snap",player)


func _on_player_2_try_snap(player) -> void:
	await card_animation_finished
	emit_signal("try_snap",player)
