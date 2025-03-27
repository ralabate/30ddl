extends Area3D


signal exploded(explosion_template: PackedScene, location: Vector3)

@onready var explosion = preload("res://vfx/mine_explosion.tscn")
@onready var timer = %Timer

var damage_list = []


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	timer.timeout.connect(_on_timer_timeout)


func _on_body_entered(node: Node3D) -> void:
	damage_list.append(node)
	
	if node.is_in_group("player"):
		var player = node as Player
		player.set_firing_rate(0.1)


func _on_body_exited(node: Node3D) -> void:
	damage_list.erase(node)

	if node.is_in_group("player"):
		var player = node as Player
		player.set_firing_rate(1)


func _on_timer_timeout() -> void:
	for badguy in damage_list:
		if badguy.has_node("HealthComponent"):
			var health_component = badguy.get_node("HealthComponent") as HealthComponent
			health_component.damage(5)
	
	exploded.emit(explosion, global_position)
	queue_free()
