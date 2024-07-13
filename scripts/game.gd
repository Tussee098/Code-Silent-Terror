extends Node3D

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene
var players : Array

func _host_button_pressed():
	_toggle_UI(false)
	peer.close() # idk
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player(multiplayer.get_unique_id())


# MÅste testas
func _join_button_pressed(ip_adress):
	_toggle_UI(false)
	peer.close() # idk
	peer.create_client(ip_adress, 135)
	multiplayer.multiplayer_peer = peer


func add_player(id):
	var player = player_scene.instantiate()
	player.name = str(id)
	add_child(player)
	players.push_back(player)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		peer.close() # idk
		get_tree().quit()
		

func _toggle_UI(value : bool):
	$ConnectionUI.set_visible(value)
	

func _process(delta):
	for player in players:
		if player.is_walking:
			player._walk_animation()
		else:
			player._idle_animation()
