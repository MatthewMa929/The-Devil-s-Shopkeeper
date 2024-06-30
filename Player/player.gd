extends CharacterBody2D

#Player related things and their attempt at movement
@export var speed = 80

@onready var raycast = $RayCast2D
@onready var line = $Line2D
@onready var animation_player = $AnimationPlayer

signal place_item(collided)

func get_input():
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_direction * speed
	if Input.is_action_just_pressed("Left"):
		raycast.rotation = deg_to_rad(90)
	if Input.is_action_just_pressed("Right"):
		raycast.rotation = deg_to_rad(270)
	if Input.is_action_just_pressed("Up"):
		raycast.rotation = deg_to_rad(180)
	if Input.is_action_just_pressed("Down"):
		raycast.rotation = 0
	line.rotation = raycast.rotation

func inputs(delta):
	get_input()
	move_and_collide(delta * velocity)
	if Input.is_action_just_pressed("Continue") and raycast.is_colliding():
		var collided = raycast.get_collider()
		emit_signal("place_item", collided)
