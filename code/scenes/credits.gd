extends Node2D

var filter = load("res://nodes/main/vhsFilter.tscn")
var vhsAmbience = load("res://nodes/main/vhsAmbience.tscn")

var select = load("res://audio/sfx/select.wav")

func _ready():
	add_child(filter.instance())
	add_child(vhsAmbience.instance())
	
	$BG/Credits2.text = "you got the " + str(Global.currentEnding) + " ending"

func _on_TryAgain_pressed():
	$BG/SFX.stream = select
	$BG/SFX.play()
	
	Global.sc3_correct = 0
	Global.sc3_wrong = 0
	Global.sc5_face = null
	Global.sc5_faceBrightness = 0
	Global.sc5_faceContrast = 0
	
	Global._changeScene("res://scenes/init.tscn")
