class_name MainGame
extends Node2D

# Dependencies
onready var gameTooltip = 	$Tooltip
onready var dateCounter = 	$MainSession/Header/HudLeft/DateCounter
onready var teamScreen = 	$TeamScreen
onready var soundManager = 	$Sounds
onready var header = 		$HeaderLayer/Header
onready var money = 		$HeaderLayer/Header/MoneySystem
onready var phase_hud = 	$HeaderLayer/Header/HudRight/PhaseHUD
onready var web_interface = $WebInterface
onready var main_menu =		$MainMenu
onready var pause_menu = 	$PauseMenu
onready var mm_button = 	$MM_Button
onready var map_screen = 	$MapScreen
onready var main_session = 	$MainSession
onready var win_screen = 	$WinScreen

func _ready():
	global.game = self

	yield(web_interface.ConnectToWeb(), "completed")
	yield(web_interface.LoadFiles(), "completed")
		
	main_menu.visible = true
	main_menu.Start()
	pause_menu.Start()
	mm_button.Start()
	dateCounter.connect("dayTick", main_session, "CheckTime")
	dateCounter.connect("dayTick", header, "CheckTime")

func StartScenario():
	map_screen.visible = false
	global.curPhaseIndex = 0
	header.Start()
	money.SetMoney(global.curScenario()["Money"])
	phase_hud.StartPhase()
	header.visible = true
	teamScreen.Start()
	main_session.Start()
	main_session.ResetCounters()
	main_session.FirstStart()
	main_session.visible = true
	global.curPhaseIndex = -1
	gameTooltip.SetTooltip(trans.local("SCENARIO_POPUP_TITLE"), trans.local("SCENARIO_POPUP_DESC"), null)

func StartNextPhase():
	phase_hud.StartPhase()
	$Projects.Start()
	yield(get_tree().create_timer(0.1),"timeout")
	$Projects.visible = true

func StartProject():
	$Projects.visible = false
	teamScreen.UpdateAvailableWorkers()
	PauseTimer(false)
	header.StartProject()
	$ActionScreen.Start()
	main_session.StartProject()
	main_session.visible = true

func ProjectComplete():
	main_session.visible = false
	if global.curPhaseIndex == -1:
		AdvancePhase()
		return
	PauseTimer(true)
	global.ApplyInsights()
	phase_hud.ShowButton(false)
	if global.curPhaseIndex == 1:
		##################################################
		# print("name your product")
		pass
	AdvancePhase()

func AdvancePhase():
	if global.curPhaseIndex < 8:
		global.curPhaseIndex += 1
		StartNextPhase()
	else:
		Win()

var timerPaused = true
func PauseTimer(pause):
	timerPaused = pause
	if pause:
		dateCounter.timerOn = false
	else:
		dateCounter.t = 0
		dateCounter.timerOn = true

func GameOver():
	PauseTimer(true)
	main_session.office.ClearQueue()
	phase_hud.ShowButton(false)
	gameTooltip.closeIsProceed = true
	var callback = funcref(self, "ExitGame")
	gameTooltip.SetTooltip(trans.local("GAME_OVER"), trans.local("GAME_OVER_DESCR"), callback)

func Win():
	win_screen.Start()
	win_screen.visible = true
	win_screen.scores.text = trans.local("SCORES") + ": " + str(CalcScores())

func CalcScores():
	var points = 0
	points += 20 * main_session.counters["Fit"].good
	points -= 25 * main_session.counters["Fit"].bad
	points += 15 * main_session.counters["Dev"].good
	points -= 20 * main_session.counters["Dev"].bad
	points += 10 * main_session.counters["Market"].good
	points -= 15 * main_session.counters["Market"].bad
	if header.totalDays < 336:
		points += (336 - header.totalDays) * 5
		points += 336 * 3
	else:
		if header.totalDays < 672:
			points += (672 - header.totalDays) * 3
	points += money.total * 5
	return points



func _on_Start_Button_buttonPressed():
	main_menu.visible = false
	mm_button.visible = true
	map_screen.visible = true
	map_screen.Start()

func _on_language_changed(lang):
	yield(web_interface.ChangeLanguage(lang), "completed")
	var _reload = get_tree().reload_current_scene()

func PauseGame(pause):
	if not timerPaused:
		if pause:
			dateCounter.timerOn = false
		else:
			dateCounter.t = 0
			dateCounter.timerOn = true
	pause_menu.visible = pause

func ExitGame():
	PauseTimer(true)
	global.ResetGame()
	phase_hud.ResetPhases()
	for child in get_children():
		if !(child is CanvasItem):
			continue
		child.visible = false
	pause_menu.visible = false
	main_menu.visible = true

func HireWorker(quantity):
	money.AddBurn(int(global.mainConfig["Salary"]) * quantity)
	main_session.office.UpdateMinis()

func OpenTeamScreen(open):
	PauseTimer(open)
	teamScreen.visible = open
	main_session.visible = not open
	if not open:
		money.SetMaxBurn()

func OpenActionScreen(open):
	PauseTimer(open)
	$ActionScreen.visible = open
	main_session.visible = not open
	
func Overtime():
	phase_hud.OverTime()

func CheckEvents(day):
	$EventManager.CheckEvents(day)

func AddMoney(amount):
	money.AddMoney(amount)
