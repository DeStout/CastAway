extends Control


var _show := false : set = _show_debug

enum _SFX {NONE, MUSIC, SFX, ALL}
var _sound : int = _SFX.MUSIC : set = _set_sound
var _master_bus := AudioServer.get_bus_index("Master")
var _music_bus := AudioServer.get_bus_index("Music")
var _sfx_bus := AudioServer.get_bus_index("SFX")


func _ready():
	_show_debug(_show)
	_set_sound(_sound)


func _process(delta):
	$FPS.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))


func _unhandled_input(event):
	if Input.is_action_just_pressed("DEBUG_MUTE"):
		_sound = (_sound + 1) % 4
	elif Input.is_action_just_pressed("DEBUG_FPS"):
		_show = !_show


func _show_debug(show_debug) -> void:
	_show = show_debug
	visible = _show


func _set_sound(set_sound) -> void:
	_sound = set_sound
	match _sound:
		_SFX.NONE:
			$Mute.text = "Mute: None"
			AudioServer.set_bus_mute(_master_bus, false)
			AudioServer.set_bus_mute(_music_bus, false)
			AudioServer.set_bus_mute(_sfx_bus, false)
		_SFX.MUSIC:
			$Mute.text = "Mute: Music"
			AudioServer.set_bus_mute(_master_bus, false)
			AudioServer.set_bus_mute(_music_bus, true)
			AudioServer.set_bus_mute(_sfx_bus, false)
		_SFX.SFX:
			$Mute.text = "Mute: SFX"
			AudioServer.set_bus_mute(_master_bus, false)
			AudioServer.set_bus_mute(_music_bus, false)
			AudioServer.set_bus_mute(_sfx_bus, true)
		_SFX.ALL:
			$Mute.text = "Mute: All"
			AudioServer.set_bus_mute(_master_bus, true)
