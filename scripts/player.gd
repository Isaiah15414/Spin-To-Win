extends CharacterBody2D
class_name Player

var speed: float = 100.0

func _process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * speed
		$AnimationPlayer.play("walk")
	else:
		velocity = Vector2.ZERO
		$AnimationPlayer.stop()

	move_and_slide()
