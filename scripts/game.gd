extends Node3D

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene

var hauntedParanoiaLevel = 100
var haunted = false
var haunted_player

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
	

# MÅste testas  ?
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
	
	var player_client_id = playerIds.pick_random()
	rpc_id(player_client_id, "_load_haunted", player_client_id)

#Anything that should happen to the haunted player when Loading

@rpc("call_local")
func _load_haunted(player_id):
	$MonsterTimer.start()
	print("Loading Haunted...")
	$DirectionalLight3D.visible = !visible
	$MusicPlayer.play()
	var children = get_children()
	haunted_player
	for child in children:
		if child.name == str(player_id):
			haunted_player = child
	haunted_player.set_haunted(true)
	$Monster.visible = visible
	pass


func _on_entrance_trigger_body_entered(body):
	if body.is_haunted:
		var music_timer = $MusicPlayer.get_playback_position()
		$MusicPlayer.stop()
		var entrance_trigger = $EntranceTrigger 
		var Jumpscareplayer = entrance_trigger.get_child(0)
		Jumpscareplayer.play()
	pass # Replace with function body.


func _on_jump_scare_player_finished():
	$MusicPlayer.play()


func _on_monster_timer_timeout():
	print("Timeer")
	var hauntingValue = randi_range(25, 100)
	if hauntedParanoiaLevel >= hauntingValue:
		haunt()
	$MonsterTimer.wait_time = randi_range(10, 25)


func haunt():
	var scaryface = find_child("scaryface")
	scaryface.position = haunted_player.get_global_position() + Vector3(20, 6, 20).rotated(Vector3(0,1,0), randf_range(0, 2*PI))
	scaryface.haunting_picture(randi_range(5, 10))
	


