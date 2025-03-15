extends CharacterBody3D


signal shoot(bullet: PackedScene, direction: Vector3, location: Vector3)
signal mine_spawned(mine: PackedScene, location: Vector3)

@export var SPEED = 2.5
@export var TIME_BETWEEN_SHOTS = 1

@onready var animation_player = %AnimatedMesh/AnimationPlayer

var bullet_template = preload("res://player/bullet.tscn")
var mine_template = preload("res://player/mine.tscn")

var can_shoot = true
var shot_timer: Timer


func _ready() -> void:
	shot_timer = Timer.new()
	shot_timer.one_shot = true
	shot_timer.wait_time = TIME_BETWEEN_SHOTS
	shot_timer.autostart = false
	shot_timer.timeout.connect(_on_shot_timer_timeout)
	add_child(shot_timer)


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept") and can_shoot:
		shoot.emit(
				bullet_template,
				rotation,
				transform.origin - transform.basis.z
			)
		can_shoot = false
		shot_timer.start()
		
	if Input.is_action_just_pressed("player_mine"):
		mine_spawned.emit(
				mine_template,
				transform.origin - transform.basis.y
			)

	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()

	if direction:
		rotation.y = atan2(-direction.x, -direction.z)

		self.velocity.x = direction.x * SPEED
		self.velocity.z = direction.z * SPEED

	else:
		self.velocity.x = move_toward(velocity.x, 0, SPEED)
		self.velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_shot_timer_timeout() -> void:
	can_shoot = true
