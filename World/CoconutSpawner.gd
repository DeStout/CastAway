extends Node3D

var spawn = false

var coconut_ := preload("res://Ammo/RigidCoconut.tscn")
var coco_life := 10.0

var timer := Timer.new()
var spawn_per := 100


func _ready():
	if spawn:
		randomize()
		
		add_child(timer)
		timer.connect("timeout", Callable(self, "_spawn"))
		timer.start(1.0/spawn_per)


func _spawn():
	var coconut = coconut_.instantiate()
	add_child(coconut)
	
	var coco_timer = Timer.new()
	coconut.add_child(coco_timer)
	coco_timer.connect("timeout", Callable(coconut, "queue_free"))
	coco_timer.start(coco_life)
	
	coconut.apply_central_impulse(Vector3(0.5 * randf_range(-1, 1), 1.0 * randf(), 0.5 * randf_range(-1, 1)) * randf_range(25, 75))
