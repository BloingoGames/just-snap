extends Node2D

@export var Deck : Node2D
@export var Player1 : Node2D #For now just declaring each player in inspector. ->
@export var Player2 : Node2D

var barTracker = 1
var lastBar = 1

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

func on_snap_occurred(points,player):
	players[player].score += points
	players[player].update_player_ui()

func deal(players):
	var cards = Deck.get_children()
	var toDeal = len(cards) / len(players) #Will leave some extra cards if odd no. of players
	
	Deck.shuffle() #Shuffle before dealing
	
	for player in players:
		for i in range(0,toDeal):
			var card = Deck.get_child(0)
			var cardReplaceID = card["Pip"] + card["Suit"]
			#check for the card in the player's inventory
			if cardReplaceID in player.uniquePlayerDeck.deck:
				print("Found a spicy ", cardReplaceID+".")
				print("Replacing card for ",str(player.playerID))
				var newName = player.uniquePlayerDeck.deck[cardReplaceID]["Name"]
				var newPip = player.uniquePlayerDeck.deck[cardReplaceID]["Pip"]
				var newSuit = player.uniquePlayerDeck.deck[cardReplaceID]["Suit"]
				var newBloingoEffect = player.uniquePlayerDeck.deck[cardReplaceID]["bloingoEffect"]
				var playableBeats = player.uniquePlayerDeck.deck[cardReplaceID]["playableBeats"]
				Deck.remove_child(card) #make sure the old card is definitely removed
				card.queue_free()
				
				#replace with the new one
				card = Deck.generateCard(newSuit,newPip,newName,newBloingoEffect,playableBeats,true) #true sets special=true, meaning the unique sprite is loaded
				
			card.reparent(player.get_node("PlayerDeck")) #Move card nodes from Deck to Player Deck
			
			
	Player1.showHand()
	Player2.showHand()

func start_turn():
	# Rebuild list of players still in the game for turn-cycling, 
	# by checking their 'is_out()' status based on each player's remaining deck and hand
	var activePlayers = []
	for player in players:
		if player.is_out() == false:
			activePlayers.append(player)
			
	# End condition is met if a single player remains in play (can't play with youself!) 
	if activePlayers.size() <= 1:
		end_game()
		return
		
	# the list of players can change in size -
	# ensure that the current player index is still within range
	current_player_idx = current_player_idx % players.size()
	# skip turn if palyer is dead
	if players[current_player_idx].is_out():
		print("Player " + str(players[current_player_idx].playerID) +" is out - skipping their turn")
		end_turn()
		return
	
	# Set all players' 'active' flags false, then current player's to true 
	for player in players:
		player.is_active_turn = false
		player.update_player_ui()
		
	players[current_player_idx].is_active_turn = true
	players[current_player_idx].update_player_ui() # highlight PlayerUI for active player
	
	print("\nPlayer " + str(players[current_player_idx].playerID) + "'s turn:")
	
func end_turn():
	current_player_idx = (current_player_idx + 1) % players.size()
	barTracker = 1
	start_turn()
	
func end_game():
	print("game over")


func _on_fmod_event_emitter_2d_timeline_beat(params: Dictionary) -> void:
	var currentBar = params["bar"]
	if currentBar > lastBar:
		barTracker += 1
		lastBar = currentBar
	if barTracker > 3:
		print("Ran out of time")
		end_turn()
