extends Node2D

var filter = load("res://nodes/main/vhsFilter.tscn")
var vhsAmbience = load("res://nodes/main/vhsAmbience.tscn")

var phase = 0

var newsLineSpeed = 2
var newsLineOffset
var newsLineStartPos

var secondsPassed = 0

var skeletonEmoji = load("res://sprites/section2/skull_1f480.png")
var sfxPlayed = false

func _ready():
	add_child(filter.instance())
	add_child(vhsAmbience.instance())

	newsLineStartPos = 640
	$BG/YellowBar/Label.rect_position = Vector2(newsLineStartPos, $BG/YellowBar/Label.rect_position.y)
	
	newsLineOffset = $BG/YellowBar/Label.text.length() * -19.8
	
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
				$BG/Label.text = "breaking news\n\nspooky animatronics\nare near your area for five nights"
			
			if secondsPassed > 6:
				if not $BG/Emoji/AudioPlayer.playing and not sfxPlayed:
					$BG/Emoji/AudioPlayer.play()
					sfxPlayed = true
					
				$BG/Emoji.show()
				
			if secondsPassed > 10:
				phase += 1
				secondsPassed = 0
				sfxPlayed = false
		2:
			$BG/Emoji.hide()
			$BG/Label.text = "we don't really know what to tell you now"
			
			if secondsPassed > 3:
				$BG/Label.text = "we don't really know what to tell you now\n\nunlucky ass mf"
				
			if secondsPassed > 6:
				$BG/Label.text = "we don't really know what to tell you now\n\nunlucky ass mf\nlmao"
				
			if secondsPassed > 8:
				$BG/Emoji.texture = skeletonEmoji
				$BG/Emoji.show()
				
				if not $BG/Emoji/AudioPlayer.playing and not sfxPlayed:
					$BG/Emoji/AudioPlayer.play()
					sfxPlayed = true
					
			if secondsPassed > 9:
				Global._changeScene("res://scenes/scenario3.tscn")
			

func _on_Timer_timeout():
	secondsPassed += 1
