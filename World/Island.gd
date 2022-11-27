extends Node3D


func remove_ammo(old_ammo) -> void:
	old_ammo.queue_free()


func add_ammo(new_ammo_type, new_ammo_pos) -> void:
	var new_ammo = Globals.rigid_ammo[new_ammo_type].instantiate()
	$Ammo.add_child(new_ammo)
	new_ammo.global_position = new_ammo_pos
