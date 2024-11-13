extends Node

# Dependencies
onready var scores = $CenterContainer/Control/Scores
onready var title = $CenterContainer/Control/Title
onready var mm_button = $CenterContainer/Control/MM_Button

func Start():
	title.text = trans.local("YOU_WIN")
	mm_button.Start()

func _on_MM_Button_buttonPressed():
	global.game.ExitGame()
