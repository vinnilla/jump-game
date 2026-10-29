extends Node

@export var obstacle_scene: PackedScene
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


func _on_the_boys_hit() -> void:
	health -= 20
	$HUD.update_health(health)
	if health <= 0:
		game_over()
