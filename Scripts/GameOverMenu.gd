extends TextureRect

signal Replay_Signal

func give_focus():
	$HSplitContainer/TextureButton.grab_focus()
	pass

#Play again pressed
func _on_TextureButton_button_up():
	emit_signal("Replay_Signal")
	pass

#Quit pressed
func _on_TextureButton2_button_up():
	get_tree().quit()
	pass
