extends Node3D

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene

var haunted = false


func _host_button_pressed():
	_toggle_UI(false)
	peer.close() # idk
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player(multiplayer.get_unique_id())
	$StartGameButton.visible = !$StartGameButton.visible
	

# MÅste testas
func _join_button_pressed(ip_adress):
	_toggle_UI(false)
	peer.close() # idk
	peer.create_client(ip_adress, 135)
	multiplayer.multiplayer_peer = peer
	_add_player(multiplayer.get_unique_id())


func _add_player(id):
	var player = player_scene.instantiate()
	player.name = "Player" + str(id)
	add_child(player)
	call_deferred("add_child")


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		peer.close() # idk
		get_tree().quit()
		


func _toggle_UI(value : bool):
	$ConnectionUI.set_visible(value)
	


func _on_start_game_button_pressed():
	$StartGameButton.visible = !visible
	_start_game()


func _start_game():
	randomize()
	var players = []
	for child in get_children():
		if child.name.begins_with("Player"):
			players.append(child)
	var random_number = randi() % players.size()
	players[random_number].haunted = true
	print(random_number)
	_load_haunted.rpc_id(1)
	


@rpc("call_local")
func _load_haunted():
	$DirectionalLight3D.visible = !visible
	print("LoadingHaunted...")
	pass
