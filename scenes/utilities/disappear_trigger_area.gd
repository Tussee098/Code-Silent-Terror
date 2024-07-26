extends Area3D

signal player_entered()

func _on_area_entered(_area):
	print("trigger")
	emit_signal("player_entered")
