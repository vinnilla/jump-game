extends RigidBody2D

var speed = 500


#func _ready() -> void:
	#pass

# move obstacle every frame
func _process(delta: float) -> void:
	var velocity = Vector2(-1, 0) * speed
	position += velocity * delta

# automatically despawn obstacle when it exits screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
