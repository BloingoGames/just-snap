extends Node

var cardIDs = []

var currentTimeSig = "4-4"
var currentBeat = 0
var beatClaimed = false

func _ready() -> void:
	get_window().min_size = Vector2(960,540)
	
##For now throwing these in Global. We should probably find a better spot, but this
##At least allows us to reuse effects for different cards
func BloingoEffect1():
	print("BLOIGO 1 ACTIVATED")
	
func BloingoEffect2():
	print("BLOINGO 2 ACTIVATED")
