extends Node3D


@export var rotation_rate = 2.0
@export var shield_radius = 1.0

var egg_template = preload("res://player/egg_shield.tscn")
var egg_count: int:
	get:
		return get_child_count()


func _physics_process(delta: float) -> void:
	rotate_y(rotation_rate * delta)


func add_egg() -> void:
	var egg = egg_template.instantiate()
	add_child(egg)

	egg.area_entered.connect(_on_area_entered_egg.bind(egg))
	egg.body_entered.connect(_on_body_entered_egg.bind(egg))

	_update_egg_placement()


func remove_eggs(count: int) -> void:
	for i in range(count):
		var egg = get_child(i)
		egg.queue_free()

	_update_egg_placement()


func _update_egg_placement() -> void:
	var angle_increment = 360.0 / float(get_child_count())
	for i in range(get_child_count()):
		var angle = deg_to_rad(i * angle_increment)
		var egg = get_child(i)
		egg.position.x = shield_radius * cos(angle)
		egg.position.z = shield_radius * sin(angle)


func _add_damage_to(node: Node3D) -> void:
	if node.has_node("HealthComponent"):
		var health_component = node.get_node("HealthComponent") as HealthComponent
		health_component.damage(1)


func _on_body_entered_egg(body: Node3D, egg: Node3D) -> void:
	_add_damage_to(body)
	egg.queue_free()


func _on_area_entered_egg(area: Area3D, egg: Node3D) -> void:
	_add_damage_to(area)
	egg.queue_free()
