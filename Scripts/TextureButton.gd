extends TextureButton

export var start_focus = false

export var normal_color = Color()
export var focus_color = Color()
export var pressed_color = Color()

func _ready():
	if start_focus: grab_focus()
	pass

func _on_TextureButton_focus_entered():
	print(name)
	modulate = focus_color
	pass


func _on_TextureButton_focus_exited():
	modulate = normal_color
	pass 


func _on_TextureButton_button_down():
	modulate = pressed_color
	pass 


func _on_TextureButton_button_up():
	modulate = focus_color
	pass 
