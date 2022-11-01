extends Node

var sc3_wrong = 0
var sc3_correct = 0

var sc5_face = null
var sc5_faceBrightness
var sc5_faceContrast

var currentEnding = "worst"

func _quitGame():
	get_tree().quit()
	
func _changeScene(var scene):
	print("Changing scene to " + scene)
	get_tree().change_scene(scene)
