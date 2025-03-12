extends Node
class_name HealthComponent


signal damage_received(amount: int)
signal death

@export var MAX_HEALTH = 0
@onready var current_health = MAX_HEALTH


func damage(amount: int):
	current_health -= amount
	damage_received.emit(amount)
	Log.info("[%s] took [%s] dmg current_health = [%s]" % 
			[get_parent().name, amount, current_health])
	
	if current_health <= 0:
		death.emit()
		get_parent().queue_free()
