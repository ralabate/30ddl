extends CharacterBody3D


@export var damage_overlay: ShaderMaterial

@onready var navigation_agent: NavigationAgent3D = %NavigationAgent3D
@onready var navigation_timer: Timer = %NavigationTimer
@onready var player_damage_area: Area3D = %PlayerDamageArea
@onready var health_component: HealthComponent = %HealthComponent
@onready var animated_mesh = %AnimatedMesh

var target: Node3D
var movement_speed: float = 0.5


func _ready():
	add_to_group("badguys")

	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	navigation_timer.timeout.connect(_on_navtimer_timeout)
	
	player_damage_area.body_entered.connect(_on_body_entered_dmg_area)
	health_component.damage_received.connect(_on_damage_received)
	health_component.death.connect(_on_death)
	
	animated_mesh.get_node("AnimationPlayer").play("idle")


func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed

	var direction = velocity.normalized()
	rotation.y = atan2(-direction.x, -direction.z)
	move_and_slide()


func update_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)


func toggle_damage_overlay(on: bool) -> void:
	var mesh = animated_mesh.get_node("Skeleton3D/Mesh") as MeshInstance3D
	if mesh != null:
		mesh.material_overlay = damage_overlay if on else null


func toggle_navigation_timer(on: bool) -> void:
	navigation_timer.paused = not on


func _on_navtimer_timeout() -> void:
	if target != null:
		update_movement_target(target.global_position)


func _on_body_entered_dmg_area(body: Node3D) -> void:
	if body.has_node("HealthComponent"):
		var health_component = body.get_node("HealthComponent") as HealthComponent
		health_component.damage(1)


func _on_damage_received(amount: float) -> void:
	toggle_damage_overlay(true)
	await get_tree().create_timer(0.1).timeout
	toggle_damage_overlay(false)


func _on_death() -> void:
	queue_free()
