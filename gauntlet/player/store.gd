extends Area3D


@export var powerup_type: Player.Powerup


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var player = body as Player
		player.activate_powerup(powerup_type)
