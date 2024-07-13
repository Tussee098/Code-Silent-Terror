extends Node3D

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene

func _on_host_button_pressed():
	_toggle_UI(false)
	peer.close()
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player(multiplayer.get_unique_id())
	
func add_player(id):
	var player = player_scene.instantiate()
	player.name = str(id)
	add_child(player)


#Joinar den skrivna IpAdressen
# MÅste testas
func _on_join_button_pressed():
	var ip_adress = $IpAdress.text
	peer.close()
	peer.create_client(ip_adress, 135)
	multiplayer.multiplayer_peer = peer
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		peer.close()
		get_tree().quit()
		

func _toggle_UI(value : bool):
	$HostButton.set_visible(value)
	$JoinButton.set_visible(value)
	$IpAdress.set_visible(value)

