extends Node3D


@onready var player = %Player
@onready var nav_timer = %BadguyNavTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.shoot.connect(_on_player_shoot)
	
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	nav_timer.start()

func _on_player_shoot(bullet_template: PackedScene, rotation: Vector3, location: Vector3):
	var bullet = bullet_template.instantiate()
	add_child(bullet)
	bullet.rotation = rotation
	bullet.position = location


func _on_badguy_nav_timer_timeout() -> void:
	print("nav timer!")
	var badguys = get_tree().get_nodes_in_group("badguys")
	for badguy in badguys:
		badguy.set_movement_target(player.global_position)
