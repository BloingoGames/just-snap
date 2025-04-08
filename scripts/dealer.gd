extends Node2D

@export var Deck : Node2D
@export var Player1 : Node2D #For now just declaring each player in inspector. ->
@export var Player2 : Node2D

func _ready() -> void:
	deal([Player1,Player2])

func deal(players):
	var cards = Deck.get_children()
	var toDeal = len(cards) / len(players) #Will leave some extra cards if odd no. of players
	
	Deck.shuffle() #Shuffle before dealing
	
	for player in players:
		for i in range(0,toDeal):
			Deck.get_child(0).reparent(player.get_node("PlayerDeck")) #Move card nodes from Deck to Player Deck
	
	Player1.showHand()
	Player2.showHand()
