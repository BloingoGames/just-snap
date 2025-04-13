extends Node2D
var speed = 0.5
@export var CursorFollower : PathFollow2D
@export var FmodEventEmitter : FmodEventEmitter2D
@onready var tempo = FmodEventEmitter.tempo
var time_sig_upper = 4
var time_sig_lower = 4
var initialised = false

@onready var quarterLength = $Path2D.get_curve().get_baked_length() / 4

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if initialised:
		CursorFollower.progress_ratio += speed
		
func reset():
	CursorFollower.progress = 0
	initialised = false
	

func initialise(tempo,time_sig_upper,time_sig_lower,newSpeed):
	tempo = tempo
	time_sig_upper = time_sig_upper
	time_sig_lower = time_sig_lower
	speed = newSpeed
	print("Speed: ",speed)
	print("Tempo: ",tempo)
	initialised = true
	
	
# speed should be distance to travel per beat / beat interval * framerate
#distance to travel is dependant on time sig - e.g 4/4 will be a quarter of the circle, 3/4 will be a third
#we'll need different circle indicators for each time sig though

func _on_fmod_event_emitter_2d_timeline_beat(params: Dictionary) -> void:
	if not initialised:
		var newSpeed = (1.0 / time_sig_lower) / ((FmodEventEmitter.beatInterval / 1000) * 60)
		initialise(params["tempo"],params["time_signature_upper"],params["time_signature_lower"],newSpeed)
	#if needed to avoid desync we could probably grab the current beat here and snap to that exact position
	$AnimationPlayer.play("beat")
