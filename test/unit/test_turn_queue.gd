extends GutTest

var instance: TurnQueue
var player: Node
var monster: Node

func before_each():
	instance = TurnQueue.new()

	player = Node.new()
	player.name = 'Player'
	instance.add_child(player)

	monster = Node.new()
	monster.name = 'Monster'
	instance.add_child(monster)

func after_each():
	instance.free()

func test_start_turn():
	instance.start()
	assert_eq(instance.active_node, player)

func test_turn_has_started():
	watch_signals(instance)
	instance.start()
	assert_eq(instance.active_node, player)
	assert_signal_emit_count(instance, 'turn_started', 1)

func test_turn_has_ended():
	watch_signals(instance)
	instance.start()
	instance.proceed()
	assert_eq(instance.active_node, monster)
	assert_signal_emit_count(instance, 'turn_ended', 1)

func test_queue_has_finished():
	watch_signals(instance)
	instance.start()
	instance.proceed()
	instance.proceed()
	assert_eq(instance.active_node, null)
	assert_signal_emit_count(instance, 'turn_started', 2)
	assert_signal_emit_count(instance, 'turn_ended', 2)
	assert_signal_emit_count(instance, 'queue_finished', 1)

func test_queue_loop():
	instance.loop = true
	watch_signals(instance)
	instance.start()
	instance.proceed()
	instance.proceed()
	assert_eq(instance.active_node, player)
	assert_signal_emit_count(instance, 'turn_started', 3)
	assert_signal_emit_count(instance, 'turn_ended', 2)
	assert_signal_emit_count(instance, 'queue_finished', 0)
