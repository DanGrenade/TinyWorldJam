extends Node

onready var sfx = AudioStreamPlayer.new()
onready var bgm = AudioStreamPlayer.new()

onready var game = load("res://Audio/start_of_your_end.ogg")
onready var menu = load("res://Audio/start_of_end.ogg")
onready var jump = load("res://Audio/sfx_movement_jump8.wav")
onready var confirm = load("res://Audio/sfx_menu_move2.wav")
onready var interact_trash = load("res://Audio/sfx_sounds_interaction22.wav")
onready var explosion = load("res://Audio/sfx_exp_short_hard3.wav")

func _ready():
	self.add_child(sfx)
	self.add_child(bgm)
	bgm.volume_db = -10
	bgm.stream = game
	bgm.play()

func play_menu_bg():
	bgm.stream = menu
	bgm.play()

func play_game_bg():
	bgm.stream = game
	bgm.play()
	
func play_confirm_sfx():
	sfx.stream = confirm
	sfx.play()

func _on_PlayerCharacter_player_hit() -> void:
	sfx.stream = explosion
	sfx.play()

func _on_PlayerCharacter_player_jump() -> void:
	sfx.stream = jump
	sfx.play()

func _on_PlayerCharacter_player_interact() -> void:
	sfx.stream = interact_trash
	sfx.play()
