extends Label

signal worker_hire_pressed(worker_name)
signal worker_fire_pressed(worker_name)

func Start():
	text = name
	match name:
		"Management":
			$BgDefault/Portrait.texture = load("res://Sprites/Portraits/portrait01Transaprent.png")
		"Development":
			$BgDefault/Portrait.texture = load("res://Sprites/Portraits/portrait02Transaprent.png")
		"Design":
			$BgDefault/Portrait.texture = load("res://Sprites/Portraits/portrait03Transaprent.png")
		"Product":
			$BgDefault/Portrait.texture = load("res://Sprites/Portraits/portrait04Transaprent.png")
		"Marketing":
			$BgDefault/Portrait.texture = load("res://Sprites/Portraits/portrait05Transaprent.png")
		"QA":
			$BgDefault/Portrait.texture = load("res://Sprites/Portraits/portrait06Transaprent.png")
		"Support":
			$BgDefault/Portrait.texture = load("res://Sprites/Portraits/portrait07Transaprent.png")

func _on_Plus_Button_buttonPressed():
	emit_signal("worker_hire_pressed", name)

func _on_Minus_Button_buttonPressed():
	emit_signal("worker_fire_pressed", name)

func UpdateQuantity(quantity):
	$Quantity.text = str(quantity)


func _on_DetailsButton_pressed():
	global.game.soundManager.PlaySFX("Boop")
	global.game.gameTooltip.SetTooltip(name, global.teamDetails[name], null)

