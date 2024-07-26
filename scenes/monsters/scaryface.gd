extends Node3D

var player
var haunting = false

@onready var showFaceTimer = $ShowFaceTimer
@onready var disappearTriggerArea = $DisappearTriggerArea
signal face_forced_disappear()

func _process(delta):
	if haunting:
		var target_vector = global_position.direction_to(player.position)
		var target_basis= Basis.looking_at(target_vector)
		basis = basis.slerp(target_basis, 0.5)

func haunting_picture(time):
	player = get_tree().get_first_node_in_group("player")
	haunting = true
	visible = true
	showFaceTimer.start(time)
	disappearTriggerArea.monitoring = true 


func _on_show_face_timer_timeout():
	visible = false


func _on_disappear_trigger_area_player_entered():
	print("pooof")
	visible = false
	showFaceTimer.stop()
	disappearTriggerArea.monitoring = false 
	emit_signal("face_forced_disappear")
