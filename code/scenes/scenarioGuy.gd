extends Node2D

var filter = load("res://nodes/main/vhsFilter.tscn")

var vhsAmbience = load("res://nodes/main/vhsAmbience.tscn")
var ambienceInstance = vhsAmbience.instance()

var voiceLines = [load("res://audio/voice lines/scenario1/guy01.wav"), 
				  load("res://audio/voice lines/scenario1/guy02.wav"), 
				  load("res://audio/voice lines/scenario1/guy03.wav")]
				
var guySprites = [load("res://sprites/section1/guy01.png"), 
				  load("res://sprites/section1/guy02.png")]

var logoAlpha = 0
var guyAlpha = 0

var noiseIntensity = 0.06
var rollSpeed = 3.168

var filterInstance = filter.instance()

var playedVoiceClip = false

var secondsPassed = 0
var phase = -1

func _ready():
	add_child(filterInstance)
	add_child(ambienceInstance)
	
	$BG/Logo.modulate = Color(1, 1, 1, logoAlpha)
	$BG/Guy.modulate = Color(1, 1, 1, guyAlpha)
	
	$BG.modulate = Color(1, 1, 1, 1)
	$BG/Guy.texture = guySprites[0]
	
	$Buttons.hide()
	$BG/GameLogo.hide()
	
	$Timer.start()
	
func _process(delta):
	_scenario1()
	
func _scenario1():	
	match phase:
		-1:
			if secondsPassed > 3:
				phase += 1
				secondsPassed = 0
		0:
			$BG/Logo.show()
			if logoAlpha <= 1:
				logoAlpha += 0.01
			$BG/Logo.modulate = Color(1, 1, 1, logoAlpha)
			
			if secondsPassed > 3:
				phase += 1
				secondsPassed = 0
		1:
			$BG/Guy.show()
			
			if not playedVoiceClip:
				$BG/Guy/Voice.stream = voiceLines[0]
				$BG/Guy/Voice.play()
				playedVoiceClip = true
			
			if logoAlpha >= 0 and guyAlpha <= 1:
				logoAlpha -= 0.01
				guyAlpha += 0.01
				
			$BG/Logo.modulate = Color(1, 1, 1, logoAlpha)
			$BG/Guy.modulate = Color(1, 1, 1, guyAlpha)
			
			if secondsPassed > 7:
				var tween = $BG/Guy/Tween
				
				tween.interpolate_property($BG/Guy, "position", $BG/Guy.position, 
				Vector2(200, 240), 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				
				tween.start()
				
			if not $BG/Guy/Voice.playing and $BG/Guy/Voice.stream == voiceLines[0]:
				phase += 1
				secondsPassed = 0
		2:
			$BG/Logo.hide()
			$Buttons.show()
		3:
			$Buttons.hide()
			
			if not playedVoiceClip:
				$BG/Guy/Voice.stream = voiceLines[2]
				$BG/Guy/Voice.play()
				playedVoiceClip = true
				
			if playedVoiceClip and not $BG/Guy/Voice.playing:
				Global.currentEnding = "best"
				JavaScript.eval("unlockMedal('ez win')")
				JavaScript.eval("unlockMedal('71438')")
				
				Global._changeScene("res://scenes/credits.tscn")
		4:
			$Buttons.hide()
			
			if secondsPassed > 2:
				var tween = $BG/BGTween
				
				tween.interpolate_property($BG, "color", $BG.color, 
				Color(0, 0, 0, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				
				tween.start()
				$BG.modulate = Color(1, 1, 1, 1)
				
			if secondsPassed > 3:
				$BGM.stop()
				$BG/Guy.texture = guySprites[1]
			
			if secondsPassed > 4 and not playedVoiceClip:
				$BG/Guy/Voice.stream = voiceLines[1]
				$BG/Guy/Voice.play()
				playedVoiceClip = true
			
			if secondsPassed > 7:
				if noiseIntensity < 0.75:
					noiseIntensity += 0.01
				elif noiseIntensity > 0.75:
					phase = 5
					secondsPassed = 0
					
				filterInstance.get_child(0).material.set('shader_param/static_noise_intensity', noiseIntensity)
				ambienceInstance.volume_db = noiseIntensity * 20;
		5:
			$BG/Guy.hide()
			$BG/Logo.hide()
			
			noiseIntensity = 0.06
			rollSpeed = 3.186
			
			ambienceInstance.volume_db = 0;
			filterInstance.get_child(0).material.set('shader_param/static_noise_intensity', 0.06)
			
			if secondsPassed > 2:
				$BG/GameLogo.show()
				
			if secondsPassed > 5:
				Global._changeScene("res://scenes/scenario2.tscn")
			

func _on_Timer_timeout():
	secondsPassed += 1

func _on_heck_yeah_pressed():
	print("heck yeah")
	$Buttons/SFX.play()
	playedVoiceClip = false
	phase = 3
	secondsPassed = 0

func _on_fuck_no_pressed():
	print("fuck no")
	$Buttons/SFX.play()
	playedVoiceClip = false
	phase = 4
	secondsPassed = 0
