extends CharacterBody2D

@export var npc_res:Customer
@onready var sprite = $Sprite
@onready var rng = RandomNumberGenerator.new()

var rand_stand = null

enum {
	ENTER,
	WANDER,
	STOP
}

var state = ENTER

func _physics_process(delta):
	sprite.texture = npc_res.texture
	if state == ENTER:
		rand_stand = get_random_stand()
	if state == WANDER:
		pass

func get_random_stand():
	var stand_amt = Global.stand_arr.size()
	var stand_num = rng.randi_range(0, stand_amt)
	return stand_num
