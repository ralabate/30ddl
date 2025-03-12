extends CharacterBody3D


@onready var navigation_agent: NavigationAgent3D = %NavigationAgent3D

var movement_speed: float = 0.5


func _ready():
	add_to_group("badguys")

	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5


func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		#print("finished!")
		return

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	
	#print(
		#"velocity: ", velocity, 
		#" current: ", current_agent_position, 
		#" next: ", next_path_position,
		#" target: ", navigation_agent.target_position)
	
	move_and_slide()


func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)
