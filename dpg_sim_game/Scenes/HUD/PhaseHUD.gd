extends Control

# Dependencies
onready var phase_title = $Phase/Margin/Control/PhaseTitle
onready var next_phase_label = $NextStage/Margin/CenterContainer/NextPhaseParent/NextPhaseLabel
onready var steps_parent = $Phase/Margin/Control/MarginContainer/HBoxContainer
onready var next_stage = $NextStage
onready var next_phase_label_parent = $NextStage/Margin/CenterContainer/NextPhaseParent
var phase_steps_path: String = "Phase/Margin/Control/MarginContainer/HBoxContainer/PhaseStep"

func StartPhase():
	phase_title.text = trans.local(global.mainConfig["Phases"][global.curPhaseIndex]["PhaseName"])
	get_node(phase_steps_path + str(global.curPhaseIndex+1)).ActiveStep()

func OverTime():
	ShowButton(true)
	get_node(phase_steps_path + str(global.curPhaseIndex+1)).CompleteStep()
	if (global.curPhaseIndex == 8):
		next_phase_label.text = trans.local("FINISH_GAME")
	else:
		next_phase_label.text = trans.local("NEXT_PHASE")

func ResetPhases():
	for child in steps_parent.get_children():
		child.EmptyStep()

func ShowButton(hide):
	next_stage.visible = hide

func _on_Button_pressed():
	global.game.soundManager.PlaySFX("Boop")
	global.game.ProjectComplete()

var t = 0
func _process(delta):
	t += delta
	if t > 1:
		t -= 1
	next_phase_label_parent.rect_scale = Vector2.ONE * lerp(1, 1.2, abs(t-0.5) * 2)
