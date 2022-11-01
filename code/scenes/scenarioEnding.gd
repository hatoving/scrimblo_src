extends Node2D

var secondsPassed = 0

var filter = load("res://nodes/main/vhsFilter.tscn")
var vhsAmbience = load("res://nodes/main/vhsAmbience.tscn")

var voiceLines = [load("res://audio/voice lines/scenario6/sc6_vl_good.wav"), 
				  load("res://audio/voice lines/scenario6/sc6_vl_bad.wav")]
				
var guySprites = [load("res://sprites/section1/guy01.png"), 
				  load("res://sprites/section1/guy02.png")]
				
var phase = 0
var playedVoiceClip = false

func _ready():
	add_child(filter.instance())
	add_child(vhsAmbience.instance())
	
	rand_seed(656)
	$BGM.play(rand_range(21, 50))
	
	$BG/Guy/Voice.stream = voiceLines[0]
	$BG/Guy/Voice.play()
	
	$Timer.start()

func _process(delta):
	match (phase):
		0:
			if not $BG/Guy/Voice.playing:
				phase += 1
				secondsPassed = 0
		1:
			if Global.sc3_correct > Global.sc3_wrong:
				Global.currentEnding = "good"
				JavaScript.eval("unlockMedal('Survived')")
				JavaScript.eval("unlockMedal('71440')")
				
				Global._changeScene("res://scenes/credits.tscn")
			else:
				Global.currentEnding = "worst"
				$BGM.stop()
			
				$BG.color = Color(0, 0, 0, 1)
				$BG/Guy.texture = guySprites[1]
			
				if secondsPassed > 2:
					if not $BG/Guy/Voice.playing and not playedVoiceClip:
						$BG/Guy/Voice.stream = voiceLines[1]
						$BG/Guy/Voice.play()
						playedVoiceClip = true
					
				if not $BG/Guy/Voice.playing and playedVoiceClip:
					Global._changeScene("res://scenes/scenario7.tscn")

func _on_Timer_timeout():
	secondsPassed += 1
