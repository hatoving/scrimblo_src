extends Node2D

var timeLeft = 4

var filter = load("res://nodes/main/vhsFilter.tscn")
var vhsAmbience = load("res://nodes/main/vhsAmbience.tscn")
var initTimer = load("res://nodes/init/scenarioInit_timer.tscn")

func _ready():
	JavaScript.eval("initSession()")
	
	add_child(initTimer.instance())
	add_child(filter.instance())
	add_child(vhsAmbience.instance())
	
	$Timer.start()

func _process(delta):
	if timeLeft <= 0:
		Global._changeScene("res://scenes/scenario1.tscn")

func _on_Timer_timeout():
	timeLeft -= 1
