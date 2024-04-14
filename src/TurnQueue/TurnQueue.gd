@icon('./TurnQueue.svg')
class_name TurnQueue
extends Node

signal turn_started(node: Node)
signal turn_ended(node: Node)
signal queue_finished()

@export var active_node: Node = null

# If enabled, the queue will loop back to the first when end is reached
# Otherwise, it'll just stop
@export var loop: bool = false

var finished: bool = false

func start() -> void:
	# Select the first node if none defined
	if not active_node and get_child_count() > 0:
		active_node = get_child(0)

	# Starts the queue off the main thread
	if active_node:
		finished = false
		turn_started.emit(active_node)

func stop() -> void:
	finished = true
	queue_finished.emit()

func proceed() -> void:
	if finished:
		return

	turn_ended.emit(active_node)

	# The queue could've been terminated on turn_ended
	if finished:
		return

	if get_child_count() > 0 and (loop or active_node.get_index() + 1 < get_child_count()):
		# The sort order of the nodes determine the act order
		var new_index: int = (active_node.get_index() + 1) % get_child_count()
		active_node = get_child(new_index)
		turn_started.emit(active_node)
	else:
		# If there are no nodes to activate, stop the queue
		active_node = null
		stop()
