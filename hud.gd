extends CanvasLayer

signal start_game


#func _ready() -> void:
	#pass # Replace with function body.
#
#func _process(delta: float) -> void:
	#pass

# helper to display text on screen
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

# helper to update score text
func update_score(score):
	$ScoreLabel.text = str(score)

# helper to update health text
func update_health(health):
	$HPLabel.text = str(health)

# show game over message before resetting to start screen
func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	
	$Message.text = "Jump!"
	$Message.show()
	$StartButton.show()

# when START button is pressed
func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()

# when message timer expires
func _on_message_timer_timeout() -> void:
	$Message.hide()
