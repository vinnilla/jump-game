extends Sprite2D

# generate random speed between 20 and 80
var speed = randi() % 61 + 20

func _process(delta: float) -> void:
	var velocity = Vector2(-1, 0) * speed 
	position += velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
