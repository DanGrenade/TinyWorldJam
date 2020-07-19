extends Control

var Start_Button_Node
signal Start_Button_Pressed

var Continue_Button_Node
signal Continue_Button_Pressed

var Quit_Button_Node
signal Quit_Button_Pressed


#Start button pressed
func _on_TextureButton_pressed():
	emit_signal("Start_Button_Pressed")
	
	visible = false
	$YSort/VBoxContainer/TextureButton.visible = false
	$YSort/VBoxContainer/TextureButton3.visible = true
	
	pass 

#Continue Button Pressed
func _on_TextureButton3_pressed():
	emit_signal("Continue_Button_Pressed")
	visible = false
	pass 


#Quit Button Pressed
func _on_TextureButton2_pressed():
	emit_signal("Quit_Button_Pressed")
	get_tree().quit()
	pass 


func _on_GameManager_switch_game_state_signal(pause_state):
	
	visible = pause_state
	pass
