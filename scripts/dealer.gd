extends Node2D

@export var Deck : Node2D
@export var Player1 : Node2D #For now just declaring each player in inspector. ->
@export var Player2 : Node2D

var current_player_idx = 0
var players = []

func _ready() -> void:
	players = [Player1, Player2]
	deal(players)
	
	# connect turn_finished signal to end_turn(), for each Player
	for player in players:
		player.turn_finished.connect(end_turn)
	get_node("../Table").snap_occurred.connect(on_snap_occurred)
	
	start_turn()

func on_snap_occurred(points):
	players[current_player_idx].score += points
	players[current_player_idx].update_player_ui()

func deal(players):
	var cards = Deck.get_children()
	var toDeal = len(cards) / len(players) #Will leave some extra cards if odd no. of players
	
	Deck.shuffle() #Shuffle before dealing
	
	for player in players:
		for i in range(0,toDeal):
			Deck.get_child(0).reparent(player.get_node("PlayerDeck")) #Move card nodes from Deck to Player Deck
	
	Player1.showHand()
	Player2.showHand()

func start_turn():
	# set all players' 'active' flags false, then current player's to true 
	for player in players:
		player.is_active_turn = false
		player.update_player_ui()
		
	players[current_player_idx].is_active_turn = true
	players[current_player_idx].update_player_ui() # highlight PlayerUI for active player
	
	print("Player " + str(players[current_player_idx].playerID) + "'s turn")
	
func end_turn():
	current_player_idx = (current_player_idx + 1) % players.size()
	start_turn()
