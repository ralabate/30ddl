extends Area3D


@export var SPEED = 10


func _physics_process(delta: float) -> void:
	translate_object_local(Vector3.FORWARD * SPEED * delta)


func _on_body_entered(body: Node3D) -> void:
	queue_free()
