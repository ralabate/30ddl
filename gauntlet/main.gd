extends Node3D


@onready var player = %Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.shoot.connect(_on_player_shoot)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_shoot(bullet_template: PackedScene, rotation: Vector3, location: Vector3):
	var bullet = bullet_template.instantiate()
	add_child(bullet)
	bullet.rotation = rotation
	bullet.position = location
