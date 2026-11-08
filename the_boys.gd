extends CharacterBody2D

signal hit

var JUMP_SPEED = -600
var MOVE_SPEED = 200
var GRAVITY = 1000

var double_jump_enabled = false

func _ready() -> void:
	hide()

# runs when the start button is pressed
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# process user input
func get_input() -> void:
	velocity.x = 0
	var jump = Input.is_action_just_pressed("jump")
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	
	# first jump
	if is_on_floor() and jump:
		velocity.y = JUMP_SPEED
		double_jump_enabled = true
	
	# double jump
	if not is_on_floor() and jump and double_jump_enabled:
		velocity.y = JUMP_SPEED
		double_jump_enabled = false
	
	# move left
	if left:
		velocity.x = -MOVE_SPEED
	
	# move right
	if right:
		velocity.x = MOVE_SPEED

# overloaded function that processes physics interactions every frame
func _physics_process(delta) -> void:
	velocity.y += GRAVITY * delta
	get_input()
	move_and_slide()
	var collision_count = get_slide_collision_count()
	if collision_count > 0:
		for i in collision_count:
			var collision = get_slide_collision(i)
			if collision:
				var collider = collision.get_collider()
				# check for left and right world boundaries
				if collider.name == "LeftWall" or collider.name == "RightWall":
					print("x movement intercepted: ", collider.name)
					velocity.x = 0
				# check for damaging collisions
				elif collider.name != "Floor":
					print("I collided with ", collision.get_collider().name)
					collider.hide()
					collider.queue_free()
					
					on_hit()
					await get_tree().create_timer(1.0).timeout
					reset()

# what happens when character collides with obstacle
func on_hit():
	# start hit animation
	$AnimatedSprite2D.animation = "hit"
	$AnimatedSprite2D.play()
	
	# emit hit signal
	hit.emit()
	
	# TODO: add invincibility frames - disabling collision will make the char 
	# fall through the floor

# what happens when the character can be hit again
func reset() -> void:
	# stop hit animation
	$AnimatedSprite2D.stop()
