extends RigidBody3D


@export_enum("Coconut") var ammo_type


func _ready() -> void:
	$Pickup.body_entered.connect(_player_entered)
	$Pickup.body_exited.connect(_player_exited)


func _player_entered(body):
	if body is Player:
		body.add_nearby_ammo(self)


func _player_exited(body):
	if body is Player:
		body.remove_nearby_ammo(self)
