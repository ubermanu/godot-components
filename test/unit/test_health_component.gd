extends GutTest

var instance: HealthComponent

func before_each():
	instance = HealthComponent.new()
	instance.health = 100.0
	instance.max_health = 100.0

func after_each():
	instance.free()

func test_health_is_full_when_created():
	assert_eq(instance.health, instance.max_health)

func test_health_is_reduced_when_taking_damage():
	instance.damage(10.0)
	assert_eq(instance.health, instance.max_health - 10.0)

func test_health_is_increased_when_healing():
	instance.health = 50.0
	instance.heal(10.0)
	assert_eq(instance.health, 60.0)

func test_health_is_not_increased_over_max_health():
	instance.health = 90.0
	instance.heal(20.0)
	assert_eq(instance.health, instance.max_health)

func test_health_is_not_reduced_below_zero():
	instance.damage(200.0)
	assert_eq(instance.health, 0.0)
	assert_true(instance.is_dead())

func test_health_cannot_be_restored_when_dead():
	instance.damage(200.0)
	assert_true(instance.is_dead())
	instance.heal(10.0)
	assert_eq(instance.health, 0.0)
	assert_true(instance.is_dead())
