extends CharacterBody2D

@export var npc_res:Customer
@onready var sprite = $Sprite

enum {
	ENTER,
	WANDER,
	STOP
}

var state = ENTER

func _physics_process(delta):
	sprite.texture = npc_res.texture
	if state == ENTER:
		pass
	if state == WANDER:
		pass
