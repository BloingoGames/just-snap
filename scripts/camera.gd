extends Camera2D

func wobble():
	#If already wobbling, delay it a little bit so that it's clear the other player also wobbled
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.play("RESET")
		await get_tree().create_timer(0.1).timeout
	# nice
	$AnimationPlayer.play("camera_wobble")
	
func _ready() -> void:
	Global.currentCamera = self
