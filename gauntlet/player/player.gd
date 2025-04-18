extends CharacterBody3D
class_name Player


signal bullet_spawned(bullet: Node3D, direction: Vector3, location: Vector3)
signal mine_spawned(mine: Node3D, location: Vector3)
signal decoy_spawned(decoy: Node3D, location: Vector3)
signal phasing_toggled(on: bool)
signal death
signal done_winning

@export var SPEED = 2.5
@export var TIME_BETWEEN_SHOTS = 0.5

@export var invisibility_material: StandardMaterial3D

@onready var lizardprince_idle = %lizardprince_idle
@onready var lizardprince_attack = %lizardprince_attack
@onready var lizardprince_win = %lizardprince_win
@onready var lizardprince_die = %lizardprince_die

@onready var health_component = %HealthComponent
@onready var phasing_timer = %PhasingTimer
@onready var egg_inventory = %EggInventory


enum Powerup {
	MINE,
	DECOY,
	PHASING,
}

var bullet_template = preload("res://player/bullet.tscn")
var mine_template = preload("res://player/mine.tscn")
var decoy_template = preload("res://player/decoy.tscn")

var can_shoot = true
var shot_timer: Timer
var shot_direction: Vector3

var current_animated_mesh: Node3D

var current_powerup = -1


func _ready() -> void:
	add_to_group("player")

	shot_timer = Timer.new()
	shot_timer.one_shot = true
	shot_timer.wait_time = TIME_BETWEEN_SHOTS
	shot_timer.autostart = false
	shot_timer.timeout.connect(_on_shot_timer_timeout)
	add_child(shot_timer)

	phasing_timer.timeout.connect(_on_phasing_timer_timeout)
	health_component.death.connect(_on_death)

	play_animation(lizardprince_idle)


func _physics_process(delta: float) -> void:
	# Block input when in a cutscene (aka playing dying or winning anim)
	if current_animated_mesh.name == "lizardprince_win" or current_animated_mesh.name == "lizardprince_die":
		return

	# Shooting
	if Input.is_action_pressed("ui_accept") and can_shoot:
		bullet_spawned.emit(
			bullet_template.instantiate(),
			shot_direction,
			transform.origin + transform.basis.z * 0.2
		)
		can_shoot = false
		shot_timer.start()
		play_animation(lizardprince_attack)

	if can_shoot == false:
		return

	# Powerups
	if Input.is_action_just_pressed("player_mine"):
		match current_powerup:
			Powerup.MINE:
				mine_spawned.emit(
					mine_template.instantiate(),
					transform.origin - transform.basis.y
				)
			Powerup.DECOY:
				var decoy = decoy_template.instantiate()
				decoy_spawned.emit(decoy, transform.origin - transform.basis.y)
			Powerup.PHASING:
				self.set_collision_mask_value(1, false)
				toggle_invisibility_material(true)
				phasing_timer.start()
				phasing_toggled.emit(true)

		current_powerup = -1

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Movement input
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()

	if direction:
		# Rotate to face the direction we're moving
		current_animated_mesh.rotation.y = atan2(direction.x, direction.z)
		self.velocity.x = direction.x * SPEED
		self.velocity.z = direction.z * SPEED
		shot_direction = direction
	else:
		self.velocity.x = 0
		self.velocity.z = 0

	# Do it
	move_and_slide()


func set_firing_rate(rate: float) -> void:
	shot_timer.wait_time = TIME_BETWEEN_SHOTS * rate


func activate_powerup(id: Powerup):
	if egg_inventory.egg_count > 0:
		egg_inventory.remove_eggs(egg_inventory.egg_count)
		current_powerup = id
		Log.info("Activating powerup ID: [%s]" % [id])


func add_egg() -> void:
	egg_inventory.add_egg()


func play_animation(anim: Node3D) -> void:
	lizardprince_attack.hide()
	lizardprince_idle.hide()
	lizardprince_win.hide()
	lizardprince_die.hide()
	
	# This should work if we keep consistent naming
	anim.show()
	anim.get_node("AnimationPlayer").play(anim.name)
	
	current_animated_mesh = anim
	Log.info("Anim name: " +  anim.name)

func toggle_invisibility_material(on: bool) -> void:
	var mesh = current_animated_mesh.get_node("Skeleton3D/Mesh") as MeshInstance3D
	if mesh != null:
		mesh.material_override = invisibility_material if on else null


func win() -> void:
	play_animation(lizardprince_win)
	var animation_player = lizardprince_win.get_node("AnimationPlayer") as AnimationPlayer
	await animation_player.animation_finished
	done_winning.emit()


func _on_shot_timer_timeout() -> void:
	can_shoot = true


func _on_phasing_timer_timeout() -> void:
	self.set_collision_mask_value(1, true)
	toggle_invisibility_material(false)
	phasing_toggled.emit(false)


func _on_death() -> void:
	play_animation(lizardprince_die)
	var animation_player = lizardprince_die.get_node("AnimationPlayer") as AnimationPlayer
	await animation_player.animation_finished
	death.emit()
