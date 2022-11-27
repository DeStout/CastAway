extends Control


func _process(delta):
	$FPS.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))
