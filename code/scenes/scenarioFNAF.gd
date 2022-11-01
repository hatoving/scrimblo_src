extends Node2D

var vhsAmbience = load("res://nodes/main/vhsAmbience.tscn")
var filter = load("res://nodes/main/vhsFilter.tscn")

var username
var cameraSpeed = 2

var phase = 0
var secondsPassed = 0

var phonePlayed = false
var flashPlayed = false

func _ready():
	add_child(filter.instance())
	add_child(vhsAmbience.instance())
	
	username = JavaScript.eval("ngio.user.name") if (OS.get_name() == "HTML5") else str(OS.get_environment("USERNAME"))
	
	$Label.text = ""
	
	$ViewportContainer/Face.texture = Global.sc5_face
	$ViewportContainer/Face.material.set_shader_param("brightness", Global.sc5_faceBrightness)
	$ViewportContainer/Face.material.set_shader_param("contrast", Global.sc5_faceContrast)
	
	$Timer.start()
	pass
	
func _process(delta):
	match(phase):
		0:
			if secondsPassed > 2:
				$Label.text = "FIGHT OFF YOUR OWN CREATION,\n" + str(username) 
				
			if secondsPassed > 5:
				$Label.text = "IT'S GONNA BE SUPER FUNNY"
				
			if secondsPassed > 8:
				$Label.text = ""
				
			if secondsPassed > 11:
				$Label.text = "NIGHT 1\n12 PM"
				
			if secondsPassed > 15:
				phase += 1
				secondsPassed = 0
		1:
			$Label.hide()
			
			$ViewportContainer/Viewport/Camera.show()
			$ViewportContainer.show()
			
			if Input.is_action_pressed("ui_left"):
				if $ViewportContainer/Viewport/Camera.position.x > 320 - 60:
					$ViewportContainer/Viewport/Camera.position.x -= cameraSpeed
			
			if Input.is_action_pressed("ui_right"):
				if $ViewportContainer/Viewport/Camera.position.x < 320 + 60:
					$ViewportContainer/Viewport/Camera.position.x += cameraSpeed
					
			if $ViewportContainer/Viewport/Camera.position.x > 320 - 60 and $ViewportContainer/Viewport.get_mouse_position().x < 250:
					$ViewportContainer/Viewport/Camera.position.x -= cameraSpeed
			
			if $ViewportContainer/Viewport/Camera.position.x < 320 + 60 and $ViewportContainer/Viewport.get_mouse_position().x > 490:
					$ViewportContainer/Viewport/Camera.position.x += cameraSpeed
					
			if secondsPassed > 4:
				if not $ViewportContainer/Viewport/BG/Phone/Audio.playing and not phonePlayed:
					$ViewportContainer/Viewport/BG/Phone/Audio.play()
					phonePlayed = true
					
			if secondsPassed > 68:
				$ViewportContainer/Face.scale.x += 0.125
				$ViewportContainer/Face.scale.y += 0.125
				$ViewportContainer/Face.rotation += 0.125 * 2
				
			if $ViewportContainer/Face.scale.x > 1:
				phase += 1
				secondsPassed = 0
					
			match(secondsPassed):
				45:
					$ViewportContainer/GameLabels/Night.text = "NIGHT 1\n1 AM"
				90:
					$ViewportContainer/GameLabels/Night.text = "NIGHT 1\n2 AM"
				135:
					$ViewportContainer/GameLabels/Night.text = "NIGHT 1\n3 AM"
					
		2:
			$ViewportContainer.hide()
			$ViewportContainer/Viewport/BG/Phone/Audio.stop()
			
			$AMRect.show()
			
			if not $AMRect/Flashbang.playing and not flashPlayed:
				$AMRect/Flashbang.play()
				flashPlayed = true
				
			if secondsPassed > 3:
				JavaScript.eval("unlockMedal('Pretty bad learner')")
				JavaScript.eval("unlockMedal('71439')")
				
				Global._changeScene("res://scenes/credits.tscn")


func _on_Timer_timeout():
	secondsPassed += 1
