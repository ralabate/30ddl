extends Area3D


signal done(affected_list: Array[Node3D])
signal bullet_spawned(bullet: Node3D, direction: Vector3, location: Vector3)

var bullet_template = preload("res://player/bullet.tscn")
var baduy_list: Array[Node3D] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


func finished() -> void:
	done.emit(baduy_list)
	queue_free()


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("badguys"):
		body.target = self
		baduy_list.append(body)


func _on_player_spawned_bullet(
	bullet: Node3D,
	direction: Vector3,
	location: Vector3
) -> void:
	bullet_spawned.emit(
		bullet_template.instantiate(),
		direction,
		position
	)
