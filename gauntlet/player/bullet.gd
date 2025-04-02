extends Area3D


@export var SPEED = 2.5
@export var DAMAGE = 1


func _ready() -> void:
	add_to_group("player_bullets")


func _physics_process(delta: float) -> void:
	translate_object_local(Vector3.FORWARD * SPEED * delta)


func _on_body_entered(body: Node3D) -> void:
	if body.has_node("HealthComponent"):
		var health_component = body.get_node("HealthComponent") as HealthComponent
		health_component.damage(1)
	
	queue_free()
