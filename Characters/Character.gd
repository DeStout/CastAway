extends CharacterBody3D
class_name Player

const FREE_MAX_SPEED := 8.0
const ATTACHED_MAX_SPEED := 3.0
const FREE_ACCEL := 2.0
const ATTACHED_ACCEL := 1.0
const DEACCEL := 1.0
const MOUSE_HORZ_SENS := -0.005

@onready var _island := get_parent()
@onready var _catapult := $"%Catapult"
var _catapult_in_range := false
var _attached := false

signal ammo_picked_up
signal ammo_dropped
var nearby_ammo := []
var ammo_type = null
var held_ammo = null


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ammo_picked_up.connect(_island.remove_ammo)
	ammo_dropped.connect(_island.add_ammo)


func _input(event) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(MOUSE_HORZ_SENS * event.relative.x)
		if velocity == Vector3.ZERO:
			$ArmBuffer.transform.basis = $ArmBuffer.transform.basis.slerp((
									$ArmBuffer.transform.basis.looking_at(Vector3.FORWARD)), 0.1)
	
	if Input.is_action_just_pressed("Pickup"):
		if held_ammo == null:
			_pickup_ammo()
		else:
			if _catapult_in_range:
				pass
			else:
				_drop_ammo()
	if Input.is_action_just_pressed("Attach"):
		if _catapult_in_range:
			if !_attached:
				_attach()
			else:
				_detach()


func _physics_process(delta) -> void:
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = -(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		if !_attached:
			velocity.x += direction.x * FREE_ACCEL
			velocity.z += direction.z * FREE_ACCEL
			velocity = velocity.limit_length(FREE_MAX_SPEED)
		else:
			velocity.x += direction.x * ATTACHED_ACCEL
			velocity.z += direction.z * ATTACHED_ACCEL
			velocity = velocity.limit_length(ATTACHED_MAX_SPEED)
		
		$ArmBuffer.transform.basis = $ArmBuffer.transform.basis.slerp(($ArmBuffer.transform.basis.looking_at(Vector3(input_dir.x, 0, input_dir.y))), 0.3)
		$AnimationPlayer.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, DEACCEL)
		velocity.z = move_toward(velocity.z, 0, DEACCEL)
		$AnimationPlayer.play("Idle")
		
	velocity -= Globals.gravity
		
	move_and_slide()


func catapult_in_range() -> void:
	_catapult_in_range = true


func catapult_out_of_range() -> void:
	_catapult_in_range = false


func _attach() -> void:
	_attached = true
	_catapult.attach()
	global_position = _catapult.get_node("CharPos").global_position
	basis = basis.looking_at(-_catapult.basis.z)
	$ArmBuffer.basis = basis.looking_at(-basis.z)


func _detach() -> void:
	_attached = false
	_catapult.detach()


func _pickup_ammo() -> void:
	if nearby_ammo.size() > 0:
		held_ammo = nearby_ammo.pop_at(_closest_ammo())
		ammo_type = held_ammo.ammo_type
		ammo_picked_up.emit(held_ammo)
		held_ammo = Globals.ammo[ammo_type].instantiate()
		$Ammo.add_child(held_ammo)


func _drop_ammo() -> void:
	ammo_dropped.emit(ammo_type, held_ammo.global_position)
	$Ammo.remove_child(held_ammo)
	held_ammo.queue_free()
	held_ammo = null
	ammo_type = null


func _closest_ammo() -> int:
	var closest_ammo = nearby_ammo[0]
	for ammo in nearby_ammo:
		if global_position.distance_squared_to(ammo.global_position) < \
				global_position.distance_squared_to(closest_ammo.global_position):
			closest_ammo = ammo
	return nearby_ammo.find(closest_ammo)


func add_nearby_ammo(new_ammo) -> void:
	if !nearby_ammo.has(new_ammo):
		nearby_ammo.append(new_ammo)


func remove_nearby_ammo(old_ammo) -> void:
	if nearby_ammo.has(old_ammo):
		nearby_ammo.erase(old_ammo)
