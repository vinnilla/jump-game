extends CharacterBody2D

signal hit

var jump_speed = -750
var gravity = 1000


func _ready() -> void:
	hide()


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func get_input() -> void:
	velocity.x = 0
	var jump = Input.is_action_just_pressed("jump")
	
	if is_on_floor() and jump:
		velocity.y = jump_speed
		
func _physics_process(delta) -> void:
	velocity.y += gravity * delta
	get_input()
	move_and_slide()
	var collision_count = get_slide_collision_count()
	for i in collision_count:
		var collision = get_slide_collision(i)
		if collision:
			var collider = collision.get_collider()
			if collider.name != "Floor":
				print("I collided with ", collision.get_collider().name)
				collider.hide()
				collider.queue_free()
				
				on_hit()
				await get_tree().create_timer(1.0).timeout
				reset()


func on_hit():
	# start hit animation
	$AnimatedSprite2D.animation = "hit"
	$AnimatedSprite2D.play()
	
	# emit hit signal
	hit.emit()
	
	# disable collision
	#$CollisionShape2D.set_deferred("disabled", true)
	
	
func reset() -> void:
	# stop hit animation
	$AnimatedSprite2D.stop()
	
	# enable collision
	#$CollisionShape2D.disabled = false
