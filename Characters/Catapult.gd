extends CharacterBody3D


var _attached := false


func _physics_process(delta):
	velocity = -Globals.gravity
	move_and_slide()
	if is_on_floor():
		_align_to_surface()


func _align_to_surface() -> void:
	basis.y = get_floor_normal().reflect(Vector3.UP)
	basis.x = basis.y.cross(basis.z)
	basis.z = -basis.y.cross(basis.x)
	basis = basis.orthonormalized()


func attach() -> void:
	_attached = true


func detach() -> void:
	_attached = false


func _player_entered(body):
	if body is Player:
		body.catapult_in_range()


func _player_exited(body):
	if body is Player:
		body.catapult_out_of_range()
