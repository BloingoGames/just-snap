extends Node2D
var gameScene = preload("res://main.tscn")

func _ready() -> void:
	$AnimationPlayer.play("moving_logo")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		get_tree().change_scene_to_packed(gameScene)
