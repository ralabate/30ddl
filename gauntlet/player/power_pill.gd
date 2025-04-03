extends Area3D


@export var ATTRACTION_THRESHOLD = 2.0
@export var SPEED = 10.0

var player: Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	Log.info("Pill: [%s] Player: [%s] Distance: [%s]" % [position, player.position, position.distance_to(player.position)])
	if position.distance_to(player.position) < ATTRACTION_THRESHOLD:
		position = position.move_toward(player.position, SPEED * delta)


func _on_body_entered(body: Node3D) -> void:
	queue_free()
