extends FmodEventEmitter2D

const NEXT_BEAT_TOLERANCE = 1

var startTime : float
var tempo : float
var fmodPosition : float
var lastBeat : int
var lastBeatTime : float
var beatInterval = null
var timeIntoCurrentBeat : float

var beatPreClaimed = false

var time_sig_upper : int
var time_sig_lower : int

func _ready() -> void:
	play()
	

# this signal sends these params which contains the current beat, bar, tempo etc. pretty helpful
# we could/should probably be using this in some other script but this is good for an example

#timeline marks in the fmod studio also send a signal, so we can use those on tempo changes etc. if necessary
func _on_timeline_beat(params: Dictionary) -> void:
	fmodPosition = params["position"]
	lastBeatTime = Time.get_ticks_msec()
	lastBeat = params["beat"]
	tempo = params["tempo"]

	time_sig_upper = params["time_signature_upper"]
	time_sig_lower = params["time_signature_lower"]
	Global.currentTimeSig = str(time_sig_lower)+'-'+str(time_sig_upper)
	if not beatInterval:
		beatInterval = 60000.0 / tempo
	
	if not beatPreClaimed:
		Global.currentBeat = params["beat"]
		Global.beatClaimed = false
	
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

func getNearestBeat():
	var timeToNextBeat = timeToNextBeat()
	if timeToNextBeat > beatInterval / 2:
		return lastBeat
	elif lastBeat >= time_sig_lower:
		return 1
	else:
		return lastBeat + 1
	#Pretty self explanatory. If more than half the interval away, nearest is the last one.
	#If we're on the last beat in the bar and more than halfway, nearest is one. 
	#Otherwise, last beat plus one

func _physics_process(delta: float) -> void:
	pass
