extends Node3D


@onready var badguy_template = preload("res://badguys/badguy.tscn")
@onready var player = %Player


func _ready() -> void:
	player.shoot.connect(_on_player_shoot)
	player.mine_spawned.connect(_on_player_spawned_mine)
	player.decoy_spawned.connect(_on_player_spawned_decoy)
	
	var badguy_spawners = get_tree().get_nodes_in_group("spawners")
	for spawner in badguy_spawners:
		spawner.spawned_badguy.connect(_on_spawned_badguy)
	
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame


func _on_player_shoot(
		bullet_template: PackedScene, rotation: Vector3, location: Vector3):
	var bullet = bullet_template.instantiate()
	add_child(bullet)
	bullet.rotation = rotation
	bullet.position = location


func _on_player_spawned_mine(mine_template: PackedScene, location: Vector3):
	var mine = mine_template.instantiate()
	mine.exploded.connect(_on_mine_exploded)
	add_child(mine)
	mine.position = location


func _on_mine_exploded(explosion_template: PackedScene, location: Vector3):
	var explosion = explosion_template.instantiate()
	add_child(explosion)
	explosion.position = location


func _on_player_spawned_decoy(decoy_template: PackedScene, location: Vector3):
	var decoy = decoy_template.instantiate()
	decoy.done.connect(_on_decoy_is_done)
	add_child(decoy)
	decoy.position = location


func _on_decoy_is_done(affected_list: Array[Node3D]) -> void:
	# Reset their target to the player
	for affected in affected_list:
		if affected != null and is_queued_for_deletion() == false\
		and affected.is_in_group("badguys"):
			affected.target = player


func _on_spawned_badguy(position: Vector3) -> void:
	var badguy = badguy_template.instantiate()
	add_child(badguy)
	badguy.target = player
	badguy.position = position
