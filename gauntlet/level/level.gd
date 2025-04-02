extends Node3D
class_name Level


signal player_won
signal player_lost

@onready var badguy_template = preload("res://badguys/badguy.tscn")
@onready var player_template = preload("res://player/player.tscn")
@onready var spawner_template = preload("res://badguys/badguy_spawner.tscn")

@onready var player_spawner = %PlayerSpawner

var player: Player
var spawner_count: int


func _ready() -> void:
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	start_game()


func spawn_player() -> void:
	if player != null and not player.is_queued_for_deletion():
		player.queue_free()

	player = player_template.instantiate()
	add_child(player)
	player.position = player_spawner.global_position
	player.shoot.connect(_on_player_shoot)
	player.mine_spawned.connect(_on_player_spawned_mine)
	player.decoy_spawned.connect(_on_player_spawned_decoy)
	player.phasing_toggled.connect(_on_player_toggled_phasing)
	player.death.connect(_on_player_died)
	player.done_winning.connect(_on_player_done_winning)


func spawn_badguy(position: Vector3) -> void:
	var badguy = badguy_template.instantiate()
	add_child(badguy)
	badguy.target = player
	badguy.position = position


func start_game() -> void:
	spawn_player()

	var spawner_spawners = get_tree().get_nodes_in_group("spawner_spawners")
	for spawner_spawner in spawner_spawners:
		var spawner = spawner_template.instantiate()
		add_child(spawner)
		spawner.position = spawner_spawner.position
		spawner.spawned_badguy.connect(_on_spawned_badguy)
		spawner.death.connect(_on_spawner_died)
		spawner_count += 1

		spawn_badguy(spawner.position)


func clean_up() -> void:
	var bullets = get_tree().get_nodes_in_group("bullets")
	for bullet in bullets:
		bullet.queue_free()

	var badguys = get_tree().get_nodes_in_group("badguys")
	for badguy in badguys:
		badguy.queue_free()

	var spawners = get_tree().get_nodes_in_group("spawners")
	for spawner in spawners:
		spawner.queue_free()
		
	if player != null and not player.is_queued_for_deletion():
		player.queue_free()


func _on_player_shoot(
		bullet_template: PackedScene, rotation: Vector3, location: Vector3):
	var bullet = bullet_template.instantiate()
	bullet.add_to_group("bullets")
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


func _on_player_toggled_phasing(on: bool) -> void:
	var badguys = get_tree().get_nodes_in_group("badguys")
	for badguy in badguys:
		badguy.toggle_navigation_timer(not on)


func _on_player_died() -> void:
	player_lost.emit()


func _on_player_done_winning() -> void:
	player_won.emit()


func _on_decoy_is_done(affected_list: Array[Node3D]) -> void:
	# Reset their target to the player
	for affected in affected_list:
		if affected != null and is_queued_for_deletion() == false\
		and affected.is_in_group("badguys"):
			affected.target = player


func _on_spawned_badguy(position: Vector3) -> void:
	if player != null and not player.is_queued_for_deletion():
		spawn_badguy(position)


func _on_spawner_died() -> void:
	spawner_count -= 1
	if spawner_count <= 0:
		player.win()
