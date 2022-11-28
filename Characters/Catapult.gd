extends Node3D


@onready var _player := $"%Player"
@onready var char_pos : Vector3 = $CharPos.global_position
var _attached := false

var ammo1 = null
var ammo2 = null


func _ready() -> void:
	$Body/AttachArea.body_entered.connect(_player_entered)
	$Body/AttachArea.body_exited.connect(_player_exited)


#func _physics_process(delta):
#	if _attached:
#		$PlayerAttach.global_position = _player.global_positions


#func _physics_process(delta):
#	if !_attached:
#		velocity = -Globals.gravity
#	else:
#		velocity = _player.velocity
#	move_and_slide()
#	if is_on_floor():
#		basis = basis.slerp(_align_to_surface(), delta)
#
#
#func _align_to_surface() -> Basis:
#	var new_basis = Basis()
#	new_basis.y = get_floor_normal().reflect(Vector3.UP)
#	new_basis.x = new_basis.y.cross(basis.z)
#	new_basis.z = -new_basis.y.cross(new_basis.x)
#	new_basis = new_basis.orthonormalized()
#	return new_basis


func has_ammo_space() -> bool:
	return (ammo1 == null or ammo2 == null)


func load_ammo(new_ammo) -> void:
	if ammo1 == null:
		$Body/AmmoPos1.add_child(new_ammo)
		ammo1 = new_ammo
	else:
		$Body/AmmoPos2.add_child(new_ammo)
		ammo2 = new_ammo


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
