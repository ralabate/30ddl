extends Area3D


signal done(affected_list: Array[Node3D])

var baduy_list: Array[Node3D] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("badguys"):
		body.target = self
		baduy_list.append(body)


func finished() -> void:
	done.emit(baduy_list)
	queue_free()
