extends FmodEventEmitter2D

func _ready() -> void:
	play()

func _on_timeline_beat(params: Dictionary) -> void:
	print(params)
# this signal sends these params which contains the current beat, bar, tempo etc. pretty helpful
# we could/should probably be using this in some other script but this is good for an example

#timeline marks in the fmod studio also send a signal, so we can use those on tempo changes etc. if necessary
