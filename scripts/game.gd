extends Node3D

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene


func _on_host_button_pressed():
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player(multiplayer.get_unique_id())
	
func add_player(id):
	var player = player_scene.instantiate()
	player.name = str(id)
	add_child(player)



func _on_join_button_pressed():
	peer.create_client("localhost", 135)
	multiplayer.multiplayer_peer = peer
	
