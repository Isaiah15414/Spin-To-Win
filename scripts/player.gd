extends CharacterBody2D

@export var speed: float = 100.0

var in_range: bool = false
var current_target: Node2D
var targets: Array = []
@onready var target_indicator = $PickupRange/TargetIndicator

func _ready():
	target_indicator.hide()

func _process(delta: float) -> void:
	# Player control
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * speed
		$AnimationPlayer.play("walk")
	else:
		velocity = Vector2.ZERO
		$AnimationPlayer.stop()
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and in_range:
		print("hey " + find_closest_target(targets).name)

func find_closest_target(array) -> Node2D:
	if array.is_empty(): return self
	var closest: Node2D = array[0]
	var closest_distance: float
	var item_distance: float
	for item in array:
		closest_distance = closest.position.distance_to(self.position)
		item_distance = item.position.distance_to(self.position)
		if item_distance < closest_distance:
			closest = item
	return closest

func indicate_target(item) -> void:
	if item == self:
		target_indicator.hide()
	else:
		target_indicator.show()
	target_indicator.reparent(item)
	target_indicator.position = Vector2(0, -10) # 10 units above target

# Machine = body
# Laundry = area

func _on_pickup_range_body_entered(body: Node2D) -> void:
	in_range = true
	targets.append(body)
	indicate_target(find_closest_target(targets))

func _on_pickup_range_body_exited(body: Node2D) -> void:
	in_range = false
	targets.erase(body)
	indicate_target(find_closest_target(targets))

func _on_pickup_range_area_entered(area: Area2D) -> void:
	in_range = true
	targets.append(area)
	indicate_target(find_closest_target(targets))

func _on_pickup_range_area_exited(area: Area2D) -> void:
	in_range = false
	targets.erase(area)
	indicate_target(find_closest_target(targets))
