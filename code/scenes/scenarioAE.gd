extends Node2D

var secondsPassed = 0
var phase = 0

var filter = load("res://nodes/main/vhsFilter.tscn")
var vhsAmbience = load("res://nodes/main/vhsAmbience.tscn")

var appear = load("res://audio/sfx/appear.wav")
var select = load("res://audio/sfx/select.wav")

var images = [load("res://sprites/section3/sc3_town.jpg"),
			  load("res://sprites/section3/sc3_congrats.jpg"),
			  load("res://sprites/section3/sc3_face.jpg"),
			  load("res://sprites/section3/sc3_rw.jpg"),
			  load("res://sprites/section3/sc3_threat.jpg"),
			  load("res://sprites/section3/sc3_lego.jpg")]
			
var faces  = [load("res://sprites/section3/sc3_mark.png"),
			  load("res://sprites/section3/sc3_jack.png"),
			  load("res://sprites/section3/sc3_ludwig.png"),
			  load("res://sprites/section3/sc3_quandale.jpg"),
			  load("res://sprites/section3/sc3_schlutt.png"),
			  load("res://sprites/section3/sc3_jerma.png"),
			  load("res://sprites/section3/sc3_dream.png"),
			  load("res://sprites/section3/sc3_tomfulp.png")]
			
var rightAnswer = [1, 0]
var scaryMat = load("res://shaders/spookyFace_mat.tres")

var endVoiceLine = load("res://audio/voice lines/scenario3/scenario03_vl_02.wav")

var chosenCorrect = 0
var chosenWrong = 0

var faceStage = 0

func _ready():
	add_child(filter.instance())
	add_child(vhsAmbience.instance())
	
	$Timer.start()

func _process(delta):
	match(phase):
		0:
			_showContent(2, 3, "SCRIMBLO BIMBLOR\nCOUNTY", 0)
			_hideContent(6)
			
			_showContent(7, 7, "CONGRATULATION!", 1)
			_hideContent(11)
			
			_showContent(12, 13, "YOUR JOB:", 2)
			_hideContent(16)
			
			_showContent(17, 18, "RIGHT OR WRONG", 3)
			_hideContent(20)
				
			_showContent(22, 23, "FRIEND OR FOE?", 4)
			_hideContent(28)
			
			if not $Voice.playing:
				phase += 1
				secondsPassed = 0
		1:
			match(faceStage):
				0:
					rightAnswer = [1, 0]
					_showFaces(faces[0], faces[1], false)
				1:
					rightAnswer = [0, 1]
					_showFaces(faces[2], faces[5], false)
				2:
					rightAnswer = [1, 0]
					_showFaces(faces[4], faces[3], true)
				3:
					rightAnswer = [1, 0]
					_showFaces(faces[7], faces[6], true)
				4:
					$Voice.stream = endVoiceLine
					$Voice.play()
					
					phase += 1
					secondsPassed = 0
		2:
			_showContent(1, 2, "CONGRATULATION!", 1)
			_hideContent(5)
			
			_showContent(8, 10, "PHOTO OF POLICE STATION", 5)
			_hideContent(16)
			
			if not $Voice.playing:
				Global.sc3_correct = chosenCorrect
				Global.sc3_wrong = chosenWrong
				
				Global._changeScene("res://scenes/scenario4.tscn")

func _on_Timer_timeout():
	secondsPassed += 1
	
func _showFaces(var leftFace, var rightFace, var scarifyWrongAnswer):
	if secondsPassed > 1:
		$BG/Label.show()
		$BG/Label.text = "MAKE YOUR DECISION"
	if secondsPassed > 2:
		if not $BG/Faces/Face01.visible:
			$BG/Faces/SFX.stream = appear
			$BG/Faces/SFX.play()
		$BG/Faces/Face01.texture = leftFace
		$BG/Faces/Face01.show()
	if secondsPassed > 3:
		if not $BG/Faces/Face02.visible:
			$BG/Faces/SFX.stream = appear
			$BG/Faces/SFX.play()
		$BG/Faces/Face02.texture = rightFace
		$BG/Faces/Face02.show()
		
	if scarifyWrongAnswer:
		match (rightAnswer):
			[0, 1]:
				$BG/Faces/Face01.material = scaryMat
				$BG/Faces/Face01.material.set_shader_param("brightness", 1.32)
				$BG/Faces/Face01.material.set_shader_param("contrast", 10)
			[1, 0]:
				$BG/Faces/Face02.material = scaryMat
				$BG/Faces/Face02.material.set_shader_param("brightness", 1.32)
				$BG/Faces/Face02.material.set_shader_param("contrast", 10)
				
func _hideFaces():
	$BG/Label.hide()
	$BG/Faces/Face01.hide()
	$BG/Faces/Face02.hide()
	
	$BG/Faces/Face01.material = null
	$BG/Faces/Face02.material = null
	
	faceStage += 1
	secondsPassed = 0

func _showContent(var labelSec, var imageSec, var labelText, var imageIndex):
	if secondsPassed > labelSec:
		if not $BG/Label.visible:
			$BG/Faces/SFX.stream = appear
			$BG/Faces/SFX.play()
		$BG/Label.show()
		$BG/Label.text = labelText
			
	if secondsPassed > imageSec:
		if not $BG/Image.visible:
			$BG/Faces/SFX.stream = appear
			$BG/Faces/SFX.play()
		$BG/Image.texture = images[imageIndex]
		$BG/Image.show()

func _hideContent(var afterHowManySecs):
	if secondsPassed > afterHowManySecs:
		$BG/Label.hide()
		$BG/Image.hide()

func _on_RightFace_pressed():
	$BG/Faces/SFX.stream = select
	$BG/Faces/SFX.play()
	_hideFaces()
	
	match (rightAnswer):
		[1, 0]:
			print("wrong")
			chosenWrong += 1
		[0, 1]:
			print("correct")
			chosenCorrect += 1

func _on_LeftFace_pressed():
	$BG/Faces/SFX.stream = select
	$BG/Faces/SFX.play()
	_hideFaces()
	
	match (rightAnswer):
		[1, 0]:
			print("correct")
			chosenCorrect += 1
		[0, 1]:
			print("wrong")
			chosenWrong += 1
