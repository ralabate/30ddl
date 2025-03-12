extends Node3D


@onready var badguy_template = preload("res://badguy.tscn")
@onready var player = %Player
@onready var nav_timer = %BadguyNavTimer


func _ready() -> void:
	player.shoot.connect(_on_player_shoot)
	
	var badguy_spawners = get_tree().get_nodes_in_group("spawners")
	for spawner in badguy_spawners:
		spawner.spawn_badguy.connect(_on_spawn_badguy)
	
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	nav_timer.start()


func _on_player_shoot(bullet_template: PackedScene, rotation: Vector3, location: Vector3):
	var bullet = bullet_template.instantiate()
	add_child(bullet)
	bullet.rotation = rotation
	bullet.position = location


func _on_badguy_nav_timer_timeout() -> void:
	var badguys = get_tree().get_nodes_in_group("badguys")
	for badguy in badguys:
		badguy.set_movement_target(player.global_position)


func _on_spawn_badguy(position: Vector3) -> void:
	var badguy = badguy_template.instantiate()
	add_child(badguy)
	badguy.position = position
