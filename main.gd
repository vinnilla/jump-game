extends Node

@export var obstacle_scene: PackedScene
@export var cloud_scene: PackedScene
var score
var health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func new_game() -> void:
	print("Starting new game")
	score = 0
	health = 100
	$TheBoys.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.update_health(health)
	$HUD.show_message("Get Ready")


func game_over() -> void:
	$ScoreTimer.stop()
	$ObstacleTimer.stop()
	$HUD.show_game_over()
	$TheBoys.hide()


func _on_obstacle_timer_timeout() -> void:
	# create a new instance of obstacle
	var obstacle = obstacle_scene.instantiate()
	
	# set the start position
	obstacle.position = $ObstacleSpawn.position
	obstacle.visible = true
	
	# spawn the obstacle
	add_child(obstacle)


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout() -> void:
	$ObstacleTimer.start()
	$ScoreTimer.start()
	$CloudTimer.start()


func _on_the_boys_hit() -> void:
	health -= 20
	$HUD.update_health(health)
	if health <= 0:
		game_over()


func _on_cloud_timer_timeout() -> void:
	# delay an extra 0 - 3 seconds on top of the timer's 5 seconds
	await get_tree().create_timer(randi() % 4).timeout
	
	# create a new instance of cloud
	var cloud = cloud_scene.instantiate()
	
	# set the start position
	cloud.position = $CloudSpawn.position
	cloud.position.y += randi() % 150
	cloud.visible = true
	
	# spawn the cloud
	add_child(cloud)
