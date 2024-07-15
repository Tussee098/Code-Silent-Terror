extends Node3D

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene

var haunted = false
var playerIds = []

func _host_button_pressed():
	_toggle_UI(false)
	peer.close() # idk
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	var newId = multiplayer.get_unique_id()
	_add_player(newId)
	$StartGameButton.visible = !$StartGameButton.visible
	

# MÅste testas
func _join_button_pressed(ip_adress):
	_toggle_UI(false)
	peer.close() # idk
	peer.create_client(ip_adress, 135)
	multiplayer.multiplayer_peer = peer
	
	_add_player(multiplayer.get_unique_id())
	

@rpc("any_peer", "call_local", "reliable")
func _add_player(id):
	playerIds.append(id)
	var player = player_scene.instantiate()
	player.name = str(id)
	player.player_id = id
	add_child(player)
	call_deferred("add_child")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		


func _toggle_UI(value : bool):
	$ConnectionUI.set_visible(value)
	


func _on_start_game_button_pressed():
	$StartGameButton.visible = !visible
	_start_game()


func _start_game():
	randomize()
	
	#players[random_number].haunted = true
	var random_number = randi() % playerIds.size()
	_load_haunted.rpc_id(playerIds[random_number])

#Anything that should happen to the haunted player when Loading
@rpc("call_local")
func _load_haunted():
	print("Loading Haunted...")
	$DirectionalLight3D.visible = !visible
	
	pass
