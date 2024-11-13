extends Node

# Dependencies
onready var action_options = [
	$CenterContainer/Control/ActionOption1,
	$CenterContainer/Control/ActionOption2,
	$CenterContainer/Control/ActionOption3,
	$CenterContainer/Control/ActionOption4,
]
onready var back_button = $CenterContainer/Control/Back_Button

func Start():
	for i in range(len(action_options)):
		action_options[i].present = int(global.actions[i]["StartingPhase"]) <= global.curPhaseIndex

	for i in range(len(action_options)):
		action_options[i].Start()
		if (!action_options[i].is_connected("action_start_pressed", self, "StartAction")):
			action_options[i].connect("action_start_pressed", self, "StartAction")

	back_button.Start()

func StartAction(index):
	if index == 3:
		global.actionsActive[0] = true
		global.actionsActive[1] = true
		global.actionsActive[2] = true
	else:
		global.actionsActive[index] = true
	global.game.OpenActionScreen(false)

func _on_Back_Button_buttonPressed():
	global.game.OpenActionScreen(false)
