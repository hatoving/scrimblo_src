extends Node2D

var filter = load("res://nodes/main/vhsFilter.tscn")
var vhsAmbience = load("res://nodes/main/vhsAmbience.tscn")

var voiceLines = [load("res://audio/voice lines/scenario5/sc5_vl_mj.wav"), 
				  load("res://audio/voice lines/scenario5/sc5_vl_rock.wav"), 
				  load("res://audio/voice lines/scenario5/sc5_vl_matpat.wav"),
				  load("res://audio/voice lines/scenario5/sc5_vl_walt.wav")]
				
var appear = load("res://audio/sfx/appear.wav")
var select = load("res://audio/sfx/select.wav")

var secondsPassed = 0
var phase = 0

var label1Alpha = 0
var label2Alpha = 0

var chooseFaceAlpha = 0
var configureFaceAlpha = 0

var chosenFace = null

var faceAlpha = 0
var facePlayed = false

var hallwayAlpha = 0

var scaryMat = load("res://shaders/spookyFace_mat.tres")
var musicPlaying = false

func _ready():
	add_child(filter.instance())
	add_child(vhsAmbience.instance())
	
	$BG/FirstPortion/Label.modulate = Color(1, 1, 1, label1Alpha)
	$BG/FirstPortion/Label2.modulate = Color(1, 1, 1, label2Alpha)
	$BG/SecondPortion/Label.modulate = Color(1, 1, 1, chooseFaceAlpha)
	$BG/ThirdPortion/Label.modulate = Color(1, 1, 1, configureFaceAlpha)
	
	$BG/ThirdPortion/Sliders.hide()
	
	$"BG/ThirdPortion/Done!".hide()
	
	$BG/FourthPortion/Sc5Hallway.modulate = Color(1, 1, 1, hallwayAlpha)
	
	$Timer.start()

func _process(delta):
	match(phase):
		0:
			if secondsPassed > 2 and secondsPassed < 9:
				if not $BGM.playing and not musicPlaying:
					musicPlaying = true
					$BGM.play()
				
				if label1Alpha <= 1:
					label1Alpha += 0.05
					
			$BG/FirstPortion/Label.modulate = Color(1, 1, 1, label1Alpha)
				
			if secondsPassed > 4 and secondsPassed < 9:
				if label2Alpha <= 1:
					label2Alpha += 0.05
					
			$BG/FirstPortion/Label2.modulate = Color(1, 1, 1, label2Alpha)
			
			if secondsPassed > 8:
				label1Alpha -= 0.05
				label2Alpha -= 0.05
				
				$BG/FirstPortion/Label.modulate = Color(1, 1, 1, label1Alpha)
				$BG/FirstPortion/Label2.modulate = Color(1, 1, 1, label2Alpha)
				
				if label1Alpha <= 0:
					phase += 1
					secondsPassed = 0
					
		1:
			if secondsPassed > 1:
				$BG/FirstPortion.hide()
				$BG/SecondPortion.show()
				$BG/SecondPortion/Faces.hide()
				
			if secondsPassed > 3:
				if chooseFaceAlpha < 1:
					chooseFaceAlpha += 0.05
			
			$BG/SecondPortion/Label.modulate = Color(1, 1, 1, chooseFaceAlpha)
			
			_disableFaces()
				
			if secondsPassed > 5:
				if not $BG/SecondPortion/Faces.visible:
					$BG/SFX.stream = appear
					$BG/SFX.play()
				$BG/SecondPortion/Faces.show()
				
			if secondsPassed > 6:
				if not $BG/SecondPortion/Faces/Face2.visible:
					$BG/SFX.play()
				$BG/SecondPortion/Faces/Face2.show()	
			
			if secondsPassed > 7:
				if not $BG/SecondPortion/Faces/Face3.visible:
					$BG/SFX.play()
				$BG/SecondPortion/Faces/Face3.show()	
				
			if secondsPassed > 8:
				if not $BG/SecondPortion/Faces/Face4.visible:
					$BG/SFX.play()
				$BG/SecondPortion/Faces/Face4.show()
			
			if secondsPassed > 9:
				if not $BG/SecondPortion/Faces/Face5.visible:
					$BG/SFX.play()
				$BG/SecondPortion/Faces/Face5.show()	
				_enableFaces()
		2:
			$BG/SecondPortion.hide()
			
			$BG/ThirdPortion.show()
			$BG/Face.hide()
			
			$BG/Face.texture = chosenFace
			$BG/Face.material = scaryMat
			
			if secondsPassed > 2:
				if configureFaceAlpha < 1:
					configureFaceAlpha += 0.05
					
			$BG/ThirdPortion/Label.modulate = Color(1, 1, 1, configureFaceAlpha)
			
			if secondsPassed > 4:
				if not $BG/ThirdPortion/Sliders.visible:
					$BG/SFX.stream = appear
					$BG/SFX.play()
				$BG/ThirdPortion/Sliders.show()
				
				$"BG/ThirdPortion/Done!".show()
				$"BG/ThirdPortion/Done!".disabled = false
				
				$BG/Face.show()

				$BG/Face.material.set_shader_param("brightness", $BG/ThirdPortion/Sliders/HSlider.value)
				$BG/Face.material.set_shader_param("contrast", $BG/ThirdPortion/Sliders/HSlider2.value)
		3:
			$BG/ThirdPortion.hide()
			$BG/FourthPortion.show()
			
			$BGM.stop()
			
			$BG/Face.position.x = 319
			$BG/Face.position.y = 237
			
			$BG/Face.scale.x = 0.1
			$BG/Face.scale.y = 0.1
			
			if secondsPassed > 3 and hallwayAlpha <= 1:
				hallwayAlpha += 0.05
				$BG/FourthPortion/Sc5Hallway.modulate = Color(1, 1, 1, hallwayAlpha)
			
			if secondsPassed > 7 and faceAlpha <= 1:
				if not facePlayed and not $BG/Face/SFX.playing:
					match($BG/Face.texture.resource_path):
						"res://sprites/section5/sc5_rock.png":
							$BG/Face/SFX.stream = voiceLines[1]
						"res://sprites/section5/sc5_micheal.png":
							$BG/Face/SFX.stream = voiceLines[0]
						"res://sprites/section5/sc5_matpat.png":
							$BG/Face/SFX.stream = voiceLines[2]
						"res://sprites/section5/sc5_walt.png":
							$BG/Face/SFX.stream = voiceLines[3]
					
					$BG/Face/SFX.play()
					facePlayed = true
				faceAlpha += 0.01
				
			$BG/Face.modulate = Color(1, 1, 1, faceAlpha)
				
			if not $BG/Face/SFX.playing and facePlayed:
				Global.sc5_face = $BG/Face.texture
				Global.sc5_faceBrightness = $BG/Face.material.get_shader_param("brightness")
				Global.sc5_faceContrast = $BG/Face.material.get_shader_param("contrast")
				
				Global._changeScene("res://scenes/scenario6.tscn")

func _on_Timer_timeout():
	secondsPassed += 1
	
func _disableFaces():
	$BG/SecondPortion/Faces/Face1.show()
	$BG/SecondPortion/Faces/Face2.hide()
	$BG/SecondPortion/Faces/Face3.hide()
	$BG/SecondPortion/Faces/Face4.hide()
	$BG/SecondPortion/Faces/Face5.hide()
	
	$BG/SecondPortion/Faces/Face1/Button.disabled = true
	$BG/SecondPortion/Faces/Face2/Button.disabled = true
	$BG/SecondPortion/Faces/Face3/Button.disabled = true
	$BG/SecondPortion/Faces/Face4/Button.disabled = true
	$BG/SecondPortion/Faces/Face5/Button.disabled = true
	
func _enableFaces():
	$BG/SecondPortion/Faces/Face1/Button.disabled = false
	$BG/SecondPortion/Faces/Face2/Button.disabled = false
	$BG/SecondPortion/Faces/Face3/Button.disabled = false
	$BG/SecondPortion/Faces/Face4/Button.disabled = false
	$BG/SecondPortion/Faces/Face5/Button.disabled = false

func _on_Face1_pressed():
	$BG/SFX.stream = select
	$BG/SFX.play()
	
	chosenFace = $BG/SecondPortion/Faces/Face1.texture
	phase += 1
	secondsPassed = 0

func _on_Face2_pressed():
	$BG/SFX.stream = select
	$BG/SFX.play()
	
	chosenFace = $BG/SecondPortion/Faces/Face2.texture
	phase += 1
	secondsPassed = 0

func _on_Face3_pressed():
	$BG/SFX.stream = select
	$BG/SFX.play()
	
	chosenFace = $BG/SecondPortion/Faces/Face3.texture
	phase += 1
	secondsPassed = 0

func _on_Face4_pressed():
	$BG/SFX.stream = select
	$BG/SFX.play()
	
	chosenFace = $BG/SecondPortion/Faces/Face4.texture
	phase += 1
	secondsPassed = 0
	
func _on_Face5_pressed():
	$BG/SFX.stream = select
	$BG/SFX.play()
	
	chosenFace = $BG/SecondPortion/Faces/Face5.texture
	phase += 1
	secondsPassed = 0

func _on_Done_pressed():
	$BG/SFX.stream = select
	$BG/SFX.play()
	
	phase += 1
	secondsPassed = 0
