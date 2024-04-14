@icon("./Heart.svg")
class_name HealthComponent
extends Node

@export var max_health: float = 100.0

signal changed(health: float)
signal healed(amount: float)
signal damaged(amount: float)
signal died()
signal revived()

var health: float

func _ready() -> void:
	health = max_health

func heal(amount: float) -> void:
	if is_dead() or amount < 0:
		return
	var old_health := health
	health = min(health + amount, max_health)
	healed.emit(health - old_health)
	if amount != 0:
		changed.emit(health)

func damage(amount: float) -> void:
	if is_dead() or amount < 0:
		return
	health -= amount
	damaged.emit(amount)
	if amount != 0:
		changed.emit(health)
	if is_dead():
		died.emit()

# Revive the entity with the given amount of health (bypasses the dead state)
func revive(amount: float) -> void:
	if is_dead() and amount > 0:
		health = amount
		revived.emit()
		healed.emit(health)
		changed.emit(health)

func is_alive() -> bool:
	return health > 0

func is_dead() -> bool:
	return health <= 0

func is_full() -> bool:
	return health == max_health
