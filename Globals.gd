extends Node


var gravity = Vector3(0, ProjectSettings.get_setting("physics/3d/default_gravity"), 0)


var rigid_ammo = {0 : preload("res://Ammo/RigidCoconut.tscn")}
var ammo = {0 : preload("res://Ammo/Coconut.tscn"), 1 : preload("res://Ammo/Banana.tscn")}


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func _input(event):
	if Input.is_action_just_pressed("Pause"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().paused = true
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_tree().paused = false
