extends Node3D


@export var rotation_rate = 2.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Area3D:
			child.area_entered.connect(_on_area_entered_egg.bind(child))
			child.body_entered.connect(_on_body_entered_egg.bind(child))


func _physics_process(delta: float) -> void:
	rotate_y(rotation_rate * delta)


func add_damage_to(node: Node3D) -> void:
	if node.has_node("HealthComponent"):
		var health_component = node.get_node("HealthComponent") as HealthComponent
		health_component.damage(1)


func _on_body_entered_egg(body: Node3D, egg: Node3D) -> void:
	add_damage_to(body)
	egg.queue_free()


func _on_area_entered_egg(area: Area3D, egg: Node3D) -> void:
	add_damage_to(area)
	egg.queue_free()
