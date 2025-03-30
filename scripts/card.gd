extends Node2D

var initialised = false

var ID : int
@export var Suit : String
@export var Pip : String
@export var Name : String

const allowedPips = ["2","3","4","5","6","7","8","9","10","J","Q","K","A"]
const allowedSuits = ["Spades","Hearts","Diamonds","Clubs"]


func _ready() -> void:
	
	if not initialised:
		print("Card instantiated with no parameters! Setting to default")
		Suit = "Spades"
		Pip = "A"
		Name = "Ace of Spades" #default
		
	_createID(null)
		
	if Pip not in allowedPips:
		print("Invalid pip for card "+ str(ID)+"!")
	if Suit not in allowedSuits:
		print("Invalid suit for card "+ str(ID)+"!")

func _createID(newID):
	if newID == null:
		if Global.cardIDs.max() == null:
			ID = 0
		else:
			ID = Global.cardIDs.max() + 1
	else:
		ID = newID
	
	if ID not in Global.cardIDs:
		Global.cardIDs.append(ID)
	else:
		_createID(ID+1) #Just brute force until ID is new lol
	print("ID set to " + str(ID))
	
func setParams(suit,pip,fancyName):
	if not initialised:
		Suit = suit
		Pip = pip
		Name = fancyName
		initialised = true
