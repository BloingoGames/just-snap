extends FmodEventEmitter2D

const NEXT_BEAT_TOLERANCE = 1

var startTime : float
var tempo : float
var fmodPosition : float
var lastBeatTime : float
var beatInterval = null
var timeIntoCurrentBeat : float

func _ready() -> void:
	play()
	

# this signal sends these params which contains the current beat, bar, tempo etc. pretty helpful
# we could/should probably be using this in some other script but this is good for an example

#timeline marks in the fmod studio also send a signal, so we can use those on tempo changes etc. if necessary
func _on_timeline_beat(params: Dictionary) -> void:
	fmodPosition = params["position"]
	lastBeatTime = Time.get_ticks_msec()
	tempo = params["tempo"]
	if not beatInterval:
		beatInterval = 60000.0 / tempo
	
	#for testing: seems to be within 3ms of accuracy which should be good enough given how big our hit windows will be
	#print(beatInterval)
	#
	#await get_tree().create_timer(0.3).timeout
	#
	#print("time to next: ",timeToNextBeat())
	
func timeToNextBeat():
	#calculate based on godot time and last known fmod time+position for max accuracy.
	var currentTime = Time.get_ticks_msec()
	var elapsedTime = currentTime - lastBeatTime
	var currentPosition = fmodPosition + elapsedTime
	
	var timeIntoCurrentBeat = fmod(currentPosition,beatInterval)
	var timeToNextBeat = beatInterval - timeIntoCurrentBeat
	
	if timeToNextBeat < NEXT_BEAT_TOLERANCE: #if calling this function too close to the start of a beat, it gets confused.
		#if we're pretty much on the beat the time to next can just be the constant time between beats based on tempo.
		timeToNextBeat = beatInterval
	
	return timeToNextBeat
