extends Node3D


@export var rotation_rate = 2.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Area3D:
			child.body_entered.connect(_on_body_entered_egg.bind(child))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	rotate_y(rotation_rate * delta)


func _on_body_entered_egg(body: Node3D, egg: Node3D):
	body.queue_free()
	egg.queue_free()
