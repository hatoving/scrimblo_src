extends Node2D

var s = 0
var m = 0
var h = 0

func _ready():
	print("Starting timer")
	$Timer.start()

func _process(delta):
	if s > 59:
		m += 1
		s = 0
	if m > 59:
		h += 1
		m = 0
	if h > 99:
		h = 0
		m = 0
		s = 0
	pass

func _on_Timer_timeout():
	s += 1
	pass # Replace with function body.
