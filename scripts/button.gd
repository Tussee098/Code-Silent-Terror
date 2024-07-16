extends StaticBody3D

enum STATE {
	ON,
	OFF
}

signal on_state_change
var state = STATE.OFF
	
func get_interaction_text():
	if state == STATE.ON:
		return "to turn off"
	
	return "to turn on"

func interact():
	if $AnimationPlayer.is_playing():
		return
		
		if state == STATE.ON:
			turn_off()
		else:
			turn_on()

func turn_on():
	if $AnimationPlayer.is_playing():
		return
	
	if state == STATE.ON:
		return
	
	state == STATE.ON
	$AnimationPlayer.play("new_animation")
	#$AudioStreamPlayer3D.play()
	
func turn_off():
	if $AnimationPlayer.is_playing():
		return
	
	if state == STATE.OFF:
		return
	
	state == STATE.OFF
	$AnimationPlayer.play_backwards("new_animation")
	#$AudioStreamPlayer3D.play()

func _on_AnimationPLayer_animation_finished(_anim_name):
	if state == STATE.ON:
		emit_signal("on_state_change", true)
	else:
		emit_signal("on_state_change", false)
