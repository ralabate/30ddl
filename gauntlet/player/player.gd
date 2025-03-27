extends CharacterBody3D
class_name Player


signal shoot(bullet: PackedScene, direction: Vector3, location: Vector3)
signal mine_spawned(mine: PackedScene, location: Vector3)
signal decoy_spawned(decoy: PackedScene, location: Vector3)
signal death

@export var SPEED = 2.5
@export var TIME_BETWEEN_SHOTS = 0.1

@onready var lizardprince_idle = %lizardprince_idle
@onready var lizardprince_attack = %lizardprince_attack
@onready var health_component = %HealthComponent

var bullet_template = preload("res://player/bullet.tscn")
var mine_template = preload("res://player/mine.tscn")
var decoy_template = preload("res://player/decoy.tscn")

var can_shoot = true
var shot_timer: Timer


func _ready() -> void:
	shot_timer = Timer.new()
	shot_timer.one_shot = true
	shot_timer.wait_time = TIME_BETWEEN_SHOTS
	shot_timer.autostart = false
	shot_timer.timeout.connect(_on_shot_timer_timeout)
	add_child(shot_timer)

	health_component.death.connect(_on_death)

	lizardprince_idle.get_node("AnimationPlayer").play("lizardprince_idle")
	lizardprince_attack.hide()


func _physics_process(delta: float) -> void:
	# Shooting
	if Input.is_action_pressed("ui_accept") and can_shoot:
		shoot.emit(
				bullet_template,
				rotation,
				transform.origin - transform.basis.z
			)
		can_shoot = false
		shot_timer.start()
		lizardprince_attack.show()
		lizardprince_attack.get_node("AnimationPlayer").play("lizardprince_attack")
		lizardprince_idle.hide()

	# Mines
	if Input.is_action_just_pressed("player_mine"):
		mine_spawned.emit(mine_template, transform.origin - transform.basis.y)

	# Player decoys
	if Input.is_action_just_pressed("player_decoy"):
		decoy_spawned.emit(decoy_template, transform.origin - transform.basis.y)

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Movement input
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()

	if direction:
		# Rotate to face the direction we're moving
		rotation.y = atan2(-direction.x, -direction.z)

		self.velocity.x = direction.x * SPEED
		self.velocity.z = direction.z * SPEED

	else:
		self.velocity.x = move_toward(velocity.x, 0, SPEED)
		self.velocity.z = move_toward(velocity.z, 0, SPEED)

	# Do it
	move_and_slide()


func _on_shot_timer_timeout() -> void:
	can_shoot = true


func _on_death() -> void:
	death.emit()
	queue_free()
