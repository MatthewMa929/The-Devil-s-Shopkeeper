extends CharacterBody2D

#Player related things and their attempt at movement
@export var speed = 80

@onready var raycast = $RayCast2D

signal place_item(collided)

func get_input():
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_direction * speed

func _physics_process(delta):
	if Global.state == "MOVE":
		get_input()
		move_and_collide(delta * velocity)
		if Input.is_action_just_pressed("Continue") and raycast.is_colliding():
			var collided = raycast.get_collider()
			emit_signal("place_item", collided)
