extends Node3D


@export var linked_bridge: Node3D

@onready var exit_area: Area3D = %ExitArea
@onready var entrance_location: Marker3D = %Entrance


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit_area.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	body.global_position = linked_bridge.entrance_location.global_position
