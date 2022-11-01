extends Label

var hText
var mText
var sText

func _process(delta):
	hText = str(GlobalTimer.h) if (GlobalTimer.h > 9) else "0" + str(GlobalTimer.h)
	mText = str(GlobalTimer.m) if (GlobalTimer.m > 9) else "0" + str(GlobalTimer.m)
	sText = str(GlobalTimer.s) if (GlobalTimer.s > 9) else "0" + str(GlobalTimer.s)
	
	text = "SLP     " + hText + ":" + mText + ":" + sText
	pass
