extends Node2D

var filter = load("res://nodes/main/vhsFilter.tscn")
var vhsAmbience = load("res://nodes/main/vhsAmbience.tscn")

var phase = 0

var newsLineSpeed = 2
var newsLineOffset
var newsLineStartPos

var secondsPassed = 0

var emojis = [load("res://sprites/section4/face-with-raised-eyebrow_1f928.png"),
			  load("res://sprites/section4/smiling-face-with-sunglasses_1f60e.png")]
var sfxPlayed = false

func _ready():
	add_child(filter.instance())
	add_child(vhsAmbience.instance())
	
	$BG/YellowBar/Label.rect_position = Vector2(670, $BG/YellowBar/Label.rect_position.y)
	
	newsLineOffset = $BG/YellowBar/Label.text.length() * -19.8
	newsLineStartPos = 670
	
	$Timer.start()
	
# warning-ignore:unused_argument
func _process(delta):
	if $BG/YellowBar/Label.rect_position.x > newsLineOffset:
		$BG/YellowBar/Label.rect_position.x -= newsLineSpeed
	elif $BG/YellowBar/Label.rect_position.x <= newsLineOffset:
		$BG/YellowBar/Label.rect_position.x = newsLineStartPos
		
	match(phase):
		0:
			if secondsPassed > 4:
				phase += 1
				secondsPassed = 0
		1:
			if secondsPassed > 1:
				$BG/Label.text = "breaking news"
				
			if secondsPassed > 3:
				$BG/Label.text = "breaking news\n\nfreddy fazbear was caught dipping\nhis balls into a deep fryer"
			
			if secondsPassed > 6:
				if not $BG/Emoji/AudioPlayer.playing and not sfxPlayed:
					$BG/Emoji/AudioPlayer.play()
					sfxPlayed = true
					
				$BG/Emoji.texture = emojis[0]
				$BG/Emoji.show()
				
			if secondsPassed > 10:
				phase += 1
				secondsPassed = 0
				sfxPlayed = false
		2:
			$BG/Emoji.hide()
			$BG/Label.text = "but don't worry"
			
			if secondsPassed > 3:
				$BG/Label.text = "but don't worry\n\nhe did it in america"
				
			if secondsPassed > 6:
				$BG/Label.text = "but don't worry\n\nhe did it in america\nit's a free country so it's cool"
				
			if secondsPassed > 8:
				$BG/Emoji.texture = emojis[1]
				$BG/Emoji.show()
				
				if not $BG/Emoji/AudioPlayer.playing and not sfxPlayed:
					$BG/Emoji/AudioPlayer.play()
					sfxPlayed = true
					
			if secondsPassed > 9:
				Global._changeScene("res://scenes/scenario5.tscn")
			
			

func _on_Timer_timeout():
	secondsPassed += 1
