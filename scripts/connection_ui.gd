extends Control


func _on_host_button_pressed():
	get_parent()._host_button_pressed()

# MÅste testas
func _on_join_button_pressed():
	get_parent()._join_button_pressed($IpAdress.text)

