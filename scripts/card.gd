extends Node2D

var initialised = false

var ID : int
@export var Suit : String
@export var Pip : String
@export var Name : String
@export var Sprite : Sprite2D #This should probably be animated at some point
@export var playableBeats = [true,true,true,true,true,true,true] #playable beats up to 7 for 7/8 - assuming we wont go to any 
var bloingoEffect : Callable #no default because _ready -> if not initalised: should sort that for any broken cards.
var customSpriteSet = false

var flipped = false

const allowedPips = ["2","3","4","5","6","7","8","9","10","J","Q","K","A"]
const allowedSuits = ["Spades","Hearts","Diamonds","Clubs"]

var blocking = false

func _ready() -> void:
	
	if not customSpriteSet:
		_setGenericSprite() #set generic texture for each playing cards. the special cards will need to be able to override this
	
	if not initialised:
		print("Card instantiated with no parameters! Setting to default")
		Suit = "Spades"
		Pip = "A"
		Name = "Ace of Spades" #default
		bloingoEffect = Global.BloingoEffect1
		
	_createID(null)
		
	if Pip not in allowedPips:
		print("Invalid pip for card "+ str(ID)+"!")
	if Suit not in allowedSuits:
		print("Invalid suit for card "+ str(ID)+"!")
	
	_drawIndicatorBeats()

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
	#print("ID set to " + str(ID))
	
func setParams(suit,pip,fancyName,BloingoEffect,special=false):
	if not initialised:
		Suit = suit
		Pip = pip
		Name = fancyName
		bloingoEffect = BloingoEffect
		if special:
			var SpritePath = "res://assets/special_cards/"+fancyName+".png"
			Sprite.texture = load(SpritePath)
			customSpriteSet = true

		initialised = true
		
func _setGenericSprite():
	var genericSpritePath = "res://assets/default_cards/"+Suit.to_lower()+"_"+Pip+".png"
	Sprite.texture = load(genericSpritePath)
	
func hideIndicator():
	$CardIndicator.visible = false

func _showIndicator():
	$CardIndicator.texture = load("res://assets/UI/CardIndicators/"+Global.currentTimeSig+".png")

func _drawIndicatorBeats():
	var colour = Color.from_rgba8(255,98,36,255)
	if Global.currentTimeSig == "4-4":
		var image = $CardIndicator.texture.get_image()
		for i in range(0,int(Global.currentTimeSig[0])):
			if playableBeats[i] == true: #Colour pixel square for each beat. only 4/4 right now
				if i == 0:
					image.set_pixel(4,1,colour)
					image.set_pixel(5,1,colour)
					image.set_pixel(4,2,colour)
					image.set_pixel(5,2,colour)
				if i == 1:
					image.set_pixel(7,4,colour)
					image.set_pixel(7,5,colour)
					image.set_pixel(8,4,colour)
					image.set_pixel(8,5,colour)
				if i == 2:
					image.set_pixel(4,7,colour)
					image.set_pixel(5,7,colour)
					image.set_pixel(4,8,colour)
					image.set_pixel(5,8,colour)
				if i == 3:
					image.set_pixel(1,4,colour)
					image.set_pixel(2,4,colour)
					image.set_pixel(1,5,colour)
					image.set_pixel(2,5,colour)
					
		
		$CardIndicator.texture = ImageTexture.create_from_image(image)
	
func _physics_process(delta: float) -> void:
	if flipped: #This is really dumb but it works for now fuck it.
		$CardIndicator.position.y = 38
	else:
		$CardIndicator.position.y = -38
