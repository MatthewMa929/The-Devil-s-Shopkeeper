extends CharacterBody2D

#Player related things and their attempt at movement
@export var speed = 80

func get_input():
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_direction * speed

func _physics_process(delta):
	if Global.state == "MOVE":
		get_input()
		move_and_slide()
